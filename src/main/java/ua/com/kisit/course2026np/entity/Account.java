package ua.com.kisit.course2026np.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "accounts", indexes = {
        @Index(name = "idx_account_number", columnList = "account_number"),
        @Index(name = "idx_account_status", columnList = "status")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // === ДОДАНО НОВЕ ПОЛЕ ===
    @Column(name = "account_name", nullable = false)
    private String accountName;
    // ========================

    @Column(name = "account_number", nullable = false, unique = true, length = 20)
    private String accountNumber;

    @Column(nullable = false, precision = 19, scale = 2)
    @Builder.Default
    private BigDecimal balance = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private AccountStatus status = AccountStatus.ACTIVE;

    /* ===================== RELATIONS ===================== */

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "card_id", nullable = false)
    @JsonBackReference("card-accounts")
    private CreditCard creditCard;

    @OneToMany(mappedBy = "account", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    @Builder.Default
    private List<Payment> payments = new ArrayList<>();

    /* ===================== AUDIT ===================== */

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    /* ===================== BUSINESS LOGIC ===================== */

    public boolean isActive() {
        return status == AccountStatus.ACTIVE;
    }

    public void block() {
        this.status = AccountStatus.BLOCKED;
    }

    public void unblock() {
        this.status = AccountStatus.ACTIVE;
    }

    public void deposit(BigDecimal amount) {
        validateAmount(amount);

        if (status == AccountStatus.BLOCKED) {
            throw new IllegalStateException("Рахунок заблокований");
        }

        balance = balance.add(amount);
    }

    public void withdraw(BigDecimal amount) {
        validateAmount(amount);

        if (status == AccountStatus.BLOCKED) {
            throw new IllegalStateException("Рахунок заблокований");
        }

        if (balance.compareTo(amount) < 0) {
            throw new IllegalStateException("Недостатньо коштів");
        }

        balance = balance.subtract(amount);
    }

    /* ===================== PAYMENTS ===================== */

    public void addPayment(Payment payment) {
        payments.add(payment);
        payment.setAccount(this);
    }

    public void removePayment(Payment payment) {
        payments.remove(payment);
        payment.setAccount(null);
    }

    /* ===================== HELPERS ===================== */

    private void validateAmount(BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Сума має бути більшою за нуль");
        }
    }
}