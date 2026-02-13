package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.PaymentRepository;
import ua.com.kisit.course2026np.repository.AccountRepository;

import java.util.List;
import java.util.Optional;

/**
 * Service for Payment business logic
 * Handles transaction processing, filtering, and pagination
 */
@Service
@RequiredArgsConstructor
@Transactional
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final AccountRepository accountRepository;

    // ============= ORIGINAL METHODS (НЕ ЧІПАЄМО) =============

    public Payment createPayment(Payment payment) {
        return paymentRepository.save(payment);
    }

    public Payment executePayment(Long accountId, Payment payment) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        if (account.getBalance().compareTo(payment.getAmount()) < 0) {
            payment.fail("Insufficient funds");
            return paymentRepository.save(payment);
        }

        account.setBalance(account.getBalance().subtract(payment.getAmount()));
        accountRepository.save(account);

        payment.setAccount(account);
        payment.setSenderAccount(account.getAccountNumber());
        payment.complete();
        return paymentRepository.save(payment);
    }

    public Payment executeReplenishment(Long accountId, Payment payment) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        account.setBalance(account.getBalance().add(payment.getAmount()));
        accountRepository.save(account);

        payment.setAccount(account);
        payment.setRecipientAccount(account.getAccountNumber());
        payment.complete();
        return paymentRepository.save(payment);
    }

    @Transactional(readOnly = true)
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Payment> getPaymentById(Long id) {
        return paymentRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByAccount(Account account) {
        return paymentRepository.findByAccount(account);
    }

    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByAccountOrdered(Account account) {
        return paymentRepository.findByAccountOrderByCreatedAtDesc(account);
    }

    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByStatus(PaymentStatus status) {
        return paymentRepository.findByStatus(status);
    }

    public void deletePayment(Long id) {
        paymentRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public long countPayments() {
        return paymentRepository.count();
    }

    @Transactional(readOnly = true)
    public long countPaymentsByStatus(PaymentStatus status) {
        return paymentRepository.findByStatus(status).size();
    }

    // ============= NEW METHODS FOR TRANSACTIONS PAGE =============

    /**
     * Get paginated payments for a user with optional filters
     * Used by: PaymentController.transactionsPage()
     *
     * @param user The user whose payments to retrieve
     * @param search Search query for description (optional)
     * @param type Filter by payment type (optional)
     * @param status Filter by payment status (optional)
     * @param page Page number (0-based)
     * @param size Number of items per page
     * @return Page of payments
     */
    @Transactional(readOnly = true)
    public Page<Payment> getPaymentsForUser(
            User user,
            String search,
            PaymentType type,
            PaymentStatus status,
            int page,
            int size
    ) {
        Pageable pageable = PageRequest.of(page, size);

        // If all filters are null/empty, get all payments for user
        if ((search == null || search.trim().isEmpty()) && type == null && status == null) {
            return paymentRepository.findByUser(user, pageable);
        }

        // Apply filters
        return paymentRepository.findByUserWithFilters(
                user,
                search != null && !search.trim().isEmpty() ? search.trim() : null,
                type,
                status,
                pageable
        );
    }

    /**
     * Get recent transactions for dashboard (limited to specified number)
     * Used by: ClientController.dashboard() - для віджету "Recent Transactions"
     */
    @Transactional(readOnly = true)
    public List<Payment> getRecentTransactionsForUser(User user, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return paymentRepository.findByUser(user, pageable).getContent();
    }

    /**
     * Get recent payments by account (limited to specified number)
     * Used by: AccountController.getAccountDetails() - для деталей акаунту
     *
     * @param account Account to get payments for
     * @param limit Maximum number of payments to return
     * @return List of recent payments ordered by date descending
     */
    @Transactional(readOnly = true)
    public List<Payment> getRecentPaymentsByAccount(Account account, int limit) {
        List<Payment> allPayments = paymentRepository.findByAccountOrderByCreatedAtDesc(account);

        // Обмежуємо кількість результатів
        return allPayments.stream()
                .limit(limit)
                .toList();
    }

    /**
     * Count total payments for user
     * Can be used for dashboard statistics
     */
    @Transactional(readOnly = true)
    public long countPaymentsForUser(User user) {
        return paymentRepository.countByUser(user);
    }

    /**
     * Count pending payments for user
     * Used for dashboard "Pending" count
     */
    @Transactional(readOnly = true)
    public long countPendingPaymentsForUser(User user) {
        return paymentRepository.countByUserAndStatus(user, PaymentStatus.PENDING);
    }
}