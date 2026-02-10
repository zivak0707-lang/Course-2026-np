<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вхід адміністратора - PayFlow</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="min-vh-100 d-flex align-items-center justify-content-center position-relative" 
         style="background: linear-gradient(135deg, rgba(30, 41, 59, 0.95) 0%, rgba(15, 23, 42, 1) 100%);">
        
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5 col-xl-4">
                    <div class="card shadow-lg border-0 animate-scale-in">
                        <div class="card-body p-4 p-md-5">
                            <!-- Logo -->
                            <div class="text-center mb-4">
                                <a href="/" class="text-decoration-none">
                                    <div class="d-flex align-items-center justify-content-center gap-2 mb-3">
                                        <i class="bi bi-shield-lock-fill fs-3 text-danger"></i>
                                        <span class="fs-4 fw-bold text-dark">PayFlow Admin</span>
                                    </div>
                                </a>
                                <h4 class="fw-bold mb-2">Панель адміністратора</h4>
                                <p class="text-muted small">Введіть облікові дані адміністратора</p>
                            </div>

                            <!-- Error message -->
                            <#if error??>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </#if>

                            <!-- Admin Login Form -->
                            <form action="/admin/login" method="POST" id="adminLoginForm">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email адміністратора *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-person-badge"></i>
                                        </span>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               placeholder="admin@payflow.com" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="password" class="form-label">Пароль *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-key"></i>
                                        </span>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="••••••••" required>
                                        <button type="button" class="btn btn-outline-secondary" 
                                                onclick="togglePassword()" tabindex="-1">
                                            <i class="bi bi-eye" id="toggleIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="remember" name="remember">
                                        <label class="form-check-label small" for="remember">
                                            Запам'ятати мене
                                        </label>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-danger w-100 py-2 mb-3">
                                    <i class="bi bi-shield-lock me-2"></i> Увійти як адміністратор
                                </button>

                                <div class="text-center">
                                    <a href="/login" class="btn btn-link text-muted text-decoration-none">
                                        <i class="bi bi-arrow-left me-2"></i> Повернутися до звичайного входу
                                    </a>
                                </div>
                            </form>

                            <!-- Security Notice -->
                            <div class="alert alert-warning mt-4 d-flex align-items-start" role="alert">
                                <i class="bi bi-exclamation-triangle me-2 mt-1"></i>
                                <small>
                                    <strong>Увага!</strong> Цей вхід призначений тільки для адміністраторів системи. 
                                    Всі дії логуються.
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('bi-eye');
                toggleIcon.classList.add('bi-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('bi-eye-slash');
                toggleIcon.classList.add('bi-eye');
            }
        }
    </script>
</body>
</html>
