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

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class AccountService {

    private final AccountRepository accountRepository;

    public Account createAccount(Account account) {
        log.info("Створення нового рахунку з номером: {}", account.getAccountNumber());

        // Перевірка унікальності номера рахунку
        if (accountRepository.findByAccountNumber(account.getAccountNumber()).isPresent()) {
            log.error("Рахунок з номером {} вже існує", account.getAccountNumber());
            throw new IllegalArgumentException(
                    "Рахунок з номером " + account.getAccountNumber() + " вже існує"
            );
        }

        // 🔴 НОВА ПЕРЕВІРКА: одна картка = один рахунок
        if (account.getCreditCard() != null &&
                accountRepository.findByCreditCard(account.getCreditCard()).isPresent()) {

            log.error("Для цієї картки вже існує рахунок");
            throw new IllegalStateException(
                    "Для цієї картки вже створено рахунок"
            );
        }

        Account savedAccount = accountRepository.save(account);
        log.info("Рахунок створено з ID: {}", savedAccount.getId());

        return savedAccount;
    }

    @Transactional(readOnly = true)
    public Optional<Account> getAccountById(Long id) {
        log.debug("Пошук рахунку за ID: {}", id);
        return accountRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<Account> getAccountByNumber(String accountNumber) {
        log.debug("Пошук рахунку за номером: {}", accountNumber);
        return accountRepository.findByAccountNumber(accountNumber);
    }

    @Transactional(readOnly = true)
    public Optional<Account> getAccountByCardId(Long cardId) {
        log.debug("Пошук рахунку за ID картки: {}", cardId);
        return accountRepository.findByCreditCardId(cardId);
    }

    @Transactional(readOnly = true)
    public List<Account> getAllAccounts() {
        log.debug("Отримання всіх рахунків");
        return accountRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Account> getAccountsByStatus(AccountStatus status) {
        log.debug("Пошук рахунків за статусом: {}", status);
        return accountRepository.findByStatus(status);
    }

    public Account depositToAccount(Long id, BigDecimal amount) {
        log.info("Поповнення рахунку {} на суму: {}", id, amount);

        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        account.deposit(amount);
        Account savedAccount = accountRepository.save(account);

        log.info("Рахунок {} поповнено. Новий баланс: {}",
                id, savedAccount.getBalance());

        return savedAccount;
    }

    public Account withdrawFromAccount(Long id, BigDecimal amount) {
        log.info("Зняття з рахунку {} суми: {}", id, amount);

        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        account.withdraw(amount);
        Account savedAccount = accountRepository.save(account);

        log.info("З рахунку {} знято кошти. Новий баланс: {}",
                id, savedAccount.getBalance());

        return savedAccount;
    }

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

    public void deleteAccount(Long id) {
        log.info("Видалення рахунку з ID: {}", id);

        if (!accountRepository.existsById(id)) {
            throw new IllegalArgumentException(
                    "Рахунок з ID " + id + " не знайдено"
            );
        }

        accountRepository.deleteById(id);
        log.info("Рахунок з ID {} видалено", id);
    }

    @Transactional(readOnly = true)
    public BigDecimal getBalance(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        return account.getBalance();
    }

    // ============= 🆕 ДОДАТКОВІ МЕТОДИ =============

    /**
     * 🆕 Підрахунок загальної кількості рахунків
     *
     * @return загальна кількість рахунків
     */
    @Transactional(readOnly = true)
    public long countAccounts() {
        long count = accountRepository.count();
        log.debug("Загальна кількість рахунків: {}", count);
        return count;
    }

    /**
     * 🆕 Підрахунок активних рахунків
     *
     * @return кількість активних рахунків
     */
    @Transactional(readOnly = true)
    public long countActiveAccounts() {
        long count = accountRepository.findByStatus(AccountStatus.ACTIVE).size();
        log.debug("Кількість активних рахунків: {}", count);
        return count;
    }

    /**
     * 🆕 Підрахунок заблокованих рахунків
     *
     * @return кількість заблокованих рахунків
     */
    @Transactional(readOnly = true)
    public long countBlockedAccounts() {
        long count = accountRepository.findByStatus(AccountStatus.BLOCKED).size();
        log.debug("Кількість заблокованих рахунків: {}", count);
        return count;
    }

    /**
     * 🆕 Отримати активні рахунки
     *
     * @return список активних рахунків
     */
    @Transactional(readOnly = true)
    public List<Account> getActiveAccounts() {
        log.debug("Отримання активних рахунків");
        return accountRepository.findByStatus(AccountStatus.ACTIVE);
    }

    /**
     * 🆕 Отримати заблоковані рахунки
     *
     * @return список заблокованих рахунків
     */
    @Transactional(readOnly = true)
    public List<Account> getBlockedAccounts() {
        log.debug("Отримання заблокованих рахунків");
        return accountRepository.findByStatus(AccountStatus.BLOCKED);
    }

    /**
     * 🆕 Перевірити чи існує рахунок з номером
     *
     * @param accountNumber номер рахунку
     * @return true якщо існує, false якщо ні
     */
    @Transactional(readOnly = true)
    public boolean existsByAccountNumber(String accountNumber) {
        boolean exists = accountRepository.findByAccountNumber(accountNumber).isPresent();
        log.debug("Рахунок з номером {} {}", accountNumber, exists ? "існує" : "не існує");
        return exists;
    }

    /**
     * 🆕 Отримати загальний баланс всіх рахунків
     *
     * @return сума балансів всіх рахунків
     */
    @Transactional(readOnly = true)
    public BigDecimal getTotalBalance() {
        BigDecimal total = accountRepository.findAll().stream()
                .map(Account::getBalance)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        log.debug("Загальний баланс всіх рахунків: {}", total);
        return total;
    }

    /**
     * 🆕 Отримати максимальний баланс серед усіх рахунків
     *
     * @return максимальний баланс або 0 якщо рахунків немає
     */
    @Transactional(readOnly = true)
    public BigDecimal getMaxBalance() {
        return accountRepository.findAll().stream()
                .map(Account::getBalance)
                .max(BigDecimal::compareTo)
                .orElse(BigDecimal.ZERO);
    }

    /**
     * 🆕 Перевірити чи активний рахунок
     *
     * @param id ідентифікатор рахунку
     * @return true якщо активний, false якщо заблокований
     */
    @Transactional(readOnly = true)
    public boolean isAccountActive(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        return account.getStatus() == AccountStatus.ACTIVE;
    }

    /**
     * 🆕 Перевірити чи заблокований рахунок
     *
     * @param id ідентифікатор рахунку
     * @return true якщо заблокований, false якщо активний
     */
    @Transactional(readOnly = true)
    public boolean isAccountBlocked(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Рахунок з ID " + id + " не знайдено"
                ));

        return account.getStatus() == AccountStatus.BLOCKED;
    }
}