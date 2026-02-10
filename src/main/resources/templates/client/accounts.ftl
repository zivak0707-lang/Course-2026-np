<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мої рахунки - PayFlow</title>
    
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
                                <span class="fw-semibold text-primary">JD</span>
                            </div>
                            <span class="fw-medium d-none d-sm-inline">John Doe</span>
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
                    <!-- Header -->
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3 mb-4">
                        <div>
                            <h1 class="h3 fw-bold mb-1">Мої рахунки</h1>
                            <p class="text-muted mb-0">Керуйте своїми банківськими рахунками</p>
                        </div>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                            <i class="bi bi-plus-lg me-2"></i> Додати рахунок
                        </button>
                    </div>

                    <!-- Accounts Grid -->
                    <div class="row g-4">
                        <#if accounts?has_content>
                            <#list accounts as account>
                            <div class="col-md-6 col-lg-4">
                                <div class="account-card">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge badge-secondary">Поточний</span>
                                        <#if account.status == 'ACTIVE'>
                                            <span class="badge badge-success">Активний</span>
                                        <#else>
                                            <span class="badge badge-danger">Заблокований</span>
                                        </#if>
                                    </div>

                                    <p class="account-number mb-2">****${account.accountNumber?substring(account.accountNumber?length - 4)}</p>
                                    <p class="account-balance mb-4">${account.balance?string.currency}</p>

                                    <button class="btn btn-outline-primary w-100">
                                        Деталі рахунку
                                    </button>
                                </div>
                            </div>
                            </#list>
                        <#else>
                            <div class="col-12">
                                <div class="card border-0 bg-light text-center py-5">
                                    <div class="card-body">
                                        <i class="bi bi-wallet2 text-muted" style="font-size: 4rem;"></i>
                                        <h5 class="mt-3 mb-2">Рахунків не знайдено</h5>
                                        <p class="text-muted mb-3">Додайте свій перший рахунок</p>
                                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                                            <i class="bi bi-plus-lg me-2"></i> Додати рахунок
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </#if>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add Account Modal -->
    <div class="modal fade" id="addAccountModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-semibold">Додати новий рахунок</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="/dashboard/accounts/add" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="accountType" class="form-label">Тип рахунку</label>
                            <select class="form-select" id="accountType" name="accountType" required>
                                <option value="">Оберіть тип...</option>
                                <option value="Checking">Поточний</option>
                                <option value="Savings">Ощадний</option>
                                <option value="Business">Бізнес</option>
                            </select>
                        </div>

                        <div class="alert alert-info d-flex align-items-start">
                            <i class="bi bi-info-circle me-2 mt-1"></i>
                            <small>Номер рахунку буде згенеровано автоматично</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Скасувати</button>
                        <button type="submit" class="btn btn-primary">Створити рахунок</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999" id="toast-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/main.js"></script>
</body>
</html>
