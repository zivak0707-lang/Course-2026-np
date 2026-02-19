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

@Service
@RequiredArgsConstructor
@Transactional
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final AccountRepository accountRepository;

    // ============= ORIGINAL METHODS =============

    public Payment createPayment(Payment payment) {
        return paymentRepository.save(payment);
    }

    // ✅ ВИПРАВЛЕНО: додана перевірка блокування рахунку +
    //               payment.setAccount() тепер викликається ПЕРЕД save() при помилці
    public Payment executePayment(Long accountId, Payment payment) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        // ✅ Перевірка блокування (було відсутнє)
        if (account.getStatus() == AccountStatus.BLOCKED) {
            payment.setAccount(account);
            payment.fail("Sender account is blocked");
            return paymentRepository.save(payment);
        }

        if (account.getBalance().compareTo(payment.getAmount()) < 0) {
            // ✅ setAccount() перед save() — інакше account_id = null → constraint violation
            payment.setAccount(account);
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

    // ✅ ВИПРАВЛЕНО: додана перевірка блокування рахунку
    public Payment executeReplenishment(Long accountId, Payment payment) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        // ✅ Перевірка блокування (було відсутнє)
        if (account.getStatus() == AccountStatus.BLOCKED) {
            payment.setAccount(account);
            payment.fail("Account is blocked");
            return paymentRepository.save(payment);
        }

        account.setBalance(account.getBalance().add(payment.getAmount()));
        accountRepository.save(account);

        payment.setAccount(account);
        payment.setRecipientAccount(account.getAccountNumber());
        payment.complete();
        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment executeTransfer(Long senderAccountId, String recipientAccountNumber, Payment payment) {
        Account sender = accountRepository.findById(senderAccountId)
                .orElseThrow(() -> new IllegalArgumentException("Sender account not found"));

        Account recipient = accountRepository.findByAccountNumber(recipientAccountNumber)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Recipient account not found: " + recipientAccountNumber));

        if (sender.getId().equals(recipient.getId())) {
            payment.setAccount(sender);
            payment.fail("Cannot transfer to the same account");
            return paymentRepository.save(payment);
        }

        if (sender.getBalance().compareTo(payment.getAmount()) < 0) {
            payment.setAccount(sender);
            payment.fail("Insufficient funds");
            return paymentRepository.save(payment);
        }

        if (sender.getStatus() == AccountStatus.BLOCKED) {
            payment.setAccount(sender);
            payment.fail("Sender account is blocked");
            return paymentRepository.save(payment);
        }

        if (recipient.getStatus() == AccountStatus.BLOCKED) {
            payment.setAccount(sender);
            payment.fail("Recipient account is blocked");
            return paymentRepository.save(payment);
        }

        sender.setBalance(sender.getBalance().subtract(payment.getAmount()));
        accountRepository.save(sender);

        recipient.setBalance(recipient.getBalance().add(payment.getAmount()));
        accountRepository.save(recipient);

        // Запис для відправника (TRANSFER — списання)
        payment.setAccount(sender);
        payment.setSenderAccount(sender.getAccountNumber());
        payment.setRecipientAccount(recipient.getAccountNumber());
        payment.complete();
        paymentRepository.save(payment);

        // Окремий запис для отримувача (REPLENISHMENT — зарахування)
        // Без цього у отримувача транзакція не відображається в списку
        Payment incomingPayment = Payment.builder()
                .account(recipient)
                .amount(payment.getAmount())
                .type(PaymentType.REPLENISHMENT)
                .status(PaymentStatus.COMPLETED)
                .description("Transfer from " + sender.getAccountNumber()
                        + (payment.getDescription() != null && !payment.getDescription().isBlank()
                        ? ": " + payment.getDescription() : ""))
                .senderAccount(sender.getAccountNumber())
                .recipientAccount(recipient.getAccountNumber())
                .build();
        incomingPayment.complete();
        paymentRepository.save(incomingPayment);

        return payment;
    }

    // ============= READ METHODS =============

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

    // ============= TRANSACTIONS PAGE =============

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

        if ((search == null || search.trim().isEmpty()) && type == null && status == null) {
            return paymentRepository.findByUser(user, pageable);
        }

        return paymentRepository.findByUserWithFilters(
                user,
                search != null && !search.trim().isEmpty() ? search.trim() : null,
                type,
                status,
                pageable
        );
    }

    @Transactional(readOnly = true)
    public List<Payment> getRecentTransactionsForUser(User user, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return paymentRepository.findByUser(user, pageable).getContent();
    }

    @Transactional(readOnly = true)
    public List<Payment> getRecentPaymentsByAccount(Account account, int limit) {
        return paymentRepository.findByAccountOrderByCreatedAtDesc(account)
                .stream()
                .limit(limit)
                .toList();
    }

    @Transactional(readOnly = true)
    public long countPaymentsForUser(User user) {
        return paymentRepository.countByUser(user);
    }

    @Transactional(readOnly = true)
    public long countPendingPaymentsForUser(User user) {
        return paymentRepository.countByUserAndStatus(user, PaymentStatus.PENDING);
    }
}