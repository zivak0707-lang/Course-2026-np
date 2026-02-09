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
                                    <span class="badge bg-primary" id="step-1">1. Особисті дані</span>
                                    <span class="badge bg-secondary" id="step-2">2. Пароль</span>
                                    <span class="badge bg-secondary" id="step-3">3. Завершення</span>
                                </div>
                                <div class="progress" style="height: 4px;">
                                    <div class="progress-bar bg-primary" id="progress-bar" role="progressbar" 
                                         style="width: 33%" aria-valuenow="33" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>

                            <!-- Registration Form -->
                            <form action="/register" method="POST" id="registerForm" class="needs-validation" novalidate>
                                <!-- Step 1: Personal Info -->
                                <div id="step-1-content">
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

                                    <button type="button" class="btn btn-primary w-100" onclick="nextStep(2)">
                                        Далі <i class="bi bi-arrow-right ms-2"></i>
                                    </button>
                                </div>

                                <!-- Step 2: Password -->
                                <div id="step-2-content" style="display: none;">
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
                                        <div class="invalid-feedback">Паролі не співпадають</div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-outline-secondary w-100" onclick="prevStep(1)">
                                            <i class="bi bi-arrow-left me-2"></i> Назад
                                        </button>
                                        <button type="button" class="btn btn-primary w-100" onclick="nextStep(3)">
                                            Далі <i class="bi bi-arrow-right ms-2"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Step 3: Confirmation -->
                                <div id="step-3-content" style="display: none;">
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
                                        <button type="button" class="btn btn-outline-secondary w-100" onclick="prevStep(2)">
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
    <script src="/js/main.js"></script>
    <script>
        let currentStep = 1;

        function nextStep(step) {
            // Validate current step
            if (currentStep === 1) {
                const firstName = document.getElementById('firstName');
                const lastName = document.getElementById('lastName');
                const email = document.getElementById('email');
                
                if (!firstName.value || !lastName.value || !email.value || !email.validity.valid) {
                    document.getElementById('registerForm').classList.add('was-validated');
                    return;
                }
            }
            
            if (currentStep === 2) {
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');
                
                if (!password.value || password.value.length < 8) {
                    document.getElementById('registerForm').classList.add('was-validated');
                    return;
                }
                
                if (password.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity('Паролі не співпадають');
                    document.getElementById('registerForm').classList.add('was-validated');
                    return;
                }
                confirmPassword.setCustomValidity('');
                
                // Update summary
                document.getElementById('summary-name').textContent = 
                    document.getElementById('firstName').value + ' ' + document.getElementById('lastName').value;
                document.getElementById('summary-email').textContent = document.getElementById('email').value;
            }

            // Hide current step
            document.getElementById(`step-${currentStep}-content`).style.display = 'none';
            document.getElementById(`step-${currentStep}`).classList.remove('bg-primary');
            document.getElementById(`step-${currentStep}`).classList.add('bg-secondary');

            // Show next step
            currentStep = step;
            document.getElementById(`step-${currentStep}-content`).style.display = 'block';
            document.getElementById(`step-${currentStep}`).classList.remove('bg-secondary');
            document.getElementById(`step-${currentStep}`).classList.add('bg-primary');

            // Update progress bar
            const progress = (currentStep / 3) * 100;
            document.getElementById('progress-bar').style.width = progress + '%';
            document.getElementById('progress-bar').setAttribute('aria-valuenow', progress);
        }

        function prevStep(step) {
            // Hide current step
            document.getElementById(`step-${currentStep}-content`).style.display = 'none';
            document.getElementById(`step-${currentStep}`).classList.remove('bg-primary');
            document.getElementById(`step-${currentStep}`).classList.add('bg-secondary');

            // Show previous step
            currentStep = step;
            document.getElementById(`step-${currentStep}-content`).style.display = 'block';
            document.getElementById(`step-${currentStep}`).classList.remove('bg-secondary');
            document.getElementById(`step-${currentStep}`).classList.add('bg-primary');

            // Update progress bar
            const progress = (currentStep / 3) * 100;
            document.getElementById('progress-bar').style.width = progress + '%';
            document.getElementById('progress-bar').setAttribute('aria-valuenow', progress);
        }
    </script>
</body>
</html>
