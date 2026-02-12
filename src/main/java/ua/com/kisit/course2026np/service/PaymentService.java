package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.Payment;
import ua.com.kisit.course2026np.entity.PaymentStatus;
import ua.com.kisit.course2026np.repository.PaymentRepository;

import java.util.List;
import java.util.Optional;

/**
 * Сервіс для роботи з платежами
 * Реалізує CRUD операції та виконання транзакцій
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final AccountService accountService;

    /**
     * CREATE - Створити новий платіж
     *
     * @param payment платіж для створення
     * @return створений платіж з присвоєним ID
     */
    public Payment createPayment(Payment payment) {
        log.info("Створення нового платежу на суму: {}", payment.getAmount());

        Payment savedPayment = paymentRepository.save(payment);
        log.info("Платіж створено з ID: {}", savedPayment.getId());

        return savedPayment;
    }

    /**
     * CREATE - Виконати платіж (зняття коштів)
     *
     * @param accountId ідентифікатор рахунку
     * @param payment платіж для виконання
     * @return платіж зі статусом COMPLETED або FAILED
     */
    public Payment executePayment(Long accountId, Payment payment) {
        log.info("Виконання платежу на суму {} з рахунку {}",
                payment.getAmount(), accountId);

        // 🔥 1. ЗНАЙТИ РАХУНОК
        Account account = accountService.getAccountById(accountId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Рахунок з ID " + accountId + " не знайдено")
                );

        // 🔥 2. ПРИВ'ЯЗАТИ ПЛАТІЖ ДО РАХУНКУ
        payment.setAccount(account);

        try {
            // 3. Зняти кошти
            accountService.withdrawFromAccount(accountId, payment.getAmount());

            // 4. Завершити платіж
            payment.complete();
            log.info("Платіж успішно виконано");

        } catch (Exception e) {
            payment.fail(e.getMessage());
            log.error("Платіж не виконано: {}", e.getMessage());
        }

        return paymentRepository.save(payment);
    }


    /**
     * CREATE - Виконати поповнення
     *
     * @param accountId ідентифікатор рахунку
     * @param payment платіж-поповнення
     * @return платіж зі статусом COMPLETED або FAILED
     */
    public Payment executeReplenishment(Long accountId, Payment payment) {

        Account account = accountService.getAccountById(accountId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Рахунок з ID " + accountId + " не знайдено")
                );

        payment.setAccount(account); // 🔥 ОБОВʼЯЗКОВО

        try {
            accountService.depositToAccount(accountId, payment.getAmount());
            payment.complete();

        } catch (Exception e) {
            payment.fail(e.getMessage());
        }

        return paymentRepository.save(payment);
    }


    /**
     * READ - Отримати платіж за ID
     *
     * @param id ідентифікатор платежу
     * @return Optional з платежем або порожній
     */
    @Transactional(readOnly = true)
    public Optional<Payment> getPaymentById(Long id) {
        log.debug("Пошук платежу за ID: {}", id);
        return paymentRepository.findById(id);
    }

    /**
     * READ - Отримати всі платежі
     *
     * @return список всіх платежів
     */
    @Transactional(readOnly = true)
    public List<Payment> getAllPayments() {
        log.debug("Отримання всіх платежів");
        return paymentRepository.findAll();
    }

    /**
     * READ - Отримати платежі за рахунком
     *
     * @param account рахунок
     * @return список платежів рахунку
     */
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByAccount(Account account) {
        log.debug("Пошук платежів для рахунку: {}", account.getId());
        return paymentRepository.findByAccount(account);
    }

    /**
     * READ - Отримати платежі за рахунком (впорядковані за датою)
     *
     * @param account рахунок
     * @return список платежів рахунку, відсортованих за датою (спадання)
     */
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByAccountOrdered(Account account) {
        log.debug("Пошук платежів для рахунку {} (відсортовані)", account.getId());
        return paymentRepository.findByAccountOrderByCreatedAtDesc(account);
    }

    /**
     * 🆕 READ - Отримати останні N транзакцій для акаунту
     *
     * @param account рахунок
     * @param limit кількість транзакцій
     * @return список останніх транзакцій
     */
    @Transactional(readOnly = true)
    public List<Payment> getRecentPaymentsByAccount(Account account, int limit) {
        log.debug("Отримання останніх {} платежів для рахунку {}", limit, account.getId());
        List<Payment> allPayments = paymentRepository.findByAccountOrderByCreatedAtDesc(account);

        // Обмежуємо кількість результатів
        return allPayments.stream()
                .limit(limit)
                .toList();
    }

    /**
     * READ - Отримати платежі за статусом
     *
     * @param status статус платежу
     * @return список платежів з вказаним статусом
     */
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByStatus(PaymentStatus status) {
        log.debug("Пошук платежів за статусом: {}", status);
        return paymentRepository.findByStatus(status);
    }

    /**
     * DELETE - Видалити платіж
     *
     * @param id ідентифікатор платежу
     * @throws IllegalArgumentException якщо платіж не знайдено
     */
    public void deletePayment(Long id) {
        log.info("Видалення платежу з ID: {}", id);

        if (!paymentRepository.existsById(id)) {
            log.error("Платіж з ID {} не знайдено", id);
            throw new IllegalArgumentException(
                    "Платіж з ID " + id + " не знайдено"
            );
        }

        paymentRepository.deleteById(id);
        log.info("Платіж з ID {} видалено", id);
    }

    /**
     * Підрахунок кількості платежів
     *
     * @return загальна кількість платежів
     */
    @Transactional(readOnly = true)
    public long countPayments() {
        long count = paymentRepository.count();
        log.debug("Загальна кількість платежів: {}", count);
        return count;
    }

    /**
     * Підрахунок платежів за статусом
     *
     * @param status статус платежу
     * @return кількість платежів з вказаним статусом
     */
    @Transactional(readOnly = true)
    public long countPaymentsByStatus(PaymentStatus status) {
        long count = paymentRepository.findByStatus(status).size();
        log.debug("Кількість платежів зі статусом {}: {}", status, count);
        return count;
    }
}