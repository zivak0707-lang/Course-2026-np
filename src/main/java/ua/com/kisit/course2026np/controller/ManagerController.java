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
@RequestMapping("/manager")
@RequiredArgsConstructor
public class ManagerController {

    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    private final AccountRepository accountRepository;
    private final CreditCardRepository creditCardRepository;

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

        Optional<User> managerOpt = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim())
                        && u.getRole() == UserRole.MANAGER)
                .findFirst();

        if (managerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found or insufficient privileges");
            return "redirect:/manager/login";
        }

        User manager = managerOpt.get();
        if (!manager.getPassword().equals(password.trim())) {
            redirectAttributes.addFlashAttribute("error", "Incorrect password");
            return "redirect:/manager/login";
        }
        if (!Boolean.TRUE.equals(manager.getIsActive())) {
            redirectAttributes.addFlashAttribute("error", "Your account has been blocked");
            return "redirect:/manager/login";
        }

        session.setAttribute("managerUser", manager);
        return "redirect:/manager/dashboard";
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

        List<Payment>    allPayments = paymentRepository.findAll();
        List<User>       allUsers    = userRepository.findAll();
        List<Account>    allAccounts = accountRepository.findAll();
        List<CreditCard> allCards    = creditCardRepository.findAll();

        long totalUsers        = allUsers.size();
        long totalTransactions = allPayments.size();
        long pendingApprovals  = allPayments.stream()
                .filter(p -> p.getStatus() == PaymentStatus.PENDING).count();
        long activeCards       = allCards.stream()
                .filter(c -> Boolean.TRUE.equals(c.getIsActive())).count();

        BigDecimal totalBalance = allAccounts.stream()
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        LocalDate today = LocalDate.now();
        long newUsersToday = allUsers.stream()
                .filter(u -> u.getCreatedAt() != null
                        && u.getCreatedAt().toLocalDate().equals(today))
                .count();

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

        long completedCount = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.COMPLETED).count();
        long pendingCount   = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.PENDING).count();
        long failedCount    = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.FAILED).count();
        long cancelledCount = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.CANCELLED).count();

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

        long typePayment       = allPayments.stream().filter(p -> p.getType() == PaymentType.PAYMENT).count();
        long typeReplenishment = allPayments.stream().filter(p -> p.getType() == PaymentType.REPLENISHMENT).count();
        long typeTransfer      = allPayments.stream().filter(p -> p.getType() == PaymentType.TRANSFER).count();

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
                    double pct = totalBalance.compareTo(BigDecimal.ZERO) > 0
                            ? vol.divide(totalBalance, 4, RoundingMode.HALF_UP)
                            .multiply(BigDecimal.valueOf(100))
                            .doubleValue()
                            : 0.0;
                    row.put("pct", Math.min(pct, 100.0));
                    return row;
                })
                .toList();

        List<Payment> recentTransactions = allPayments.stream()
                .filter(p -> p.getCreatedAt() != null)
                .sorted(Comparator.comparing(Payment::getCreatedAt).reversed())
                .limit(5)
                .toList();

        model.addAttribute("totalUsers",           totalUsers);
        model.addAttribute("totalTransactions",    totalTransactions);
        model.addAttribute("pendingApprovals",     pendingApprovals);
        model.addAttribute("activeCards",          activeCards);
        model.addAttribute("totalBalance",         totalBalance);
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
