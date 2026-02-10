package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;

import java.math.BigDecimal;
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
        User user = getDemoUser();

        List<Account> accounts = accountRepository.findAll();
        BigDecimal totalBalance = accounts.stream()
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long activeCards = creditCardRepository.count();

        List<Payment> allPayments = paymentRepository.findAll();
        long pendingCount = allPayments.stream()
                .filter(p -> p.getStatus() == PaymentStatus.PENDING)
                .count();

        BigDecimal monthlySpending = allPayments.stream()
                .filter(p -> p.getAmount().compareTo(BigDecimal.ZERO) < 0)
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .abs();

        List<Payment> recentTransactions = allPayments.stream()
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
        List<Account> accounts = accountRepository.findAll();
        model.addAttribute("accounts", accounts);
        return "client/accounts";
    }

    @GetMapping("/cards")
    public String cards(Model model) {
        List<CreditCard> cards = creditCardRepository.findAll();
        model.addAttribute("cards", cards);
        return "client/cards";
    }

    @GetMapping("/payment")
    public String payment(Model model) {
        List<Account> accounts = accountRepository.findAll();
        model.addAttribute("accounts", accounts);
        return "client/payment";
    }

    @GetMapping("/transactions")
    public String transactions(Model model) {
        List<Payment> payments = paymentRepository.findAll();
        model.addAttribute("payments", payments);
        return "client/transactions";
    }

    @GetMapping("/settings")
    public String settings(Model model) {
        User user = getDemoUser();
        model.addAttribute("user", user);
        return "client/settings";
    }

    private String formatCurrency(BigDecimal amount) {
        return String.format("$%,.2f", amount);
    }

    private User getDemoUser() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == UserRole.CLIENT)
                .findFirst()
                .orElseGet(() -> {
                    User demo = new User();
                    demo.setFirstName("Іван");
                    demo.setLastName("Петренко");
                    demo.setEmail("user@example.com");
                    demo.setRole(UserRole.CLIENT);
                    return demo;
                });
    }
}