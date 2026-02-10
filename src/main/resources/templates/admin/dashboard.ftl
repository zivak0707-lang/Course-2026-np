<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - PayFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
    <div class="d-flex">
        <aside class="sidebar sidebar-admin">
            <div class="p-3 border-bottom border-secondary">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-wallet2 fs-4 text-white"></i>
                    <span class="fs-5 fw-bold text-white">PayFlow Admin</span>
                </div>
            </div>
            <nav class="sidebar-nav p-3">
                <a href="/admin" class="nav-link active"><i class="bi bi-grid-fill"></i> Дашборд</a>
                <a href="/admin/users" class="nav-link"><i class="bi bi-people"></i> Користувачі</a>
                <a href="/admin/transactions" class="nav-link"><i class="bi bi-list-ul"></i> Транзакції</a>
                <a href="/admin/reports" class="nav-link"><i class="bi bi-graph-up"></i> Звіти</a>
                <a href="/admin/settings" class="nav-link"><i class="bi bi-gear"></i> Налаштування</a>
            </nav>
            <div class="p-3 border-top border-secondary"><a href="/logout" class="nav-link"><i class="bi bi-box-arrow-right"></i> Вийти</a></div>
        </aside>
        
        <div class="main-content">
            <header class="bg-white border-bottom p-4">
                <h1 class="h4 fw-bold mb-0">Панель адміністратора</h1>
            </header>
            
            <main class="p-4">
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-card-icon"><i class="bi bi-people fs-4"></i></div>
                            <div class="stat-card-label">Всього користувачів</div>
                            <div class="stat-card-value">1,248</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-card-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;"><i class="bi bi-arrow-repeat fs-4"></i></div>
                            <div class="stat-card-label">Транзакцій сьогодні</div>
                            <div class="stat-card-value">342</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-card-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;"><i class="bi bi-clock fs-4"></i></div>
                            <div class="stat-card-label">Очікують схвалення</div>
                            <div class="stat-card-value">18</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-card-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;"><i class="bi bi-check-circle fs-4"></i></div>
                            <div class="stat-card-label">Здоров'я системи</div>
                            <div class="stat-card-value">99.8%</div>
                        </div>
                    </div>
                </div>
                
                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header bg-white"><h6 class="mb-0 fw-semibold">Обсяг транзакцій</h6></div>
                            <div class="card-body"><canvas id="transactionVolumeChart" height="80"></canvas></div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-header bg-white"><h6 class="mb-0 fw-semibold">Розподіл статусів</h6></div>
                            <div class="card-body"><canvas id="statusDistributionChart"></canvas></div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/main.js"></script>
</body>
</html>
