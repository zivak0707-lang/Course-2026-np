package ua.com.kisit.course2026np.dto;

import ua.com.kisit.course2026np.entity.Payment;

import java.util.List;

public record TransactionPage(
        List<Payment> payments,
        int currentPage,
        int totalPages,
        int totalItems,
        int pageSize,
        boolean hasNext,
        boolean hasPrevious,
        String searchQuery,
        String selectedType,
        String selectedStatus
) {}
