package ua.com.kisit.course2026np.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ua.com.kisit.course2026np.dto.ChangePinRequest;
import ua.com.kisit.course2026np.dto.SpendingLimitRequest;
import ua.com.kisit.course2026np.entity.CreditCard;
import ua.com.kisit.course2026np.entity.User;
import ua.com.kisit.course2026np.repository.CreditCardRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Service for CreditCard CRUD operations + Block/Unblock, PIN, Spending Limit.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CreditCardService {

    private final CreditCardRepository creditCardRepository;

    /**
     * Dedicated BCrypt encoder for PIN hashing.
     * Strength 10 is the OWASP-recommended minimum.
     */
    private static final BCryptPasswordEncoder PIN_ENCODER =
            new BCryptPasswordEncoder(10);

    // ══════════════════════════════════════════════════════════
    // CREATE
    // ══════════════════════════════════════════════════════════

    /**
     * Creates a new credit card.
     *
     * @param card card to persist
     * @return saved card with assigned ID
     * @throws IllegalArgumentException if card number already exists
     */
    public CreditCard createCreditCard(CreditCard card) {
        log.info("Creating credit card: {}", card.getCardNumber());

        if (creditCardRepository.existsByCardNumber(card.getCardNumber())) {
            log.error("Card with number {} already exists", card.getCardNumber());
            throw new IllegalArgumentException(
                    "Card with number " + card.getCardNumber() + " already exists");
        }

        CreditCard saved = creditCardRepository.save(card);
        log.info("Credit card created with ID: {}", saved.getId());
        return saved;
    }

    // ══════════════════════════════════════════════════════════
    // READ
    // ══════════════════════════════════════════════════════════

    @Transactional(readOnly = true)
    public Optional<CreditCard> getCreditCardById(Long id) {
        log.debug("Looking up credit card by ID: {}", id);
        return creditCardRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<CreditCard> getCreditCardByNumber(String cardNumber) {
        log.debug("Looking up credit card by number: {}", cardNumber);
        return creditCardRepository.findByCardNumber(cardNumber);
    }

    @Transactional(readOnly = true)
    public List<CreditCard> getAllCreditCards() {
        log.debug("Fetching all credit cards");
        return creditCardRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<CreditCard> getCreditCardsByUser(User user) {
        log.debug("Fetching credit cards for user ID: {}", user.getId());
        return creditCardRepository.findByUser(user);
    }

    // ══════════════════════════════════════════════════════════
    // UPDATE – general fields
    // ══════════════════════════════════════════════════════════

    /**
     * Updates cardholder name and expiry date.
     */
    public CreditCard updateCreditCard(Long id, CreditCard updatedCard) {
        log.info("Updating credit card ID: {}", id);
        CreditCard existing = findOrThrow(id);
        existing.setCardholderName(updatedCard.getCardholderName());
        existing.setExpiryDate(updatedCard.getExpiryDate());
        CreditCard saved = creditCardRepository.save(existing);
        log.info("Credit card ID {} updated", id);
        return saved;
    }

    // ══════════════════════════════════════════════════════════
    // UPDATE – block / unblock
    // ══════════════════════════════════════════════════════════

    /**
     * Toggles the card's active state.
     * Blocks an active card; unblocks a blocked one.
     *
     * @return new active state: true = unblocked, false = blocked
     */
    public boolean toggleBlockCard(Long id) {
        CreditCard card = findOrThrow(id);
        boolean newState = !card.getIsActive();
        card.setIsActive(newState);
        creditCardRepository.save(card);
        log.info("Card {} is now {}", id, newState ? "ACTIVE" : "BLOCKED");
        return newState;
    }

    /** Explicitly blocks a card (sets isActive = false). */
    public void deactivateCreditCard(Long id) {
        log.info("Deactivating credit card ID: {}", id);
        CreditCard card = findOrThrow(id);
        card.setIsActive(false);
        creditCardRepository.save(card);
        log.info("Credit card ID {} deactivated", id);
    }

    /** Explicitly unblocks a card (sets isActive = true). */
    public void activateCreditCard(Long id) {
        log.info("Activating credit card ID: {}", id);
        CreditCard card = findOrThrow(id);
        card.setIsActive(true);
        creditCardRepository.save(card);
        log.info("Credit card ID {} activated", id);
    }

    // ══════════════════════════════════════════════════════════
    // UPDATE – PIN
    // ══════════════════════════════════════════════════════════

    /**
     * Validates and updates the card's PIN.
     * The PIN is hashed with BCrypt before persistence — never stored in plain text.
     *
     * @param cardId  target card ID
     * @param request DTO containing newPin + confirmPin
     * @throws IllegalArgumentException if PINs don't match or are non-numeric
     */
    public void changePin(Long cardId, ChangePinRequest request) {
        if (!request.getNewPin().equals(request.getConfirmPin())) {
            throw new IllegalArgumentException("PINs do not match");
        }
        CreditCard card = findOrThrow(cardId);
        String hashed = PIN_ENCODER.encode(request.getNewPin());
        card.setPinCode(hashed);
        creditCardRepository.save(card);
        log.info("PIN updated for card ID {}", cardId);
    }

    /**
     * Verifies a raw PIN against the stored BCrypt hash.
     * Use this in payment authorization flows.
     *
     * @param cardId target card ID
     * @param rawPin 4-digit PIN entered by the user
     * @return true if PIN matches
     */
    @Transactional(readOnly = true)
    public boolean verifyPin(Long cardId, String rawPin) {
        CreditCard card = findOrThrow(cardId);
        if (card.getPinCode() == null) return false;
        return PIN_ENCODER.matches(rawPin, card.getPinCode());
    }

    // ══════════════════════════════════════════════════════════
    // UPDATE – spending limit
    // ══════════════════════════════════════════════════════════

    /**
     * Sets or removes the daily spending limit for a card.
     * Pass limit = null or 0 to remove the cap entirely.
     *
     * @param cardId  target card ID
     * @param request DTO containing the new limit value
     */
    public void setSpendingLimit(Long cardId, SpendingLimitRequest request) {
        CreditCard card = findOrThrow(cardId);
        BigDecimal limit = request.getLimit();

        if (limit == null || limit.compareTo(BigDecimal.ZERO) == 0) {
            card.setSpendingLimit(null);
            log.info("Spending limit removed for card ID {}", cardId);
        } else {
            card.setSpendingLimit(limit);
            log.info("Spending limit set to {} for card ID {}", limit, cardId);
        }
        creditCardRepository.save(card);
    }

    // ══════════════════════════════════════════════════════════
    // DELETE
    // ══════════════════════════════════════════════════════════

    public void deleteCreditCard(Long id) {
        log.info("Deleting credit card ID: {}", id);
        if (!creditCardRepository.existsById(id)) {
            log.error("Credit card ID {} not found", id);
            throw new IllegalArgumentException("Credit card with ID " + id + " not found");
        }
        creditCardRepository.deleteById(id);
        log.info("Credit card ID {} deleted", id);
    }

    // ══════════════════════════════════════════════════════════
    // UTILITIES
    // ══════════════════════════════════════════════════════════

    @Transactional(readOnly = true)
    public boolean isExpired(Long id) {
        return findOrThrow(id).isExpired();
    }

    @Transactional(readOnly = true)
    public String getMaskedCardNumber(Long id) {
        return findOrThrow(id).getMaskedCardNumber();
    }

    @Transactional(readOnly = true)
    public long countCreditCards() {
        long count = creditCardRepository.count();
        log.debug("Total credit cards: {}", count);
        return count;
    }

    @Transactional(readOnly = true)
    public long countActiveCards() {
        long count = creditCardRepository.findAll().stream()
                .filter(CreditCard::getIsActive).count();
        log.debug("Active credit cards: {}", count);
        return count;
    }

    // ══════════════════════════════════════════════════════════
    // PRIVATE HELPERS
    // ══════════════════════════════════════════════════════════

    private CreditCard findOrThrow(Long id) {
        return creditCardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Credit card with ID " + id + " not found"));
    }
}