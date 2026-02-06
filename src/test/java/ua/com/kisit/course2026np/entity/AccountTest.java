package ua.com.kisit.course2026np.entity;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import static org.junit.jupiter.api.Assertions.*;

import java.math.BigDecimal;

/**
 * Юніт-тести для сутності Account
 *
 * Ці тести перевіряють:
 * - Створення рахунків
 * - Операції поповнення (deposit)
 * - Операції зняття (withdraw)
 * - Блокування/розблокування рахунків
 * - Управління платежами
 */
@DisplayName("Account Entity Tests")
class AccountTest {

    private Account account;

    /**
     * Виконується перед кожним тестом
     * Створює новий екземпляр рахунку для тестування
     */
    @BeforeEach
    void setUp() {
        account = Account.builder()
                .accountNumber("UA123456789012345678")
                .balance(BigDecimal.valueOf(1000))
                .status(AccountStatus.ACTIVE)
                .build();
    }

    // ========== ТЕСТИ СТВОРЕННЯ РАХУНКУ ==========

    @Nested
    @DisplayName("Account Creation Tests")
    class AccountCreationTests {

        @Test
        @DisplayName("Створення рахунку з використанням Builder патерну")
        void testAccountCreationWithBuilder() {
            // Arrange & Act
            Account newAccount = Account.builder()
                    .accountNumber("UA987654321098765432")
                    .balance(BigDecimal.ZERO)
                    .status(AccountStatus.ACTIVE)
                    .build();

            // Assert - перевіряємо всі поля одразу
            assertAll(
                    () -> assertNotNull(newAccount, "Рахунок не повинен бути null"),
                    () -> assertEquals("UA987654321098765432", newAccount.getAccountNumber()),
                    () -> assertEquals(BigDecimal.ZERO, newAccount.getBalance()),
                    () -> assertEquals(AccountStatus.ACTIVE, newAccount.getStatus())
            );
        }

        @Test
        @DisplayName("Рахунок повинен мати дефолтні значення")
        void testDefaultValues() {
            // Arrange & Act
            Account defaultAccount = new Account();

            // Assert
            assertEquals(BigDecimal.ZERO, defaultAccount.getBalance(),
                    "Початковий баланс має бути 0");
            assertEquals(AccountStatus.ACTIVE, defaultAccount.getStatus(),
                    "Статус за замовчуванням має бути ACTIVE");
        }
    }

    // ========== ТЕСТИ ПОПОВНЕННЯ ==========

    @Nested
    @DisplayName("Deposit Tests")
    class DepositTests {

        @Test
        @DisplayName("Успішне поповнення рахунку коректною сумою")
        void testDepositValidAmount() {
            // Arrange
            BigDecimal initialBalance = account.getBalance();
            BigDecimal depositAmount = BigDecimal.valueOf(500);
            BigDecimal expectedBalance = initialBalance.add(depositAmount);

            // Act
            account.deposit(depositAmount);

            // Assert
            assertEquals(expectedBalance, account.getBalance(),
                    "Баланс має збільшитись на суму поповнення");
            assertEquals(BigDecimal.valueOf(1500), account.getBalance());
        }

        @Test
        @DisplayName("Виключення при спробі поповнення на null")
        void testDepositNullAmount() {
            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> account.deposit(null),
                    "Має бути викинуто IllegalArgumentException"
            );

            assertEquals("Сума поповнення має бути більше нуля",
                    exception.getMessage());
        }

        @Test
        @DisplayName("Виключення при поповненні на 0 або від'ємну суму")
        void testDepositZeroOrNegativeAmount() {
            // Перевіряємо декілька випадків разом
            assertAll(
                    () -> assertThrows(IllegalArgumentException.class,
                            () -> account.deposit(BigDecimal.ZERO),
                            "Не можна поповнити на 0"),
                    () -> assertThrows(IllegalArgumentException.class,
                            () -> account.deposit(BigDecimal.valueOf(-100)),
                            "Не можна поповнити на від'ємну суму")
            );
        }

        @Test
        @DisplayName("Не можна поповнити заблокований рахунок")
        void testDepositToBlockedAccount() {
            // Arrange
            account.setStatus(AccountStatus.BLOCKED);

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> account.deposit(BigDecimal.valueOf(100))
            );

