package ua.com.kisit.course2026np.entity;

/**
 * Типи платежів
 */
public enum PaymentType {
    /**
     * Платіж - переказ коштів з рахунку
     */
    PAYMENT,

    /**
     * Поповнення - зарахування коштів на рахунок
     */
    REPLENISHMENT,

    /**
     * Переказ - переказ між рахунками
     */
    TRANSFER
}