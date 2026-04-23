package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.dto.DashboardStats;
import ua.com.kisit.course2026np.dto.TransactionPage;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.PaymentRepository;
import ua.com.kisit.course2026np.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    private final DashboardService dashboardService;
    private final PasswordEncoder passwordEncoder;

    // ── Auth ──────────────────────────────────────────────────────────────────

    public User authenticateAdmin(String email, String password) {
        User admin = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim()) && u.getRole() == UserRole.ADMIN)
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("User not found or insufficient privileges"));
        if (!passwordEncoder.matches(password.trim(), admin.getPassword())) {
            throw new IllegalArgumentException("Incorrect password");
        }
        return admin;
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    // ── Dashboard ─────────────────────────────────────────────────────────────

    public DashboardStats getDashboardStats() {
        return dashboardService.getDashboardStats();
    }

    // ── Users ─────────────────────────────────────────────────────────────────

    public List<User> getUsersSortedById() {
        return userRepository.findAll().stream()
                .sorted(Comparator.comparing(User::getId))
                .toList();
    }

    @Transactional
    public String toggleUserBlock(Long userId, Long adminId) {
        if (adminId != null && adminId.equals(userId)) {
            throw new IllegalArgumentException("You cannot block your own account");
        }
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        user.setIsActive(!Boolean.TRUE.equals(user.getIsActive()));
        userRepository.save(user);
        String action = Boolean.TRUE.equals(user.getIsActive()) ? "unblocked" : "blocked";
        return "User " + user.getEmail() + " has been " + action;
    }

    @Transactional
    public String assignRole(Long userId, String role, Long adminId) {
        if (adminId != null && adminId.equals(userId)) {
            throw new IllegalArgumentException("You cannot change your own role");
        }
        UserRole newRole;
        try {
            newRole = UserRole.valueOf(role.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid role: " + role);
        }
        if (newRole == UserRole.ADMIN) {
            throw new IllegalArgumentException("ADMIN role cannot be assigned via panel");
        }
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        if (user.getRole() == UserRole.ADMIN) {
            throw new IllegalArgumentException("Cannot change role of another administrator");
        }
        user.setRole(newRole);
        userRepository.save(user);
        return user.getEmail() + " is now " + newRole.name();
    }

    @Transactional
    public String deleteUser(Long userId, Long adminId) {
        if (adminId != null && adminId.equals(userId)) {
            throw new IllegalArgumentException("You cannot delete your own account");
        }
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        userRepository.deleteById(userId);
        return "User " + user.getEmail() + " deleted";
    }

    // ── Transactions ──────────────────────────────────────────────────────────

    public TransactionPage filterAndPageTransactions(
            int page, int size, String search, String type, String status) {
        return dashboardService.filterAndPageTransactions(page, size, search, type, status);
    }

    @Transactional
    public void approveTransaction(Long paymentId) {
        applyTransactionStatus(paymentId, PaymentStatus.COMPLETED);
    }

    @Transactional
    public void rejectTransaction(Long paymentId) {
        applyTransactionStatus(paymentId, PaymentStatus.FAILED);
    }

    private void applyTransactionStatus(Long paymentId, PaymentStatus newStatus) {
        Payment p = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Transaction not found"));
        if (p.getStatus() != PaymentStatus.PENDING) {
            throw new IllegalArgumentException("Transaction is already processed");
        }
        p.setStatus(newStatus);
        if (newStatus == PaymentStatus.COMPLETED) p.complete();
        else p.fail("Rejected by admin");
        paymentRepository.save(p);
    }

    // ── Settings ──────────────────────────────────────────────────────────────

    public void updateProfile(Long adminId, String firstName, String lastName, String email) {
        if (firstName.trim().length() < 2 || firstName.trim().length() > 50) {
            throw new IllegalArgumentException("First name must be between 2 and 50 characters");
        }
        if (lastName.trim().length() < 2 || lastName.trim().length() > 50) {
            throw new IllegalArgumentException("Last name must be between 2 and 50 characters");
        }
        boolean emailTaken = userRepository.findAll().stream()
                .anyMatch(u -> u.getEmail().equalsIgnoreCase(email.trim()) && !u.getId().equals(adminId));
        if (emailTaken) {
            throw new IllegalArgumentException("Email address is already in use by another account");
        }
        int updated = userRepository.updateProfile(
                adminId, firstName.trim(), lastName.trim(), email.trim(), LocalDateTime.now());
        if (updated == 0) {
            throw new IllegalArgumentException("Update failed — admin account not found");
        }
    }

    public void updatePassword(Long adminId, String currentPassword, String newPassword) {
        User user = userRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("Admin account not found"));
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }
        if (newPassword.trim().length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters");
        }
        if (passwordEncoder.matches(newPassword.trim(), user.getPassword())) {
            throw new IllegalArgumentException("New password must be different from the current one");
        }
        int updated = userRepository.updatePassword(adminId, passwordEncoder.encode(newPassword.trim()), LocalDateTime.now());
        if (updated == 0) {
            throw new IllegalArgumentException("Update failed — admin account not found");
        }
    }
}
