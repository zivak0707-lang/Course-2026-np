<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Здійснити платіж - PayFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
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
                <a href="/dashboard" class="nav-link"><i class="bi bi-grid-fill"></i> Дашборд</a>
                <a href="/dashboard/accounts" class="nav-link"><i class="bi bi-wallet2"></i> Мої рахунки</a>
                <a href="/dashboard/cards" class="nav-link"><i class="bi bi-credit-card"></i> Мої картки</a>
                <a href="/dashboard/payment" class="nav-link active"><i class="bi bi-send"></i> Здійснити платіж</a>
                <a href="/dashboard/transactions" class="nav-link"><i class="bi bi-list-ul"></i> Історія транзакцій</a>
                <a href="/dashboard/settings" class="nav-link"><i class="bi bi-gear"></i> Налаштування</a>
            </nav>
            <div class="p-3 border-top"><a href="/logout" class="nav-link text-muted"><i class="bi bi-box-arrow-right"></i> Вийти</a></div>
        </aside>
        
        <div class="main-content">
            <header class="bg-white border-bottom p-4">
                <button class="btn btn-link d-lg-none" onclick="toggleSidebar()"><i class="bi bi-list fs-3"></i></button>
            </header>
            
            <main class="p-4">
                <h1 class="h3 fw-bold mb-4">Здійснити платіж</h1>
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-body p-4">
                                <form action="/dashboard/payment/submit" method="POST">
                                    <div class="mb-3">
                                        <label class="form-label">Рахунок *</label>
                                        <label>
                                            <select class="form-select" name="accountId" required>
                                                <option value="">Оберіть рахунок</option>
                                                <option value="1">**** 1234 ($12,450.00)</option>
                                                <option value="2">**** 5678 ($34,200.50)</option>
                                            </select>
                                        </label>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Одержувач *</label>
                                        <label>
                                            <input type="text" class="form-control" name="recipient" placeholder="Ім'я або номер рахунку" required>
                                        </label>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Сума *</label>
                                        <div class="input-group input-group-lg">
                                            <span class="input-group-text">$</span>
                                            <label>
                                                <input type="number" class="form-control" name="amount" placeholder="0.00" step="0.01" min="0.01" required>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Тип платежу *</label>
                                        <label>
                                            <select class="form-select" name="type" required>
                                                <option value="PAYMENT">Платіж</option>
                                                <option value="REPLENISHMENT">Поповнення</option>
                                            </select>
                                        </label>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Опис</label>
                                        <label>
                                            <textarea class="form-control" name="description" rows="3" placeholder="Призначення платежу"></textarea>
                                        </label>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-lg w-100"><i class="bi bi-send me-2"></i> Здійснити платіж</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="fw-semibold mb-3">Підсумок</h6>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Сума:</span>
                                    <span class="fw-medium">$0.00</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Комісія:</span>
                                    <span class="fw-medium">$0.00</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between">
                                    <span class="fw-semibold">До сплати:</span>
                                    <span class="fw-bold fs-5 text-primary">$0.00</span>
                                </div>
                            </div>
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
