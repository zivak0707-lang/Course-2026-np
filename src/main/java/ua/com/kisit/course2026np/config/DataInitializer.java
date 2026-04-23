package ua.com.kisit.course2026np.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

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
    }

    private void createOrRehash(String email, String firstName, String lastName,
                                String rawPassword, UserRole role) {
        var existing = userRepository.findByEmail(email);
        if (existing.isPresent()) {
            User user = existing.get();
            if (!user.getPassword().startsWith("$2a$")) {
                user.setPassword(passwordEncoder.encode(rawPassword));
                userRepository.save(user);
                System.out.println("[DataInitializer] Re-hashed password for: " + email);
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
        System.out.println("[DataInitializer] Created test user: " + email + " (" + role + ")");
    }
}
