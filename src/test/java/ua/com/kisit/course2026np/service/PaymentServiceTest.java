package ua.com.kisit.course2026np.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.AccountRepository;
import ua.com.kisit.course2026np.repository.PaymentRepository;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * =====================================================================
 * PaymentService Unit Tests
 * =====================================================================
 *
 * ЯК ЗАПУСТИТИ:
 *   mvn test -Dtest=PaymentServiceTest
 *   або у IntelliJ IDEA: правою кнопкою на класі → Run 'PaymentServiceTest'
 *
 * ЗАЛЕЖНОСТІ (вже є у spring-boot-starter-test):
 *   - JUnit 5
 *   - Mockito
 *   - AssertJ
 * =====================================================================
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("PaymentService Tests")
class PaymentServiceTest {

    @Mock
    private PaymentRepository paymentRepository;

    @Mock
    private AccountRepository accountRepository;

    @InjectMocks
    private PaymentService paymentService;

    // ─── спільні тестові об'єкти ───────────────────────────────────────
    private Account savingsAccount;
    private Account checkingAccount;
    private Payment replenishmentPayment;
    private Payment regularPayment;

    @BeforeEach
    void setUp() {
        savingsAccount = Account.builder()
                .id(1L)
                .accountName("Savings Account")
                .accountNumber("UA111111111111111111")
                .balance(BigDecimal.ZERO)
                .status(AccountStatus.ACTIVE)
                .build();

        checkingAccount = Account.builder()
                .id(2L)
                .accountName("Checking Account")
                .accountNumber("UA222222222222222222")
                .balance(new BigDecimal("2678.00"))
                .status(AccountStatus.ACTIVE)
                .build();

        replenishmentPayment = Payment.builder()
                .amount(new BigDecimal("500.00"))
                .type(PaymentType.REPLENISHMENT)
                .description("Test top up")
                .build();

        regularPayment = Payment.builder()
                .amount(new BigDecimal("100.00"))
                .type(PaymentType.PAYMENT)
                .description("Test payment")
                .build();
    }

    // =====================================================================
    // БАГ #1 — executeReplenishment: НЕ перевіряє статус рахунку
    // =====================================================================
    @Nested
    @DisplayName("executeReplenishment — БАГ #1")
    class ExecuteReplenishmentTests {

