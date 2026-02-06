package ua.com.kisit.course2026np.entity;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import static org.junit.jupiter.api.Assertions.*;

import java.math.BigDecimal;

/**
 * Юніт-тести для сутності Payment
 */
@DisplayName("Payment Entity Tests")
class PaymentTest {

    private Payment payment;

    @BeforeEach
    void setUp() {
        payment = Payment.builder()
                .amount(BigDecimal.valueOf(100))
                .type(PaymentType.PAYMENT)
                .status(PaymentStatus.PENDING)
                .description("Test payment")
                .build();
    }

    @Nested
    @DisplayName("Payment Creation Tests")
    class PaymentCreationTests {

        @Test
        @DisplayName("Створення платежу з усіма полями")
        void testPaymentCreation() {
            assertAll(
                    () -> assertNotNull(payment),
                    () -> assertEquals(BigDecimal.valueOf(100), payment.getAmount()),
                    () -> assertEquals(PaymentType.PAYMENT, payment.getType()),
                    () -> assertEquals(PaymentStatus.PENDING, payment.getStatus()),
                    () -> assertEquals("Test payment", payment.getDescription())
            );
        }

        @Test
        @DisplayName("Статус за замовчуванням - PENDING")
        void testDefaultStatus() {
            Payment newPayment = new Payment();
            assertEquals(PaymentStatus.PENDING, newPayment.getStatus());
        }

        @Test
        @DisplayName("Створення платежу для поповнення")
        void testCreateReplenishmentPayment() {
            Payment replenishment = Payment.builder()
                    .amount(BigDecimal.valueOf(500))
                    .type(PaymentType.REPLENISHMENT)
                    .build();

            assertEquals(PaymentType.REPLENISHMENT, replenishment.getType());
        }

        @Test
        @DisplayName("Створення платежу для переказу")
        void testCreateTransferPayment() {
            Payment transfer = Payment.builder()
                    .amount(BigDecimal.valueOf(200))
                    .type(PaymentType.TRANSFER)
                    .recipientAccount("UA987654321098765432")
                    .senderAccount("UA123456789012345678")
                    .build();

            assertAll(
                    () -> assertEquals(PaymentType.TRANSFER, transfer.getType()),
                    () -> assertEquals("UA987654321098765432", transfer.getRecipientAccount()),
                    () -> assertEquals("UA123456789012345678", transfer.getSenderAccount())
            );
        }
    }

    @Nested
    @DisplayName("Payment Status Tests")
    class PaymentStatusTests {

        @Test
        @DisplayName("Завершення платежу")
        void testCompletePayment() {
            // Act
            payment.complete();

            // Assert
            assertAll(
                    () -> assertEquals(PaymentStatus.COMPLETED, payment.getStatus()),
                    () -> assertNotNull(payment.getCompletedAt()),
                    () -> assertTrue(payment.isCompleted()),
                    () -> assertFalse(payment.isFailed()),
                    () -> assertFalse(payment.isPending())
            );
        }

        @Test
        @DisplayName("Відхилення платежу з повідомленням про помилку")
        void testFailPayment() {
            // Arrange
            String errorMessage = "Insufficient funds";

            // Act
            payment.fail(errorMessage);

            // Assert
            assertAll(
                    () -> assertEquals(PaymentStatus.FAILED, payment.getStatus()),
                    () -> assertEquals(errorMessage, payment.getErrorMessage()),
                    () -> assertNotNull(payment.getCompletedAt()),
                    () -> assertTrue(payment.isFailed()),
                    () -> assertFalse(payment.isCompleted()),
                    () -> assertFalse(payment.isPending())
            );
        }

        @Test
        @DisplayName("Перевірка статусу PENDING")
        void testIsPending() {
            assertTrue(payment.isPending());
            assertFalse(payment.isCompleted());
            assertFalse(payment.isFailed());
        }

        @Test
        @DisplayName("Перевірка статусу після завершення")
        void testStatusChecksAfterCompletion() {
            // Act
            payment.complete();

            // Assert
            assertTrue(payment.isCompleted());
            assertFalse(payment.isPending());
            assertFalse(payment.isFailed());
        }

        @Test
        @DisplayName("Перевірка статусу після відхилення")
        void testStatusChecksAfterFailure() {
            // Act
            payment.fail("Error");

            // Assert
            assertTrue(payment.isFailed());
            assertFalse(payment.isPending());
            assertFalse(payment.isCompleted());
        }
    }

    @Nested
    @DisplayName("Payment Types Tests")
    class PaymentTypesTests {

        @Test
        @DisplayName("Платіж типу PAYMENT")
        void testPaymentType() {
            assertEquals(PaymentType.PAYMENT, payment.getType());
        }

        @Test
        @DisplayName("Платіж типу REPLENISHMENT")
        void testReplenishmentType() {
            Payment replenishment = Payment.builder()
                    .amount(BigDecimal.valueOf(500))
                    .type(PaymentType.REPLENISHMENT)
                    .build();

            assertEquals(PaymentType.REPLENISHMENT, replenishment.getType());
        }

        @Test
        @DisplayName("Платіж типу TRANSFER")
        void testTransferType() {
            Payment transfer = Payment.builder()
                    .amount(BigDecimal.valueOf(300))
                    .type(PaymentType.TRANSFER)
                    .build();

            assertEquals(PaymentType.TRANSFER, transfer.getType());
        }
    }

