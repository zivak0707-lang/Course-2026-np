package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.Payment;
import ua.com.kisit.course2026np.entity.PaymentStatus;
import ua.com.kisit.course2026np.service.AccountService;
import ua.com.kisit.course2026np.service.PaymentService;

import java.util.List;

/**
 * REST контролер для роботи з платежами
 */
@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;
    private final AccountService accountService;

    /**
     * CREATE - Створити новий платіж (без виконання)
     * POST http://localhost:8080/api/payments
     * Body: {
     *   "account": {"id": 1},
     *   "amount": 100.00,
     *   "type": "PAYMENT",
     *   "description": "Оплата послуг",
     *   "recipientAccount": "98765432109876543210"
     * }
     */
    @PostMapping
    public ResponseEntity<Payment> createPayment(@RequestBody Payment payment) {
        Payment created = paymentService.createPayment(payment);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * CREATE - Виконати платіж (списання коштів)
     * POST http://localhost:8080/api/payments/execute
     * Body: {
     *   "accountId": 1,
     *   "payment": {
     *     "amount": 100.00,
     *     "type": "PAYMENT",
     *     "description": "Оплата послуг",
     *     "recipientAccount": "98765432109876543210"
     *   }
     * }
     */
    @PostMapping("/execute")
    public ResponseEntity<Payment> executePayment(@RequestBody ExecutePaymentRequest request) {
        Payment executed = paymentService.executePayment(
                request.getAccountId(),
                request.getPayment()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(executed);
    }

    /**
     * CREATE - Виконати поповнення
     * POST http://localhost:8080/api/payments/replenish
     * Body: {
     *   "accountId": 1,
     *   "payment": {
     *     "amount": 500.00,
     *     "type": "REPLENISHMENT",
     *     "description": "Поповнення рахунку",
     *     "senderAccount": "11111111111111111111"
     *   }
     * }
     */
    @PostMapping("/replenish")
    public ResponseEntity<Payment> executeReplenishment(@RequestBody ExecutePaymentRequest request) {
        Payment executed = paymentService.executeReplenishment(
                request.getAccountId(),
                request.getPayment()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(executed);
    }

    /**
     * READ - Отримати всі платежі
     * GET http://localhost:8080/api/payments
     */
    @GetMapping
    public ResponseEntity<List<Payment>> getAllPayments() {
        List<Payment> payments = paymentService.getAllPayments();
        return ResponseEntity.ok(payments);
    }

    /**
     * READ - Отримати платіж за ID
     * GET http://localhost:8080/api/payments/1
     */
    @GetMapping("/{id}")
    public ResponseEntity<Payment> getPaymentById(@PathVariable Long id) {
        return paymentService.getPaymentById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати платежі рахунку
     * GET http://localhost:8080/api/payments/account/1
     */
    @GetMapping("/account/{accountId}")
    public ResponseEntity<List<Payment>> getPaymentsByAccount(@PathVariable Long accountId) {
        Account account = accountService.getAccountById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено"));
        List<Payment> payments = paymentService.getPaymentsByAccount(account);
        return ResponseEntity.ok(payments);
    }

    /**
     * READ - Отримати платежі рахунку (відсортовані)
     * GET http://localhost:8080/api/payments/account/1/ordered
     */
    @GetMapping("/account/{accountId}/ordered")
    public ResponseEntity<List<Payment>> getPaymentsByAccountOrdered(@PathVariable Long accountId) {
        Account account = accountService.getAccountById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено"));
        List<Payment> payments = paymentService.getPaymentsByAccountOrdered(account);
        return ResponseEntity.ok(payments);
    }

    /**
     * READ - Отримати платежі за статусом
     * GET http://localhost:8080/api/payments/status/COMPLETED
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<Payment>> getPaymentsByStatus(@PathVariable PaymentStatus status) {
        List<Payment> payments = paymentService.getPaymentsByStatus(status);
        return ResponseEntity.ok(payments);
    }

    /**
     * DELETE - Видалити платіж
     * DELETE http://localhost:8080/api/payments/1
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePayment(@PathVariable Long id) {
        paymentService.deletePayment(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * COUNT - Підрахувати всі платежі
     * GET http://localhost:8080/api/payments/count
     */
    @GetMapping("/count")
    public ResponseEntity<Long> countPayments() {
        long count = paymentService.countPayments();
        return ResponseEntity.ok(count);
    }

    /**
     * COUNT - Підрахувати платежі за статусом
     * GET http://localhost:8080/api/payments/count/status/COMPLETED
     */
    @GetMapping("/count/status/{status}")
    public ResponseEntity<Long> countPaymentsByStatus(@PathVariable PaymentStatus status) {
        long count = paymentService.countPaymentsByStatus(status);
        return ResponseEntity.ok(count);
    }

    // ============= DTO CLASSES =============

    public static class ExecutePaymentRequest {
        private Long accountId;
        private Payment payment;

        public Long getAccountId() {
            return accountId;
        }

        public void setAccountId(Long accountId) {
            this.accountId = accountId;
        }

        public Payment getPayment() {
            return payment;
        }

        public void setPayment(Payment payment) {
            this.payment = payment;
        }
    }
}