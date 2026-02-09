package ua.com.kisit.course2026np.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Сутність користувача системи
 * Представляє клієнта або адміністратора платіжної системи
 */
@Entity
@Table(name = "users", indexes = {
        @Index(name = "idx_user_email", columnList = "email"),
        @Index(name = "idx_user_role", columnList = "role"),
        @Index(name = "idx_user_active", columnList = "is_active")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Ім'я обов'язкове")
    @Size(min = 2, max = 50, message = "Ім'я має містити від 2 до 50 символів")
    @Column(nullable = false, length = 50)
    private String firstName;

    @NotBlank(message = "Прізвище обов'язкове")
    @Size(min = 2, max = 50, message = "Прізвище має містити від 2 до 50 символів")
    @Column(nullable = false, length = 50)
    private String lastName;

    @Email(message = "Невірний формат email")
    @NotBlank(message = "Email обов'язковий")
    @Column(unique = true, nullable = false, length = 100)
    private String email;

    @NotBlank(message = "Пароль обов'язковий")
    @Size(min = 8, message = "Пароль має містити мінімум 8 символів")
    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private UserRole role = UserRole.CLIENT;

    @Column(nullable = false, name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @JsonManagedReference("user-cards")
    @Builder.Default
    private List<CreditCard> creditCards = new ArrayList<>();

    @Column(nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
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
     * Отримати повне ім'я користувача
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }

    /**
     * Додати кредитну карту до користувача
     */
    public void addCreditCard(CreditCard card) {
        creditCards.add(card);
        card.setUser(this);
    }

    /**
     * Видалити кредитну карту користувача
     */
    public void removeCreditCard(CreditCard card) {
        creditCards.remove(card);
        card.setUser(null);
    }
}