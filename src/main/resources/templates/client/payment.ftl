<#-- @ftlvariable name="user" type="ua.com.kisit.course2026np.entity.User" -->
<#-- @ftlvariable name="accounts" type="java.util.List<ua.com.kisit.course2026np.entity.Account>" -->
<#-- @ftlvariable name="recentPayments" type="java.util.List<ua.com.kisit.course2026np.entity.Payment>" -->

<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in { animation: fadeIn 0.4s ease-out forwards; }

        /* Custom radio-button type selector */
        .type-radio { display: none; }
        .type-label {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            padding: 10px 0; border-radius: 8px; cursor: pointer; font-size: .875rem;
            font-weight: 500; color: #6b7280; background: #f9fafb;
            border: 1.5px solid #e5e7eb; transition: all .18s; user-select: none;
        }
        .type-label:hover { border-color: #93c5fd; color: #1d4ed8; background: #eff6ff; }
        .type-radio:checked + .type-label {
            border-color: #2563eb; background: #eff6ff; color: #1d4ed8;
        }
        .type-radio.replenishment:checked + .type-label {
            border-color: #10b981; background: #ecfdf5; color: #065f46;
        }

        /* Amount input big */
        .amount-input {
            font-size: 1.5rem; font-weight: 700; padding-left: 2rem;
            border: 1.5px solid #e5e7eb; border-radius: 8px;
            transition: border-color .15s, box-shadow .15s;
            outline: none; width: 100%; background: #f9fafb;
        }
        .amount-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,.1);
            background: #fff;
        }
        .amount-input.error { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,.1); }

        /* Text inputs unified */
        .pay-input {
            width: 100%; padding: 10px 14px; font-size: .9rem;
            border: 1.5px solid #e5e7eb; border-radius: 8px; background: #f9fafb;
            transition: border-color .15s, box-shadow .15s; outline: none;
        }
        .pay-input:focus {
            border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,.1); background: #fff;
        }

        /* Select */
        .pay-select {
            width: 100%; padding: 10px 14px; font-size: .9rem; font-weight: 500;
            border: 1.5px solid #e5e7eb; border-radius: 8px; background: #f9fafb;
            appearance: none; cursor: pointer;
            transition: border-color .15s, box-shadow .15s; outline: none;
        }
        .pay-select:focus {
            border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,.1); background: #fff;
        }

        /* Submit button */
        .btn-submit {
            width: 100%; padding: 13px; border-radius: 8px; border: none;
            background: #2563eb; color: #fff; font-size: .95rem; font-weight: 600;
            cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px;
            transition: background .18s, transform .12s, box-shadow .18s;
            box-shadow: 0 4px 14px rgba(37,99,235,.25);
        }
        .btn-submit:hover { background: #1d4ed8; transform: translateY(-1px); box-shadow: 0 6px 18px rgba(37,99,235,.3); }
        .btn-submit:active { transform: translateY(0); }
        .btn-submit:disabled { opacity: .55; cursor: not-allowed; transform: none; box-shadow: none; }

        /* Spinner */
        @keyframes spin { to { transform: rotate(360deg); } }
        .spin { animation: spin .7s linear infinite; }
    </style>
</head>
<body class="bg-gray-50 text-gray-900">

<div class="flex min-h-screen w-full">

    <!-- ===== SIDEBAR (точна копія cards.ftl) ===== -->
    <aside class="sidebar hidden lg:flex flex-col border-r border-gray-200 bg-white px-6 py-6 w-64 fixed h-full z-20 top-0 left-0">
        <div class="mb-8 flex items-center gap-2 px-2">
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-600 text-white">
                <i data-lucide="wallet" class="h-5 w-5"></i>
            </div>
            <span class="text-xl font-bold tracking-tight text-blue-900">PayFlow</span>
        </div>
        <nav class="flex flex-1 flex-col space-y-1">
            <a href="/dashboard" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="layout-dashboard" class="h-4 w-4"></i> Dashboard
            </a>
            <a href="/dashboard/accounts" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="landmark" class="h-4 w-4"></i> My Accounts
            </a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="credit-card" class="h-4 w-4"></i> My Cards
            </a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700 transition-colors">
                <i data-lucide="send" class="h-4 w-4"></i> Make Payment
            </a>
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="receipt" class="h-4 w-4"></i> Transactions
            </a>
            <a href="/dashboard/settings" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="settings" class="h-4 w-4"></i> Settings
            </a>
        </nav>
        <div class="mt-auto border-t border-gray-200 pt-4">
            <a href="/dashboard/logout" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-red-50 hover:text-red-600 transition-colors">
                <i data-lucide="log-out" class="h-4 w-4"></i> Logout
            </a>
        </div>
    </aside>

    <!-- ===== MAIN ===== -->
    <main class="flex-1 lg:ml-64 p-8 overflow-y-auto min-h-screen">

        <!-- Flash alerts -->
        <#if successMessage??>
        <div id="alert-box" class="mb-6 rounded-lg bg-emerald-50 p-4 border border-emerald-200 flex items-center gap-3 shadow-sm animate-fade-in">
            <i data-lucide="check-circle" class="h-5 w-5 text-emerald-600 flex-shrink-0"></i>
            <p class="text-sm font-medium text-emerald-800">${successMessage}</p>
        </div>
        </#if>
        <#if errorMessage??>
        <div id="alert-box" class="mb-6 rounded-lg bg-red-50 p-4 border border-red-200 flex items-center gap-3 shadow-sm animate-fade-in">
            <i data-lucide="alert-circle" class="h-5 w-5 text-red-600 flex-shrink-0"></i>
            <p class="text-sm font-medium text-red-800">${errorMessage}</p>
        </div>
        </#if>

        <div class="max-w-6xl mx-auto animate-fade-in">

            <!-- Page header -->
            <div class="mb-8">
                <h1 class="text-2xl font-bold text-gray-900">Make Payment</h1>
                <p class="text-gray-500 mt-1">Send money or top up your account</p>
            </div>

            <!-- No accounts warning -->
            <#if !accounts?? || accounts?size == 0>
            <div class="rounded-lg bg-amber-50 border border-amber-200 p-5 flex items-start gap-3 mb-8">
                <i data-lucide="triangle-alert" class="h-5 w-5 text-amber-500 flex-shrink-0 mt-0.5"></i>
                <div>
                    <p class="font-semibold text-amber-800">No active accounts found</p>
                    <p class="text-sm text-amber-700 mt-1">You need a card with an active account to make payments.</p>
                    <a href="/dashboard/cards" class="inline-flex items-center gap-1.5 mt-3 text-sm font-semibold text-amber-800 underline underline-offset-2">
                        <i data-lucide="plus" class="h-3.5 w-3.5"></i> Add a card
                    </a>
                </div>
            </div>
            </#if>

            <div class="grid lg:grid-cols-3 gap-6">

                <!-- ===== FORM (2/3) ===== -->
                <div class="lg:col-span-2">
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">

                        <!-- Recent recipients bar (якщо є) -->
                        <#if recentPayments?? && recentPayments?size gt 0>
                        <div class="px-6 pt-5 pb-4 border-b border-gray-100 bg-gray-50/60">
                            <p class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-1.5">
                                <i data-lucide="clock" class="h-3.5 w-3.5"></i> Recent recipients
                            </p>
                            <div class="flex flex-wrap gap-2">
                                <#list recentPayments as p>
                                <#if p.recipientAccount??>
                                <button type="button"
                                        onclick="selectRecipient('${p.recipientAccount}', '${p.description!''}')"
                                        class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white border border-gray-200 text-xs font-medium text-gray-700 hover:border-blue-400 hover:bg-blue-50 hover:text-blue-700 transition-all">
                                    <span class="w-5 h-5 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-[10px] font-bold">
                                        ${p.recipientAccount?substring(0,1)?upper_case}
                                    </span>
                                    <#if p.recipientAccount?length gt 18>
                                        ${p.recipientAccount?substring(0,18)}…
                                    <#else>
                                        ${p.recipientAccount}
                                    </#if>
                                </button>
                                </#if>
                                </#list>
                            </div>
                        </div>
                        </#if>

                        <!-- Form body -->
                        <form id="paymentForm" action="/dashboard/payment/submit" method="POST" class="p-6 space-y-6">

                            <!-- 1. From account -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
                                    From account <span class="text-red-500">*</span>
                                </label>
                                <#if accounts?? && accounts?size gt 0>
                                <div class="relative">
                                    <select name="accountId" id="accountSelect"
                                            class="pay-select pr-10"
                                            required
                                            onchange="onAccountChange(this)">
                                        <option value="">— Select account —</option>
                                        <#list accounts as acc>
                                        <option value="${acc.id}"
                                                data-balance="${acc.balance}"
                                                data-name="${acc.accountName}"
                                                data-number="${acc.accountNumber}">
                                            ${acc.accountName} · ****${acc.accountNumber?substring(acc.accountNumber?length - 4)} · $${acc.balance?string("0.00")}
                                        </option>
                                        </#list>
                                    </select>
                                    <div class="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-gray-400">
                                        <i data-lucide="chevron-down" class="h-4 w-4"></i>
                                    </div>
                                </div>
                                <!-- Balance info block (visible after account selected) -->
                                <div id="balanceBlock" class="hidden mt-3 rounded-lg border border-gray-100 bg-gray-50 px-4 py-3">
                                    <div class="flex items-center justify-between mb-2">
                                        <div class="flex items-center gap-1.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                                            <i data-lucide="wallet" class="h-3.5 w-3.5"></i> Available balance
                                        </div>
                                        <span id="balanceValue" class="text-base font-extrabold text-gray-900">$0.00</span>
                                    </div>
                                    <!-- Progress bar: how much of balance will be spent -->
                                    <div class="w-full bg-gray-200 rounded-full h-1.5 overflow-hidden">
                                        <div id="balanceBar" class="h-1.5 rounded-full bg-blue-500 transition-all duration-300" style="width: 0%"></div>
                                    </div>
                                    <div id="balanceAfterRow" class="hidden mt-2 flex items-center justify-between text-xs text-gray-500">
                                        <span>After payment</span>
                                        <span id="balanceAfterValue" class="font-semibold text-gray-700">$0.00</span>
                                    </div>
                                    <p id="insufficientMsg" class="hidden mt-2 text-xs font-semibold text-red-600 flex items-center gap-1">
                                        <i data-lucide="alert-circle" class="h-3.5 w-3.5"></i>
                                        <span id="insufficientText"></span>
                                    </p>
                                </div>
                                <#else>
                                <p class="text-sm text-gray-400 mt-1">No active accounts</p>
                                </#if>
                            </div>

                            <!-- 2. Payment type -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
                                    Operation type <span class="text-red-500">*</span>
                                </label>
                                <div class="grid grid-cols-2 gap-3">
                                    <div>
                                        <input type="radio" name="type" id="typePayment" value="PAYMENT"
                                               class="type-radio" checked onchange="onTypeChange()">
                                        <label for="typePayment" class="type-label">
                                            <i data-lucide="arrow-up-circle" class="h-4 w-4"></i> Payment
                                        </label>
                                    </div>
                                    <div>
                                        <input type="radio" name="type" id="typeReplenishment" value="REPLENISHMENT"
                                               class="type-radio replenishment" onchange="onTypeChange()">
                                        <label for="typeReplenishment" class="type-label">
                                            <i data-lucide="arrow-down-circle" class="h-4 w-4"></i> Top Up
                                        </label>
                                    </div>
                                </div>
                                <p id="feeHint" class="mt-2 text-xs text-gray-400 flex items-center gap-1">
                                    <i data-lucide="info" class="h-3.5 w-3.5"></i>
                                    A <strong class="text-gray-600">1.5% fee</strong> is applied to payments
                                </p>
                            </div>

                            <!-- 3. Recipient -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2" for="recipientInput">
                                    Recipient account <span class="text-red-500">*</span>
                                </label>
                                <input type="text"
                                       id="recipientInput"
                                       name="recipientAccount"
                                       class="pay-input"
                                       placeholder="Enter account number or name"
                                       required
                                       maxlength="50"
                                       oninput="updateSummary()">
                                <p class="mt-1.5 text-xs text-gray-400">e.g. UA123456789012345678901234</p>
                            </div>

                            <!-- 4. Amount -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2" for="amountInput">
                                    Amount <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 font-bold text-lg pointer-events-none">$</span>
                                    <input type="number"
                                           id="amountInput"
                                           name="amount"
                                           class="amount-input"
                                           placeholder="0.00"
                                           step="0.01" min="0.01"
                                           required
                                           oninput="updateSummary(); validateBalance()">
                                </div>
                                <p id="amountError" class="hidden mt-1.5 text-xs text-red-600 flex items-center gap-1">
                                    <i data-lucide="alert-circle" class="h-3.5 w-3.5"></i>
                                    <span id="amountErrorText"></span>
                                </p>
                            </div>

                            <!-- 5. Description -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2" for="descInput">
                                    Description <span class="text-gray-300 font-normal normal-case">(optional)</span>
                                </label>
                                <textarea id="descInput" name="description"
                                          class="pay-input resize-none"
                                          rows="2" maxlength="200"
                                          placeholder="Payment purpose..."
                                          oninput="updateSummary(); document.getElementById('descCounter').textContent = this.value.length + ' / 200'"></textarea>
                                <div class="flex justify-end mt-1">
                                    <span id="descCounter" class="text-xs text-gray-400">0 / 200</span>
                                </div>
                            </div>

                            <!-- Submit -->
                            <button type="submit" id="submitBtn" class="btn-submit"
                                    <#if !accounts?? || accounts?size == 0>disabled</#if>>
                                <i data-lucide="send" class="h-4 w-4" id="btnIcon"></i>
                                <span id="btnText">Send Payment</span>
                            </button>

                        </form>
                    </div>
                </div>

                <!-- ===== SUMMARY SIDEBAR (1/3) ===== -->
                <div class="space-y-4">

                    <!-- Summary card -->
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                        <!-- Header -->
                        <div class="bg-gradient-to-br from-blue-700 to-blue-500 px-5 py-5 text-white">
                            <p class="text-xs font-semibold uppercase tracking-widest opacity-75 mb-1">Payment Summary</p>
                            <p class="text-3xl font-extrabold leading-none" id="summaryTotal">$0.00</p>
                            <p class="text-xs opacity-70 mt-1">Total to pay</p>
                        </div>
                        <!-- Rows -->
                        <div class="px-5 py-4 space-y-3">
                            <div class="flex items-center justify-between text-sm">
                                <span class="text-gray-500">Recipient</span>
                                <span class="font-semibold text-gray-800 text-right max-w-[130px] truncate" id="summaryRecipient">—</span>
                            </div>
                            <div class="flex items-center justify-between text-sm border-t border-dashed border-gray-100 pt-3">
                                <span class="text-gray-500">Type</span>
                                <span id="summaryType" class="inline-flex items-center gap-1 text-xs font-bold px-2 py-0.5 rounded-full bg-blue-50 text-blue-700">Payment</span>
                            </div>
                            <div class="flex items-center justify-between text-sm border-t border-dashed border-gray-100 pt-3">
                                <span class="text-gray-500">Amount</span>
                                <span class="font-semibold text-gray-800" id="summaryAmount">$0.00</span>
                            </div>
                            <div id="feeRow" class="flex items-center justify-between text-sm border-t border-dashed border-gray-100 pt-3">
                                <span class="text-gray-500 flex items-center gap-1">
                                    Fee <span class="text-[10px] font-bold bg-amber-100 text-amber-700 px-1.5 py-0.5 rounded-full">1.5%</span>
                                </span>
                                <span class="font-semibold text-amber-600" id="summaryFee">$0.00</span>
                            </div>
                            <div class="flex items-center justify-between border-t border-gray-200 pt-3">
                                <span class="font-bold text-gray-900">Total</span>
                                <span class="font-extrabold text-blue-700 text-base" id="summaryTotalRow">$0.00</span>
                            </div>
                        </div>
                        <!-- Security note -->
                        <div class="px-5 pb-5">
                            <div class="rounded-lg bg-gray-50 px-3 py-2.5 flex items-start gap-2 text-xs text-gray-500">
                                <i data-lucide="shield-check" class="h-3.5 w-3.5 text-emerald-500 flex-shrink-0 mt-0.5"></i>
                                <span>All transactions are secured and saved to the database.</span>
                            </div>
                        </div>
                    </div>

                    <!-- Recent transactions mini list -->
                    <#if recentPayments?? && recentPayments?size gt 0>
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                        <div class="px-5 pt-4 pb-2 border-b border-gray-100">
                            <p class="text-xs font-semibold text-gray-400 uppercase tracking-wider flex items-center gap-1.5">
                                <i data-lucide="clock" class="h-3.5 w-3.5"></i> Recent activity
                            </p>
                        </div>
                        <div class="divide-y divide-gray-50 px-5">
                            <#list recentPayments as p>
                            <div class="flex items-center gap-3 py-3">
                                <div class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center
                                    <#if p.type?string == 'PAYMENT'>bg-red-50 text-red-500<#else>bg-emerald-50 text-emerald-600</#if>">
                                    <#if p.type?string == 'PAYMENT'>
                                    <i data-lucide="arrow-up-right" class="h-3.5 w-3.5"></i>
                                    <#else>
                                    <i data-lucide="arrow-down-left" class="h-3.5 w-3.5"></i>
                                    </#if>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <p class="text-xs font-semibold text-gray-800 truncate">${p.recipientAccount!"—"}</p>
                                    <p class="text-[11px] text-gray-400">
                                        <#if p.createdAtFormatted??>${p.createdAtFormatted}</#if>
                                        ·
                                        <#if p.status?string == 'COMPLETED'><span class="text-emerald-600">Done</span>
                                        <#elseif p.status?string == 'FAILED'><span class="text-red-500">Failed</span>
                                        <#else><span class="text-amber-500">Pending</span></#if>
                                    </p>
                                </div>
                                <div class="flex-shrink-0 text-xs font-bold <#if p.type?string == 'PAYMENT'>text-red-500<#else>text-emerald-600</#if>">
                                    <#if p.type?string == 'PAYMENT'>−<#else>+</#if>$${p.amount?string("0.00")}
                                </div>
                            </div>
                            </#list>
                        </div>
                        <div class="px-5 pb-4 pt-1">
                            <a href="/dashboard/transactions"
                               class="text-xs font-semibold text-blue-600 hover:text-blue-800 flex items-center gap-1 transition-colors">
                                All transactions <i data-lucide="arrow-right" class="h-3 w-3"></i>
                            </a>
                        </div>
                    </div>
                    </#if>

                </div>
            </div>
        </div>
    </main>
</div>

<script>
    // Init icons
    if (window.lucide) window.lucide.createIcons();

    // ===== STATE =====
    let currentBalance = 0;

    // ===== ACCOUNT CHANGE =====
    function onAccountChange(select) {
        const opt   = select.options[select.selectedIndex];
        const block = document.getElementById('balanceBlock');
        const val   = document.getElementById('balanceValue');

        if (opt.value) {
            currentBalance = parseFloat(opt.dataset.balance) || 0;
            val.textContent = '$' + currentBalance.toFixed(2);
            block.classList.remove('hidden');
        } else {
            currentBalance = 0;
            block.classList.add('hidden');
        }
        validateBalance();
        updateSummary();
        if (window.lucide) window.lucide.createIcons();
    }

    // ===== TYPE CHANGE =====
    function onTypeChange() {
        const isReplenishment = document.getElementById('typeReplenishment').checked;
        const feeRow  = document.getElementById('feeRow');
        const feeHint = document.getElementById('feeHint');
        if (isReplenishment) {
            feeRow.classList.add('hidden');
            feeHint.classList.add('hidden');
        } else {
            feeRow.classList.remove('hidden');
            feeHint.classList.remove('hidden');
        }
        validateBalance();
        updateSummary();
    }

    // ===== VALIDATE BALANCE (+ update progress bar) =====
    function validateBalance() {
        const amount    = parseFloat(document.getElementById('amountInput').value) || 0;
        const isPayment = document.getElementById('typePayment').checked;
        const input     = document.getElementById('amountInput');
        const errorDiv  = document.getElementById('amountError');
        const errorText = document.getElementById('amountErrorText');
        const bar       = document.getElementById('balanceBar');
        const afterRow  = document.getElementById('balanceAfterRow');
        const afterVal  = document.getElementById('balanceAfterValue');
        const insuffMsg = document.getElementById('insufficientMsg');
        const insuffTxt = document.getElementById('insufficientText');
        const balVal    = document.getElementById('balanceValue');

        // Reset
        input.classList.remove('error');
        if (errorDiv) errorDiv.classList.add('hidden');
        if (insuffMsg) insuffMsg.classList.add('hidden');
        if (afterRow)  afterRow.classList.add('hidden');

        if (currentBalance <= 0 || amount <= 0) {
            if (bar) { bar.style.width = '0%'; bar.className = 'h-1.5 rounded-full bg-blue-500 transition-all duration-300'; }
            return true;
        }

        const total = isPayment ? amount * 1.015 : amount;
        const pct   = Math.min((total / currentBalance) * 100, 100);
        const after = currentBalance - total;

        // Progress bar color
        if (bar) {
            bar.style.width = pct + '%';
            if (pct >= 100)      bar.className = 'h-1.5 rounded-full bg-red-500 transition-all duration-300';
            else if (pct >= 75)  bar.className = 'h-1.5 rounded-full bg-amber-500 transition-all duration-300';
            else                 bar.className = 'h-1.5 rounded-full bg-blue-500 transition-all duration-300';
        }

        if (!isPayment) {
            if (afterRow && afterVal) {
                afterRow.classList.remove('hidden');
                afterVal.textContent = '$' + (currentBalance + amount).toFixed(2);
                afterVal.className = 'font-semibold text-emerald-600';
            }
            return true;
        }

        // Show "after payment" balance
        if (afterRow && afterVal) {
            afterRow.classList.remove('hidden');
            if (after >= 0) {
                afterVal.textContent = '$' + after.toFixed(2);
                afterVal.className = after < currentBalance * 0.1
                    ? 'font-semibold text-amber-600'
                    : 'font-semibold text-gray-700';
            } else {
                afterVal.textContent = '—';
                afterVal.className = 'font-semibold text-red-500';
            }
        }

        // Insufficient check
        if (total > currentBalance) {
            input.classList.add('error');
            if (errorDiv) errorDiv.classList.add('hidden'); // hide inline error, use block error
            if (insuffMsg) insuffMsg.classList.remove('hidden');
            if (insuffTxt) insuffTxt.textContent = 'Insufficient funds. Need $' + total.toFixed(2) + ', have $' + currentBalance.toFixed(2);
            if (balVal) balVal.className = 'text-base font-extrabold text-red-600';
            return false;
        }

        input.classList.remove('error');
        if (balVal) balVal.className = 'text-base font-extrabold text-gray-900';
        return true;
    }

    // ===== UPDATE SUMMARY =====
    function updateSummary() {
        const amount    = parseFloat(document.getElementById('amountInput').value) || 0;
        const recipient = document.getElementById('recipientInput').value.trim() || '—';
        const isPayment = document.getElementById('typePayment').checked;

        const fee   = isPayment ? amount * 0.015 : 0;
        const total = amount + fee;

        const s = (id, v) => { const el = document.getElementById(id); if (el) el.textContent = v; };
        s('summaryRecipient', recipient.length > 20 ? recipient.substring(0,20)+'…' : recipient);
        s('summaryAmount', '$' + amount.toFixed(2));
        s('summaryFee',    '$' + fee.toFixed(2));
        s('summaryTotal',  '$' + total.toFixed(2));
        s('summaryTotalRow', '$' + total.toFixed(2));

        const typeEl = document.getElementById('summaryType');
        if (typeEl) {
            if (isPayment) {
                typeEl.textContent = 'Payment';
                typeEl.className = 'inline-flex items-center gap-1 text-xs font-bold px-2 py-0.5 rounded-full bg-blue-50 text-blue-700';
            } else {
                typeEl.textContent = 'Top Up';
                typeEl.className = 'inline-flex items-center gap-1 text-xs font-bold px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-700';
            }
        }
    }

    // ===== QUICK SELECT RECIPIENT =====
    function selectRecipient(account, description) {
        const ri = document.getElementById('recipientInput');
        const di = document.getElementById('descInput');
        if (ri) { ri.value = account; ri.focus(); }
        if (di && description) di.value = description;
        updateSummary();
    }

    // ===== FORM SUBMIT =====
    document.getElementById('paymentForm')?.addEventListener('submit', function(e) {
        if (!validateBalance()) {
            e.preventDefault();
            return;
        }
        const btn  = document.getElementById('submitBtn');
        const text = document.getElementById('btnText');
        const icon = document.getElementById('btnIcon');
        if (btn) {
            btn.disabled = true;
            if (text) text.textContent = 'Processing...';
            if (icon) { icon.setAttribute('data-lucide', 'loader-2'); icon.classList.add('spin'); if (window.lucide) window.lucide.createIcons(); }
        }
    });

    // ===== AUTO-HIDE ALERT =====
    setTimeout(() => {
        const box = document.getElementById('alert-box');
        if (box) { box.style.transition = 'opacity .3s'; box.style.opacity = '0'; setTimeout(() => box.remove(), 300); }
    }, 4000);
</script>
</body>
</html>
