<#-- @ftlvariable name="user" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="successMessage" type="java.lang.String" -->
<#-- @ftlvariable name="errorMessage" type="java.lang.String" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - PayFlow</title>
    <link rel="stylesheet" href="/css/style.css">

    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        /* Стилі для перемикачів */
        .toggle-checkbox:checked {
            right: 0;
            border-color: #2563EB;
        }
        .toggle-checkbox:checked + .toggle-label {
            background-color: #2563EB;
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-900">

<div class="flex min-h-screen w-full">

    <aside class="sidebar hidden w-64 flex-col border-r border-gray-200 bg-white px-6 py-6 lg:flex">
        <div class="mb-8 flex items-center gap-2 px-2">
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-600 text-white">
                <i data-lucide="wallet" class="h-5 w-5"></i>
            </div>
            <span class="text-xl font-bold tracking-tight text-blue-900">PayFlow</span>
        </div>
        <nav class="flex flex-1 flex-col space-y-1">
            <a href="/dashboard" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
                <i data-lucide="layout-dashboard" class="h-4 w-4"></i> Dashboard
            </a>
            <a href="/dashboard/accounts" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
                <i data-lucide="landmark" class="h-4 w-4"></i> My Accounts
            </a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
                <i data-lucide="credit-card" class="h-4 w-4"></i> My Cards
            </a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
                <i data-lucide="send" class="h-4 w-4"></i> Make Payment
            </a>
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
                <i data-lucide="receipt" class="h-4 w-4"></i> Transactions
            </a>
            <a href="/dashboard/settings" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700">
                <i data-lucide="settings" class="h-4 w-4"></i> Settings
            </a>
        </nav>
        <div class="mt-auto border-t border-gray-200 pt-4">
            <a href="/dashboard/logout" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-red-50 hover:text-red-600">
                <i data-lucide="log-out" class="h-4 w-4"></i> Logout
            </a>
        </div>
    </aside>

    <main class="main-content flex-1 overflow-auto p-8">

        <div class="mx-auto max-w-4xl space-y-8">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">Settings</h1>
                    <p class="text-gray-500">Manage your account settings and preferences.</p>
                </div>
            </div>

            <#if successMessage??>
                <div class="rounded-md bg-green-50 p-4 border border-green-200">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <i data-lucide="check-circle" class="h-5 w-5 text-green-400"></i>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm font-medium text-green-800">${successMessage}</p>
                        </div>
                    </div>
                </div>
            </#if>

            <#if errorMessage??>
                <div class="rounded-md bg-red-50 p-4 border border-red-200">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <i data-lucide="x-circle" class="h-5 w-5 text-red-400"></i>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm font-medium text-red-800">${errorMessage}</p>
                        </div>
                    </div>
                </div>
            </#if>

            <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
                <div class="mb-6">
                    <h2 class="text-lg font-semibold text-gray-900">Profile Information</h2>
                </div>
                <form action="/dashboard/settings/update-profile" method="POST" class="space-y-6">
                    <div class="grid gap-6 md:grid-cols-2">
                        <div class="space-y-2">
                            <label class="text-sm font-medium leading-none" for="firstName">First Name</label>
                            <input class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   id="firstName" name="firstName" value="${(user.firstName)!''}" placeholder="John" required>
                        </div>
                        <div class="space-y-2">
                            <label class="text-sm font-medium leading-none" for="lastName">Last Name</label>
                            <input class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   id="lastName" name="lastName" value="${(user.lastName)!''}" placeholder="Doe" required>
                        </div>
                    </div>

                    <div class="space-y-2">
                        <label class="text-sm font-medium leading-none" for="email">Email</label>
                        <input class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                               id="email" name="email" value="${(user.email)!''}" placeholder="john@example.com" required>
                    </div>

                    <button type="submit" class="inline-flex items-center justify-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                        Save Changes
                    </button>
                </form>
            </div>

            <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
                <div class="mb-6">
                    <h2 class="text-lg font-semibold text-gray-900">Notifications</h2>
                </div>
                <div class="space-y-6">
                    <div class="flex items-center justify-between space-x-2">
                        <div class="flex flex-col space-y-1">
                            <span class="text-sm font-medium leading-none">Email Notifications</span>
                            <span class="text-sm text-gray-500">Receive email alerts for transactions</span>
                        </div>
                        <div class="relative inline-block w-10 mr-2 align-middle select-none transition duration-200 ease-in">
                            <input type="checkbox" name="emailNotif" id="emailNotif" class="toggle-checkbox absolute block w-5 h-5 rounded-full bg-white border-4 appearance-none cursor-pointer border-gray-300 checked:right-0 checked:border-blue-600 transition-all duration-200" checked/>
                            <label for="emailNotif" class="toggle-label block overflow-hidden h-5 rounded-full bg-blue-600 cursor-pointer transition-colors duration-200"></label>
                        </div>
                    </div>

                    <div class="flex items-center justify-between space-x-2">
                        <div class="flex flex-col space-y-1">
                            <span class="text-sm font-medium leading-none">Push Notifications</span>
                            <span class="text-sm text-gray-500">Get push alerts on your device</span>
                        </div>
                        <div class="relative inline-block w-10 mr-2 align-middle select-none transition duration-200 ease-in">
                            <input type="checkbox" name="pushNotif" id="pushNotif" class="toggle-checkbox absolute block w-5 h-5 rounded-full bg-white border-4 appearance-none cursor-pointer border-gray-300 transition-all duration-200"/>
                            <label for="pushNotif" class="toggle-label block overflow-hidden h-5 rounded-full bg-gray-300 cursor-pointer transition-colors duration-200"></label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
                <div class="mb-4">
                    <h2 class="text-lg font-semibold text-gray-900">Security</h2>
                    <p class="text-sm text-gray-500 mt-1">Change your password. You\'ll need to enter your current password to confirm.</p>
                </div>
                <form action="/dashboard/settings/update-password" method="POST" class="space-y-5" id="pwForm">
                    <!-- Current password -->
                    <div class="space-y-1">
                        <label class="text-sm font-medium text-gray-700" for="currentPassword">Current Password</label>
                        <div class="relative">
                            <input type="password"
                                   class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 pr-10 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   id="currentPassword" name="currentPassword" placeholder="Enter current password" required>
                            <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-blue-600 transition-colors" onclick="togglePw('currentPassword', this)">
                                <i data-lucide="eye" class="h-4 w-4"></i>
                            </button>
                        </div>
                    </div>

                    <!-- New password -->
                    <div class="space-y-1">
                        <label class="text-sm font-medium text-gray-700" for="newPassword">New Password</label>
                        <div class="relative">
                            <input type="password"
                                   class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 pr-10 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   id="newPassword" name="newPassword" placeholder="Min. 6 characters" required
                                   oninput="checkStrength(this.value)">
                            <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-blue-600 transition-colors" onclick="togglePw('newPassword', this)">
                                <i data-lucide="eye" class="h-4 w-4"></i>
                            </button>
                        </div>
                        <!-- Strength bar -->
                        <div class="h-1 w-full bg-gray-100 rounded-full overflow-hidden mt-2">
                            <div id="strengthFill" class="h-full rounded-full transition-all duration-300" style="width:0%"></div>
                        </div>
                        <p id="strengthLabel" class="text-xs text-gray-400 mt-1">Enter a new password</p>
                    </div>

                    <!-- Confirm password -->
                    <div class="space-y-1">
                        <label class="text-sm font-medium text-gray-700" for="confirmPassword">Confirm New Password</label>
                        <div class="relative">
                            <input type="password"
                                   class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 pr-10 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   id="confirmPassword" placeholder="Repeat new password" required
                                   oninput="checkMatch()">
                            <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-blue-600 transition-colors" onclick="togglePw('confirmPassword', this)">
                                <i data-lucide="eye" class="h-4 w-4"></i>
                            </button>
                        </div>
                        <p id="matchLabel" class="text-xs mt-1"></p>
                    </div>

                    <button type="submit" id="pwSubmitBtn"
                            class="inline-flex items-center justify-center gap-2 rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                        <i data-lucide="shield-check" class="h-4 w-4"></i>
                        Update Password
                    </button>
                </form>
            </div>

        </div>
    </main>
</div>

<script>
    // Init lucide icons
    if (window.lucide) {
        window.lucide.createIcons();
    } else {
        window.addEventListener('load', function() {
            if (window.lucide) window.lucide.createIcons();
        });
    }

    // Toggle switches
    function updateToggle(toggle) {
        const label = toggle.nextElementSibling;
        if (toggle.checked) {
            label.classList.remove('bg-gray-300');
            label.classList.add('bg-blue-600');
        } else {
            label.classList.add('bg-gray-300');
            label.classList.remove('bg-blue-600');
        }
    }
    document.querySelectorAll('.toggle-checkbox').forEach(toggle => {
        updateToggle(toggle);
        toggle.addEventListener('change', function() { updateToggle(this); });
    });

    // Show/hide password
    function togglePw(id, btn) {
        const input = document.getElementById(id);
        const icon  = btn.querySelector('[data-lucide]');
        if (input.type === 'password') {
            input.type = 'text';
            icon.setAttribute('data-lucide', 'eye-off');
        } else {
            input.type = 'password';
            icon.setAttribute('data-lucide', 'eye');
        }
        lucide.createIcons();
    }

    // Password strength
    function checkStrength(val) {
        const fill  = document.getElementById('strengthFill');
        const label = document.getElementById('strengthLabel');
        let score = 0;
        if (val.length >= 6)           score++;
        if (val.length >= 10)          score++;
        if (/[A-Z]/.test(val))         score++;
        if (/[0-9]/.test(val))         score++;
        if (/[^A-Za-z0-9]/.test(val))  score++;

        const levels = [
            { pct: '0%',   bg: 'transparent', text: 'Enter a new password',  color: '#9ca3af' },
            { pct: '20%',  bg: '#ef4444',     text: 'Very weak',              color: '#dc2626' },
            { pct: '40%',  bg: '#f97316',     text: 'Weak',                   color: '#ea580c' },
            { pct: '60%',  bg: '#eab308',     text: 'Fair',                   color: '#ca8a04' },
            { pct: '80%',  bg: '#22c55e',     text: 'Strong',                 color: '#16a34a' },
            { pct: '100%', bg: '#16a34a',     text: 'Very strong ✓',          color: '#15803d' },
        ];
        const lvl = val.length === 0 ? 0 : Math.min(score, 5);
        fill.style.width      = levels[lvl].pct;
        fill.style.background = levels[lvl].bg;
        label.textContent     = levels[lvl].text;
        label.style.color     = levels[lvl].color;
        checkMatch();
    }

    // Confirm match
    function checkMatch() {
        const np  = document.getElementById('newPassword').value;
        const cp  = document.getElementById('confirmPassword').value;
        const lbl = document.getElementById('matchLabel');
        const btn = document.getElementById('pwSubmitBtn');
        if (!cp) { lbl.textContent = ''; return; }
        if (np === cp) {
            lbl.textContent  = '✓ Passwords match';
            lbl.style.color  = '#16a34a';
            btn.disabled     = false;
        } else {
            lbl.textContent  = '✗ Passwords do not match';
            lbl.style.color  = '#dc2626';
            btn.disabled     = true;
        }
    }

    // Block submit if mismatch
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