package ua.com.kisit.course2026np.service;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
public class LoginAttemptService {

    private static final Logger securityLog = LoggerFactory.getLogger("SECURITY");

    private static final int    MAX_ATTEMPTS    = 5;
    private static final long   LOCKOUT_MINUTES = 15;

    private final ConcurrentHashMap<String, AttemptInfo> attempts = new ConcurrentHashMap<>();

    public boolean isBlocked(String email) {
        AttemptInfo info = attempts.get(normalize(email));
        if (info == null || info.lockedUntil == null) return false;
        if (LocalDateTime.now().isBefore(info.lockedUntil)) return true;
        attempts.remove(normalize(email));
        return false;
    }

    public long getMinutesLeft(String email) {
        AttemptInfo info = attempts.get(normalize(email));
        if (info == null || info.lockedUntil == null) return 0;
        long diff = ChronoUnit.MINUTES.between(LocalDateTime.now(), info.lockedUntil);
        return Math.max(1, diff + 1);
    }

    public void recordFailure(String email) {
        String key = normalize(email);
        attempts.compute(key, (k, info) -> {
            if (info == null) info = new AttemptInfo();
            if (info.lockedUntil != null && !LocalDateTime.now().isBefore(info.lockedUntil)) {
                info.count = 0;
                info.lockedUntil = null;
            }
            info.count++;
            if (info.count >= MAX_ATTEMPTS) {
                info.lockedUntil = LocalDateTime.now().plusMinutes(LOCKOUT_MINUTES);
                securityLog.warn("[BRUTE_FORCE_LOCKOUT] Account locked after {} attempts: email={} lockedUntil={}",
                        MAX_ATTEMPTS, email, info.lockedUntil);
            } else {
                securityLog.warn("[LOGIN_FAIL_ATTEMPT] Failed attempt #{} of {} for email={}",
                        info.count, MAX_ATTEMPTS, email);
            }
            return info;
        });
    }

    public void recordSuccess(String email) {
        log.debug("[LOGIN_ATTEMPTS_CLEARED] Cleared failed attempts for email={}", email);
        attempts.remove(normalize(email));
    }

    private String normalize(String email) {
        return email == null ? "" : email.toLowerCase().trim();
    }

    private static class AttemptInfo {
        int count = 0;
        LocalDateTime lockedUntil = null;
    }
}
