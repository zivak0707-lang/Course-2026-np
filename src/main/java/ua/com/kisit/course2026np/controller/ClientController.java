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

    // --- 2. ACCOUNTS ---
    @GetMapping("/accounts")
    public String accounts(Model model) {
        User user = getDemoUser();
        addCommonData(model, user);
        return "client/accounts";
    }

    // --- 3. CARDS ---
    @GetMapping("/cards")
    public String cards(Model model) {
        User user = getDemoUser();
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
                          RedirectAttributes redirectAttributes) {
        try {
            String cleanCardNumber = cardNumber.replace(" ", "");
            String[] dateParts = expiryDate.split("/");
            int month = Integer.parseInt(dateParts[0]);
            int year = 2000 + Integer.parseInt(dateParts[1]);
            LocalDate expiryLocalDate = LocalDate.of(year, month, YearMonth.of(year, month).lengthOfMonth());

            User currentUser = getDemoUser();
            CreditCard newCard = CreditCard.builder()
                    .cardNumber(cleanCardNumber)
                    .cardholderName(cardholderName.toUpperCase())
                    .expiryDate(expiryLocalDate)
                    .cvv(cvv)
                    .user(currentUser)
                    .isActive(true)
                    .build();

            creditCardRepository.save(newCard);
            redirectAttributes.addFlashAttribute("successMessage", "Card added successfully!");
        } catch (Exception e) {
            log.error("Error adding card for user: {}", cardholderName, e);
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding card.");
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
            // 1. Перевірка на пусті поля
            if (firstName.trim().isEmpty() || lastName.trim().isEmpty() || email.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Всі поля повинні бути заповнені!");
                return "redirect:/dashboard/settings";
            }

            // 2. Валідація Імені та Прізвища
            // Дозволяємо: літери (всіх мов), пробіл, крапку, апостроф, дефіс.
            // Забороняємо: цифри та спецсимволи.
            String nameRegex = "^[\\p{L} .'-]+$";

            if (!firstName.matches(nameRegex) || !lastName.matches(nameRegex)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Ім'я та прізвище повинні містити лише літери!");
                return "redirect:/dashboard/settings";
            }

            // 3. Валідація Email
            String emailRegex = "^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,}$";

            if (!email.matches(emailRegex)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Невірний формат Email (наприклад: user@example.com)");
                return "redirect:/dashboard/settings";
            }

            User user = getDemoUser();

            user.setFirstName(firstName.trim());
            user.setLastName(lastName.trim());
            user.setEmail(email.trim());

            userRepository.save(user);

            redirectAttributes.addFlashAttribute("successMessage", "Профіль успішно оновлено!");
        } catch (Exception e) {
            log.error("Помилка при оновленні профілю користувача [Email: {}]", email, e);
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