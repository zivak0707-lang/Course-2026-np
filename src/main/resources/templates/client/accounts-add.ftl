<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Додати рахунок - PayFlow</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="p-3 border-bottom">
                <a href="/" class="text-decoration-none">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-wallet2 fs-4 text-primary"></i>
                        <span class="fs-5 fw-bold text-primary">PayFlow</span>
                    </div>
                </a>
            </div>

            <nav class="sidebar-nav p-3">
                <a href="/dashboard" class="nav-link">
                    <i class="bi bi-grid-fill"></i>
                    <span>Дашборд</span>
                </a>
                <a href="/dashboard/accounts" class="nav-link active">
                    <i class="bi bi-wallet2"></i>
                    <span>Мої рахунки</span>
                </a>
                <a href="/dashboard/cards" class="nav-link">
                    <i class="bi bi-credit-card"></i>
                    <span>Мої картки</span>
                </a>
                <a href="/dashboard/payment" class="nav-link">
                    <i class="bi bi-send"></i>
                    <span>Здійснити платіж</span>
                </a>
                <a href="/dashboard/transactions" class="nav-link">
                    <i class="bi bi-list-ul"></i>
                    <span>Історія транзакцій</span>
                </a>
                <a href="/dashboard/settings" class="nav-link">
                    <i class="bi bi-gear"></i>
                    <span>Налаштування</span>
                </a>
            </nav>

            <div class="p-3 border-top mt-auto">
                <a href="/logout" class="nav-link text-muted">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Вийти</span>
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Bar -->
            <header class="bg-white border-bottom sticky-top">
                <div class="d-flex align-items-center justify-content-between p-3 p-lg-4">
                    <button class="btn btn-link d-lg-none p-0 text-dark" onclick="toggleSidebar()">
                        <i class="bi bi-list fs-3"></i>
                    </button>
                    
                    <div class="flex-grow-1"></div>

                    <div class="dropdown">
                        <button class="btn btn-link text-dark text-decoration-none dropdown-toggle d-flex align-items-center gap-2" 
                                type="button" data-bs-toggle="dropdown">
                            <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" 
                                 style="width: 40px; height: 40px;">
                                <span class="fw-semibold text-primary">ІП</span>
                            </div>
                            <span class="fw-medium d-none d-sm-inline">Іван Петренко</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-person me-2"></i> Профіль</a></li>
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-gear me-2"></i> Налаштування</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Війти</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="p-3 p-lg-4">
                <div class="animate-fade-in">
                    <!-- Header -->
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <a href="/dashboard/accounts" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-arrow-left me-2"></i> Назад до рахунків
                        </a>
                        <div>
                            <h1 class="h3 fw-bold mb-1">Створити новий рахунок</h1>
                            <p class="text-muted mb-0">Виберіть тип рахунку для створення</p>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <!-- Account Type Selection -->
                            <div class="card border-0 shadow-sm">
                                <div class="card-body p-4">
                                    <form action="/dashboard/accounts/add" method="POST">
                                        <div class="mb-4">
                                            <label class="form-label fw-semibold">Оберіть тип рахунку *</label>
                                            
                                            <div class="row g-3">
                                                <!-- Checking Account -->
                                                <div class="col-md-4">
                                                    <input type="radio" class="btn-check" name="accountType" id="checking" value="Checking" required>
                                                    <label class="btn btn-outline-primary w-100 py-4" for="checking">
                                                        <i class="bi bi-wallet2 fs-1 d-block mb-3"></i>
                                                        <h6 class="mb-2">Поточний</h6>
                                                        <small class="text-muted">Для щоденних операцій</small>
                                                    </label>
                                                </div>

                                                <!-- Savings Account -->
                                                <div class="col-md-4">
                                                    <input type="radio" class="btn-check" name="accountType" id="savings" value="Savings">
                                                    <label class="btn btn-outline-primary w-100 py-4" for="savings">
                                                        <i class="bi bi-piggy-bank fs-1 d-block mb-3"></i>
                                                        <h6 class="mb-2">Ощадний</h6>
                                                        <small class="text-muted">Для накопичень</small>
                                                    </label>
                                                </div>

                                                <!-- Business Account -->
                                                <div class="col-md-4">
                                                    <input type="radio" class="btn-check" name="accountType" id="business" value="Business">
                                                    <label class="btn btn-outline-primary w-100 py-4" for="business">
                                                        <i class="bi bi-briefcase fs-1 d-block mb-3"></i>
                                                        <h6 class="mb-2">Бізнес</h6>
                                                        <small class="text-muted">Для підприємства</small>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="alert alert-info d-flex align-items-start mb-4">
                                            <i class="bi bi-info-circle me-2 mt-1"></i>
                                            <div>
                                                <strong>Важлива інформація</strong>
                                                <ul class="mb-0 mt-2 small ps-3">
                                                    <li>Номер рахунку буде згенеровано автоматично</li>
                                                    <li>Початковий баланс: $0.00</li>
                                                    <li>Статус рахунку: Активний</li>
                                                    <li>Ви зможете поповнити рахунок після створення</li>
                                                </ul>
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary btn-lg px-5">
                                                <i class="bi bi-plus-lg me-2"></i> Створити рахунок
                                            </button>
                                            <a href="/dashboard/accounts" class="btn btn-outline-secondary btn-lg px-4">
                                                Скасувати
                                            </a>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Features -->
                            <div class="row g-3 mt-4">
                                <div class="col-md-4">
                                    <div class="text-center">
                                        <i class="bi bi-shield-check text-success fs-2 mb-2"></i>
                                        <h6 class="fw-semibold">Безпечно</h6>
                                        <small class="text-muted">256-бітне шифрування</small>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-center">
                                        <i class="bi bi-lightning-charge text-warning fs-2 mb-2"></i>
                                        <h6 class="fw-semibold">Миттєво</h6>
                                        <small class="text-muted">Рахунок активний одразу</small>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-center">
                                        <i class="bi bi-cash-stack text-primary fs-2 mb-2"></i>
                                        <h6 class="fw-semibold">Без комісій</h6>
                                        <small class="text-muted">Безкоштовне обслуговування</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999" id="toast-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/main.js"></script>
</body>
</html>
