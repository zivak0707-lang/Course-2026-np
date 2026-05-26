package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.dto.DashboardStats;
import ua.com.kisit.course2026np.dto.TransactionPage;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.AccountRepository;
import ua.com.kisit.course2026np.repository.PaymentRepository;
import ua.com.kisit.course2026np.repository.UserRepository;
import ua.com.kisit.course2026np.service.PaymentService;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminService {

    private static final Logger securityLog = LoggerFactory.getLogger("SECURITY");

    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    private final AccountRepository accountRepository;
    private final DashboardService dashboardService;
    private final PasswordEncoder passwordEncoder;
    private final PaymentService paymentService;

    // ── Auth ──────────────────────────────────────────────────────────────────

    public User authenticateAdmin(String email, String password) {
        String normalizedEmail = email.trim();
        User admin = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(normalizedEmail) && u.getRole() == UserRole.ADMIN)
                .findFirst()
                .orElseThrow(() -> {
                    securityLog.warn("[ADMIN_LOGIN_FAIL] Admin login failed: email={} reason=not_found_or_not_admin",
                            normalizedEmail);
                    return new IllegalArgumentException("User not found or insufficient privileges");
                });

        if (!passwordEncoder.matches(password.trim(), admin.getPassword())) {
            securityLog.warn("[ADMIN_LOGIN_FAIL] Admin login failed: email={} id={} reason=wrong_password",
                    normalizedEmail, admin.getId());
            throw new IllegalArgumentException("Incorrect password");
        }

        if (!Boolean.TRUE.equals(admin.getIsActive())) {
            securityLog.warn("[ADMIN_LOGIN_FAIL] Admin login failed: email={} id={} reason=account_blocked",
                    normalizedEmail, admin.getId());
            throw new IllegalArgumentException("Your account has been blocked");
        }

        securityLog.info("[ADMIN_LOGIN_OK] Admin authenticated: email={} id={}", admin.getEmail(), admin.getId());
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
            log.warn("[ADMIN_ACTION_DENIED] Admin id={} attempted to block own account", adminId);
            throw new IllegalArgumentException("You cannot block your own account");
        }
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        user.setIsActive(!Boolean.TRUE.equals(user.getIsActive()));
        userRepository.save(user);
        String action = Boolean.TRUE.equals(user.getIsActive()) ? "unblocked" : "blocked";
        log.info("[ADMIN_ACTION] Admin id={} {} user: id={} email={}", adminId, action, user.getId(), user.getEmail());
        securityLog.info("[USER_BLOCK_TOGGLE] Admin id={} {} user: id={} email={}", adminId, action, user.getId(), user.getEmail());
        return "User " + user.getEmail() + " has been " + action;
    }

    @Transactional
    public String assignRole(Long userId, String role, Long adminId) {
        if (adminId != null && adminId.equals(userId)) {
            log.warn("[ADMIN_ACTION_DENIED] Admin id={} attempted to change own role", adminId);
            throw new IllegalArgumentException("You cannot change your own role");
        }
        UserRole newRole;
        try {
            newRole = UserRole.valueOf(role.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid role: " + role);
        }
        if (newRole == UserRole.ADMIN) {
            log.warn("[ADMIN_ACTION_DENIED] Admin id={} attempted to assign ADMIN role to userId={}", adminId, userId);
            throw new IllegalArgumentException("ADMIN role cannot be assigned via panel");
        }
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        if (user.getRole() == UserRole.ADMIN) {
            log.warn("[ADMIN_ACTION_DENIED] Admin id={} attempted to change role of another admin: id={}", adminId, userId);
            throw new IllegalArgumentException("Cannot change role of another administrator");
        }
        UserRole previousRole = user.getRole();
        user.setRole(newRole);
        userRepository.save(user);
        log.info("[ADMIN_ACTION] Admin id={} changed role: userId={} email={} from={} to={}",
                adminId, user.getId(), user.getEmail(), previousRole, newRole);
        return user.getEmail() + " is now " + newRole.name();
    }

    @Transactional
    public String deleteUser(Long userId, Long adminId) {
        if (adminId != null && adminId.equals(userId)) {
            log.warn("[ADMIN_ACTION_DENIED] Admin id={} attempted to delete own account", adminId);
            throw new IllegalArgumentException("You cannot delete your own account");
        }
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        log.info("[ADMIN_ACTION] Admin id={} deleted user: id={} email={} role={}",
                adminId, user.getId(), user.getEmail(), user.getRole());
        userRepository.deleteById(userId);
        return "User " + user.getEmail() + " deleted";
    }

    // ── Accounts ──────────────────────────────────────────────────────────────

    public List<Account> getAllAccountsSortedById() {
        return accountRepository.findAll().stream()
                .sorted(Comparator.comparing(Account::getId))
                .toList();
    }

    @Transactional
    public String blockAccount(Long accountId, Long adminId) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));
        if (account.getStatus() == AccountStatus.BLOCKED) {
            throw new IllegalArgumentException("Account is already blocked");
        }
        account.block();
        accountRepository.save(account);
        log.info("[ADMIN_ACTION] Admin id={} blocked account: id={} number={}",
                adminId, account.getId(), account.getAccountNumber());
        securityLog.info("[ACCOUNT_BLOCK] Admin id={} blocked account: id={} number={}",
                adminId, account.getId(), account.getAccountNumber());
        return "Account " + account.getAccountNumber() + " has been blocked";
    }

    public AccountAdminDetailsDto getAccountDetailsForAdmin(Long accountId) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));

        User owner = (account.getCreditCard() != null) ? account.getCreditCard().getUser() : null;
        List<Payment> recent = paymentService.getRecentPaymentsByAccount(account, 10);

        AccountAdminDetailsDto dto = new AccountAdminDetailsDto();
        dto.id            = account.getId();
        dto.accountNumber = account.getAccountNumber();
        dto.accountName   = account.getAccountName();
        dto.status        = account.getStatus() != null ? account.getStatus().name() : null;
        dto.balance       = account.getBalance();
        dto.createdAt     = account.getCreatedAt() != null ? account.getCreatedAt().toString() : null;
        dto.updatedAt     = account.getUpdatedAt() != null ? account.getUpdatedAt().toString() : null;
        if (owner != null) {
            dto.ownerId    = owner.getId();
            dto.ownerName  = ((owner.getFirstName() != null ? owner.getFirstName() : "")
                            + " "
                            + (owner.getLastName() != null ? owner.getLastName() : "")).trim();
            dto.ownerEmail = owner.getEmail();
        }
        dto.recentActivity = recent.stream().map(p -> {
            AccountAdminDetailsDto.PaymentRow row = new AccountAdminDetailsDto.PaymentRow();
            row.id               = p.getId();
            row.transactionId    = p.getTransactionId();
            row.amount           = p.getAmount();
            row.type             = p.getType() != null ? p.getType().name() : null;
            row.status           = p.getStatus() != null ? p.getStatus().name() : null;
            row.description      = p.getDescription();
            row.senderAccount    = p.getSenderAccount();
            row.recipientAccount = p.getRecipientAccount();
            row.createdAt        = p.getCreatedAt() != null ? p.getCreatedAt().toString() : null;
            return row;
        }).toList();
        return dto;
    }

    @lombok.Getter
    @lombok.Setter
    public static class AccountAdminDetailsDto {
        public Long id;
        public String accountNumber;
        public String accountName;
        public String status;
        public java.math.BigDecimal balance;
        public String createdAt;
        public String updatedAt;
        public Long ownerId;
        public String ownerName;
        public String ownerEmail;
        public List<PaymentRow> recentActivity;

        @lombok.Getter
        @lombok.Setter
        public static class PaymentRow {
            public Long id;
            public String transactionId;
            public java.math.BigDecimal amount;
            public String type;
            public String status;
            public String description;
            public String senderAccount;
            public String recipientAccount;
            public String createdAt;
        }
    }

    @Transactional
    public String unblockAccount(Long accountId, Long adminId) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));
        if (account.getStatus() == AccountStatus.ACTIVE) {
            throw new IllegalArgumentException("Account is already active");
        }
        account.unblock();
        accountRepository.save(account);
        log.info("[ADMIN_ACTION] Admin id={} unblocked account: id={} number={}",
                adminId, account.getId(), account.getAccountNumber());
        securityLog.info("[ACCOUNT_UNBLOCK] Admin id={} unblocked account: id={} number={}",
                adminId, account.getId(), account.getAccountNumber());
        return "Account " + account.getAccountNumber() + " has been unblocked";
    }

    // ── Transactions ──────────────────────────────────────────────────────────

    public TransactionPage filterAndPageTransactions(
            int page, int size, String search, String type, String status) {
        return dashboardService.filterAndPageTransactions(page, size, search, type, status);
    }

    @Transactional
    public void approveTransaction(Long paymentId, Long adminId) {
        applyTransactionStatus(paymentId, PaymentStatus.COMPLETED, adminId);
    }

    @Transactional
    public void rejectTransaction(Long paymentId, Long adminId) {
        applyTransactionStatus(paymentId, PaymentStatus.FAILED, adminId);
    }

    private void applyTransactionStatus(Long paymentId, PaymentStatus newStatus, Long adminId) {
        Payment p = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Transaction not found"));
        if (p.getStatus() != PaymentStatus.PENDING) {
            throw new IllegalArgumentException("Transaction is already processed");
        }
        PaymentStatus oldStatus = p.getStatus();
        p.setStatus(newStatus);
        if (newStatus == PaymentStatus.COMPLETED) p.complete();
        else p.fail("Rejected by admin");
        paymentRepository.save(p);
        log.info("[ADMIN_ACTION] Transaction {} → {}: paymentId={} amount={} type={} adminId={}",
                oldStatus, newStatus, paymentId, p.getAmount(), p.getType(), adminId);
    }

    @Transactional
    public void cancelTransaction(Long paymentId, Long adminId, String reason) {
        User admin = userRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("Admin not found"));
        String cancelledBy = "Admin: " + admin.getEmail() + " (id=" + adminId + ")";
        paymentService.cancelPayment(paymentId, cancelledBy, reason);
        log.info("[ADMIN_ACTION] Admin id={} cancelled paymentId={} reason={}", adminId, paymentId, reason);
        securityLog.info("[ADMIN_ACTION] Admin id={} cancelled paymentId={} reason={}", adminId, paymentId, reason);
    }

    @Transactional
    public void refundTransaction(Long paymentId, Long adminId, String reason) {
        User admin = userRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("Admin not found"));
        String refundedBy = "Admin: " + admin.getEmail() + " (id=" + adminId + ")";
        paymentService.refundPayment(paymentId, refundedBy, reason);
        log.info("[ADMIN_ACTION] Admin id={} issued refund for paymentId={} reason={}", adminId, paymentId, reason);
        securityLog.info("[ADMIN_ACTION] Admin id={} issued refund for paymentId={} reason={}", adminId, paymentId, reason);
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
        log.info("[ADMIN_PROFILE_UPDATE] Admin id={} updated profile: newEmail={}", adminId, email.trim());
    }

    public void updatePassword(Long adminId, String currentPassword, String newPassword) {
        User user = userRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("Admin account not found"));
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            log.warn("[ADMIN_PASSWORD_FAIL] Admin id={} provided wrong current password", adminId);
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
        log.info("[ADMIN_PASSWORD_CHANGE] Admin id={} changed password", adminId);
        securityLog.info("[ADMIN_PASSWORD_CHANGE] Admin id={} changed own password", adminId);
    }
}
