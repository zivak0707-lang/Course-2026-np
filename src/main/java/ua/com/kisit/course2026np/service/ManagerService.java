package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import ua.com.kisit.course2026np.dto.DashboardStats;
import ua.com.kisit.course2026np.dto.TransactionPage;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

@Slf4j
@Service
@RequiredArgsConstructor
public class ManagerService {

    private static final Logger securityLog = LoggerFactory.getLogger("SECURITY");

    private final UserRepository userRepository;
    private final DashboardService dashboardService;
    private final PasswordEncoder passwordEncoder;

    // ── Auth ──────────────────────────────────────────────────────────────────

    public User authenticateManager(String email, String password) {
        String normalizedEmail = email.trim();
        User manager = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(normalizedEmail) && u.getRole() == UserRole.MANAGER)
                .findFirst()
                .orElseThrow(() -> {
                    securityLog.warn("[MANAGER_LOGIN_FAIL] email={} reason=not_found_or_not_manager", normalizedEmail);
                    return new IllegalArgumentException("User not found or insufficient privileges");
                });
        if (!passwordEncoder.matches(password.trim(), manager.getPassword())) {
            securityLog.warn("[MANAGER_LOGIN_FAIL] email={} id={} reason=wrong_password",
                    normalizedEmail, manager.getId());
            throw new IllegalArgumentException("Incorrect password");
        }
        if (!Boolean.TRUE.equals(manager.getIsActive())) {
            securityLog.warn("[MANAGER_LOGIN_FAIL] email={} id={} reason=account_blocked",
                    normalizedEmail, manager.getId());
            throw new IllegalArgumentException("Your account has been blocked");
        }
        securityLog.info("[MANAGER_LOGIN_OK] Manager authenticated: email={} id={}", manager.getEmail(), manager.getId());
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
