package ua.com.kisit.course2026np.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ua.com.kisit.course2026np.entity.CreditCard;
import ua.com.kisit.course2026np.entity.User;

import java.util.List;
import java.util.Optional;

@Repository
public interface CreditCardRepository extends JpaRepository<CreditCard, Long> {

    Optional<CreditCard> findByCardNumber(String cardNumber);

    List<CreditCard> findByUser(User user);

    boolean existsByCardNumber(String cardNumber);
}