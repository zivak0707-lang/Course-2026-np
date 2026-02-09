package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

import java.util.List;
import java.util.Optional;

/**
 * Сервіс для роботи з користувачами
 * Реалізує CRUD операції
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;

    /**
     * CREATE - Створити нового користувача
     *
     * @param user користувач для створення
     * @return створений користувач з присвоєним ID
     * @throws IllegalArgumentException якщо email вже існує
     */
    public User createUser(User user) {
        log.info("Створення нового користувача з email: {}", user.getEmail());

        // Перевірка чи email вже існує
        if (userRepository.existsByEmail(user.getEmail())) {
            log.error("Користувач з email {} вже існує", user.getEmail());
            throw new IllegalArgumentException(
                    "Користувач з email " + user.getEmail() + " вже існує"
            );
        }

        User savedUser = userRepository.save(user);
        log.info("Користувача створено з ID: {}", savedUser.getId());

        return savedUser;
    }

    /**
     * READ - Отримати користувача за ID
     *
     * @param id ідентифікатор користувача
     * @return Optional з користувачем або порожній
     */
    @Transactional(readOnly = true)
    public Optional<User> getUserById(Long id) {
        log.debug("Пошук користувача за ID: {}", id);
        return userRepository.findById(id);
    }

    /**
     * READ - Отримати користувача за email
     *
     * @param email електронна пошта користувача
     * @return Optional з користувачем або порожній
     */
    @Transactional(readOnly = true)
    public Optional<User> getUserByEmail(String email) {
        log.debug("Пошук користувача за email: {}", email);
        return userRepository.findByEmail(email);
    }

    /**
     * READ - Отримати всіх користувачів
     *
     * @return список всіх користувачів
     */
    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        log.debug("Отримання всіх користувачів");
        return userRepository.findAll();
    }

    /**
     * READ - Отримати користувачів за роллю
     *
     * @param role роль користувача
     * @return список користувачів з вказаною роллю
     */
    @Transactional(readOnly = true)
    public List<User> getUsersByRole(UserRole role) {
        log.debug("Пошук користувачів за роллю: {}", role);
        return userRepository.findByRole(role);
    }

    /**
     * READ - Отримати активних користувачів
     *
     * @return список активних користувачів
     */
    @Transactional(readOnly = true)
    public List<User> getActiveUsers() {
        log.debug("Отримання активних користувачів");
        return userRepository.findByIsActive(true);
    }

    /**
     * UPDATE - Оновити дані користувача
     *
     * @param id ідентифікатор користувача
     * @param updatedUser оновлені дані
     * @return оновлений користувач
     * @throws IllegalArgumentException якщо користувача не знайдено
     */
    public User updateUser(Long id, User updatedUser) {
        log.info("Оновлення користувача з ID: {}", id);

        User existingUser = userRepository.findById(id)
                .orElseThrow(() -> {
                    log.error("Користувача з ID {} не знайдено", id);
                    return new IllegalArgumentException(
                            "Користувача з ID " + id + " не знайдено"
                    );
                });

        // Оновлюємо поля
        existingUser.setFirstName(updatedUser.getFirstName());
        existingUser.setLastName(updatedUser.getLastName());
        existingUser.setEmail(updatedUser.getEmail());

        User saved = userRepository.save(existingUser);
        log.info("Користувача з ID {} оновлено", id);

        return saved;
    }

    /**
     * UPDATE - Деактивувати користувача
     *
     * @param id ідентифікатор користувача
     * @throws IllegalArgumentException якщо користувача не знайдено
     */
    public void deactivateUser(Long id) {
        log.info("Деактивація користувача з ID: {}", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Користувача з ID " + id + " не знайдено"
                ));

        user.setIsActive(false);
        userRepository.save(user);

        log.info("Користувача з ID {} деактивовано", id);
    }

    /**
     * UPDATE - Активувати користувача
     *
     * @param id ідентифікатор користувача
     * @throws IllegalArgumentException якщо користувача не знайдено
     */
    public void activateUser(Long id) {
        log.info("Активація користувача з ID: {}", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Користувача з ID " + id + " не знайдено"
                ));

        user.setIsActive(true);
        userRepository.save(user);

        log.info("Користувача з ID {} активовано", id);
    }

    /**
     * DELETE - Видалити користувача
     *
     * @param id ідентифікатор користувача
     * @throws IllegalArgumentException якщо користувача не знайдено
     */
    public void deleteUser(Long id) {
        log.info("Видалення користувача з ID: {}", id);

        if (!userRepository.existsById(id)) {
            log.error("Користувача з ID {} не знайдено", id);
            throw new IllegalArgumentException(
                    "Користувача з ID " + id + " не знайдено"
            );
        }

        userRepository.deleteById(id);
        log.info("Користувача з ID {} видалено", id);
    }

    /**
     * Підрахунок кількості користувачів
     *
     * @return загальна кількість користувачів
     */
    @Transactional(readOnly = true)
    public long countUsers() {
        long count = userRepository.count();
        log.debug("Загальна кількість користувачів: {}", count);
        return count;
    }

    /**
     * Підрахунок активних користувачів
     *
     * @return кількість активних користувачів
     */
    @Transactional(readOnly = true)
    public long countActiveUsers() {
        long count = userRepository.findByIsActive(true).size();
        log.debug("Кількість активних користувачів: {}", count);
        return count;
    }
}