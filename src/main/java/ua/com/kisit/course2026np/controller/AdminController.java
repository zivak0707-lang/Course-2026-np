package ua.com.kisit.course2026np.controller;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.Payment;
import ua.com.kisit.course2026np.repository.UserRepository;
import ua.com.kisit.course2026np.repository.PaymentRepository;
import ua.com.kisit.course2026np.repository.AccountRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Контролер для адміністративної панелі
 */
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    @Getter
    private final AccountRepository accountRepository;

    /**
     * Головна сторінка адмін панелі
     */
    @GetMapping
    public String dashboard(Model model) {
        // Статистика
        long totalUsers = userRepository.count();
        
        List<Payment> allPayments = paymentRepository.findAll();
        long transactionsToday = allPayments.stream()
                .filter(p -> p.getCreatedAt().toLocalDate().equals(LocalDateTime.now().toLocalDate()))
                .count();
        
        long pendingApprovals = allPayments.stream()
                .filter(p -> p.getStatus() == ua.com.kisit.course2026np.entity.PaymentStatus.PENDING)
                .count();
        
        double systemHealth = 99.8; // TODO: Implement real health check
        
        BigDecimal transactionVolume = allPayments.stream()
                .filter(p -> p.getCreatedAt().toLocalDate().equals(LocalDateTime.now().toLocalDate()))
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .abs();
        
        // Останні транзакції
        List<Payment> recentTransactions = allPayments.stream()
                .sorted((p1, p2) -> p2.getCreatedAt().compareTo(p1.getCreatedAt()))
                .limit(10)
                .collect(Collectors.toList());
        
        // Нові користувачі
        List<User> recentUsers = userRepository.findAll().stream()
                .sorted((u1, u2) -> u2.getRegisteredAt().compareTo(u1.getRegisteredAt()))
                .limit(5)
                .collect(Collectors.toList());
        
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("transactionsToday", transactionsToday);
        model.addAttribute("pendingApprovals", pendingApprovals);
        model.addAttribute("systemHealth", systemHealth);
        model.addAttribute("transactionVolume", transactionVolume);
        model.addAttribute("recentTransactions", recentTransactions);
        model.addAttribute("recentUsers", recentUsers);
        
        return "admin/dashboard";
    }

    /**
     * Сторінка управління користувачами
     */
    @GetMapping("/users")
    public String users(Model model) {
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    /**
     * Сторінка всіх транзакцій
     */
    @GetMapping("/transactions")
    public String transactions(Model model) {
        List<Payment> payments = paymentRepository.findAll();
        
        // Розрахунок обсягу за сьогодні
        BigDecimal todayVolume = payments.stream()
                .filter(p -> p.getCreatedAt().toLocalDate().equals(LocalDateTime.now().toLocalDate()))
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .abs();
        
        model.addAttribute("payments", payments);
        model.addAttribute("todayVolume", todayVolume);
        
        return "admin/transactions";
    }

    /**
     * Сторінка звітів
     */
    @GetMapping("/reports")
    public String reports(Model model) {
        // TODO: Implement reports functionality
        return "admin/dashboard"; // Поки що редирект на дашборд
    }

    /**
     * Сторінка налаштувань адміна
     */
    @GetMapping("/settings")
    public String settings(Model model) {
        // TODO: Implement admin settings
        return "client/settings"; // Поки що використовуємо клієнтські налаштування
    }

}
