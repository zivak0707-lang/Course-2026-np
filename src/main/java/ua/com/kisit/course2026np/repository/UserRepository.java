package ua.com.kisit.course2026np.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository; // Додав анотацію
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    // --- ДОДАНО ДЛЯ РЕЄСТРАЦІЇ ---
    boolean existsByEmail(String email);
    // -----------------------------

    List<User> findByRole(UserRole role);

    List<User> findByIsActiveTrue();

    long countByIsActiveTrue();
}