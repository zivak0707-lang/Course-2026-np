<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PayFlow - Керуйте вашими платежами легко</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light navbar-custom fixed-top">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="bi bi-wallet2 fs-4"></i>
                <span>PayFlow</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-3">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Головна</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Можливості</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">Про нас</a>
                    </li>
                    <li class="nav-item">
                        <a href="/login" class="btn btn-outline-primary btn-sm">Увійти</a>
                    </li>
                    <li class="nav-item">
                        <a href="/register" class="btn btn-primary btn-sm">Почати</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-gradient"></div>
        <div class="hero-blob-1"></div>
        <div class="hero-blob-2"></div>
        
        <div class="container position-relative">
            <div class="row justify-content-center">
                <div class="col-lg-10 text-center animate-fade-in">
                    <h1 class="display-3 fw-bold mb-4">
                        Керуйте вашими платежами 
                        <span class="text-primary">легко</span>
                    </h1>
                    <p class="lead text-muted mb-5 px-lg-5">
                        Сучасна платформа для безпечних транзакцій, моніторингу в реальному часі
                        та простого управління картками — все в одному місці.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap">
                        <a href="/register" class="btn btn-primary btn-lg px-5">
                            Почати роботу
                        </a>
                        <a href="/login" class="btn btn-outline-primary btn-lg px-5">
                            Увійти
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-5 bg-light">
        <div class="container py-5">
            <h2 class="text-center fw-bold mb-5">Чому обирають PayFlow?</h2>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3 animate-slide-up">
                    <div class="feature-card">
                        <div class="feature-icon mx-auto">
                            <i class="bi bi-shield-check fs-2"></i>
                        </div>
                        <h5 class="fw-semibold mb-2">Безпечні транзакції</h5>
                        <p class="text-muted small mb-0">
                            Банківське шифрування захищає кожну вашу транзакцію.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-3 animate-slide-up" style="animation-delay: 0.1s;">
                    <div class="feature-card">
                        <div class="feature-icon mx-auto">
                            <i class="bi bi-activity fs-2"></i>
                        </div>
                        <h5 class="fw-semibold mb-2">Моніторинг в реальному часі</h5>
                        <p class="text-muted small mb-0">
                            Відстежуйте витрати та доходи через живі дашборди.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-3 animate-slide-up" style="animation-delay: 0.2s;">
                    <div class="feature-card">
                        <div class="feature-icon mx-auto">
                            <i class="bi bi-credit-card-2-front fs-2"></i>
                        </div>
                        <h5 class="fw-semibold mb-2">Управління картками</h5>
                        <p class="text-muted small mb-0">
                            Керуйте всіма вашими картками в одному місці з легкістю.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-3 animate-slide-up" style="animation-delay: 0.3s;">
                    <div class="feature-card">
                        <div class="feature-icon mx-auto">
                            <i class="bi bi-headset fs-2"></i>
                        </div>
                        <h5 class="fw-semibold mb-2">Підтримка 24/7</h5>
                        <p class="text-muted small mb-0">
                            Наша команда завжди готова допомогти вам.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-4 border-top bg-white">
        <div class="container">
            <p class="text-center text-muted small mb-0">
                © 2026 PayFlow. Всі права захищені.
            </p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="/static/js/main.js"></script>
</body>
</html>
