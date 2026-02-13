package ua.com.kisit.course2026np.controller;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.UserRepository;
import ua.com.kisit.course2026np.service.AccountService;
import ua.com.kisit.course2026np.service.PaymentService;

import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 * Controller for payment operations
 * Handles both REST API endpoints and web pages
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;
    private final AccountService accountService;
    private final UserRepository userRepository;

    // ============= HELPER METHOD (ідентичний до ClientController) =============

    private User getCurrentUser(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            return userRepository.findById(userId)
                    .orElseGet(this::getFallbackUser);
        }
        return getFallbackUser();
    }

    private User getFallbackUser() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == UserRole.CLIENT)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("No CLIENT user found in DB"));
    }

    // ============= WEB PAGE: TRANSACTIONS =============

    /**
     * Display transactions history page with filters and pagination
     * GET /dashboard/transactions
     *
     * ВАЖЛИВО: Цей метод НЕ конфліктує з ClientController.transactions()
     * бо тут ми додаємо параметри фільтрації та пагінації
     */
    @GetMapping("/dashboard/transactions")
    public String transactionsPage(
            HttpSession session,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String status,
            Model model
    ) {
        User user = getCurrentUser(session);

        // Parse enum values
        PaymentType paymentType = null;
        PaymentStatus paymentStatus = null;

        try {
            if (type != null && !type.trim().isEmpty() && !type.equalsIgnoreCase("ALL")) {
                paymentType = PaymentType.valueOf(type.toUpperCase());
            }
        } catch (IllegalArgumentException e) {
            log.warn("Invalid payment type: {}", type);
        }

        try {
            if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
                paymentStatus = PaymentStatus.valueOf(status.toUpperCase());
            }
        } catch (IllegalArgumentException e) {
            log.warn("Invalid payment status: {}", status);
        }

        // Get paginated payments
        Page<Payment> paymentsPage = paymentService.getPaymentsForUser(
                user,
                search,
                paymentType,
                paymentStatus,
                page,
                size
        );

        // Add attributes to model
        model.addAttribute("user", user);
        model.addAttribute("payments", paymentsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", paymentsPage.getTotalPages());
        model.addAttribute("totalItems", paymentsPage.getTotalElements());
        model.addAttribute("pageSize", size);
        model.addAttribute("hasNext", paymentsPage.hasNext());
        model.addAttribute("hasPrevious", paymentsPage.hasPrevious());

        // Keep filter values for form
        model.addAttribute("searchQuery", search != null ? search : "");
        model.addAttribute("selectedType", type != null ? type : "ALL");
        model.addAttribute("selectedStatus", status != null ? status : "ALL");

        // Add enums for dropdowns
        model.addAttribute("paymentTypes", PaymentType.values());
        model.addAttribute("paymentStatuses", PaymentStatus.values());

        log.info("Transactions page accessed by user: {} (page: {}, size: {})",
                user.getEmail(), page, size);

        return "client/transactions";
    }

    // ============= REST API ENDPOINTS =============

    /**
     * CREATE - Create new payment (without execution)
     * POST http://localhost:8080/api/payments
     */
    @PostMapping("/api/payments")
    @ResponseBody
    public ResponseEntity<Payment> createPayment(@RequestBody Payment payment) {
        Payment created = paymentService.createPayment(payment);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * CREATE - Execute payment (deduct funds)
     * POST http://localhost:8080/api/payments/execute
     */
    @PostMapping("/api/payments/execute")
    @ResponseBody
    public ResponseEntity<Payment> executePayment(@RequestBody ExecutePaymentRequest request) {
        Payment executed = paymentService.executePayment(
                request.getAccountId(),
                request.getPayment()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(executed);
    }

    /**
     * CREATE - Execute replenishment
     * POST http://localhost:8080/api/payments/replenish
     */
    @PostMapping("/api/payments/replenish")
    @ResponseBody
    public ResponseEntity<Payment> executeReplenishment(@RequestBody ExecutePaymentRequest request) {
        Payment executed = paymentService.executeReplenishment(
                request.getAccountId(),
                request.getPayment()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(executed);
    }

    /**
     * READ - Get all payments
     * GET http://localhost:8080/api/payments
     */
    @GetMapping("/api/payments")
    @ResponseBody
    public ResponseEntity<List<Payment>> getAllPayments() {
        List<Payment> payments = paymentService.getAllPayments();
        return ResponseEntity.ok(payments);
    }

    /**
     * READ - Get payment by ID
     * GET http://localhost:8080/api/payments/1
     */
    @GetMapping("/api/payments/{id}")
    @ResponseBody
    public ResponseEntity<Payment> getPaymentById(@PathVariable Long id) {
        return paymentService.getPaymentById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Get payments by account
     * GET http://localhost:8080/api/payments/account/1
     */
    @GetMapping("/api/payments/account/{accountId}")
    @ResponseBody
    public ResponseEntity<List<Payment>> getPaymentsByAccount(@PathVariable Long accountId) {
        Account account = accountService.getAccountById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));
        List<Payment> payments = paymentService.getPaymentsByAccount(account);
        return ResponseEntity.ok(payments);
    }

    /**
     * READ - Get payments by account (ordered)
     * GET http://localhost:8080/api/payments/account/1/ordered
     */
    @GetMapping("/api/payments/account/{accountId}/ordered")
    @ResponseBody
    public ResponseEntity<List<Payment>> getPaymentsByAccountOrdered(@PathVariable Long accountId) {
        Account account = accountService.getAccountById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));
        List<Payment> payments = paymentService.getPaymentsByAccountOrdered(account);
        return ResponseEntity.ok(payments);
    }

    /**
     * READ - Get payments by status
     * GET http://localhost:8080/api/payments/status/COMPLETED
     */
    @GetMapping("/api/payments/status/{status}")
    @ResponseBody
    public ResponseEntity<List<Payment>> getPaymentsByStatus(@PathVariable PaymentStatus status) {
        List<Payment> payments = paymentService.getPaymentsByStatus(status);
        return ResponseEntity.ok(payments);
    }

    /**
     * DELETE - Delete payment
     * DELETE http://localhost:8080/api/payments/1
     */
    @DeleteMapping("/api/payments/{id}")
    @ResponseBody
    public ResponseEntity<Void> deletePayment(@PathVariable Long id) {
        paymentService.deletePayment(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * COUNT - Count all payments
     * GET http://localhost:8080/api/payments/count
     */
    @GetMapping("/api/payments/count")
    @ResponseBody
    public ResponseEntity<Long> countPayments() {
        long count = paymentService.countPayments();
        return ResponseEntity.ok(count);
    }

    /**
     * COUNT - Count payments by status
     * GET http://localhost:8080/api/payments/count/status/COMPLETED
     */
    @GetMapping("/api/payments/count/status/{status}")
    @ResponseBody
    public ResponseEntity<Long> countPaymentsByStatus(@PathVariable PaymentStatus status) {
        long count = paymentService.countPaymentsByStatus(status);
        return ResponseEntity.ok(count);
    }

    // ============= DTO CLASSES =============

    @Setter
    @Getter
    public static class ExecutePaymentRequest {
        private Long accountId;
        private Payment payment;
    }
}