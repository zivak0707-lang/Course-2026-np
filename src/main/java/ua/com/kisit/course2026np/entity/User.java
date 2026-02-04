package ua.com.kisit.course2026np.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import ua.com.kisit.course2026np.entity.UserRole;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Ім'я обов'язкове")
    @Column(nullable = false)
    private String firstName;

    @NotBlank(message = "Прізвище обов'язкове")
    @Column(nullable = false)
    private String lastName;

    @Email(message = "Невірний формат email")
    @NotBlank(message = "Email обов'язковий")
    @Column(unique = true, nullable = false)
    private String email;

    @NotBlank(message = "Пароль обов'язковий")
    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role = UserRole.CLIENT;

    @Column(nullable = false)
    private Boolean isActive = true;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ua.com.kisit.course2026np.entity.CreditCard> creditCards = new ArrayList<>();
}