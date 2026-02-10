<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Дашборд - PayFlow</title>
    
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
                <a href="/dashboard" class="nav-link active">
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

                    <!-- User Menu -->
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

            <!-- Dashboard Content -->
            <main class="p-3 p-lg-4">
                <div class="animate-fade-in">
                    <!-- Welcome Message -->
                    <div class="mb-4">
                        <h1 class="h3 fw-bold mb-1">Вітаємо, ${user.firstName}! 👋</h1>
                        <p class="text-muted mb-0">Ось огляд ваших фінансів.</p>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6 col-lg-3">
                            <div class="stat-card">
                                <div class="stat-card-icon">
                                    <i class="bi bi-wallet2 fs-4"></i>
                                </div>
                                <div class="stat-card-label">Загальний баланс</div>
                                <div class="stat-card-value">${totalBalance}</div>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-3">
                            <div class="stat-card">
                                <div class="stat-card-icon" style="background-color: rgba(16, 185, 129, 0.1); color: #10b981;">
                                    <i class="bi bi-credit-card fs-4"></i>
                                </div>
                                <div class="stat-card-label">Активні картки</div>
                                <div class="stat-card-value">${activeCards}</div>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-3">
                            <div class="stat-card">
                                <div class="stat-card-icon" style="background-color: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                                    <i class="bi bi-clock fs-4"></i>
                                </div>
                                <div class="stat-card-label">В очікуванні</div>
                                <div class="stat-card-value">${pendingCount}</div>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-3">
                            <div class="stat-card">
                                <div class="stat-card-icon" style="background-color: rgba(239, 68, 68, 0.1); color: #ef4444;">
                                    <i class="bi bi-graph-down fs-4"></i>
                                </div>
                                <div class="stat-card-label">Витрати за місяць</div>
                                <div class="stat-card-value">${monthlySpending}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="mb-4">
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="/dashboard/cards" class="btn btn-primary">
                                <i class="bi bi-plus-lg me-2"></i> Додати картку
                            </a>
                            <a href="/dashboard/payment" class="btn btn-outline-primary">
                                <i class="bi bi-send me-2"></i> Здійснити платіж
                            </a>
                        </div>
                    </div>

                    <!-- Recent Transactions -->
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                            <h5 class="mb-0 fw-semibold">Останні транзакції</h5>
                            <a href="/dashboard/transactions" class="btn btn-sm btn-link text-primary text-decoration-none">
                                Переглянути всі <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Дата</th>
                                            <th>Опис</th>
                                            <th>Тип</th>
                                            <th class="text-end">Сума</th>
                                            <th>Статус</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <#list recentTransactions as transaction>
                                        <tr>
                                            <td class="text-muted small">${transaction.createdAt?string('dd.MM.yyyy HH:mm')}</td>
                                            <td class="fw-medium">${transaction.description}</td>
                                            <td>
                                                <#if transaction.type == 'REPLENISHMENT'>
                                                    <span class="badge badge-primary">Поповнення</span>
                                                <#else>
                                                    <span class="badge badge-secondary">Платіж</span>
                                                </#if>
                                            </td>
                                            <td class="text-end fw-semibold <#if transaction.amount gt 0>text-success<#else>text-danger</#if>">
                                                <#if transaction.amount gt 0>+</#if>${transaction.amount?string.currency}
                                            </td>
                                            <td>
                                                <#switch transaction.status>
                                                    <#case 'COMPLETED'>
                                                        <span class="badge badge-success">Виконано</span>
                                                        <#break>
                                                    <#case 'PENDING'>
                                                        <span class="badge badge-warning">В очікуванні</span>
                                                        <#break>
                                                    <#case 'FAILED'>
                                                        <span class="badge badge-danger">Невдало</span>
                                                        <#break>
                                                </#switch>
                                            </td>
                                        </tr>
                                        </#list>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999" id="toast-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/main.js"></script>
</body>
</html>
