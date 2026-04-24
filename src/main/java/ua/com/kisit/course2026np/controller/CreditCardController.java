package ua.com.kisit.course2026np.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    private static final Logger securityLog = LoggerFactory.getLogger("SECURITY");

    private final CreditCardService creditCardService;

    // ── BLOCK / UNBLOCK ────────────────────────────────────────

    @PostMapping("/{id}/toggle-block")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleBlock(
            @PathVariable Long id,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            securityLog.warn("[UNAUTHENTICATED_ACCESS] Unauthenticated toggle-block attempt for card id={}", id);
            return ResponseEntity.status(401).body(Map.of(
                    "success", false, "message", "Not authenticated"));
        }
        if (!creditCardService.isOwnedByUser(id, userId)) {
            securityLog.warn("[ACCESS_DENIED_403] User id={} attempted to toggle-block card id={} that does not belong to them",
                    userId, id);
            return ResponseEntity.status(403).body(Map.of(
                    "success", false, "message", "Forbidden"));
        }
        try {
            boolean isActive = creditCardService.toggleBlockCard(id);
            log.info("[CARD_TOGGLE_BLOCK] Card id={} by user id={} → isActive={}", id, userId, isActive);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "isActive", isActive,
                    "message", isActive ? "Card unblocked successfully" : "Card blocked successfully"
            ));
        } catch (IllegalArgumentException e) {
            log.warn("[CARD_TOGGLE_BLOCK_FAIL] Card id={} by user id={}: {}", id, userId, e.getMessage());
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

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            securityLog.warn("[UNAUTHENTICATED_ACCESS] Unauthenticated change-pin attempt for card id={}", id);
            return ResponseEntity.status(401).body(Map.of(
                    "success", false, "message", "Not authenticated"));
        }
        if (!creditCardService.isOwnedByUser(id, userId)) {
            securityLog.warn("[ACCESS_DENIED_403] User id={} attempted to change PIN for card id={} that does not belong to them",
                    userId, id);
            return ResponseEntity.status(403).body(Map.of(
                    "success", false, "message", "Forbidden"));
        }
        try {
            boolean hasPin = creditCardService.getCreditCardById(id)
                    .map(c -> c.getPinCode() != null)
                    .orElse(false);

            if (hasPin) {
                if (request.getCurrentPin() == null || request.getCurrentPin().isBlank()) {
                    return ResponseEntity.badRequest().body(Map.of(
                            "success", false, "message", "Current PIN is required"));
                }
                if (!creditCardService.verifyPin(id, request.getCurrentPin())) {
                    log.warn("[PIN_CHANGE_FAIL] Wrong current PIN for card id={} by user id={}", id, userId);
                    return ResponseEntity.badRequest().body(Map.of(
                            "success", false, "message", "Current PIN is incorrect"));
                }
            }

            creditCardService.changePin(id, request);
            log.info("[PIN_CHANGE_OK] PIN changed for card id={} by user id={}", id, userId);
            return ResponseEntity.ok(Map.of("success", true, "message", "PIN changed successfully"));
        } catch (IllegalArgumentException e) {
            log.warn("[PIN_CHANGE_FAIL] Card id={} by user id={}: {}", id, userId, e.getMessage());
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

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            securityLog.warn("[UNAUTHENTICATED_ACCESS] Unauthenticated spending-limit attempt for card id={}", id);
            return ResponseEntity.status(401).body(Map.of(
                    "success", false, "message", "Not authenticated"));
        }
        if (!creditCardService.isOwnedByUser(id, userId)) {
            securityLog.warn("[ACCESS_DENIED_403] User id={} attempted to set spending limit for card id={} that does not belong to them",
                    userId, id);
            return ResponseEntity.status(403).body(Map.of(
                    "success", false, "message", "Forbidden"));
        }
        try {
            creditCardService.setSpendingLimit(id, request);
            log.info("[SPENDING_LIMIT_OK] Spending limit set for card id={} by user id={} limit={}",
                    id, userId, request.getLimit());
            return ResponseEntity.ok(Map.of("success", true, "message", "Spending limit updated"));
        } catch (IllegalArgumentException e) {
            log.warn("[SPENDING_LIMIT_FAIL] Card id={} by user id={}: {}", id, userId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }
}
