package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.entity.CreditCard;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.service.CreditCardService;
import ua.com.kisit.course2026np.service.UserService;

import java.util.List;

/**
 * REST контролер для роботи з кредитними картками
 */
@RestController
@RequestMapping("/api/cards")
@RequiredArgsConstructor
public class CreditCardController {

    private final CreditCardService creditCardService;
    private final UserService userService;

    /**
     * CREATE - Створити нову кредитну карту
     * POST <a href="http://localhost:8080/api/cards">...</a>
     * Body: {
     *   "cardNumber": "1234567890123456",
     *   "cardholderName": "IVAN PETRENKO",
     *   "expiryDate": "2027-12-31",
     *   "cvv": "123",
     *   "user": {"id": 1}
     * }
     */
    @PostMapping
    public ResponseEntity<CreditCard> createCreditCard(@RequestBody CreditCard card) {
        CreditCard created = creditCardService.createCreditCard(card);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * READ - Отримати всі кредитні картки
     * GET <a href="http://localhost:8080/api/cards">...</a>
     */
    @GetMapping
    public ResponseEntity<List<CreditCard>> getAllCreditCards() {
        List<CreditCard> cards = creditCardService.getAllCreditCards();
        return ResponseEntity.ok(cards);
    }

    /**
     * READ - Отримати кредитну карту за ID
     * GET <a href="http://localhost:8080/api/cards/1">...</a>
     */
    @GetMapping("/{id}")
    public ResponseEntity<CreditCard> getCreditCardById(@PathVariable Long id) {
        return creditCardService.getCreditCardById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати кредитну карту за номером
     * GET <a href="http://localhost:8080/api/cards/number/1234567890123456">...</a>
     */
    @GetMapping("/number/{cardNumber}")
    public ResponseEntity<CreditCard> getCreditCardByNumber(@PathVariable String cardNumber) {
        return creditCardService.getCreditCardByNumber(cardNumber)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * READ - Отримати картки користувача
     * GET <a href="http://localhost:8080/api/cards/user/1">...</a>
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<CreditCard>> getCreditCardsByUser(@PathVariable Long userId) {
        User user = userService.getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Користувача не знайдено"));
        List<CreditCard> cards = creditCardService.getCreditCardsByUser(user);
        return ResponseEntity.ok(cards);
    }

    /**
     * READ - Отримати замаскований номер карти
     * GET <a href="http://localhost:8080/api/cards/1/masked">...</a>
     */
    @GetMapping("/{id}/masked")
    public ResponseEntity<String> getMaskedCardNumber(@PathVariable Long id) {
        String masked = creditCardService.getMaskedCardNumber(id);
        return ResponseEntity.ok(masked);
    }

    /**
     * READ - Перевірити чи карта прострочена
     * GET <a href="http://localhost:8080/api/cards/1/expired">...</a>
     */
    @GetMapping("/{id}/expired")
    public ResponseEntity<Boolean> isExpired(@PathVariable Long id) {
        boolean expired = creditCardService.isExpired(id);
        return ResponseEntity.ok(expired);
    }

    /**
     * UPDATE - Оновити дані карти
     * PUT <a href="http://localhost:8080/api/cards/1">...</a>
     * Body: {
     *   "cardholderName": "IVAN SYDORENKO",
     *   "expiryDate": "2028-12-31"
     * }
     */
    @PutMapping("/{id}")
    public ResponseEntity<CreditCard> updateCreditCard(
            @PathVariable Long id,
            @RequestBody CreditCard card
    ) {
        CreditCard updated = creditCardService.updateCreditCard(id, card);
        return ResponseEntity.ok(updated);
    }

    /**
     * UPDATE - Активувати карту
     * POST <a href="http://localhost:8080/api/cards/1/activate">...</a>
     */
    @PostMapping("/{id}/activate")
    public ResponseEntity<Void> activateCreditCard(@PathVariable Long id) {
        creditCardService.activateCreditCard(id);
        return ResponseEntity.ok().build();
    }

    /**
     * UPDATE - Деактивувати карту
     * POST <a href="http://localhost:8080/api/cards/1/deactivate">...</a>
     */
    @PostMapping("/{id}/deactivate")
    public ResponseEntity<Void> deactivateCreditCard(@PathVariable Long id) {
        creditCardService.deactivateCreditCard(id);
        return ResponseEntity.ok().build();
    }

    /**
     * DELETE - Видалити карту
     * DELETE <a href="http://localhost:8080/api/cards/1">...</a>
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCreditCard(@PathVariable Long id) {
        creditCardService.deleteCreditCard(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * COUNT - Підрахувати всі картки
     * GET <a href="http://localhost:8080/api/cards/count">...</a>
     */
    @GetMapping("/count")
    public ResponseEntity<Long> countCreditCards() {
        long count = creditCardService.countCreditCards();
        return ResponseEntity.ok(count);
    }

    /**
     * COUNT - Підрахувати активні картки
     * GET <a href="http://localhost:8080/api/cards/count/active">...</a>
     */
    @GetMapping("/count/active")
    public ResponseEntity<Long> countActiveCards() {
        long count = creditCardService.countActiveCards();
        return ResponseEntity.ok(count);
    }
}