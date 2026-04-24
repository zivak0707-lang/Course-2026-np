package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;
import ua.com.kisit.course2026np.service.PaymentService;
import ua.com.kisit.course2026np.service.AccountService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class ClientController {

    private static final Logger securityLog = LoggerFactory.getLogger("SECURITY");

    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final PaymentRepository paymentRepository;
    private final CreditCardRepository creditCardRepository;
    private final PaymentService paymentService;
    private final AccountService accountService;
    private final org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    // ─────────────────────────────────────────────────────────────────
    //  HELPER: повертає поточного юзера або кидає редірект на /blocked
    //  Перевіряє isActive з БД при КОЖНОМУ запиті — щоб блокування
    //  адміном набирало чинності одразу, без перезапуску сесії.
    // ─────────────────────────────────────────────────────────────────
    private User getCurrentUser(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            securityLog.warn("[UNAUTHENTICATED_ACCESS] Access attempt without session");
            throw new UserNotAuthenticatedException();
        }
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            session.invalidate();
            securityLog.warn("[UNAUTHENTICATED_ACCESS] Session userId={} not found in DB — session invalidated", userId);
            throw new UserNotAuthenticatedException();
        }
        if (!Boolean.TRUE.equals(user.getIsActive())) {
            session.invalidate();
            securityLog.warn("[BLOCKED_USER_ACCESS] Blocked user attempted access: email={} id={}", user.getEmail(), user.getId());
            throw new UserBlockedException();
        }
        return user;
    }

    public static class UserNotAuthenticatedException extends RuntimeException {
        public UserNotAuthenticatedException() {
            super("User is not authenticated");
        }
    }

    public static class UserBlockedException extends RuntimeException {
        public UserBlockedException() {
            super("User account is blocked");
        }
    }

    // ─────────────────────────────────────────────────────────────────
    //  1. DASHBOARD
    // ─────────────────────────────────────────────────────────────────
    @GetMapping({"", "/"})
    public String dashboard(HttpSession session, Model model) {
        User user = getCurrentUser(session);

        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> userAccounts = getUserAccounts(userCards);

        long activeCards = userCards.stream().filter(c -> Boolean.TRUE.equals(c.getIsActive())).count();
        BigDecimal totalBalance = userAccounts.stream().map(Account::getBalance).reduce(BigDecimal.ZERO, BigDecimal::add);

        List<Payment> allUserPayments = userAccounts.stream()
                .flatMap(account -> paymentRepository.findByAccount(account).stream())
                .toList();

        long pendingCount = allUserPayments.stream().filter(p -> p.getStatus() == PaymentStatus.PENDING).count();

        YearMonth currentMonth = YearMonth.now();
        BigDecimal monthlySpending = allUserPayments.stream()
                .filter(p -> p.getType() == PaymentType.PAYMENT)
                .filter(p -> p.getCreatedAt() != null && YearMonth.from(p.getCreatedAt()).equals(currentMonth))
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<Payment> recentTransactions = allUserPayments.stream()
                .sorted((a, b) -> {
                    if (b.getCreatedAt() == null || a.getCreatedAt() == null) return 0;
                    return b.getCreatedAt().compareTo(a.getCreatedAt());
                })
                .limit(5)
                .toList();

        model.addAttribute("user", user);
        model.addAttribute("totalBalance", formatCurrency(totalBalance));
        model.addAttribute("activeCards", activeCards);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("monthlySpending", formatCurrency(monthlySpending));
        model.addAttribute("recentTransactions", recentTransactions);

        return "client/dashboard";
    }

    // ─────────────────────────────────────────────────────────────────
    //  2. ACCOUNTS
    // ─────────────────────────────────────────────────────────────────
    @GetMapping("/accounts")
    public String accounts(HttpSession session, Model model) {
        User user = getCurrentUser(session);

        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> accounts = getUserAccounts(userCards);

        BigDecimal totalBalance = accounts.stream()
                .filter(Account::isActive)
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long activeCount = accounts.stream().filter(Account::isActive).count();
        long blockedCount = accounts.stream().filter(a -> a.getStatus() == AccountStatus.BLOCKED).count();

        BigDecimal maxBalance = accounts.stream()
                .map(Account::getBalance)
                .max(BigDecimal::compareTo)
                .orElse(BigDecimal.ONE);

        model.addAttribute("user", user);
        model.addAttribute("accounts", accounts);
        model.addAttribute("totalBalance", formatCurrency(totalBalance));
        model.addAttribute("activeCount", activeCount);
        model.addAttribute("blockedCount", blockedCount);
        model.addAttribute("maxBalance", maxBalance);

        return "client/accounts";
    }

    // ─────────────────────────────────────────────────────────────────
    //  3. CARDS
    // ─────────────────────────────────────────────────────────────────
    @GetMapping("/cards")
    public String cards(HttpSession session, Model model) {
        User user = getCurrentUser(session);
        List<CreditCard> cards = creditCardRepository.findByUser(user);
        model.addAttribute("cards", cards);
        model.addAttribute("user", user);
        return "client/cards";
    }

    @PostMapping("/cards/add")
    public String addCard(@RequestParam String cardNumber,
                          @RequestParam String cardholderName,
                          @RequestParam String expiryDate,
                          @RequestParam String cvv,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        User currentUser = null;
        try {
            String cleanCardNumber = cardNumber.replace(" ", "").trim();
            if (!cleanCardNumber.matches("^\\d{16}$")) {
                throw new IllegalArgumentException("Номер картки має містити 16 цифр");
            }
            if (!cvv.matches("^\\d{3}$")) {
                throw new IllegalArgumentException("CVV має містити 3 цифри");
            }
            if (!expiryDate.matches("^(0[1-9]|1[0-2])/[0-9]{2}$")) {
                throw new IllegalArgumentException("Невірний формат дати. Використовуйте MM/YY");
            }

            String[] dateParts = expiryDate.split("/");
            int month = Integer.parseInt(dateParts[0]);
            int yearShort = Integer.parseInt(dateParts[1]);
            int yearFull = 2000 + yearShort;
            LocalDate expiryLocalDate = LocalDate.of(yearFull, month, YearMonth.of(yearFull, month).lengthOfMonth());

            if (expiryLocalDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Термін дії картки вже закінчився!");
            }

            currentUser = getCurrentUser(session);
            if (creditCardRepository.existsByCardNumber(cleanCardNumber)) {
                throw new IllegalArgumentException("Картка з таким номером вже існує");
            }

            CreditCard newCard = CreditCard.builder()
                    .cardNumber(cleanCardNumber)
                    .cardholderName(cardholderName.toUpperCase().trim())
                    .expiryDate(expiryLocalDate)
                    .cvv(cvv)
                    .user(currentUser)
                    .isActive(true)
                    .build();

            creditCardRepository.save(newCard);
            log.info("[CARD_ADD_OK] User id={} added card ending in ****{}",
                    currentUser.getId(), cleanCardNumber.substring(cleanCardNumber.length() - 4));
            redirectAttributes.addFlashAttribute("successMessage", "Картку успішно додано!");

        } catch (IllegalArgumentException e) {
            Long uid = currentUser != null ? currentUser.getId() : null;
            log.warn("[CARD_ADD_FAIL] userId={} reason={}", uid, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            Long uid = currentUser != null ? currentUser.getId() : null;
            log.error("[CARD_ADD_ERROR] userId={} error={}", uid, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Сталася технічна помилка при додаванні картки.");
        }
        return "redirect:/dashboard/cards";
    }

    @PostMapping("/cards/delete/{id}")
    public String deleteCard(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            User user = getCurrentUser(session);
            CreditCard card = creditCardRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Картку не знайдено"));
            if (!card.getUser().getId().equals(user.getId())) {
                securityLog.warn("[ACCESS_DENIED_403] User id={} attempted to delete card id={} belonging to user id={}",
                        user.getId(), id, card.getUser().getId());
                throw new IllegalStateException("Доступ заборонено");
            }
            String maskedNum = maskCard(card.getCardNumber());
            creditCardRepository.delete(card);
            log.info("[CARD_DELETE_OK] User id={} deleted card id={} ({})", user.getId(), id, maskedNum);
            redirectAttributes.addFlashAttribute("successMessage", "Картку успішно видалено.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            log.error("[CARD_DELETE_ERROR] Card id={} error={}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Не вдалося видалити картку.");
        }
        return "redirect:/dashboard/cards";
    }

    // ─────────────────────────────────────────────────────────────────
    //  4. PAYMENT
    // ─────────────────────────────────────────────────────────────────
    @GetMapping("/payment")
    public String payment(HttpSession session, Model model) {
        User user = getCurrentUser(session);

        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> userAccounts = getUserAccounts(userCards);

        List<Payment> recentPayments = userAccounts.stream()
                .flatMap(account -> paymentRepository.findByAccountOrderByCreatedAtDesc(account).stream())
                .filter(p -> p.getRecipientAccount() != null && !p.getRecipientAccount().isBlank())
                .limit(5)
                .toList();

        model.addAttribute("user", user);
        model.addAttribute("accounts", userAccounts);
        model.addAttribute("recentPayments", recentPayments);

        return "client/payment";
    }

    @PostMapping("/payment/submit")
    public String submitPayment(
            @RequestParam Long accountId,
            @RequestParam(required = false) String recipientAccount,
            @RequestParam BigDecimal amount,
            @RequestParam String type,
            @RequestParam(required = false) String description,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        try {
            User user = getCurrentUser(session);

            List<CreditCard> userCards = creditCardRepository.findByUser(user);
            List<Account> userAccounts = getUserAccounts(userCards);

            Account account = userAccounts.stream()
                    .filter(a -> a.getId().equals(accountId))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено або не належить вам"));

            if (!account.isActive()) {
                throw new IllegalStateException("Рахунок заблоковано");
            }

            Payment payment = Payment.builder()
                    .amount(amount)
                    .type(PaymentType.valueOf(type))
                    .description(description)
                    .build();

            Payment result;

            switch (type) {
                case "REPLENISHMENT" -> result = paymentService.executeReplenishment(accountId, payment);
                case "TRANSFER" -> {
                    if (recipientAccount == null || recipientAccount.isBlank()) {
                        throw new IllegalArgumentException("Вкажіть рахунок отримувача для переказу");
                    }
                    result = paymentService.executeTransfer(accountId, recipientAccount, payment);
                }
                default -> {
                    if (recipientAccount == null || recipientAccount.isBlank()) {
                        throw new IllegalArgumentException("Вкажіть рахунок отримувача для платежу");
                    }
                    payment.setRecipientAccount(recipientAccount);
                    result = paymentService.executePayment(accountId, payment);
                }
            }

            if (result.isCompleted()) {
                log.info("[PAYMENT_SUBMIT_OK] User id={} completed {} amount={} accountId={} txId={}",
                        user.getId(), type, amount, accountId, result.getTransactionId());
                redirectAttributes.addFlashAttribute("successMessage",
                        "Успішно! ID транзакції: " + result.getTransactionId());
            } else {
                log.warn("[PAYMENT_SUBMIT_FAIL] User id={} {} amount={} accountId={} reason={}",
                        user.getId(), type, amount, accountId, result.getErrorMessage());
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Операція не вдалась: " + result.getErrorMessage());
            }

        } catch (IllegalArgumentException | IllegalStateException e) {
            log.warn("[PAYMENT_SUBMIT_REJECTED] accountId={} type={} amount={} reason={}", accountId, type, amount, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            log.error("[PAYMENT_SUBMIT_ERROR] accountId={} type={} amount={} error={}", accountId, type, amount, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Технічна помилка. Спробуйте пізніше.");
        }

        return "redirect:/dashboard/payment";
    }

    // ─────────────────────────────────────────────────────────────────
    //  5. SETTINGS
    // ─────────────────────────────────────────────────────────────────
    @GetMapping("/settings")
    public String settings(HttpSession session, Model model) {
        model.addAttribute("user", getCurrentUser(session));
        return "client/settings";
    }

    @PostMapping("/settings/update-profile")
    public String updateProfile(@RequestParam String firstName,
                                @RequestParam String lastName,
                                @RequestParam String email,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            if (firstName.trim().isEmpty() || lastName.trim().isEmpty() || email.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Всі поля повинні бути заповнені!");
                return "redirect:/dashboard/settings";
            }
            String nameRegex = "^[\\p{L} .'-]+$";
            if (!firstName.matches(nameRegex) || !lastName.matches(nameRegex)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Ім'я та прізвище повинні містити лише літери!");
                return "redirect:/dashboard/settings";
            }
            String emailRegex = "^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,}$";
            if (!email.matches(emailRegex)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Невірний формат Email");
                return "redirect:/dashboard/settings";
            }

            User user = getCurrentUser(session);
            user.setFirstName(firstName.trim());
            user.setLastName(lastName.trim());
            user.setEmail(email.trim());
            userRepository.save(user);
            log.info("[PROFILE_UPDATE_OK] User id={} updated profile: email={}", user.getId(), email.trim());
            redirectAttributes.addFlashAttribute("successMessage", "Профіль успішно оновлено!");
        } catch (Exception e) {
            log.error("[PROFILE_UPDATE_ERROR] error={}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Помилка при оновленні профілю.");
        }
        return "redirect:/dashboard/settings";
    }

    @PostMapping("/settings/update-password")
    public String updatePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = getCurrentUser(session);
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            log.warn("[PASSWORD_CHANGE_FAIL] User id={} provided wrong current password", user.getId());
            redirectAttributes.addFlashAttribute("errorMessage", "Невірний поточний пароль!");
            return "redirect:/dashboard/settings";
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        log.info("[PASSWORD_CHANGE_OK] User id={} changed password", user.getId());
        redirectAttributes.addFlashAttribute("successMessage", "Пароль успішно змінено!");
        return "redirect:/dashboard/settings";
    }

    // ─────────────────────────────────────────────────────────────────
    //  6. LOGOUT
    // ─────────────────────────────────────────────────────────────────
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        securityLog.info("[LOGOUT] Client user logged out: userId={}", userId);
        session.invalidate();
        return "redirect:/";
    }

    // ─────────────────────────────────────────────────────────────────
    //  HELPERS
    // ─────────────────────────────────────────────────────────────────
    private List<Account> getUserAccounts(List<CreditCard> cards) {
        return cards.stream()
                .flatMap(card -> accountRepository.findByCreditCardId(card.getId()).stream())
                .toList();
    }

    private String formatCurrency(BigDecimal amount) {
        return String.format("$%,.2f", amount);
    }

    private String maskCard(String cardNumber) {
        if (cardNumber == null || cardNumber.length() < 4) return "****";
        return "****" + cardNumber.substring(cardNumber.length() - 4);
    }
}
