package ua.com.kisit.course2026np.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ua.com.kisit.course2026np.entity.Account;
import ua.com.kisit.course2026np.entity.AccountStatus;
import ua.com.kisit.course2026np.repository.AccountRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/dashboard/accounts")
@RequiredArgsConstructor
public class DashboardAccountController {

    private final AccountRepository accountRepository;

    @GetMapping("/add")
    public String addAccountPage(Model model) {
        return "client/accounts-add";
    }

    @PostMapping("/add")
    public String addAccount(@RequestParam String accountType) {
        Account account = new Account();
        account.setAccountNumber(generateAccountNumber());
        account.setBalance(BigDecimal.ZERO);
        account.setStatus(AccountStatus.ACTIVE);
        account.setCreatedAt(LocalDateTime.now());
        account.setUpdatedAt(LocalDateTime.now());

        accountRepository.save(account);

        return "redirect:/dashboard/accounts?success=added";
    }

    private String generateAccountNumber() {
        return "4521" + System.currentTimeMillis();
    }
}