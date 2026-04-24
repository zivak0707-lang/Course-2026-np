package ua.com.kisit.course2026np.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        createOrRehash("admin@payflow.com",   "Admin",   "PayFlow", "admin123",   UserRole.ADMIN);
        createOrRehash("manager@payflow.com", "Manager", "PayFlow", "manager123", UserRole.MANAGER);
        createOrRehash("client@payflow.com",  "Client",  "PayFlow", "client123",  UserRole.CLIENT);

        rehashOnly("zivak0707@gmail.com", "19810707");
        rehashOnly("dima007@gmail.com",   "19810707");
    }

    private void createOrRehash(String email, String firstName, String lastName,
                                String rawPassword, UserRole role) {
        var existing = userRepository.findByEmail(email);
        if (existing.isPresent()) {
            User user = existing.get();
            if (!user.getPassword().startsWith("$2a$")) {
                user.setPassword(passwordEncoder.encode(rawPassword));
                userRepository.save(user);
                log.info("[INIT] Re-hashed password for: email={} role={}", email, role);
            }
            return;
        }
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setRole(role);
        user.setIsActive(true);
        userRepository.save(user);
        log.info("[INIT] Created seed user: email={} role={}", email, role);
    }

    // Перехешовує пароль тільки якщо юзер існує і пароль ще plain-text.
    // Не створює юзера, не змінює жодних інших полів.
    private void rehashOnly(String email, String rawPassword) {
        userRepository.findByEmail(email).ifPresentOrElse(user -> {
            if (user.getPassword().startsWith("$2")) {
                log.debug("[INIT] Password already BCrypt for: email={}", email);
                return;
            }
            user.setPassword(passwordEncoder.encode(rawPassword));
            userRepository.save(user);
            log.info("[INIT] BCrypt-rehashed plain-text password for: email={}", email);
        }, () -> log.warn("[INIT] rehashOnly skipped — user not found: email={}", email));
    }
}
