package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;
import ua.com.kisit.course2026np.service.LoginAttemptService;

import java.util.Optional;

@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {

    private static final Logger securityLog = LoggerFactory.getLogger("SECURITY");

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final LoginAttemptService loginAttemptService;

    @GetMapping("/")
    public String index() { return "index"; }

    @GetMapping("/login")
    public String login(@RequestParam(required = false) String registered, Model model) {
        if (registered != null) model.addAttribute("success", "Реєстрація успішна!");
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email, @RequestParam String password,
                              HttpSession session, Model model, HttpServletRequest request) {
        String normalizedEmail = email.trim();
        String clientIp = getClientIp(request);

        if (loginAttemptService.isBlocked(normalizedEmail)) {
            long minutes = loginAttemptService.getMinutesLeft(normalizedEmail);
            securityLog.warn("[BRUTE_FORCE_BLOCK] Login blocked: email={} ip={} minutesLeft={}",
                    normalizedEmail, clientIp, minutes);
            model.addAttribute("error",
                    "Забагато невдалих спроб. Спробуйте через " + minutes + " хв.");
            return "login";
        }

        Optional<User> userOpt = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(normalizedEmail))
                .findFirst();

        if (userOpt.isEmpty()) {
            loginAttemptService.recordFailure(normalizedEmail);
            securityLog.warn("[LOGIN_FAIL] User not found: email={} ip={}", normalizedEmail, clientIp);
            model.addAttribute("error", "Невірний email або пароль");
            return "login";
        }

        User user = userOpt.get();

        if (!passwordEncoder.matches(password.trim(), user.getPassword())) {
            loginAttemptService.recordFailure(normalizedEmail);
            securityLog.warn("[LOGIN_FAIL] Wrong password: email={} id={} ip={}", normalizedEmail, user.getId(), clientIp);
            model.addAttribute("error", "Невірний email або пароль");
            return "login";
        }

        if (!Boolean.TRUE.equals(user.getIsActive())) {
            securityLog.warn("[LOGIN_BLOCKED_USER] Blocked user attempted login: email={} id={} ip={}",
                    user.getEmail(), user.getId(), clientIp);
            return "redirect:/blocked";
        }

        loginAttemptService.recordSuccess(normalizedEmail);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userRole", user.getRole());
        securityLog.info("[LOGIN_OK] Successful login: email={} role={} id={} ip={}",
                user.getEmail(), user.getRole(), user.getId(), clientIp);

        if (user.getRole() == UserRole.ADMIN) {
            session.setAttribute("adminUser", user);
            return "redirect:/admin";
        }
        if (user.getRole() == UserRole.MANAGER) {
            session.setAttribute("managerUser", user);
            return "redirect:/manager";
        }
        return "redirect:/dashboard";
    }

    @GetMapping("/register")
    public String register() { return "register"; }

    @PostMapping("/register")
    public String handleRegister(@RequestParam String firstName, @RequestParam String lastName,
                                 @RequestParam String email, @RequestParam String password, Model model) {
        String normalizedEmail = email.trim();
        boolean emailExists = userRepository.findAll().stream()
                .anyMatch(u -> u.getEmail().equalsIgnoreCase(normalizedEmail));
        if (emailExists) {
            log.warn("[REGISTER_FAIL] Registration attempted with existing email: {}", normalizedEmail);
            model.addAttribute("error", "Користувач з таким email вже існує");
            return "register";
        }
        User newUser = new User();
        newUser.setFirstName(firstName.trim());
        newUser.setLastName(lastName.trim());
        newUser.setEmail(normalizedEmail);
        newUser.setPassword(passwordEncoder.encode(password));
        newUser.setRole(UserRole.CLIENT);
        newUser.setIsActive(true);
        userRepository.save(newUser);
        log.info("[REGISTER_OK] New user registered: email={}", normalizedEmail);
        return "redirect:/login?registered=true";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        UserRole role = (UserRole) session.getAttribute("userRole");
        securityLog.info("[LOGOUT] User logged out: userId={} role={}", userId, role);
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/blocked")
    public String blocked() { return "blocked"; }

    private String getClientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        return (xff != null && !xff.isBlank()) ? xff.split(",")[0].trim() : request.getRemoteAddr();
    }
}
