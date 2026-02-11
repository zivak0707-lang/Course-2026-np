<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="bg-gray-50 text-gray-900">

<div>

    <aside class="sidebar hidden lg:flex border-r border-gray-200 bg-white px-6 py-6">

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
            <a href="/dashboard/accounts" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900">
                <i data-lucide="credit-card" class="h-4 w-4"></i>
                My Accounts
            </a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900">
                <i data-lucide="credit-card" class="h-4 w-4"></i>
                My Cards
            </a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900">
                <i data-lucide="send" class="h-4 w-4"></i>
                Make Payment
            </a>
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900">
                <i data-lucide="list" class="h-4 w-4"></i>
                Transactions
            </a>
            <a href="/dashboard/settings" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 hover:text-gray-900">
                <i data-lucide="settings" class="h-4 w-4"></i>
                Settings
            </a>
        </nav>

        <div class="mt-auto border-t border-gray-200 pt-4">
            <a href="/dashboard/logout" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-red-50 hover:text-red-600">
                <i data-lucide="log-out" class="h-4 w-4"></i>
                Logout
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="flex h-16 items-center border-b border-gray-200 bg-white px-6 lg:hidden">
            <div class="font-bold text-blue-900">PayFlow</div>
        </header>

        <div class="container mx-auto max-w-7xl space-y-8 p-8 fade-in">

            <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between mb-8">
                <div>
                    <h1 class="text-3xl font-bold tracking-tight text-gray-900">Welcome back, ${user.firstName}! 👋</h1>
                    <p class="text-gray-500">Here's an overview of your finances.</p>
                </div>

                <div class="relative ml-auto sm:ml-0">
                    <button id="user-menu-button" type="button" class="flex items-center gap-2 rounded-full bg-white py-1 pl-1 pr-3 shadow-sm ring-1 ring-gray-200 hover:bg-gray-50 focus:outline-none">
                        <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-sm font-medium text-blue-700">
                            ${user.firstName?substring(0,1)}${user.lastName?substring(0,1)}
                        </span>
                        <span class="text-sm font-medium text-gray-700">${user.firstName} ${user.lastName}</span>
                        <i data-lucide="chevron-down" class="h-4 w-4 text-gray-400"></i>
                    </button>

                    <div id="user-menu-dropdown" class="hidden absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                        <div class="px-4 py-3 border-b border-gray-100">
                            <p class="text-sm text-gray-900 font-medium">${user.firstName} ${user.lastName}</p>
                            <p class="text-xs text-gray-500 truncate">${user.email}</p>
                        </div>
                        <a href="/dashboard/settings" class="flex items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                            <i data-lucide="settings" class="h-4 w-4"></i> Settings
                        </a>
                        <a href="/dashboard/logout" class="flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50">
                            <i data-lucide="log-out" class="h-4 w-4"></i> Logout
                        </a>
                    </div>
                </div>
            </div>

            <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Total Balance</div>
                        <i data-lucide="dollar-sign" class="h-4 w-4 text-gray-500"></i>
                    </div>
                    <div class="text-2xl font-bold text-gray-900">${totalBalance}</div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Active Cards</div>
                        <i data-lucide="credit-card" class="h-4 w-4 text-gray-500"></i>
                    </div>
                    <div class="text-2xl font-bold text-gray-900">${activeCards}</div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Pending</div>
                        <i data-lucide="clock" class="h-4 w-4 text-gray-500"></i>
                    </div>
                    <div class="text-2xl font-bold text-gray-900">${pendingCount}</div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
                    <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                        <div class="text-sm font-medium text-gray-500">Monthly Spending</div>
                        <i data-lucide="trending-down" class="h-4 w-4 text-gray-500"></i>
                    </div>
                    <div class="text-2xl font-bold text-gray-900">${monthlySpending}</div>
                </div>
            </div>

            <div class="flex gap-4">
                <a href="/dashboard/cards/add" class="inline-flex items-center justify-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                    <i data-lucide="plus" class="mr-2 h-4 w-4"></i> Add Card
                </a>
                <a href="/dashboard/payment" class="inline-flex items-center justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                    <i data-lucide="send" class="mr-2 h-4 w-4"></i> Make Payment
                </a>
            </div>

            <div class="rounded-xl border border-gray-200 bg-white shadow-sm">
                <div class="flex items-center justify-between border-b border-gray-200 p-6">
                    <h3 class="font-semibold leading-none tracking-tight text-gray-900">Recent Transactions</h3>
                    <a href="/dashboard/transactions" class="text-sm text-blue-600 hover:text-blue-800 hover:underline">View all</a>
                </div>
                <div class="relative w-full overflow-auto">
                    <table class="w-full caption-bottom text-sm">
                        <thead class="[&_tr]:border-b">
                        <tr class="border-b transition-colors hover:bg-gray-50/50 data-[state=selected]:bg-gray-50">
                            <th class="h-12 px-4 text-left align-middle font-medium text-gray-500">Date</th>
                            <th class="h-12 px-4 text-left align-middle font-medium text-gray-500">Description</th>
                            <th class="h-12 px-4 text-left align-middle font-medium text-gray-500">Type</th>
                            <th class="h-12 px-4 text-right align-middle font-medium text-gray-500">Amount</th>
                            <th class="h-12 px-4 text-left align-middle font-medium text-gray-500">Status</th>
                        </tr>
                        </thead>
                        <tbody class="[&_tr:last-child]:border-0">
                        <#if recentTransactions?? && (recentTransactions?size > 0)>
                            <#list recentTransactions as payment>
                                <tr class="border-b transition-colors hover:bg-gray-50/50">
                                    <td class="p-4 align-middle text-gray-600">
                                        <#if payment.createdAt??>
                                            <#assign monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]>
                                            ${monthNames[payment.createdAt.monthValue - 1]} ${payment.createdAt.dayOfMonth}, ${payment.createdAt.year?c}
                                        <#else>
                                            -
                                        </#if>
                                    </td>
                                    <td class="p-4 align-middle font-medium text-gray-900">${payment.description!"No description"}</td>
                                    <td class="p-4 align-middle">
                                        <#if payment.type?? && payment.type.name() == 'REPLENISHMENT'>
                                            <span class="inline-flex items-center rounded-full bg-blue-100 px-2.5 py-0.5 text-xs font-semibold text-blue-800">
                                                Replenishment
                                            </span>
                                        <#else>
                                            <span class="inline-flex items-center rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-semibold text-gray-800">
                                                Payment
                                            </span>
                                        </#if>
                                    </td>
                                    <td class="p-4 align-middle text-right font-medium">
                                        <#if payment.type?? && payment.type.name() == 'REPLENISHMENT'>
                                            <span class="text-green-600">+$${payment.amount}</span>
                                        <#else>
                                            <span class="text-red-600">-$${payment.amount}</span>
                                        </#if>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <#if payment.status?? && payment.status.name() == 'COMPLETED'>
                                            <span class="inline-flex items-center rounded-full bg-blue-600 px-2.5 py-0.5 text-xs font-semibold text-white">
                                                Completed
                                            </span>
                                        <#elseif payment.status?? && payment.status.name() == 'PENDING'>
                                            <span class="inline-flex items-center rounded-full bg-gray-500 px-2.5 py-0.5 text-xs font-semibold text-white">
                                                Pending
                                            </span>
                                        <#else>
                                            <span class="inline-flex items-center rounded-full bg-red-600 px-2.5 py-0.5 text-xs font-semibold text-white">
                                                Failed
                                            </span>
                                        </#if>
                                    </td>
                                </tr>
                            </#list>
                        <#else>
                            <tr>
                                <td colspan="5" class="p-8 text-center text-gray-500">
                                    No transactions found yet.
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
    lucide.createIcons();
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