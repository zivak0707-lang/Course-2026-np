package ua.com.kisit.course2026np.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Контролер для публічних сторінок (Landing, Login, Register)
 */
@Controller
public class HomeController {

    /**
     * Головна сторінка (Landing Page)
     */
    @GetMapping("/")
    public String index() {
        return "index";
    }

    /**
     * Сторінка входу
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /**
     * Сторінка реєстрації
     */
    @GetMapping("/register")
    public String register() {
        return "register";
    }
}
