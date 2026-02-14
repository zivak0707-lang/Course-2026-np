<#-- @ftlvariable name="user" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="accounts" type="java.util.List<ua.com.kisit.course2026np.entity.Account>" -->
<#-- @ftlvariable name="totalBalance" type="java.lang.String" -->
<#-- @ftlvariable name="activeCount" type="java.lang.Long" -->
<#-- @ftlvariable name="blockedCount" type="java.lang.Long" -->
<#-- @ftlvariable name="maxBalance" type="java.math.BigDecimal" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Accounts - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body {
            font-family: 'Inter', system-ui, sans-serif;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        
        /* Modal styles */
        .modal-backdrop {
            backdrop-filter: blur(4px);
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-900">

<div class="flex min-h-screen w-full">

    <aside class="sidebar hidden lg:flex flex-col border-r border-gray-200 bg-white px-6 py-6 w-64 fixed h-full z-20 top-0 left-0">

        <div class="mb-8 flex items-center gap-2 px-2">
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-600 text-white">
                <i data-lucide="wallet" class="h-5 w-5"></i>
            </div>
            <span class="text-xl font-bold tracking-tight text-blue-900">PayFlow</span>
        </div>

        <nav class="flex flex-1 flex-col space-y-1">
            <a href="/dashboard" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900 transition-colors">
                <i data-lucide="layout-dashboard" class="h-4 w-4"></i>
                Dashboard
            </a>
            <a href="/dashboard/accounts" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700">
                <i data-lucide="landmark" class="h-4 w-4"></i>
                My Accounts
            </a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900 transition-colors">
                <i data-lucide="credit-card" class="h-4 w-4"></i>
                My Cards
            </a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900 transition-colors">
                <i data-lucide="send" class="h-4 w-4"></i>
                Make Payment
            </a>
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900 transition-colors">
                <i data-lucide="receipt" class="h-4 w-4"></i>
                Transactions
            </a>
            <a href="/dashboard/settings" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900 transition-colors">
                <i data-lucide="settings" class="h-4 w-4"></i>
                Settings
            </a>
        </nav>

        <div class="mt-auto border-t border-gray-200 pt-4">
            <a href="/dashboard/logout" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-red-50 hover:text-red-600 transition-colors">
                <i data-lucide="log-out" class="h-4 w-4"></i>
                Logout
            </a>
        </div>
    </aside>

    <main class="main-content flex-1 lg:ml-64 p-8 overflow-y-auto">
        <header class="flex h-16 items-center border-b border-gray-200 bg-white px-6 lg:hidden mb-6 rounded-lg shadow-sm">
            <div class="font-bold text-blue-900">PayFlow</div>
        </header>

        <div class="container mx-auto max-w-7xl space-y-6 animate-fade-in">

            <#if successMessage??>
                <div class="rounded-lg bg-green-50 border border-green-200 p-4 flex items-center gap-3">
                    <div class="flex-shrink-0">
                        <i data-lucide="check-circle" class="h-5 w-5 text-green-600"></i>
                    </div>
                    <p class="text-sm font-medium text-green-800">${successMessage}</p>
                </div>
            </#if>

            <#if errorMessage??>
                <div class="rounded-lg bg-red-50 border border-red-200 p-4 flex items-center gap-3">
                    <div class="flex-shrink-0">
                        <i data-lucide="alert-circle" class="h-5 w-5 text-red-600"></i>
                    </div>
                    <p class="text-sm font-medium text-red-800">${errorMessage}</p>
                </div>
            </#if>

            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-bold">My Accounts</h1>
                    <p class="text-sm text-gray-500 mt-1">Manage your accounts and track balances</p>
                </div>
                <button onclick="openAddAccountModal()" class="inline-flex items-center justify-center rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all">
                    <i data-lucide="plus" class="h-4 w-4 mr-1"></i> Add Account
                </button>
            </div>

            <div class="grid sm:grid-cols-3 gap-4">
                <div class="rounded-xl border border-gray-200 bg-white shadow-sm">
                    <div class="pt-5 pb-4 px-6">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-blue-600/10 flex items-center justify-center">
                                <i data-lucide="wallet" class="h-5 w-5 text-blue-600"></i>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500">Total Balance</p>
                                <p class="text-xl font-bold">${totalBalance}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white shadow-sm">
                    <div class="pt-5 pb-4 px-6">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-green-600/10 flex items-center justify-center">
                                <i data-lucide="trending-up" class="h-5 w-5 text-green-600"></i>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500">Active Accounts</p>
                                <p class="text-xl font-bold">${activeCount}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white shadow-sm">
                    <div class="pt-5 pb-4 px-6">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-red-600/10 flex items-center justify-center">
                                <i data-lucide="lock" class="h-5 w-5 text-red-600"></i>
                            </div>
                            <div>
                                <p class="text-xs text-gray-500">Blocked Accounts</p>
                                <p class="text-xl font-bold">${blockedCount}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="flex gap-2">
                <button onclick="filterAccounts('all')" id="filter-all" class="capitalize inline-flex items-center justify-center rounded-lg bg-gray-900 px-4 py-2 text-sm font-medium text-white shadow hover:bg-black focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 transition-all">
                    All
                </button>
                <button onclick="filterAccounts('active')" id="filter-active" class="capitalize inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all">
                    Active <span class="ml-1.5 text-xs opacity-70">(${activeCount})</span>
                </button>
                <button onclick="filterAccounts('blocked')" id="filter-blocked" class="capitalize inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all">
                    Blocked <span class="ml-1.5 text-xs opacity-70">(${blockedCount})</span>
                </button>
            </div>

            <div id="accounts-grid" class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
                <#if accounts?? && (accounts?size > 0)>
                    <#list accounts as account>
                    <#-- Calculate balance percentage for progress bar -->
                        <#if maxBalance?? && maxBalance gt 0>
                            <#assign balancePercent = (account.balance / maxBalance * 100)?round>
                        <#else>
                            <#assign balancePercent = 0>
                        </#if>

                        <#if balancePercent gt 100><#assign balancePercent = 100></#if>

                    <#-- Determine account type icon and name from accountName field -->
                        <#assign accountType = account.accountName!"Checking">
                        <#assign accountIcon = "credit-card">
                        <#assign accountTypeLower = accountType?lower_case>
                        <#if accountTypeLower?contains("saving")>
                            <#assign accountIcon = "piggy-bank">
                        <#elseif accountTypeLower?contains("business")>
                            <#assign accountIcon = "building-2">
                        </#if>

                        <div class="account-card group relative overflow-hidden transition-all duration-300 hover:shadow-lg cursor-pointer rounded-xl border border-gray-200 bg-white ${account.status.name()}"
                             data-status="${account.status.name()?lower_case}"
                             data-account-name="${accountType}"
                             data-account-icon="${accountIcon}"
                             onclick="showAccountDetails('${account.id}', this)">
                            <div class="p-6 space-y-4">
                                <div class="flex items-start justify-between">
                                    <div class="flex items-center gap-3">
                                        <div class="w-9 h-9 rounded-lg bg-blue-600/10 flex items-center justify-center text-blue-600">
                                            <i data-lucide="${accountIcon}" class="h-5 w-5"></i>
                                        </div>
                                        <div>
                                            <p class="font-semibold text-sm">${accountType}</p>
                                            <div class="flex items-center gap-1.5">
                                                <p class="text-xs font-mono text-gray-500">
                                                    ****${account.accountNumber?substring(account.accountNumber?length - 4)}
                                                </p>
                                                <button onclick="event.stopPropagation(); copyAccountNumber('${account.accountNumber}', this)" class="text-gray-400 hover:text-blue-600 transition-colors">
                                                    <i data-lucide="copy" class="h-3 w-3"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <#if account.status.name() == 'ACTIVE'>
                                        <span class="inline-flex items-center rounded-full bg-blue-600 px-2.5 py-0.5 text-xs font-semibold text-white capitalize">
                                            Active
                                        </span>
                                    <#else>
                                        <span class="inline-flex items-center rounded-full bg-red-600 px-2.5 py-0.5 text-xs font-semibold text-white capitalize">
                                            Blocked
                                        </span>
                                    </#if>
                                </div>

                                <div>
                                    <div class="flex items-center gap-2 mb-1">
                                        <p class="text-2xl font-bold tracking-tight balance-amount" data-account-id="${account.id}">
                                            ••••••
                                        </p>
                                        <p class="text-2xl font-bold tracking-tight balance-revealed hidden" data-account-id="${account.id}">
                                            $${account.balance?string("#,##0.00")}
                                        </p>
                                        <button onclick="event.stopPropagation(); toggleBalance('${account.id}')" class="text-gray-500 hover:text-gray-900 transition-colors">
                                            <i data-lucide="eye" class="h-4 w-4 balance-icon-hidden" data-account-id="${account.id}"></i>
                                            <i data-lucide="eye-off" class="h-4 w-4 balance-icon-revealed hidden" data-account-id="${account.id}"></i>
                                        </button>
                                    </div>
                                    <div class="w-full bg-gray-200 rounded-full h-1.5">
                                        <div class="bg-blue-600 h-1.5 rounded-full" style="width: ${balancePercent}%"></div>
                                    </div>
                                </div>

                                <div class="flex gap-2 pt-1 opacity-0 group-hover:opacity-100 transition-opacity duration-200">
                                    <#if account.status.name() == 'ACTIVE'>
                                        <button onclick="event.stopPropagation(); blockAccount('${account.id}')" class="flex-1 inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-3 py-2 text-xs h-8 font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all">
                                            <i data-lucide="lock" class="h-3 w-3 mr-1"></i> Block
                                        </button>
                                    <#else>
                                        <button onclick="event.stopPropagation(); unblockAccount('${account.id}')" class="flex-1 inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-3 py-2 text-xs h-8 font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all">
                                            <i data-lucide="unlock" class="h-3 w-3 mr-1"></i> Unblock
                                        </button>
                                    </#if>
                                    <button onclick="event.stopPropagation(); deleteAccount('${account.id}', '${account.balance}')" class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-3 py-2 text-xs h-8 text-red-600 hover:bg-red-50 hover:border-red-600 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-all">
                                        <i data-lucide="trash-2" class="h-3 w-3"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </#list>
                </#if>
            </div>

            <div id="empty-state" class="text-center py-12 text-gray-500 hidden">
                <i data-lucide="wallet" class="h-12 w-12 mx-auto mb-3 opacity-30"></i>
                <p class="font-medium">No accounts found</p>
                <p class="text-sm mt-1">Try changing the filter or add a new account.</p>
            </div>

        </div>
    </main>
</div>

<!-- 🆕 Modal для додавання акаунту -->
<div id="addAccountModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50 modal-backdrop">
    <div class="bg-white rounded-xl shadow-2xl max-w-md w-full mx-4 p-6 space-y-4">
        <div class="flex items-center justify-between">
            <h3 class="text-lg font-semibold">Add New Account</h3>
            <button onclick="closeAddAccountModal()" class="text-gray-400 hover:text-gray-600">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>
        <p class="text-sm text-gray-500">Choose an account type to get started</p>

        <div class="grid grid-cols-3 gap-3">
            <button type="button" onclick="selectAccountType('Checking')" class="account-type-btn flex flex-col items-center gap-2 p-4 rounded-xl border-2 border-gray-200 hover:border-blue-600 transition-all duration-200" data-type="Checking">
                <div class="w-10 h-10 rounded-lg bg-gray-100 flex items-center justify-center text-gray-600">
                    <i data-lucide="credit-card" class="h-5 w-5"></i>
                </div>
                <span class="text-sm font-medium">Checking</span>
            </button>
            <button type="button" onclick="selectAccountType('Savings')" class="account-type-btn flex flex-col items-center gap-2 p-4 rounded-xl border-2 border-gray-200 hover:border-blue-600 transition-all duration-200" data-type="Savings">
                <div class="w-10 h-10 rounded-lg bg-gray-100 flex items-center justify-center text-gray-600">
                    <i data-lucide="piggy-bank" class="h-5 w-5"></i>
                </div>
                <span class="text-sm font-medium">Savings</span>
            </button>
            <button type="button" onclick="selectAccountType('Business')" class="account-type-btn flex flex-col items-center gap-2 p-4 rounded-xl border-2 border-gray-200 hover:border-blue-600 transition-all duration-200" data-type="Business">
                <div class="w-10 h-10 rounded-lg bg-gray-100 flex items-center justify-center text-gray-600">
                    <i data-lucide="building-2" class="h-5 w-5"></i>
                </div>
                <span class="text-sm font-medium">Business</span>
            </button>
        </div>

        <form method="POST" action="/api/accounts/create" id="addAccountForm">
            <input type="hidden" id="accountTypeInput" name="accountType" required>
            <div class="flex gap-3 pt-2">
                <button type="button" onclick="closeAddAccountModal()" class="flex-1 inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
                    Cancel
                </button>
                <button type="submit" id="submitAccountBtn" disabled class="flex-1 inline-flex items-center justify-center rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed">
                    Create Account
                </button>
            </div>
        </form>
    </div>
</div>

<!-- 🆕 Modal для деталей акаунту -->
<div id="accountDetailsModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50 modal-backdrop">
    <div class="bg-white rounded-xl shadow-2xl max-w-md w-full mx-4 overflow-hidden">
        <div class="flex items-center justify-between p-6 border-b border-gray-200">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-lg bg-blue-600/10 flex items-center justify-center text-blue-600">
                    <i id="modal-account-icon" data-lucide="credit-card" class="h-5 w-5"></i>
                </div>
                <h3 id="modal-account-title" class="text-lg font-semibold">Account Details</h3>
            </div>
            <button onclick="closeAccountDetailsModal()" class="text-gray-400 hover:text-gray-600">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>

        <div class="p-6 space-y-6">
            <!-- Account Number -->
            <div>
                <div class="flex items-center justify-between mb-1">
                    <p class="text-xs text-gray-500 font-medium">Account Number</p>
                    <span id="modal-status" class="inline-flex items-center rounded-full bg-blue-600 px-2.5 py-0.5 text-xs font-semibold text-white">
                        Active
                    </span>
                </div>
                <p id="modal-account-number" class="text-sm font-mono text-gray-900">452178341234123</p>
            </div>

            <!-- Balance -->
            <div>
                <p class="text-xs text-gray-500 font-medium mb-1">Balance</p>
                <p id="modal-balance" class="text-3xl font-bold text-gray-900">$12,450.00</p>
            </div>

            <!-- Recent Activity -->
            <div>
                <p class="text-sm font-semibold text-gray-900 mb-3">RECENT ACTIVITY</p>
                <div id="modal-activity" class="space-y-3">
                    <!-- Transactions will be loaded here -->
                    <div class="flex justify-center py-8">
                        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="p-6 border-t border-gray-200">
            <button onclick="closeAccountDetailsModal()" class="w-full inline-flex items-center justify-center rounded-lg bg-gray-100 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-200 transition-all">
                Close
            </button>
        </div>
    </div>
</div>

<script src="/js/main.js"></script>
<script>
    // Initialize Lucide icons
    lucide.createIcons();

    // Filter accounts
    function filterAccounts(status) {
        const cards = document.querySelectorAll('.account-card');
        const emptyState = document.getElementById('empty-state');
        const filterButtons = ['filter-all', 'filter-active', 'filter-blocked'];

        // Update button styles
        filterButtons.forEach(btnId => {
            const btn = document.getElementById(btnId);
            if (btnId === 'filter-' + status) {
                btn.classList.remove('border', 'border-gray-300', 'bg-white', 'text-gray-700');
                btn.classList.add('bg-gray-900', 'text-white');
            } else {
                btn.classList.remove('bg-gray-900', 'text-white');
                btn.classList.add('border', 'border-gray-300', 'bg-white', 'text-gray-700');
            }
        });

        let visibleCount = 0;
        cards.forEach(card => {
            const cardStatus = card.getAttribute('data-status');
            if (status === 'all' || cardStatus === status) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        emptyState.classList.toggle('hidden', visibleCount > 0);
        lucide.createIcons();
    }

    // Toggle balance visibility
    function toggleBalance(accountId) {
        const hidden = document.querySelector('.balance-amount[data-account-id="' + accountId + '"]');
        const revealed = document.querySelector('.balance-revealed[data-account-id="' + accountId + '"]');
        const iconHidden = document.querySelector('.balance-icon-hidden[data-account-id="' + accountId + '"]');
        const iconRevealed = document.querySelector('.balance-icon-revealed[data-account-id="' + accountId + '"]');

        hidden.classList.toggle('hidden');
        revealed.classList.toggle('hidden');
        iconHidden.classList.toggle('hidden');
        iconRevealed.classList.toggle('hidden');
    }

    // Copy account number
    function copyAccountNumber(accountNumber, button) {
        navigator.clipboard.writeText(accountNumber).then(() => {
            const icon = button.querySelector('i');
            icon.setAttribute('data-lucide', 'check');
            lucide.createIcons();

            setTimeout(() => {
                icon.setAttribute('data-lucide', 'copy');
                lucide.createIcons();
            }, 2000);
        });
    }

    // Block account
    function blockAccount(accountId) {
        if (confirm('Are you sure you want to block this account?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/api/accounts/' + accountId + '/block';
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Unblock account
    function unblockAccount(accountId) {
        if (confirm('Are you sure you want to unblock this account?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/api/accounts/' + accountId + '/unblock';
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Delete account
    function deleteAccount(accountId, balance) {
        if (parseFloat(balance) > 0) {
            alert('Cannot delete account with positive balance. Please withdraw all funds first.');
            return;
        }

        if (confirm('Are you sure you want to delete this account? This action cannot be undone.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/api/accounts/' + accountId + '/delete';
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Add Account Modal functions
    function openAddAccountModal() {
        document.getElementById('addAccountModal').classList.remove('hidden');
        document.getElementById('addAccountModal').classList.add('flex');
    }

    function closeAddAccountModal() {
        document.getElementById('addAccountModal').classList.add('hidden');
        document.getElementById('addAccountModal').classList.remove('flex');
        document.getElementById('accountTypeInput').value = '';
        document.getElementById('submitAccountBtn').disabled = true;
        document.querySelectorAll('.account-type-btn').forEach(btn => {
            btn.classList.remove('border-blue-600', 'bg-blue-50');
            btn.classList.add('border-gray-200');
        });
    }

    function selectAccountType(type) {
        document.getElementById('accountTypeInput').value = type;
        document.getElementById('submitAccountBtn').disabled = false;

        document.querySelectorAll('.account-type-btn').forEach(btn => {
            if (btn.getAttribute('data-type') === type) {
                btn.classList.remove('border-gray-200');
                btn.classList.add('border-blue-600', 'bg-blue-50');
            } else {
                btn.classList.remove('border-blue-600', 'bg-blue-50');
                btn.classList.add('border-gray-200');
            }
        });
    }

    // Helper function to format date
    function formatDate(dateString) {
        const options = { year: 'numeric', month: 'short', day: 'numeric' };
        return new Date(dateString).toLocaleDateString('en-US', options);
    }

    // 🆕 Show account details modal
    // cardElement is passed from onclick so we can read data-account-name / data-account-icon
    function showAccountDetails(accountId, cardElement) {
        const modal = document.getElementById('accountDetailsModal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');

        // --- Immediately update title & icon from the clicked card's data attributes ---
        if (cardElement) {
            const name = cardElement.getAttribute('data-account-name') || 'Account Details';
            const icon = cardElement.getAttribute('data-account-icon') || 'credit-card';

            document.getElementById('modal-account-title').textContent = name;

            const iconEl = document.getElementById('modal-account-icon');
            iconEl.setAttribute('data-lucide', icon);
            lucide.createIcons();  // re-render the new icon immediately
        }

        // Show loading spinner for activity
        document.getElementById('modal-activity').innerHTML = 
            '<div class="flex justify-center py-8">' +
                '<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>' +
            '</div>';

        // Fetch full account details from API
        fetch('/api/accounts/' + accountId + '/details')
            .then(response => response.json())
            .then(data => {
                // Update number, balance, status
                document.getElementById('modal-account-number').textContent = data.accountNumber;
                document.getElementById('modal-balance').textContent = '$' + parseFloat(data.balance).toFixed(2);
                document.getElementById('modal-status').textContent = data.status;
                document.getElementById('modal-status').className = data.status === 'ACTIVE' 
                    ? 'inline-flex items-center rounded-full bg-blue-600 px-2.5 py-0.5 text-xs font-semibold text-white'
                    : 'inline-flex items-center rounded-full bg-red-600 px-2.5 py-0.5 text-xs font-semibold text-white';

                // If the API returns accountName, update title too (keeps in sync with DB)
                if (data.accountName) {
                    document.getElementById('modal-account-title').textContent = data.accountName;
                    // Update icon based on accountName
                    const nameLower = data.accountName.toLowerCase();
                    const resolvedIcon = nameLower.includes('saving') ? 'piggy-bank'
                                      : nameLower.includes('business') ? 'building-2'
                                      : 'credit-card';
                    document.getElementById('modal-account-icon').setAttribute('data-lucide', resolvedIcon);
                }

                // Render recent activity
                const activityHtml = data.recentActivity && data.recentActivity.length > 0
                    ? data.recentActivity.map(payment => {
                        const isIncoming = payment.type && payment.type === 'REPLENISHMENT';
                        const iconName = isIncoming ? 'arrow-down-left' : 'arrow-up-right';
                        const iconColor = isIncoming ? 'text-green-600' : 'text-red-600';
                        const iconBg = isIncoming ? 'bg-green-50' : 'bg-red-50';
                        const amountColor = isIncoming ? 'text-green-600' : 'text-red-600';
                        const amountSign = isIncoming ? '+' : '-';

                        return '<div class="flex items-center justify-between">' +
                                '<div class="flex items-center gap-3">' +
                                    '<div class="w-8 h-8 rounded-lg ' + iconBg + ' flex items-center justify-center ' + iconColor + '">' +
                                        '<i data-lucide="' + iconName + '" class="h-4 w-4"></i>' +
                                    '</div>' +
                                    '<div>' +
                                        '<p class="text-sm font-medium text-gray-900">' + (payment.description || payment.type) + '</p>' +
                                        '<p class="text-xs text-gray-500">' + formatDate(payment.createdAt) + '</p>' +
                                    '</div>' +
                                '</div>' +
                                '<p class="text-sm font-semibold ' + amountColor + '">' + amountSign + '$' + parseFloat(payment.amount).toFixed(2) + '</p>' +
                            '</div>';
                    }).join('')
                    : '<p class="text-sm text-gray-500 text-center py-4">No recent transactions</p>';

                document.getElementById('modal-activity').innerHTML = activityHtml;
                lucide.createIcons();
            })
            .catch(error => {
                console.error('Error fetching account details:', error);
                document.getElementById('modal-activity').innerHTML = '<p class="text-sm text-red-500 text-center py-4">Error loading transactions</p>';
            });
    }

    // 🆕 Close account details modal
    function closeAccountDetailsModal() {
        document.getElementById('accountDetailsModal').classList.add('hidden');
        document.getElementById('accountDetailsModal').classList.remove('flex');
    }
</script>

</body>
</html>
