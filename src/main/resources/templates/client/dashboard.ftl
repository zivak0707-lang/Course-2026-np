<#-- @ftlvariable name="user" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="totalBalance" type="java.lang.String" -->
<#-- @ftlvariable name="activeCards" type="java.lang.Long" -->
<#-- @ftlvariable name="pendingCount" type="java.lang.Long" -->
<#-- @ftlvariable name="monthlySpending" type="java.lang.String" -->
<#-- @ftlvariable name="recentTransactions" type="java.util.List<ua.com.kisit.course2026np.entity.Payment>" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; }
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
            <a href="/dashboard" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700">
                <i data-lucide="layout-dashboard" class="h-4 w-4"></i>
                Dashboard
            </a>
            <a href="/dashboard/accounts" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900 transition-colors">
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

        <div class="container mx-auto max-w-7xl space-y-8 animate-fade-in">

            <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                <div>
                    <h1 class="text-3xl font-bold tracking-tight text-gray-900">Welcome back, ${user.firstName}! 👋</h1>
                    <p class="text-gray-500 mt-1">Here's an overview of your finances.</p>
                </div>

                <div class="relative ml-auto sm:ml-0">
                    <button id="user-menu-button" type="button" class="flex items-center gap-2 rounded-full bg-white py-1 pl-1 pr-3 shadow-sm ring-1 ring-gray-200 hover:bg-gray-50 focus:outline-none transition-all">
                        <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-sm font-medium text-blue-700 uppercase">
                            ${user.firstName?substring(0,1)}${user.lastName?substring(0,1)}
                        </span>
                        <span class="text-sm font-medium text-gray-700">${user.firstName} ${user.lastName}</span>
                        <i data-lucide="chevron-down" class="h-4 w-4 text-gray-400"></i>
                    </button>

                    <div id="user-menu-dropdown" class="hidden absolute right-0 z-20 mt-2 w-56 origin-top-right rounded-lg bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none transition-all">
                        <div class="px-4 py-3 border-b border-gray-100">
                            <p class="text-sm text-gray-900 font-medium">${user.firstName} ${user.lastName}</p>
                            <p class="text-xs text-gray-500 truncate">${user.email}</p>
                        </div>
                        <a href="/dashboard/settings" class="flex items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                            <i data-lucide="settings" class="h-4 w-4"></i> Settings
                        </a>
                        <a href="/dashboard/logout" class="flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50">
                            <i data-lucide="log-out" class="h-4 w-4"></i> Logout
                        </a>
                    </div>
                </div>
            </div>

            <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Total Balance</div>
                        <div class="h-8 w-8 rounded-full bg-green-50 flex items-center justify-center">
                            <i data-lucide="dollar-sign" class="h-4 w-4 text-green-600"></i>
                        </div>
                    </div>
                    <div class="text-2xl font-bold text-gray-900 mt-2">${totalBalance}</div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Active Cards</div>
                        <div class="h-8 w-8 rounded-full bg-blue-50 flex items-center justify-center">
                            <i data-lucide="credit-card" class="h-4 w-4 text-blue-600"></i>
                        </div>
                    </div>
                    <div class="text-2xl font-bold text-gray-900 mt-2">${activeCards}</div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Pending</div>
                        <div class="h-8 w-8 rounded-full bg-orange-50 flex items-center justify-center">
                            <i data-lucide="clock" class="h-4 w-4 text-orange-600"></i>
                        </div>
                    </div>
                    <div class="text-2xl font-bold text-gray-900 mt-2">${pendingCount}</div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm hover:shadow-md transition-shadow">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Monthly Spending</div>
                        <div class="h-8 w-8 rounded-full bg-purple-50 flex items-center justify-center">
                            <i data-lucide="trending-down" class="h-4 w-4 text-purple-600"></i>
                        </div>
                    </div>
                    <div class="text-2xl font-bold text-gray-900 mt-2">${monthlySpending}</div>
                </div>
            </div>

            <div class="flex flex-col sm:flex-row gap-4">
                <#-- ВИПРАВЛЕНО: Тепер веде на сторінку карток, а не викликає помилку -->
                <a href="/dashboard/cards" class="inline-flex items-center justify-center rounded-lg bg-gray-900 px-5 py-2.5 text-sm font-medium text-white shadow hover:bg-black focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 transition-all">
                    <i data-lucide="plus" class="mr-2 h-4 w-4"></i> Add Card
                </a>
                <a href="/dashboard/payment" class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-5 py-2.5 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all">
                    <i data-lucide="send" class="mr-2 h-4 w-4"></i> Make Payment
                </a>
            </div>

            <div class="rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
                <div class="flex items-center justify-between border-b border-gray-200 p-6 bg-gray-50/50">
                    <h3 class="font-semibold leading-none tracking-tight text-gray-900">Recent Transactions</h3>
                    <a href="/dashboard/transactions" class="text-sm font-medium text-blue-600 hover:text-blue-800 hover:underline">View all</a>
                </div>
                <div class="relative w-full overflow-x-auto">
                    <table class="w-full caption-bottom text-sm">
                        <thead class="[&_tr]:border-b bg-gray-50/50">
                        <tr class="border-b transition-colors">
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Date</th>
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Description</th>
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Type</th>
                            <th class="h-12 px-6 text-right align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Amount</th>
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs pl-8">Status</th>
                        </tr>
                        </thead>
                        <tbody class="[&_tr:last-child]:border-0 bg-white">
                        <#if recentTransactions?? && (recentTransactions?size > 0)>
                            <#list recentTransactions as payment>
                                <tr class="border-b transition-colors hover:bg-gray-50/50">
                                    <td class="p-6 align-middle text-gray-600 font-mono text-xs">
                                        <#if payment.createdAt??>
                                            <#assign monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]>
                                            ${monthNames[payment.createdAt.monthValue - 1]} ${payment.createdAt.dayOfMonth}, ${payment.createdAt.year?c}
                                        <#else>
                                            -
                                        </#if>
                                    </td>
                                    <td class="p-6 align-middle font-medium text-gray-900">${payment.description!"No description"}</td>
                                    <td class="p-6 align-middle">
                                        <#if payment.type?? && payment.type.name() == 'REPLENISHMENT'>
                                            <span class="inline-flex items-center rounded-full bg-blue-50 px-2.5 py-0.5 text-xs font-semibold text-blue-700 border border-blue-200">
                                                Replenishment
                                            </span>
                                        <#else>
                                            <span class="inline-flex items-center rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-semibold text-gray-700 border border-gray-200">
                                                Payment
                                            </span>
                                        </#if>
                                    </td>
                                    <td class="p-6 align-middle text-right font-semibold">
                                        <#if payment.type?? && payment.type.name() == 'REPLENISHMENT'>
                                            <span class="text-emerald-600">+$${payment.amount}</span>
                                        <#else>
                                            <span class="text-gray-900">-$${payment.amount}</span>
                                        </#if>
                                    </td>
                                    <td class="p-6 align-middle pl-8">
                                        <#if payment.status?? && payment.status.name() == 'COMPLETED'>
                                            <div class="flex items-center gap-2">
                                                <div class="h-2 w-2 rounded-full bg-emerald-500"></div>
                                                <span class="text-xs font-medium text-gray-700">Completed</span>
                                            </div>
                                        <#elseif payment.status?? && payment.status.name() == 'PENDING'>
                                            <div class="flex items-center gap-2">
                                                <div class="h-2 w-2 rounded-full bg-yellow-500"></div>
                                                <span class="text-xs font-medium text-gray-700">Pending</span>
                                            </div>
                                        <#else>
                                            <div class="flex items-center gap-2">
                                                <div class="h-2 w-2 rounded-full bg-red-500"></div>
                                                <span class="text-xs font-medium text-gray-700">Failed</span>
                                            </div>
                                        </#if>
                                    </td>
                                </tr>
                            </#list>
                        <#else>
                            <tr>
                                <td colspan="5" class="p-12 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center gap-2">
                                        <i data-lucide="inbox" class="h-8 w-8 text-gray-300"></i>
                                        <p>No transactions found yet.</p>
                                    </div>
                                </td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>
</div>

<script>
    if (window.lucide) window.lucide.createIcons();
    document.addEventListener('DOMContentLoaded', function() {
        const button = document.getElementById('user-menu-button');
        const dropdown = document.getElementById('user-menu-dropdown');
        if (button && dropdown) {
            button.addEventListener('click', function(e) {
                e.stopPropagation();
                dropdown.classList.toggle('hidden');
            });
            document.addEventListener('click', function(e) {
                if (!button.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.classList.add('hidden');
                }
            });
        }
    });
</script>
</body>
</html>