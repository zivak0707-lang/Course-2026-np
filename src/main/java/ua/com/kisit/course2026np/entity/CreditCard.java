package ua.com.kisit.course2026np.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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

    @NotBlank
    @Pattern(regexp = "\\d{16}")
    @Column(name = "card_number", nullable = false, unique = true, length = 16)
    private String cardNumber;

    @NotBlank
    @Column(name = "cardholder_name", nullable = false)
    private String cardholderName;

    @Column(nullable = false)
    private LocalDate expiryDate;

    @NotBlank
    @Pattern(regexp = "\\d{3}")
    @Column(nullable = false, length = 3)
    private String cvv;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonBackReference("user-cards")
    private User user;

    // ОДНА КАРТА → БАГАТО РАХУНКІВ
    @OneToMany(mappedBy = "creditCard", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference("card-accounts")
    @Builder.Default
    private List<Account> accounts = new ArrayList<>();

    @Column(nullable = false)
    @Builder.Default
    private Boolean isActive = true;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    /* ===================== JPA LIFECYCLE ===================== */

    @PrePersist
    void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    /* ===================== BUSINESS LOGIC ===================== */

    public boolean isExpired() {
        return expiryDate.isBefore(LocalDate.now());
    }

    public String getMaskedCardNumber() {
        if (cardNumber == null || cardNumber.length() < 4) {
            return "";
        }
        return "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
    }

    /* ===================== TEST HELPERS (FIX) ===================== */

    /**
     * Для тестів: повертає перший рахунок (якщо є)
     */
    public Account getAccount() {
        return accounts.isEmpty() ? null : accounts.get(0);
    }

    /**
     * Для тестів: встановлює єдиний рахунок
     */
    public void setAccount(Account account) {
        accounts.clear();
        if (account != null) {
            accounts.add(account);
            account.setCreditCard(this);
        }
    }
}
