package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Controller
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class ClientController {

    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final PaymentRepository paymentRepository;
    private final CreditCardRepository creditCardRepository;

    @GetMapping({"", "/"})
    public String dashboard(Model model) {
        // Отримуємо поточного юзера (першого CLIENT у БД)
        User user = getDemoUser();

        // Отримуємо ТІЛЬКИ картки цього юзера
        List<CreditCard> userCards = creditCardRepository.findByUser(user);

        // Рахуємо активні картки цього юзера
        long activeCards = userCards.stream()
                .filter(c -> Boolean.TRUE.equals(c.getIsActive()))
                .count();

        // Отримуємо всі рахунки, прив'язані до карток цього юзера
        List<Account> userAccounts = userCards.stream()
                .flatMap(card -> accountRepository.findByCreditCardId(card.getId()).stream())
                .toList();

        // Загальний баланс тільки цього юзера
        BigDecimal totalBalance = userAccounts.stream()
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Платежі тільки для рахунків цього юзера
        List<Payment> allUserPayments = userAccounts.stream()
                .flatMap(account -> paymentRepository.findByAccount(account).stream())
                .toList();

        // Кількість платежів зі статусом PENDING
        long pendingCount = allUserPayments.stream()
                .filter(p -> p.getStatus() == PaymentStatus.PENDING)
                .count();

        // Місячні витрати (тільки платежі типу PAYMENT)
        BigDecimal monthlySpending = allUserPayments.stream()
                .filter(p -> p.getType() == PaymentType.PAYMENT)
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Останні 5 транзакцій (посортовані за датою, найновіші першими)
        List<Payment> recentTransactions = allUserPayments.stream()
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
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

    @GetMapping("/accounts")
    public String accounts(Model model) {
        User user = getDemoUser();
        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> accounts = userCards.stream()
                .flatMap(card -> accountRepository.findByCreditCardId(card.getId()).stream())
                .toList();
        model.addAttribute("accounts", accounts);
        model.addAttribute("user", user);
        return "client/accounts";
    }

    @GetMapping("/cards")
    public String cards(Model model) {
        User user = getDemoUser();
        List<CreditCard> cards = creditCardRepository.findByUser(user);
        model.addAttribute("cards", cards);
        model.addAttribute("user", user);
        return "client/cards";
    }

    /**
     * Обробка форми додавання картки
     */
    @PostMapping("/cards/add")
    public String addCard(@RequestParam String cardNumber,
                          @RequestParam String cardholderName,
                          @RequestParam String expiryDate,
                          @RequestParam String cvv,
                          Model model) {
        try {
            String cleanCardNumber = cardNumber.replace(" ", "");

            String[] dateParts = expiryDate.split("/");
            int month = Integer.parseInt(dateParts[0]);
            int year = 2000 + Integer.parseInt(dateParts[1]);

            LocalDate expiryLocalDate = LocalDate.of(year, month,
                    YearMonth.of(year, month).lengthOfMonth());

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

            return "redirect:/dashboard/cards?success=true";

        } catch (Exception e) {
            return "redirect:/dashboard/cards?error=true";
        }
    }

    @GetMapping("/payment")
    public String payment(Model model) {
        User user = getDemoUser();
        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> accounts = userCards.stream()
                .flatMap(card -> accountRepository.findByCreditCardId(card.getId()).stream())
                .toList();
        model.addAttribute("accounts", accounts);
        model.addAttribute("user", user);
        return "client/payment";
    }

    @GetMapping("/transactions")
    public String transactions(Model model) {
        User user = getDemoUser();
        List<CreditCard> userCards = creditCardRepository.findByUser(user);
        List<Account> userAccounts = userCards.stream()
                .flatMap(card -> accountRepository.findByCreditCardId(card.getId()).stream())
                .toList();
        List<Payment> payments = userAccounts.stream()
                .flatMap(account -> paymentRepository.findByAccountOrderByCreatedAtDesc(account).stream())
                .toList();
        model.addAttribute("payments", payments);
        model.addAttribute("user", user);
        return "client/transactions";
    }

    @GetMapping("/settings")
    public String settings(Model model) {
        User user = getDemoUser();
        model.addAttribute("user", user);
        return "client/settings";
    }

    // ---- Helpers ----

    private String formatCurrency(BigDecimal amount) {
        return String.format("$%,.2f", amount);
    }

    /**
     * Отримати першого CLIENT-юзера з БД.
     * В майбутньому замінити на Spring Security: Principal / @AuthenticationPrincipal
     */
    private User getDemoUser() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == UserRole.CLIENT)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Жодного клієнта не знайдено в БД"));
    }
}