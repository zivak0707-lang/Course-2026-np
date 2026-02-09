<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вхід - PayFlow</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="min-vh-100 d-flex align-items-center justify-content-center position-relative" style="background: linear-gradient(135deg, rgba(37, 99, 235, 0.05) 0%, rgba(255, 255, 255, 1) 50%, rgba(37, 99, 235, 0.1) 100%);">
        <!-- Background blobs -->
        <div class="position-absolute" style="top: 5rem; right: 2.5rem; width: 18rem; height: 18rem; background: rgba(37, 99, 235, 0.1); border-radius: 50%; filter: blur(80px);"></div>
        <div class="position-absolute" style="bottom: 2.5rem; left: 2.5rem; width: 14rem; height: 14rem; background: rgba(16, 185, 129, 0.1); border-radius: 50%; filter: blur(80px);"></div>
        
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5 col-xl-4">
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
                                <h4 class="fw-bold mb-2">Ласкаво просимо!</h4>
                                <p class="text-muted small">Введіть дані для входу в обліковий запис</p>
                            </div>

                            <!-- Error message -->
                            <#if error??>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </#if>

                            <!-- Login Form -->
                            <form action="/login" method="POST" id="loginForm">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           placeholder="your@example.com" required>
                                </div>

                                <div class="mb-3">
                                    <label for="password" class="form-label">Пароль *</label>
                                    <div class="position-relative">
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="••••••••" required>
                                        <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted" 
                                                onclick="togglePasswordVisibility('password')" tabindex="-1">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="remember" name="remember">
                                        <label class="form-check-label small" for="remember">
                                            Запам'ятати мене
                                        </label>
                                    </div>
                                    <a href="/forgot-password" class="small text-primary text-decoration-none">
                                        Забули пароль?
                                    </a>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 py-2 mb-3">
                                    Увійти
                                </button>

                                <button type="button" class="btn btn-outline-secondary w-100 py-2 mb-3" 
                                        onclick="window.location.href='/admin/login'">
                                    Увійти як адміністратор
                                </button>

                                <p class="text-center text-muted small mb-0">
                                    Ще не маєте облікового запису?
                                    <a href="/register" class="text-primary text-decoration-none fw-medium">Зареєструватися</a>
                                </p>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="/js/main.js"></script>
</body>
</html>
