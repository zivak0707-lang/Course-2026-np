<#-- @ftlvariable name="admin" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="accounts" type="java.util.List<ua.com.kisit.course2026np.entity.Account>" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Accounts — PayFlow Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *{box-sizing:border-box}
        body{font-family:'Inter',sans-serif;background:#f1f5f9;margin:0}
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
        .admin-main{margin-left:220px;min-height:100vh}
        .topbar{background:#fff;border-bottom:1px solid #e5e7eb;padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50}
        .topbar h5{margin:0;font-weight:700;color:#111827;font-size:1.1rem}
        .admin-avatar{width:36px;height:36px;background:linear-gradient(135deg,#4f46e5,#7c3aed);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.85rem}
        .content-area{padding:28px}
        .section-title{font-size:1.25rem;font-weight:700;color:#111827;margin:0}
        .table-card{background:#fff;border-radius:14px;border:1px solid #e5e7eb;box-shadow:0 1px 3px rgba(0,0,0,.04);overflow:hidden}
        .table-card-header{padding:18px 24px;border-bottom:1px solid #f3f4f6;display:flex;align-items:center;gap:12px;flex-wrap:wrap}
        .table thead th{font-size:.72rem;font-weight:600;color:#6b7280;text-transform:uppercase;letter-spacing:.6px;background:#f9fafb;border-bottom:1px solid #f3f4f6;padding:12px 16px;white-space:nowrap}
        .table tbody td{padding:14px 16px;font-size:.875rem;color:#374151;border-bottom:1px solid #f9fafb;vertical-align:middle}
        .table tbody tr:last-child td{border-bottom:none}
        .table tbody tr:hover{background:#fafafa}
        .user-avatar{width:36px;height:36px;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-weight:700;font-size:.8rem;flex-shrink:0}
        .status-badge{display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:20px;font-size:.72rem;font-weight:600}
        .status-active{background:#d1fae5;color:#065f46}
        .status-blocked{background:#fee2e2;color:#991b1b}
        .btn-action{height:30px;padding:0 12px;border-radius:7px;font-size:.75rem;font-weight:600;border:1px solid #e5e7eb;background:#fff;cursor:pointer;transition:background .15s,color .15s;white-space:nowrap;display:inline-flex;align-items:center;gap:5px}
        .btn-action:hover{background:#f3f4f6}
        .btn-action.btn-warn{color:#991b1b;border-color:#fecaca}
        .btn-action.btn-warn:hover{background:#fef2f2}
        .btn-action.btn-ok{color:#065f46;border-color:#bbf7d0}
        .btn-action.btn-ok:hover{background:#f0fdf4}
        .btn-icon{width:32px;height:32px;padding:0;display:inline-flex;align-items:center;justify-content:center;border-radius:8px;font-size:.85rem}
        .tx-table{width:100%;font-size:.82rem}
        .tx-table th{font-size:.68rem;font-weight:600;color:#6b7280;text-transform:uppercase;letter-spacing:.5px;padding:8px 10px;background:#f9fafb;border-bottom:1px solid #f3f4f6;text-align:left}
        .tx-table td{padding:9px 10px;border-bottom:1px solid #f9fafb;color:#374151;vertical-align:middle}
        .tx-table tr:last-child td{border-bottom:none}
        .tx-type-badge{display:inline-block;padding:2px 8px;border-radius:6px;font-size:.68rem;font-weight:600;letter-spacing:.3px}
        .tx-type-PAYMENT{background:#fef3c7;color:#92400e}
        .tx-type-REPLENISHMENT{background:#d1fae5;color:#065f46}
        .tx-type-TRANSFER{background:#dbeafe;color:#1e40af}
        .tx-status-COMPLETED{color:#059669}
        .tx-status-PENDING{color:#d97706}
        .tx-status-FAILED{color:#dc2626}
        .tx-status-CANCELLED{color:#6b7280}
        .form-control-sm,.form-select-sm{border-radius:8px;font-size:.85rem;border-color:#e5e7eb}
        .form-control-sm:focus,.form-select-sm:focus{border-color:#4f46e5;box-shadow:0 0 0 3px rgba(79,70,229,.12)}
        .search-wrapper{position:relative}
        .search-wrapper .bi{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:#9ca3af;font-size:.85rem}
        .search-wrapper input{padding-left:32px}
        .account-number{font-family:monospace;font-size:.82rem;color:#6b7280}
        .balance-amount{font-weight:600;color:#111827;font-variant-numeric:tabular-nums}
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
        <a href="/admin/dashboard" class="nav-link"><i class="bi bi-grid"></i> Dashboard</a>
        <a href="/admin/users" class="nav-link"><i class="bi bi-people"></i> Manage Users</a>
        <a href="/admin/accounts" class="nav-link active"><i class="bi bi-wallet2"></i> Accounts</a>
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
        <h5><i class="bi bi-wallet2 me-2"></i>Manage Accounts</h5>
        <div class="d-flex align-items-center gap-2">
            <div class="admin-avatar">
                <#if admin??>${admin.firstName?substring(0,1)}${admin.lastName?substring(0,1)}<#else>A</#if>
            </div>
            <div>
                <div style="font-size:.85rem;font-weight:600;color:#111827"><#if admin??>${admin.firstName} ${admin.lastName}<#else>Admin</#if></div>
                <div style="font-size:.7rem;color:#6b7280">Administrator</div>
            </div>
        </div>
    </div>

    <div class="content-area">
        <#if successMessage??>
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4 rounded-3" style="font-size:.875rem">
                <i class="bi bi-check-circle-fill"></i>${successMessage}
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </#if>
        <#if errorMessage??>
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4 rounded-3" style="font-size:.875rem">
                <i class="bi bi-exclamation-triangle-fill"></i>${errorMessage}
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </#if>

        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h4 class="section-title">All Accounts</h4>
                <p class="text-muted small mb-0 mt-1"><#if accounts??>${accounts?size}<#else>0</#if> total accounts</p>
            </div>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <div class="search-wrapper flex-grow-1" style="max-width:320px">
                    <i class="bi bi-search"></i>
                    <input type="text" id="searchInput" class="form-control form-control-sm" placeholder="Search by owner or account number…">
                </div>
                <select id="statusFilter" class="form-select form-select-sm" style="width:140px">
                    <option value="ALL">All Status</option>
                    <option value="ACTIVE">Active</option>
                    <option value="BLOCKED">Blocked</option>
                </select>
                <span class="text-muted small ms-auto" id="rowCount"></span>
            </div>
            <div class="table-responsive">
                <table class="table mb-0" id="accountsTable">
                    <thead>
                    <tr>
                        <th>ID</th><th>Owner</th><th>Account Number</th><th class="text-end">Balance</th><th>Status</th><th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody id="accountsBody">
                    <#if accounts?? && (accounts?size > 0)>
                        <#list accounts as a>
                            <#assign isActive = a.status.name() == "ACTIVE">
                            <#assign hasOwner = a.creditCard?? && a.creditCard.user??>
                            <#if hasOwner>
                                <#assign owner = a.creditCard.user>
                                <#assign firstName = owner.firstName!''>
                                <#assign lastName  = owner.lastName!''>
                                <#assign ownerName       = (firstName + ' ' + lastName)?trim>
                                <#if ownerName == ''><#assign ownerName = '—'></#if>
                                <#assign ownerEmail      = owner.email!''>
                                <#assign initFirst       = (firstName?length > 0)?then(firstName?substring(0,1), '?')>
                                <#assign initLast        = (lastName?length > 0)?then(lastName?substring(0,1), '')>
                                <#assign ownerInitials   = initFirst + initLast>
                                <#assign ownerIdForColor = owner.id>
                            <#else>
                                <#assign ownerName       = '—'>
                                <#assign ownerEmail      = ''>
                                <#assign ownerInitials   = '?'>
                                <#assign ownerIdForColor = a.id>
                            </#if>
                            <#assign bgColors = ["#ede9fe","#dbeafe","#d1fae5","#fef3c7","#fee2e2","#f0fdf4"]>
                            <#assign txColors = ["#5b21b6","#1e40af","#065f46","#92400e","#991b1b","#166534"]>
                            <#assign ci = (ownerIdForColor % 6)?int>
                            <#assign acctNum  = a.accountNumber!''>
                            <#assign acctName = a.accountName!''>
                            <tr data-owner="${ownerName?lower_case} ${ownerEmail?lower_case}"
                                data-number="${acctNum?lower_case}"
                                data-status="${isActive?string("ACTIVE","BLOCKED")}">
                                <td><span style="font-size:.78rem;color:#6b7280;font-family:monospace">ACC-${a.id?string("000")}</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-avatar" style="background:${bgColors[ci]};color:${txColors[ci]}">${ownerInitials}</div>
                                        <div>
                                            <div style="font-weight:600;font-size:.875rem">${ownerName}</div>
                                            <#if ownerEmail != ''><div style="font-size:.75rem;color:#6b7280">${ownerEmail}</div></#if>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="account-number">${acctNum}</div>
                                    <#if acctName != ''><div style="font-size:.72rem;color:#6b7280;margin-top:2px">${acctName}</div></#if>
                                </td>
                                <td class="text-end"><span class="balance-amount">$${a.balance?string["0.00"]}</span></td>
                                <td>
                                    <#if isActive>
                                        <span class="status-badge status-active"><i class="bi bi-circle-fill" style="font-size:.5rem"></i>Active</span>
                                    <#else>
                                        <span class="status-badge status-blocked"><i class="bi bi-circle-fill" style="font-size:.5rem"></i>Blocked</span>
                                    </#if>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center justify-content-center gap-1">
                                        <button type="button" class="btn btn-light btn-icon" title="View details"
                                                onclick="openAccountDetails(${a.id?c})">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <#if isActive>
                                            <form method="post" action="/admin/accounts/${a.id?c}/block" style="margin:0;display:inline">
                                                <button type="submit" class="btn-action btn-warn" title="Block account"><i class="bi bi-slash-circle"></i>Заблокувати</button>
                                            </form>
                                        <#else>
                                            <form method="post" action="/admin/accounts/${a.id?c}/unblock" style="margin:0;display:inline">
                                                <button type="submit" class="btn-action btn-ok" title="Unblock account"><i class="bi bi-check-circle"></i>Розблокувати</button>
                                            </form>
                                        </#if>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-wallet2 fs-2 d-block mb-2"></i>No accounts found</td></tr>
                    </#if>
                    </tbody>
                </table>
                <div id="emptyState" class="text-center py-5 text-muted" style="display:none">
                    <i class="bi bi-search fs-2 d-block mb-2"></i>No accounts match your search
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Account details modal -->
<div class="modal fade" id="accountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h6 class="modal-title fw-bold"><i class="bi bi-wallet2 me-2"></i>Account Details</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body pt-3">
                <div id="acctModalLoading" class="text-center py-4 text-muted">
                    <div class="spinner-border spinner-border-sm me-2" role="status"></div>Loading…
                </div>
                <div id="acctModalError" class="alert alert-danger d-none" style="font-size:.85rem"></div>
                <div id="acctModalContent" class="d-none">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="user-avatar" id="acctModalAvatar" style="width:50px;height:50px;font-size:1rem;background:#ede9fe;color:#5b21b6"></div>
                        <div>
                            <div class="fw-bold" id="acctModalOwnerName" style="font-size:1rem"></div>
                            <div class="text-muted small" id="acctModalOwnerEmail"></div>
                        </div>
                        <div class="ms-auto" id="acctModalStatus"></div>
                    </div>
                    <div class="row g-3">
                        <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Account ID</div><div class="fw-600 mt-1" id="acctModalId" style="font-family:monospace;font-size:.9rem"></div></div></div>
                        <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Type</div><div class="fw-600 mt-1" id="acctModalName" style="font-size:.9rem"></div></div></div>
                        <div class="col-12"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Account Number</div><div class="fw-600 mt-1" id="acctModalNumber" style="font-family:monospace;font-size:.95rem"></div></div></div>
                        <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Balance</div><div class="fw-700 mt-1" id="acctModalBalance" style="font-size:1.1rem;color:#111827"></div></div></div>
                        <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Created</div><div class="fw-600 mt-1" id="acctModalCreated" style="font-size:.85rem"></div></div></div>
                    </div>
                    <div class="mt-4">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h6 class="mb-0 fw-bold" style="font-size:.85rem;color:#111827">Recent Transactions</h6>
                            <span class="text-muted small" id="acctModalTxCount"></span>
                        </div>
                        <div class="rounded-3 border" style="border-color:#e5e7eb !important;overflow:hidden">
                            <table class="tx-table mb-0">
                                <thead><tr><th>Date</th><th>Type</th><th>Status</th><th class="text-end">Amount</th><th>Counterparty</th></tr></thead>
                                <tbody id="acctModalTxBody"></tbody>
                            </table>
                            <div id="acctModalNoTx" class="text-center py-4 text-muted d-none" style="font-size:.85rem"><i class="bi bi-inbox d-block fs-5 mb-1"></i>No transactions yet</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0"><button type="button" class="btn btn-light rounded-3" data-bs-dismiss="modal">Close</button></div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script>
const searchInput=document.getElementById('searchInput');
const statusFilter=document.getElementById('statusFilter');
const rows=document.querySelectorAll('#accountsBody tr[data-owner]');
const emptyState=document.getElementById('emptyState');
const rowCount=document.getElementById('rowCount');

function applyFilters(){
    const q=searchInput.value.toLowerCase().trim();
    const stat=statusFilter.value;
    let visible=0;
    rows.forEach(row=>{
        const show=(row.dataset.owner.includes(q)||row.dataset.number.includes(q))
            &&(stat==='ALL'||row.dataset.status===stat);
        row.style.display=show?'':'none';
        if(show)visible++;
    });
    emptyState.style.display=visible===0&&rows.length>0?'block':'none';
    rowCount.textContent=visible+' of '+rows.length+' accounts';
}
searchInput.addEventListener('input',applyFilters);
statusFilter.addEventListener('change',applyFilters);
applyFilters();

function escapeHtml(s){
    if(s==null) return '';
    return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}
function fmtDate(iso){
    if(!iso) return '—';
    const d=new Date(iso); if(isNaN(d)) return iso;
    const mo=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const hh=String(d.getHours()).padStart(2,'0'), mm=String(d.getMinutes()).padStart(2,'0');
    return mo[d.getMonth()]+' '+d.getDate()+', '+d.getFullYear()+' '+hh+':'+mm;
}
function fmtAmount(n){ if(n==null) return '—'; return '$'+Number(n).toFixed(2); }

const acctModal = new bootstrap.Modal(document.getElementById('accountModal'));

async function openAccountDetails(id){
    document.getElementById('acctModalLoading').classList.remove('d-none');
    document.getElementById('acctModalError').classList.add('d-none');
    document.getElementById('acctModalContent').classList.add('d-none');
    acctModal.show();
    try {
        const res = await fetch('/admin/accounts/'+id+'/details', { headers:{'Accept':'application/json'} });
        if(!res.ok){
            const msg = res.status===401 ? 'Session expired — please log in again' : ('Failed to load: '+res.status);
            const errEl=document.getElementById('acctModalError');
            errEl.textContent=msg; errEl.classList.remove('d-none');
            document.getElementById('acctModalLoading').classList.add('d-none');
            return;
        }
        const d = await res.json();
        populateAccountModal(d);
    } catch(e){
        const errEl=document.getElementById('acctModalError');
        errEl.textContent='Network error — please try again'; errEl.classList.remove('d-none');
        document.getElementById('acctModalLoading').classList.add('d-none');
    }
}

function populateAccountModal(d){
    const initials = (d.ownerName||'').split(' ').filter(Boolean).map(s=>s[0]).slice(0,2).join('').toUpperCase() || '?';
    document.getElementById('acctModalAvatar').textContent = initials;
    document.getElementById('acctModalOwnerName').textContent  = d.ownerName  || 'No owner';
    document.getElementById('acctModalOwnerEmail').textContent = d.ownerEmail || '—';
    document.getElementById('acctModalStatus').innerHTML = d.status==='ACTIVE'
        ? '<span class="status-badge status-active"><i class="bi bi-circle-fill" style="font-size:.5rem"></i>Active</span>'
        : '<span class="status-badge status-blocked"><i class="bi bi-circle-fill" style="font-size:.5rem"></i>Blocked</span>';
    document.getElementById('acctModalId').textContent      = 'ACC-'+String(d.id).padStart(3,'0');
    document.getElementById('acctModalName').textContent    = d.accountName || '—';
    document.getElementById('acctModalNumber').textContent  = d.accountNumber || '—';
    document.getElementById('acctModalBalance').textContent = fmtAmount(d.balance);
    document.getElementById('acctModalCreated').textContent = fmtDate(d.createdAt);

    const body = document.getElementById('acctModalTxBody');
    const noTx = document.getElementById('acctModalNoTx');
    const count = document.getElementById('acctModalTxCount');
    body.innerHTML = '';
    const list = d.recentActivity || [];
    if(list.length===0){
        noTx.classList.remove('d-none');
        count.textContent = '0 entries';
    } else {
        noTx.classList.add('d-none');
        count.textContent = list.length + (list.length===1?' entry':' entries');
        for(const p of list){
            const tr = document.createElement('tr');
            const sender = p.senderAccount || '';
            const recipient = p.recipientAccount || '';
            const counterparty = (p.type==='REPLENISHMENT' ? sender : recipient) || '—';
            tr.innerHTML =
                '<td style="white-space:nowrap;color:#6b7280">'+escapeHtml(fmtDate(p.createdAt))+'</td>'+
                '<td><span class="tx-type-badge tx-type-'+escapeHtml(p.type||'')+'">'+escapeHtml(p.type||'')+'</span></td>'+
                '<td><span class="tx-status-'+escapeHtml(p.status||'')+'" style="font-weight:600">'+escapeHtml(p.status||'')+'</span></td>'+
                '<td class="text-end" style="font-variant-numeric:tabular-nums;font-weight:600">'+escapeHtml(fmtAmount(p.amount))+'</td>'+
                '<td style="font-family:monospace;font-size:.78rem;color:#6b7280">'+escapeHtml(counterparty)+'</td>';
            body.appendChild(tr);
        }
    }
    document.getElementById('acctModalLoading').classList.add('d-none');
    document.getElementById('acctModalContent').classList.remove('d-none');
}
</script>
</body>
</html>
