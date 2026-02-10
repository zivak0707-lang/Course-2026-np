<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Історія транзакцій - PayFlow</title>
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
                <a href="/dashboard/payment" class="nav-link"><i class="bi bi-send"></i> Здійснити платіж</a>
                <a href="/dashboard/transactions" class="nav-link active"><i class="bi bi-list-ul"></i> Історія транзакцій</a>
                <a href="/dashboard/settings" class="nav-link"><i class="bi bi-gear"></i> Налаштування</a>
            </nav>
            <div class="p-3 border-top"><a href="/logout" class="nav-link text-muted"><i class="bi bi-box-arrow-right"></i> Вийти</a></div>
        </aside>
        
        <div class="main-content">
            <header class="bg-white border-bottom p-4">
                <button class="btn btn-link d-lg-none" onclick="toggleSidebar()"><i class="bi bi-list fs-3"></i></button>
            </header>
            
            <main class="p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h3 fw-bold mb-0">Історія транзакцій</h1>
                    <button class="btn btn-outline-primary btn-sm"><i class="bi bi-download me-2"></i> Експорт CSV</button>
                </div>
                
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label>
                                    <input type="text" class="form-control" placeholder="Пошук...">
                                </label>
                            </div>
                            <div class="col-md-3">
                                <label>
                                    <select class="form-select">
                                        <option value="">Всі типи</option>
                                        <option value="payment">Платіж</option>
                                        <option value="replenishment">Поповнення</option>
                                    </select>
                                </label>
                            </div>
                            <div class="col-md-3">
                                <label>
                                    <select class="form-select">
                                        <option value="">Всі статуси</option>
                                        <option value="completed">Виконано</option>
                                        <option value="pending">В очікуванні</option>
                                        <option value="failed">Невдало</option>
                                    </select>
                                </label>
                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-primary w-100">Фільтр</button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Дата</th>
                                    <th>Опис</th>
                                    <th>Тип</th>
                                    <th class="text-end">Сума</th>
                                    <th>Статус</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-muted small">09.02.2026 10:30</td>
                                    <td>Оплата електроенергії</td>
                                    <td><span class="badge badge-secondary">Платіж</span></td>
                                    <td class="text-end text-danger fw-semibold">-$250.00</td>
                                    <td><span class="badge badge-success">Виконано</span></td>
                                    <td><button class="btn btn-sm btn-link">Деталі</button></td>
                                </tr>
                                <tr>
                                    <td class="text-muted small">08.02.2026 14:15</td>
                                    <td>Зарахування зарплати</td>
                                    <td><span class="badge badge-primary">Поповнення</span></td>
                                    <td class="text-end text-success fw-semibold">+$3,500.00</td>
                                    <td><span class="badge badge-success">Виконано</span></td>
                                    <td><button class="btn btn-sm btn-link">Деталі</button></td>
                                </tr>
                                <tr>
                                    <td class="text-muted small">07.02.2026 09:00</td>
                                    <td>Netflix підписка</td>
                                    <td><span class="badge badge-secondary">Платіж</span></td>
                                    <td class="text-end text-danger fw-semibold">-$89.99</td>
                                    <td><span class="badge badge-warning">В очікуванні</span></td>
                                    <td><button class="btn btn-sm btn-link">Деталі</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer bg-white">
                        <nav>
                            <ul class="pagination mb-0 justify-content-center">
                                <li class="page-item disabled"><a class="page-link" href="#">Назад</a></li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link" href="#">Вперед</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/main.js"></script>
</body>
</html>
