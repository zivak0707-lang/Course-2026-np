<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Всі транзакції - PayFlow Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="//css/style.css" rel="stylesheet">
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
                <a href="/admin" class="nav-link"><i class="bi bi-grid-fill"></i> Дашборд</a>
                <a href="/admin/users" class="nav-link"><i class="bi bi-people"></i> Користувачі</a>
                <a href="/admin/transactions" class="nav-link active"><i class="bi bi-list-ul"></i> Транзакції</a>
                <a href="/admin/reports" class="nav-link"><i class="bi bi-graph-up"></i> Звіти</a>
                <a href="/admin/settings" class="nav-link"><i class="bi bi-gear"></i> Налаштування</a>
            </nav>
            <div class="p-3 border-top border-secondary"><a href="/logout" class="nav-link"><i class="bi bi-box-arrow-right"></i> Вийти</a></div>
        </aside>
        
        <div class="main-content">
            <header class="bg-white border-bottom p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="h4 fw-bold mb-0">Всі транзакції</h1>
                    <button class="btn btn-outline-primary"><i class="bi bi-download me-2"></i> Експорт</button>
                </div>
            </header>
            
            <main class="p-4">
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3"><input type="text" class="form-control" placeholder="Пошук..."></div>
                            <div class="col-md-2">
                                <select class="form-select"><option>Всі типи</option><option>Платіж</option><option>Поповнення</option></select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select"><option>Всі статуси</option><option>Виконано</option><option>Очікує</option><option>Невдало</option></select>
                            </div>
                            <div class="col-md-2"><input type="date" class="form-control"></div>
                            <div class="col-md-2"><input type="date" class="form-control"></div>
                            <div class="col-md-1"><button class="btn btn-primary w-100">Фільтр</button></div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Дата/Час</th>
                                    <th>Користувач</th>
                                    <th>Опис</th>
                                    <th>Тип</th>
                                    <th class="text-end">Сума</th>
                                    <th>Статус</th>
                                    <th>Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-muted small">TXN-001</td>
                                    <td class="text-muted small">09.02.2026 10:30</td>
                                    <td>Іван Іваненко</td>
                                    <td>Оплата електроенергії</td>
                                    <td><span class="badge badge-secondary">Платіж</span></td>
                                    <td class="text-end text-danger fw-semibold">-$250.00</td>
                                    <td><span class="badge badge-success">Виконано</span></td>
                                    <td><button class="btn btn-sm btn-link">Деталі</button></td>
                                </tr>
                                <tr>
                                    <td class="text-muted small">TXN-002</td>
                                    <td class="text-muted small">08.02.2026 14:15</td>
                                    <td>Марія Петренко</td>
                                    <td>Зарплата</td>
                                    <td><span class="badge badge-primary">Поповнення</span></td>
                                    <td class="text-end text-success fw-semibold">+$3,500.00</td>
                                    <td><span class="badge badge-success">Виконано</span></td>
                                    <td><button class="btn btn-sm btn-link">Деталі</button></td>
                                </tr>
                                <tr>
                                    <td class="text-muted small">TXN-003</td>
                                    <td class="text-muted small">07.02.2026 09:00</td>
                                    <td>Олег Коваленко</td>
                                    <td>Netflix</td>
                                    <td><span class="badge badge-secondary">Платіж</span></td>
                                    <td class="text-end text-danger fw-semibold">-$89.99</td>
                                    <td><span class="badge badge-warning">Очікує</span></td>
                                    <td><button class="btn btn-sm btn-link">Деталі</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer bg-white">
                        <nav><ul class="pagination mb-0 justify-content-center">
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
                            <li class="page-item active"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                        </ul></nav>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/main.js"></script>
</body>
</html>