            assertEquals("Неможливо поповнити заблокований рахунок",
                    exception.getMessage());
        }

        @Test
        @DisplayName("Баланс не змінюється при невдалому поповненні")
        void testBalanceNotChangedOnFailedDeposit() {
            // Arrange
            BigDecimal initialBalance = account.getBalance();
            account.setStatus(AccountStatus.BLOCKED);

            // Act
            try {
                account.deposit(BigDecimal.valueOf(100));
            } catch (IllegalStateException e) {
                // Очікуване виключення
            }

            // Assert
            assertEquals(initialBalance, account.getBalance(),
                    "Баланс не повинен змінитись при невдалому поповненні");
        }
    }

    // ========== ТЕСТИ ЗНЯТТЯ КОШТІВ ==========

    @Nested
    @DisplayName("Withdraw Tests")
    class WithdrawTests {

        @Test
        @DisplayName("Успішне зняття коректної суми")
        void testWithdrawValidAmount() {
            // Arrange
            BigDecimal initialBalance = account.getBalance();
            BigDecimal withdrawAmount = BigDecimal.valueOf(300);
            BigDecimal expectedBalance = initialBalance.subtract(withdrawAmount);

            // Act
            account.withdraw(withdrawAmount);

            // Assert
            assertEquals(expectedBalance, account.getBalance(),
                    "Баланс має зменшитись на суму зняття");
            assertEquals(BigDecimal.valueOf(700), account.getBalance());
        }

        @Test
        @DisplayName("Можна зняти весь баланс")
        void testWithdrawAllBalance() {
            // Arrange
            BigDecimal allBalance = account.getBalance();

            // Act
            account.withdraw(allBalance);

            // Assert
            assertEquals(BigDecimal.ZERO, account.getBalance(),
                    "Після зняття всього балансу має залишитись 0");
        }

        @Test
        @DisplayName("Виключення при спробі зняти більше ніж є на рахунку")
        void testWithdrawInsufficientFunds() {
            // Arrange
            BigDecimal tooMuch = account.getBalance().add(BigDecimal.valueOf(500));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> account.withdraw(tooMuch)
            );

            assertEquals("Недостатньо коштів на рахунку",
                    exception.getMessage());
        }

        @Test
        @DisplayName("Не можна зняти кошти з заблокованого рахунку")
        void testWithdrawFromBlockedAccount() {
            // Arrange
            account.setStatus(AccountStatus.BLOCKED);

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> account.withdraw(BigDecimal.valueOf(100))
            );

            assertEquals("Неможливо зняти кошти із заблокованого рахунку",
                    exception.getMessage());
        }

        @Test
        @DisplayName("Виключення для некоректних сум зняття")
        void testWithdrawInvalidAmounts() {
            // Перевіряємо всі некоректні випадки
            assertAll(
                    () -> assertThrows(IllegalArgumentException.class,
                            () -> account.withdraw(null),
                            "Не можна зняти null"),
                    () -> assertThrows(IllegalArgumentException.class,
                            () -> account.withdraw(BigDecimal.ZERO),
                            "Не можна зняти 0"),
                    () -> assertThrows(IllegalArgumentException.class,
                            () -> account.withdraw(BigDecimal.valueOf(-50)),
                            "Не можна зняти від'ємну суму")
            );
        }

        @Test
        @DisplayName("Баланс не змінюється при невдалому знятті")
        void testBalanceNotChangedOnFailedWithdraw() {
            // Arrange
            BigDecimal initialBalance = account.getBalance();

            // Act
            try {
                account.withdraw(BigDecimal.valueOf(5000));
            } catch (IllegalStateException e) {
                // Очікуване виключення
            }

            // Assert
            assertEquals(initialBalance, account.getBalance(),
                    "Баланс не повинен змінитись при невдалому знятті");
        }
    }

    // ========== ТЕСТИ СТАТУСУ РАХУНКУ ==========

    @Nested
    @DisplayName("Account Status Tests")
    class AccountStatusTests {

        @Test
        @DisplayName("Блокування рахунку")
        void testBlockAccount() {
            // Arrange
            assertTrue(account.isActive(), "Спочатку рахунок має бути активним");

            // Act
            account.block();

            // Assert
            assertAll(
                    () -> assertEquals(AccountStatus.BLOCKED, account.getStatus()),
                    () -> assertFalse(account.isActive())
            );
        }

        @Test
        @DisplayName("Розблокування рахунку")
        void testUnblockAccount() {
            // Arrange
            account.setStatus(AccountStatus.BLOCKED);
            assertFalse(account.isActive(), "Рахунок має бути заблокованим");

            // Act
            account.unblock();

            // Assert
            assertAll(
                    () -> assertEquals(AccountStatus.ACTIVE, account.getStatus()),
                    () -> assertTrue(account.isActive())
            );
        }

        @Test
        @DisplayName("Перевірка активності рахунку")
        void testIsActive() {
            // Активний рахунок
            assertTrue(account.isActive(), "Активний рахунок має повертати true");

            // Блокований рахунок
            account.block();
            assertFalse(account.isActive(), "Заблокований рахунок має повертати false");

            // Знову активний
            account.unblock();
            assertTrue(account.isActive(), "Розблокований рахунок має бути активним");
        }

        @Test
        @DisplayName("Подвійне блокування не змінює статус")
        void testDoubleBlock() {
            // Act
            account.block();
            AccountStatus firstStatus = account.getStatus();
            account.block();
            AccountStatus secondStatus = account.getStatus();

            // Assert
            assertEquals(firstStatus, secondStatus,
                    "Подвійне блокування не має змінювати статус");
            assertEquals(AccountStatus.BLOCKED, secondStatus);
        }
    }

    // ========== ТЕСТИ УПРАВЛІННЯ ПЛАТЕЖАМИ ==========

    @Nested
    @DisplayName("Payment Management Tests")
    class PaymentManagementTests {

        @Test
        @DisplayName("Додавання платежу до рахунку")
        void testAddPayment() {
            // Arrange
            Payment payment = Payment.builder()
                    .amount(BigDecimal.valueOf(100))
                    .type(PaymentType.PAYMENT)
                    .build();

            // Act
            account.addPayment(payment);

            // Assert
            assertAll(
                    () -> assertTrue(account.getPayments().contains(payment),
                            "Рахунок має містити доданий платіж"),
                    () -> assertEquals(account, payment.getAccount(),
                            "Платіж має посилатись на цей рахунок")
            );
        }

        @Test
        @DisplayName("Видалення платежу з рахунку")
        void testRemovePayment() {
            // Arrange
            Payment payment = Payment.builder()
                    .amount(BigDecimal.valueOf(100))
                    .type(PaymentType.PAYMENT)
                    .build();
            account.addPayment(payment);

            // Act
            account.removePayment(payment);

            // Assert
            assertAll(
                    () -> assertFalse(account.getPayments().contains(payment),
                            "Рахунок не має містити видалений платіж"),
                    () -> assertNull(payment.getAccount(),
                            "Платіж не має посилатись на рахунок")
            );
        }

        @Test
        @DisplayName("Додавання кількох платежів")
        void testAddMultiplePayments() {
            // Arrange
            Payment payment1 = Payment.builder()
                    .amount(BigDecimal.valueOf(100))
                    .type(PaymentType.PAYMENT)
                    .build();
            Payment payment2 = Payment.builder()
                    .amount(BigDecimal.valueOf(200))
                    .type(PaymentType.REPLENISHMENT)
                    .build();

            // Act
            account.addPayment(payment1);
            account.addPayment(payment2);

            // Assert
            assertEquals(2, account.getPayments().size(),
                    "Рахунок має містити 2 платежі");
            assertTrue(account.getPayments().contains(payment1));
            assertTrue(account.getPayments().contains(payment2));
        }
    }

    // ========== КОМПЛЕКСНІ ТЕСТИ ==========

    @Nested
    @DisplayName("Complex Scenario Tests")
    class ComplexScenarioTests {

        @Test
        @DisplayName("Послідовність операцій: поповнення, зняття, поповнення")
        void testSequenceOfOperations() {
            // Arrange
            BigDecimal initialBalance = BigDecimal.valueOf(1000);

            // Act & Assert
            assertEquals(initialBalance, account.getBalance());

            account.deposit(BigDecimal.valueOf(500));
            assertEquals(BigDecimal.valueOf(1500), account.getBalance());

            account.withdraw(BigDecimal.valueOf(700));
            assertEquals(BigDecimal.valueOf(800), account.getBalance());

            account.deposit(BigDecimal.valueOf(200));
            assertEquals(BigDecimal.valueOf(1000), account.getBalance());
        }

        @Test
        @DisplayName("Операції після блокування мають викидати виключення")
        void testOperationsAfterBlocking() {
            // Arrange
            account.block();

            // Assert
            assertAll(
                    () -> assertThrows(IllegalStateException.class,
                            () -> account.deposit(BigDecimal.valueOf(100))),
                    () -> assertThrows(IllegalStateException.class,
                            () -> account.withdraw(BigDecimal.valueOf(100)))
            );
        }

        @Test
        @DisplayName("Операції після розблокування працюють нормально")
        void testOperationsAfterUnblocking() {
            // Arrange
            account.block();
            account.unblock();
            BigDecimal initialBalance = account.getBalance();

            // Act
            account.deposit(BigDecimal.valueOf(100));
            account.withdraw(BigDecimal.valueOf(50));

            // Assert
            assertEquals(initialBalance.add(BigDecimal.valueOf(50)),
                    account.getBalance());
        }
    }
}