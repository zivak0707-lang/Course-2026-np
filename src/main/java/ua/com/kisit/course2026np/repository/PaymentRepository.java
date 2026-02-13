package ua.com.kisit.course2026np.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ua.com.kisit.course2026np.entity.Payment;
import ua.com.kisit.course2026np.entity.PaymentStatus;
import ua.com.kisit.course2026np.entity.PaymentType;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.User;

import java.util.List;

/**
 * Repository for Payment entity operations
 * Includes pagination and filtering support
 *
 * ВАЖЛИВО: У вашій структурі User → CreditCard → Account → Payment
 * Тому в queries використовується p.account.creditCard.user
 */
@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    // ============= ORIGINAL METHODS (НЕ ЧІПАЄМО) =============

    List<Payment> findByAccount(Account account);

    List<Payment> findByStatus(PaymentStatus status);

    List<Payment> findByAccountOrderByCreatedAtDesc(Account account);

    // ============= NEW METHODS FOR TRANSACTIONS PAGE =============

    /**
     * Find all payments by user with pagination
     * Використовує ланцюжок: Payment → Account → CreditCard → User
     */
    @Query("SELECT p FROM Payment p " +
            "WHERE p.account.creditCard.user = :user " +
            "ORDER BY p.createdAt DESC")
    Page<Payment> findByUser(@Param("user") User user, Pageable pageable);

    /**
     * Find payments by user with search filter (description contains)
     */
    @Query("SELECT p FROM Payment p " +
            "WHERE p.account.creditCard.user = :user " +
            "AND LOWER(p.description) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "ORDER BY p.createdAt DESC")
    Page<Payment> findByUserAndDescriptionContaining(
            @Param("user") User user,
            @Param("search") String search,
            Pageable pageable
    );

    /**
     * Find payments by user and type
     */
    @Query("SELECT p FROM Payment p " +
            "WHERE p.account.creditCard.user = :user " +
            "AND p.type = :type " +
            "ORDER BY p.createdAt DESC")
    Page<Payment> findByUserAndType(
            @Param("user") User user,
            @Param("type") PaymentType type,
            Pageable pageable
    );

    /**
     * Find payments by user and status
     */
    @Query("SELECT p FROM Payment p " +
            "WHERE p.account.creditCard.user = :user " +
            "AND p.status = :status " +
            "ORDER BY p.createdAt DESC")
    Page<Payment> findByUserAndStatus(
            @Param("user") User user,
            @Param("status") PaymentStatus status,
            Pageable pageable
    );

    /**
     * Find payments by user with all filters applied
     * Підтримує комбінацію: search + type + status
     */
    @Query("SELECT p FROM Payment p " +
            "WHERE p.account.creditCard.user = :user " +
            "AND (:search IS NULL OR :search = '' OR LOWER(p.description) LIKE LOWER(CONCAT('%', :search, '%'))) " +
            "AND (:type IS NULL OR p.type = :type) " +
            "AND (:status IS NULL OR p.status = :status) " +
            "ORDER BY p.createdAt DESC")
    Page<Payment> findByUserWithFilters(
            @Param("user") User user,
            @Param("search") String search,
            @Param("type") PaymentType type,
            @Param("status") PaymentStatus status,
            Pageable pageable
    );

    /**
     * Count payments by user
     */
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.account.creditCard.user = :user")
    long countByUser(@Param("user") User user);

    /**
     * Count payments by user and status
     */
    @Query("SELECT COUNT(p) FROM Payment p " +
            "WHERE p.account.creditCard.user = :user " +
            "AND p.status = :status")
    long countByUserAndStatus(@Param("user") User user, @Param("status") PaymentStatus status);
}