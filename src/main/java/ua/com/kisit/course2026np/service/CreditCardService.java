package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.entity.CreditCard;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.repository.CreditCardRepository;

import java.util.List;
import java.util.Optional;

/**
 * Сервіс для роботи з кредитними картками
 * Реалізує CRUD операції
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CreditCardService {

    private final CreditCardRepository creditCardRepository;

    /**
     * CREATE - Створити нову кредитну карту
     *
     * @param card карта для створення
     * @return створена карта з присвоєним ID
     * @throws IllegalArgumentException якщо номер карти вже існує
     */
    public CreditCard createCreditCard(CreditCard card) {
        log.info("Створення нової кредитної карти: {}", card.getCardNumber());

        // Перевірка унікальності номера карти
        if (creditCardRepository.existsByCardNumber(card.getCardNumber())) {
            log.error("Карта з номером {} вже існує", card.getCardNumber());
            throw new IllegalArgumentException(
                    "Карта з номером " + card.getCardNumber() + " вже існує"
            );
        }

        CreditCard savedCard = creditCardRepository.save(card);
        log.info("Кредитну карту створено з ID: {}", savedCard.getId());

        return savedCard;
    }

    /**
     * READ - Отримати карту за ID
     *
     * @param id ідентифікатор карти
     * @return Optional з картою або порожній
     */
    @Transactional(readOnly = true)
    public Optional<CreditCard> getCreditCardById(Long id) {
        log.debug("Пошук кредитної карти за ID: {}", id);
        return creditCardRepository.findById(id);
    }

    /**
     * READ - Отримати карту за номером
     *
     * @param cardNumber номер карти
     * @return Optional з картою або порожній
     */
    @Transactional(readOnly = true)
    public Optional<CreditCard> getCreditCardByNumber(String cardNumber) {
        log.debug("Пошук кредитної карти за номером: {}", cardNumber);
        return creditCardRepository.findByCardNumber(cardNumber);
    }

    /**
     * READ - Отримати всі карти
     *
     * @return список всіх карт
     */
    @Transactional(readOnly = true)
    public List<CreditCard> getAllCreditCards() {
        log.debug("Отримання всіх кредитних карток");
        return creditCardRepository.findAll();
    }

    /**
     * READ - Отримати карти користувача
     *
     * @param user користувач
     * @return список карток користувача
     */
    @Transactional(readOnly = true)
    public List<CreditCard> getCreditCardsByUser(User user) {
        log.debug("Пошук кредитних карток користувача: {}", user.getId());
        return creditCardRepository.findByUser(user);
    }

    /**
     * UPDATE - Оновити дані карти
     *
     * @param id ідентифікатор карти
     * @param updatedCard оновлені дані
     * @return оновлена карта
     * @throws IllegalArgumentException якщо карту не знайдено
     */
    public CreditCard updateCreditCard(Long id, CreditCard updatedCard) {
        log.info("Оновлення кредитної карти з ID: {}", id);

        CreditCard existingCard = creditCardRepository.findById(id)
                .orElseThrow(() -> {
                    log.error("Кредитну карту з ID {} не знайдено", id);
                    return new IllegalArgumentException(
                            "Кредитну карту з ID " + id + " не знайдено"
                    );
                });

        // Оновлюємо поля
        existingCard.setCardholderName(updatedCard.getCardholderName());
        existingCard.setExpiryDate(updatedCard.getExpiryDate());

        CreditCard saved = creditCardRepository.save(existingCard);
        log.info("Кредитну карту з ID {} оновлено", id);

        return saved;
    }

    /**
     * UPDATE - Деактивувати карту
     *
     * @param id ідентифікатор карти
     * @throws IllegalArgumentException якщо карту не знайдено
     */
    public void deactivateCreditCard(Long id) {
        log.info("Деактивація кредитної карти з ID: {}", id);

        CreditCard card = creditCardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Кредитну карту з ID " + id + " не знайдено"
                ));

        card.setIsActive(false);
        creditCardRepository.save(card);

        log.info("Кредитну карту з ID {} деактивовано", id);
    }

    /**
     * UPDATE - Активувати карту
     *
     * @param id ідентифікатор карти
     * @throws IllegalArgumentException якщо карту не знайдено
     */
    public void activateCreditCard(Long id) {
        log.info("Активація кредитної карти з ID: {}", id);

        CreditCard card = creditCardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Кредитну карту з ID " + id + " не знайдено"
                ));

        card.setIsActive(true);
        creditCardRepository.save(card);

        log.info("Кредитну карту з ID {} активовано", id);
    }

    /**
     * DELETE - Видалити карту
     *
     * @param id ідентифікатор карти
     * @throws IllegalArgumentException якщо карту не знайдено
     */
    public void deleteCreditCard(Long id) {
        log.info("Видалення кредитної карти з ID: {}", id);

        if (!creditCardRepository.existsById(id)) {
            log.error("Кредитну карту з ID {} не знайдено", id);
            throw new IllegalArgumentException(
                    "Кредитну карту з ID " + id + " не знайдено"
            );
        }

        creditCardRepository.deleteById(id);
        log.info("Кредитну карту з ID {} видалено", id);
    }

    /**
     * Перевірка чи карта прострочена
     *
     * @param id ідентифікатор карти
     * @return true якщо прострочена, false якщо ні
     */
    @Transactional(readOnly = true)
    public boolean isExpired(Long id) {
        log.debug("Перевірка терміну дії карти: {}", id);

        CreditCard card = creditCardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Кредитну карту з ID " + id + " не знайдено"
                ));

        return card.isExpired();
    }

    /**
     * Отримати замасковану версію номера карти
     *
     * @param id ідентифікатор карти
     * @return замаскований номер (**** **** **** 1234)
     */
    @Transactional(readOnly = true)
    public String getMaskedCardNumber(Long id) {
        log.debug("Отримання замаскованого номера карти: {}", id);

        CreditCard card = creditCardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Кредитну карту з ID " + id + " не знайдено"
                ));

        return card.getMaskedCardNumber();
    }

    /**
     * Підрахунок кількості карт
     *
     * @return загальна кількість карт
     */
    @Transactional(readOnly = true)
    public long countCreditCards() {
        long count = creditCardRepository.count();
        log.debug("Загальна кількість кредитних карток: {}", count);
        return count;
    }

    /**
     * Підрахунок активних карт
     *
     * @return кількість активних карт
     */
    @Transactional(readOnly = true)
    public long countActiveCards() {
        long count = creditCardRepository.findAll().stream()
                .filter(CreditCard::getIsActive)
                .count();
        log.debug("Кількість активних кредитних карток: {}", count);
        return count;
    }
}