<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Додати картку - PayFlow</title>
    
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
                <a href="/dashboard/cards" class="nav-link active">
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
                            <li><a class="dropdown-item text-danger" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Вийти</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="p-3 p-lg-4">
                <div class="animate-fade-in">
                    <!-- Header -->
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <a href="/dashboard/cards" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-arrow-left me-2"></i> Назад до карток
                        </a>
                        <div>
                            <h1 class="h3 fw-bold mb-1">Додати нову картку</h1>
                            <p class="text-muted mb-0">Введіть дані вашої кредитної картки</p>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-8">
                            <!-- Card Form -->
                            <div class="card border-0 shadow-sm">
                                <div class="card-body p-4">
                                    <form action="/dashboard/cards/add" method="POST" id="addCardForm">
                                        <div class="mb-4">
                                            <label for="cardNumber" class="form-label fw-semibold">Номер картки *</label>
                                            <input type="text" class="form-control form-control-lg" id="cardNumber" name="cardNumber" 
                                                   placeholder="1234 5678 9012 3456" maxlength="19" required>
                                            <small class="text-muted">Введіть 16-значний номер картки</small>
                                        </div>

                                        <div class="mb-4">
                                            <label for="cardholderName" class="form-label fw-semibold">Ім'я власника картки *</label>
                                            <input type="text" class="form-control form-control-lg" id="cardholderName" name="cardholderName" 
                                                   placeholder="IVAN PETRENKO" style="text-transform: uppercase;" required>
                                            <small class="text-muted">Як вказано на картці (великими літерами)</small>
                                        </div>

                                        <div class="row g-3 mb-4">
                                            <div class="col-md-6">
                                                <label for="expiryDate" class="form-label fw-semibold">Термін дії *</label>
                                                <input type="text" class="form-control form-control-lg" id="expiryDate" name="expiryDate" 
                                                       placeholder="MM/YY" maxlength="5" required>
                                                <small class="text-muted">Місяць/Рік (наприклад: 12/25)</small>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="cvv" class="form-label fw-semibold">CVV код *</label>
                                                <input type="text" class="form-control form-control-lg" id="cvv" name="cvv" 
                                                       placeholder="123" maxlength="3" required>
                                                <small class="text-muted">3 цифри на звороті картки</small>
                                            </div>
                                        </div>

                                        <div class="alert alert-info d-flex align-items-start mb-4">
                                            <i class="bi bi-shield-check fs-4 me-3"></i>
                                            <div>
                                                <strong>Безпека даних</strong>
                                                <p class="mb-0 small">Всі дані вашої картки захищені за допомогою 256-бітного шифрування. 
                                                Ми не зберігаємо CVV код.</p>
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary btn-lg px-5">
                                                <i class="bi bi-plus-lg me-2"></i> Додати картку
                                            </button>
                                            <a href="/dashboard/cards" class="btn btn-outline-secondary btn-lg px-4">
                                                Скасувати
                                            </a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <!-- Card Preview -->
                            <div class="card border-0 shadow-sm sticky-top" style="top: 1rem;">
                                <div class="card-header bg-white py-3">
                                    <h6 class="mb-0 fw-semibold">Попередній перегляд</h6>
                                </div>
                                <div class="card-body p-4">
                                    <div class="credit-card credit-card-visa" style="height: 200px; transform: none;">
                                        <div class="d-flex justify-content-between align-items-start mb-4">
                                            <span class="badge bg-white bg-opacity-20 text-white">VISA</span>
                                            <div style="width: 50px; height: 35px; background: rgba(255,255,255,0.2); border-radius: 4px;"></div>
                                        </div>
                                        <p class="card-number mb-4" id="previewCardNumber">•••• •••• •••• ••••</p>
                                        <div class="d-flex justify-content-between align-items-end">
                                            <div>
                                                <p class="text-white-50 small mb-1" style="font-size: 0.7rem;">CARDHOLDER</p>
                                                <p class="mb-0 fw-semibold" id="previewCardHolder">YOUR NAME</p>
                                            </div>
                                            <div class="text-end">
                                                <p class="text-white-50 small mb-1" style="font-size: 0.7rem;">EXPIRES</p>
                                                <p class="mb-0 fw-semibold" id="previewExpiry">MM/YY</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mt-3">
                                        <small class="text-muted d-block">
                                            <i class="bi bi-info-circle me-1"></i>
                                            Заповнюйте форму зліва, щоб побачити попередній перегляд картки
                                        </small>
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
    <script>
        // Card number formatting
        document.getElementById('cardNumber').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s/g, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
            e.target.value = formattedValue;
            
            // Update preview
            document.getElementById('previewCardNumber').textContent = formattedValue || '•••• •••• •••• ••••';
        });

        // Cardholder name preview
        document.getElementById('cardholderName').addEventListener('input', function(e) {
            document.getElementById('previewCardHolder').textContent = e.target.value.toUpperCase() || 'YOUR NAME';
        });

        // Expiry date formatting
        document.getElementById('expiryDate').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.slice(0, 2) + '/' + value.slice(2, 4);
            }
            e.target.value = value;
            
            // Update preview
            document.getElementById('previewExpiry').textContent = value || 'MM/YY';
        });

        // CVV - only numbers
        document.getElementById('cvv').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/\D/g, '').slice(0, 3);
        });
    </script>
</body>
</html>
