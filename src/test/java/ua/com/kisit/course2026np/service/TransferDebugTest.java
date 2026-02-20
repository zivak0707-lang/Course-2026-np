package ua.com.kisit.course2026np.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import ua.com.kisit.course2026np.entity.*;
import ua.com.kisit.course2026np.repository.AccountRepository;
import ua.com.kisit.course2026np.repository.CreditCardRepository;
import ua.com.kisit.course2026np.repository.PaymentRepository;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TransferDebugTest {

    @Mock private PaymentRepository paymentRepository;
    @Mock private AccountRepository accountRepository;
    @Mock private CreditCardRepository creditCardRepository;

    @InjectMocks
    private PaymentService paymentService;

    private Account sender;
    private Account recipient;
    private CreditCard recipientCard;

    @BeforeEach
    void setUp() {
        CreditCard senderCard = new CreditCard();
        senderCard.setId(1L);
        senderCard.setCardNumber("1111222233334444");

        recipientCard = new CreditCard();
        recipientCard.setId(2L);
        recipientCard.setCardNumber("5555666677778888");

        sender = new Account();
        sender.setId(1L);
        sender.setAccountNumber("ACC-SENDER-001");
        sender.setBalance(new BigDecimal("1000.00"));
        sender.setStatus(AccountStatus.ACTIVE);
        sender.setCreditCard(senderCard);

        recipient = new Account();
        recipient.setId(2L);
        recipient.setAccountNumber("ACC-RECIPIENT-001");
        recipient.setBalance(new BigDecimal("500.00"));
        recipient.setStatus(AccountStatus.ACTIVE);
        recipient.setCreditCard(recipientCard);

        when(paymentRepository.save(any(Payment.class))).thenAnswer(i -> i.getArgument(0));
        // lenient — деякі тести (з FAILED) не доходять до accountRepository.save
        lenient().when(accountRepository.save(any(Account.class))).thenAnswer(i -> i.getArgument(0));
    }

    @Test
    void transfer_byAccountNumber_shouldDebitSenderAndCreditRecipient() {
        when(accountRepository.findById(1L)).thenReturn(Optional.of(sender));
        when(accountRepository.findByAccountNumber("ACC-RECIPIENT-001")).thenReturn(Optional.of(recipient));

        Payment payment = Payment.builder()
                .amount(new BigDecimal("200.00"))
                .type(PaymentType.TRANSFER)
                .description("Test")
                .build();

        Payment result = paymentService.executeTransfer(1L, "ACC-RECIPIENT-001", payment);

        System.out.println("=== ТЕСТ 1: За номером рахунку ===");
        System.out.println("Статус: " + result.getStatus() + " | Помилка: " + result.getErrorMessage());
        System.out.println("Відправник: " + sender.getBalance() + " | Отримувач: " + recipient.getBalance());

        assertEquals(PaymentStatus.COMPLETED, result.getStatus());
        assertEquals(new BigDecimal("800.00"), sender.getBalance());
        assertEquals(new BigDecimal("700.00"), recipient.getBalance());
    }

    @Test
    void transfer_byCardNumber_shouldDebitSenderAndCreditRecipient() {
        when(accountRepository.findById(1L)).thenReturn(Optional.of(sender));
        when(accountRepository.findByAccountNumber("5555666677778888")).thenReturn(Optional.empty());
        when(creditCardRepository.findByCardNumber("5555666677778888")).thenReturn(Optional.of(recipientCard));
        when(accountRepository.findByCreditCard(recipientCard)).thenReturn(Optional.of(recipient));

        Payment payment = Payment.builder()
                .amount(new BigDecimal("200.00"))
                .type(PaymentType.TRANSFER)
                .build();

        Payment result = paymentService.executeTransfer(1L, "5555666677778888", payment);

        System.out.println("=== ТЕСТ 2: За номером картки ===");
        System.out.println("Статус: " + result.getStatus() + " | Помилка: " + result.getErrorMessage());
        System.out.println("Відправник: " + sender.getBalance() + " | Отримувач: " + recipient.getBalance());

        assertEquals(PaymentStatus.COMPLETED, result.getStatus());
        assertEquals(new BigDecimal("800.00"), sender.getBalance());
        assertEquals(new BigDecimal("700.00"), recipient.getBalance());
    }

    @Test
    void transfer_recipientNotFound_shouldFail() {
        when(accountRepository.findById(1L)).thenReturn(Optional.of(sender));
        when(accountRepository.findByAccountNumber("NONEXISTENT")).thenReturn(Optional.empty());
        when(creditCardRepository.findByCardNumber("NONEXISTENT")).thenReturn(Optional.empty());

        Payment payment = Payment.builder().amount(new BigDecimal("200.00")).type(PaymentType.TRANSFER).build();

        Payment result = paymentService.executeTransfer(1L, "NONEXISTENT", payment);

        System.out.println("=== ТЕСТ 3: Отримувач не знайдений ===");
        System.out.println("Статус: " + result.getStatus() + " | Помилка: " + result.getErrorMessage());

        assertEquals(PaymentStatus.FAILED, result.getStatus());
        assertEquals(new BigDecimal("1000.00"), sender.getBalance());
    }

    @Test
    void transfer_toSameAccount_shouldFail() {
        when(accountRepository.findById(1L)).thenReturn(Optional.of(sender));
        when(accountRepository.findByAccountNumber("ACC-SENDER-001")).thenReturn(Optional.of(sender));

        Payment payment = Payment.builder().amount(new BigDecimal("200.00")).type(PaymentType.TRANSFER).build();

        Payment result = paymentService.executeTransfer(1L, "ACC-SENDER-001", payment);

        System.out.println("=== ТЕСТ 4: Переказ самому собі ===");
        System.out.println("Статус: " + result.getStatus() + " | Помилка: " + result.getErrorMessage());

        assertEquals(PaymentStatus.FAILED, result.getStatus());
    }

    @Test
    void transfer_insufficientFunds_shouldFail() {
        when(accountRepository.findById(1L)).thenReturn(Optional.of(sender));
        when(accountRepository.findByAccountNumber("ACC-RECIPIENT-001")).thenReturn(Optional.of(recipient));

        Payment payment = Payment.builder().amount(new BigDecimal("9999.00")).type(PaymentType.TRANSFER).build();

        Payment result = paymentService.executeTransfer(1L, "ACC-RECIPIENT-001", payment);

        System.out.println("=== ТЕСТ 5: Недостатньо коштів ===");
        System.out.println("Статус: " + result.getStatus() + " | Помилка: " + result.getErrorMessage());

        assertEquals(PaymentStatus.FAILED, result.getStatus());
        assertEquals(new BigDecimal("1000.00"), sender.getBalance());
        assertEquals(new BigDecimal("500.00"), recipient.getBalance());
    }
}