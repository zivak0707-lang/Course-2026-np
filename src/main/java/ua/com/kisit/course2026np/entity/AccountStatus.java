package ua.com.kisit.course2026np.entity;

/**
 * Статуси банківського рахунку
 */
public enum AccountStatus {
    /**
     * Активний рахунок - доступні всі операції
     */
    ACTIVE,

    /**
     * Заблокований рахунок - операції недоступні
     */
    BLOCKED
}