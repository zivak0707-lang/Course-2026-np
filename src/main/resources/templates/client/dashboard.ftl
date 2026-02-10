<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - PayFlow</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex" style="min-height: 100vh;">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="p-3 border-bottom">
                <!-- PayFlow лого БЕЗ посилання на головну — просто для вигляду -->
                <div class="d-flex align-items-center gap-2" style="cursor: default; user-select: none;">
                    <i class="bi bi-wallet2 fs-4 text-primary"></i>
                    <span class="fs-5 fw-bold text-primary">PayFlow</span>
                </div>
            </div>

            <nav class="sidebar-nav p-3">
                <a href="/dashboard" class="nav-link active">
                    <i class="bi bi-grid-fill"></i>
                    <span>Dashboard</span>
                </a>
                <a href="/dashboard/accounts" class="nav-link">
                    <i class="bi bi-wallet2"></i>
                    <span>My Accounts</span>
                </a>
                <a href="/dashboard/cards" class="nav-link">
                    <i class="bi bi-credit-card"></i>
                    <span>My Cards</span>
                </a>
                <a href="/dashboard/payment" class="nav-link">
                    <i class="bi bi-send"></i>
                    <span>Make Payment</span>
                </a>
                <a href="/dashboard/transactions" class="nav-link">
                    <i class="bi bi-list-ul"></i>
                    <span>Transactions</span>
                </a>
                <a href="/dashboard/settings" class="nav-link">
                    <i class="bi bi-gear"></i>
                    <span>Settings</span>
                </a>
            </nav>

            <div class="p-3 border-top mt-auto">
                <a href="/logout" class="nav-link text-muted">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="main-content" style="flex: 1; min-width: 0; width: calc(100% - 210px);">
            <!-- Top Bar -->
            <header class="bg-white border-bottom sticky-top">
                <div class="d-flex align-items-center justify-content-between px-4" style="height: 56px;">
                    <button class="btn btn-link d-lg-none p-0 text-dark" onclick="toggleSidebar()">
                        <i class="bi bi-list fs-5"></i>
                    </button>

                    <div class="flex-grow-1"></div>

                    <!-- Динамічні ініціали та повне ім'я з БД -->
                    <div class="dropdown">
                        <button class="btn btn-link text-dark text-decoration-none dropdown-toggle d-flex align-items-center gap-2 p-0"
                                type="button" data-bs-toggle="dropdown">
                            <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center"
                                 style="width: 34px; height: 34px;">
                                <span class="fw-semibold text-primary" style="font-size: 0.75rem;">
                                    ${user.firstName?substring(0,1)?upper_case}${user.lastName?substring(0,1)?upper_case}
                                </span>
                            </div>
                            <span class="fw-medium d-none d-sm-inline" style="font-size: 0.9rem;">${user.firstName} ${user.lastName}</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-person me-2"></i> Profile</a></li>
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-gear me-2"></i> Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <main class="p-4">
                <div class="animate-fade-in">
                    <!-- Welcome Message з іменем з БД -->
                    <div class="mb-3">
                        <h1 class="fw-bold mb-1" style="font-size: 1.5rem;">Welcome back, ${user.firstName}! 👋</h1>
                        <p class="text-muted mb-0" style="font-size: 0.875rem;">Here's an overview of your finances.</p>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row g-3 mb-3">
                        <div class="col-6 col-lg-3">
                            <div class="stat-card" style="padding: 1.25rem 1.5rem;">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="stat-card-label" style="font-size: 0.8rem;">Total Balance</div>
                                    <div class="stat-card-icon" style="width:2.25rem;height:2.25rem;border-radius:10px;background-color:rgba(37,99,235,0.1);color:#2563eb;display:flex;align-items:center;justify-content:center;">
                                        <i class="bi bi-currency-dollar"></i>
                                    </div>
                                </div>
                                <div class="fw-bold" style="font-size:1.6rem;color:#1e293b;line-height:1.2;">${totalBalance}</div>
                            </div>
                        </div>

                        <div class="col-6 col-lg-3">
                            <div class="stat-card" style="padding: 1.25rem 1.5rem;">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="stat-card-label" style="font-size: 0.8rem;">Active Cards</div>
                                    <div class="stat-card-icon" style="width:2.25rem;height:2.25rem;border-radius:10px;background-color:rgba(16,185,129,0.1);color:#10b981;display:flex;align-items:center;justify-content:center;">
                                        <i class="bi bi-credit-card"></i>
                                    </div>
                                </div>
                                <div class="fw-bold" style="font-size:1.6rem;color:#1e293b;line-height:1.2;">${activeCards}</div>
                            </div>
                        </div>

                        <div class="col-6 col-lg-3">
                            <div class="stat-card" style="padding: 1.25rem 1.5rem;">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="stat-card-label" style="font-size: 0.8rem;">Pending</div>
                                    <div class="stat-card-icon" style="width:2.25rem;height:2.25rem;border-radius:10px;background-color:rgba(245,158,11,0.1);color:#f59e0b;display:flex;align-items:center;justify-content:center;">
                                        <i class="bi bi-clock"></i>
                                    </div>
                                </div>
                                <div class="fw-bold" style="font-size:1.6rem;color:#1e293b;line-height:1.2;">${pendingCount}</div>
                            </div>
                        </div>

                        <div class="col-6 col-lg-3">
                            <div class="stat-card" style="padding: 1.25rem 1.5rem;">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="stat-card-label" style="font-size: 0.8rem;">Monthly Spending</div>
                                    <div class="stat-card-icon" style="width:2.25rem;height:2.25rem;border-radius:10px;background-color:rgba(139,92,246,0.1);color:#8b5cf6;display:flex;align-items:center;justify-content:center;">
                                        <i class="bi bi-graph-down"></i>
                                    </div>
                                </div>
                                <div class="fw-bold" style="font-size:1.6rem;color:#1e293b;line-height:1.2;">${monthlySpending}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="mb-3">
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="/dashboard/cards" class="btn btn-primary btn-sm px-3">
                                <i class="bi bi-plus-lg me-1"></i> Add Card
                            </a>
                            <a href="/dashboard/payment" class="btn btn-outline-secondary btn-sm px-3">
                                <i class="bi bi-send me-1"></i> Make Payment
                            </a>
                        </div>
                    </div>

                    <!-- Recent Transactions -->
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                            <h5 class="mb-0 fw-semibold">Recent Transactions</h5>
                            <a href="/dashboard/transactions" class="text-primary text-decoration-none fw-medium">
                                View all
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table mb-0">
                                    <thead>
                                        <tr>
                                            <th class="border-0 text-muted fw-normal small ps-4">Date</th>
                                            <th class="border-0 text-muted fw-normal small">Description</th>
                                            <th class="border-0 text-muted fw-normal small">Type</th>
                                            <th class="border-0 text-muted fw-normal small text-end">Amount</th>
                                            <th class="border-0 text-muted fw-normal small pe-4">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <#if recentTransactions?? && recentTransactions?size gt 0>
                                            <#list recentTransactions as transaction>
                                            <tr>
                                                <td class="ps-4 small text-muted">
                                                    ${transaction.createdAt.toString()?substring(0, 10)}
                                                </td>
                                                <td class="fw-medium">
                                                    <#if transaction.description?? && transaction.description?has_content>
                                                        ${transaction.description}
                                                    <#else>
                                                        —
                                                    </#if>
                                                </td>
                                                <td>
                                                    <#if transaction.type?string == 'REPLENISHMENT'>
                                                        <span class="badge" style="background-color: #dbeafe; color: #1e40af; border-radius: 6px; padding: 4px 10px; font-weight: 500;">Replenishment</span>
                                                    <#else>
                                                        <span class="badge" style="background-color: #f1f5f9; color: #475569; border-radius: 6px; padding: 4px 10px; font-weight: 500;">Payment</span>
                                                    </#if>
                                                </td>
                                                <td class="text-end fw-semibold">
                                                    <#if transaction.type?string == 'REPLENISHMENT'>
                                                        <span class="text-success">+$${transaction.amount?string("0.00")}</span>
                                                    <#else>
                                                        <span class="text-danger">-$${transaction.amount?string("0.00")}</span>
                                                    </#if>
                                                </td>
                                                <td class="pe-4">
                                                    <#if transaction.status?string == 'COMPLETED'>
                                                        <span class="badge" style="background-color: #d1fae5; color: #065f46; border-radius: 6px; padding: 4px 10px; font-weight: 500;">Completed</span>
                                                    <#elseif transaction.status?string == 'PENDING'>
                                                        <span class="badge" style="background-color: #fef3c7; color: #92400e; border-radius: 6px; padding: 4px 10px; font-weight: 500;">Pending</span>
                                                    <#elseif transaction.status?string == 'FAILED'>
                                                        <span class="badge" style="background-color: #fee2e2; color: #991b1b; border-radius: 6px; padding: 4px 10px; font-weight: 500;">Failed</span>
                                                    </#if>
                                                </td>
                                            </tr>
                                            </#list>
                                        <#else>
                                            <tr>
                                                <td colspan="5" class="text-center py-5 text-muted">
                                                    <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                                    No recent transactions
                                                </td>
                                            </tr>
                                        </#if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999" id="toast-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSidebar() {
            document.querySelector('.sidebar').classList.toggle('show');
        }
    </script>
</body>
</html>
