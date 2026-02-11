package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    /* ===================== AUTH & REGISTER (НОВІ МЕТОДИ) ===================== */

    /**
     * Метод для реєстрації нового користувача через форму.
     * Встановлює дефолтну роль CLIENT, якщо вона не задана.
     */
    public User registerUser(User user) {
        // Якщо роль не вказана, це звичайний клієнт
        if (user.getRole() == null) {
            user.setRole(UserRole.CLIENT);
        }
        // За замовчуванням активуємо користувача
        if (user.getIsActive() == null) {
            user.setIsActive(true);
        }

        // Тут міг би бути хеш пароля, якщо підключиш Spring Security
        // user.setPassword(passwordEncoder.encode(user.getPassword()));

        return userRepository.save(user);
    }

    /**
     * Перевірка існування email (для валідації форми)
     */
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /* ===================== CREATE (Старий метод) ===================== */

    public User createUser(User user) {
        return userRepository.save(user);
    }

    /* ===================== READ ===================== */

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public List<User> getUsersByRole(UserRole role) {
        return userRepository.findByRole(role);
    }

    public List<User> getActiveUsers() {
        return userRepository.findByIsActiveTrue();
    }

    /* ===================== UPDATE ===================== */

    public User updateUser(Long id, User updatedUser) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setEmail(updatedUser.getEmail());
        // Якщо роль передана - оновлюємо, якщо ні - залишаємо стару
        if (updatedUser.getRole() != null) {
            user.setRole(updatedUser.getRole());
        }
        user.setIsActive(updatedUser.getIsActive());

        // Додаткові поля (ім'я, прізвище) теж варто оновлювати
        if (updatedUser.getFirstName() != null) user.setFirstName(updatedUser.getFirstName());
        if (updatedUser.getLastName() != null) user.setLastName(updatedUser.getLastName());

        return userRepository.save(user);
    }

    public void activateUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setIsActive(true);
        userRepository.save(user);
    }

    public void deactivateUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setIsActive(false);
        userRepository.save(user);
    }

    /* ===================== DELETE ===================== */

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    /* ===================== COUNT ===================== */

    public long countUsers() {
        return userRepository.count();
    }

    public long countActiveUsers() {
        return userRepository.countByIsActiveTrue();
    }

    /* ===================== CURRENT USER ===================== */

    public User getCurrentUser() {
        // Тимчасова заглушка: повертаємо користувача з ID 1 або створюємо, якщо база порожня
        return userRepository.findById(1L)
                .orElseGet(() -> {
                    // Це щоб код не падав, якщо база пуста
                    return null;
                });
    }
}