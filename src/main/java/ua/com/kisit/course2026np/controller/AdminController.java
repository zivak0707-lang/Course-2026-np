package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    private final AccountRepository accountRepository;

    @GetMapping("/login")
    public String loginPage() {
        return "admin/login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email, @RequestParam String password, Model model) {
        Optional<User> adminOpt = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim()) && u.getRole() == UserRole.ADMIN)
                .findFirst();

        if (!adminOpt.isPresent()) {
            model.addAttribute("error", "Невірний email або пароль");
            return "admin/login";
        }

        User admin = adminOpt.get();

        if (!admin.getPassword().equals(password.trim())) {
            model.addAttribute("error", "Невірний email або пароль");
            return "admin/login";
        }

        return "redirect:/admin";
    }

    @GetMapping({"", "/"})
    public String dashboard(Model model) {
        long totalUsers = userRepository.count();
        long totalTransactions = paymentRepository.count();
        long pendingApprovals = paymentRepository.findAll().stream()
                .filter(p -> p.getStatus() == PaymentStatus.PENDING)
                .count();

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalTransactions", totalTransactions);
        model.addAttribute("pendingApprovals", pendingApprovals);
        model.addAttribute("systemHealth", 99.8);

        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String users(Model model) {
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    @GetMapping("/transactions")
    public String transactions(Model model) {
        List<Payment> payments = paymentRepository.findAll();
        model.addAttribute("payments", payments);
        return "admin/transactions";
    }
}