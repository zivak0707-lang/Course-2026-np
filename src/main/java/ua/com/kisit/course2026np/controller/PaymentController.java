package ua.com.kisit.course2026np.controller;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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

    private static final Logger securityLog = LoggerFactory.getLogger("SECURITY");

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

    // ============= CLIENT: CANCEL OWN PENDING TRANSACTION =============

    @PostMapping("/dashboard/transactions/cancel")
    public String cancelTransaction(
            @RequestParam Long paymentId,
            @RequestParam(required = false) String reason,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User user = getCurrentUser(session);
        try {
            Payment payment = paymentService.getPaymentById(paymentId)
                    .orElseThrow(() -> new IllegalArgumentException("Transaction not found"));

            // Ownership check: payment must belong to this user
            if (payment.getAccount() == null
                    || payment.getAccount().getCreditCard() == null
                    || !payment.getAccount().getCreditCard().getUser().getId().equals(user.getId())) {
                securityLog.warn("[ACCESS_DENIED_403] User id={} attempted to cancel payment id={} belonging to another user",
                        user.getId(), paymentId);
                throw new IllegalArgumentException("You can only cancel your own transactions");
            }

            String cancelledBy = "Client: " + user.getEmail() + " (id=" + user.getId() + ")";
            paymentService.cancelPayment(paymentId, cancelledBy, reason);
            log.info("[CANCEL_OK] Client id={} cancelled paymentId={} reason={}", user.getId(), paymentId, reason);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Transaction #" + paymentId + " has been cancelled");
        } catch (IllegalArgumentException e) {
            log.warn("[CANCEL_FAIL] userId={} paymentId={} reason={}", user.getId(), paymentId, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/dashboard/transactions";
    }

    // ============= CSV EXPORT (user-scoped) =============

    @GetMapping(value = "/api/payments/export/csv", produces = "text/csv;charset=UTF-8")
    public ResponseEntity<String> exportTransactionsCsv(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        User user = userRepository.findById(userId).orElse(null);
        if (user == null || !Boolean.TRUE.equals(user.getIsActive())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        List<Payment> all = paymentService.getPaymentsForUser(user, null, null, null, 0, Integer.MAX_VALUE).getContent();

        StringBuilder sb = new StringBuilder();
        sb.append("Transaction ID,Date,Type,Status,Amount,Sender,Recipient,Description\n");
        for (Payment p : all) {
            sb.append(csv(p.getTransactionId())).append(',')
              .append(csv(p.getCreatedAt() != null ? p.getCreatedAt().toString() : "")).append(',')
              .append(csv(p.getType() != null ? p.getType().name() : "")).append(',')
              .append(csv(p.getStatus() != null ? p.getStatus().name() : "")).append(',')
              .append(csv(p.getAmount() != null ? p.getAmount().toPlainString() : "")).append(',')
              .append(csv(p.getSenderAccount())).append(',')
              .append(csv(p.getRecipientAccount())).append(',')
              .append(csv(p.getDescription())).append('\n');
        }

        return ResponseEntity.ok()
                .header("Content-Disposition", "attachment; filename=\"transactions.csv\"")
                .body(sb.toString());
    }

    private static String csv(String s) {
        if (s == null) return "";
        boolean needsQuote = s.contains(",") || s.contains("\"") || s.contains("\n") || s.contains("\r");
        String escaped = s.replace("\"", "\"\"");
        return needsQuote ? "\"" + escaped + "\"" : escaped;
    }

    // ============= AJAX: валідація рахунку отримувача =============

    /**
     * GET /api/accounts/validate?number=452184...
     * Повертає інформацію про власника рахунку для UI підтвердження
     */
    @GetMapping("/api/accounts/validate")
    @ResponseBody
    public ResponseEntity<AccountValidationResponse> validateAccount(
            @RequestParam String number,
            HttpSession session
    ) {
        if (number == null || number.isBlank()) {
            return ResponseEntity.ok(new AccountValidationResponse(false, null, null, null));
        }

        User currentUser = getCurrentUser(session);

        return accountService.getAccountByNumber(number.trim())
                .map(account -> {
                    String acctNum = account.getAccountNumber();
                    String masked = "****" + acctNum.substring(Math.max(0, acctNum.length() - 4));

                    String ownerName = "Unknown";
                    if (account.getCreditCard() != null && account.getCreditCard().getUser() != null) {
                        User owner = account.getCreditCard().getUser();
                        String lastName = owner.getLastName();
                        ownerName = owner.getFirstName() + " "
                                + (lastName != null && !lastName.isEmpty() ? lastName.charAt(0) + "." : "");
                        if (owner.getId().equals(currentUser.getId())) {
                            ownerName = "Ваш рахунок";
                        }
                    }

                    String status = account.getStatus() != null ? account.getStatus().name() : "UNKNOWN";
                    return ResponseEntity.ok(new AccountValidationResponse(true, ownerName, masked, status));
                })
                .orElse(ResponseEntity.ok(new AccountValidationResponse(false, null, null, null)));
    }

    // ============= DTO CLASSES =============

    @Getter
    @Setter
    public static class AccountValidationResponse {
        private boolean valid;
        private String ownerName;
        private String maskedNumber;
        private String status;

        public AccountValidationResponse(boolean valid, String ownerName, String maskedNumber, String status) {
            this.valid = valid;
            this.ownerName = ownerName;
            this.maskedNumber = maskedNumber;
            this.status = status;
        }
    }
}