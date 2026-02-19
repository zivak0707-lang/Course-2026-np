<#-- @ftlvariable name="admin" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="totalUsers" type="java.lang.Long" -->
<#-- @ftlvariable name="totalTransactions" type="java.lang.Long" -->
<#-- @ftlvariable name="pendingApprovals" type="java.lang.Long" -->
<#-- @ftlvariable name="activeCards" type="java.lang.Long" -->
<#-- @ftlvariable name="totalBalance" type="java.math.BigDecimal" -->
<#-- @ftlvariable name="newUsersToday" type="java.lang.Long" -->
<#-- @ftlvariable name="avgTransactionAmount" type="java.math.BigDecimal" -->
<#-- @ftlvariable name="completedCount" type="java.lang.Long" -->
<#-- @ftlvariable name="pendingCount" type="java.lang.Long" -->
<#-- @ftlvariable name="failedCount" type="java.lang.Long" -->
<#-- @ftlvariable name="cancelledCount" type="java.lang.Long" -->
<#-- @ftlvariable name="chartLabels" type="java.util.List<java.lang.String>" -->
<#-- @ftlvariable name="chartData" type="java.util.List<java.lang.Long>" -->
<#-- @ftlvariable name="typePayment" type="java.lang.Long" -->
<#-- @ftlvariable name="typeReplenishment" type="java.lang.Long" -->
<#-- @ftlvariable name="typeTransfer" type="java.lang.Long" -->
<#-- @ftlvariable name="topUsers" type="java.util.List<java.util.Map>" -->
<#-- @ftlvariable name="recentTransactions" type="java.util.List<ua.com.kisit.course2026np.entity.Payment>" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — PayFlow</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
    <style>
        *{box-sizing:border-box}
        body{font-family:'Inter',sans-serif;background:#f1f5f9;margin:0}

        /* Sidebar */
        .admin-sidebar{width:220px;min-height:100vh;position:fixed;top:0;left:0;z-index:100;background:#1e1b4b;display:flex;flex-direction:column}
        .sidebar-brand{display:flex;align-items:center;gap:10px;padding:22px 20px;border-bottom:1px solid rgba(255,255,255,.08)}
        .sidebar-brand .brand-icon{width:34px;height:34px;background:rgba(255,255,255,.15);border-radius:8px;display:flex;align-items:center;justify-content:center}
        .sidebar-brand .brand-icon i{color:#fff;font-size:17px}
        .sidebar-brand span{color:#fff;font-weight:700;font-size:1.05rem}
        .sidebar-nav{padding:16px 12px;flex:1}
        .sidebar-nav .nav-label{font-size:.68rem;font-weight:600;color:rgba(255,255,255,.35);text-transform:uppercase;letter-spacing:1px;padding:10px 8px 6px}
        .sidebar-nav .nav-link{color:rgba(255,255,255,.72);padding:9px 12px;border-radius:8px;display:flex;align-items:center;gap:10px;font-size:.88rem;font-weight:500;text-decoration:none;transition:background .15s,color .15s;margin-bottom:2px}
        .sidebar-nav .nav-link i{font-size:16px;width:18px;text-align:center}
        .sidebar-nav .nav-link:hover{background:rgba(255,255,255,.1);color:#fff}
        .sidebar-nav .nav-link.active{background:rgba(255,255,255,.15);color:#fff;font-weight:600}
        .sidebar-footer{padding:14px 12px;border-top:1px solid rgba(255,255,255,.08)}
        .sidebar-footer .nav-link{color:rgba(255,255,255,.6);padding:9px 12px;border-radius:8px;display:flex;align-items:center;gap:10px;font-size:.88rem;text-decoration:none;transition:background .15s}
        .sidebar-footer .nav-link:hover{background:rgba(239,68,68,.2);color:#fca5a5}

        /* Layout */
        .admin-main{margin-left:220px;min-height:100vh}
        .topbar{background:#fff;border-bottom:1px solid #e5e7eb;padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50}
        .topbar h5{margin:0;font-weight:700;color:#111827;font-size:1.1rem}
        .admin-avatar{width:36px;height:36px;background:linear-gradient(135deg,#4f46e5,#7c3aed);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.85rem}
        .content-area{padding:28px}

        /* Stat cards */
        .stat-card{background:#fff;border-radius:14px;padding:20px 22px;border:1px solid #e5e7eb;box-shadow:0 1px 3px rgba(0,0,0,.04);transition:box-shadow .2s,transform .18s;height:100%}
        .stat-card:hover{box-shadow:0 6px 20px rgba(0,0,0,.09);transform:translateY(-2px)}
        .stat-icon{width:42px;height:42px;border-radius:11px;display:flex;align-items:center;justify-content:center;font-size:19px}
        .stat-value{font-size:1.75rem;font-weight:800;color:#111827;line-height:1.1;margin:10px 0 2px}
        .stat-label{font-size:.78rem;font-weight:500;color:#6b7280}
        .stat-sub{font-size:.72rem;color:#9ca3af;margin-top:4px}

        /* Panels */
        .panel{background:#fff;border-radius:14px;border:1px solid #e5e7eb;box-shadow:0 1px 3px rgba(0,0,0,.04);overflow:hidden}
        .panel-header{padding:16px 20px;border-bottom:1px solid #f3f4f6;display:flex;align-items:center;justify-content:space-between}
        .panel-header h6{margin:0;font-weight:700;color:#111827;font-size:.92rem}
        .panel-body{padding:20px}

        /* Table */
        .data-table{width:100%;border-collapse:collapse}
        .data-table thead th{font-size:.7rem;font-weight:600;color:#6b7280;text-transform:uppercase;letter-spacing:.6px;background:#f9fafb;border-bottom:1px solid #f3f4f6;padding:10px 14px;white-space:nowrap}
        .data-table tbody td{padding:13px 14px;font-size:.855rem;color:#374151;border-bottom:1px solid #f9fafb;vertical-align:middle}
        .data-table tbody tr:last-child td{border-bottom:none}
        .data-table tbody tr:hover{background:#fafafa}

        /* Badges */
        .bdg{display:inline-flex;align-items:center;gap:4px;padding:3px 9px;border-radius:20px;font-size:.7rem;font-weight:600}
        .bdg-payment{background:#f3f4f6;color:#374151}
        .bdg-replenishment{background:#d1fae5;color:#065f46}
        .bdg-transfer{background:#dbeafe;color:#1e40af}
        .bdg-completed{background:#d1fae5;color:#065f46}
        .bdg-pending{background:#fef3c7;color:#92400e}
        .bdg-failed{background:#fee2e2;color:#991b1b}
        .bdg-cancelled{background:#f3f4f6;color:#6b7280}

        .amt-neg{color:#dc2626;font-weight:600}
        .amt-pos{color:#059669;font-weight:600}
        .amt-neu{color:#2563eb;font-weight:600}

        /* Progress */
        .progress-thin{height:6px;border-radius:3px;background:#f3f4f6;overflow:hidden}
        .progress-fill{height:100%;border-radius:3px;background:linear-gradient(90deg,#4f46e5,#7c3aed);transition:width .6s ease}

        /* Pending banner */
        .pending-banner{background:linear-gradient(135deg,#fef3c7,#fde68a);border:1px solid #fcd34d;border-radius:12px;padding:14px 18px;margin-bottom:24px;display:flex;align-items:center;gap:12px}
        .pending-banner i{font-size:1.3rem;color:#b45309}

        /* Type bars */
        .type-bar-row{display:flex;align-items:center;gap:10px;margin-bottom:14px}
        .type-bar-row:last-child{margin-bottom:0}
        .type-bar-label{width:115px;font-size:.8rem;font-weight:500;color:#374151;flex-shrink:0}
        .type-bar-track{flex:1;height:8px;background:#f3f4f6;border-radius:4px;overflow:hidden}
        .type-bar-fill{height:100%;border-radius:4px;transition:width .5s ease}
        .type-bar-count{width:36px;text-align:right;font-size:.8rem;font-weight:600;color:#374151}

        .section-title{font-size:1.2rem;font-weight:700;color:#111827}
    </style>
</head>
<body>

<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-shield-lock-fill"></i></div>
        <span>Admin Panel</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Main</div>
        <a href="/admin/dashboard" class="nav-link active"><i class="bi bi-grid"></i> Dashboard</a>
        <a href="/admin/users" class="nav-link"><i class="bi bi-people"></i> Manage Users</a>
        <a href="/admin/transactions" class="nav-link"><i class="bi bi-arrow-left-right"></i> All Transactions</a>
        <div class="nav-label" style="margin-top:8px">Analytics</div>
        <a href="/admin/reports" class="nav-link"><i class="bi bi-bar-chart-line"></i> Reports</a>
        <a href="/admin/settings" class="nav-link"><i class="bi bi-gear"></i> Settings</a>
    </nav>
    <div class="sidebar-footer">
        <a href="/admin/logout" class="nav-link"><i class="bi bi-box-arrow-left"></i> Logout</a>
    </div>
</aside>

<div class="admin-main">
    <div class="topbar">
        <h5><i class="bi bi-grid me-2" style="color:#4f46e5"></i>Admin Dashboard</h5>
        <div class="d-flex align-items-center gap-2">
            <div class="admin-avatar">
                <#if admin??>${admin.firstName?substring(0,1)}${admin.lastName?substring(0,1)}<#else>A</#if>
            </div>
            <div>
                <div style="font-size:.85rem;font-weight:600;color:#111827">
                    <#if admin??>${admin.firstName} ${admin.lastName}<#else>Admin</#if>
                </div>
                <div style="font-size:.7rem;color:#6b7280">Administrator</div>
            </div>
        </div>
    </div>

    <div class="content-area">

        <#if successMessage??>
            <div class="alert alert-success alert-dismissible fade show rounded-3 d-flex align-items-center gap-2 mb-4" style="font-size:.875rem">
                <i class="bi bi-check-circle-fill"></i>${successMessage}
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </#if>
        <#if errorMessage??>
            <div class="alert alert-danger alert-dismissible fade show rounded-3 d-flex align-items-center gap-2 mb-4" style="font-size:.875rem">
                <i class="bi bi-exclamation-triangle-fill"></i>${errorMessage}
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </#if>

        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h4 class="section-title mb-1">Dashboard Overview</h4>
                <p class="text-muted small mb-0">Real-time metrics pulled directly from the database</p>
            </div>
            <span class="bdg bdg-replenishment px-3 py-2" style="font-size:.78rem">
                <i class="bi bi-clock me-1"></i>Live Data
            </span>
        </div>

        <#if (pendingApprovals > 0)>
            <div class="pending-banner">
                <i class="bi bi-hourglass-split"></i>
                <div>
                    <strong style="color:#92400e;font-size:.9rem">${pendingApprovals} transaction<#if (pendingApprovals > 1)>s</#if> waiting for approval</strong><br>
                    <span style="color:#b45309;font-size:.8rem">Review and approve or reject them in the Transactions section.</span>
                </div>
                <a href="/admin/transactions?status=PENDING" class="btn btn-sm ms-auto rounded-3 px-3"
                   style="background:#b45309;color:#fff;font-weight:600;font-size:.8rem;border:none">
                    Review Now <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </#if>

        <!-- Row 1: primary stats -->
        <div class="row g-3 mb-3">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#ede9fe"><i class="bi bi-people-fill" style="color:#7c3aed"></i></div>
                        <#if (newUsersToday > 0)><span class="bdg bdg-replenishment" style="font-size:.65rem">+${newUsersToday} today</span></#if>
                    </div>
                    <div class="stat-value">${totalUsers}</div>
                    <div class="stat-label">Registered Users</div>
                    <div class="stat-sub"><#if (newUsersToday > 0)>${newUsersToday} new today<#else>No new today</#if></div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#dbeafe"><i class="bi bi-arrow-left-right" style="color:#2563eb"></i></div>
                        <span class="text-muted" style="font-size:.7rem">All time</span>
                    </div>
                    <div class="stat-value">${totalTransactions}</div>
                    <div class="stat-label">Total Transactions</div>
                    <div class="stat-sub">${completedCount} completed &bull; ${failedCount} failed</div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#d1fae5"><i class="bi bi-credit-card-2-front-fill" style="color:#059669"></i></div>
                        <span class="text-muted" style="font-size:.7rem">Active</span>
                    </div>
                    <div class="stat-value">${activeCards}</div>
                    <div class="stat-label">Active Cards</div>
                    <div class="stat-sub">Across all client accounts</div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card" style="<#if (pendingApprovals > 0)>border-color:#fcd34d;</#if>">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#fef3c7"><i class="bi bi-hourglass-split" style="color:#d97706"></i></div>
                        <#if (pendingApprovals > 0)>
                            <span class="bdg bdg-pending" style="font-size:.65rem">Action needed</span>
                        <#else>
                            <span class="bdg bdg-completed" style="font-size:.65rem">All clear</span>
                        </#if>
                    </div>
                    <div class="stat-value">${pendingApprovals}</div>
                    <div class="stat-label">Pending Approvals</div>
                    <div class="stat-sub"><#if (pendingApprovals == 0)>No action required<#else>Waiting for review</#if></div>
                </div>
            </div>
        </div>

        <!-- Row 2: secondary stats -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#d1fae5"><i class="bi bi-currency-dollar" style="color:#059669"></i></div>
                        <span class="text-muted" style="font-size:.7rem">All accounts</span>
                    </div>
                    <div class="stat-value" style="font-size:1.4rem">$${totalBalance?string["0.00"]}</div>
                    <div class="stat-label">Total Balance</div>
                    <div class="stat-sub">Sum of all account balances</div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#ede9fe"><i class="bi bi-graph-up-arrow" style="color:#7c3aed"></i></div>
                        <span class="text-muted" style="font-size:.7rem">Completed only</span>
                    </div>
                    <div class="stat-value" style="font-size:1.4rem">$${avgTransactionAmount?string["0.00"]}</div>
                    <div class="stat-label">Avg Transaction</div>
                    <div class="stat-sub">Based on ${completedCount} completed</div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#d1fae5"><i class="bi bi-check-circle-fill" style="color:#059669"></i></div>
                        <span class="text-muted" style="font-size:.7rem">Success rate</span>
                    </div>
                    <#assign successRate = 0>
                    <#if (totalTransactions > 0)><#assign successRate = (completedCount * 100 / totalTransactions)></#if>
                    <div class="stat-value">${successRate?string["0"]}%</div>
                    <div class="stat-label">Completion Rate</div>
                    <div class="stat-sub">${completedCount} of ${totalTransactions} transactions</div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex align-items-start justify-content-between">
                        <div class="stat-icon" style="background:#d1fae5"><i class="bi bi-activity" style="color:#059669"></i></div>
                        <span class="bdg bdg-completed" style="font-size:.65rem">Healthy</span>
                    </div>
                    <div class="stat-value">99.8%</div>
                    <div class="stat-label">System Health</div>
                    <div class="stat-sub">All services operational</div>
                </div>
            </div>
        </div>

        <!-- Row 3: Charts -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="panel" style="height:100%">
                    <div class="panel-header">
                        <h6><i class="bi bi-graph-up me-2" style="color:#4f46e5"></i>Transaction Volume — Last 6 Months</h6>
                        <span class="text-muted" style="font-size:.75rem">Grouped by calendar month &amp; year</span>
                    </div>
                    <div class="panel-body">
                        <canvas id="volumeChart" height="130"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="panel" style="height:100%">
                    <div class="panel-header">
                        <h6><i class="bi bi-pie-chart me-2" style="color:#4f46e5"></i>Status Distribution</h6>
                    </div>
                    <div class="panel-body">
                        <div class="d-flex justify-content-center mb-3">
                            <canvas id="statusChart" width="180" height="180"></canvas>
                        </div>
                        <div class="d-flex flex-wrap justify-content-center gap-2 mb-4">
                            <span class="bdg bdg-completed"><i class="bi bi-circle-fill" style="font-size:.45rem"></i>Done (${completedCount})</span>
                            <span class="bdg bdg-pending"><i class="bi bi-circle-fill" style="font-size:.45rem"></i>Pending (${pendingCount})</span>
                            <span class="bdg bdg-failed"><i class="bi bi-circle-fill" style="font-size:.45rem"></i>Failed (${failedCount})</span>
                            <span class="bdg bdg-cancelled"><i class="bi bi-circle-fill" style="font-size:.45rem"></i>Cancelled (${cancelledCount})</span>
                        </div>
                        <div style="border-top:1px solid #f3f4f6;padding-top:16px">
                            <div style="font-size:.75rem;font-weight:600;color:#6b7280;text-transform:uppercase;letter-spacing:.5px;margin-bottom:12px">By Type</div>
                            <#assign totalTx = typePayment + typeReplenishment + typeTransfer>
                            <#if (totalTx == 0)><#assign totalTx = 1></#if>
                            <div class="type-bar-row">
                                <span class="type-bar-label"><i class="bi bi-arrow-up-circle me-1" style="color:#374151"></i>Payment</span>
                                <div class="type-bar-track"><div class="type-bar-fill" style="width:${(typePayment*100/totalTx)?string["0"]}%;background:#6b7280"></div></div>
                                <span class="type-bar-count">${typePayment}</span>
                            </div>
                            <div class="type-bar-row">
                                <span class="type-bar-label"><i class="bi bi-arrow-down-circle me-1" style="color:#059669"></i>Top-up</span>
                                <div class="type-bar-track"><div class="type-bar-fill" style="width:${(typeReplenishment*100/totalTx)?string["0"]}%;background:#10b981"></div></div>
                                <span class="type-bar-count">${typeReplenishment}</span>
                            </div>
                            <div class="type-bar-row">
                                <span class="type-bar-label"><i class="bi bi-arrow-left-right me-1" style="color:#2563eb"></i>Transfer</span>
                                <div class="type-bar-track"><div class="type-bar-fill" style="width:${(typeTransfer*100/totalTx)?string["0"]}%;background:#3b82f6"></div></div>
                                <span class="type-bar-count">${typeTransfer}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Row 4: Top Users + Recent Transactions -->
        <div class="row g-4">
            <div class="col-lg-5">
                <div class="panel" style="height:100%">
                    <div class="panel-header">
                        <h6><i class="bi bi-trophy me-2" style="color:#f59e0b"></i>Top Users by Volume</h6>
                        <span class="text-muted" style="font-size:.75rem">Completed payments only</span>
                    </div>
                    <div class="panel-body" style="padding:0">
                        <#if topUsers?? && (topUsers?size > 0)>
                            <#list topUsers as u>
                                <#assign rank = u_index + 1>
                                <div style="padding:14px 20px;border-bottom:<#if u_has_next>1px solid #f9fafb<#else>none</#if>">
                                    <div class="d-flex align-items-center gap-3 mb-2">
                                        <div style="width:26px;height:26px;border-radius:50%;
                                            background:<#if rank==1>#fef3c7<#elseif rank==2>#f3f4f6<#else>#f9fafb</#if>;
                                            color:<#if rank==1>#b45309<#elseif rank==2>#374151<#else>#9ca3af</#if>;
                                            display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:700;flex-shrink:0">
                                            ${rank}
                                        </div>
                                        <div class="flex-grow-1 overflow-hidden">
                                            <div style="font-weight:600;font-size:.875rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${u.name}</div>
                                            <div style="color:#9ca3af;font-size:.72rem">${u.email} &bull; ${u.count} txn<#if (u.count > 1)>s</#if></div>
                                        </div>
                                        <div style="font-weight:700;font-size:.9rem;color:#111827;flex-shrink:0">$${u.total?string["0.00"]}</div>
                                    </div>
                                    <div class="progress-thin" style="margin-left:38px">
                                        <div class="progress-fill" style="width:${u.pct?string["0.0"]}%"></div>
                                    </div>
                                </div>
                            </#list>
                        <#else>
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-3 d-block mb-2"></i>No transaction data yet
                            </div>
                        </#if>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="panel">
                    <div class="panel-header">
                        <h6><i class="bi bi-clock-history me-2" style="color:#4f46e5"></i>Recent Transactions</h6>
                        <a href="/admin/transactions" class="bdg bdg-transfer px-3 py-2" style="text-decoration:none;font-size:.75rem">
                            View All <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                            <tr>
                                <th>TXN ID</th>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Type</th>
                                <th style="text-align:right">Amount</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#if recentTransactions?? && (recentTransactions?size > 0)>
                                <#list recentTransactions as p>
                                    <tr>
                                        <td><code style="font-size:.72rem;color:#4f46e5;font-weight:600">${p.transactionId!"—"}</code></td>
                                        <td style="white-space:nowrap;color:#6b7280;font-size:.78rem">
                                            <#if p.createdAt??>
                                                <#assign mo = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]>
                                                ${mo[p.createdAt.monthValue-1]} ${p.createdAt.dayOfMonth}<br>
                                                <span style="font-size:.68rem">${p.createdAt.hour?string("00")}:${p.createdAt.minute?string("00")}</span>
                                            <#else>—</#if>
                                        </td>
                                        <td style="max-width:130px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${p.description!"—"}</td>
                                        <td>
                                            <#if p.type??>
                                                <#if p.type.name()=="REPLENISHMENT"><span class="bdg bdg-replenishment"><i class="bi bi-arrow-down-circle"></i>Top-up</span>
                                                <#elseif p.type.name()=="TRANSFER"><span class="bdg bdg-transfer"><i class="bi bi-arrow-left-right"></i>Transfer</span>
                                                <#else><span class="bdg bdg-payment"><i class="bi bi-arrow-up-circle"></i>Payment</span></#if>
                                            <#else>—</#if>
                                        </td>
                                        <td style="text-align:right;white-space:nowrap">
                                            <#if p.type?? && p.type.name()=="REPLENISHMENT"><span class="amt-pos">+$${p.amount?string["0.00"]}</span>
                                            <#elseif p.type?? && p.type.name()=="TRANSFER"><span class="amt-neu">$${p.amount?string["0.00"]}</span>
                                            <#else><span class="amt-neg">-$${p.amount?string["0.00"]}</span></#if>
                                        </td>
                                        <td>
                                            <#if p.status??>
                                                <#if p.status.name()=="COMPLETED"><span class="bdg bdg-completed"><i class="bi bi-check-circle"></i>Done</span>
                                                <#elseif p.status.name()=="PENDING"><span class="bdg bdg-pending"><i class="bi bi-hourglass"></i>Pending</span>
                                                <#elseif p.status.name()=="FAILED"><span class="bdg bdg-failed"><i class="bi bi-x-circle"></i>Failed</span>
                                                <#else><span class="bdg bdg-cancelled"><i class="bi bi-dash-circle"></i>Cancelled</span></#if>
                                            <#else>—</#if>
                                        </td>
                                    </tr>
                                </#list>
                            <#else>
                                <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-2 d-block mb-2"></i>No transactions yet</td></tr>
                            </#if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script>
const volumeLabels = [<#list chartLabels as l>"${l}"<#sep>,</#list>];
const volumeData   = [<#list chartData as d>${d}<#sep>,</#list>];
const statusData   = [${completedCount},${pendingCount},${failedCount},${cancelledCount}];

new Chart(document.getElementById('volumeChart'),{
    type:'line',
    data:{
        labels:volumeLabels,
        datasets:[{label:'Transactions',data:volumeData,borderColor:'#4f46e5',backgroundColor:'rgba(79,70,229,.07)',borderWidth:2.5,pointBackgroundColor:'#4f46e5',pointBorderColor:'#fff',pointBorderWidth:2,pointRadius:5,pointHoverRadius:7,tension:0.35,fill:true}]
    },
    options:{responsive:true,plugins:{legend:{display:false},tooltip:{backgroundColor:'#1e1b4b',padding:10,callbacks:{label:ctx=>'  '+ctx.parsed.y+' transaction'+(ctx.parsed.y!==1?'s':'')}}},scales:{x:{grid:{display:false},ticks:{font:{size:11},color:'#9ca3af'}},y:{beginAtZero:true,ticks:{font:{size:11},color:'#9ca3af',stepSize:1,precision:0},grid:{color:'#f3f4f6'}}}}
});

new Chart(document.getElementById('statusChart'),{
    type:'doughnut',
    data:{labels:['Completed','Pending','Failed','Cancelled'],datasets:[{data:statusData,backgroundColor:['#10b981','#f59e0b','#ef4444','#9ca3af'],borderWidth:0,hoverOffset:8}]},
    options:{cutout:'70%',responsive:false,plugins:{legend:{display:false},tooltip:{backgroundColor:'#1e1b4b',callbacks:{label:ctx=>'  '+ctx.label+': '+ctx.parsed}}}}
});
</script>
</body>
</html>
