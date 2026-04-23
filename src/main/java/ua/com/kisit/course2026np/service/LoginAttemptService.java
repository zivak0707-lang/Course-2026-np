package ua.com.kisit.course2026np.service;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class LoginAttemptService {

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
        attempts.compute(normalize(email), (k, info) -> {
            if (info == null) info = new AttemptInfo();
            if (info.lockedUntil != null && !LocalDateTime.now().isBefore(info.lockedUntil)) {
                info.count = 0;
                info.lockedUntil = null;
            }
            info.count++;
            if (info.count >= MAX_ATTEMPTS) {
                info.lockedUntil = LocalDateTime.now().plusMinutes(LOCKOUT_MINUTES);
            }
            return info;
        });
    }

    public void recordSuccess(String email) {
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
