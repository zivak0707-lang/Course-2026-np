package ua.com.kisit.course2026np.controller;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.AccountStatus;
import ua.com.kisit.course2026np.entity.CreditCard;
import ua.com.kisit.course2026np.entity.Payment;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.repository.CreditCardRepository;
import ua.com.kisit.course2026np.repository.UserRepository;
import ua.com.kisit.course2026np.service.AccountService;
import ua.com.kisit.course2026np.service.PaymentService;

import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import java.security.SecureRandom;

/**
 * REST контролер для роботи з рахунками
 */
@Controller
@RequestMapping("/api/accounts")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;
    private final PaymentService paymentService;
    private final CreditCardRepository creditCardRepository;
    private final UserRepository userRepository;

    private static final String SUCCESS_MESSAGE = "successMessage";
    private static final String ERROR_MESSAGE = "errorMessage";
    private static final String REDIRECT_ACCOUNTS = "redirect:/dashboard/accounts";

    /**
     * CREATE - Створити новий рахунок через веб-інтерфейс
     * POST /api/accounts/create
     */
    @PostMapping("/create")
    public String createAccountWeb(
            @RequestParam String accountType,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) return "redirect:/login";
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new IllegalStateException("User not found"));

            // Знаходимо першу активну картку користувача
            List<CreditCard> userCards = creditCardRepository.findByUser(user);
            if (userCards.isEmpty()) {
                throw new IllegalStateException("У користувача немає карток. Спочатку додайте картку.");
            }

            CreditCard card = userCards.stream()
                    .filter(c -> accountService.getAccountByCardId(c.getId()).isEmpty())
                    .findFirst()
                    .orElseThrow(() ->
                            new IllegalStateException("Усі картки вже мають рахунки.")
                    );

            // Генеруємо номер рахунку залежно від типу
            String accountNumber = generateAccountNumber(accountType);

            // Створюємо рахунок
            Account account = Account.builder()
                    .accountNumber(accountNumber)
                    .accountName(accountType + " Account")
                    .balance(BigDecimal.ZERO)
                    .status(AccountStatus.ACTIVE)
                    .creditCard(card)
                    .build();

            accountService.createAccount(account);

            redirectAttributes.addFlashAttribute(SUCCESS_MESSAGE,
                    "Рахунок типу " + accountType + " успішно створено!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(ERROR_MESSAGE,
                    "Помилка при створенні рахунку: " + e.getMessage());
        }

        return REDIRECT_ACCOUNTS;
    }

    /**
     * GET - Отримати деталі акаунту з останніми транзакціями
     * GET /api/accounts/{id}/details
     */
    @GetMapping("/{id}/details")
    @ResponseBody
    public ResponseEntity<AccountDetailsResponse> getAccountDetails(@PathVariable Long id) {
        try {
            Account account = accountService.getAccountById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено"));

            List<Payment> recentPayments = paymentService.getRecentPaymentsByAccount(account, 5);

            // Map Payment entities to flat DTO to avoid Jackson circular reference:
            // Payment.account -> Account.payments -> Payment... causes infinite nesting
            List<AccountDetailsResponse.PaymentSummary> summaries = recentPayments.stream()
                    .map(p -> new AccountDetailsResponse.PaymentSummary(
                            p.getId(),
                            p.getAmount(),
                            p.getType() != null ? p.getType().name() : null,
                            p.getStatus() != null ? p.getStatus().name() : null,
                            p.getDescription(),
                            p.getRecipientAccount(),
                            p.getSenderAccount(),
                            p.getCreatedAt() != null ? p.getCreatedAt().toString() : null
                    ))
                    .toList();

            AccountDetailsResponse response = new AccountDetailsResponse();
            response.setAccountNumber(account.getAccountNumber());
            response.setAccountName(account.getAccountName());
            response.setStatus(account.getStatus().name());
            response.setBalance(account.getBalance());
            response.setRecentActivity(summaries);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * UPDATE - Заблокувати рахунок
     * POST /api/accounts/{id}/block
     */
    @PostMapping("/{id}/block")
    public String blockAccountWeb(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {
        try {
            accountService.blockAccount(id);
            redirectAttributes.addFlashAttribute(SUCCESS_MESSAGE, "Рахунок заблоковано!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(ERROR_MESSAGE,
                    "Помилка при блокуванні: " + e.getMessage());
        }
        return REDIRECT_ACCOUNTS;
    }

    /**
     * UPDATE - Розблокувати рахунок
     * POST /api/accounts/{id}/unblock
     */
    @PostMapping("/{id}/unblock")
    public String unblockAccountWeb(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {
        try {
            accountService.unblockAccount(id);
            redirectAttributes.addFlashAttribute(SUCCESS_MESSAGE, "Рахунок розблоковано!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(ERROR_MESSAGE,
                    "Помилка при розблокуванні: " + e.getMessage());
        }
        return REDIRECT_ACCOUNTS;
    }

    /**
     * DELETE - Видалити рахунок
     * POST /api/accounts/{id}/delete
     */
    @PostMapping("/{id}/delete")
    public String deleteAccountWeb(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {
        try {
            // Перевіряємо чи баланс = 0
            Account account = accountService.getAccountById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено"));

            if (account.getBalance().compareTo(BigDecimal.ZERO) > 0) {
                throw new IllegalStateException("Неможливо видалити рахунок з залишком коштів!");
            }

            accountService.deleteAccount(id);
            redirectAttributes.addFlashAttribute(SUCCESS_MESSAGE, "Рахунок видалено!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(ERROR_MESSAGE,
                    "Помилка при видаленні: " + e.getMessage());
        }
        return REDIRECT_ACCOUNTS;
    }

    // ============= HELPER METHODS =============

    /**
     * Генерація номера рахунку на основі типу
     */
    private String generateAccountNumber(String accountType) {
        SecureRandom random = new SecureRandom();

        // Enhanced switch expression (Java 14+)
        String prefix = switch (accountType.toLowerCase()) {
            case "checking" -> "4521"; // Checking accounts
            case "savings" -> "5432";  // Savings accounts
            case "business" -> "2222"; // Business accounts
            default -> "4521";
        };

        // Генеруємо решту 16 цифр
        StringBuilder accountNumber = new StringBuilder(prefix);
        for (int i = 0; i < 16; i++) {
            accountNumber.append(random.nextInt(10));
        }

        return accountNumber.toString();
    }



    // ============= DTO CLASSES =============

    /**
     * Safe DTO for account details.
     * Uses flat PaymentSummary instead of Payment entity
     * to break the Payment->Account->Payment circular reference.
     */
    @Setter
    @Getter
    public static class AccountDetailsResponse {
        private String accountNumber;
        private String accountName;  // used by JS to update modal title
        private String status;
        private BigDecimal balance;
        private List<PaymentSummary> recentActivity;

        /** Flat payment DTO — no reference back to Account */
        @Setter
        @Getter
        @lombok.AllArgsConstructor
        @lombok.NoArgsConstructor
        public static class PaymentSummary {
            private Long id;
            private BigDecimal amount;
            private String type;
            private String status;
            private String description;
            private String recipientAccount;
            private String senderAccount;
            private String createdAt;
        }
    }
}