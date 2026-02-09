package ua.com.kisit.course2026np.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Сутність кредитної карти
 * Зберігає інформацію про платіжну карту клієнта
 */
@Entity
@Table(name = "credit_cards", indexes = {
        @Index(name = "idx_card_number", columnList = "card_number"),
        @Index(name = "idx_card_user", columnList = "user_id")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditCard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Номер карти обов'язковий")
    @Pattern(regexp = "\\d{16}", message = "Номер карти має містити 16 цифр")
    @Column(unique = true, nullable = false, length = 16, name = "card_number")
    private String cardNumber;

    @NotBlank(message = "Ім'я власника обов'язкове")
    @Column(nullable = false, name = "cardholder_name", length = 100)
    private String cardholderName;

    @Column(nullable = false, name = "expiry_date")
    private LocalDate expiryDate;

    @NotBlank(message = "CVV обов'язковий")
    @Pattern(regexp = "\\d{3}", message = "CVV має містити 3 цифри")
    @Column(nullable = false, length = 3)
    private String cvv;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonBackReference("user-cards")
    private User user;

    @OneToOne(mappedBy = "creditCard", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference("card-account")
    private Account account;

    @Column(nullable = false, name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

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
     * Перевірка чи карта не прострочена
     */
    public boolean isExpired() {
        return LocalDate.now().isAfter(expiryDate)
                || LocalDate.now().isEqual(expiryDate);
    }

    /**
     * Отримати замасковану версію номера карти
     */
    public String getMaskedCardNumber() {
        if (cardNumber == null || cardNumber.length() != 16) {
            return "";
        }
        return "**** **** **** " + cardNumber.substring(12);
    }

    /**
     * Встановити зв'язок з рахунком
     */
    public void setAccount(Account account) {
        this.account = account;
        if (account != null) {
            account.setCreditCard(this);
        }
    }
}