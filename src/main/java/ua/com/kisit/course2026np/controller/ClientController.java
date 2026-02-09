package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.Payment;
import ua.com.kisit.course2026np.entity.CreditCard;
import ua.com.kisit.course2026np.repository.UserRepository;
import ua.com.kisit.course2026np.repository.AccountRepository;
import ua.com.kisit.course2026np.repository.PaymentRepository;
import ua.com.kisit.course2026np.repository.CreditCardRepository;

import java.math.BigDecimal;
import java.util.List;

/**
 * Контролер для клієнтського кабінету
 */
@Controller
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class ClientController {

    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final PaymentRepository paymentRepository;
    private final CreditCardRepository creditCardRepository;

    /**
     * Головна сторінка дашборду
     */
    @GetMapping
    public String dashboard(Model model) {
        // TODO: Отримати поточного користувача з Security Context
        // Поки що використовуємо першого користувача як приклад
        User user = userRepository.findAll().stream()
                .findFirst()
                .orElse(createDemoUser());

        // Розрахунок статистики
        List<Account> accounts = accountRepository.findAll(); // TODO: фільтрувати по user
        BigDecimal totalBalance = accounts.stream()
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long activeCards = creditCardRepository.count(); // TODO: фільтрувати по user
        
        List<Payment> allPayments = paymentRepository.findAll(); // TODO: фільтрувати по user
        long pendingCount = allPayments.stream()
                .filter(p -> p.getStatus() == ua.com.kisit.course2026np.entity.PaymentStatus.PENDING)
                .count();

        BigDecimal monthlySpending = allPayments.stream()
                .filter(p -> p.getAmount().compareTo(BigDecimal.ZERO) < 0)
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .abs();

        // Останні 5 транзакцій
        List<Payment> recentTransactions = allPayments.stream()
                .limit(5)
                .toList();

        // Передача даних в шаблон
        model.addAttribute("user", user);
        model.addAttribute("totalBalance", formatCurrency(totalBalance));
        model.addAttribute("activeCards", activeCards);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("monthlySpending", formatCurrency(monthlySpending));
        model.addAttribute("recentTransactions", recentTransactions);

        return "client/dashboard";
    }

    /**
     * Сторінка рахунків
     */
    @GetMapping("/accounts")
    public String accounts(Model model) {
        List<Account> accounts = accountRepository.findAll();
        model.addAttribute("accounts", accounts);
        return "client/accounts";
    }

    /**
     * Сторінка карток
     */
    @GetMapping("/cards")
    public String cards(Model model) {
        List<CreditCard> cards = creditCardRepository.findAll();
        model.addAttribute("cards", cards);
        return "client/cards";
    }

    /**
     * Сторінка платежів
     */
    @GetMapping("/payment")
    public String payment(Model model) {
        List<Account> accounts = accountRepository.findAll();
        model.addAttribute("accounts", accounts);
        return "client/payment";
    }

    /**
     * Сторінка історії транзакцій
     */
    @GetMapping("/transactions")
    public String transactions(Model model) {
        List<Payment> payments = paymentRepository.findAll();
        model.addAttribute("payments", payments);
        return "client/transactions";
    }

    /**
     * Сторінка налаштувань
     */
    @GetMapping("/settings")
    public String settings(Model model) {
        User user = userRepository.findAll().stream()
                .findFirst()
                .orElse(createDemoUser());
        model.addAttribute("user", user);
        return "client/settings";
    }

    // Допоміжні методи

    private String formatCurrency(BigDecimal amount) {
        return String.format("$%,.2f", amount);
    }

    private User createDemoUser() {
        User user = new User();
        user.setFirstName("John");
        user.setLastName("Doe");
        user.setEmail("john.doe@example.com");
        user.setRole(ua.com.kisit.course2026np.entity.UserRole.CLIENT);
        user.setIsActive(true);
        return user;
    }
}
