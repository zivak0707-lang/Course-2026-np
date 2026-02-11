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
        .animate-fade-in {
            animation: fadeIn 0.4s ease-out forwards;
        }

        .perspective-1000 { perspective: 1200px; }
        .card-container {
            position: relative;
            width: 100%;
            height: 100%;
            transition: transform 0.6s cubic-bezier(0.4, 0.0, 0.2, 1);
            transform-style: preserve-3d;
        }
        .card-container.flipped { transform: rotateY(180deg); }

        .card-face {
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            position: absolute;
            inset: 0;
            border-radius: 1.25rem;
            overflow: hidden;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.2), 0 8px 10px -6px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* Додано z-index для доступності кнопок на звороті */
        .card-back {
            transform: rotateY(180deg);
            z-index: 20;
        }

        .chip-metallic {
            background: linear-gradient(135deg, #fce3b4 0%, #eec476 50%, #d4af37 100%);
            box-shadow: inset 0 1px 2px rgba(255,255,255,0.4), 0 1px 2px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
        }

        .text-shadow-sm { text-shadow: 0 1px 2px rgba(0,0,0,0.5); }

        .modal {
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.2s ease, visibility 0.2s;
        }
        .modal.open { opacity: 1; visibility: visible; }
        .modal-content {
            transform: scale(0.95);
            transition: transform 0.2s ease;
        }
        .modal.open .modal-content { transform: scale(1); }
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
                <i data-lucide="credit-card" class="h-4 w-4"></i> My Accounts
            </a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700 transition-colors">
                <i data-lucide="credit-card" class="h-4 w-4"></i> My Cards
            </a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="send" class="h-4 w-4"></i> Make Payment
            </a>
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors">
                <i data-lucide="list" class="h-4 w-4"></i> Transactions
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
                <button onclick="openModal()" class="inline-flex items-center justify-center rounded-lg bg-gray-900 px-5 py-2 text-sm font-medium text-white shadow hover:bg-black transition-all">
                    <i data-lucide="plus" class="h-4 w-4 mr-2"></i> Add Card
                </button>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
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
                        <div class="card-container w-full h-full relative cursor-pointer" onclick="toggleFlip(event, this)">

                            <div class="card-face card-front ${bgClass} p-6 flex flex-col justify-between text-white">
                                <div class="absolute inset-0 bg-gradient-to-tr from-white/5 to-transparent pointer-events-none"></div>

                                <div class="relative z-10 flex justify-between items-start">
                                    <div class="flex items-center gap-2">
                                        <i data-lucide="wallet" class="h-5 w-5 text-white/90"></i>
                                        <span class="font-bold text-sm tracking-wide opacity-90">PayFlow</span>
                                    </div>
                                    <i data-lucide="wifi" class="h-6 w-6 text-white/70 rotate-90"></i>
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
                    </div>
                </#list>

                <button onclick="openModal()" class="h-[220px] border-2 border-dashed border-gray-200 rounded-[1.25rem] flex flex-col items-center justify-center hover:border-blue-500 hover:bg-blue-50/30 transition-all duration-300 bg-white group">
                    <div class="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all duration-300 text-gray-400">
                        <i data-lucide="plus" class="h-6 w-6"></i>
                    </div>
                    <span class="mt-4 text-sm font-semibold text-gray-500 group-hover:text-blue-600">Add New Card</span>
                </button>
            </div>
        </div>
    </main>
</div>

<div id="addCardModal" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" onclick="closeModal()"></div>
    <div class="modal-content relative w-full max-w-md bg-white rounded-xl shadow-2xl p-6 z-10">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-900">Add New Card</h2>
            <button onclick="closeModal()" class="text-gray-400 hover:text-gray-600">
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

<script>
    if (window.lucide) window.lucide.createIcons();

    function toggleFlip(event, element) {
        // Перевірка, чи не був клік по кнопці (ігноруємо переворот)
        if (event.target.closest('button')) return;

        element.closest('.card-container').classList.toggle('flipped');
    }

    function unflipCard(element) {
        element.querySelector('.card-container')?.classList.remove('flipped');
    }

    function toggleCardNumber(cardId) {
        const textElement = document.getElementById('cardNumberText-' + cardId);
        if (!textElement) return;
        const isMasked = textElement.getAttribute('data-masked') === 'true';
        const fullNumber = textElement.getAttribute('data-full');

        if (isMasked) {
            textElement.textContent = fullNumber.match(/.{1,4}/g)?.join(' ') || fullNumber;
            textElement.setAttribute('data-masked', 'false');
            setTimeout(() => { if (textElement.getAttribute('data-masked') === 'false') toggleCardNumber(cardId); }, 5000);
        } else {
            textElement.textContent = '**** **** **** ' + fullNumber.substring(fullNumber.length - 4);
            textElement.setAttribute('data-masked', 'true');
        }
    }

    function copyCardNumber(text, btn) {
        navigator.clipboard.writeText(text).then(() => {
            const original = btn.innerHTML;
            btn.innerHTML = '<i data-lucide="check" class="h-4 w-4 text-green-400"></i>';
            if (window.lucide) window.lucide.createIcons();
            setTimeout(() => { btn.innerHTML = original; if (window.lucide) window.lucide.createIcons(); }, 1500);
        });
    }

    function openModal() { document.getElementById('addCardModal').classList.add('open'); }
    function closeModal() { document.getElementById('addCardModal').classList.remove('open'); }

    function openDeleteModal(id, last4) {
        const form = document.getElementById('deleteCardForm');
        form.action = '/dashboard/cards/delete/' + id;
        document.getElementById('deleteCardLast4').textContent = last4;
        document.getElementById('deleteCardModal').classList.add('open');
    }
    function closeDeleteModal() { document.getElementById('deleteCardModal').classList.remove('open'); }

    // Input Formatters
    document.getElementById('cardNumberInput')?.addEventListener('input', e => {
        let v = e.target.value.replace(/\D/g, '').substring(0,16);
        e.target.value = v.match(/.{1,4}/g)?.join(' ') || v;
    });
    document.getElementById('expiryDateInput')?.addEventListener('input', e => {
        let v = e.target.value.replace(/\D/g, '');
        if(v.length >= 2) v = v.substring(0,2) + '/' + v.substring(2,4);
        e.target.value = v.substring(0,5);
    });
    document.getElementById('cvvInput')?.addEventListener('input', e => {
        e.target.value = e.target.value.replace(/\D/g, '').substring(0,3);
    });

    setTimeout(() => {
        const box = document.getElementById('alert-box');
        if(box) { box.style.opacity = '0'; setTimeout(() => box.remove(), 300); }
    }, 4000);
</script>

</body>
</html>