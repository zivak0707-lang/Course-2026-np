package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ua.com.kisit.course2026np.dto.DashboardStats;
import ua.com.kisit.course2026np.dto.TransactionPage;
import ua.com.kisit.course2026np.entity.PaymentStatus;
import ua.com.kisit.course2026np.entity.PaymentType;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.service.AdminService;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    // ─────────────────────────────────────────────
    //  AUTH
    // ─────────────────────────────────────────────

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        if (!isNotAuthenticated(session)) return "redirect:/admin/dashboard";
        return "admin/login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email,
                              @RequestParam String password,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        try {
            User admin = adminService.authenticateAdmin(email, password);
            session.setAttribute("adminUser", admin);
            return "redirect:/admin/dashboard";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin/login";
    }

    // ─────────────────────────────────────────────
    //  DASHBOARD
    // ─────────────────────────────────────────────

    @GetMapping({"", "/dashboard"})
    public String dashboard(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        DashboardStats s = adminService.getDashboardStats();

        model.addAttribute("totalUsers",           s.totalUsers());
        model.addAttribute("totalTransactions",    s.totalTransactions());
        model.addAttribute("pendingApprovals",     s.pendingApprovals());
        model.addAttribute("activeCards",          s.activeCards());
        model.addAttribute("totalBalance",         s.totalBalance());
        model.addAttribute("systemHealth",         99.8);
        model.addAttribute("newUsersToday",        s.newUsersToday());
        model.addAttribute("avgTransactionAmount", s.avgTransactionAmount());

        model.addAttribute("completedCount",  s.completedCount());
        model.addAttribute("pendingCount",    s.pendingCount());
        model.addAttribute("failedCount",     s.failedCount());
        model.addAttribute("cancelledCount",  s.cancelledCount());

        model.addAttribute("chartLabels", s.chartLabels());
        model.addAttribute("chartData",   s.chartData());

        model.addAttribute("typePayment",       s.typePayment());
        model.addAttribute("typeReplenishment", s.typeReplenishment());
        model.addAttribute("typeTransfer",      s.typeTransfer());

        model.addAttribute("topUsers",           s.topUsers());
        model.addAttribute("recentTransactions", s.recentTransactions());
        model.addAttribute("admin", session.getAttribute("adminUser"));

        return "admin/dashboard";
    }

    // ─────────────────────────────────────────────
    //  USERS
    // ─────────────────────────────────────────────

    @GetMapping("/users")
    public String users(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        model.addAttribute("users", adminService.getUsersSortedById());
        model.addAttribute("admin", session.getAttribute("adminUser"));
        return "admin/users";
    }

    @PostMapping("/users/toggle-block")
    public String toggleUserBlock(@RequestParam Long userId,
                                  RedirectAttributes redirectAttributes,
                                  HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        try {
            String msg = adminService.toggleUserBlock(userId, admin != null ? admin.getId() : null);
            redirectAttributes.addFlashAttribute("successMessage", msg);
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/assign-role")
    public String assignRole(@RequestParam Long userId,
                             @RequestParam String role,
                             RedirectAttributes redirectAttributes,
                             HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        try {
            String msg = adminService.assignRole(userId, role, admin != null ? admin.getId() : null);
            redirectAttributes.addFlashAttribute("successMessage", msg);
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/delete")
    public String deleteUser(@RequestParam Long userId,
                             RedirectAttributes redirectAttributes,
                             HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        try {
            String msg = adminService.deleteUser(userId, admin != null ? admin.getId() : null);
            redirectAttributes.addFlashAttribute("successMessage", msg);
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // ─────────────────────────────────────────────
    //  TRANSACTIONS
    // ─────────────────────────────────────────────

    @GetMapping("/transactions")
    public String transactions(Model model, HttpSession session,
                               @RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "10") int size,
                               @RequestParam(required = false) String search,
                               @RequestParam(required = false) String type,
                               @RequestParam(required = false) String status) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        TransactionPage p = adminService.filterAndPageTransactions(page, size, search, type, status);

        model.addAttribute("payments",        p.payments());
        model.addAttribute("currentPage",     p.currentPage());
        model.addAttribute("totalPages",      p.totalPages());
        model.addAttribute("totalItems",      p.totalItems());
        model.addAttribute("pageSize",        p.pageSize());
        model.addAttribute("hasNext",         p.hasNext());
        model.addAttribute("hasPrevious",     p.hasPrevious());
        model.addAttribute("searchQuery",     p.searchQuery());
        model.addAttribute("selectedType",    p.selectedType());
        model.addAttribute("selectedStatus",  p.selectedStatus());
        model.addAttribute("paymentTypes",    PaymentType.values());
        model.addAttribute("paymentStatuses", PaymentStatus.values());
        model.addAttribute("admin", session.getAttribute("adminUser"));
        return "admin/transactions";
    }

    @PostMapping("/transactions/approve")
    public String approveTransaction(@RequestParam Long paymentId,
                                     RedirectAttributes redirectAttributes,
                                     HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        try {
            adminService.approveTransaction(paymentId);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Transaction #" + paymentId + " has been approved");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/transactions";
    }

    @PostMapping("/transactions/reject")
    public String rejectTransaction(@RequestParam Long paymentId,
                                    RedirectAttributes redirectAttributes,
                                    HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        try {
            adminService.rejectTransaction(paymentId);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Transaction #" + paymentId + " has been rejected");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/transactions";
    }

    // ─────────────────────────────────────────────
    //  PLACEHOLDER PAGES
    // ─────────────────────────────────────────────

    @GetMapping("/reports")
    public String reports(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        model.addAttribute("admin", session.getAttribute("adminUser"));
        return "admin/reports";
    }

    @GetMapping("/settings")
    public String settings(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        if (admin != null) {
            adminService.findById(admin.getId()).ifPresent(fresh -> {
                model.addAttribute("admin", fresh);
                session.setAttribute("adminUser", fresh);
            });
        }
        if (!model.containsAttribute("admin")) {
            model.addAttribute("admin", admin);
        }
        return "admin/settings";
    }

    @PostMapping("/settings/update-profile")
    public String updateProfile(@RequestParam String firstName,
                                @RequestParam String lastName,
                                @RequestParam String email,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        try {
            adminService.updateProfile(admin.getId(), firstName, lastName, email);
            adminService.findById(admin.getId())
                    .ifPresent(fresh -> session.setAttribute("adminUser", fresh));
            redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/settings";
    }

    @PostMapping("/settings/update-password")
    public String updatePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        try {
            adminService.updatePassword(admin.getId(), currentPassword, newPassword);
            adminService.findById(admin.getId())
                    .ifPresent(fresh -> session.setAttribute("adminUser", fresh));
            redirectAttributes.addFlashAttribute("successMessage", "Password updated successfully");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/settings";
    }

    // ─────────────────────────────────────────────
    //  HELPERS
    // ─────────────────────────────────────────────

    private boolean isNotAuthenticated(HttpSession session) {
        return session.getAttribute("adminUser") == null;
    }
}
