<#-- @ftlvariable name="cards" type="java.util.List<ua.com.kisit.course2026np.entity.CreditCard>" -->
<#-- @ftlvariable name="user" type="ua.com.kisit.course2026np.entity.User" -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cards - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; }
        .font-credit { font-family: 'Share Tech Mono', monospace; }
        .font-mono-details { font-family: 'JetBrains Mono', monospace; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in { animation: fadeIn 0.4s ease-out forwards; }

        .perspective-1000 { perspective: 1200px; }
        .card-container {
            position: relative; width: 100%; height: 100%;
            transition: transform 0.6s cubic-bezier(0.4, 0.0, 0.2, 1);
            transform-style: preserve-3d;
        }
        .card-container.flipped { transform: rotateY(180deg); }

        .card-face {
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            position: absolute; inset: 0;
            border-radius: 1.25rem;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.2), 0 8px 10px -6px rgba(0,0,0,0.2);
            border: 1px solid rgba(255,255,255,0.1);
        }
        .card-back { transform: rotateY(180deg); z-index: 20; overflow: hidden; }

        .chip-metallic {
            background: linear-gradient(135deg, #fce3b4 0%, #eec476 50%, #d4af37 100%);
            box-shadow: inset 0 1px 2px rgba(255,255,255,0.4), 0 1px 2px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
        }
        .text-shadow-sm { text-shadow: 0 1px 2px rgba(0,0,0,0.5); }

        .modal {
            opacity: 0; visibility: hidden;
            transition: opacity 0.2s ease, visibility 0.2s;
        }
        .modal.open { opacity: 1; visibility: visible; }
        .modal-content {
            transform: scale(0.95);
            transition: transform 0.2s ease;
        }
        .modal.open .modal-content { transform: scale(1); }

        /* Action selection cards */
        .action-card {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .action-card:hover {
            border-color: #3b82f6;
            background: #eff6ff;
            transform: translateY(-2px);
        }
        .action-card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        .action-card-label {
            font-size: 0.9375rem;
            font-weight: 600;
            color: #1f2937;
            text-align: center;
        }

        /* Dark modals */
        .dark-modal {
            background: #1e2535;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 18px;
            box-shadow: 0 28px 64px rgba(0,0,0,0.65);
        }
        .dark-modal-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 18px 22px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .dark-modal-title {
            font-size: 1rem; font-weight: 600;
            color: #f1f5f9; margin: 0;
        }
        .dark-modal-close {
            background: rgba(255,255,255,0.07); border: none;
            color: #94a3b8; width: 30px; height: 30px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: background 0.15s, color 0.15s;
        }
        .dark-modal-close:hover {
            background: rgba(239,68,68,0.15); color: #ef4444;
        }
        .dark-modal-body { padding: 22px; color: #cbd5e1; }
        .dark-modal-footer {
            padding: 14px 22px 20px;
            display: flex; justify-content: flex-end; gap: 10px;
            border-top: 1px solid rgba(255,255,255,0.06);
        }
        .dark-input {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 10px; color: #f1f5f9;
            padding: 10px 14px; font-size: 0.9375rem;
            width: 100%; outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .dark-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.22);
        }
        .dark-input::placeholder { color: rgba(255,255,255,0.22); }

        .dark-btn {
            border: none; border-radius: 10px;
            padding: 9px 20px; font-size: 0.875rem; font-weight: 600;
            cursor: pointer; transition: opacity 0.2s, transform 0.15s;
        }
        .dark-btn:active { transform: scale(0.97); }
        .dark-btn-ghost { background: rgba(255,255,255,0.07); color: #94a3b8; }
        .dark-btn-ghost:hover { background: rgba(255,255,255,0.12); color: #e2e8f0; }
        .dark-btn-primary { background: #2563eb; color: #fff; }
        .dark-btn-primary:hover { background: #1d4ed8; }
        .dark-btn-warning { background: #f59e0b; color: #fff; }
        .dark-btn-warning:hover { background: #d97706; }
        .dark-btn-info { background: #06b6d4; color: #fff; }
        .dark-btn-info:hover { background: #0891b2; }

        .error-msg {
            color: #ef4444; font-size: 0.8125rem;
            margin-top: 8px; display: none;
        }
        .spinner {
            width: 14px; height: 14px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top-color: #fff; border-radius: 50%;
            animation: spin 0.65s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* Blocked card overlay */
        .card-blocked-overlay {
            position: absolute; inset: 0;
            background: rgba(0,0,0,0.55);
            border-radius: 1.25rem;
            z-index: 15;
            display: flex; align-items: center; justify-content: center;
        }
        .card-blocked-badge {
            background: rgba(239,68,68,0.92);
            color: white; font-size: 0.7rem; font-weight: 700;
            letter-spacing: 0.12em; text-transform: uppercase;
            padding: 6px 16px; border-radius: 999px;
            display: flex; align-items: center; gap: 6px;
            cursor: pointer;
            transition: background 0.15s, transform 0.15s;
            border: none;
        }
        .card-blocked-badge:hover {
            background: rgba(220,38,38,1);
            transform: scale(1.05);
        }
        /* Limit side panel */
        .limit-side-panel {
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 8px;
            padding: 12px 16px;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            min-width: 140px;
            align-self: stretch;
        }
        .limit-side-label {
            font-size: 0.7rem;
            font-weight: 600;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }
        .limit-side-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #111827;
        }
        .limit-side-bar-wrap {
            background: #f3f4f6;
            border-radius: 999px;
            height: 6px;
            overflow: hidden;
        }
        .limit-side-bar {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(to right, #3b82f6, #06b6d4);
            transition: width 0.4s ease;
        }
        .limit-side-spent {
            font-size: 0.72rem;
            color: #6b7280;
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
            <a href="/dashboard" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="layout-dashboard" class="h-4 w-4"></i> Dashboard
            </a>
            <a href="/dashboard/accounts" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="landmark" class="h-4 w-4"></i> My Accounts
            </a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700 transition-colors">
                <i data-lucide="credit-card" class="h-4 w-4"></i> My Cards
            </a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
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

    <main class="main-content flex-1 lg:ml-64 p-8 overflow-y-auto min-h-screen">

        <#if successMessage??>
            <div id="alert-box" class="mb-6 rounded-lg bg-emerald-50 p-4 border border-emerald-200 flex items-center gap-3 shadow-sm animate-fade-in">
                <i data-lucide="check-circle" class="h-5 w-5 text-emerald-600"></i>
                <p class="text-sm font-medium text-emerald-800">${successMessage}</p>
            </div>
        </#if>
        <#if errorMessage??>
            <div id="alert-box" class="mb-6 rounded-lg bg-red-50 p-4 border border-red-200 flex items-center gap-3 shadow-sm animate-fade-in">
                <i data-lucide="alert-circle" class="h-5 w-5 text-red-600"></i>
                <p class="text-sm font-medium text-red-800">${errorMessage}</p>
            </div>
        </#if>

        <div class="space-y-8 max-w-6xl mx-auto animate-fade-in">

            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">My Cards</h1>
                    <p class="text-gray-500 mt-1">Physical and virtual cards</p>
                </div>
                <button onclick="openAddCardModal()" class="inline-flex items-center justify-center rounded-lg bg-gray-900 px-5 py-2 text-sm font-medium text-white shadow hover:bg-black transition-all">
                    <i data-lucide="plus" class="h-4 w-4 mr-2"></i> Add Card
                </button>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 items-start">
                <#list cards as card>
                    <#assign themeIndex = card?index % 3>
                    <#assign bgClass = "">

                    <#if themeIndex == 0>
                        <#assign bgClass = "bg-gradient-to-br from-gray-800 via-gray-900 to-black">
                    <#elseif themeIndex == 1>
                        <#assign bgClass = "bg-gradient-to-br from-blue-900 via-slate-800 to-gray-900">
                    <#else>
                        <#assign bgClass = "bg-gradient-to-br from-emerald-900 via-teal-900 to-slate-900">
                    </#if>

                    <div class="group perspective-1000 h-[220px]" onmouseleave="unflipCard(this)">
                        <div class="card-container w-full h-full relative cursor-pointer" onclick="toggleFlip(event, this)" style="transform-style:preserve-3d;">

                            <div class="card-face card-front ${bgClass} p-6 flex flex-col justify-between text-white">
                                <div class="absolute inset-0 bg-gradient-to-tr from-white/5 to-transparent pointer-events-none"></div>

                                <div class="relative z-10 flex justify-between items-start">
                                    <div class="flex items-center gap-2">
                                        <i data-lucide="wallet" class="h-5 w-5 text-white/90"></i>
                                        <span class="font-bold text-sm tracking-wide opacity-90">PayFlow</span>
                                    </div>

                                    <button onclick="event.stopPropagation(); event.preventDefault(); openCardActionsModal(${card.id}, ${card.isActive?c}, '${card.spendingLimit!0}', '${(card.pinCode?? && card.pinCode?has_content)?c}')"
                                            class="p-1.5 rounded-lg bg-white/10 hover:bg-white/20 text-white transition-colors"
                                            style="position:relative; z-index:100; pointer-events:all; cursor:pointer;"
                                            title="Manage card">
                                        <i data-lucide="settings" class="h-4 w-4" style="pointer-events:none;"></i>
                                    </button>
                                </div>

                                <div class="relative z-10 mt-2">
                                    <div class="w-11 h-8 rounded-md chip-metallic mb-4 relative overflow-hidden">
                                        <div class="absolute inset-0 bg-gradient-to-br from-white/30 to-transparent opacity-50"></div>
                                    </div>

                                    <div class="flex items-center justify-between">
                                        <p class="font-credit text-[22px] tracking-widest text-white text-shadow-sm whitespace-nowrap overflow-visible"
                                           id="cardNumberText-${card.id}"
                                           data-full="${card.cardNumber}"
                                           data-masked="true">
                                            **** **** **** ${card.cardNumber?substring(card.cardNumber?length - 4)}
                                        </p>
                                    </div>
                                </div>

                                <div class="relative z-10 flex justify-between items-end">
                                    <div>
                                        <div class="flex gap-8 mb-1">
                                            <div>
                                                <p class="text-[8px] uppercase text-white/50 mb-0.5">Card Holder</p>
                                                <p class="font-medium text-xs uppercase tracking-wide overflow-hidden whitespace-nowrap max-w-[120px] text-ellipsis">${card.cardholderName}</p>
                                            </div>
                                            <div>
                                                <p class="text-[8px] uppercase text-white/50 mb-0.5">Expires</p>
                                                <p class="font-mono-details font-medium text-xs tracking-wide">${card.formattedExpiryDate}</p>
                                            </div>
                                        </div>
                                        <#if card.hasSpendingLimit()>
                                        <div style="display:inline-flex; align-items:center; gap:4px; background:rgba(6,182,212,0.2); border:1px solid rgba(6,182,212,0.4); color:#67e8f9; font-size:0.65rem; font-weight:600; padding:2px 8px; border-radius:999px;">
                                            Limit: $${card.spendingLimit?string["0.##"]}
                                        </div>
                                        </#if>
                                    </div>

                                    <div class="mb-1">
                                        <#if card.cardNumber?starts_with("4")>
                                            <span class="text-2xl font-black italic tracking-tighter opacity-90">VISA</span>
                                        <#else>
                                            <div class="flex -space-x-3 opacity-90">
                                                <div class="w-7 h-7 rounded-full bg-red-500/80"></div>
                                                <div class="w-7 h-7 rounded-full bg-yellow-500/80"></div>
                                            </div>
                                        </#if>
                                    </div>
                                </div>

                                <div class="absolute right-5 top-[85px] z-20 flex gap-2">
                                    <button onclick="event.stopPropagation(); toggleCardNumber('${card.id}')" class="p-1.5 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors" title="Show/Hide">
                                        <i data-lucide="eye" class="h-4 w-4"></i>
                                    </button>
                                    <button onclick="event.stopPropagation(); copyCardNumber('${card.cardNumber}', this)" class="p-1.5 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors" title="Copy">
                                        <i data-lucide="copy" class="h-4 w-4"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="card-face card-back ${bgClass} flex flex-col">
                                <div class="absolute inset-0 bg-black/20 pointer-events-none"></div>
                                <div class="w-full h-10 bg-[#111] mt-6 relative z-10 border-y border-black/30"></div>

                                <div class="px-6 mt-4 flex-1 relative z-10 flex flex-col">
                                    <div class="flex justify-end items-center gap-3 mt-2">
                                        <span class="text-[9px] uppercase text-white/60">CVV</span>
                                        <div class="bg-white text-gray-900 font-mono-details font-bold text-sm px-2 py-1 rounded w-12 text-center">
                                            ${card.cvv}
                                        </div>
                                    </div>

                                    <div class="mt-auto mb-6 flex justify-between items-center border-t border-white/10 pt-4">
                                        <p class="text-[10px] text-white/50">support@payflow.com</p>

                                        <button type="button"
                                                onclick="event.stopPropagation(); openDeleteModal('${card.id}', '${card.cardNumber?substring(card.cardNumber?length - 4)}')"
                                                class="flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-medium text-red-100 hover:bg-red-500 hover:text-white transition-colors border border-red-500/30">
                                            <i data-lucide="trash-2" class="h-3 w-3"></i> Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                            <!-- Blocked overlay — клікабельна кнопка -->
                            <#if !card.isActive>
                            <div class="card-blocked-overlay">
                                <button class="card-blocked-badge"
                                        onclick="event.stopPropagation(); openToggleBlockModal(${card.id}, false)">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>
                                    BLOCKED
                                </button>
                            </div>
                            </#if>
                    </div><!-- /card perspective -->
                </#list>

                <button onclick="openAddCardModal()" class="h-[220px] border-2 border-dashed border-gray-200 rounded-[1.25rem] flex flex-col items-center justify-center hover:border-blue-500 hover:bg-blue-50/30 transition-all duration-300 bg-white group">
                    <div class="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all duration-300 text-gray-400">
                        <i data-lucide="plus" class="h-6 w-6"></i>
                    </div>
                    <span class="mt-4 text-sm font-semibold text-gray-500 group-hover:text-blue-600">Add New Card</span>
                </button>
            </div>
        </div>
    </main>
</div>

<!-- MODAL: Card Actions Selection -->
<div id="modal-card-actions" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" onclick="closeModal('modal-card-actions')"></div>
    <div class="modal-content relative w-full max-w-lg bg-white rounded-xl shadow-2xl p-6 z-10">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-900">Manage Card</h2>
            <button onclick="closeModal('modal-card-actions')" class="text-gray-400 hover:text-gray-600">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>
        <p class="text-sm text-gray-500 mb-6 text-center">Choose an action to manage your card</p>

        <div class="grid grid-cols-3 gap-4">
            <div id="action-block" class="action-card" onclick="selectCardAction('block')">
                <div class="action-card-icon" style="background:#fef3c7; color:#f59e0b;">
                    <i data-lucide="slash" class="h-6 w-6"></i>
                </div>
                <span class="action-card-label">Block Card</span>
            </div>
            <div class="action-card" onclick="selectCardAction('pin')">
                <div class="action-card-icon" style="background:#dbeafe; color:#2563eb;">
                    <i data-lucide="key" class="h-6 w-6"></i>
                </div>
                <span class="action-card-label">Change PIN</span>
            </div>
            <div class="action-card" onclick="selectCardAction('limit')">
                <div class="action-card-icon" style="background:#cffafe; color:#06b6d4;">
                    <i data-lucide="gauge" class="h-6 w-6"></i>
                </div>
                <span class="action-card-label">Spending Limit</span>
            </div>
        </div>

        <div class="mt-6 flex justify-end">
            <button onclick="closeModal('modal-card-actions')" class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded-lg transition-colors">
                Cancel
            </button>
        </div>
    </div>
</div>

<!-- MODAL: Add Card -->
<div id="addCardModal" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" onclick="closeAddCardModal()"></div>
    <div class="modal-content relative w-full max-w-md bg-white rounded-xl shadow-2xl p-6 z-10">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-900">Add New Card</h2>
            <button onclick="closeAddCardModal()" class="text-gray-400 hover:text-gray-600">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>

        <form action="/dashboard/cards/add" method="POST" class="space-y-4">
            <#if _csrf??><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/></#if>
            <div>
                <label class="block text-xs font-medium text-gray-700 uppercase mb-1">Card Number</label>
                <div class="relative">
                    <input type="text" name="cardNumber" id="cardNumberInput" maxlength="19" placeholder="0000 0000 0000 0000" required
                           class="block w-full rounded-lg border-gray-300 bg-gray-50 border px-3 py-2.5 text-sm font-mono focus:ring-2 focus:ring-blue-500 outline-none">
                    <i data-lucide="credit-card" class="absolute right-3 top-2.5 h-5 w-5 text-gray-400"></i>
                </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-medium text-gray-700 uppercase mb-1">Expiry</label>
                    <input type="text" name="expiryDate" id="expiryDateInput" maxlength="5" placeholder="MM/YY" required
                           class="block w-full rounded-lg border-gray-300 bg-gray-50 border px-3 py-2.5 text-sm font-mono focus:ring-2 focus:ring-blue-500 outline-none">
                </div>
                <div>
                    <label class="block text-xs font-medium text-gray-700 uppercase mb-1">CVV</label>
                    <input type="text" name="cvv" id="cvvInput" maxlength="3" placeholder="123" required
                           class="block w-full rounded-lg border-gray-300 bg-gray-50 border px-3 py-2.5 text-sm font-mono focus:ring-2 focus:ring-blue-500 outline-none">
                </div>
            </div>
            <div>
                <label class="block text-xs font-medium text-gray-700 uppercase mb-1">Cardholder Name</label>
                <input type="text" name="cardholderName" placeholder="JOHN DOE" required
                       class="block w-full rounded-lg border-gray-300 bg-gray-50 border px-3 py-2.5 text-sm font-medium uppercase focus:ring-2 focus:ring-blue-500 outline-none">
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white py-2.5 rounded-lg font-medium hover:bg-blue-700 transition-colors shadow-lg shadow-blue-600/20 mt-2">
                Save Card
            </button>
        </form>
    </div>
</div>

<!-- MODAL: Delete Card -->
<div id="deleteCardModal" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" onclick="closeDeleteModal()"></div>
    <div class="modal-content relative w-full max-w-sm bg-white rounded-xl shadow-xl p-6 z-10 text-center">
        <div class="w-12 h-12 rounded-full bg-red-100 text-red-600 flex items-center justify-center mx-auto mb-4">
            <i data-lucide="trash-2" class="h-6 w-6"></i>
        </div>
        <h3 class="text-lg font-bold text-gray-900">Delete Card?</h3>
        <p class="text-sm text-gray-500 mt-2 mb-6">
            Are you sure you want to delete card ending in <span id="deleteCardLast4" class="font-mono font-bold text-gray-800"></span>?
        </p>
        <form id="deleteCardForm" method="POST" class="flex gap-3">
            <#if _csrf??><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/></#if>
            <button type="button" onclick="closeDeleteModal()" class="flex-1 py-2 rounded-lg border border-gray-300 text-gray-700 font-medium hover:bg-gray-50">Cancel</button>
            <button type="submit" class="flex-1 py-2 rounded-lg bg-red-600 text-white font-medium hover:bg-red-700">Delete</button>
        </form>
    </div>
</div>

<!-- MODAL: Block/Unblock -->
<div id="modal-block" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/65 backdrop-blur-sm" onclick="closeModal('modal-block')"></div>
    <div class="modal-content dark-modal w-full max-w-sm z-10">
        <div class="dark-modal-header">
            <h5 id="modal-block-title" class="dark-modal-title">Block Card</h5>
            <button class="dark-modal-close" onclick="closeModal('modal-block')">
                <i data-lucide="x" class="h-4 w-4"></i>
            </button>
        </div>
        <div class="dark-modal-body text-center">
            <div id="modal-block-icon" class="w-14 h-14 rounded-full bg-yellow-500/15 text-yellow-500 flex items-center justify-center mx-auto mb-4">
                <i data-lucide="slash" class="h-7 w-7"></i>
            </div>
            <p id="modal-block-desc" class="text-sm text-gray-400">
                Are you sure? All transactions will be declined until you unblock it.
            </p>
        </div>
        <div class="dark-modal-footer">
            <button class="dark-btn dark-btn-ghost" onclick="closeModal('modal-block')">Cancel</button>
            <button id="btn-confirm-block" class="dark-btn dark-btn-warning" onclick="confirmToggleBlock()">Block Card</button>
        </div>
    </div>
</div>

<!-- MODAL: Change PIN -->
<div id="modal-pin" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/65 backdrop-blur-sm" onclick="closeModal('modal-pin')"></div>
    <div class="modal-content dark-modal w-full max-w-sm z-10">
        <div class="dark-modal-header">
            <h5 class="dark-modal-title flex items-center gap-2">
                <i data-lucide="key" class="h-4 w-4" style="color:#2563eb;"></i>
                Change PIN
            </h5>
            <button class="dark-modal-close" onclick="closeModal('modal-pin')">
                <i data-lucide="x" class="h-4 w-4"></i>
            </button>
        </div>
        <div class="dark-modal-body">
            <div id="pin-current-wrap" style="margin-bottom:16px; display:none;">
                <label class="block text-xs font-medium text-gray-400 uppercase mb-1">
                    Current PIN <span style="color:#ef4444;">*</span>
                </label>
                <input id="pin-current" type="password" class="dark-input text-center" maxlength="4" placeholder="● ● ● ●" style="letter-spacing:0.6em; font-size:1.2rem;"/>
            </div>
            <div style="margin-bottom:16px;">
                <label class="block text-xs font-medium text-gray-400 uppercase mb-1">
                    New PIN <span style="color:#ef4444;">*</span>
                </label>
                <input id="pin-new" type="password" class="dark-input text-center" maxlength="4" placeholder="● ● ● ●" style="letter-spacing:0.6em; font-size:1.2rem;"/>
            </div>
            <div>
                <label class="block text-xs font-medium text-gray-400 uppercase mb-1">
                    Confirm PIN <span style="color:#ef4444;">*</span>
                </label>
                <input id="pin-confirm" type="password" class="dark-input text-center" maxlength="4" placeholder="● ● ● ●" style="letter-spacing:0.6em; font-size:1.2rem;"/>
            </div>
            <p id="pin-error" class="error-msg"></p>
        </div>
        <div class="dark-modal-footer">
            <button class="dark-btn dark-btn-ghost" onclick="closeModal('modal-pin')">Cancel</button>
            <button class="dark-btn dark-btn-primary" onclick="submitChangePin()">
                <span id="pin-btn-text">Update PIN</span>
                <span id="pin-btn-spinner" class="spinner" style="display:none;"></span>
            </button>
        </div>
    </div>
</div>

<!-- MODAL: Spending Limit -->
<div id="modal-limit" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/65 backdrop-blur-sm" onclick="closeModal('modal-limit')"></div>
    <div class="modal-content dark-modal w-full max-w-sm z-10">
        <div class="dark-modal-header">
            <h5 class="dark-modal-title flex items-center gap-2">
                <i data-lucide="gauge" class="h-4 w-4" style="color:#06b6d4;"></i>
                Spending Limit
            </h5>
            <button class="dark-modal-close" onclick="closeModal('modal-limit')">
                <i data-lucide="x" class="h-4 w-4"></i>
            </button>
        </div>
        <div class="dark-modal-body">
            <p class="text-sm text-gray-400 mb-4 text-center">
                Set a daily spending cap. Leave blank or enter 0 to remove it.
            </p>
            <div>
                <label class="block text-xs font-medium text-gray-400 uppercase mb-1">Daily Limit (USD)</label>
                <div style="position:relative;">
                    <span style="position:absolute; left:13px; top:10px; color:#64748b; font-size:0.9375rem;">$</span>
                    <input id="limit-amount" type="number" class="dark-input" min="0" step="0.01" placeholder="e.g. 500.00" style="padding-left:26px;"/>
                </div>
            </div>
            <p id="limit-error" class="error-msg"></p>
        </div>
        <div class="dark-modal-footer">
            <button class="dark-btn dark-btn-ghost" onclick="closeModal('modal-limit')">Cancel</button>
            <button class="dark-btn dark-btn-info" onclick="submitSpendingLimit()">
                <span id="limit-btn-text">Save Limit</span>
                <span id="limit-btn-spinner" class="spinner" style="display:none;"></span>
            </button>
        </div>
    </div>
</div>

<script>
    if (window.lucide) window.lucide.createIcons();

    let _activeCardId = null;
    let _cardIsActive = null;
    let _currentSpendingLimit = null;
    let _cardHasPin = false;

    // ── CARD FLIP ──────────────────────────────────────────────
    function toggleFlip(event, element) {
        if (event.target.closest('button')) return;
        element.closest('.card-container').classList.toggle('flipped');
    }
    function unflipCard(element) {
        element.querySelector('.card-container')?.classList.remove('flipped');
    }

    // ── CARD NUMBER ────────────────────────────────────────────
    function toggleCardNumber(cardId) {
        const el = document.getElementById('cardNumberText-' + cardId);
        if (!el) return;
        const isMasked = el.getAttribute('data-masked') === 'true';
        const full = el.getAttribute('data-full');
        if (isMasked) {
            el.textContent = full.match(/.{1,4}/g)?.join(' ') || full;
            el.setAttribute('data-masked', 'false');
            setTimeout(() => { if (el.getAttribute('data-masked') === 'false') toggleCardNumber(cardId); }, 5000);
        } else {
            el.textContent = '**** **** **** ' + full.substring(full.length - 4);
            el.setAttribute('data-masked', 'true');
        }
    }
    function copyCardNumber(text, btn) {
        navigator.clipboard.writeText(text).then(() => {
            const orig = btn.innerHTML;
            btn.innerHTML = '<i data-lucide="check" class="h-4 w-4 text-green-400"></i>';
            if (window.lucide) window.lucide.createIcons();
            setTimeout(() => { btn.innerHTML = orig; if (window.lucide) window.lucide.createIcons(); }, 1500);
        });
    }

    // ── MODAL HELPERS ──────────────────────────────────────────
    function openModal(id) {
        const el = document.getElementById(id);
        if (el) el.classList.add('open');
    }
    function closeModal(id) {
        const el = document.getElementById(id);
        if (!el) return;
        el.classList.remove('open');
        el.querySelectorAll('.error-msg').forEach(e => { e.style.display = 'none'; e.textContent = ''; });
    }

    function openAddCardModal() { openModal('addCardModal'); }
    function closeAddCardModal() { closeModal('addCardModal'); }

    function openDeleteModal(id, last4) {
        const form = document.getElementById('deleteCardForm');
        if (form) form.action = '/dashboard/cards/delete/' + id;
        const span = document.getElementById('deleteCardLast4');
        if (span) span.textContent = last4;
        openModal('deleteCardModal');
    }
    function closeDeleteModal() { closeModal('deleteCardModal'); }

    // ── CARD ACTIONS MODAL ─────────────────────────────────────
    function openCardActionsModal(cardId, isActive, spendingLimit) {
        _activeCardId = cardId;
        _cardIsActive = String(isActive) === 'true';
        _currentSpendingLimit = spendingLimit;

        const label = document.querySelector('#action-block .action-card-label');
        const icon  = document.querySelector('#action-block i');
        if (label) label.textContent = _cardIsActive ? 'Block Card' : 'Unblock Card';
        if (icon)  icon.setAttribute('data-lucide', _cardIsActive ? 'slash' : 'check-circle');
        if (window.lucide) window.lucide.createIcons();

        openModal('modal-card-actions');
    }

    function selectCardAction(action) {
        closeModal('modal-card-actions');
        setTimeout(() => {
            if (action === 'block')       openToggleBlockModal(_activeCardId, _cardIsActive);
            else if (action === 'pin')    openPinModal(_activeCardId, _cardHasPin);
            else if (action === 'limit')  openLimitModal(_activeCardId, _currentSpendingLimit);
        }, 200);
    }

    // ── BLOCK/UNBLOCK ──────────────────────────────────────────
    function openToggleBlockModal(cardId, isActive) {
        _activeCardId = cardId;
        _cardIsActive = isActive;

        const title = document.getElementById('modal-block-title');
        const desc  = document.getElementById('modal-block-desc');
        const icon  = document.getElementById('modal-block-icon');
        const btn   = document.getElementById('btn-confirm-block');

        if (isActive) {
            if (title) title.textContent = 'Block Card';
            if (desc)  desc.textContent  = 'Are you sure? All transactions will be declined until you unblock it.';
            if (icon)  { icon.className = 'w-14 h-14 rounded-full bg-yellow-500/15 text-yellow-500 flex items-center justify-center mx-auto mb-4'; icon.innerHTML = '<i data-lucide="slash" class="h-7 w-7"></i>'; }
            if (btn)   { btn.textContent = 'Block Card'; btn.className = 'dark-btn dark-btn-warning'; }
        } else {
            if (title) title.textContent = 'Unblock Card';
            if (desc)  desc.textContent  = 'This will restore full functionality. Continue?';
            if (icon)  { icon.className = 'w-14 h-14 rounded-full bg-green-500/15 text-green-500 flex items-center justify-center mx-auto mb-4'; icon.innerHTML = '<i data-lucide="check-circle" class="h-7 w-7"></i>'; }
            if (btn)   { btn.textContent = 'Unblock Card'; btn.className = 'dark-btn dark-btn-primary'; }
        }
        if (window.lucide) window.lucide.createIcons();
        openModal('modal-block');
    }

    async function confirmToggleBlock() {
        const btn = document.getElementById('btn-confirm-block');
        if (!btn) return;
        btn.disabled = true;
        const origText = btn.textContent;
        btn.textContent = 'Processing...';
        try {
            const res  = await fetch('/cards/' + _activeCardId + '/toggle-block', { method: 'POST' });
            const data = await res.json();
            if (data.success) {
                alert(data.message);
                closeModal('modal-block');
                location.reload();
            } else {
                alert(data.message || 'Operation failed');
            }
        } catch(e) {
            alert('Network error — please try again.');
        } finally {
            btn.disabled = false;
            btn.textContent = origText;
        }
    }

    // ── CHANGE PIN ─────────────────────────────────────────────
    function openPinModal(cardId, hasPin) {
        _activeCardId = cardId;
        const p0wrap = document.getElementById('pin-current-wrap');
        const p0 = document.getElementById('pin-current');
        const p1 = document.getElementById('pin-new');
        const p2 = document.getElementById('pin-confirm');
        if (p0) p0.value = '';
        if (p1) p1.value = '';
        if (p2) p2.value = '';
        // Show current PIN field only if card already has a PIN
        if (p0wrap) p0wrap.style.display = hasPin ? 'block' : 'none';
        openModal('modal-pin');
        setTimeout(() => { if (hasPin && p0) p0.focus(); else if (p1) p1.focus(); }, 120);
    }

    ['pin-new', 'pin-confirm'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', () => { el.value = el.value.replace(/\D/g, '').slice(0, 4); });
    });

    async function submitChangePin() {
        const p0  = document.getElementById('pin-current');
        const p1  = document.getElementById('pin-new');
        const p2  = document.getElementById('pin-confirm');
        const err = document.getElementById('pin-error');
        const bt  = document.getElementById('pin-btn-text');
        const sp  = document.getElementById('pin-btn-spinner');
        if (!p1 || !p2 || !err) return;

        const currentPin = p0 ? p0.value.trim() : '';
        const newPin     = p1.value.trim();
        const confPin    = p2.value.trim();
        err.style.display = 'none';

        if (!/^\d{4}$/.test(newPin)) { err.textContent = 'New PIN must be exactly 4 digits.'; err.style.display = 'block'; return; }
        if (newPin !== confPin)        { err.textContent = 'PINs do not match.'; err.style.display = 'block'; return; }

        if (bt) bt.style.display = 'none';
        if (sp) sp.style.display = 'inline-block';
        try {
            const body = { newPin, confirmPin: confPin };
            if (currentPin) body.currentPin = currentPin;
            const res  = await fetch('/cards/' + _activeCardId + '/change-pin', {
                method: 'POST', headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
            const data = await res.json();
            if (data.success) { closeModal('modal-pin'); location.reload(); }
            else { err.textContent = data.message || 'Failed to update PIN.'; err.style.display = 'block'; }
        } catch(e) {
            err.textContent = 'Network error.'; err.style.display = 'block';
        } finally {
            if (bt) bt.style.display = 'inline';
            if (sp) sp.style.display = 'none';
        }
    }

    // ── SPENDING LIMIT ─────────────────────────────────────────
    function openLimitModal(cardId, currentLimit) {
        _activeCardId = cardId;
        const input = document.getElementById('limit-amount');
        if (!input) return;
        const parsed = parseFloat(currentLimit);
        input.value = (!isNaN(parsed) && parsed > 0) ? parsed.toFixed(2) : '';
        openModal('modal-limit');
        setTimeout(() => input.focus(), 120);
    }

    async function submitSpendingLimit() {
        const input = document.getElementById('limit-amount');
        const bt    = document.getElementById('limit-btn-text');
        const sp    = document.getElementById('limit-btn-spinner');
        const err   = document.getElementById('limit-error');
        if (!input || !err) return;

        err.style.display = 'none';
        const raw   = input.value.trim();
        const limit = raw === '' ? 0 : parseFloat(raw);
        if (isNaN(limit) || limit < 0) { err.textContent = 'Please enter a valid positive amount.'; err.style.display = 'block'; return; }

        if (bt) bt.style.display = 'none';
        if (sp) sp.style.display = 'inline-block';
        try {
            const res  = await fetch('/cards/' + _activeCardId + '/spending-limit', {
                method: 'POST', headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ limit: limit === 0 ? null : limit })
            });
            const data = await res.json();
            if (data.success) {
                closeModal('modal-limit');
                location.reload();
            } else { err.textContent = data.message || 'Failed.'; err.style.display = 'block'; }
        } catch(e) {
            err.textContent = 'Network error.'; err.style.display = 'block';
        } finally {
            if (bt) bt.style.display = 'inline';
            if (sp) sp.style.display = 'none';
        }
    }

    // ── INPUT FORMATTERS ───────────────────────────────────────
    document.getElementById('cardNumberInput')?.addEventListener('input', e => {
        let v = e.target.value.replace(/\D/g, '').substring(0, 16);
        e.target.value = v.match(/.{1,4}/g)?.join(' ') || v;
    });
    document.getElementById('expiryDateInput')?.addEventListener('input', e => {
        let v = e.target.value.replace(/\D/g, '');
        if (v.length >= 2) v = v.substring(0, 2) + '/' + v.substring(2, 4);
        e.target.value = v.substring(0, 5);
    });
    document.getElementById('cvvInput')?.addEventListener('input', e => {
        e.target.value = e.target.value.replace(/\D/g, '').substring(0, 3);
    });

    // ── ALERT AUTO-DISMISS ─────────────────────────────────────
    setTimeout(() => {
        const box = document.getElementById('alert-box');
        if (box) { box.style.opacity = '0'; setTimeout(() => box.remove(), 300); }
    }, 4000);

    setTimeout(() => { if (window.lucide) window.lucide.createIcons(); }, 100);
</script>

</body>
</html>
