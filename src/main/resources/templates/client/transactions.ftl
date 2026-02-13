<#-- @ftlvariable name="user" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="payments" type="java.util.List<ua.com.kisit.course2026np.entity.Payment>" -->
<#-- @ftlvariable name="currentPage" type="java.lang.Integer" -->
<#-- @ftlvariable name="totalPages" type="java.lang.Integer" -->
<#-- @ftlvariable name="totalItems" type="java.lang.Long" -->
<#-- @ftlvariable name="pageSize" type="java.lang.Integer" -->
<#-- @ftlvariable name="hasNext" type="java.lang.Boolean" -->
<#-- @ftlvariable name="hasPrevious" type="java.lang.Boolean" -->
<#-- @ftlvariable name="searchQuery" type="java.lang.String" -->
<#-- @ftlvariable name="selectedType" type="java.lang.String" -->
<#-- @ftlvariable name="selectedStatus" type="java.lang.String" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="bg-gray-50 text-gray-900">

<div class="flex min-h-screen w-full">

    <!-- SIDEBAR - Identical to dashboard -->
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
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700">
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

    <!-- MAIN CONTENT -->
    <main class="main-content flex-1 lg:ml-64 p-8 overflow-y-auto">
        <!-- Mobile Header -->
        <header class="flex h-16 items-center border-b border-gray-200 bg-white px-6 lg:hidden mb-6 rounded-lg shadow-sm">
            <div class="font-bold text-blue-900">PayFlow</div>
        </header>

        <div class="container mx-auto max-w-7xl space-y-8 animate-fade-in">

            <!-- Page Header -->
            <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                <div>
                    <h1 class="text-3xl font-bold tracking-tight text-gray-900">Transaction History</h1>
                    <p class="text-gray-500 mt-1">View and manage all your transactions</p>
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

            <!-- Filters and Actions -->
            <div class="rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
                <div class="p-6">
                    <form method="GET" action="/dashboard/transactions" class="space-y-4">
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <!-- Search Input -->
                            <div class="md:col-span-1">
                                <label for="search" class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                                <div class="relative">
                                    <input
                                        type="text"
                                        id="search"
                                        name="search"
                                        value="${searchQuery}"
                                        placeholder="Search transactions..."
                                        class="w-full rounded-lg border border-gray-300 px-4 py-2 pl-10 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
                                    />
                                    <i data-lucide="search" class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400"></i>
                                </div>
                            </div>

                            <!-- Type Filter -->
                            <div>
                                <label for="type" class="block text-sm font-medium text-gray-700 mb-2">Type</label>
                                <select
                                    id="type"
                                    name="type"
                                    class="w-full rounded-lg border border-gray-300 px-4 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
                                >
                                    <option value="ALL" <#if selectedType == "ALL">selected</#if>>All Types</option>
                                    <option value="PAYMENT" <#if selectedType == "PAYMENT">selected</#if>>Payment</option>
                                    <option value="REPLENISHMENT" <#if selectedType == "REPLENISHMENT">selected</#if>>Replenishment</option>
                                </select>
                            </div>

                            <!-- Status Filter -->
                            <div>
                                <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                                <select
                                    id="status"
                                    name="status"
                                    class="w-full rounded-lg border border-gray-300 px-4 py-2 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
                                >
                                    <option value="ALL" <#if selectedStatus == "ALL">selected</#if>>All Status</option>
                                    <option value="COMPLETED" <#if selectedStatus == "COMPLETED">selected</#if>>Completed</option>
                                    <option value="PENDING" <#if selectedStatus == "PENDING">selected</#if>>Pending</option>
                                    <option value="FAILED" <#if selectedStatus == "FAILED">selected</#if>>Failed</option>
                                </select>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex items-end gap-2">
                                <button
                                    type="submit"
                                    class="flex-1 inline-flex items-center justify-center rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all"
                                >
                                    <i data-lucide="filter" class="mr-2 h-4 w-4"></i>
                                    Filter
                                </button>
                                <a
                                    href="/dashboard/transactions"
                                    class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all"
                                    title="Clear filters"
                                >
                                    <i data-lucide="x" class="h-4 w-4"></i>
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Transactions Table -->
            <div class="rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
                <div class="flex items-center justify-between border-b border-gray-200 p-6 bg-gray-50/50">
                    <div>
                        <h3 class="font-semibold leading-none tracking-tight text-gray-900">All Transactions</h3>
                        <p class="text-sm text-gray-500 mt-1">Showing ${payments?size} of ${totalItems} transactions</p>
                    </div>
                    <a
                        href="/api/payments/export/csv"
                        class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all"
                    >
                        <i data-lucide="download" class="mr-2 h-4 w-4"></i>
                        Export CSV
                    </a>
                </div>

                <div class="relative w-full overflow-x-auto">
                    <table class="w-full caption-bottom text-sm">
                        <thead class="[&_tr]:border-b bg-gray-50/50">
                        <tr class="border-b transition-colors">
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Date & Time</th>
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Description</th>
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Type</th>
                            <th class="h-12 px-6 text-right align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Amount</th>
                            <th class="h-12 px-6 text-left align-middle font-medium text-gray-500 uppercase tracking-wider text-xs pl-8">Status</th>
                            <th class="h-12 px-6 text-center align-middle font-medium text-gray-500 uppercase tracking-wider text-xs">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="[&_tr:last-child]:border-0 bg-white">
                        <#if payments?? && (payments?size > 0)>
                            <#list payments as payment>
                                <tr class="border-b transition-colors hover:bg-gray-50/50" data-payment-id="${payment.id?c}">
                                    <!-- Date & Time -->
                                    <td class="p-6 align-middle text-gray-600 font-mono text-xs">
                                        <#if payment.createdAt??>
                                            <div class="font-medium text-gray-900">
                                                ${payment.createdAt.dayOfMonth?string["00"]}.${payment.createdAt.monthValue?string["00"]}.${payment.createdAt.year?c}
                                            </div>
                                            <div class="text-gray-500">
                                                ${payment.createdAt.hour?string["00"]}:${payment.createdAt.minute?string["00"]}
                                            </div>
                                        <#else>
                                            <span class="text-gray-400">-</span>
                                        </#if>
                                    </td>

                                    <!-- Description -->
                                    <td class="p-6 align-middle">
                                        <div class="font-medium text-gray-900">${payment.description!"No description"}</div>
                                        <#if payment.transactionId??>
                                            <div class="text-xs text-gray-500 font-mono mt-1">${payment.transactionId}</div>
                                        </#if>
                                    </td>

                                    <!-- Type -->
                                    <td class="p-6 align-middle">
                                        <#if payment.type?? && payment.type.name() == 'REPLENISHMENT'>
                                            <span class="inline-flex items-center rounded-full bg-blue-50 px-2.5 py-0.5 text-xs font-semibold text-blue-700 border border-blue-200">
                                                <i data-lucide="arrow-down-circle" class="mr-1 h-3 w-3"></i>
                                                Replenishment
                                            </span>
                                        <#else>
                                            <span class="inline-flex items-center rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-semibold text-gray-700 border border-gray-200">
                                                <i data-lucide="arrow-up-circle" class="mr-1 h-3 w-3"></i>
                                                Payment
                                            </span>
                                        </#if>
                                    </td>

                                    <!-- Amount -->
                                    <td class="p-6 align-middle text-right">
                                        <#if payment.type?? && payment.type.name() == 'REPLENISHMENT'>
                                            <span class="text-lg font-bold text-emerald-600">+$${payment.amount}</span>
                                        <#else>
                                            <span class="text-lg font-bold text-red-600">-$${payment.amount}</span>
                                        </#if>
                                    </td>

                                    <!-- Status -->
                                    <td class="p-6 align-middle pl-8">
                                        <#if payment.status?? && payment.status.name() == 'COMPLETED'>
                                            <span class="inline-flex items-center rounded-full bg-emerald-50 px-2.5 py-0.5 text-xs font-semibold text-emerald-700 border border-emerald-200">
                                                <span class="mr-1.5 h-1.5 w-1.5 rounded-full bg-emerald-600"></span>
                                                Completed
                                            </span>
                                        <#elseif payment.status?? && payment.status.name() == 'PENDING'>
                                            <span class="inline-flex items-center rounded-full bg-yellow-50 px-2.5 py-0.5 text-xs font-semibold text-yellow-700 border border-yellow-200">
                                                <span class="mr-1.5 h-1.5 w-1.5 rounded-full bg-yellow-600"></span>
                                                Pending
                                            </span>
                                        <#else>
                                            <span class="inline-flex items-center rounded-full bg-red-50 px-2.5 py-0.5 text-xs font-semibold text-red-700 border border-red-200">
                                                <span class="mr-1.5 h-1.5 w-1.5 rounded-full bg-red-600"></span>
                                                Failed
                                            </span>
                                        </#if>
                                    </td>

                                    <!-- Actions -->
                                    <td class="p-6 align-middle text-center">
                                        <button
                                            onclick="showPaymentDetails('${payment.id?c}', '${payment.transactionId!""}', '${payment.description!"No description"}', '${payment.type.name()}', '${payment.amount}', '${payment.status.name()}', '${payment.senderAccount!"N/A"}', '${payment.recipientAccount!"N/A"}', '<#if payment.createdAt??>${payment.createdAt.dayOfMonth?string["00"]}.${payment.createdAt.monthValue?string["00"]}.${payment.createdAt.year?c} ${payment.createdAt.hour?string["00"]}:${payment.createdAt.minute?string["00"]}<#else>N/A</#if>', '${payment.errorMessage!""}')"
                                            class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-3 py-1.5 text-xs font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all"
                                        >
                                            <i data-lucide="eye" class="mr-1 h-3 w-3"></i>
                                            Details
                                        </button>
                                    </td>
                                </tr>
                            </#list>
                        <#else>
                            <tr>
                                <td colspan="6" class="p-12 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center gap-3">
                                        <i data-lucide="inbox" class="h-12 w-12 text-gray-300"></i>
                                        <div>
                                            <p class="font-medium text-gray-900">No transactions found</p>
                                            <p class="text-sm text-gray-500 mt-1">Try adjusting your filters or search query</p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <#if totalPages gt 1>
                    <div class="border-t border-gray-200 bg-gray-50/50 px-6 py-4">
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-700">
                                Showing page <span class="font-medium">${currentPage + 1}</span> of <span class="font-medium">${totalPages}</span>
                            </div>

                            <nav class="flex items-center gap-2">
                                <!-- Previous Button -->
                                <#if hasPrevious>
                                    <a
                                        href="?page=${currentPage - 1}&size=${pageSize}<#if searchQuery?has_content>&search=${searchQuery}</#if><#if selectedType != 'ALL'>&type=${selectedType}</#if><#if selectedStatus != 'ALL'>&status=${selectedStatus}</#if>"
                                        class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all"
                                    >
                                        <i data-lucide="chevron-left" class="h-4 w-4"></i>
                                    </a>
                                <#else>
                                    <button
                                        disabled
                                        class="inline-flex items-center justify-center rounded-lg border border-gray-200 bg-gray-100 px-3 py-2 text-sm font-medium text-gray-400 cursor-not-allowed"
                                    >
                                        <i data-lucide="chevron-left" class="h-4 w-4"></i>
                                    </button>
                                </#if>

                                <!-- Page Numbers -->
                                <div class="hidden sm:flex items-center gap-1">
                                    <#assign startPage = ((currentPage - 2) < 0)?then(0, currentPage - 2)>
                                    <#assign endPage = ((startPage + 4) > (totalPages - 1))?then(totalPages - 1, startPage + 4)>
                                    <#assign startPage = ((endPage - 4) < 0)?then(0, endPage - 4)>

                                    <#list startPage..endPage as pageNum>
                                        <#if pageNum == currentPage>
                                            <span class="inline-flex items-center justify-center rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow">
                                                ${pageNum + 1}
                                            </span>
                                        <#else>
                                            <a
                                                href="?page=${pageNum}&size=${pageSize}<#if searchQuery?has_content>&search=${searchQuery}</#if><#if selectedType != 'ALL'>&type=${selectedType}</#if><#if selectedStatus != 'ALL'>&status=${selectedStatus}</#if>"
                                                class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all"
                                            >
                                                ${pageNum + 1}
                                            </a>
                                        </#if>
                                    </#list>
                                </div>

                                <!-- Next Button -->
                                <#if hasNext>
                                    <a
                                        href="?page=${currentPage + 1}&size=${pageSize}<#if searchQuery?has_content>&search=${searchQuery}</#if><#if selectedType != 'ALL'>&type=${selectedType}</#if><#if selectedStatus != 'ALL'>&status=${selectedStatus}</#if>"
                                        class="inline-flex items-center justify-center rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all"
                                    >
                                        <i data-lucide="chevron-right" class="h-4 w-4"></i>
                                    </a>
                                <#else>
                                    <button
                                        disabled
                                        class="inline-flex items-center justify-center rounded-lg border border-gray-200 bg-gray-100 px-3 py-2 text-sm font-medium text-gray-400 cursor-not-allowed"
                                    >
                                        <i data-lucide="chevron-right" class="h-4 w-4"></i>
                                    </button>
                                </#if>
                            </nav>
                        </div>
                    </div>
                </#if>
            </div>

        </div>
    </main>
