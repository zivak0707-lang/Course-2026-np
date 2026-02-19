<#-- @ftlvariable name="admin" type="ua.com.kisit.course2026np.entity.User" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports — PayFlow Admin</title>
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
        <a href="/admin/transactions" class="nav-link"><i class="bi bi-arrow-left-right"></i> All Transactions</a>
        <div class="nav-label" style="margin-top:8px">Analytics</div>
        <a href="/admin/reports" class="nav-link active"><i class="bi bi-bar-chart-line"></i> Reports</a>
        <a href="/admin/settings" class="nav-link"><i class="bi bi-gear"></i> Settings</a>
    </nav>
    <div class="sidebar-footer">
        <a href="/admin/logout" class="nav-link"><i class="bi bi-box-arrow-left"></i> Logout</a>
    </div>
</aside>

<div class="admin-main">
    <div class="topbar">
        <h5><i class="bi bi-bar-chart-line me-2"></i>Reports</h5>
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
    <div class="content-area d-flex align-items-center justify-content-center" style="min-height:calc(100vh - 65px)">
        <div class="text-center" style="max-width:400px">
            <div style="width:80px;height:80px;background:#ede9fe;border-radius:20px;display:inline-flex;align-items:center;justify-content:center;margin-bottom:24px">
                <i class="bi bi-bar-chart-line" style="font-size:2rem;color:#7c3aed"></i>
            </div>
            <h4 style="font-weight:700;color:#111827;margin-bottom:8px">Reports Coming Soon</h4>
            <p class="text-muted mb-4" style="font-size:.9rem;line-height:1.6">
                Advanced analytics and export features are in development.<br>Check the Dashboard for real-time metrics.
            </p>
            <a href="/admin/dashboard" class="btn rounded-3 px-4 py-2" style="background:#4f46e5;color:#fff;font-weight:600;border:none;font-size:.9rem">
                <i class="bi bi-grid me-2"></i>Go to Dashboard
            </a>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
