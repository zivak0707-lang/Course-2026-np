package ua.com.kisit.course2026np.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import java.time.LocalDate;

@Entity
@Table(name = "credit_cards")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreditCard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Номер карти обов'язковий")
    @Pattern(regexp = "\\d{16}", message = "Номер карти має містити 16 цифр")
    @Column(unique = true, nullable = false, length = 16)
    private String cardNumber;

    @NotBlank(message = "Ім'я власника обов'язкове")
    @Column(nullable = false)
    private String cardholderName;

    @Column(nullable = false)
    private LocalDate expiryDate;

    @NotBlank(message = "CVV обов'язковий")
    @Pattern(regexp = "\\d{3}", message = "CVV має містити 3 цифри")
    @Column(nullable = false, length = 3)
    private String cvv;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private ua.com.kisit.course2026np.entity.User user;

    @OneToOne(mappedBy = "creditCard", cascade = CascadeType.ALL)
    private ua.com.kisit.course2026np.entity.Account account;
}