</div>

<!-- MODAL for Payment Details -->
<div id="payment-modal" class="hidden fixed inset-0 z-50 overflow-y-auto">
    <div class="flex min-h-screen items-center justify-center p-4">
        <!-- Backdrop -->
        <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" onclick="closePaymentModal()"></div>
        
        <!-- Modal Content -->
        <div class="relative bg-white rounded-xl shadow-2xl max-w-2xl w-full p-6 animate-scale-in">
            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-2xl font-bold text-gray-900">Transaction Details</h2>
                <button onclick="closePaymentModal()" class="text-gray-400 hover:text-gray-600 transition-colors">
                    <i data-lucide="x" class="h-6 w-6"></i>
                </button>
            </div>

            <!-- Content -->
            <div class="space-y-6">
                <!-- Transaction ID -->
                <div class="bg-gray-50 rounded-lg p-4">
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-medium text-gray-500">Transaction ID</span>
                        <span id="modal-txn-id" class="text-sm font-mono text-gray-900"></span>
                    </div>
                </div>

                <!-- Details Grid -->
                <div class="grid grid-cols-2 gap-4">
                    <!-- Type -->
                    <div>
                        <div class="text-sm font-medium text-gray-500 mb-1">Type</div>
                        <div id="modal-type" class="text-base font-semibold text-gray-900"></div>
                    </div>

                    <!-- Status -->
                    <div>
                        <div class="text-sm font-medium text-gray-500 mb-1">Status</div>
                        <div id="modal-status"></div>
                    </div>

                    <!-- Amount -->
                    <div>
                        <div class="text-sm font-medium text-gray-500 mb-1">Amount</div>
                        <div id="modal-amount" class="text-2xl font-bold"></div>
                    </div>

                    <!-- Date -->
                    <div>
                        <div class="text-sm font-medium text-gray-500 mb-1">Date & Time</div>
                        <div id="modal-date" class="text-base text-gray-900"></div>
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <div class="text-sm font-medium text-gray-500 mb-2">Description</div>
                    <div id="modal-description" class="text-base text-gray-900 bg-gray-50 rounded-lg p-3"></div>
                </div>

                <!-- Accounts -->
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <div class="text-sm font-medium text-gray-500 mb-2">From Account</div>
                        <div id="modal-from" class="text-xs font-mono text-gray-900 bg-gray-50 rounded-lg p-3"></div>
                    </div>
                    <div>
                        <div class="text-sm font-medium text-gray-500 mb-2">To Account</div>
                        <div id="modal-to" class="text-xs font-mono text-gray-900 bg-gray-50 rounded-lg p-3"></div>
                    </div>
                </div>

                <!-- Error Message (if failed) -->
                <div id="modal-error-container" class="hidden">
                    <div class="text-sm font-medium text-red-500 mb-2">Error Message</div>
                    <div id="modal-error" class="text-sm text-red-700 bg-red-50 rounded-lg p-3 border border-red-200"></div>
                </div>
            </div>

            <!-- Footer -->
            <div class="mt-6 flex justify-end gap-3">
                <button onclick="closePaymentModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors">
                    Close
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Initialize Lucide icons
    lucide.createIcons();

    // User menu dropdown
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

        // Reinitialize icons after any DOM updates
        setTimeout(() => lucide.createIcons(), 100);
    });

    // Payment details modal
    function showPaymentDetails(id, txnId, description, type, amount, status, from, to, date, error) {
        const modal = document.getElementById('payment-modal');
        
        // Set transaction ID
        document.getElementById('modal-txn-id').textContent = txnId || 'N/A';
        
        // Set type
        document.getElementById('modal-type').textContent = type === 'REPLENISHMENT' ? 'Replenishment' : 'Payment';
        
        // Set status badge
        const statusEl = document.getElementById('modal-status');
        if (status === 'COMPLETED') {
            statusEl.innerHTML = '<span class="inline-flex items-center rounded-full bg-emerald-50 px-3 py-1 text-sm font-semibold text-emerald-700 border border-emerald-200"><span class="mr-1.5 h-2 w-2 rounded-full bg-emerald-600"></span>Completed</span>';
        } else if (status === 'PENDING') {
            statusEl.innerHTML = '<span class="inline-flex items-center rounded-full bg-yellow-50 px-3 py-1 text-sm font-semibold text-yellow-700 border border-yellow-200"><span class="mr-1.5 h-2 w-2 rounded-full bg-yellow-600"></span>Pending</span>';
        } else {
            statusEl.innerHTML = '<span class="inline-flex items-center rounded-full bg-red-50 px-3 py-1 text-sm font-semibold text-red-700 border border-red-200"><span class="mr-1.5 h-2 w-2 rounded-full bg-red-600"></span>Failed</span>';
        }
        
        // Set amount with color
        const amountEl = document.getElementById('modal-amount');
        if (type === 'REPLENISHMENT') {
            amountEl.className = 'text-2xl font-bold text-emerald-600';
            amountEl.textContent = '+$' + amount;
        } else {
            amountEl.className = 'text-2xl font-bold text-red-600';
            amountEl.textContent = '-$' + amount;
        }
        
        // Set other fields
        document.getElementById('modal-date').textContent = date;
        document.getElementById('modal-description').textContent = description;
        document.getElementById('modal-from').textContent = from || 'N/A';
        document.getElementById('modal-to').textContent = to || 'N/A';
        
        // Show error if exists
        const errorContainer = document.getElementById('modal-error-container');
        if (error && error.trim() !== '') {
            document.getElementById('modal-error').textContent = error;
            errorContainer.classList.remove('hidden');
        } else {
            errorContainer.classList.add('hidden');
        }
        
        // Show modal
        modal.classList.remove('hidden');
        
        // Reinitialize icons
        setTimeout(() => lucide.createIcons(), 50);
    }

    function closePaymentModal() {
        document.getElementById('payment-modal').classList.add('hidden');
    }

    // Close modal on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closePaymentModal();
        }
    });
</script>
</body>
</html>
