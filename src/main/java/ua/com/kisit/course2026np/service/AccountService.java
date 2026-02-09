package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.AccountStatus;
import ua.com.kisit.course2026np.repository.AccountRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Сервіс для роботи з рахунками
 * Реалізує CRUD операції та операції з балансом
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class AccountService {

    private final AccountRepository accountRepository;

    /**
     * CREATE - Створити новий рахунок
     *
     * @param account рахунок для створення
     * @return створений рахунок з присвоєним ID
     * @throws IllegalArgumentException якщо номер рахунку вже існує
     */
    public Account createAccount(Account account) {
        log.info("Створення нового рахунку з номером: {}", account.getAccountNumber());

        // Перевірка унікальності номера рахунку
        if (accountRepository.findByAccountNumber(account.getAccountNumber()).isPresent()) {
            log.error("Рахунок з номером {} вже існує", account.getAccountNumber());
            throw new IllegalArgumentException(
                    "Рахунок з номером " + account.getAccountNumber() + " вже існує"
            );
        }

        Account savedAccount = accountRepository.save(account);
        log.info("Рахунок створено з ID: {}", savedAccount.getId());

        return savedAccount;
    }

    /**
     * READ - Отримати рахунок за ID
     *
     * @param id ідентифікатор рахунку
     * @return Optional з рахунком або порожній
     */
    @Transactional(readOnly = true)
    public Optional<Account> getAccountById(Long id) {
        log.debug("Пошук рахунку за ID: {}", id);
        return accountRepository.findById(id);
    }

    /**
     * READ - Отримати рахунок за номером
     *
     * @param accountNumber номер рахунку
     * @return Optional з рахунком або порожній
     */
    @Transactional(readOnly = true)
    public Optional<Account> getAccountByNumber(String accountNumber) {
        log.debug("Пошук рахунку за номером: {}", accountNumber);
        return accountRepository.findByAccountNumber(accountNumber);
    }

    /**
     * READ - Отримати рахунок за ID картки
     *
     * @param cardId ідентифікатор кредитної карти
     * @return Optional з рахунком або порожній
     */
    @Transactional(readOnly = true)
    public Optional<Account> getAccountByCardId(Long cardId) {
        log.debug("Пошук рахунку за ID картки: {}", cardId);
        return accountRepository.findByCreditCardId(cardId);
    }

    /**
     * READ - Отримати всі рахунки
     *
     * @return список всіх рахунків
     */
    @Transactional(readOnly = true)
    public List<Account> getAllAccounts() {
        log.debug("Отримання всіх рахунків");
        return accountRepository.findAll();
    }

    /**
     * READ - Отримати рахунки за статусом
     *
     * @param status статус рахунку
     * @return список рахунків з вказаним статусом
     */
    @Transactional(readOnly = true)
    public List<Account> getAccountsByStatus(AccountStatus status) {
        log.debug("Пошук рахунків за статусом: {}", status);
        return accountRepository.findByStatus(status);
    }

    /**
     * UPDATE - Поповнити рахунок
     *
     * @param id ідентифікатор рахунку
     * @param amount сума поповнення
     * @return оновлений рахунок
     * @throws IllegalArgumentException якщо рахунок не знайдено
     * @throws IllegalStateException якщо рахунок заблокований
     */
    public Account depositToAccount(Long id, BigDecimal amount) {
        log.info("Поповнення рахунку {} на суму: {}", id, amount);

        Account account = accountRepository.findById(id)
                .orElseThrow(() -> {
                    log.error("Рахунок з ID {} не знайдено", id);
                    return new IllegalArgumentException(
                            "Рахунок з ID " + id + " не знайдено"
                    );
                });

        account.deposit(amount);
        Account savedAccount = accountRepository.save(account);

        log.info("Рахунок {} поповнено. Новий баланс: {}",
                id, savedAccount.getBalance());

        return savedAccount;
    }

    /**
     * UPDATE - Зняти кошти з рахунку
     *
     * @param id ідентифікатор рахунку
     * @param amount сума зняття
     * @return оновлений рахунок
     * @throws IllegalArgumentException якщо рахунок не знайдено
     * @throws IllegalStateException якщо рахунок заблокований або недостатньо коштів
     */
    public Account withdrawFromAccount(Long id, BigDecimal amount) {
        log.info("Зняття з рахунку {} суми: {}", id, amount);

        Account account = accountRepository.findById(id)
                .orElseThrow(() -> {
                    log.error("Рахунок з ID {} не знайдено", id);
                    return new IllegalArgumentException(
                            "Рахунок з ID " + id + " не знайдено"
                    );
                });

        account.withdraw(amount);
        Account savedAccount = accountRepository.save(account);

        log.info("З рахунку {} знято кошти. Новий баланс: {}",
                id, savedAccount.getBalance());

        return savedAccount;
    }

    /**
     * UPDATE - Заблокувати рахунок
     *
     * @param id ідентифікатор рахунку
     * @throws IllegalArgumentException якщо рахунок не знайдено
     */
    public void blockAccount(Long id) {
        log.info("Блокування рахунку з ID: {}", id);

        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        account.block();
        accountRepository.save(account);

        log.info("Рахунок {} заблоковано", id);
    }

    /**
     * UPDATE - Розблокувати рахунок
     *
     * @param id ідентифікатор рахунку
     * @throws IllegalArgumentException якщо рахунок не знайдено
     */
    public void unblockAccount(Long id) {
        log.info("Розблокування рахунку з ID: {}", id);

        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        account.unblock();
        accountRepository.save(account);

        log.info("Рахунок {} розблоковано", id);
    }

    /**
     * DELETE - Видалити рахунок
     *
     * @param id ідентифікатор рахунку
     * @throws IllegalArgumentException якщо рахунок не знайдено
     */
    public void deleteAccount(Long id) {
        log.info("Видалення рахунку з ID: {}", id);

        if (!accountRepository.existsById(id)) {
            log.error("Рахунок з ID {} не знайдено", id);
            throw new IllegalArgumentException(
                    "Рахунок з ID " + id + " не знайдено"
            );
        }

        accountRepository.deleteById(id);
        log.info("Рахунок з ID {} видалено", id);
    }

    /**
     * Отримати баланс рахунку
     *
     * @param id ідентифікатор рахунку
     * @return баланс рахунку
     */
    @Transactional(readOnly = true)
    public BigDecimal getBalance(Long id) {
        log.debug("Отримання балансу рахунку: {}", id);

        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        return account.getBalance();
    }
}