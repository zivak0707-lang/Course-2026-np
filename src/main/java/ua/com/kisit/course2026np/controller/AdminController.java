package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    // Видалили accountRepository, бо він не використовувався

    // --- 1. LOGIN & LOGOUT ---

    @GetMapping("/login")
    public String loginPage() {
        return "admin/login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email,
                              @RequestParam String password,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {

        Optional<User> adminOpt = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim()) && u.getRole() == UserRole.ADMIN)
                .findFirst();

        if (adminOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Користувача не знайдено або немає прав адміна");
            return "redirect:/admin/login";
        }

        User admin = adminOpt.get();

        if (!admin.getPassword().equals(password.trim())) {
            redirectAttributes.addFlashAttribute("error", "Невірний пароль");
            return "redirect:/admin/login";
        }

        session.setAttribute("adminUser", admin);
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin/login";
    }

    // --- 2. DASHBOARD ---

    @GetMapping({"", "/dashboard"})
    public String dashboard(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        long totalUsers = userRepository.count();
        long totalTransactions = paymentRepository.count();
        long pendingApprovals = paymentRepository.findAll().stream()
                .filter(p -> p.getStatus() == PaymentStatus.PENDING)
                .count();

        List<Payment> recentTransactions = paymentRepository.findAll().stream()
                .sorted(Comparator.comparing(Payment::getCreatedAt).reversed())
                .limit(5)
                .toList();

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalTransactions", totalTransactions);
        model.addAttribute("pendingApprovals", pendingApprovals);
        model.addAttribute("recentTransactions", recentTransactions);
        model.addAttribute("systemHealth", 99.8);
        model.addAttribute("admin", session.getAttribute("adminUser"));

        return "admin/dashboard";
    }

    // --- 3. USERS MANAGEMENT ---

    @GetMapping("/users")
    public String users(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        model.addAttribute("admin", session.getAttribute("adminUser"));

        return "admin/users";
    }

    @PostMapping("/users/toggle-block")
    public String toggleUserBlock(@RequestParam Long userId, RedirectAttributes redirectAttributes, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Тут буде логіка блокування, коли додасте поле в БД
            redirectAttributes.addFlashAttribute("successMessage", "Статус користувача " + user.getEmail() + " змінено (Демо)");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Користувача не знайдено");
        }
        return "redirect:/admin/users";
    }

    // --- 4. TRANSACTIONS MANAGEMENT ---

    @GetMapping("/transactions")
    public String transactions(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        List<Payment> payments = paymentRepository.findAll().stream()
                .sorted(Comparator.comparing(Payment::getCreatedAt).reversed())
                .toList();

        model.addAttribute("payments", payments);
        model.addAttribute("admin", session.getAttribute("adminUser"));

        return "admin/transactions";
    }

    @PostMapping("/transactions/approve")
    public String approveTransaction(@RequestParam Long paymentId, RedirectAttributes redirectAttributes, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        processTransaction(paymentId, PaymentStatus.COMPLETED, "успішно підтверджено", redirectAttributes);
        return "redirect:/admin/transactions";
    }

    @PostMapping("/transactions/reject")
    public String rejectTransaction(@RequestParam Long paymentId, RedirectAttributes redirectAttributes, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        processTransaction(paymentId, PaymentStatus.FAILED, "відхилено", redirectAttributes);
        return "redirect:/admin/transactions";
    }

    // --- Helper Methods ---

    private void processTransaction(Long paymentId, PaymentStatus newStatus, String messageAction, RedirectAttributes redirectAttributes) {
        Optional<Payment> paymentOpt = paymentRepository.findById(paymentId);
        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            if (payment.getStatus() == PaymentStatus.PENDING) {
                payment.setStatus(newStatus);
                paymentRepository.save(payment);
                redirectAttributes.addFlashAttribute("successMessage", "Транзакцію #" + paymentId + " " + messageAction + ".");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Ця транзакція вже оброблена.");
            }
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Транзакцію не знайдено.");
        }
    }

    // Змінив назву на "isNotAuthenticated", щоб логіка читалася прямо
    private boolean isNotAuthenticated(HttpSession session) {
        return session.getAttribute("adminUser") == null;
    }
}