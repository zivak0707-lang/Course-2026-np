package ua.com.kisit.course2026np.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ua.com.kisit.course2026np.entity.Payment;
import ua.com.kisit.course2026np.entity.PaymentStatus;
import ua.com.kisit.course2026np.entity.Account;

import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    List<Payment> findByAccount(Account account);

    List<Payment> findByStatus(PaymentStatus status);

    List<Payment> findByAccountOrderByCreatedAtDesc(Account account);
}