        @Test
        @DisplayName("✅ Успішне поповнення активного savings рахунку")
        void shouldReplenishActiveAccount() {
            // GIVEN
            when(accountRepository.findById(1L)).thenReturn(Optional.of(savingsAccount));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));
            when(accountRepository.save(any(Account.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executeReplenishment(1L, replenishmentPayment);

            // THEN
            assertThat(result.getStatus()).isEqualTo(PaymentStatus.COMPLETED);
            assertThat(result.getRecipientAccount()).isEqualTo("UA111111111111111111");

            // Перевіряємо що баланс дійсно збільшився
            ArgumentCaptor<Account> accountCaptor = ArgumentCaptor.forClass(Account.class);
            verify(accountRepository).save(accountCaptor.capture());
            assertThat(accountCaptor.getValue().getBalance())
                    .isEqualByComparingTo(new BigDecimal("500.00"));
        }

        @Test
        @DisplayName("🐛 БАГ: поповнення ЗАБЛОКОВАНОГО рахунку — має повертати FAILED (зараз не перевіряється!)")
        void shouldFailReplenishmentForBlockedAccount() {
            // GIVEN — savings рахунок заблокований
            savingsAccount.block(); // status = BLOCKED
            when(accountRepository.findById(1L)).thenReturn(Optional.of(savingsAccount));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executeReplenishment(1L, replenishmentPayment);

            // THEN — очікуємо FAILED, але зараз повертає COMPLETED (це і є баг!)
            // Після фіксу цей тест має ПРОХОДИТИ:
            assertThat(result.getStatus())
                    .as("Поповнення заблокованого рахунку має повернути FAILED")
                    .isEqualTo(PaymentStatus.FAILED);

            // Баланс НЕ повинен змінитись
            verify(accountRepository, never()).save(argThat(
                    acc -> acc.getBalance().compareTo(BigDecimal.ZERO) > 0
            ));
        }

        @Test
        @DisplayName("🐛 БАГ: payment.setAccount() не встановлюється коли account не знайдено")
        void shouldThrowWhenAccountNotFound() {
            // GIVEN
            when(accountRepository.findById(999L)).thenReturn(Optional.empty());

            // THEN — має кидати виключення
            assertThatThrownBy(() ->
                    paymentService.executeReplenishment(999L, replenishmentPayment)
            ).isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Account not found");
        }

        @Test
        @DisplayName("✅ Перевіряємо що сума правильно додається до поточного балансу")
        void shouldAddAmountToExistingBalance() {
            // GIVEN — savings вже має $200
            savingsAccount = Account.builder()
                    .id(1L)
                    .accountName("Savings Account")
                    .accountNumber("UA111111111111111111")
                    .balance(new BigDecimal("200.00"))
                    .status(AccountStatus.ACTIVE)
                    .build();

            when(accountRepository.findById(1L)).thenReturn(Optional.of(savingsAccount));
            when(accountRepository.save(any(Account.class))).thenAnswer(inv -> inv.getArgument(0));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN — поповнюємо на $500
            paymentService.executeReplenishment(1L, replenishmentPayment);

            // THEN — баланс має бути $700
            ArgumentCaptor<Account> captor = ArgumentCaptor.forClass(Account.class);
            verify(accountRepository).save(captor.capture());
            assertThat(captor.getValue().getBalance())
                    .isEqualByComparingTo(new BigDecimal("700.00"));
        }
    }

    // =====================================================================
    // БАГ #2 — executePayment: НЕ перевіряє статус рахунку
    // =====================================================================
    @Nested
    @DisplayName("executePayment — БАГ #2")
    class ExecutePaymentTests {

        @Test
        @DisplayName("✅ Успішний платіж з достатніми коштами")
        void shouldExecutePaymentSuccessfully() {
            // GIVEN
            when(accountRepository.findById(2L)).thenReturn(Optional.of(checkingAccount));
            when(accountRepository.save(any(Account.class))).thenAnswer(inv -> inv.getArgument(0));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executePayment(2L, regularPayment);

            // THEN
            assertThat(result.getStatus()).isEqualTo(PaymentStatus.COMPLETED);
            assertThat(result.getSenderAccount()).isEqualTo("UA222222222222222222");
        }

        @Test
        @DisplayName("✅ FAILED при недостатньому балансі")
        void shouldFailPaymentWhenInsufficientFunds() {
            // GIVEN — рахунок з $50
            checkingAccount.setBalance(new BigDecimal("50.00"));
            when(accountRepository.findById(2L)).thenReturn(Optional.of(checkingAccount));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN — намагаємось заплатити $100
            Payment result = paymentService.executePayment(2L, regularPayment);

            // THEN
            assertThat(result.getStatus()).isEqualTo(PaymentStatus.FAILED);
            assertThat(result.getErrorMessage()).isEqualTo("Insufficient funds");
        }

        @Test
        @DisplayName("🐛 БАГ: платіж із ЗАБЛОКОВАНОГО рахунку має повертати FAILED")
        void shouldFailPaymentForBlockedAccount() {
            // GIVEN
            checkingAccount.block();
            when(accountRepository.findById(2L)).thenReturn(Optional.of(checkingAccount));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executePayment(2L, regularPayment);

            // THEN — зараз цей тест ПАДАЄ (баг), після фіксу має проходити
            assertThat(result.getStatus())
                    .as("Платіж з заблокованого рахунку має бути FAILED")
                    .isEqualTo(PaymentStatus.FAILED);
            assertThat(result.getErrorMessage()).contains("blocked");

            // Баланс не має змінитись
            verify(accountRepository, never()).save(any());
        }
    }

    // =====================================================================
    // БАГ #3 — executeTransfer: self-transfer перевірка не зберігає account
    // =====================================================================
    @Nested
    @DisplayName("executeTransfer — БАГ #3")
    class ExecuteTransferTests {

        @Test
        @DisplayName("✅ Успішний переказ між двома рахунками")
        void shouldTransferBetweenAccounts() {
            // GIVEN
            Payment transferPayment = Payment.builder()
                    .amount(new BigDecimal("200.00"))
                    .type(PaymentType.TRANSFER)
                    .description("Transfer")
                    .build();

            when(accountRepository.findById(2L)).thenReturn(Optional.of(checkingAccount));
            when(accountRepository.findByAccountNumber("UA111111111111111111"))
                    .thenReturn(Optional.of(savingsAccount));
            when(accountRepository.save(any(Account.class))).thenAnswer(inv -> inv.getArgument(0));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executeTransfer(
                    2L, "UA111111111111111111", transferPayment);

            // THEN
            assertThat(result.getStatus()).isEqualTo(PaymentStatus.COMPLETED);
            // Відправник зменшився
            assertThat(checkingAccount.getBalance()).isEqualByComparingTo(new BigDecimal("2478.00"));
            // Отримувач збільшився
            assertThat(savingsAccount.getBalance()).isEqualByComparingTo(new BigDecimal("200.00"));
        }

        @Test
        @DisplayName("✅ FAILED при переказі на себе")
        void shouldFailSelfTransfer() {
            // GIVEN
            Payment transferPayment = Payment.builder()
                    .amount(new BigDecimal("100.00"))
                    .type(PaymentType.TRANSFER)
                    .build();

            when(accountRepository.findById(2L)).thenReturn(Optional.of(checkingAccount));
            when(accountRepository.findByAccountNumber("UA222222222222222222"))
                    .thenReturn(Optional.of(checkingAccount)); // той самий рахунок
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executeTransfer(
                    2L, "UA222222222222222222", transferPayment);

            // THEN
            assertThat(result.getStatus()).isEqualTo(PaymentStatus.FAILED);
            assertThat(result.getErrorMessage()).contains("same account");
        }

        @Test
        @DisplayName("✅ FAILED якщо відправник заблокований")
        void shouldFailTransferFromBlockedSender() {
            // GIVEN
            checkingAccount.block();
            Payment transferPayment = Payment.builder()
                    .amount(new BigDecimal("100.00"))
                    .type(PaymentType.TRANSFER)
                    .build();

            when(accountRepository.findById(2L)).thenReturn(Optional.of(checkingAccount));
            when(accountRepository.findByAccountNumber("UA111111111111111111"))
                    .thenReturn(Optional.of(savingsAccount));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executeTransfer(
                    2L, "UA111111111111111111", transferPayment);

            // THEN
            assertThat(result.getStatus()).isEqualTo(PaymentStatus.FAILED);
            assertThat(result.getErrorMessage()).contains("blocked");
        }

        @Test
        @DisplayName("✅ FAILED якщо одержувач заблокований")
        void shouldFailTransferToBlockedRecipient() {
            // GIVEN
            savingsAccount.block();
            Payment transferPayment = Payment.builder()
                    .amount(new BigDecimal("100.00"))
                    .type(PaymentType.TRANSFER)
                    .build();

            when(accountRepository.findById(2L)).thenReturn(Optional.of(checkingAccount));
            when(accountRepository.findByAccountNumber("UA111111111111111111"))
                    .thenReturn(Optional.of(savingsAccount));
            when(paymentRepository.save(any(Payment.class))).thenAnswer(inv -> inv.getArgument(0));

            // WHEN
            Payment result = paymentService.executeTransfer(
                    2L, "UA111111111111111111", transferPayment);

            // THEN
            assertThat(result.getStatus()).isEqualTo(PaymentStatus.FAILED);
            assertThat(result.getErrorMessage()).contains("blocked");
        }
    }

    // =====================================================================
    // Тести для Account.deposit() — БАГ у entity
    // =====================================================================
    @Nested
    @DisplayName("Account entity — блокування при deposit()")
    class AccountDepositTests {

        @Test
        @DisplayName("✅ deposit() на активний рахунок — OK")
        void shouldDepositToActiveAccount() {
            // GIVEN
            savingsAccount.setBalance(BigDecimal.ZERO);

            // WHEN
            savingsAccount.deposit(new BigDecimal("500.00"));

            // THEN
            assertThat(savingsAccount.getBalance()).isEqualByComparingTo(new BigDecimal("500.00"));
        }

        @Test
        @DisplayName("🐛 deposit() на ЗАБЛОКОВАНИЙ рахунок — має кидати IllegalStateException")
        void shouldThrowWhenDepositToBlockedAccount() {
            // GIVEN
            savingsAccount.block();

            // THEN — метод deposit() правильно кидає виняток для заблокованого рахунку
            assertThatThrownBy(() -> savingsAccount.deposit(new BigDecimal("500.00")))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("заблокований");
        }

        @Test
        @DisplayName("✅ deposit() з нульовою сумою — IllegalArgumentException")
        void shouldThrowWhenDepositZeroAmount() {
            assertThatThrownBy(() -> savingsAccount.deposit(BigDecimal.ZERO))
                    .isInstanceOf(IllegalArgumentException.class);
        }

        @Test
        @DisplayName("✅ deposit() з від'ємною сумою — IllegalArgumentException")
        void shouldThrowWhenDepositNegativeAmount() {
            assertThatThrownBy(() -> savingsAccount.deposit(new BigDecimal("-100.00")))
                    .isInstanceOf(IllegalArgumentException.class);
        }
    }
}