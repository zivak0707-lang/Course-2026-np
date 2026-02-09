package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.service.UserService;

import java.util.List;

/**
 * REST контролер для роботи з користувачами
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * CREATE - Створити нового користувача
     * POST <a href="http://localhost:8080/api/users">...</a>
     * Body: {
     *   "firstName": "Іван",
     *   "lastName": "Петренко",
     *   "email": "ivan@example.com",
     *   "password": "password123",
     *   "role": "CLIENT"
     * }
     */
    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        User created = userService.createUser(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * READ - Отримати всіх користувачів
     * GET <a href="http://localhost:8080/api/users">...</a>
     */
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    /**
     * READ - Отримати користувача за ID
     * GET <a href="http://localhost:8080/api/users/1">...</a>
     */
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userService.getUserById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати користувача за email
     * GET <a href="http://localhost:8080/api/users/email/ivan@example.com">...</a>
     */
    @GetMapping("/email/{email}")
    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
        return userService.getUserByEmail(email)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати користувачів за роллю
     * GET <a href="http://localhost:8080/api/users/role/CLIENT">...</a>
     */
    @GetMapping("/role/{role}")
    public ResponseEntity<List<User>> getUsersByRole(@PathVariable UserRole role) {
        List<User> users = userService.getUsersByRole(role);
        return ResponseEntity.ok(users);
    }

    /**
     * READ - Отримати активних користувачів
     * GET <a href="http://localhost:8080/api/users/active">...</a>
     */
    @GetMapping("/active")
    public ResponseEntity<List<User>> getActiveUsers() {
        List<User> users = userService.getActiveUsers();
        return ResponseEntity.ok(users);
    }

    /**
     * UPDATE - Оновити користувача
     * PUT <a href="http://localhost:8080/api/users/1">...</a>
     * Body: {
     *   "firstName": "Іван",
     *   "lastName": "Сидоренко",
     *   "email": "ivan.new@example.com"
     * }
     */
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(
            @PathVariable Long id,
            @RequestBody User user
    ) {
        User updated = userService.updateUser(id, user);
        return ResponseEntity.ok(updated);
    }

    /**
     * UPDATE - Активувати користувача
     * POST <a href="http://localhost:8080/api/users/1/activate">...</a>
     */
    @PostMapping("/{id}/activate")
    public ResponseEntity<Void> activateUser(@PathVariable Long id) {
        userService.activateUser(id);
        return ResponseEntity.ok().build();
    }

    /**
     * UPDATE - Деактивувати користувача
     * POST <a href="http://localhost:8080/api/users/1/deactivate">...</a>
     */
    @PostMapping("/{id}/deactivate")
    public ResponseEntity<Void> deactivateUser(@PathVariable Long id) {
        userService.deactivateUser(id);
        return ResponseEntity.ok().build();
    }

    /**
     * DELETE - Видалити користувача
     * DELETE <a href="http://localhost:8080/api/users/1">...</a>
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * COUNT - Підрахувати всіх користувачів
     * GET <a href="http://localhost:8080/api/users/count">...</a>
     */
    @GetMapping("/count")
    public ResponseEntity<Long> countUsers() {
        long count = userService.countUsers();
        return ResponseEntity.ok(count);
    }

    /**
     * COUNT - Підрахувати активних користувачів
     * GET <a href="http://localhost:8080/api/users/count/active">...</a>
     */
    @GetMapping("/count/active")
    public ResponseEntity<Long> countActiveUsers() {
        long count = userService.countActiveUsers();
        return ResponseEntity.ok(count);
    }
}