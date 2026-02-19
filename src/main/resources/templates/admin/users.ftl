<#-- @ftlvariable name="admin" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="users" type="java.util.List<ua.com.kisit.course2026np.entity.User>" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users — PayFlow Admin</title>
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
        .role-badge{display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:20px;font-size:.72rem;font-weight:600}
        .role-client{background:#dbeafe;color:#1e40af}
        .role-admin{background:#ede9fe;color:#5b21b6}
        .form-control-sm,.form-select-sm{border-radius:8px;font-size:.85rem;border-color:#e5e7eb}
        .form-control-sm:focus,.form-select-sm:focus{border-color:#4f46e5;box-shadow:0 0 0 3px rgba(79,70,229,.12)}
        .btn-icon{width:32px;height:32px;padding:0;display:inline-flex;align-items:center;justify-content:center;border-radius:8px;font-size:.85rem}
        .toggle-switch{position:relative;display:inline-block;width:40px;height:22px}
        .toggle-switch input{opacity:0;width:0;height:0}
        .slider{position:absolute;cursor:pointer;top:0;left:0;right:0;bottom:0;background:#d1d5db;border-radius:22px;transition:.25s}
        .slider:before{position:absolute;content:"";height:16px;width:16px;left:3px;bottom:3px;background:white;border-radius:50%;transition:.25s;box-shadow:0 1px 3px rgba(0,0,0,.2)}
        input:checked+.slider{background:#4f46e5}
        input:checked+.slider:before{transform:translateX(18px)}
        .search-wrapper{position:relative}
        .search-wrapper .bi{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:#9ca3af;font-size:.85rem}
        .search-wrapper input{padding-left:32px}
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
        <a href="/admin/users" class="nav-link active"><i class="bi bi-people"></i> Manage Users</a>
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
        <h5><i class="bi bi-people me-2"></i>Manage Users</h5>
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
                <h4 class="section-title">All Users</h4>
                <p class="text-muted small mb-0 mt-1"><#if users??>${users?size}<#else>0</#if> registered accounts</p>
            </div>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <div class="search-wrapper flex-grow-1" style="max-width:320px">
                    <i class="bi bi-search"></i>
                    <input type="text" id="searchInput" class="form-control form-control-sm" placeholder="Search by name or email…">
                </div>
                <select id="roleFilter" class="form-select form-select-sm" style="width:140px">
                    <option value="ALL">All Roles</option>
                    <option value="CLIENT">Client</option>
                    <option value="ADMIN">Admin</option>
                </select>
                <select id="statusFilter" class="form-select form-select-sm" style="width:140px">
                    <option value="ALL">All Status</option>
                    <option value="ACTIVE">Active</option>
                    <option value="BLOCKED">Blocked</option>
                </select>
                <span class="text-muted small ms-auto" id="rowCount"></span>
            </div>
            <div class="table-responsive">
                <table class="table mb-0" id="usersTable">
                    <thead>
                    <tr>
                        <th>ID</th><th>User</th><th>Email</th><th>Role</th><th>Status</th><th>Registered</th><th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody id="usersBody">
                    <#if users?? && (users?size > 0)>
                        <#list users as u>
                            <#assign isActive = u.isActive?? && u.isActive>
                            <#assign isAdmin  = u.role.name() == "ADMIN">
                            <#assign bgColors = ["#ede9fe","#dbeafe","#d1fae5","#fef3c7","#fee2e2","#f0fdf4"]>
                            <#assign txColors = ["#5b21b6","#1e40af","#065f46","#92400e","#991b1b","#166534"]>
                            <#assign ci = (u.id % 6)?int>
                            <tr data-name="${u.firstName?lower_case} ${u.lastName?lower_case}"
                                data-email="${u.email?lower_case}"
                                data-role="${u.role.name()}"
                                data-status="${isActive?string("ACTIVE","BLOCKED")}">
                                <td><span style="font-size:.78rem;color:#6b7280;font-family:monospace">USR-${u.id?string("000")}</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-avatar" style="background:${bgColors[ci]};color:${txColors[ci]}">
                                            ${u.firstName?substring(0,1)}${u.lastName?substring(0,1)}
                                        </div>
                                        <span style="font-weight:600;font-size:.875rem">${u.firstName} ${u.lastName}</span>
                                    </div>
                                </td>
                                <td style="color:#6b7280;font-size:.85rem">${u.email}</td>
                                <td>
                                    <#if isAdmin>
                                        <span class="role-badge role-admin"><i class="bi bi-shield-fill"></i>Admin</span>
                                    <#else>
                                        <span class="role-badge role-client"><i class="bi bi-person"></i>Client</span>
                                    </#if>
                                </td>
                                <td>
                                    <form method="post" action="/admin/users/toggle-block" style="margin:0">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <label class="toggle-switch" title="${isActive?string("Click to block","Click to unblock")}">
                                            <input type="checkbox" ${isActive?string("checked","")} onchange="this.closest('form').submit()">
                                            <span class="slider"></span>
                                        </label>
                                    </form>
                                </td>
                                <td style="color:#6b7280;font-size:.82rem;white-space:nowrap">
                                    <#if u.createdAt??>
                                        <#assign mo=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]>
                                        ${mo[u.createdAt.monthValue-1]} ${u.createdAt.dayOfMonth}, ${u.createdAt.year?c}
                                    <#else>—</#if>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center justify-content-center gap-1">
                                        <button type="button" class="btn btn-light btn-icon" title="View details"
                                                data-bs-toggle="modal" data-bs-target="#userModal"
                                                data-id="${u.id}"
                                                data-name="${u.firstName} ${u.lastName}"
                                                data-email="${u.email}"
                                                data-role="${u.role.name()}"
                                                data-active="${isActive?string("Yes","No")}"
                                                data-registered="<#if u.createdAt??><#assign mo2=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]>${mo2[u.createdAt.monthValue-1]} ${u.createdAt.dayOfMonth}, ${u.createdAt.year?c}<#else>—</#if>">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-light btn-icon text-danger" title="Delete user"
                                                onclick="confirmDelete(${u.id},'${u.firstName} ${u.lastName}')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr><td colspan="7" class="text-center py-5 text-muted"><i class="bi bi-people fs-2 d-block mb-2"></i>No users found</td></tr>
                    </#if>
                    </tbody>
                </table>
                <div id="emptyState" class="text-center py-5 text-muted" style="display:none">
                    <i class="bi bi-search fs-2 d-block mb-2"></i>No users match your search
                </div>
            </div>
        </div>
    </div>
</div>

<!-- User detail modal -->
<div class="modal fade" id="userModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h6 class="modal-title fw-bold">User Details</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body pt-3">
                <div class="d-flex align-items-center gap-3 mb-4">
                    <div class="user-avatar" id="modalAvatar" style="width:50px;height:50px;font-size:1rem;background:#ede9fe;color:#5b21b6"></div>
                    <div>
                        <div class="fw-bold" id="modalName" style="font-size:1rem"></div>
                        <div class="text-muted small" id="modalEmail"></div>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">User ID</div><div class="fw-600 mt-1" id="modalId" style="font-family:monospace;font-size:.9rem"></div></div></div>
                    <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Role</div><div class="mt-1" id="modalRole"></div></div></div>
                    <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Status</div><div class="fw-600 mt-1" id="modalStatus"></div></div></div>
                    <div class="col-6"><div class="p-3 rounded-3" style="background:#f9fafb"><div class="text-muted" style="font-size:.7rem;font-weight:600;text-transform:uppercase">Registered</div><div class="fw-600 mt-1" id="modalRegistered" style="font-size:.85rem"></div></div></div>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0"><button type="button" class="btn btn-light rounded-3" data-bs-dismiss="modal">Close</button></div>
        </div>
    </div>
</div>

<!-- Delete confirm modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-body text-center p-4">
                <div class="mb-3" style="font-size:2.5rem">⚠️</div>
                <h6 class="fw-bold mb-2">Delete User?</h6>
                <p class="text-muted small mb-0" id="deleteConfirmText"></p>
            </div>
            <div class="modal-footer border-0 pt-0 justify-content-center gap-2">
                <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="post" action="/admin/users/delete" style="margin:0">
                    <input type="hidden" name="userId" id="deleteUserId">
                    <button type="submit" class="btn btn-danger rounded-3 px-4">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('userModal').addEventListener('show.bs.modal',function(e){
    const b=e.relatedTarget;
    const name=b.dataset.name;
    const parts=name.split(' ');
    document.getElementById('modalAvatar').textContent=(parts[0]?.[0]||'')+(parts[1]?.[0]||'');
    document.getElementById('modalName').textContent=name;
    document.getElementById('modalEmail').textContent=b.dataset.email;
    document.getElementById('modalId').textContent='USR-'+String(b.dataset.id).padStart(3,'0');
    const role=b.dataset.role;
    document.getElementById('modalRole').innerHTML=role==='ADMIN'
        ?'<span class="role-badge role-admin"><i class="bi bi-shield-fill"></i>Admin</span>'
        :'<span class="role-badge role-client"><i class="bi bi-person"></i>Client</span>';
    const active=b.dataset.active==='Yes';
    document.getElementById('modalStatus').innerHTML=active
        ?'<span style="color:#059669"><i class="bi bi-circle-fill me-1" style="font-size:.5rem"></i>Active</span>'
        :'<span style="color:#dc2626"><i class="bi bi-circle-fill me-1" style="font-size:.5rem"></i>Blocked</span>';
    document.getElementById('modalRegistered').textContent=b.dataset.registered;
});

function confirmDelete(id,name){
    document.getElementById('deleteUserId').value=id;
    document.getElementById('deleteConfirmText').textContent='Delete "'+name+'"? This cannot be undone.';
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}

const searchInput=document.getElementById('searchInput');
const roleFilter=document.getElementById('roleFilter');
const statusFilter=document.getElementById('statusFilter');
const rows=document.querySelectorAll('#usersBody tr[data-name]');
const emptyState=document.getElementById('emptyState');
const rowCount=document.getElementById('rowCount');

function applyFilters(){
    const q=searchInput.value.toLowerCase().trim();
    const role=roleFilter.value;
    const stat=statusFilter.value;
    let visible=0;
    rows.forEach(row=>{
        const show=(row.dataset.name.includes(q)||row.dataset.email.includes(q))
            &&(role==='ALL'||row.dataset.role===role)
            &&(stat==='ALL'||row.dataset.status===stat);
        row.style.display=show?'':'none';
        if(show)visible++;
    });
    emptyState.style.display=visible===0&&rows.length>0?'block':'none';
    rowCount.textContent=visible+' of '+rows.length+' users';
}
searchInput.addEventListener('input',applyFilters);
roleFilter.addEventListener('change',applyFilters);
statusFilter.addEventListener('change',applyFilters);
applyFilters();
</script>
</body>
</html>
