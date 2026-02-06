package ua.com.kisit.course2026np.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Сутність рахунку
 * Представляє банківський рахунок, прив'язаний до кредитної карти
 */
@Entity
@Table(name = "accounts", indexes = {
        @Index(name = "idx_account_number", columnList = "account_number"),
        @Index(name = "idx_account_status", columnList = "status"),
        @Index(name = "idx_account_card", columnList = "card_id")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 20, name = "account_number")
    private String accountNumber;

    @DecimalMin(value = "0.0", message = "Баланс не може бути від'ємним")
    @Column(nullable = false, precision = 19, scale = 2)
    @Builder.Default
    private BigDecimal balance = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private AccountStatus status = AccountStatus.ACTIVE;

    @OneToOne
    @JoinColumn(name = "card_id", unique = true, nullable = false)
    private CreditCard creditCard;

    @OneToMany(mappedBy = "account", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @Builder.Default
    private List<Payment> payments = new ArrayList<>();

    @Column(nullable = false, updatable = false, name = "created_at")
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false, name = "updated_at")
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Поповнення рахунку
     */
    public void deposit(BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Сума поповнення має бути більше нуля");
        }
        if (this.status != AccountStatus.ACTIVE) {
            throw new IllegalStateException("Неможливо поповнити заблокований рахунок");
        }
        this.balance = this.balance.add(amount);
    }

    /**
     * Зняття коштів з рахунку
     */
    public void withdraw(BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Сума зняття має бути більше нуля");
        }
        if (this.status != AccountStatus.ACTIVE) {
            throw new IllegalStateException("Неможливо зняти кошти із заблокованого рахунку");
        }
        if (this.balance.compareTo(amount) < 0) {
            throw new IllegalStateException("Недостатньо коштів на рахунку");
        }
        this.balance = this.balance.subtract(amount);
    }

    /**
     * Блокування рахунку
     */
    public void block() {
        this.status = AccountStatus.BLOCKED;
    }

    /**
     * Розблокування рахунку
     */
    public void unblock() {
        this.status = AccountStatus.ACTIVE;
    }

    /**
     * Перевірка чи рахунок активний
     */
    public boolean isActive() {
        return this.status == AccountStatus.ACTIVE;
    }

    /**
     * Додати платіж до рахунку
     */
    public void addPayment(Payment payment) {
        payments.add(payment);
        payment.setAccount(this);
    }

    /**
     * Видалити платіж з рахунку
     */
    public void removePayment(Payment payment) {
        payments.remove(payment);
        payment.setAccount(null);
    }
}