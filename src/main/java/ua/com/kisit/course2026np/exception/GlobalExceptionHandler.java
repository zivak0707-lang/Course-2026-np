package ua.com.kisit.course2026np.exception;

import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import ua.com.kisit.course2026np.controller.ClientController;

import java.time.LocalDateTime;

@ControllerAdvice
public class GlobalExceptionHandler {

    // ─────────────────────────────────────────────────────────────────
    //  BLOCKED USER
    //  ВАЖЛИВО: повертаємо ModelAndView(RedirectView), а НЕ String.
    //  З @ControllerAdvice рядок "redirect:/..." ігнорується Spring-ом —
    //  він не проходить через ViewNameTranslator як у звичайному контролері.
    // ─────────────────────────────────────────────────────────────────
    @ExceptionHandler(ClientController.UserBlockedException.class)
    public ModelAndView handleBlockedException() {
        return new ModelAndView(new RedirectView("/blocked", true));
    }

    // ─────────────────────────────────────────────────────────────────
    //  СТАНДАРТНІ ОБРОБНИКИ
    // ─────────────────────────────────────────────────────────────────
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(
            IllegalArgumentException ex, WebRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(),
                "Невірні параметри запиту",
                ex.getMessage(),
                request.getDescription(false),
                LocalDateTime.now()
        ));
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ErrorResponse> handleIllegalStateException(
            IllegalStateException ex, WebRequest request) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(new ErrorResponse(
                HttpStatus.CONFLICT.value(),
                "Операція неможлива",
                ex.getMessage(),
                request.getDescription(false),
                LocalDateTime.now()
        ));
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponse> handleRuntimeException(
            RuntimeException ex, WebRequest request) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Внутрішня помилка сервера",
                ex.getMessage(),
                request.getDescription(false),
                LocalDateTime.now()
        ));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGlobalException(
            Exception ex, WebRequest request) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Несподівана помилка",
                ex.getMessage(),
                request.getDescription(false),
                LocalDateTime.now()
        ));
    }

    @Data
    @AllArgsConstructor
    public static class ErrorResponse {
        private int status;
        private String error;
        private String message;
        private String path;
        private LocalDateTime timestamp;
    }
}