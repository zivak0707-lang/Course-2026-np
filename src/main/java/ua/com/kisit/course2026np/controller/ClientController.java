package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class ClientController {

    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final PaymentRepository paymentRepository;
    private final CreditCardRepository creditCardRepository;

    // --- 1. DASHBOARD ---
    @GetMapping({"", "/"})
    public String dashboard(Model model) {
        User user = getDemoUser();

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

    // --- 2. ACCOUNTS (НОВИЙ ЕНДПОІНТ З ПОВНОЮ СТАТИСТИКОЮ) ---
    @GetMapping("/accounts")
    public String accounts(Model model) {
        User user = getDemoUser();

        // Отримуємо всі картки користувача
        List<CreditCard> userCards = creditCardRepository.findByUser(user);

        // Отримуємо всі рахунки користувача через картки
        List<Account> accounts = getUserAccounts(userCards);

        // Розраховуємо статистику
        BigDecimal totalBalance = accounts.stream()
                .filter(Account::isActive)
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long activeCount = accounts.stream()
                .filter(Account::isActive)
                .count();

        long blockedCount = accounts.stream()
                .filter(a -> a.getStatus() == AccountStatus.BLOCKED)
                .count();

        // Знаходимо максимальний баланс для прогрес-барів
        BigDecimal maxBalance = accounts.stream()
                .map(Account::getBalance)
                .max(BigDecimal::compareTo)
                .orElse(BigDecimal.ONE);

        // Додаємо дані в модель
        model.addAttribute("user", user);
        model.addAttribute("accounts", accounts);
        model.addAttribute("totalBalance", formatCurrency(totalBalance));
        model.addAttribute("activeCount", activeCount);
        model.addAttribute("blockedCount", blockedCount);
        model.addAttribute("maxBalance", maxBalance);

        return "client/accounts";
    }

    // --- 3. CARDS (Оновлено для підтримки списку) ---
    @GetMapping("/cards")
    public String cards(Model model) {
        User user = getDemoUser();
        List<CreditCard> cards = creditCardRepository.findByUser(user);
        model.addAttribute("cards", cards);
        model.addAttribute("user", user);
        return "client/cards";
    }

    // --- 3.1 ADD CARD (Правки для коректної дати та безпеки) ---
    @PostMapping("/cards/add")
    public String addCard(@RequestParam String cardNumber,
                          @RequestParam String cardholderName,
                          @RequestParam String expiryDate,
                          @RequestParam String cvv,
                          RedirectAttributes redirectAttributes) {
        try {
            // Очищення номера від пробілів
            String cleanCardNumber = cardNumber.replace(" ", "").trim();

            // ✅ Валідація номера картки (має бути 16 цифр)
            if (!cleanCardNumber.matches("^\\d{16}$")) {
                throw new IllegalArgumentException("Номер картки має містити 16 цифр");
            }

            // ✅ Валідація CVV (має бути 3 цифри)
            if (!cvv.matches("^\\d{3}$")) {
                throw new IllegalArgumentException("CVV має містити 3 цифри");
            }

            // Перевірка формату дати MM/YY
            if (!expiryDate.matches("^(0[1-9]|1[0-2])/[0-9]{2}$")) {
                throw new IllegalArgumentException("Невірний формат дати. Використовуйте MM/YY");
            }

            String[] dateParts = expiryDate.split("/");
            int month = Integer.parseInt(dateParts[0]);
            int yearShort = Integer.parseInt(dateParts[1]);
            int yearFull = 2000 + yearShort;

            // Встановлюємо дату на останній день місяця
            LocalDate expiryLocalDate = LocalDate.of(yearFull, month, YearMonth.of(yearFull, month).lengthOfMonth());

            if (expiryLocalDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Термін дії картки вже закінчився!");
            }

            User currentUser = getDemoUser();

            // ✅ Перевірка на дублікат номера картки
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
            redirectAttributes.addFlashAttribute("successMessage", "Картку успішно додано!");

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            log.error("Помилка при додаванні картки для: {}", cardholderName, e);
            redirectAttributes.addFlashAttribute("errorMessage", "Сталася технічна помилка при додаванні картки.");
        }
        return "redirect:/dashboard/cards";
    }

    // --- 3.2 DELETE CARD (Нова функція, була в Lovable) ---
    @PostMapping("/cards/delete/{id}")
    public String deleteCard(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            User user = getDemoUser();
            CreditCard card = creditCardRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Картку не знайдено"));

            // Перевірка, що картка належить поточному користувачу
            if (!card.getUser().getId().equals(user.getId())) {
                throw new IllegalStateException("Доступ заборонено");
            }

            creditCardRepository.delete(card);
            redirectAttributes.addFlashAttribute("successMessage", "Картку успішно видалено.");
        } catch (Exception e) {
            log.error("Error deleting card ID: {}", id, e);
            redirectAttributes.addFlashAttribute("errorMessage", "Не вдалося видалити картку.");
        }
        return "redirect:/dashboard/cards";
    }

    // --- 4. PAYMENT ---
    @GetMapping("/payment")
    public String payment(Model model) {
        User user = getDemoUser();
        addCommonData(model, user);
        return "client/payment";
    }

    // --- 5. TRANSACTIONS ---
    @GetMapping("/transactions")
    public String transactions(Model model) {
        User user = getDemoUser();
        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> userAccounts = getUserAccounts(userCards);

        List<Payment> payments = userAccounts.stream()
                .flatMap(account -> paymentRepository.findByAccountOrderByCreatedAtDesc(account).stream())
                .toList();

        model.addAttribute("payments", payments);
        model.addAttribute("user", user);
        return "client/transactions";
    }

    // --- 6. SETTINGS ---
    @GetMapping("/settings")
    public String settings(Model model) {
        model.addAttribute("user", getDemoUser());
        return "client/settings";
    }

    @PostMapping("/settings/update-profile")
    public String updateProfile(@RequestParam String firstName,
                                @RequestParam String lastName,
                                @RequestParam String email,
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

            User user = getDemoUser();
            user.setFirstName(firstName.trim());
            user.setLastName(lastName.trim());
            user.setEmail(email.trim());
            userRepository.save(user);

            redirectAttributes.addFlashAttribute("successMessage", "Профіль успішно оновлено!");
        } catch (Exception e) {
            log.error("Помилка при оновленні профілю", e);
            redirectAttributes.addFlashAttribute("errorMessage", "Помилка при оновленні профілю.");
        }
        return "redirect:/dashboard/settings";
    }

    @PostMapping("/settings/update-password")
    public String updatePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 RedirectAttributes redirectAttributes) {
        User user = getDemoUser();
        if (!user.getPassword().equals(currentPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Incorrect current password!");
            return "redirect:/dashboard/settings";
        }
        user.setPassword(newPassword);
        userRepository.save(user);
        redirectAttributes.addFlashAttribute("successMessage", "Password changed successfully!");
        return "redirect:/dashboard/settings";
    }

    // --- 7. LOGOUT ---
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // --- HELPERS ---
    private List<Account> getUserAccounts(List<CreditCard> cards) {
        return cards.stream()
                .flatMap(card -> accountRepository.findByCreditCardId(card.getId()).stream())
                .toList();
    }

    private void addCommonData(Model model, User user) {
        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> accounts = getUserAccounts(userCards);
        model.addAttribute("accounts", accounts);
        model.addAttribute("user", user);
    }

    private String formatCurrency(BigDecimal amount) {
        return String.format("$%,.2f", amount);
    }

    private User getDemoUser() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == UserRole.CLIENT)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("User not found"));
    }
}