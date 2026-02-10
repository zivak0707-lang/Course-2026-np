<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Управління користувачами - PayFlow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
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
                <a href="/admin/users" class="nav-link active"><i class="bi bi-people"></i> Користувачі</a>
                <a href="/admin/transactions" class="nav-link"><i class="bi bi-list-ul"></i> Транзакції</a>
                <a href="/admin/reports" class="nav-link"><i class="bi bi-graph-up"></i> Звіти</a>
                <a href="/admin/settings" class="nav-link"><i class="bi bi-gear"></i> Налаштування</a>
            </nav>
            <div class="p-3 border-top border-secondary"><a href="/logout" class="nav-link"><i class="bi bi-box-arrow-right"></i> Вийти</a></div>
        </aside>
        
        <div class="main-content">
            <header class="bg-white border-bottom p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="h4 fw-bold mb-0">Управління користувачами</h1>
                    <button class="btn btn-primary"><i class="bi bi-plus-lg me-2"></i> Додати користувача</button>
                </div>
            </header>
            
            <main class="p-4">
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6"><input type="text" class="form-control" placeholder="Пошук за іменем або email..."></div>
                            <div class="col-md-3">
                                <select class="form-select">
                                    <option value="">Всі ролі</option>
                                    <option value="CLIENT">Клієнт</option>
                                    <option value="ADMIN">Адміністратор</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select">
                                    <option value="">Всі статуси</option>
                                    <option value="ACTIVE">Активні</option>
                                    <option value="INACTIVE">Неактивні</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Ім'я</th>
                                    <th>Email</th>
                                    <th>Роль</th>
                                    <th>Статус</th>
                                    <th>Реєстрація</th>
                                    <th>Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>USR-001</td>
                                    <td>Іван Іваненко</td>
                                    <td>ivan@example.com</td>
                                    <td><span class="badge badge-primary">Клієнт</span></td>
                                    <td><span class="badge badge-success">Активний</span></td>
                                    <td class="text-muted small">15.01.2024</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-outline-warning"><i class="bi bi-lock"></i></button>
                                        <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>USR-002</td>
                                    <td>Марія Петренко</td>
                                    <td>maria@example.com</td>
                                    <td><span class="badge badge-primary">Клієнт</span></td>
                                    <td><span class="badge badge-success">Активний</span></td>
                                    <td class="text-muted small">20.02.2024</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-outline-warning"><i class="bi bi-lock"></i></button>
                                        <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>USR-003</td>
                                    <td>Олег Коваленко</td>
                                    <td>oleg@example.com</td>
                                    <td><span class="badge badge-danger">Адмін</span></td>
                                    <td><span class="badge badge-success">Активний</span></td>
                                    <td class="text-muted small">05.11.2023</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></button>
                                        <button class="btn btn-sm btn-outline-warning"><i class="bi bi-lock"></i></button>
                                        <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/main.js"></script>
</body>
</html>