    @Nested
    @DisplayName("Payment-Account Relationship Tests")
    class PaymentAccountRelationshipTests {

        @Test
        @DisplayName("Встановлення зв'язку з рахунком")
        void testSetAccount() {
            // Arrange
            Account account = Account.builder()
                    .accountNumber("UA123456789012345678")
                    .build();

            // Act
            payment.setAccount(account);

            // Assert
            assertEquals(account, payment.getAccount());
        }
    }

    @Nested
    @DisplayName("Payment Amount Tests")
    class PaymentAmountTests {

        @Test
        @DisplayName("Платіж з різними сумами")
        void testDifferentAmounts() {
            Payment payment1 = Payment.builder()
                    .amount(BigDecimal.valueOf(0.01))
                    .type(PaymentType.PAYMENT)
                    .build();

            Payment payment2 = Payment.builder()
                    .amount(BigDecimal.valueOf(1000000))
                    .type(PaymentType.PAYMENT)
                    .build();

            assertAll(
                    () -> assertEquals(BigDecimal.valueOf(0.01), payment1.getAmount()),
                    () -> assertEquals(BigDecimal.valueOf(1000000), payment2.getAmount())
            );
        }

        @Test
        @DisplayName("Платіж з десятковими знаками")
        void testDecimalAmount() {
            Payment decimalPayment = Payment.builder()
                    .amount(BigDecimal.valueOf(123.45))
                    .type(PaymentType.PAYMENT)
                    .build();

            assertEquals(BigDecimal.valueOf(123.45), decimalPayment.getAmount());
        }
    }

    @Nested
    @DisplayName("Payment Description Tests")
    class PaymentDescriptionTests {

        @Test
        @DisplayName("Платіж з описом")
        void testPaymentWithDescription() {
            assertEquals("Test payment", payment.getDescription());
        }

        @Test
        @DisplayName("Платіж без опису")
        void testPaymentWithoutDescription() {
            Payment noDescPayment = Payment.builder()
                    .amount(BigDecimal.valueOf(100))
                    .type(PaymentType.PAYMENT)
                    .build();

            assertNull(noDescPayment.getDescription());
        }

        @Test
        @DisplayName("Платіж з довгим описом")
        void testPaymentWithLongDescription() {
            String longDescription = "Це дуже довгий опис платежу, " +
                    "який містить багато інформації про транзакцію";

            Payment longDescPayment = Payment.builder()
                    .amount(BigDecimal.valueOf(100))
                    .type(PaymentType.PAYMENT)
                    .description(longDescription)
                    .build();

            assertEquals(longDescription, longDescPayment.getDescription());
        }
    }

    @Nested
    @DisplayName("Complex Scenarios")
    class ComplexScenarios {

        @Test
        @DisplayName("Повний життєвий цикл успішного платежу")
        void testSuccessfulPaymentLifecycle() {
            // 1. Створення
            Payment newPayment = Payment.builder()
                    .amount(BigDecimal.valueOf(250))
                    .type(PaymentType.PAYMENT)
                    .description("Оплата послуг")
                    .build();

            assertEquals(PaymentStatus.PENDING, newPayment.getStatus());
            assertTrue(newPayment.isPending());

            // 2. Завершення
            newPayment.complete();

            assertEquals(PaymentStatus.COMPLETED, newPayment.getStatus());
            assertTrue(newPayment.isCompleted());
            assertNotNull(newPayment.getCompletedAt());
        }

        @Test
        @DisplayName("Повний життєвий цикл невдалого платежу")
        void testFailedPaymentLifecycle() {
            // 1. Створення
            Payment newPayment = Payment.builder()
                    .amount(BigDecimal.valueOf(1000))
                    .type(PaymentType.PAYMENT)
                    .description("Великий платіж")
                    .build();

            assertTrue(newPayment.isPending());

            // 2. Відхилення
            newPayment.fail("Недостатньо коштів на рахунку");

            assertAll(
                    () -> assertEquals(PaymentStatus.FAILED, newPayment.getStatus()),
                    () -> assertTrue(newPayment.isFailed()),
                    () -> assertEquals("Недостатньо коштів на рахунку",
                            newPayment.getErrorMessage()),
                    () -> assertNotNull(newPayment.getCompletedAt())
            );
        }

        @Test
        @DisplayName("Переказ між рахунками")
        void testTransferBetweenAccounts() {
            Payment transfer = Payment.builder()
                    .amount(BigDecimal.valueOf(500))
                    .type(PaymentType.TRANSFER)
                    .description("Переказ другу")
                    .senderAccount("UA111111111111111111")
                    .recipientAccount("UA222222222222222222")
                    .build();

            assertAll(
                    () -> assertEquals(PaymentType.TRANSFER, transfer.getType()),
                    () -> assertEquals("UA111111111111111111", transfer.getSenderAccount()),
                    () -> assertEquals("UA222222222222222222", transfer.getRecipientAccount()),
                    () -> assertEquals(BigDecimal.valueOf(500), transfer.getAmount())
            );

            transfer.complete();
            assertTrue(transfer.isCompleted());
        }
    }
}