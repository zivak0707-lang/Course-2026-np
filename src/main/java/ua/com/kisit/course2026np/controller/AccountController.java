package ua.com.kisit.course2026np.controller;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.AccountStatus;
import ua.com.kisit.course2026np.service.AccountService;

import java.math.BigDecimal;
import java.util.List;

/**
 * REST контролер для роботи з рахунками
 */
@RestController
@RequestMapping("/api/accounts")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    /**
     * CREATE - Створити новий рахунок
     * POST <a href="http://localhost:8080/api/accounts">...</a>
     * Body: {
     *   "accountNumber": "12345678901234567890",
     *   "balance": 1000.00,
     *   "status": "ACTIVE",
     *   "creditCard": {"id": 1}
     * }
     */
    @PostMapping
    public ResponseEntity<Account> createAccount(@RequestBody Account account) {
        Account created = accountService.createAccount(account);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * READ - Отримати всі рахунки
     * GET <a href="http://localhost:8080/api/accounts">...</a>
     */
    @GetMapping
    public ResponseEntity<List<Account>> getAllAccounts() {
        List<Account> accounts = accountService.getAllAccounts();
        return ResponseEntity.ok(accounts);
    }

    /**
     * READ - Отримати рахунок за ID
     * GET <a href="http://localhost:8080/api/accounts/1">...</a>
     */
    @GetMapping("/{id}")
    public ResponseEntity<Account> getAccountById(@PathVariable Long id) {
        return accountService.getAccountById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати рахунок за номером
     * GET <a href="http://localhost:8080/api/accounts/number/12345678901234567890">...</a>
     */
    @GetMapping("/number/{accountNumber}")
    public ResponseEntity<Account> getAccountByNumber(@PathVariable String accountNumber) {
        return accountService.getAccountByNumber(accountNumber)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати рахунок за ID картки
     * GET <a href="http://localhost:8080/api/accounts/card/1">...</a>
     */
    @GetMapping("/card/{cardId}")
    public ResponseEntity<Account> getAccountByCardId(@PathVariable Long cardId) {
        return accountService.getAccountByCardId(cardId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати рахунки за статусом
     * GET <a href="http://localhost:8080/api/accounts/status/ACTIVE">...</a>
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<Account>> getAccountsByStatus(@PathVariable AccountStatus status) {
        List<Account> accounts = accountService.getAccountsByStatus(status);
        return ResponseEntity.ok(accounts);
    }

    /**
     * READ - Отримати баланс рахунку
     * GET <a href="http://localhost:8080/api/accounts/1/balance">...</a>
     */
    @GetMapping("/{id}/balance")
    public ResponseEntity<BigDecimal> getBalance(@PathVariable Long id) {
        BigDecimal balance = accountService.getBalance(id);
        return ResponseEntity.ok(balance);
    }

    /**
     * UPDATE - Поповнити рахунок
     * POST <a href="http://localhost:8080/api/accounts/1/deposit">...</a>
     * Body: {"amount": 500.00}
     */
    @PostMapping("/{id}/deposit")
    public ResponseEntity<Account> deposit(
            @PathVariable Long id,
            @RequestBody DepositRequest request
    ) {
        Account updated = accountService.depositToAccount(id, request.getAmount());
        return ResponseEntity.ok(updated);
    }

    /**
     * UPDATE - Зняти кошти з рахунку
     * POST <a href="http://localhost:8080/api/accounts/1/withdraw">...</a>
     * Body: {"amount": 200.00}
     */
    @PostMapping("/{id}/withdraw")
    public ResponseEntity<Account> withdraw(
            @PathVariable Long id,
            @RequestBody WithdrawRequest request
    ) {
        Account updated = accountService.withdrawFromAccount(id, request.getAmount());
        return ResponseEntity.ok(updated);
    }

    /**
     * UPDATE - Заблокувати рахунок
     * POST <a href="http://localhost:8080/api/accounts/1/block">...</a>
     */
    @PostMapping("/{id}/block")
    public ResponseEntity<Void> blockAccount(@PathVariable Long id) {
        accountService.blockAccount(id);
        return ResponseEntity.ok().build();
    }

    /**
     * UPDATE - Розблокувати рахунок
     * POST <a href="http://localhost:8080/api/accounts/1/unblock">...</a>
     */
    @PostMapping("/{id}/unblock")
    public ResponseEntity<Void> unblockAccount(@PathVariable Long id) {
        accountService.unblockAccount(id);
        return ResponseEntity.ok().build();
    }

    /**
     * DELETE - Видалити рахунок
     * DELETE <a href="http://localhost:8080/api/accounts/1">...</a>
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAccount(@PathVariable Long id) {
        accountService.deleteAccount(id);
        return ResponseEntity.noContent().build();
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
}
