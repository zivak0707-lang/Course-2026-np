package ua.com.kisit.course2026np.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;

    @Override
    public void run(String... args) {
        createIfMissing("admin@payflow.com",   "Admin",   "PayFlow", "admin123",   UserRole.ADMIN);
        createIfMissing("manager@payflow.com", "Manager", "PayFlow", "manager123", UserRole.MANAGER);
        createIfMissing("client@payflow.com",  "Client",  "PayFlow", "client123",  UserRole.CLIENT);
    }

    private void createIfMissing(String email, String firstName, String lastName,
                                 String password, UserRole role) {
        if (userRepository.findByEmail(email).isPresent()) return;
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);
        user.setIsActive(true);
        userRepository.save(user);
        System.out.println("[DataInitializer] Created test user: " + email + " / " + password + " (" + role + ")");
    }
}
