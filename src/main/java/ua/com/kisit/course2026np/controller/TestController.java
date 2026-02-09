package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.service.AccountService;
import ua.com.kisit.course2026np.service.UserService;

import java.math.BigDecimal;
import java.util.List;

/**
 * Контролер для тестування CRUD операцій
 */
@RestController
@RequestMapping("/api/test")
@RequiredArgsConstructor
public class TestController {

    private final UserService userService;
    private final AccountService accountService;

    // ============= USER ENDPOINTS =============

    /**
     * GET <a href="http://localhost:8080/api/test/users">...</a>
     */
    @GetMapping("/users")
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    /**
     * GET <a href="http://localhost:8080/api/test/users/1">...</a>
     */
    @GetMapping("/users/{id}")
    public User getUserById(@PathVariable Long id) {
        return userService.getUserById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    /**
     * POST <a href="http://localhost:8080/api/test/users">...</a>
     * Body: {"firstName": "Іван", "lastName": "Петренко", "email": "ivan@test.com", "password": "123"}
     */
    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        return userService.createUser(user);
    }

    /**
     * DELETE <a href="http://localhost:8080/api/test/users/1">...</a>
     */
    @DeleteMapping("/users/{id}")
    public String deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return "User deleted";
    }

    // ============= ACCOUNT ENDPOINTS =============

    /**
     * GET <a href="http://localhost:8080/api/test/accounts">...</a>
     */
    @GetMapping("/accounts")
    public List<Account> getAllAccounts() {
        return accountService.getAllAccounts();
    }

    /**
     * GET <a href="http://localhost:8080/api/test/accounts/1/balance">...</a>
     */
    @GetMapping("/accounts/{id}/balance")
    public BigDecimal getBalance(@PathVariable Long id) {
        return accountService.getBalance(id);
    }

    /**
     * POST <a href="http://localhost:8080/api/test/accounts/1/deposit">...</a>
     * Body: {"amount": 500.00}
     */
    @PostMapping("/accounts/{id}/deposit")
    public Account deposit(@PathVariable Long id, @RequestBody DepositRequest request) {
        return accountService.depositToAccount(id, request.amount);
    }

    /**
     * POST <a href="http://localhost:8080/api/test/accounts/1/withdraw">...</a>
     * Body: {"amount": 200.00}
     */
    @PostMapping("/accounts/{id}/withdraw")
    public Account withdraw(@PathVariable Long id, @RequestBody WithdrawRequest request) {
        return accountService.withdrawFromAccount(id, request.amount);
    }

    // ============= DTO CLASSES =============

    public static class DepositRequest {
        public BigDecimal amount;
    }

    public static class WithdrawRequest {
        public BigDecimal amount;
    }
}