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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Inter', sans-serif; }
        .font-mono { font-family: 'JetBrains Mono', monospace; }

        /* 3D Flip Styles */
        .perspective-1000 {
            perspective: 1200px;
        }

        .card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            transform-style: preserve-3d;
        }

        .card-container.flipped .card-inner {
            transform: rotateY(180deg);
        }

        .card-front, .card-back {
            position: absolute;
            width: 100%;
            height: 100%;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            border-radius: 1rem;
            overflow: hidden;
        }

        .card-back {
            transform: rotateY(180deg);
        }

        /* Modal Animation */
        .modal {
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease-in-out;
        }
        .modal.open {
            opacity: 1;
            visibility: visible;
        }
        .modal-content {
            transform: scale(0.95) translateY(10px);
            transition: all 0.3s ease-in-out;
        }
        .modal.open .modal-content {
            transform: scale(1) translateY(0);
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-900">

<div class="flex min-h-screen w-full">

    <aside class="sidebar hidden lg:flex flex-col border-r border-gray-200 bg-white px-6 py-6">
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
                <i data-lucide="credit-card" class="h-4 w-4"></i> My Accounts
            </a>
            <a href="/dashboard/cards" class="group flex items-center gap-3 rounded-md bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700">
                <i data-lucide="credit-card" class="h-4 w-4"></i> My Cards
            </a>
            <a href="/dashboard/payment" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
                <i data-lucide="send" class="h-4 w-4"></i> Make Payment
            </a>
            <a href="/dashboard/transactions" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
                <i data-lucide="list" class="h-4 w-4"></i> Transactions
            </a>
            <a href="/dashboard/settings" class="group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100">
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

        <#if successMessage??>
            <div id="alert-box" class="mb-6 rounded-md bg-green-50 p-4 border border-green-200 flex items-center gap-3">
                <i data-lucide="check-circle" class="h-5 w-5 text-green-500"></i>
                <p class="text-sm font-medium text-green-800">${successMessage}</p>
            </div>
        </#if>
        <#if errorMessage??>
            <div id="alert-box" class="mb-6 rounded-md bg-red-50 p-4 border border-red-200 flex items-center gap-3">
                <i data-lucide="alert-circle" class="h-5 w-5 text-red-500"></i>
                <p class="text-sm font-medium text-red-800">${errorMessage}</p>
            </div>
        </#if>

        <div class="space-y-6 animate-fade-in mx-auto max-w-5xl">
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">My Cards</h1>
                    <p class="text-gray-500">Manage your physical and virtual cards</p>
                </div>
                <button onclick="openModal()" class="inline-flex items-center justify-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all">
                    <i data-lucide="plus" class="h-4 w-4 mr-2"></i> Add Card
                </button>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
                <#list cards as card>
                    <#assign themeIndex = card?index % 3>
                    <#assign gradientClass = "">

                    <#if themeIndex == 0>
                        <#assign gradientClass = "bg-gradient-to-br from-[#1a1a2e] via-[#16213e] to-[#0f3460]">
                    <#elseif themeIndex == 1>
                        <#assign gradientClass = "bg-gradient-to-br from-[#0d0d0d] via-[#1a1a2e] to-[#2d2d44]">
                    <#else>
                        <#assign gradientClass = "bg-gradient-to-br from-[#134e5e] via-[#1a6b7a] to-[#71b280]">
                    </#if>

                    <div class="group perspective-1000 h-[240px]" onmouseleave="unflipCard(this)">
                        <div class="card-container w-full h-full cursor-pointer relative" onclick="toggleFlip(this)">
                            <div class="card-inner w-full h-full shadow-2xl rounded-2xl transition-all duration-300 group-hover:shadow-[0_20px_60px_-15px_rgba(0,0,0,0.5)]">

                                <div class="card-front ${gradientClass} p-6 flex flex-col justify-between text-white">
                                    <div class="absolute inset-0 bg-gradient-to-br from-white/10 via-transparent to-transparent pointer-events-none"></div>
                                    <div class="absolute top-0 right-0 w-48 h-48 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2 pointer-events-none"></div>
                                    <div class="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-1/2 -translate-x-1/2 pointer-events-none"></div>

                                    <div class="relative flex justify-between items-start z-10">
                                        <span class="text-white/90 text-sm font-bold tracking-[0.2em] uppercase">
                                            PAYFLOW
                                        </span>
                                        <i data-lucide="wifi" class="h-5 w-5 text-white/60 rotate-90"></i>
                                    </div>

                                    <div class="relative flex items-center gap-4 z-10">
                                        <div class="w-12 h-9 rounded-md bg-gradient-to-br from-yellow-300/90 via-yellow-400/80 to-yellow-600/70 shadow-inner flex items-center justify-center">
                                            <div class="w-8 h-6 rounded-sm border border-yellow-700/30 grid grid-cols-3 grid-rows-2 gap-px overflow-hidden">
                                                <div class="bg-yellow-500/40"></div><div class="bg-yellow-500/40"></div><div class="bg-yellow-500/40"></div>
                                                <div class="bg-yellow-500/40"></div><div class="bg-yellow-500/40"></div><div class="bg-yellow-500/40"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="relative z-10">
                                        <p class="text-lg sm:text-xl font-mono tracking-[0.15em] drop-shadow-md">
                                            **** **** **** ${card.cardNumber?substring(card.cardNumber?length - 4)}
                                        </p>
                                    </div>

                                    <div class="relative flex justify-between items-end z-10">
                                        <div>
                                            <p class="text-white/40 text-[9px] uppercase tracking-widest mb-0.5">Card Holder</p>
                                            <p class="text-sm font-semibold tracking-wide uppercase">${card.cardholderName}</p>
                                        </div>
                                        <span class="text-white/90 text-xs font-bold tracking-[0.15em] uppercase">
                                            <#if card.cardNumber?starts_with("4")>VISA<#else>MASTERCARD</#if>
                                        </span>
                                    </div>
                                </div>

                                <div class="card-back ${gradientClass} flex flex-col">
                                    <div class="absolute inset-0 bg-gradient-to-br from-white/5 via-transparent to-transparent pointer-events-none"></div>

                                    <div class="w-full h-12 bg-black/60 mt-6 relative z-10"></div>

                                    <div class="px-6 mt-4 flex-1 flex flex-col justify-between pb-6 relative z-10">
                                        <div class="flex items-start justify-between gap-4">
                                            <div class="text-left">
                                                <p class="text-white/40 text-[9px] uppercase tracking-widest mb-0.5">Valid Thru</p>
                                                <p class="text-white text-sm font-semibold">
                                                    <#-- ✅ ВИПРАВЛЕНО: використовуємо новий метод -->
                                                    ${card.formattedExpiryDate}
                                                </p>
                                            </div>
                                            <div class="text-right">
                                                <div class="bg-white/10 rounded px-4 py-1.5 inline-block">
                                                    <span class="text-white font-mono text-lg tracking-widest">${card.cvv}</span>
                                                </div>
                                                <p class="text-white/30 text-[9px] mt-1 uppercase tracking-wider">CVV</p>
                                            </div>
                                        </div>

                                        <div class="flex items-center justify-between mt-auto">
                                            <div class="flex items-center gap-2">
                                                <i data-lucide="credit-card" class="h-4 w-4 text-white/30"></i>
                                                <p class="text-white/30 text-[10px] tracking-wider">PayFlow Bank</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </#list>

                <div onclick="openModal()" class="group h-[240px] border-2 border-dashed border-gray-300 rounded-2xl flex flex-col items-center justify-center cursor-pointer hover:border-blue-500 hover:bg-blue-50 transition-colors">
                    <div class="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center group-hover:bg-blue-100 transition-colors">
                        <i data-lucide="plus" class="h-6 w-6 text-gray-400 group-hover:text-blue-600"></i>
                    </div>
                    <p class="mt-4 text-sm font-medium text-gray-500 group-hover:text-blue-600">Add New Card</p>
                </div>
            </div>
        </div>
    </main>
</div>

<div id="addCardModal" class="modal fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" onclick="closeModal()"></div>

    <div class="modal-content relative w-full max-w-md bg-white rounded-xl shadow-2xl p-6 m-4 z-10">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-900">Add New Card</h2>
            <button type="button" onclick="closeModal()" class="text-gray-400 hover:text-gray-600 transition-colors" aria-label="Close modal">
                <i data-lucide="x" class="h-5 w-5"></i>
            </button>
        </div>

        <form action="/dashboard/cards/add" method="POST" class="space-y-4">
            <div class="space-y-2">
                <label for="cardNumberInput" class="text-sm font-medium text-gray-700">Card Number</label>
                <input type="text" name="cardNumber" id="cardNumberInput" maxlength="19" placeholder="0000 0000 0000 0000" required
                       class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>

            <div class="grid grid-cols-2 gap-4">
                <div class="space-y-2">
                    <label for="expiryDateInput" class="text-sm font-medium text-gray-700">Expiry Date</label>
                    <input type="text" name="expiryDate" id="expiryDateInput" maxlength="5" placeholder="MM/YY" required
                           class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>
                <div class="space-y-2">
                    <label for="cvvInput" class="text-sm font-medium text-gray-700">CVV</label>
                    <input type="text" name="cvv" id="cvvInput" maxlength="3" placeholder="123" required
                           class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                </div>
            </div>

            <div class="space-y-2">
                <label for="cardholderNameInput" class="text-sm font-medium text-gray-700">Cardholder Name</label>
                <input type="text" name="cardholderName" id="cardholderNameInput" placeholder="JOHN DOE" required
                       class="flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase">
            </div>

            <div class="pt-2 flex justify-end gap-3">
                <button type="button" onclick="closeModal()" class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-md transition-colors">
                    Cancel
                </button>
                <button type="submit" class="px-4 py-2 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-md shadow-sm transition-colors">
                    Add Card
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    if (window.lucide) {
        window.lucide.createIcons();
    }

    function toggleFlip(element) {
        const container = element.closest('.card-container');
        container.classList.toggle('flipped');
    }

    function unflipCard(element) {
        const container = element.querySelector('.card-container');
        if (container) {
            container.classList.remove('flipped');
        }
    }

    function openModal() {
        const modal = document.getElementById('addCardModal');
        modal.classList.add('open');
    }

    function closeModal() {
        const modal = document.getElementById('addCardModal');
        modal.classList.remove('open');
    }

    // ✅ Форматування номера картки (0000 0000 0000 0000)
    const cardInput = document.getElementById('cardNumberInput');
    if (cardInput) {
        cardInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, '');
            value = value.substring(0, 16);
            e.target.value = value.match(/.{1,4}/g)?.join(' ') || value;
        });
    }

    // ✅ Форматування дати експірації (MM/YY)
    const expiryInput = document.getElementById('expiryDateInput');
    if (expiryInput) {
        expiryInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, '');

            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }

            e.target.value = value.substring(0, 5);
        });
    }

    // ✅ Тільки цифри для CVV
    const cvvInput = document.getElementById('cvvInput');
    if (cvvInput) {
        cvvInput.addEventListener('input', function (e) {
            e.target.value = e.target.value.replace(/\D/g, '').substring(0, 3);
        });
    }

    // Auto-hide alerts after 4 seconds
    setTimeout(() => {
        const alertBox = document.getElementById('alert-box');
        if (alertBox) {
            alertBox.style.transition = "opacity 0.5s";
            alertBox.style.opacity = "0";
            setTimeout(() => alertBox.remove(), 500);
        }
    }, 4000);
</script>
</body>
</html>