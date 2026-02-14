package ua.com.kisit.course2026np.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "payments", indexes = {
        @Index(name = "idx_payment_account", columnList = "account_id"),
        @Index(name = "idx_payment_status", columnList = "status"),
        @Index(name = "idx_payment_type", columnList = "type"),
        @Index(name = "idx_payment_created", columnList = "created_at")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @NotNull(message = "Сума платежу обов'язкова")
    @DecimalMin(value = "0.01", message = "Сума має бути більше 0")
    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PaymentType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private PaymentStatus status = PaymentStatus.PENDING;

    @Size(max = 500, message = "Опис не може перевищувати 500 символів")
    @Column(length = 500)
    private String description;

    // ✅ ВИПРАВЛЕНО: збільшено з VARCHAR(20) до VARCHAR(255)
    // Причина: номери рахунків (UA + 20 цифр = 22 символи) і номери карток (16 символів)
    // легко перевищують VARCHAR(20), що викликало:
    // "Data too long for column 'recipient_account' at row 1"
    @Column(name = "recipient_account", length = 255)
    private String recipientAccount;

    @Column(name = "sender_account", length = 255)
    private String senderAccount;

    @Column(name = "transaction_id", unique = true, length = 50)
    private String transactionId;

    @Column(name = "error_message", length = 500)
    private String errorMessage;

    @Column(nullable = false, updatable = false, name = "created_at")
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.transactionId == null) {
            this.transactionId = generateTransactionId();
        }
    }

    private String generateTransactionId() {
        return "TXN" + System.currentTimeMillis() + String.format("%04d", (int)(Math.random() * 10000));
    }

    public void complete() {
        this.status = PaymentStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
    }

    public void fail(String errorMessage) {
        this.status = PaymentStatus.FAILED;
        this.errorMessage = errorMessage;
        this.completedAt = LocalDateTime.now();
    }

    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }

    public boolean isCompleted() {
        return this.status == PaymentStatus.COMPLETED;
    }

    public boolean isFailed() {
        return this.status == PaymentStatus.FAILED;
    }

    public boolean isPending() {
        return this.status == PaymentStatus.PENDING;
    }
}