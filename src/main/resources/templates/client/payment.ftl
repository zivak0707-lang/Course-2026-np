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
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-fade-in { animation: fadeIn 0.4s ease-out forwards; }

        .type-radio { display: none; }
        .type-label {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            padding: 10px 0; border-radius: 8px; cursor: pointer; font-size: .875rem;
            font-weight: 500; color: #6b7280; background: #f9fafb;
            border: 1.5px solid #e5e7eb; transition: all .18s; user-select: none;
        }
        .type-label:hover { border-color: #93c5fd; color: #1d4ed8; background: #eff6ff; }
        .type-radio:checked + .type-label { border-color: #2563eb; background: #eff6ff; color: #1d4ed8; }
        .type-radio.replenishment:checked + .type-label { border-color: #10b981; background: #ecfdf5; color: #065f46; }
        .type-radio.transfer:checked + .type-label { border-color: #8b5cf6; background: #f5f3ff; color: #5b21b6; }

        /* Transfer sub-type radio */
        .sub-radio { display: none; }
        .sub-label {
            display: flex; align-items: center; gap: 8px; padding: 9px 14px;
            border-radius: 8px; cursor: pointer; font-size: .85rem; font-weight: 500;
            color: #6b7280; background: #f9fafb; border: 1.5px solid #e5e7eb;
            transition: all .15s; user-select: none; flex: 1;
        }
        .sub-label:hover { border-color: #c4b5fd; color: #7c3aed; background: #f5f3ff; }
        .sub-radio:checked + .sub-label { border-color: #8b5cf6; background: #f5f3ff; color: #6d28d9; }

        .amount-input {
            font-size: 1.5rem; font-weight: 700; padding-left: 2rem;
            border: 1.5px solid #e5e7eb; border-radius: 8px;
            transition: border-color .15s, box-shadow .15s;
            outline: none; width: 100%; background: #f9fafb;
        }
        .amount-input:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,.1); background: #fff; }
        .amount-input.error { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,.1); }

        .pay-input {
            width: 100%; padding: 10px 14px; font-size: .9rem;
            border: 1.5px solid #e5e7eb; border-radius: 8px; background: #f9fafb;
            transition: border-color .15s, box-shadow .15s; outline: none;
        }
        .pay-input:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,.1); background: #fff; }
        .pay-input:disabled { background: #f3f4f6; color: #9ca3af; cursor: not-allowed; border-style: dashed; }
        .pay-input.valid { border-color: #10b981; box-shadow: 0 0 0 3px rgba(16,185,129,.08); }
        .pay-input.invalid { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,.08); }

        .pay-select {
            width: 100%; padding: 10px 14px; font-size: .9rem; font-weight: 500;
            border: 1.5px solid #e5e7eb; border-radius: 8px; background: #f9fafb;
            appearance: none; cursor: pointer;
            transition: border-color .15s, box-shadow .15s; outline: none;
        }
        .pay-select:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,.1); background: #fff; }

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
        @keyframes spin { to { transform: rotate(360deg); } }
        .spin { animation: spin .7s linear infinite; }

        /* Confirmation Modal */
        #confirmModal {
            display: none; position: fixed; inset: 0; z-index: 50;
            background: rgba(0,0,0,.45); backdrop-filter: blur(2px);
            align-items: center; justify-content: center;
        }
        #confirmModal.open { display: flex; }
        @keyframes modalIn { from { opacity:0; transform: scale(.95) translateY(10px); } to { opacity:1; transform: scale(1) translateY(0); } }
        #confirmModalBox { animation: modalIn .2s ease-out; }
    </style>
</head>
<body class="bg-gray-50 text-gray-900">

<!-- ══════════════════════ CONFIRMATION MODAL ══════════════════════ -->
<div id="confirmModal">
    <div id="confirmModalBox" class="bg-white rounded-2xl shadow-2xl w-full max-w-md mx-4 overflow-hidden">
        <div id="modalHeader" class="bg-gradient-to-br from-blue-700 to-blue-500 px-6 py-5 text-white">
            <div class="flex items-center gap-2 mb-1">
                <i data-lucide="shield-check" class="h-5 w-5 opacity-80"></i>
                <p class="text-xs font-semibold uppercase tracking-widest opacity-75">Підтвердження</p>
            </div>
            <p class="text-2xl font-extrabold" id="modalAmount">$0.00</p>
            <p class="text-xs opacity-70 mt-0.5" id="modalAmountLabel">Загальна сума</p>
        </div>
        <div class="px-6 py-5 space-y-3">
            <div class="flex justify-between text-sm border-b border-dashed border-gray-100 pb-3">
                <span class="text-gray-500">Тип операції</span>
                <span class="font-semibold text-gray-800" id="modalType">—</span>
            </div>
            <div class="flex justify-between text-sm border-b border-dashed border-gray-100 pb-3">
                <span class="text-gray-500">Отримувач</span>
                <span class="font-semibold text-gray-800 text-right" id="modalRecipient">—</span>
            </div>
            <div class="flex justify-between text-sm border-b border-dashed border-gray-100 pb-3" id="modalFeeRow">
                <span class="text-gray-500">Комісія (1.5%)</span>
                <span class="font-semibold text-amber-600" id="modalFee">$0.00</span>
            </div>
            <div class="flex justify-between text-sm">
                <span class="font-bold text-gray-900">Разом</span>
                <span class="font-extrabold text-blue-700 text-base" id="modalTotal">$0.00</span>
            </div>
            <div class="rounded-lg bg-amber-50 border border-amber-100 px-3 py-2.5 flex items-start gap-2 text-xs text-amber-700 mt-2">
                <i data-lucide="triangle-alert" class="h-3.5 w-3.5 flex-shrink-0 mt-0.5"></i>
                <span>Операцію не можна скасувати після підтвердження.</span>
            </div>
        </div>
        <div class="px-6 pb-5 flex gap-3">
            <button onclick="closeModal()" class="flex-1 py-2.5 rounded-lg border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50 transition-colors">
                Скасувати
            </button>
            <button id="modalConfirmBtn" onclick="submitForm()" class="flex-1 py-2.5 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700 transition-colors flex items-center justify-center gap-2">
                <i data-lucide="check" class="h-4 w-4"></i> Підтвердити
            </button>
        </div>
    </div>
</div>

<div class="flex min-h-screen w-full">
    <!-- SIDEBAR -->
    <aside class="hidden lg:flex flex-col border-r border-gray-200 bg-white px-6 py-6 w-64 fixed h-full z-20 top-0 left-0">
        <div class="mb-8 flex items-center gap-2 px-2">
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-600 text-white">
                <i data-lucide="wallet" class="h-5 w-5"></i>
            </div>
            <span class="text-xl font-bold tracking-tight text-blue-900">PayFlow</span>
        </div>
        <nav class="flex flex-1 flex-col space-y-1">
            <a href="/dashboard" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors"><i data-lucide="layout-dashboard" class="h-4 w-4"></i> Dashboard</a>
            <a href="/dashboard/accounts" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors"><i data-lucide="landmark" class="h-4 w-4"></i> My Accounts</a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors"><i data-lucide="credit-card" class="h-4 w-4"></i> My Cards</a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700 transition-colors"><i data-lucide="send" class="h-4 w-4"></i> Make Payment</a>
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors"><i data-lucide="receipt" class="h-4 w-4"></i> Transactions</a>
            <a href="/dashboard/settings" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors"><i data-lucide="settings" class="h-4 w-4"></i> Settings</a>
        </nav>
        <div class="mt-auto border-t border-gray-200 pt-4">
            <a href="/dashboard/logout" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-red-50 hover:text-red-600 transition-colors"><i data-lucide="log-out" class="h-4 w-4"></i> Logout</a>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="flex-1 lg:ml-64 p-8 overflow-y-auto min-h-screen">

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
            <div class="mb-8">
                <h1 class="text-2xl font-bold text-gray-900">Make Payment</h1>
                <p class="text-gray-500 mt-1">Send money, top up or transfer between accounts</p>
            </div>

            <#if !accounts?? || accounts?size == 0>
            <div class="rounded-lg bg-amber-50 border border-amber-200 p-5 flex items-start gap-3 mb-8">
                <i data-lucide="triangle-alert" class="h-5 w-5 text-amber-500 flex-shrink-0 mt-0.5"></i>
                <div>
                    <p class="font-semibold text-amber-800">No active accounts found</p>
                    <p class="text-sm text-amber-700 mt-1">You need a card with an active account to make payments.</p>
                    <a href="/dashboard/cards" class="inline-flex items-center gap-1.5 mt-3 text-sm font-semibold text-amber-800 underline underline-offset-2"><i data-lucide="plus" class="h-3.5 w-3.5"></i> Add a card</a>
                </div>
            </div>
            </#if>

            <div class="grid lg:grid-cols-3 gap-6">
                <!-- FORM -->
                <div class="lg:col-span-2">
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                        <form id="paymentForm" action="/dashboard/payment/submit" method="POST" class="p-6 space-y-6">

                            <!-- 1. From account -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
                                    From account <span class="text-red-500">*</span>
                                </label>
                                <#if accounts?? && accounts?size gt 0>
                                <div class="relative">
                                    <select name="accountId" id="accountSelect" class="pay-select pr-10" required onchange="onAccountChange(this)">
                                        <option value="">— Select account —</option>
                                        <#list accounts as acc>
                                            <option value="${acc.id?c}"
                                                    data-balance="${acc.balance?c}"
                                                    data-number="${acc.accountNumber}"
                                                    data-name="${acc.accountName!'Account'}">
                                                ${acc.accountName!"Account"} · ****${acc.accountNumber?substring(acc.accountNumber?length - 4)} · $${acc.balance?string("#,##0.00")}
                                            </option>
                                        </#list>
                                    </select>
                                    <div class="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-gray-400">
                                        <i data-lucide="chevron-down" class="h-4 w-4"></i>
                                    </div>
                                </div>
                                <div id="balanceBlock" class="hidden mt-3 rounded-lg border border-gray-100 bg-gray-50 px-4 py-3">
                                    <div class="flex items-center justify-between mb-2">
                                        <div class="flex items-center gap-1.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                                            <i data-lucide="wallet" class="h-3.5 w-3.5"></i> Available balance
                                        </div>
                                        <span id="balanceValue" class="text-base font-extrabold text-gray-900">$0.00</span>
                                    </div>
                                    <div class="w-full bg-gray-200 rounded-full h-1.5 overflow-hidden">
                                        <div id="balanceBar" class="h-1.5 rounded-full bg-blue-500 transition-all duration-300" style="width: 0%"></div>
                                    </div>
                                    <div id="balanceAfterRow" class="hidden mt-2 flex items-center justify-between text-xs text-gray-500">
                                        <span id="balanceAfterLabel">After payment</span>
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

                            <!-- 2. Operation type -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
                                    Operation type <span class="text-red-500">*</span>
                                </label>
                                <div class="grid grid-cols-3 gap-3">
                                    <div>
                                        <input type="radio" name="type" id="typePayment" value="PAYMENT" class="type-radio" checked onchange="onTypeChange()">
                                        <label for="typePayment" class="type-label">
                                            <i data-lucide="arrow-up-circle" class="h-4 w-4"></i> Payment
                                        </label>
                                    </div>
                                    <div>
                                        <input type="radio" name="type" id="typeReplenishment" value="REPLENISHMENT" class="type-radio replenishment" onchange="onTypeChange()">
                                        <label for="typeReplenishment" class="type-label">
                                            <i data-lucide="arrow-down-circle" class="h-4 w-4"></i> Top Up
                                        </label>
                                    </div>
                                    <div>
                                        <input type="radio" name="type" id="typeTransfer" value="TRANSFER" class="type-radio transfer" onchange="onTypeChange()">
                                        <label for="typeTransfer" class="type-label">
                                            <i data-lucide="arrow-right-left" class="h-4 w-4"></i> Transfer
                                        </label>
                                    </div>
                                </div>
                                <p id="operationHint" class="mt-2 text-xs text-gray-400 flex items-center gap-1">
                                    <i data-lucide="info" class="h-3.5 w-3.5"></i>
                                    <span id="operationHintText">A <strong class="text-gray-600">1.5% fee</strong> is applied to payments</span>
                                </p>
                            </div>

                            <!-- Hidden input що реально відправляється на сервер -->
                            <input type="hidden" id="recipientAccountHidden" name="recipientAccount" value="">

                            <!-- 3a. PAYMENT: текстове поле -->
                            <div id="recipientSection">
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2" for="recipientInput">
                                    Recipient account <span class="text-red-500">*</span>
                                </label>
                                <input type="text" id="recipientInput"
                                       class="pay-input" placeholder="Enter account number"
                                       maxlength="255" oninput="updateSummary()">
                                <p class="mt-1.5 text-xs text-gray-400">e.g. 452184...</p>
                            </div>

                            <!-- 3b. TRANSFER: підтипи + відповідні поля -->
                            <div id="transferSection" class="hidden space-y-4">
                                <!-- Sub-type selector -->
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
                                        Transfer type
                                    </label>
                                    <div class="flex gap-2">
                                        <input type="radio" name="transferSubType" id="subMyAccounts" value="my" class="sub-radio" checked onchange="onSubTypeChange()">
                                        <label for="subMyAccounts" class="sub-label">
                                            <i data-lucide="user" class="h-4 w-4"></i> My accounts
                                        </label>
                                        <input type="radio" name="transferSubType" id="subOtherUser" value="other" class="sub-radio" onchange="onSubTypeChange()">
                                        <label for="subOtherUser" class="sub-label">
                                            <i data-lucide="users" class="h-4 w-4"></i> Another user
                                        </label>
                                    </div>
                                </div>

                                <!-- My accounts: dropdown -->
                                <div id="myAccountsSection">
                                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
                                        To account <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <select id="myAccountsSelect" class="pay-select pr-10" onchange="onMyAccountSelect(this)">
                                            <option value="">— Select destination account —</option>
                                            <#if accounts?? && accounts?size gt 0>
                                            <#list accounts as acc>
                                                <option value="${acc.accountNumber}" data-id="${acc.id?c}" data-name="${acc.accountName!'Account'}">
                                                    ${acc.accountName!"Account"} · ****${acc.accountNumber?substring(acc.accountNumber?length - 4)} · $${acc.balance?string("#,##0.00")}
                                                </option>
                                            </#list>
                                            </#if>
                                        </select>
                                        <div class="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-gray-400">
                                            <i data-lucide="chevron-down" class="h-4 w-4"></i>
                                        </div>
                                    </div>
                                    <p class="mt-1.5 text-xs text-purple-500 flex items-center gap-1">
                                        <i data-lucide="info" class="h-3.5 w-3.5"></i> Transfer between your own accounts — no fee
                                    </p>
                                </div>

                                <!-- Another user: text input + Ajax validation -->
                                <div id="otherUserSection" class="hidden">
                                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">
                                        Recipient account number <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <input type="text" id="externalAccountInput"
                                               class="pay-input pr-10" placeholder="Enter account number"
                                               maxlength="255" oninput="onExternalAccountInput(this)">
                                        <div id="validationSpinner" class="hidden absolute right-3 top-1/2 -translate-y-1/2">
                                            <svg class="spin h-4 w-4 text-blue-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/>
                                            </svg>
                                        </div>
                                    </div>
                                    <!-- Validation result card -->
                                    <div id="validationResult" class="hidden mt-2 rounded-lg px-3 py-2.5 flex items-center gap-2.5 text-sm border">
                                        <div id="validationIcon" class="flex-shrink-0 w-7 h-7 rounded-full flex items-center justify-center text-white text-xs font-bold"></div>
                                        <div class="flex-1">
                                            <p id="validationOwner" class="font-semibold text-gray-800 text-sm"></p>
                                            <p id="validationNumber" class="text-xs text-gray-400 mt-0.5"></p>
                                        </div>
                                        <div id="validationBadge" class="text-xs font-bold px-2 py-0.5 rounded-full"></div>
                                    </div>
                                    <p class="mt-1.5 text-xs text-purple-500 flex items-center gap-1">
                                        <i data-lucide="info" class="h-3.5 w-3.5"></i> Transfer to any PayFlow user — no fee
                                    </p>
                                </div>
                            </div>

                            <!-- 4. Amount -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2" for="amountInput">
                                    Amount <span class="text-red-500">*</span>
                                    <span id="limitHint" class="ml-2 font-normal normal-case text-gray-400 text-[11px]"></span>
                                </label>
                                <div class="relative">
                                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 font-bold text-lg pointer-events-none">$</span>
                                    <input type="number" id="amountInput" name="amount"
                                           class="amount-input" placeholder="0.00"
                                           style="padding-left: 2rem;"
                                           step="0.01" min="0.01" required
                                           oninput="updateSummary(); validateBalance()">
                                </div>
                                <p id="limitErrorMsg" class="hidden mt-1.5 text-xs font-semibold text-red-600 flex items-center gap-1">
                                    <i data-lucide="alert-circle" class="h-3.5 w-3.5"></i>
                                    <span id="limitErrorText"></span>
                                </p>
                            </div>

                            <!-- 5. Description -->
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2" for="descInput">
                                    Description <span class="text-gray-300 font-normal normal-case">(optional)</span>
                                </label>
                                <textarea id="descInput" name="description" class="pay-input resize-none"
                                          rows="2" maxlength="200" placeholder="Payment purpose..."
                                          oninput="document.getElementById('descCounter').textContent = this.value.length + ' / 200'"></textarea>
                                <div class="flex justify-end mt-1">
                                    <span id="descCounter" class="text-xs text-gray-400">0 / 200</span>
                                </div>
                            </div>

                            <button type="button" id="submitBtn" onclick="openModal()"
                                    class="btn-submit" <#if !accounts?? || accounts?size == 0>disabled</#if>>
                                <i data-lucide="send" class="h-4 w-4" id="btnIcon"></i>
                                <span id="btnText">Send Payment</span>
                            </button>

                        </form>
                    </div>
                </div>

                <!-- SUMMARY -->
                <div class="space-y-4">
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                        <div id="summaryHeader" class="bg-gradient-to-br from-blue-700 to-blue-500 px-5 py-5 text-white">
                            <p class="text-xs font-semibold uppercase tracking-widest opacity-75 mb-1">Payment Summary</p>
                            <p class="text-3xl font-extrabold leading-none" id="summaryTotal">$0.00</p>
                            <p class="text-xs opacity-70 mt-1" id="summarySubtitle">Total to pay</p>
                        </div>
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
                                <span class="text-gray-500 flex items-center gap-1">Fee <span class="text-[10px] font-bold bg-amber-100 text-amber-700 px-1.5 py-0.5 rounded-full">1.5%</span></span>
                                <span class="font-semibold text-amber-600" id="summaryFee">$0.00</span>
                            </div>
                            <div class="flex items-center justify-between border-t border-gray-200 pt-3">
                                <span class="font-bold text-gray-900">Total</span>
                                <span class="font-extrabold text-blue-700 text-base" id="summaryTotalRow">$0.00</span>
                            </div>
                        </div>
                        <div class="px-5 pb-5">
                            <div class="rounded-lg bg-gray-50 px-3 py-2.5 flex items-start gap-2 text-xs text-gray-500">
                                <i data-lucide="shield-check" class="h-3.5 w-3.5 text-emerald-500 flex-shrink-0 mt-0.5"></i>
                                <span>All transactions are secured and saved to the database.</span>
                            </div>
                        </div>
                    </div>

                    <!-- Limits info card -->
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                        <div class="px-5 pt-4 pb-2 border-b border-gray-100">
                            <p class="text-xs font-semibold text-gray-400 uppercase tracking-wider flex items-center gap-1.5">
                                <i data-lucide="gauge" class="h-3.5 w-3.5"></i> Transaction Limits
                            </p>
                        </div>
                        <div class="px-5 py-3 space-y-2 text-xs text-gray-600">
                            <div class="flex justify-between">
                                <span class="text-gray-400">Payment max</span>
                                <span class="font-semibold">$10,000</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Transfer max</span>
                                <span class="font-semibold">$50,000</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Top Up max</span>
                                <span class="font-semibold">$100,000</span>
                            </div>
                        </div>
                    </div>

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
                                <div class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center <#if p.type?string == 'PAYMENT'>bg-red-50 text-red-500<#else>bg-emerald-50 text-emerald-600</#if>">
                                    <#if p.type?string == 'PAYMENT'><i data-lucide="arrow-up-right" class="h-3.5 w-3.5"></i>
                                    <#else><i data-lucide="arrow-down-left" class="h-3.5 w-3.5"></i></#if>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <p class="text-xs font-semibold text-gray-800 truncate">${p.recipientAccount!"—"}</p>
                                    <p class="text-[11px] text-gray-400">
                                        <#if p.createdAtFormatted??>${p.createdAtFormatted}</#if> ·
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
                            <a href="/dashboard/transactions" class="text-xs font-semibold text-blue-600 hover:text-blue-800 flex items-center gap-1 transition-colors">
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
    if (window.lucide) window.lucide.createIcons();

    // ── Ліміти (мають відповідати AccountService) ─────────────────────
    const LIMITS = { PAYMENT: 10000, TRANSFER: 50000, REPLENISHMENT: 100000 };

    let currentBalance = 0;
    let currentAccountId = null;
    let validationTimer = null;
    let externalAccountValid = false;
    let externalAccountOwner = '—';

    // ── Вибір рахунку відправника ──────────────────────────────────────
    function onAccountChange(select) {
        const opt = select.options[select.selectedIndex];
        const block = document.getElementById('balanceBlock');
        const val   = document.getElementById('balanceValue');
        if (opt.value) {
            currentBalance   = parseFloat(opt.dataset.balance) || 0;
            currentAccountId = opt.value;
            val.textContent  = '$' + currentBalance.toFixed(2);
            block.classList.remove('hidden');
            refreshMyAccountsDropdown(opt.dataset.number);
        } else {
            currentBalance = 0; currentAccountId = null;
            block.classList.add('hidden');
        }
        validateBalance();
        updateSummary();
        if (window.lucide) window.lucide.createIcons();
    }

    // Прибираємо з "My accounts" dropdown поточний рахунок відправника
    function refreshMyAccountsDropdown(senderAccountNumber) {
        const sel = document.getElementById('myAccountsSelect');
        Array.from(sel.options).forEach(opt => {
            opt.disabled = (opt.value === senderAccountNumber);
        });
        if (sel.options[sel.selectedIndex]?.value === senderAccountNumber) {
            sel.selectedIndex = 0;
            document.getElementById('recipientAccountHidden').value = '';
        }
    }

    // ── Вибір власного рахунку в Transfer ─────────────────────────────
    function onMyAccountSelect(select) {
        const opt = select.options[select.selectedIndex];
        document.getElementById('recipientAccountHidden').value = opt.value || '';
        updateSummary();
    }

    // ── Sub-type Transfer (My accounts / Another user) ─────────────────
    function onSubTypeChange() {
        const isMy = document.getElementById('subMyAccounts').checked;
        document.getElementById('myAccountsSection').classList.toggle('hidden', !isMy);
        document.getElementById('otherUserSection').classList.toggle('hidden', isMy);
        // Скидаємо hidden
        document.getElementById('recipientAccountHidden').value = '';
        externalAccountValid = false;
        externalAccountOwner = '—';
        // Скидаємо validation UI
        const input = document.getElementById('externalAccountInput');
        if (input) { input.value = ''; input.className = 'pay-input pr-10'; }
        document.getElementById('validationResult').classList.add('hidden');
        updateSummary();
    }

    // ── Ajax валідація зовнішнього рахунку ─────────────────────────────
    function onExternalAccountInput(input) {
        const val = input.value.trim();
        document.getElementById('recipientAccountHidden').value = val;
        clearTimeout(validationTimer);
        externalAccountValid = false;
        externalAccountOwner = '—';

        const result = document.getElementById('validationResult');
        const spinner = document.getElementById('validationSpinner');

        if (val.length < 6) {
            result.classList.add('hidden');
            input.className = 'pay-input pr-10';
            updateSummary();
            return;
        }

        spinner.classList.remove('hidden');
        validationTimer = setTimeout(async () => {
            try {
                const res = await fetch('/api/accounts/validate?number=' + encodeURIComponent(val));
                const data = await res.json();
                spinner.classList.add('hidden');

                if (data.valid) {
                    externalAccountValid = true;
                    externalAccountOwner = data.ownerName || '—';

                    const isBlocked = data.status === 'BLOCKED';
                    input.className = isBlocked ? 'pay-input pr-10 invalid' : 'pay-input pr-10 valid';

                    // Show result card
                    result.classList.remove('hidden');
                    result.className = isBlocked
                        ? 'mt-2 rounded-lg px-3 py-2.5 flex items-center gap-2.5 text-sm border bg-red-50 border-red-200'
                        : 'mt-2 rounded-lg px-3 py-2.5 flex items-center gap-2.5 text-sm border bg-emerald-50 border-emerald-200';

                    const icon = document.getElementById('validationIcon');
                    icon.textContent = externalAccountOwner.charAt(0).toUpperCase();
                    icon.className = isBlocked
                        ? 'flex-shrink-0 w-7 h-7 rounded-full flex items-center justify-center text-white text-xs font-bold bg-red-400'
                        : 'flex-shrink-0 w-7 h-7 rounded-full flex items-center justify-center text-white text-xs font-bold bg-emerald-500';

                    document.getElementById('validationOwner').textContent = externalAccountOwner;
                    document.getElementById('validationNumber').textContent = data.maskedNumber || '';

                    const badge = document.getElementById('validationBadge');
                    if (isBlocked) {
                        badge.textContent = 'Заблокований';
                        badge.className = 'text-xs font-bold px-2 py-0.5 rounded-full bg-red-100 text-red-600';
                        externalAccountValid = false;
                    } else {
                        badge.textContent = 'Знайдено ✓';
                        badge.className = 'text-xs font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-600';
                    }
                } else {
                    externalAccountValid = false;
                    externalAccountOwner = '—';
                    input.className = 'pay-input pr-10 invalid';
                    result.classList.remove('hidden');
                    result.className = 'mt-2 rounded-lg px-3 py-2.5 flex items-center gap-2.5 text-sm border bg-red-50 border-red-200';
                    document.getElementById('validationIcon').textContent = '?';
                    document.getElementById('validationIcon').className = 'flex-shrink-0 w-7 h-7 rounded-full flex items-center justify-center text-white text-xs font-bold bg-gray-400';
                    document.getElementById('validationOwner').textContent = 'Рахунок не знайдено';
                    document.getElementById('validationNumber').textContent = '';
                    document.getElementById('validationBadge').textContent = '';
                }
            } catch (err) {
                spinner.classList.add('hidden');
                console.error('Validation error:', err);
            }
            updateSummary();
        }, 500); // debounce 500ms
    }

    // ── Зміна типу операції ────────────────────────────────────────────
    function onTypeChange() {
        const isPayment       = document.getElementById('typePayment').checked;
        const isReplenishment = document.getElementById('typeReplenishment').checked;
        const isTransfer      = document.getElementById('typeTransfer').checked;

        const feeRow           = document.getElementById('feeRow');
        const hintText         = document.getElementById('operationHintText');
        const recipientSection = document.getElementById('recipientSection');
        const transferSection  = document.getElementById('transferSection');
        const recipientInput   = document.getElementById('recipientInput');
        const btnText          = document.getElementById('btnText');
        const summaryHeader    = document.getElementById('summaryHeader');
        const limitHint        = document.getElementById('limitHint');

        document.getElementById('recipientAccountHidden').value = '';
        hideLimitError();

        if (isReplenishment) {
            recipientSection.classList.add('hidden');
            transferSection.classList.add('hidden');
            recipientInput.removeAttribute('required');
            recipientInput.value = '';
            feeRow.classList.add('hidden');
            hintText.innerHTML = 'Funds will be added directly to the selected account';
            if (btnText) btnText.textContent = 'Top Up Account';
            summaryHeader.className = 'bg-gradient-to-br from-emerald-700 to-emerald-500 px-5 py-5 text-white';
            if (limitHint) limitHint.textContent = '(max $100,000)';

        } else if (isTransfer) {
            recipientSection.classList.add('hidden');
            transferSection.classList.remove('hidden');
            recipientInput.removeAttribute('required');
            recipientInput.value = '';
            feeRow.classList.add('hidden');
            hintText.innerHTML = 'Transfer between accounts — <strong class="text-gray-600">no fee</strong>';
            if (btnText) btnText.textContent = 'Transfer';
            summaryHeader.className = 'bg-gradient-to-br from-purple-700 to-purple-500 px-5 py-5 text-white';
            if (limitHint) limitHint.textContent = '(max $50,000)';
            if (currentAccountId) {
                const sel = document.getElementById('accountSelect');
                const opt = sel.options[sel.selectedIndex];
                if (opt?.dataset?.number) refreshMyAccountsDropdown(opt.dataset.number);
            }
            // Скидаємо sub-type
            document.getElementById('subMyAccounts').checked = true;
            onSubTypeChange();

        } else {
            recipientSection.classList.remove('hidden');
            transferSection.classList.add('hidden');
            recipientInput.setAttribute('required', '');
            feeRow.classList.remove('hidden');
            hintText.innerHTML = 'A <strong class="text-gray-600">1.5% fee</strong> is applied to payments';
            if (btnText) btnText.textContent = 'Send Payment';
            summaryHeader.className = 'bg-gradient-to-br from-blue-700 to-blue-500 px-5 py-5 text-white';
            if (limitHint) limitHint.textContent = '(max $10,000)';
        }

        validateBalance();
        updateSummary();
        if (window.lucide) window.lucide.createIcons();
    }

    // ── Перевірка ліміту ───────────────────────────────────────────────
    function checkLimit(amount) {
        const isPayment       = document.getElementById('typePayment').checked;
        const isReplenishment = document.getElementById('typeReplenishment').checked;
        const type = isPayment ? 'PAYMENT' : isReplenishment ? 'REPLENISHMENT' : 'TRANSFER';
        const max  = LIMITS[type];
        if (amount > max) {
            showLimitError('Перевищено ліміт $' + max.toLocaleString('en') + ' для ' + type.toLowerCase());
            return false;
        }
        hideLimitError();
        return true;
    }
    function showLimitError(msg) {
        const el = document.getElementById('limitErrorMsg');
        const txt = document.getElementById('limitErrorText');
        if (el && txt) { txt.textContent = msg; el.classList.remove('hidden'); }
        document.getElementById('amountInput')?.classList.add('error');
    }
    function hideLimitError() {
        document.getElementById('limitErrorMsg')?.classList.add('hidden');
    }

    // ── Валідація балансу ──────────────────────────────────────────────
    function validateBalance() {
        const amount          = parseFloat(document.getElementById('amountInput').value) || 0;
        const isReplenishment = document.getElementById('typeReplenishment').checked;
        const isPayment       = document.getElementById('typePayment').checked;
        const input    = document.getElementById('amountInput');
        const bar      = document.getElementById('balanceBar');
        const afterRow = document.getElementById('balanceAfterRow');
        const afterVal = document.getElementById('balanceAfterValue');
        const insuffMsg = document.getElementById('insufficientMsg');
        const insuffTxt = document.getElementById('insufficientText');
        const balVal   = document.getElementById('balanceValue');

        input.classList.remove('error');
        if (insuffMsg) insuffMsg.classList.add('hidden');
        if (afterRow)  afterRow.classList.add('hidden');

        if (amount <= 0) {
            if (bar) { bar.style.width = '0%'; bar.className = 'h-1.5 rounded-full bg-blue-500 transition-all duration-300'; }
            return true;
        }

        if (!checkLimit(amount)) return false;

        if (isReplenishment) {
            if (bar) { bar.style.width = '0%'; bar.className = 'h-1.5 rounded-full bg-emerald-500 transition-all duration-300'; }
            if (afterRow && afterVal) {
                afterRow.classList.remove('hidden');
                document.getElementById('balanceAfterLabel').textContent = 'Balance after top up';
                afterVal.textContent = '$' + (currentBalance + amount).toFixed(2);
                afterVal.className = 'font-semibold text-emerald-600';
            }
            return true;
        }
        if (currentBalance <= 0) return true;

        const total = isPayment ? amount * 1.015 : amount;
        const pct   = Math.min((total / currentBalance) * 100, 100);
        const after = currentBalance - total;

        if (bar) {
            bar.style.width = pct + '%';
            bar.className = pct >= 100
                ? 'h-1.5 rounded-full bg-red-500 transition-all duration-300'
                : pct >= 75
                    ? 'h-1.5 rounded-full bg-amber-500 transition-all duration-300'
                    : 'h-1.5 rounded-full bg-blue-500 transition-all duration-300';
        }
        if (afterRow && afterVal) {
            afterRow.classList.remove('hidden');
            document.getElementById('balanceAfterLabel').textContent = 'After payment';
            if (after >= 0) {
                afterVal.textContent = '$' + after.toFixed(2);
                afterVal.className = after < currentBalance * 0.1 ? 'font-semibold text-amber-600' : 'font-semibold text-gray-700';
            } else {
                afterVal.textContent = '—'; afterVal.className = 'font-semibold text-red-500';
            }
        }
        if (total > currentBalance) {
            input.classList.add('error');
            if (insuffMsg) insuffMsg.classList.remove('hidden');
            if (insuffTxt) insuffTxt.textContent = 'Insufficient funds. Need $' + total.toFixed(2) + ', have $' + currentBalance.toFixed(2);
            if (balVal) balVal.className = 'text-base font-extrabold text-red-600';
            return false;
        }
        if (balVal) balVal.className = 'text-base font-extrabold text-gray-900';
        return true;
    }

    // ── Оновлення Summary ──────────────────────────────────────────────
    function updateSummary() {
        const amount          = parseFloat(document.getElementById('amountInput').value) || 0;
        const isPayment       = document.getElementById('typePayment').checked;
        const isReplenishment = document.getElementById('typeReplenishment').checked;
        const isTransfer      = document.getElementById('typeTransfer').checked;

        let recipientLabel = '—';
        if (isReplenishment) {
            recipientLabel = 'Self (Top Up)';
        } else if (isTransfer) {
            const isMy = document.getElementById('subMyAccounts').checked;
            if (isMy) {
                const sel = document.getElementById('myAccountsSelect');
                const opt = sel.options[sel.selectedIndex];
                recipientLabel = opt && opt.value ? (opt.dataset.name || opt.value) : '—';
            } else {
                recipientLabel = externalAccountValid ? externalAccountOwner : (document.getElementById('externalAccountInput')?.value.trim() || '—');
            }
        } else {
            const v = document.getElementById('recipientInput').value.trim();
            recipientLabel = v || '—';
        }

        const fee   = isPayment ? amount * 0.015 : 0;
        const total = amount + fee;
        const s = (id, v) => { const el = document.getElementById(id); if (el) el.textContent = v; };

        recipientLabel = recipientLabel.length > 20 ? recipientLabel.substring(0, 20) + '…' : recipientLabel;
        s('summaryRecipient', recipientLabel);
        s('summaryAmount', '$' + amount.toFixed(2));
        s('summaryFee', '$' + fee.toFixed(2));
        s('summaryTotal', '$' + total.toFixed(2));
        s('summaryTotalRow', '$' + total.toFixed(2));

        const typeEl = document.getElementById('summaryType');
        if (typeEl) {
            if (isReplenishment) { typeEl.textContent = 'Top Up'; typeEl.className = 'inline-flex items-center text-xs font-bold px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-700'; }
            else if (isTransfer) { typeEl.textContent = 'Transfer'; typeEl.className = 'inline-flex items-center text-xs font-bold px-2 py-0.5 rounded-full bg-purple-50 text-purple-700'; }
            else { typeEl.textContent = 'Payment'; typeEl.className = 'inline-flex items-center text-xs font-bold px-2 py-0.5 rounded-full bg-blue-50 text-blue-700'; }
        }
    }

    // ── Модальне вікно підтвердження ───────────────────────────────────
    function openModal() {
        const isReplenishment = document.getElementById('typeReplenishment').checked;
        const isTransfer      = document.getElementById('typeTransfer').checked;
        const isPayment       = document.getElementById('typePayment').checked;
        const amount = parseFloat(document.getElementById('amountInput').value) || 0;

        // Базова валідація
        if (!document.getElementById('accountSelect')?.value) {
            alert('Будь ласка, оберіть рахунок'); return;
        }
        if (amount <= 0) { alert('Будь ласка, введіть суму'); return; }
        if (!validateBalance()) return;

        // Валідація recipient
        if (isTransfer) {
            const isMy = document.getElementById('subMyAccounts').checked;
            if (isMy) {
                const sel = document.getElementById('myAccountsSelect');
                if (!sel.options[sel.selectedIndex]?.value) { alert('Оберіть рахунок призначення'); return; }
                document.getElementById('recipientAccountHidden').value = sel.options[sel.selectedIndex].value;
            } else {
                if (!externalAccountValid) { alert('Введіть коректний номер рахунку отримувача'); return; }
                document.getElementById('recipientAccountHidden').value = document.getElementById('externalAccountInput').value.trim();
            }
        } else if (isPayment) {
            const v = document.getElementById('recipientInput').value.trim();
            if (!v) { alert('Будь ласка, введіть рахунок отримувача'); return; }
            document.getElementById('recipientAccountHidden').value = v;
        }

        // Заповнюємо модал
        const fee = isPayment ? amount * 0.015 : 0;
        const total = amount + fee;
        const typeLabel = isReplenishment ? 'Top Up' : isTransfer ? 'Transfer' : 'Payment';
        const recipientText = document.getElementById('summaryRecipient').textContent;

        document.getElementById('modalAmount').textContent = '$' + total.toFixed(2);
        document.getElementById('modalType').textContent = typeLabel;
        document.getElementById('modalRecipient').textContent = recipientText;
        document.getElementById('modalFee').textContent = '$' + fee.toFixed(2);
        document.getElementById('modalFeeRow').style.display = isPayment ? 'flex' : 'none';
        document.getElementById('modalTotal').textContent = '$' + total.toFixed(2);

        const header = document.getElementById('modalHeader');
        header.className = isReplenishment
            ? 'bg-gradient-to-br from-emerald-700 to-emerald-500 px-6 py-5 text-white'
            : isTransfer
                ? 'bg-gradient-to-br from-purple-700 to-purple-500 px-6 py-5 text-white'
                : 'bg-gradient-to-br from-blue-700 to-blue-500 px-6 py-5 text-white';

        document.getElementById('confirmModal').classList.add('open');
        if (window.lucide) window.lucide.createIcons();
    }

    function closeModal() {
        document.getElementById('confirmModal').classList.remove('open');
    }

    function submitForm() {
        document.getElementById('modalConfirmBtn').disabled = true;
        document.getElementById('modalConfirmBtn').innerHTML = '<svg class="spin h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg> Обробляємо...';
        document.getElementById('paymentForm').submit();
    }

    // Закриття по кліку на backdrop
    document.getElementById('confirmModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    // ── Auto-hide alerts ───────────────────────────────────────────────
    setTimeout(() => {
        const box = document.getElementById('alert-box');
        if (box) { box.style.transition = 'opacity .3s'; box.style.opacity = '0'; setTimeout(() => box.remove(), 300); }
    }, 4000);
</script>
</body>
</html>
