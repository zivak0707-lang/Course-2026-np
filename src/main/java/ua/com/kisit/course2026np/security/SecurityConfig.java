package ua.com.kisit.course2026np.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Мінімальна конфігурація Spring Security.
 *
 * Зараз Security повністю відкритий — всі маршрути дозволені.
 * Авторизація працює через HttpSession (HomeController).
 * BCryptPasswordEncoder доступний як бін для хешування PIN-кодів карток.
 *
 * Коли будеш готовий підключити повноцінний Security —
 * замінити цей файл на SecurityConfig з UserDetailsService.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /**
     * PasswordEncoder бін — використовується в CreditCardService
     * для хешування PIN-коду карток.
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10);
    }

    /**
     * Відкриваємо всі маршрути — Security не блокує нічого.
     * Авторизація контролюється вручну через HttpSession.
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Вимикаємо CSRF — форми працюють без токенів
                .csrf(AbstractHttpConfigurer::disable)

                // Дозволяємо всі запити без перевірки
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll()
                )

                // Вимикаємо дефолтну форму логіну Spring Security
                .formLogin(AbstractHttpConfigurer::disable)

                // Вимикаємо HTTP Basic автентифікацію
                .httpBasic(AbstractHttpConfigurer::disable);

        return http.build();
    }
}