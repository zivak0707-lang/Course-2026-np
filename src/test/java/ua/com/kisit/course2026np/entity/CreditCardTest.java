package ua.com.kisit.course2026np.entity;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;

/**
 * Юніт-тести для сутності CreditCard
 */
@DisplayName("CreditCard Entity Tests")
class CreditCardTest {

    private CreditCard card;

    @BeforeEach
    void setUp() {
        card = CreditCard.builder()
                .cardNumber("1234567890123456")
                .cardholderName("IVAN PETRENKO")
                .expiryDate(LocalDate.of(2027, 12, 31))
                .cvv("123")
                .isActive(true)
                .build();
    }

    @Nested
    @DisplayName("Card Creation Tests")
    class CardCreationTests {

        @Test
        @DisplayName("Створення карти з усіма полями")
        void testCardCreation() {
            assertAll(
                    () -> assertNotNull(card),
                    () -> assertEquals("1234567890123456", card.getCardNumber()),
                    () -> assertEquals("IVAN PETRENKO", card.getCardholderName()),
                    () -> assertEquals(LocalDate.of(2027, 12, 31), card.getExpiryDate()),
                    () -> assertEquals("123", card.getCvv()),
                    () -> assertTrue(card.getIsActive())
            );
        }

        @Test
        @DisplayName("Карта активна за замовчуванням")
        void testDefaultActiveStatus() {
            CreditCard newCard = new CreditCard();
            assertTrue(newCard.getIsActive());
        }
    }

    @Nested
    @DisplayName("Card Expiry Tests")
    class CardExpiryTests {

        @Test
        @DisplayName("Карта не прострочена для майбутньої дати")
        void testCardNotExpired() {
            assertFalse(card.isExpired());
        }

        @Test
        @DisplayName("Карта прострочена для минулої дати")
        void testCardExpired() {
            // Arrange
            card.setExpiryDate(LocalDate.of(2020, 1, 1));

            // Assert
            assertTrue(card.isExpired());
        }

        @Test
        @DisplayName("Карта прострочена для сьогоднішньої дати")
        void testCardExpiredToday() {
            // Arrange
            card.setExpiryDate(LocalDate.now());

            // Assert
            assertTrue(card.isExpired());
        }

        @Test
        @DisplayName("Карта не прострочена для завтрашньої дати")
        void testCardNotExpiredTomorrow() {
            // Arrange
            card.setExpiryDate(LocalDate.now().plusDays(1));

            // Assert
            assertFalse(card.isExpired());
        }

        @Test
        @DisplayName("Карта прострочена для вчорашньої дати")
        void testCardExpiredYesterday() {
            // Arrange
            card.setExpiryDate(LocalDate.now().minusDays(1));

            // Assert
            assertTrue(card.isExpired());
        }
    }

    @Nested
    @DisplayName("Card Masking Tests")
    class CardMaskingTests {

        @Test
        @DisplayName("Маскування номера карти")
        void testGetMaskedCardNumber() {
            String masked = card.getMaskedCardNumber();
            assertEquals("**** **** **** 3456", masked);
        }

        @Test
        @DisplayName("Маскування різних номерів карток")
        void testMaskingDifferentCardNumbers() {
            card.setCardNumber("9876543210987654");
            assertEquals("**** **** **** 7654", card.getMaskedCardNumber());

            card.setCardNumber("1111222233334444");
            assertEquals("**** **** **** 4444", card.getMaskedCardNumber());
        }

        @Test
        @DisplayName("Порожній рядок для null номера карти")
        void testMaskedCardNumberForNull() {
            card.setCardNumber(null);
            assertEquals("", card.getMaskedCardNumber());
        }

        @Test
        @DisplayName("Порожній рядок для некоректної довжини номера")
        void testMaskedCardNumberForInvalidLength() {
            card.setCardNumber("123456");
            assertEquals("", card.getMaskedCardNumber());

            card.setCardNumber("12345678901234567");
            assertEquals("", card.getMaskedCardNumber());
        }

        @Test
        @DisplayName("Порожній рядок для порожнього номера")
        void testMaskedCardNumberForEmptyString() {
            card.setCardNumber("");
            assertEquals("", card.getMaskedCardNumber());
        }
    }

    @Nested
    @DisplayName("Card-Account Relationship Tests")
    class CardAccountRelationshipTests {

        @Test
        @DisplayName("Встановлення зв'язку з рахунком")
        void testSetAccount() {
            // Arrange
            Account account = Account.builder()
                    .accountNumber("UA123456789012345678")
                    .build();

            // Act
            card.setAccount(account);

            // Assert
            assertAll(
                    () -> assertEquals(account, card.getAccount()),
                    () -> assertEquals(card, account.getCreditCard())
            );
        }

        @Test
        @DisplayName("Двостороннє встановлення зв'язку")
        void testBidirectionalRelationship() {
            // Arrange
            Account account = Account.builder()
                    .accountNumber("UA123456789012345678")
                    .build();

            // Act
            card.setAccount(account);

            // Assert - перевіряємо обидві сторони зв'язку
            assertEquals(card.getAccount(), account);
            assertEquals(account.getCreditCard(), card);
        }
    }

    @Nested
    @DisplayName("Card-User Relationship Tests")
    class CardUserRelationshipTests {

        @Test
        @DisplayName("Встановлення зв'язку з користувачем")
        void testSetUser() {
            // Arrange
            User user = User.builder()
                    .firstName("Іван")
                    .lastName("Петренко")
                    .email("ivan@example.com")
                    .build();

            // Act
            card.setUser(user);

            // Assert
            assertEquals(user, card.getUser());
        }
    }

    @Nested
    @DisplayName("Card State Tests")
    class CardStateTests {

        @Test
        @DisplayName("Деактивація карти")
        void testDeactivateCard() {
            // Act
            card.setIsActive(false);

            // Assert
            assertFalse(card.getIsActive());
        }

        @Test
        @DisplayName("Активація карти")
        void testActivateCard() {
            // Arrange
            card.setIsActive(false);

            // Act
            card.setIsActive(true);

            // Assert
            assertTrue(card.getIsActive());
        }
    }

    @Nested
    @DisplayName("Complex Scenarios")
    class ComplexScenarios {

        @Test
        @DisplayName("Прострочена карта має бути деактивована")
        void testExpiredCardShouldBeDeactivated() {
            // Arrange
            card.setExpiryDate(LocalDate.of(2020, 1, 1));

            // Act
            if (card.isExpired()) {
                card.setIsActive(false);
            }

            // Assert
            assertTrue(card.isExpired());
            assertFalse(card.getIsActive());
        }

        @Test
        @DisplayName("Активна карта з майбутньою датою")
        void testActiveCardWithFutureDate() {
            // Assert
            assertFalse(card.isExpired());
            assertTrue(card.getIsActive());
        }
    }
}