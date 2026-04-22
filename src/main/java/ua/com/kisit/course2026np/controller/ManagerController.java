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
import ua.com.kisit.course2026np.service.ManagerService;

@Controller
@RequestMapping("/manager")
@RequiredArgsConstructor
public class ManagerController {

    private final ManagerService managerService;

    // ─────────────────────────────────────────────
    //  AUTH
    // ─────────────────────────────────────────────

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        if (!isNotAuthenticated(session)) return "redirect:/manager/dashboard";
        return "manager/login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email,
                              @RequestParam String password,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        try {
            User manager = managerService.authenticateManager(email, password);
            session.setAttribute("managerUser", manager);
            return "redirect:/manager/dashboard";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/manager/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/manager/login";
    }

    // ─────────────────────────────────────────────
    //  DASHBOARD
    // ─────────────────────────────────────────────

    @GetMapping({"", "/dashboard"})
    public String dashboard(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/manager/login";

        DashboardStats s = managerService.getDashboardStats();

        model.addAttribute("totalUsers",           s.totalUsers());
        model.addAttribute("totalTransactions",    s.totalTransactions());
        model.addAttribute("pendingApprovals",     s.pendingApprovals());
        model.addAttribute("activeCards",          s.activeCards());
        model.addAttribute("totalBalance",         s.totalBalance());
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
        model.addAttribute("manager", session.getAttribute("managerUser"));

        return "manager/dashboard";
    }

    // ─────────────────────────────────────────────
    //  TRANSACTIONS (view-only)
    // ─────────────────────────────────────────────

    @GetMapping("/transactions")
    public String transactions(Model model, HttpSession session,
                               @RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "10") int size,
                               @RequestParam(required = false) String search,
                               @RequestParam(required = false) String type,
                               @RequestParam(required = false) String status) {
        if (isNotAuthenticated(session)) return "redirect:/manager/login";

        TransactionPage p = managerService.filterAndPageTransactions(page, size, search, type, status);

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
        model.addAttribute("manager", session.getAttribute("managerUser"));
        return "manager/transactions";
    }

    // ─────────────────────────────────────────────
    //  REPORTS
    // ─────────────────────────────────────────────

    @GetMapping("/reports")
    public String reports(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/manager/login";
        model.addAttribute("manager", session.getAttribute("managerUser"));
        return "manager/reports";
    }

    // ─────────────────────────────────────────────
    //  HELPERS
    // ─────────────────────────────────────────────

    private boolean isNotAuthenticated(HttpSession session) {
        return session.getAttribute("managerUser") == null;
    }
}
