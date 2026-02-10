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

    /* ===================== CREATE ===================== */

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
        user.setRole(updatedUser.getRole());
        user.setIsActive(updatedUser.getIsActive());

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

    /* ===================== CURRENT USER (DASHBOARD FIX) ===================== */

    /**
     * Тимчасове рішення БЕЗ Spring Security
     */
    public User getCurrentUser() {
        return userRepository.findById(1L)
                .orElseThrow(() ->
                        new RuntimeException("Current user not found (id = 1)")
                );
    }
}
