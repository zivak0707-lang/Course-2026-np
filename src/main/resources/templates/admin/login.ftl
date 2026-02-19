<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login — PayFlow</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #1e1b4b 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: #fff;
            border-radius: 16px;
            padding: 48px 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.35);
        }
        .brand-icon {
            width: 56px; height: 56px;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 20px;
        }
        .brand-icon i { font-size: 26px; color: #fff; }
        .form-control {
            border-radius: 10px; padding: 12px 16px;
            border: 1.5px solid #e5e7eb; font-size: 0.9rem;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-control:focus {
            border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79,70,229,.15);
        }
        .input-group-text {
            border-radius: 10px 0 0 10px; border: 1.5px solid #e5e7eb;
            border-right: none; background: #f9fafb; color: #6b7280;
        }
        .input-group .form-control { border-radius: 0 10px 10px 0; border-left: none; }
        .input-group:focus-within .input-group-text {
            border-color: #4f46e5;
        }
        .btn-login {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border: none; border-radius: 10px; padding: 13px;
            font-size: 0.95rem; font-weight: 600; color: #fff;
            width: 100%; transition: opacity .2s, transform .1s;
        }
        .btn-login:hover { opacity: 0.92; transform: translateY(-1px); color: #fff; }
        .btn-login:active { transform: translateY(0); }
        .form-label { font-size: 0.85rem; font-weight: 500; color: #374151; margin-bottom: 6px; }
        .back-link { font-size: 0.82rem; color: #6b7280; }
        .back-link a { color: #4f46e5; text-decoration: none; font-weight: 500; }
        .back-link a:hover { text-decoration: underline; }
        #togglePassword { cursor: pointer; border: 1.5px solid #e5e7eb;
            border-left: none; border-radius: 0 10px 10px 0; background: #f9fafb; }
    </style>
</head>
<body>

<div class="login-card">
    <div class="text-center mb-4">
        <div class="brand-icon">
            <i class="bi bi-shield-lock-fill"></i>
        </div>
        <h4 class="fw-bold mb-1" style="color:#1e1b4b">Admin Panel</h4>
        <p class="text-muted small mb-0">Sign in with your administrator credentials</p>
    </div>

    <#if error??>
        <div class="alert alert-danger d-flex align-items-center gap-2 py-2 px-3 rounded-3 mb-3" style="font-size:.85rem">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <span>${error}</span>
        </div>
    </#if>

    <form method="post" action="/admin/login" autocomplete="on">
        <div class="mb-3">
            <label class="form-label" for="email">Email address</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="admin@company.com" required autofocus
                       value="${(RequestParameters.email)!}">
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label" for="password">Password</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="Enter your password" required>
                <button type="button" id="togglePassword" class="btn btn-outline-secondary px-3">
                    <i class="bi bi-eye" id="eyeIcon"></i>
                </button>
            </div>
        </div>

        <button type="submit" class="btn btn-login mb-3">
            <i class="bi bi-box-arrow-in-right me-2"></i>Sign in to Admin Panel
        </button>
    </form>

    <div class="text-center back-link">
        <a href="/"><i class="bi bi-arrow-left me-1"></i>Back to PayFlow</a>
    </div>
</div>

<script>
    document.getElementById('togglePassword').addEventListener('click', function () {
        const pw = document.getElementById('password');
        const icon = document.getElementById('eyeIcon');
        if (pw.type === 'password') {
            pw.type = 'text';
            icon.className = 'bi bi-eye-slash';
        } else {
            pw.type = 'password';
            icon.className = 'bi bi-eye';
        }
    });
</script>
</body>
</html>
