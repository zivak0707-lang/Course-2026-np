package ua.com.kisit.course2026np.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class ChangePinRequest {

    /** Поточний PIN — обов'язковий якщо PIN вже встановлений */
    private String currentPin;

    @NotBlank
    @Pattern(regexp = "\\d{4}", message = "PIN must be exactly 4 digits")
    private String newPin;

    @NotBlank
    @Pattern(regexp = "\\d{4}", message = "PIN must be exactly 4 digits")
    private String confirmPin;
}