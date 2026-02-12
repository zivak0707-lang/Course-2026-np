package ua.com.kisit.course2026np.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.AccountStatus;
import ua.com.kisit.course2026np.entity.CreditCard;

import java.util.List;
import java.util.Optional;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {

    Optional<Account> findByAccountNumber(String accountNumber);

    List<Account> findByStatus(AccountStatus status);

    // 🔹 ДОДАНО — для перевірки "одна картка = один акаунт"
    Optional<Account> findByCreditCard(CreditCard creditCard);

    // 🔹 ДОДАНО — використовується в Service
    Optional<Account> findByCreditCardId(Long creditCardId);
}
