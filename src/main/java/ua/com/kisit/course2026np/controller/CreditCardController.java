package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ua.com.kisit.course2026np.dto.ChangePinRequest;
import ua.com.kisit.course2026np.dto.SpendingLimitRequest;
import ua.com.kisit.course2026np.service.CreditCardService;

import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/cards")
@RequiredArgsConstructor
public class CreditCardController {

    private final CreditCardService creditCardService;

    // ── BLOCK / UNBLOCK ────────────────────────────────────────

    @PostMapping("/{id}/toggle-block")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleBlock(
            @PathVariable Long id,
            HttpSession session) {

        if (session.getAttribute("userId") == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false, "message", "Not authenticated"));
        }
        try {
            boolean isActive = creditCardService.toggleBlockCard(id);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "isActive", isActive,
                    "message", isActive ? "Card unblocked successfully" : "Card blocked successfully"
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // ── CHANGE PIN ─────────────────────────────────────────────

    @PostMapping("/{id}/change-pin")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> changePin(
            @PathVariable Long id,
            @RequestBody @Valid ChangePinRequest request,
            HttpSession session) {

        if (session.getAttribute("userId") == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false, "message", "Not authenticated"));
        }
        try {
            // Перевіряємо чи картка вже має PIN
            boolean hasPin = creditCardService.getCreditCardById(id)
                    .map(c -> c.getPinCode() != null)
                    .orElse(false);

            if (hasPin) {
                if (request.getCurrentPin() == null || request.getCurrentPin().isBlank()) {
                    return ResponseEntity.badRequest().body(Map.of(
                            "success", false, "message", "Current PIN is required"));
                }
                if (!creditCardService.verifyPin(id, request.getCurrentPin())) {
                    return ResponseEntity.badRequest().body(Map.of(
                            "success", false, "message", "Current PIN is incorrect"));
                }
            }

            creditCardService.changePin(id, request);
            return ResponseEntity.ok(Map.of("success", true, "message", "PIN changed successfully"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // ── SPENDING LIMIT ─────────────────────────────────────────

    @PostMapping("/{id}/spending-limit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> setSpendingLimit(
            @PathVariable Long id,
            @RequestBody @Valid SpendingLimitRequest request,
            HttpSession session) {

        if (session.getAttribute("userId") == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false, "message", "Not authenticated"));
        }
        try {
            creditCardService.setSpendingLimit(id, request);
            return ResponseEntity.ok(Map.of("success", true, "message", "Spending limit updated"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
}