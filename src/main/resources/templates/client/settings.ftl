<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Налаштування - PayFlow</title>
    
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
                <a href="/dashboard/accounts" class="nav-link">
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
                <a href="/dashboard/settings" class="nav-link active">
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
                                <span class="fw-semibold text-primary">${user.firstName?substring(0,1)}${user.lastName?substring(0,1)}</span>
                            </div>
                            <span class="fw-medium d-none d-sm-inline">${user.firstName} ${user.lastName}</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-person me-2"></i> Профіль</a></li>
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-gear me-2"></i> Налаштування</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Вийти</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="p-3 p-lg-4">
                <div class="animate-fade-in">
                    <h1 class="h3 fw-bold mb-4">Налаштування профілю</h1>

                    <div class="row g-4">
                        <!-- Profile Settings -->
                        <div class="col-lg-8">
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0 fw-semibold">Особиста інформація</h5>
                                </div>
                                <div class="card-body p-4">
                                    <form>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Ім'я</label>
                                                <input type="text" class="form-control" value="${user.firstName}" readonly>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Прізвище</label>
                                                <input type="text" class="form-control" value="${user.lastName}" readonly>
                                            </div>
                                            <div class="col-12">
                                                <label class="form-label">Email</label>
                                                <input type="email" class="form-control" value="${user.email}" readonly>
                                            </div>
                                        </div>

                                        <div class="alert alert-info mt-3 d-flex align-items-start">
                                            <i class="bi bi-info-circle me-2 mt-1"></i>
                                            <small>Редагування профілю буде доступне у наступних версіях</small>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Security Settings -->
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0 fw-semibold">Безпека</h5>
                                </div>
                                <div class="card-body p-4">
                                    <button class="btn btn-outline-primary" disabled>
                                        <i class="bi bi-key me-2"></i> Змінити пароль
                                    </button>
                                    <button class="btn btn-outline-secondary ms-2" disabled>
                                        <i class="bi bi-shield-check me-2"></i> Двофакторна автентифікація
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Account Info -->
                        <div class="col-lg-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body p-4 text-center">
                                    <div class="rounded-circle bg-primary bg-opacity-10 d-inline-flex align-items-center justify-content-center mb-3" 
                                         style="width: 80px; height: 80px;">
                                        <span class="fs-2 fw-bold text-primary">${user.firstName?substring(0,1)}${user.lastName?substring(0,1)}</span>
                                    </div>
                                    <h5 class="fw-bold mb-1">${user.firstName} ${user.lastName}</h5>
                                    <p class="text-muted small mb-3">${user.email}</p>
                                    <span class="badge bg-primary">Клієнт</span>
                                </div>
                            </div>

                            <div class="card border-0 shadow-sm mt-3">
                                <div class="card-body p-4">
                                    <h6 class="fw-semibold mb-3">Дії</h6>
                                    <div class="d-grid gap-2">
                                        <a href="/logout" class="btn btn-outline-danger">
                                            <i class="bi bi-box-arrow-right me-2"></i> Вийти з системи
                                        </a>
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
    <script src="/static/js/main.js"></script>
</body>
</html>
