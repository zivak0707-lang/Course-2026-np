<#-- @ftlvariable name="manager" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="payments" type="java.util.List<ua.com.kisit.course2026np.entity.Payment>" -->
<#-- @ftlvariable name="currentPage" type="int" -->
<#-- @ftlvariable name="totalPages" type="int" -->
<#-- @ftlvariable name="totalItems" type="int" -->
<#-- @ftlvariable name="hasNext" type="boolean" -->
<#-- @ftlvariable name="hasPrevious" type="boolean" -->
<#-- @ftlvariable name="searchQuery" type="java.lang.String" -->
<#-- @ftlvariable name="selectedType" type="java.lang.String" -->
<#-- @ftlvariable name="selectedStatus" type="java.lang.String" -->
<#-- @ftlvariable name="paymentTypes" type="ua.com.kisit.course2026np.entity.PaymentType[]" -->
<#-- @ftlvariable name="paymentStatuses" type="ua.com.kisit.course2026np.entity.PaymentStatus[]" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Transactions — PayFlow Manager</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *{box-sizing:border-box}
        body{font-family:'Inter',sans-serif;background:#f1f5f9;margin:0}
        .mgr-sidebar{width:220px;min-height:100vh;position:fixed;top:0;left:0;z-index:100;background:#064e3b;display:flex;flex-direction:column}
        .sidebar-brand{display:flex;align-items:center;gap:10px;padding:22px 20px;border-bottom:1px solid rgba(255,255,255,.1)}
        .sidebar-brand .brand-icon{width:34px;height:34px;background:rgba(255,255,255,.15);border-radius:8px;display:flex;align-items:center;justify-content:center}
        .sidebar-brand .brand-icon i{color:#fff;font-size:17px}
        .sidebar-brand span{color:#fff;font-weight:700;font-size:1.05rem}
        .sidebar-nav{padding:16px 12px;flex:1}
        .sidebar-nav .nav-label{font-size:.68rem;font-weight:600;color:rgba(255,255,255,.4);text-transform:uppercase;letter-spacing:1px;padding:10px 8px 6px}
        .sidebar-nav .nav-link{color:rgba(255,255,255,.75);padding:9px 12px;border-radius:8px;display:flex;align-items:center;gap:10px;font-size:.88rem;font-weight:500;text-decoration:none;transition:background .15s,color .15s;margin-bottom:2px}
        .sidebar-nav .nav-link i{font-size:16px;width:18px;text-align:center}
        .sidebar-nav .nav-link:hover{background:rgba(255,255,255,.12);color:#fff}
        .sidebar-nav .nav-link.active{background:rgba(255,255,255,.18);color:#fff;font-weight:600}
        .sidebar-footer{padding:14px 12px;border-top:1px solid rgba(255,255,255,.1)}
        .sidebar-footer .nav-link{color:rgba(255,255,255,.6);padding:9px 12px;border-radius:8px;display:flex;align-items:center;gap:10px;font-size:.88rem;text-decoration:none;transition:background .15s}
        .sidebar-footer .nav-link:hover{background:rgba(239,68,68,.2);color:#fca5a5}
        .mgr-main{margin-left:220px;min-height:100vh}
        .topbar{background:#fff;border-bottom:1px solid #e5e7eb;padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50}
        .topbar h5{margin:0;font-weight:700;color:#111827;font-size:1.1rem}
        .mgr-avatar{width:36px;height:36px;background:linear-gradient(135deg,#059669,#10b981);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.85rem}
        .content-area{padding:28px}
        .section-title{font-size:1.25rem;font-weight:700;color:#111827;margin:0}
        .table-card{background:#fff;border-radius:14px;border:1px solid #e5e7eb;box-shadow:0 1px 3px rgba(0,0,0,.04);overflow:hidden}
        .table-card-header{padding:18px 24px;border-bottom:1px solid #f3f4f6;display:flex;align-items:center;gap:10px;flex-wrap:wrap}
        .table thead th{font-size:.7rem;font-weight:600;color:#6b7280;text-transform:uppercase;letter-spacing:.6px;background:#f9fafb;border-bottom:1px solid #f3f4f6;padding:11px 14px;white-space:nowrap}
        .table tbody td{padding:13px 14px;font-size:.855rem;color:#374151;border-bottom:1px solid #f9fafb;vertical-align:middle}
        .table tbody tr:last-child td{border-bottom:none}
        .table tbody tr:hover{background:#fafafa}
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
        .form-control-sm,.form-select-sm{border-radius:8px;font-size:.85rem;border-color:#e5e7eb}
        .form-control-sm:focus,.form-select-sm:focus{border-color:#059669;box-shadow:0 0 0 3px rgba(5,150,105,.12)}
        .page-btn{width:34px;height:34px;border-radius:8px;border:1px solid #e5e7eb;background:#fff;display:inline-flex;align-items:center;justify-content:center;font-size:.8rem;font-weight:600;color:#374151;text-decoration:none;transition:background .15s}
        .page-btn:hover{background:#f3f4f6;color:#111827}
        .page-btn.active{background:#059669;border-color:#059669;color:#fff}
        .page-btn.disabled{opacity:.4;pointer-events:none}
        .search-wrapper{position:relative}
        .search-wrapper .bi-search{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:#9ca3af;font-size:.85rem}
        .search-wrapper input{padding-left:32px}
        .readonly-notice{background:#ecfdf5;border:1px solid #6ee7b7;border-radius:10px;padding:10px 16px;font-size:.82rem;color:#065f46;display:flex;align-items:center;gap:8px}
    </style>
</head>
<body>

<aside class="mgr-sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-speedometer2"></i></div>
        <span>Manager Panel</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Overview</div>
        <a href="/manager/dashboard" class="nav-link"><i class="bi bi-grid"></i> Dashboard</a>
        <a href="/manager/transactions" class="nav-link active"><i class="bi bi-arrow-left-right"></i> All Transactions</a>
        <div class="nav-label" style="margin-top:8px">Analytics</div>
        <a href="/manager/reports" class="nav-link"><i class="bi bi-bar-chart-line"></i> Reports</a>
    </nav>
    <div class="sidebar-footer">
        <a href="/manager/logout" class="nav-link"><i class="bi bi-box-arrow-left"></i> Logout</a>
    </div>
</aside>

<div class="mgr-main">
    <div class="topbar">
        <h5><i class="bi bi-arrow-left-right me-2" style="color:#059669"></i>All Transactions</h5>
        <div class="d-flex align-items-center gap-2">
            <div class="mgr-avatar">
                <#if manager??>${manager.firstName?substring(0,1)}${manager.lastName?substring(0,1)}<#else>M</#if>
            </div>
            <div>
                <div style="font-size:.85rem;font-weight:600;color:#111827"><#if manager??>${manager.firstName} ${manager.lastName}<#else>Manager</#if></div>
                <div style="font-size:.7rem;color:#6b7280">Manager</div>
            </div>
        </div>
    </div>

    <div class="content-area">

        <div class="d-flex align-items-center justify-content-between mb-3">
            <div>
                <h4 class="section-title">All Transactions</h4>
                <p class="text-muted small mb-0 mt-1">${totalItems} total records</p>
            </div>
            <div class="readonly-notice">
                <i class="bi bi-eye"></i> View-only — no approval actions available
            </div>
        </div>

        <!-- Filters -->
        <form method="get" action="/manager/transactions" class="table-card mb-0" style="border-radius:14px 14px 0 0;border-bottom:none">
            <div class="table-card-header">
                <div class="search-wrapper" style="flex:1;min-width:200px;max-width:340px">
                    <i class="bi bi-search"></i>
                    <input type="text" name="search" value="${searchQuery!""}"
                           class="form-control form-control-sm" placeholder="Search by description or TXN ID…">
                </div>
                <select name="type" class="form-select form-select-sm" style="width:160px">
                    <option value="ALL" <#if selectedType=="ALL">selected</#if>>All Types</option>
                    <option value="PAYMENT"        <#if selectedType=="PAYMENT">selected</#if>>Payment</option>
                    <option value="REPLENISHMENT"  <#if selectedType=="REPLENISHMENT">selected</#if>>Top-up</option>
                    <option value="TRANSFER"       <#if selectedType=="TRANSFER">selected</#if>>Transfer</option>
                </select>
                <select name="status" class="form-select form-select-sm" style="width:160px">
                    <option value="ALL"       <#if selectedStatus=="ALL">selected</#if>>All Statuses</option>
                    <option value="COMPLETED" <#if selectedStatus=="COMPLETED">selected</#if>>Completed</option>
                    <option value="PENDING"   <#if selectedStatus=="PENDING">selected</#if>>Pending</option>
                    <option value="FAILED"    <#if selectedStatus=="FAILED">selected</#if>>Failed</option>
                    <option value="CANCELLED" <#if selectedStatus=="CANCELLED">selected</#if>>Cancelled</option>
                </select>
                <input type="hidden" name="page" value="0">
                <button type="submit" class="btn btn-sm px-3 rounded-3" style="background:#059669;color:#fff;border:none;font-weight:600;font-size:.82rem">
                    <i class="bi bi-funnel me-1"></i>Filter
                </button>
                <a href="/manager/transactions" class="btn btn-sm btn-light rounded-3 px-3" style="font-size:.82rem">Reset</a>
            </div>
        </form>

        <div class="table-card" style="border-radius:0 0 14px 14px">
            <div class="table-responsive">
                <table class="table mb-0">
                    <thead>
                    <tr>
                        <th>TXN ID</th>
                        <th>Date / Time</th>
                        <th>User</th>
                        <th>Description</th>
                        <th>Type</th>
                        <th style="text-align:right">Amount</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if payments?? && (payments?size > 0)>
                        <#list payments as p>
                            <tr>
                                <td><code style="font-size:.72rem;color:#059669;font-weight:600">${p.transactionId!"—"}</code></td>
                                <td style="white-space:nowrap;color:#6b7280;font-size:.78rem">
                                    <#if p.createdAt??>
                                        <#assign mo=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]>
                                        ${mo[p.createdAt.monthValue-1]} ${p.createdAt.dayOfMonth}, ${p.createdAt.year?c}<br>
                                        <span style="font-size:.68rem">${p.createdAt.hour?string("00")}:${p.createdAt.minute?string("00")}</span>
                                    <#else>—</#if>
                                </td>
                                <td style="font-size:.82rem">
                                    <#if p.account?? && p.account.creditCard?? && p.account.creditCard.user??>
                                        <div style="font-weight:600">${p.account.creditCard.user.firstName} ${p.account.creditCard.user.lastName}</div>
                                        <div style="color:#9ca3af;font-size:.72rem">${p.account.creditCard.user.email}</div>
                                    <#else>
                                        <span class="text-muted">—</span>
                                    </#if>
                                </td>
                                <td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:.82rem">
                                    ${p.description!"—"}
                                </td>
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
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>No transactions found
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <#if (totalPages > 1)>
                <div class="d-flex align-items-center justify-content-between px-4 py-3" style="border-top:1px solid #f3f4f6">
                    <span class="text-muted small">
                        Page ${currentPage + 1} of ${totalPages}
                        &bull; ${totalItems} total
                    </span>
                    <div class="d-flex gap-1">
                        <a href="/manager/transactions?page=${currentPage - 1}&search=${searchQuery!""}&type=${selectedType!""}&status=${selectedStatus!""}"
                           class="page-btn <#if !hasPrevious>disabled</#if>">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                        <#list 0..(totalPages - 1) as i>
                            <#if (i == 0) || (i == totalPages - 1) || ((i >= currentPage - 1) && (i <= currentPage + 1))>
                                <a href="/manager/transactions?page=${i}&search=${searchQuery!""}&type=${selectedType!""}&status=${selectedStatus!""}"
                                   class="page-btn <#if i == currentPage>active</#if>">${i + 1}</a>
                            <#elseif (i == 1 && currentPage > 3) || (i == totalPages - 2 && currentPage < totalPages - 4)>
                                <span class="page-btn" style="cursor:default">…</span>
                            </#if>
                        </#list>
                        <a href="/manager/transactions?page=${currentPage + 1}&search=${searchQuery!""}&type=${selectedType!""}&status=${selectedStatus!""}"
                           class="page-btn <#if !hasNext>disabled</#if>">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </#if>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
