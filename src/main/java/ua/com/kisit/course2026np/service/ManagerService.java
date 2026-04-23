package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import ua.com.kisit.course2026np.dto.DashboardStats;
import ua.com.kisit.course2026np.dto.TransactionPage;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class ManagerService {

    private final UserRepository userRepository;
    private final DashboardService dashboardService;
    private final PasswordEncoder passwordEncoder;

    // ── Auth ──────────────────────────────────────────────────────────────────

    public User authenticateManager(String email, String password) {
        User manager = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim()) && u.getRole() == UserRole.MANAGER)
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("User not found or insufficient privileges"));
        if (!passwordEncoder.matches(password.trim(), manager.getPassword())) {
            throw new IllegalArgumentException("Incorrect password");
        }
        if (!Boolean.TRUE.equals(manager.getIsActive())) {
            throw new IllegalArgumentException("Your account has been blocked");
        }
        return manager;
    }

    // ── Dashboard ─────────────────────────────────────────────────────────────

    public DashboardStats getDashboardStats() {
        return dashboardService.getDashboardStats();
    }

    // ── Transactions ──────────────────────────────────────────────────────────

    public TransactionPage filterAndPageTransactions(
            int page, int size, String search, String type, String status) {
        return dashboardService.filterAndPageTransactions(page, size, search, type, status);
    }
}
