package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.entity.UserRole;
import ua.com.kisit.course2026np.repository.UserRepository;

import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final UserRepository userRepository;

    @GetMapping("/")
    public String index() { return "index"; }

    @GetMapping("/login")
    public String login(@RequestParam(required = false) String registered, Model model) {
        if (registered != null) model.addAttribute("success", "Реєстрація успішна!");
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email, @RequestParam String password,
                              HttpSession session, Model model) {
        Optional<User> userOpt = userRepository.findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email.trim()))
                .findFirst();
        if (userOpt.isEmpty()) {
            model.addAttribute("error", "Невірний email або пароль");
            return "login";
        }
        User user = userOpt.get();
        if (!user.getPassword().equals(password.trim())) {
            model.addAttribute("error", "Невірний email або пароль");
            return "login";
        }
        // Перевіряємо блокування при вході
        if (!Boolean.TRUE.equals(user.getIsActive())) {
            return "redirect:/blocked";
        }
        session.setAttribute("userId", user.getId());
        session.setAttribute("userRole", user.getRole());
        if (user.getRole() == UserRole.ADMIN) return "redirect:/admin";
        return "redirect:/dashboard";
    }

    @GetMapping("/register")
    public String register() { return "register"; }

    @PostMapping("/register")
    public String handleRegister(@RequestParam String firstName, @RequestParam String lastName,
                                 @RequestParam String email, @RequestParam String password, Model model) {
        boolean emailExists = userRepository.findAll().stream()
                .anyMatch(u -> u.getEmail().equalsIgnoreCase(email.trim()));
        if (emailExists) {
            model.addAttribute("error", "Користувач з таким email вже існує");
            return "register";
        }
        User newUser = new User();
        newUser.setFirstName(firstName.trim());
        newUser.setLastName(lastName.trim());
        newUser.setEmail(email.trim());
        newUser.setPassword(password);
        newUser.setRole(UserRole.CLIENT);
        newUser.setIsActive(true);
        userRepository.save(newUser);
        return "redirect:/login?registered=true";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // Сторінка блокування
    @GetMapping("/blocked")
    public String blocked() { return "blocked"; }
}