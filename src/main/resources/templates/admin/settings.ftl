<#-- @ftlvariable name="admin" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="successMessage" type="java.lang.String" -->
<#-- @ftlvariable name="errorMessage" type="java.lang.String" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings — PayFlow Admin</title>
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

        /* Settings specific */
        .settings-card{background:#fff;border-radius:14px;border:1px solid #e5e7eb;box-shadow:0 1px 3px rgba(0,0,0,.04);overflow:hidden;margin-bottom:24px}
        .settings-card-header{padding:20px 24px;border-bottom:1px solid #f3f4f6}
        .settings-card-header h6{margin:0;font-weight:700;color:#111827;font-size:1rem}
        .settings-card-header p{margin:4px 0 0;font-size:.82rem;color:#6b7280}
        .settings-card-body{padding:24px}
        .form-label-custom{font-size:.82rem;font-weight:600;color:#374151;margin-bottom:6px;display:block}
        .form-input{width:100%;height:40px;padding:0 12px;border:1px solid #e5e7eb;border-radius:9px;font-size:.875rem;color:#111827;font-family:'Inter',sans-serif;transition:border-color .15s,box-shadow .15s;outline:none}
        .form-input:focus{border-color:#4f46e5;box-shadow:0 0 0 3px rgba(79,70,229,.12)}
        .form-input::placeholder{color:#9ca3af}
        .form-input:disabled{background:#f9fafb;color:#6b7280;cursor:not-allowed}
        .pw-wrapper{position:relative}
        .pw-wrapper .form-input{padding-right:40px}
        .pw-toggle{position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;padding:0;cursor:pointer;color:#9ca3af;font-size:.95rem;line-height:1;transition:color .15s}
        .pw-toggle:hover{color:#4f46e5}
        .btn-save{height:38px;padding:0 20px;background:#4f46e5;color:#fff;border:none;border-radius:9px;font-size:.875rem;font-weight:600;cursor:pointer;transition:background .15s;display:inline-flex;align-items:center;gap:6px}
        .btn-save:hover{background:#4338ca}
        .btn-secondary-custom{height:38px;padding:0 20px;background:#fff;color:#374151;border:1px solid #e5e7eb;border-radius:9px;font-size:.875rem;font-weight:600;cursor:pointer;transition:background .15s;display:inline-flex;align-items:center;gap:6px}
        .btn-secondary-custom:hover{background:#f9fafb}

        /* Profile header block */
        .profile-header{display:flex;align-items:center;gap:16px;margin-bottom:28px;padding-bottom:24px;border-bottom:1px solid #f3f4f6}
        .profile-avatar-lg{width:64px;height:64px;border-radius:50%;background:linear-gradient(135deg,#4f46e5,#7c3aed);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:1.3rem;flex-shrink:0}
        .profile-info-name{font-size:1.1rem;font-weight:700;color:#111827}
        .profile-info-email{font-size:.83rem;color:#6b7280;margin-top:2px}
        .profile-role-badge{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;border-radius:20px;background:#ede9fe;color:#5b21b6;font-size:.72rem;font-weight:600;margin-top:6px}

        /* Password strength */
        .pw-strength{height:4px;border-radius:2px;background:#f3f4f6;margin-top:8px;overflow:hidden}
        .pw-strength-fill{height:100%;border-radius:2px;transition:width .3s,background .3s;width:0}
        .pw-strength-label{font-size:.72rem;margin-top:4px;color:#9ca3af}

        /* Danger zone */
        .danger-zone{background:#fff5f5;border:1px solid #fecaca;border-radius:14px;padding:20px 24px;margin-bottom:24px}
        .danger-zone h6{color:#991b1b;font-weight:700;font-size:.95rem;margin-bottom:4px}
        .danger-zone p{color:#dc2626;font-size:.82rem;margin:0}
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
        <a href="/admin/reports" class="nav-link"><i class="bi bi-bar-chart-line"></i> Reports</a>
        <a href="/admin/settings" class="nav-link active"><i class="bi bi-gear"></i> Settings</a>
    </nav>
    <div class="sidebar-footer">
        <a href="/admin/logout" class="nav-link"><i class="bi bi-box-arrow-left"></i> Logout</a>
    </div>
</aside>

<div class="admin-main">
    <div class="topbar">
        <h5><i class="bi bi-gear me-2"></i>Settings</h5>
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

    <div class="content-area" style="max-width:760px">

        <div class="mb-4">
            <h4 style="font-size:1.2rem;font-weight:700;color:#111827;margin:0">Settings</h4>
            <p class="text-muted small mb-0 mt-1">Manage your admin account settings and security.</p>
        </div>

        <!-- Flash messages -->
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

        <!-- ── Profile Information ── -->
        <div class="settings-card">
            <div class="settings-card-header">
                <h6><i class="bi bi-person-circle me-2" style="color:#4f46e5"></i>Profile Information</h6>
                <p>Update your name and email address.</p>
            </div>
            <div class="settings-card-body">
                <!-- Profile header -->
                <div class="profile-header">
                    <div class="profile-avatar-lg">
                        <#if admin??>${admin.firstName?substring(0,1)}${admin.lastName?substring(0,1)}<#else>A</#if>
                    </div>
                    <div>
                        <div class="profile-info-name"><#if admin??>${admin.firstName} ${admin.lastName}<#else>Admin</#if></div>
                        <div class="profile-info-email"><#if admin??>${admin.email}<#else>—</#if></div>
                        <div class="profile-role-badge"><i class="bi bi-shield-fill" style="font-size:.65rem"></i>Administrator</div>
                    </div>
                </div>

                <form method="post" action="/admin/settings/update-profile">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label-custom" for="firstName">First Name</label>
                            <input class="form-input" type="text" id="firstName" name="firstName"
                                   value="${(admin.firstName)!''}" placeholder="First name" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom" for="lastName">Last Name</label>
                            <input class="form-input" type="text" id="lastName" name="lastName"
                                   value="${(admin.lastName)!''}" placeholder="Last name" required>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label-custom" for="email">Email Address</label>
                        <input class="form-input" type="email" id="email" name="email"
                               value="${(admin.email)!''}" placeholder="admin@example.com" required>
                    </div>
                    <button type="submit" class="btn-save">
                        <i class="bi bi-floppy"></i>Save Changes
                    </button>
                </form>
            </div>
        </div>

        <!-- ── Security / Password ── -->
        <div class="settings-card">
            <div class="settings-card-header">
                <h6><i class="bi bi-lock me-2" style="color:#4f46e5"></i>Security</h6>
                <p>Change your admin password. You'll need to enter your current password to confirm.</p>
            </div>
            <div class="settings-card-body">
                <form method="post" action="/admin/settings/update-password" id="pwForm">
                    <div class="mb-3">
                        <label class="form-label-custom" for="currentPassword">Current Password</label>
                        <div class="pw-wrapper">
                            <input class="form-input" type="password" id="currentPassword"
                                   name="currentPassword" placeholder="Enter current password" required>
                            <button type="button" class="pw-toggle" onclick="togglePw('currentPassword',this)">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label-custom" for="newPassword">New Password</label>
                        <div class="pw-wrapper">
                            <input class="form-input" type="password" id="newPassword"
                                   name="newPassword" placeholder="Min. 6 characters" required
                                   oninput="checkStrength(this.value)">
                            <button type="button" class="pw-toggle" onclick="togglePw('newPassword',this)">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="pw-strength"><div class="pw-strength-fill" id="strengthFill"></div></div>
                        <div class="pw-strength-label" id="strengthLabel">Enter a new password</div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label-custom" for="confirmPassword">Confirm New Password</label>
                        <div class="pw-wrapper">
                            <input class="form-input" type="password" id="confirmPassword"
                                   placeholder="Repeat new password" required
                                   oninput="checkMatch()">
                            <button type="button" class="pw-toggle" onclick="togglePw('confirmPassword',this)">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="pw-strength-label" id="matchLabel"></div>
                    </div>
                    <button type="submit" class="btn-secondary-custom" id="pwSubmitBtn">
                        <i class="bi bi-shield-lock"></i>Update Password
                    </button>
                </form>
            </div>
        </div>

        <!-- ── Account Info (read-only) ── -->
        <div class="settings-card">
            <div class="settings-card-header">
                <h6><i class="bi bi-info-circle me-2" style="color:#4f46e5"></i>Account Details</h6>
                <p>Read-only information about your admin account.</p>
            </div>
            <div class="settings-card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label-custom">Account ID</label>
                        <input class="form-input" disabled value="<#if admin??>USR-${admin.id?string("000")}<#else>—</#if>" style="font-family:monospace">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-custom">Role</label>
                        <input class="form-input" disabled value="Administrator">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-custom">Account Status</label>
                        <input class="form-input" disabled value="Active" style="color:#059669">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-custom">Member Since</label>
                        <input class="form-input" disabled value="<#if admin?? && admin.createdAt??><#assign mo=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]>${mo[admin.createdAt.monthValue-1]} ${admin.createdAt.dayOfMonth}, ${admin.createdAt.year?c}<#else>—</#if>">
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Danger zone ── -->
        <div class="danger-zone">
            <div class="d-flex align-items-start justify-content-between gap-3">
                <div>
                    <h6><i class="bi bi-exclamation-triangle me-2"></i>Sign Out</h6>
                    <p>End your current admin session. You'll need to log in again to access the panel.</p>
                </div>
                <a href="/admin/logout"
                   class="btn btn-sm rounded-3 px-3 flex-shrink-0"
                   style="background:#dc2626;color:#fff;border:none;font-weight:600;font-size:.82rem;height:34px;display:inline-flex;align-items:center;gap:6px;text-decoration:none;margin-top:2px">
                    <i class="bi bi-box-arrow-right"></i>Logout
                </a>
            </div>
        </div>

    </div><!-- /content-area -->
</div><!-- /admin-main -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script>
function togglePw(id, btn) {
    const input = document.getElementById(id);
    const icon  = btn.querySelector('i');
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'bi bi-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'bi bi-eye';
    }
}

function checkStrength(val) {
    const fill  = document.getElementById('strengthFill');
    const label = document.getElementById('strengthLabel');
    let score = 0;
    if (val.length >= 6)  score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    const levels = [
        { pct:'0%',   bg:'#f3f4f6', text:'Enter a new password' },
        { pct:'20%',  bg:'#ef4444', text:'Very weak' },
        { pct:'40%',  bg:'#f97316', text:'Weak' },
        { pct:'60%',  bg:'#eab308', text:'Fair' },
        { pct:'80%',  bg:'#22c55e', text:'Strong' },
        { pct:'100%', bg:'#16a34a', text:'Very strong' },
    ];
    const lvl = val.length === 0 ? 0 : Math.min(score, 5);
    fill.style.width  = levels[lvl].pct;
    fill.style.background = levels[lvl].bg;
    label.textContent = levels[lvl].text;
    label.style.color = lvl < 3 ? '#dc2626' : lvl < 4 ? '#b45309' : '#059669';
    checkMatch();
}

function checkMatch() {
    const np  = document.getElementById('newPassword').value;
    const cp  = document.getElementById('confirmPassword').value;
    const lbl = document.getElementById('matchLabel');
    const btn = document.getElementById('pwSubmitBtn');
    if (!cp) { lbl.textContent = ''; return; }
    if (np === cp) {
        lbl.textContent = '✓ Passwords match';
        lbl.style.color = '#059669';
        btn.disabled = false;
    } else {
        lbl.textContent = '✗ Passwords do not match';
        lbl.style.color = '#dc2626';
        btn.disabled = true;
    }
}

// Prevent submit if passwords don't match
document.getElementById('pwForm').addEventListener('submit', function(e) {
    const np = document.getElementById('newPassword').value;
    const cp = document.getElementById('confirmPassword').value;
    if (np !== cp) {
        e.preventDefault();
        document.getElementById('matchLabel').textContent = '✗ Passwords do not match';
        document.getElementById('matchLabel').style.color = '#dc2626';
    }
});
</script>
</body>
</html>
