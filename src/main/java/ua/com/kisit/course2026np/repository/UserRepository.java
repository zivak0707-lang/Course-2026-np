package ua.com.kisit.course2026np.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    // --- РЕЄСТРАЦІЯ ---
    boolean existsByEmail(String email);

    List<User> findByRole(UserRole role);

    List<User> findByIsActiveTrue();

    long countByIsActiveTrue();

    // --- АДМІН SETTINGS ---
    // Прямий JPQL UPDATE — обходить Hibernate Bean Validation на всю entity.
    // Це вирішує ConstraintViolationException при save() коли інші поля
    // entity мають @Size/@NotNull constraint що не стосуються профілю.

    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.firstName = :firstName, u.lastName = :lastName, " +
            "u.email = :email, u.updatedAt = :updatedAt WHERE u.id = :id")
    int updateProfile(@Param("id")        Long id,
                      @Param("firstName") String firstName,
                      @Param("lastName")  String lastName,
                      @Param("email")     String email,
                      @Param("updatedAt") LocalDateTime updatedAt);

    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.password = :password, u.updatedAt = :updatedAt WHERE u.id = :id")
    int updatePassword(@Param("id")        Long id,
                       @Param("password")  String password,
                       @Param("updatedAt") LocalDateTime updatedAt);
}