package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.PaymentRepository;
import ua.com.kisit.course2026np.repository.AccountRepository;
import ua.com.kisit.course2026np.repository.CreditCardRepository;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final AccountRepository accountRepository;
    private final CreditCardRepository creditCardRepository;

    // ============= ORIGINAL METHODS =============

    public Payment createPayment(Payment payment) {
        return paymentRepository.save(payment);
    }

    public Payment executePayment(Long accountId, Payment payment) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        if (account.getStatus() == AccountStatus.BLOCKED) {
            log.warn("[PAYMENT_FAIL] accountId={} amount={} reason=account_blocked",
                    accountId, payment.getAmount());
            payment.setAccount(account);
            payment.fail("Sender account is blocked");
            return paymentRepository.save(payment);
        }

        if (account.getBalance().compareTo(payment.getAmount()) < 0) {
            log.warn("[PAYMENT_FAIL] accountId={} amount={} balance={} reason=insufficient_funds",
                    accountId, payment.getAmount(), account.getBalance());
            payment.setAccount(account);
            payment.fail("Insufficient funds");
            return paymentRepository.save(payment);
        }

        account.setBalance(account.getBalance().subtract(payment.getAmount()));
        accountRepository.save(account);

        payment.setAccount(account);
        payment.setSenderAccount(account.getAccountNumber());
        payment.complete();
        Payment saved = paymentRepository.save(payment);
        log.info("[PAYMENT_OK] Payment completed: accountId={} amount={} txId={}",
                accountId, saved.getAmount(), saved.getTransactionId());
        return saved;
    }

    public Payment executeReplenishment(Long accountId, Payment payment) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        if (account.getStatus() == AccountStatus.BLOCKED) {
            log.warn("[REPLENISHMENT_FAIL] accountId={} amount={} reason=account_blocked",
                    accountId, payment.getAmount());
            payment.setAccount(account);
            payment.fail("Account is blocked");
            return paymentRepository.save(payment);
        }

        account.setBalance(account.getBalance().add(payment.getAmount()));
        accountRepository.save(account);

        payment.setAccount(account);
        payment.setRecipientAccount(account.getAccountNumber());
        payment.complete();
        Payment saved = paymentRepository.save(payment);
        log.info("[REPLENISHMENT_OK] accountId={} amount={} txId={}",
                accountId, saved.getAmount(), saved.getTransactionId());
        return saved;
    }

    @Transactional
    public Payment executeTransfer(Long senderAccountId, String recipientInput, Payment payment) {
        Account sender = accountRepository.findById(senderAccountId)
                .orElseThrow(() -> new IllegalArgumentException("Sender account not found"));

        Account recipient = findRecipientAccount(recipientInput);

        if (recipient == null) {
            log.warn("[TRANSFER_FAIL] senderAccountId={} amount={} reason=recipient_not_found recipient={}",
                    senderAccountId, payment.getAmount(), recipientInput);
            payment.setAccount(sender);
            payment.fail("Recipient account not found: " + recipientInput);
            return paymentRepository.save(payment);
        }

        if (sender.getId().equals(recipient.getId())) {
            log.warn("[TRANSFER_FAIL] senderAccountId={} amount={} reason=same_account",
                    senderAccountId, payment.getAmount());
            payment.setAccount(sender);
            payment.fail("Cannot transfer to the same account");
            return paymentRepository.save(payment);
        }

        if (sender.getStatus() == AccountStatus.BLOCKED) {
            log.warn("[TRANSFER_FAIL] senderAccountId={} amount={} reason=sender_account_blocked",
                    senderAccountId, payment.getAmount());
            payment.setAccount(sender);
            payment.fail("Sender account is blocked");
            return paymentRepository.save(payment);
        }

        if (recipient.getStatus() == AccountStatus.BLOCKED) {
            log.warn("[TRANSFER_FAIL] senderAccountId={} recipientId={} amount={} reason=recipient_account_blocked",
                    senderAccountId, recipient.getId(), payment.getAmount());
            payment.setAccount(sender);
            payment.fail("Recipient account is blocked");
            return paymentRepository.save(payment);
        }

        if (sender.getBalance().compareTo(payment.getAmount()) < 0) {
            log.warn("[TRANSFER_FAIL] senderAccountId={} amount={} balance={} reason=insufficient_funds",
                    senderAccountId, payment.getAmount(), sender.getBalance());
            payment.setAccount(sender);
            payment.fail("Insufficient funds");
            return paymentRepository.save(payment);
        }

        sender.setBalance(sender.getBalance().subtract(payment.getAmount()));
        accountRepository.save(sender);

        recipient.setBalance(recipient.getBalance().add(payment.getAmount()));
        accountRepository.save(recipient);

        payment.setAccount(sender);
        payment.setSenderAccount(sender.getAccountNumber());
        payment.setRecipientAccount(recipient.getAccountNumber());
        payment.complete();
        paymentRepository.save(payment);

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

        log.info("[TRANSFER_OK] Transfer completed: senderAccountId={} recipientAccountId={} amount={} txId={}",
                senderAccountId, recipient.getId(), payment.getAmount(), payment.getTransactionId());
        return payment;
    }

    private Account findRecipientAccount(String input) {
        if (input == null || input.isBlank()) return null;
        String cleaned = input.trim();
        Optional<Account> byAccountNumber = accountRepository.findByAccountNumber(cleaned);
        return byAccountNumber.orElseGet(() -> creditCardRepository.findByCardNumber(cleaned)
                .flatMap(accountRepository::findByCreditCard)
                .orElse(null));
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
