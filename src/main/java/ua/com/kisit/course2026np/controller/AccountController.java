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
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.CreditCardRepository;
import ua.com.kisit.course2026np.repository.UserRepository;
import ua.com.kisit.course2026np.service.AccountService;
import ua.com.kisit.course2026np.service.PaymentService;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

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

    /**
     * CREATE - Створити новий рахунок через веб-інтерфейс
     * POST /api/accounts/create
     */
    @PostMapping("/create")
    public String createAccountWeb(
            @RequestParam String accountType,
            RedirectAttributes redirectAttributes
    ) {
        try {
            User user = getDemoUser();

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
            // Беремо першу картку

            // Генеруємо номер рахунку залежно від типу
            String accountNumber = generateAccountNumber(accountType);

            // Створюємо рахунок
            Account account = Account.builder()
                    .accountNumber(accountNumber)
                    .accountName(accountType + " Account") // === ДОДАНО: Заповнюємо обов'язкове поле ===
                    .balance(BigDecimal.ZERO)
                    .status(AccountStatus.ACTIVE)
                    .creditCard(card)
                    .build();

            accountService.createAccount(account);

            redirectAttributes.addFlashAttribute("successMessage",
                    "Рахунок типу " + accountType + " успішно створено!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Помилка при створенні рахунку: " + e.getMessage());
        }

        return "redirect:/dashboard/accounts";
    }

    /**
     * 🆕 GET - Отримати деталі акаунту з останніми транзакціями
     * GET /api/accounts/{id}/details
     */
    @GetMapping("/{id}/details")
    @ResponseBody
    public ResponseEntity<AccountDetailsResponse> getAccountDetails(@PathVariable Long id) {
        try {
            // Знаходимо акаунт
            Account account = accountService.getAccountById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено"));

            // Отримуємо останні 5 транзакцій
            List<Payment> recentPayments = paymentService.getRecentPaymentsByAccount(account, 5);

            // Формуємо відповідь
            AccountDetailsResponse response = new AccountDetailsResponse();
            response.setAccountNumber(account.getAccountNumber());
            response.setStatus(account.getStatus().name());
            response.setBalance(account.getBalance());
            response.setRecentActivity(recentPayments);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
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
            redirectAttributes.addFlashAttribute("successMessage", "Рахунок заблоковано!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Помилка при блокуванні: " + e.getMessage());
        }
        return "redirect:/dashboard/accounts";
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
            redirectAttributes.addFlashAttribute("successMessage", "Рахунок розблоковано!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Помилка при розблокуванні: " + e.getMessage());
        }
        return "redirect:/dashboard/accounts";
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
            redirectAttributes.addFlashAttribute("successMessage", "Рахунок видалено!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Помилка при видаленні: " + e.getMessage());
        }
        return "redirect:/dashboard/accounts";
    }

    // ============= HELPER METHODS =============

    /**
     * Генерація номера рахунку на основі типу
     */
    private String generateAccountNumber(String accountType) {
        Random random = new Random();
        String prefix;

        switch (accountType.toLowerCase()) {
            case "checking":
                prefix = "4521"; // Checking accounts
                break;
            case "savings":
                prefix = "5432"; // Savings accounts
                break;
            case "business":
                prefix = "2222"; // Business accounts
                break;
            default:
                prefix = "4521";
        }

        // Генеруємо решту 16 цифр
        StringBuilder accountNumber = new StringBuilder(prefix);
        for (int i = 0; i < 16; i++) {
            accountNumber.append(random.nextInt(10));
        }

        return accountNumber.toString();
    }

    /**
     * Отримати демо-користувача
     */
    private User getDemoUser() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == UserRole.CLIENT)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("User not found"));
    }

    // ============= REST API ENDPOINTS (для майбутнього використання) =============

    /**
     * CREATE - Створити новий рахунок (REST API)
     * POST /api/accounts
     */
    @PostMapping
    @ResponseBody
    public ResponseEntity<Account> createAccount(@RequestBody Account account) {
        Account created = accountService.createAccount(account);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * READ - Отримати всі рахунки
     * GET /api/accounts
     */
    @GetMapping
    @ResponseBody
    public ResponseEntity<List<Account>> getAllAccounts() {
        List<Account> accounts = accountService.getAllAccounts();
        return ResponseEntity.ok(accounts);
    }

    /**
     * READ - Отримати рахунок за ID
     * GET /api/accounts/{id}
     */
    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<Account> getAccountById(@PathVariable Long id) {
        return accountService.getAccountById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати рахунок за номером
     * GET /api/accounts/number/{accountNumber}
     */
    @GetMapping("/number/{accountNumber}")
    @ResponseBody
    public ResponseEntity<Account> getAccountByNumber(@PathVariable String accountNumber) {
        return accountService.getAccountByNumber(accountNumber)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати баланс рахунку
     * GET /api/accounts/{id}/balance
     */
    @GetMapping("/{id}/balance")
    @ResponseBody
    public ResponseEntity<BigDecimal> getBalance(@PathVariable Long id) {
        BigDecimal balance = accountService.getBalance(id);
        return ResponseEntity.ok(balance);
    }

    /**
     * UPDATE - Поповнити рахунок
     * POST /api/accounts/{id}/deposit
     */
    @PostMapping("/{id}/deposit")
    @ResponseBody
    public ResponseEntity<Account> deposit(
            @PathVariable Long id,
            @RequestBody DepositRequest request
    ) {
        Account updated = accountService.depositToAccount(id, request.getAmount());
        return ResponseEntity.ok(updated);
    }

    /**
     * UPDATE - Зняти кошти з рахунку
     * POST /api/accounts/{id}/withdraw
     */
    @PostMapping("/{id}/withdraw")
    @ResponseBody
    public ResponseEntity<Account> withdraw(
            @PathVariable Long id,
            @RequestBody WithdrawRequest request
    ) {
        Account updated = accountService.withdrawFromAccount(id, request.getAmount());
        return ResponseEntity.ok(updated);
    }

    // ============= DTO CLASSES =============

    @Setter
    @Getter
    public static class DepositRequest {
        private BigDecimal amount;
    }

    @Setter
    @Getter
    public static class WithdrawRequest {
        private BigDecimal amount;
    }

    /**
     * 🆕 DTO для деталей акаунту з транзакціями
     */
    @Setter
    @Getter
    public static class AccountDetailsResponse {
        private String accountNumber;
        private String status;
        private BigDecimal balance;
        private List<Payment> recentActivity;
    }
}