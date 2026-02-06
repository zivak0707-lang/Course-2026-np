package ua.com.kisit.course2026np.entity;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Юніт-тести для сутності User
 */
@DisplayName("User Entity Tests")
class UserTest {

    private User user;

    @BeforeEach
    void setUp() {
        user = User.builder()
                .firstName("Іван")
                .lastName("Петренко")
                .email("ivan@example.com")
                .password("password123")
                .role(UserRole.CLIENT)
                .isActive(true)
                .build();
    }

    @Nested
    @DisplayName("User Creation Tests")
    class UserCreationTests {

        @Test
        @DisplayName("Створення користувача з усіма полями")
        void testUserCreation() {
            assertAll(
                    () -> assertNotNull(user),
                    () -> assertEquals("Іван", user.getFirstName()),
                    () -> assertEquals("Петренко", user.getLastName()),
                    () -> assertEquals("ivan@example.com", user.getEmail()),
                    () -> assertEquals(UserRole.CLIENT, user.getRole()),
                    () -> assertTrue(user.getIsActive())
            );
        }

        @Test
        @DisplayName("Роль за замовчуванням - CLIENT")
        void testDefaultRole() {
            User newUser = new User();
            assertEquals(UserRole.CLIENT, newUser.getRole());
        }

        @Test
        @DisplayName("Користувач активний за замовчуванням")
        void testDefaultActiveStatus() {
            User newUser = new User();
            assertTrue(newUser.getIsActive());
        }

        @Test
        @DisplayName("Створення адміністратора")
        void testCreateAdmin() {
            User admin = User.builder()
                    .firstName("Адмін")
                    .lastName("Системи")
                    .email("admin@example.com")
                    .password("admin123")
                    .role(UserRole.ADMIN)
                    .build();

            assertEquals(UserRole.ADMIN, admin.getRole());
        }
    }

    @Nested
    @DisplayName("User Methods Tests")
    class UserMethodsTests {

        @Test
        @DisplayName("getFullName повертає повне ім'я")
        void testGetFullName() {
            String fullName = user.getFullName();
            assertEquals("Іван Петренко", fullName);
        }

        @Test
        @DisplayName("getFullName з іншими даними")
        void testGetFullNameDifferentData() {
            user.setFirstName("Марія");
            user.setLastName("Шевченко");

            assertEquals("Марія Шевченко", user.getFullName());
        }
    }

    @Nested
    @DisplayName("Credit Card Management Tests")
    class CreditCardManagementTests {

        @Test
        @DisplayName("Додавання кредитної карти до користувача")
        void testAddCreditCard() {
            // Arrange
            CreditCard card = CreditCard.builder()
                    .cardNumber("1234567890123456")
                    .cardholderName("IVAN PETRENKO")
                    .build();

            // Act
            user.addCreditCard(card);

            // Assert
            assertAll(
                    () -> assertTrue(user.getCreditCards().contains(card)),
                    () -> assertEquals(user, card.getUser()),
                    () -> assertEquals(1, user.getCreditCards().size())
            );
        }

        @Test
        @DisplayName("Видалення кредитної карти")
        void testRemoveCreditCard() {
            // Arrange
            CreditCard card = CreditCard.builder()
                    .cardNumber("1234567890123456")
                    .cardholderName("IVAN PETRENKO")
                    .build();
            user.addCreditCard(card);

            // Act
            user.removeCreditCard(card);

            // Assert
            assertAll(
                    () -> assertFalse(user.getCreditCards().contains(card)),
                    () -> assertNull(card.getUser()),
                    () -> assertEquals(0, user.getCreditCards().size())
            );
        }

        @Test
        @DisplayName("Додавання кількох кредитних карток")
        void testAddMultipleCreditCards() {
            // Arrange
            CreditCard card1 = CreditCard.builder()
                    .cardNumber("1234567890123456")
                    .cardholderName("IVAN PETRENKO")
                    .build();
            CreditCard card2 = CreditCard.builder()
                    .cardNumber("6543210987654321")
                    .cardholderName("IVAN PETRENKO")
                    .build();

            // Act
            user.addCreditCard(card1);
            user.addCreditCard(card2);

            // Assert
            assertEquals(2, user.getCreditCards().size());
            assertTrue(user.getCreditCards().contains(card1));
            assertTrue(user.getCreditCards().contains(card2));
        }
    }

    @Nested
    @DisplayName("User State Tests")
    class UserStateTests {

        @Test
        @DisplayName("Деактивація користувача")
        void testDeactivateUser() {
            // Act
            user.setIsActive(false);

            // Assert
            assertFalse(user.getIsActive());
        }

        @Test
        @DisplayName("Активація користувача")
        void testActivateUser() {
            // Arrange
            user.setIsActive(false);

            // Act
            user.setIsActive(true);

            // Assert
            assertTrue(user.getIsActive());
        }
    }

    @Nested
    @DisplayName("User Role Tests")
    class UserRoleTests {

        @Test
        @DisplayName("Зміна ролі на ADMIN")
        void testChangeRoleToAdmin() {
            // Act
            user.setRole(UserRole.ADMIN);

            // Assert
            assertEquals(UserRole.ADMIN, user.getRole());
        }

        @Test
        @DisplayName("Зміна ролі на CLIENT")
        void testChangeRoleToClient() {
            // Arrange
            user.setRole(UserRole.ADMIN);

            // Act
            user.setRole(UserRole.CLIENT);

            // Assert
            assertEquals(UserRole.CLIENT, user.getRole());
        }
    }
}