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
}
