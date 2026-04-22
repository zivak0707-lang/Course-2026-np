package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.dto.DashboardStats;
import ua.com.kisit.course2026np.dto.TransactionPage;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardService {

    private final PaymentRepository paymentRepository;
    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final CreditCardRepository creditCardRepository;

    public DashboardStats getDashboardStats() {
        List<Payment>    allPayments = paymentRepository.findAll();
        List<User>       allUsers    = userRepository.findAll();
        List<Account>    allAccounts = accountRepository.findAll();
        List<CreditCard> allCards    = creditCardRepository.findAll();

        long totalUsers        = allUsers.size();
        long totalTransactions = allPayments.size();
        long pendingApprovals  = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.PENDING).count();
        long activeCards       = allCards.stream().filter(c -> Boolean.TRUE.equals(c.getIsActive())).count();

        BigDecimal totalBalance = allAccounts.stream()
                .map(Account::getBalance).reduce(BigDecimal.ZERO, BigDecimal::add);

        LocalDate today = LocalDate.now();
        long newUsersToday = allUsers.stream()
                .filter(u -> u.getCreatedAt() != null && u.getCreatedAt().toLocalDate().equals(today))
                .count();

        List<Payment> completedPayments = allPayments.stream()
                .filter(p -> p.getStatus() == PaymentStatus.COMPLETED).toList();

        BigDecimal avgTransactionAmount = BigDecimal.ZERO;
        if (!completedPayments.isEmpty()) {
            BigDecimal total = completedPayments.stream()
                    .map(Payment::getAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
            avgTransactionAmount = total.divide(
                    BigDecimal.valueOf(completedPayments.size()), 2, RoundingMode.HALF_UP);
        }

        long completedCount = completedPayments.size();
        long pendingCount   = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.PENDING).count();
        long failedCount    = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.FAILED).count();
        long cancelledCount = allPayments.stream().filter(p -> p.getStatus() == PaymentStatus.CANCELLED).count();

        // Group by YearMonth to avoid merging same-month data across years
        Map<YearMonth, Long> byYearMonth = allPayments.stream()
                .filter(p -> p.getCreatedAt() != null)
                .collect(Collectors.groupingBy(p -> YearMonth.from(p.getCreatedAt()), Collectors.counting()));

        List<String> chartLabels = new ArrayList<>();
        List<Long>   chartData   = new ArrayList<>();
        YearMonth current = YearMonth.now();
        for (int i = 5; i >= 0; i--) {
            YearMonth ym = current.minusMonths(i);
            chartLabels.add(ym.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + ym.getYear());
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

        Map<Long, User> userMap = allUsers.stream().collect(Collectors.toMap(User::getId, u -> u));

        List<Map<String, Object>> topUsers = volumeByUserId.entrySet().stream()
                .sorted(Map.Entry.<Long, BigDecimal>comparingByValue().reversed())
                .limit(5)
                .map(e -> {
                    User u      = userMap.get(e.getKey());
                    String name  = u != null ? u.getFirstName() + " " + u.getLastName() : "Unknown";
                    String email = u != null ? u.getEmail() : "—";
                    long   cnt   = countByUserId.getOrDefault(e.getKey(), 0L);
                    BigDecimal vol = e.getValue();
                    double pct = totalBalance.compareTo(BigDecimal.ZERO) > 0
                            ? vol.divide(totalBalance, 4, RoundingMode.HALF_UP)
                                 .multiply(BigDecimal.valueOf(100)).doubleValue()
                            : 0.0;
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("name",  name);  row.put("email", email);
                    row.put("total", vol);   row.put("count", cnt);
                    row.put("pct",   Math.min(pct, 100.0));
                    return row;
                })
                .toList();

        List<Payment> recentTransactions = allPayments.stream()
                .filter(p -> p.getCreatedAt() != null)
                .sorted(Comparator.comparing(Payment::getCreatedAt).reversed())
                .limit(5).toList();

        return new DashboardStats(
                totalUsers, totalTransactions, pendingApprovals, activeCards, totalBalance,
                newUsersToday, avgTransactionAmount,
                completedCount, pendingCount, failedCount, cancelledCount,
                chartLabels, chartData,
                typePayment, typeReplenishment, typeTransfer,
                topUsers, recentTransactions
        );
    }

    public TransactionPage filterAndPageTransactions(
            int page, int size, String search, String type, String status) {

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

        return new TransactionPage(
                pageContent, page, totalPages, totalItems, size,
                page < totalPages - 1, page > 0,
                search != null ? search : "",
                type   != null ? type   : "ALL",
                status != null ? status : "ALL"
        );
    }
}
