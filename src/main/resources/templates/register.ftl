<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Реєстрація - PayFlow</title>


    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="min-vh-100 d-flex align-items-center justify-content-center position-relative py-5" 
         style="background: linear-gradient(135deg, rgba(37, 99, 235, 0.05) 0%, rgba(255, 255, 255, 1) 50%, rgba(37, 99, 235, 0.1) 100%);">
        
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6 col-xl-5">
                    <div class="card shadow-lg border-0 animate-scale-in">
                        <div class="card-body p-4 p-md-5">
                            <!-- Logo -->
                            <div class="text-center mb-4">
                                <a href="/" class="text-decoration-none">
                                    <div class="d-flex align-items-center justify-content-center gap-2 mb-3">
                                        <i class="bi bi-wallet2 fs-3 text-primary"></i>
                                        <span class="fs-4 fw-bold text-primary">PayFlow</span>
                                    </div>
                                </a>
                                <h4 class="fw-bold mb-2">Створити обліковий запис</h4>
                                <p class="text-muted small">Почніть керувати фінансами вже сьогодні</p>
                            </div>

                            <!-- Progress Indicator -->
                            <div class="mb-4">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="badge bg-primary" id="step-badge-1">1. Особисті дані</span>
                                    <span class="badge bg-secondary" id="step-badge-2">2. Пароль</span>
                                    <span class="badge bg-secondary" id="step-badge-3">3. Завершення</span>
                                </div>
                                <div class="progress" style="height: 4px;">
                                    <div class="progress-bar bg-primary" id="progress-bar" role="progressbar" 
                                         style="width: 33%" aria-valuenow="33" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>

                            <!-- Registration Form -->
                            <form action="/register" method="POST" id="registerForm" novalidate>
                                <!-- Step 1: Personal Info -->
                                <div id="step-content-1">
                                    <div class="mb-3">
                                        <label for="firstName" class="form-label">Ім'я *</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" 
                                               placeholder="Іван" required>
                                        <div class="invalid-feedback">Введіть ім'я</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="lastName" class="form-label">Прізвище *</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" 
                                               placeholder="Іваненко" required>
                                        <div class="invalid-feedback">Введіть прізвище</div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="email" class="form-label">Email *</label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               placeholder="ivan@example.com" required>
                                        <div class="invalid-feedback">Введіть коректний email</div>
                                    </div>

                                    <button type="button" class="btn btn-primary w-100" onclick="goToStep(2)">
                                        Далі <i class="bi bi-arrow-right ms-2"></i>
                                    </button>
                                </div>

                                <!-- Step 2: Password -->
                                <div id="step-content-2" style="display: none;">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">Пароль *</label>
                                        <div class="position-relative">
                                            <input type="password" class="form-control" id="password" name="password" 
                                                   placeholder="Мінімум 8 символів" minlength="8" required>
                                            <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted" 
                                                    onclick="togglePasswordVisibility('password')" tabindex="-1">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                        <div class="invalid-feedback">Пароль має містити мінімум 8 символів</div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="confirmPassword" class="form-label">Підтвердження паролю *</label>
                                        <div class="position-relative">
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                   placeholder="Повторіть пароль" minlength="8" required>
                                            <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted" 
                                                    onclick="togglePasswordVisibility('confirmPassword')" tabindex="-1">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                        <div class="invalid-feedback" id="confirm-password-error">Паролі не співпадають</div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-outline-secondary w-100" onclick="goToStep(1)">
                                            <i class="bi bi-arrow-left me-2"></i> Назад
                                        </button>
                                        <button type="button" class="btn btn-primary w-100" onclick="goToStep(3)">
                                            Далі <i class="bi bi-arrow-right ms-2"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Step 3: Confirmation -->
                                <div id="step-content-3" style="display: none;">
                                    <div class="text-center mb-4">
                                        <div class="mb-3">
                                            <i class="bi bi-check-circle text-success" style="font-size: 4rem;"></i>
                                        </div>
                                        <h5 class="fw-semibold mb-2">Майже готово!</h5>
                                        <p class="text-muted small">Перевірте введені дані перед реєстрацією</p>
                                    </div>

                                    <div class="card bg-light border-0 mb-4">
                                        <div class="card-body">
                                            <div class="mb-2">
                                                <small class="text-muted">Ім'я та прізвище</small>
                                                <p class="mb-0 fw-medium" id="summary-name">-</p>
                                            </div>
                                            <div>
                                                <small class="text-muted">Email</small>
                                                <p class="mb-0 fw-medium" id="summary-email">-</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-check mb-4">
                                        <input class="form-check-input" type="checkbox" id="terms" name="terms" required>
                                        <label class="form-check-label small" for="terms">
                                            Я погоджуюсь з <a href="#" class="text-primary">умовами використання</a> 
                                            та <a href="#" class="text-primary">політикою конфіденційності</a>
                                        </label>
                                        <div class="invalid-feedback">Необхідно прийняти умови</div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-outline-secondary w-100" onclick="goToStep(2)">
                                            <i class="bi bi-arrow-left me-2"></i> Назад
                                        </button>
                                        <button type="submit" class="btn btn-success w-100">
                                            <i class="bi bi-check-lg me-2"></i> Зареєструватися
                                        </button>
                                    </div>
                                </div>
                            </form>

                            <p class="text-center text-muted small mt-4 mb-0">
                                Вже маєте обліковий запис?
                                <a href="/login" class="text-primary text-decoration-none fw-medium">Увійти</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/main.js"></script>
    <script>
        let currentStep = 1;

        function goToStep(targetStep) {
            // Validate current step before moving forward
            if (targetStep > currentStep) {
                if (currentStep === 1 && !validateStep1()) {
                    return;
                }
                if (currentStep === 2 && !validateStep2()) {
                    return;
                }
            }

            // Hide current step
            document.getElementById('step-content-' + currentStep).style.display = 'none';
            document.getElementById('step-badge-' + currentStep).classList.remove('bg-primary');
            document.getElementById('step-badge-' + currentStep).classList.add('bg-secondary');

            // Show target step
            currentStep = targetStep;
            document.getElementById('step-content-' + currentStep).style.display = 'block';
            document.getElementById('step-badge-' + currentStep).classList.remove('bg-secondary');
            document.getElementById('step-badge-' + currentStep).classList.add('bg-primary');

            // Update progress bar
            const progress = (currentStep / 3) * 100;
            document.getElementById('progress-bar').style.width = progress + '%';

            // Update summary if moving to step 3
            if (currentStep === 3) {
                updateSummary();
            }
        }

        function validateStep1() {
            const firstName = document.getElementById('firstName');
            const lastName = document.getElementById('lastName');
            const email = document.getElementById('email');

            let isValid = true;

            if (!firstName.value.trim()) {
                firstName.classList.add('is-invalid');
                isValid = false;
            } else {
                firstName.classList.remove('is-invalid');
            }

            if (!lastName.value.trim()) {
                lastName.classList.add('is-invalid');
                isValid = false;
            } else {
                lastName.classList.remove('is-invalid');
            }

            if (!email.value.trim() || !email.validity.valid) {
                email.classList.add('is-invalid');
                isValid = false;
            } else {
                email.classList.remove('is-invalid');
            }

            return isValid;
        }

        function validateStep2() {
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');

            let isValid = true;

            if (!password.value || password.value.length < 8) {
                password.classList.add('is-invalid');
                isValid = false;
            } else {
                password.classList.remove('is-invalid');
            }

            if (password.value !== confirmPassword.value) {
                confirmPassword.classList.add('is-invalid');
                document.getElementById('confirm-password-error').textContent = 'Паролі не співпадають';
                isValid = false;
            } else if (!confirmPassword.value || confirmPassword.value.length < 8) {
                confirmPassword.classList.add('is-invalid');
                document.getElementById('confirm-password-error').textContent = 'Пароль має містити мінімум 8 символів';
                isValid = false;
            } else {
                confirmPassword.classList.remove('is-invalid');
            }

            return isValid;
        }

        function updateSummary() {
            const firstName = document.getElementById('firstName').value;
            const lastName = document.getElementById('lastName').value;
            const email = document.getElementById('email').value;

            document.getElementById('summary-name').textContent = firstName + ' ' + lastName;
            document.getElementById('summary-email').textContent = email;
        }

        // Real-time validation
        document.getElementById('firstName').addEventListener('input', function() {
            if (this.value.trim()) {
                this.classList.remove('is-invalid');
            }
        });

        document.getElementById('lastName').addEventListener('input', function() {
            if (this.value.trim()) {
                this.classList.remove('is-invalid');
            }
        });

        document.getElementById('email').addEventListener('input', function() {
            if (this.value.trim() && this.validity.valid) {
                this.classList.remove('is-invalid');
            }
        });

        document.getElementById('password').addEventListener('input', function() {
            if (this.value.length >= 8) {
                this.classList.remove('is-invalid');
            }
        });

        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            if (this.value === password && this.value.length >= 8) {
                this.classList.remove('is-invalid');
            }
        });

        // Form submission
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const terms = document.getElementById('terms');
            if (!terms.checked) {
                e.preventDefault();
                terms.classList.add('is-invalid');
                terms.parentElement.querySelector('.invalid-feedback').style.display = 'block';
            }
        });

        document.getElementById('terms').addEventListener('change', function() {
            if (this.checked) {
                this.classList.remove('is-invalid');
                this.parentElement.querySelector('.invalid-feedback').style.display = 'none';
            }
        });
    </script>
</body>
</html>
