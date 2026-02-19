package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    private final AccountRepository accountRepository;
    private final CreditCardRepository creditCardRepository;

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

        Optional<User> adminOpt = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim())
                        && u.getRole() == UserRole.ADMIN)
                .findFirst();

        if (adminOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found or insufficient privileges");
            return "redirect:/admin/login";
        }

        User admin = adminOpt.get();
        if (!admin.getPassword().equals(password.trim())) {
            redirectAttributes.addFlashAttribute("error", "Incorrect password");
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

    // ─────────────────────────────────────────────
    //  DASHBOARD
    // ─────────────────────────────────────────────

    @GetMapping({"", "/dashboard"})
    public String dashboard(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        List<Payment>    allPayments = paymentRepository.findAll();
        List<User>       allUsers    = userRepository.findAll();
        List<Account>    allAccounts = accountRepository.findAll();
        List<CreditCard> allCards    = creditCardRepository.findAll();

        // ── Basic stats ──────────────────────────────────────────────────
        long totalUsers        = allUsers.size();
        long totalTransactions = allPayments.size();
        long pendingApprovals  = allPayments.stream()
                .filter(p -> p.getStatus() == PaymentStatus.PENDING).count();
        long activeCards       = allCards.stream()
                .filter(c -> Boolean.TRUE.equals(c.getIsActive())).count();

        BigDecimal totalBalance = allAccounts.stream()
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // ── NEW: Registrations today ──────────────────────────────────────
        LocalDate today = LocalDate.now();
        long newUsersToday = allUsers.stream()
                .filter(u -> u.getCreatedAt() != null
                        && u.getCreatedAt().toLocalDate().equals(today))
                .count();

        // ── NEW: Average completed transaction amount ─────────────────────
        List<Payment> completedPayments = allPayments.stream()
                .filter(p -> p.getStatus() == PaymentStatus.COMPLETED)
                .toList();

        BigDecimal avgTransactionAmount = BigDecimal.ZERO;
        if (!completedPayments.isEmpty()) {
            BigDecimal totalCompleted = completedPayments.stream()
                    .map(Payment::getAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            avgTransactionAmount = totalCompleted.divide(
                    BigDecimal.valueOf(completedPayments.size()), 2, RoundingMode.HALF_UP);
        }

        // ── Status counts ─────────────────────────────────────────────────
        long completedCount = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.COMPLETED).count();
        long pendingCount   = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.PENDING).count();
        long failedCount    = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.FAILED).count();
        long cancelledCount = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.CANCELLED).count();

        // ── FIX: Chart volume — group by YearMonth, NOT by Month ─────────
        // Previously used p.getCreatedAt().getMonth() which merged
        // Feb 2025 + Feb 2026 into one bucket, causing a false spike.
        Map<YearMonth, Long> byYearMonth = allPayments.stream()
                .filter(p -> p.getCreatedAt() != null)
                .collect(Collectors.groupingBy(
                        p -> YearMonth.from(p.getCreatedAt()),
                        Collectors.counting()
                ));

        List<String> chartLabels = new ArrayList<>();
        List<Long>   chartData   = new ArrayList<>();
        YearMonth current = YearMonth.now();
        for (int i = 5; i >= 0; i--) {
            YearMonth ym = current.minusMonths(i);
            chartLabels.add(
                    ym.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH)
                            + " " + ym.getYear()
            );
            chartData.add(byYearMonth.getOrDefault(ym, 0L));
        }

        // ── NEW: Payment type distribution (for bar/stacked chart) ────────
        long typePayment       = allPayments.stream().filter(p -> p.getType() == PaymentType.PAYMENT).count();
        long typeReplenishment = allPayments.stream().filter(p -> p.getType() == PaymentType.REPLENISHMENT).count();
        long typeTransfer      = allPayments.stream().filter(p -> p.getType() == PaymentType.TRANSFER).count();

        // ── NEW: Top 5 users by completed transaction volume ──────────────
        // Navigation: Payment -> Account -> CreditCard -> User
        Map<Long, BigDecimal> volumeByUserId = completedPayments.stream()
                .filter(p -> p.getAccount() != null
                        && p.getAccount().getCreditCard() != null
                        && p.getAccount().getCreditCard().getUser() != null)
                .collect(Collectors.groupingBy(
                        p -> p.getAccount().getCreditCard().getUser().getId(),
                        Collectors.reducing(BigDecimal.ZERO, Payment::getAmount, BigDecimal::add)
                ));

        Map<Long, Long> countByUserId = completedPayments.stream()
                .filter(p -> p.getAccount() != null
                        && p.getAccount().getCreditCard() != null
                        && p.getAccount().getCreditCard().getUser() != null)
                .collect(Collectors.groupingBy(
                        p -> p.getAccount().getCreditCard().getUser().getId(),
                        Collectors.counting()
                ));

        Map<Long, User> userMap = allUsers.stream()
                .collect(Collectors.toMap(User::getId, u -> u));

        // Use LinkedHashMap to preserve order; pass as list of maps for FTL
        List<Map<String, Object>> topUsers = volumeByUserId.entrySet().stream()
                .sorted(Map.Entry.<Long, BigDecimal>comparingByValue().reversed())
                .limit(5)
                .map(e -> {
                    User u       = userMap.get(e.getKey());
                    String name  = u != null ? u.getFirstName() + " " + u.getLastName() : "Unknown";
                    String email = u != null ? u.getEmail() : "—";
                    long   cnt   = countByUserId.getOrDefault(e.getKey(), 0L);
                    BigDecimal vol = e.getValue();

                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("name",   name);
                    row.put("email",  email);
                    row.put("total",  vol);
                    row.put("count",  cnt);
                    // percentage of totalBalance for progress bar (cap at 100%)
                    double pct = totalBalance.compareTo(BigDecimal.ZERO) > 0
                            ? vol.divide(totalBalance, 4, RoundingMode.HALF_UP)
                            .multiply(BigDecimal.valueOf(100))
                            .doubleValue()
                            : 0.0;
                    row.put("pct", Math.min(pct, 100.0));
                    return row;
                })
                .toList();

        // ── Recent 5 transactions ─────────────────────────────────────────
        List<Payment> recentTransactions = allPayments.stream()
                .filter(p -> p.getCreatedAt() != null)
                .sorted(Comparator.comparing(Payment::getCreatedAt).reversed())
                .limit(5)
                .toList();

        // ── Bind to model ─────────────────────────────────────────────────
        model.addAttribute("totalUsers",           totalUsers);
        model.addAttribute("totalTransactions",    totalTransactions);
        model.addAttribute("pendingApprovals",     pendingApprovals);
        model.addAttribute("activeCards",          activeCards);
        model.addAttribute("totalBalance",         totalBalance);
        model.addAttribute("systemHealth",         99.8);
        model.addAttribute("newUsersToday",        newUsersToday);
        model.addAttribute("avgTransactionAmount", avgTransactionAmount);

        model.addAttribute("completedCount",  completedCount);
        model.addAttribute("pendingCount",    pendingCount);
        model.addAttribute("failedCount",     failedCount);
        model.addAttribute("cancelledCount",  cancelledCount);

        model.addAttribute("chartLabels", chartLabels);
        model.addAttribute("chartData",   chartData);

        model.addAttribute("typePayment",        typePayment);
        model.addAttribute("typeReplenishment",  typeReplenishment);
        model.addAttribute("typeTransfer",       typeTransfer);

        model.addAttribute("topUsers",           topUsers);
        model.addAttribute("recentTransactions", recentTransactions);
        model.addAttribute("admin", session.getAttribute("adminUser"));

        return "admin/dashboard";
    }

    // ─────────────────────────────────────────────
    //  USERS
    // ─────────────────────────────────────────────

    @GetMapping("/users")
    public String users(Model model, HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        List<User> users = userRepository.findAll().stream()
                .sorted(Comparator.comparing(User::getId))
                .toList();
        model.addAttribute("users", users);
        model.addAttribute("admin", session.getAttribute("adminUser"));
        return "admin/users";
    }

    @PostMapping("/users/toggle-block")
    public String toggleUserBlock(@RequestParam Long userId,
                                  RedirectAttributes redirectAttributes,
                                  HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        if (admin != null && admin.getId().equals(userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "You cannot block your own account");
            return "redirect:/admin/users";
        }
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setIsActive(!Boolean.TRUE.equals(user.getIsActive()));
            userRepository.save(user);
            String action = Boolean.TRUE.equals(user.getIsActive()) ? "unblocked" : "blocked";
            redirectAttributes.addFlashAttribute("successMessage",
                    "User " + user.getEmail() + " has been " + action);
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "User not found");
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/delete")
    public String deleteUser(@RequestParam Long userId,
                             RedirectAttributes redirectAttributes,
                             HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        User admin = (User) session.getAttribute("adminUser");
        if (admin != null && admin.getId().equals(userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "You cannot delete your own account");
            return "redirect:/admin/users";
        }
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            String email = userOpt.get().getEmail();
            userRepository.deleteById(userId);
            redirectAttributes.addFlashAttribute("successMessage", "User " + email + " deleted");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "User not found");
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

        List<Payment> all = paymentRepository.findAll().stream()
                .filter(p -> p.getCreatedAt() != null)
                .sorted(Comparator.comparing(Payment::getCreatedAt).reversed())
                .collect(Collectors.toList());

        if (search != null && !search.isBlank()) {
            String lc = search.toLowerCase();
            all = all.stream().filter(p ->
                    (p.getDescription() != null && p.getDescription().toLowerCase().contains(lc))
                            || (p.getTransactionId() != null && p.getTransactionId().toLowerCase().contains(lc))
            ).collect(Collectors.toList());
        }
        if (type != null && !type.isBlank() && !type.equalsIgnoreCase("ALL")) {
            try {
                PaymentType pt = PaymentType.valueOf(type.toUpperCase());
                all = all.stream().filter(p -> p.getType() == pt).collect(Collectors.toList());
            } catch (IllegalArgumentException ignored) {}
        }
        if (status != null && !status.isBlank() && !status.equalsIgnoreCase("ALL")) {
            try {
                PaymentStatus ps = PaymentStatus.valueOf(status.toUpperCase());
                all = all.stream().filter(p -> p.getStatus() == ps).collect(Collectors.toList());
            } catch (IllegalArgumentException ignored) {}
        }

        int totalItems = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / size));
        page = Math.max(0, Math.min(page, totalPages - 1));
        List<Payment> pageContent = all.subList(page * size, Math.min(page * size + size, totalItems));

        model.addAttribute("payments",        pageContent);
        model.addAttribute("currentPage",     page);
        model.addAttribute("totalPages",      totalPages);
        model.addAttribute("totalItems",      totalItems);
        model.addAttribute("pageSize",        size);
        model.addAttribute("hasNext",         page < totalPages - 1);
        model.addAttribute("hasPrevious",     page > 0);
        model.addAttribute("searchQuery",     search != null ? search : "");
        model.addAttribute("selectedType",    type   != null ? type   : "ALL");
        model.addAttribute("selectedStatus",  status != null ? status : "ALL");
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
        processTransaction(paymentId, PaymentStatus.COMPLETED, "approved", redirectAttributes);
        return "redirect:/admin/transactions";
    }

    @PostMapping("/transactions/reject")
    public String rejectTransaction(@RequestParam Long paymentId,
                                    RedirectAttributes redirectAttributes,
                                    HttpSession session) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";
        processTransaction(paymentId, PaymentStatus.FAILED, "rejected", redirectAttributes);
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
        // Refresh admin from DB to show current values
        User admin = (User) session.getAttribute("adminUser");
        if (admin != null) {
            userRepository.findById(admin.getId()).ifPresent(fresh -> {
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
        Optional<User> userOpt = userRepository.findById(admin.getId());
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Admin account not found");
            return "redirect:/admin/settings";
        }

        User user = userOpt.get();
        // Check if email is already taken by another user
        boolean emailTaken = userRepository.findAll().stream()
                .anyMatch(u -> u.getEmail().equalsIgnoreCase(email.trim())
                        && !u.getId().equals(user.getId()));
        if (emailTaken) {
            redirectAttributes.addFlashAttribute("errorMessage", "Email address is already in use by another account");
            return "redirect:/admin/settings";
        }

        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setEmail(email.trim());
        userRepository.save(user);
        session.setAttribute("adminUser", user); // update session
        redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully");
        return "redirect:/admin/settings";
    }

    @PostMapping("/settings/update-password")
    public String updatePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        if (isNotAuthenticated(session)) return "redirect:/admin/login";

        User admin = (User) session.getAttribute("adminUser");
        Optional<User> userOpt = userRepository.findById(admin.getId());
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Admin account not found");
            return "redirect:/admin/settings";
        }

        User user = userOpt.get();
        if (!user.getPassword().equals(currentPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Current password is incorrect");
            return "redirect:/admin/settings";
        }
        if (newPassword.length() < 6) {
            redirectAttributes.addFlashAttribute("errorMessage", "New password must be at least 6 characters");
            return "redirect:/admin/settings";
        }
        if (currentPassword.equals(newPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "New password must be different from the current one");
            return "redirect:/admin/settings";
        }

        user.setPassword(newPassword);
        userRepository.save(user);
        session.setAttribute("adminUser", user);
        redirectAttributes.addFlashAttribute("successMessage", "Password updated successfully");
        return "redirect:/admin/settings";
    }

    // ─────────────────────────────────────────────
    //  HELPERS
    // ─────────────────────────────────────────────

    private void processTransaction(Long paymentId, PaymentStatus newStatus,
                                    String action, RedirectAttributes ra) {
        Optional<Payment> opt = paymentRepository.findById(paymentId);
        if (opt.isPresent()) {
            Payment p = opt.get();
            if (p.getStatus() == PaymentStatus.PENDING) {
                p.setStatus(newStatus);
                if (newStatus == PaymentStatus.COMPLETED) p.complete();
                else p.fail("Rejected by admin");
                paymentRepository.save(p);
                ra.addFlashAttribute("successMessage",
                        "Transaction #" + paymentId + " has been " + action);
            } else {
                ra.addFlashAttribute("errorMessage", "Transaction is already processed");
            }
        } else {
            ra.addFlashAttribute("errorMessage", "Transaction not found");
        }
    }

    private boolean isNotAuthenticated(HttpSession session) {
        return session.getAttribute("adminUser") == null;
    }
}