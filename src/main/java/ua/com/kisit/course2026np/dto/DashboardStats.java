package ua.com.kisit.course2026np.dto;

import ua.com.kisit.course2026np.entity.Payment;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public record DashboardStats(
        long totalUsers,
        long totalTransactions,
        long pendingApprovals,
        long activeCards,
        BigDecimal totalBalance,
        long newUsersToday,
        BigDecimal avgTransactionAmount,
        long completedCount,
        long pendingCount,
        long failedCount,
        long cancelledCount,
        List<String> chartLabels,
        List<Long> chartData,
        long typePayment,
        long typeReplenishment,
        long typeTransfer,
        List<Map<String, Object>> topUsers,
        List<Payment> recentTransactions
) {}
