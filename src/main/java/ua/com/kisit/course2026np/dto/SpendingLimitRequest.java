package ua.com.kisit.course2026np.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class SpendingLimitRequest {

    /**
     * Daily spending cap. Send null or 0 to remove the limit entirely.
     */
    @DecimalMin(value = "0.00", message = "Limit must be a positive value")
    @Digits(integer = 17, fraction = 2, message = "Invalid amount format")
    private BigDecimal limit;
}