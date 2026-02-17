<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Card - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; }

        /* ── Sidebar ── */
        .sidebar { min-height: 100vh; width: 210px; position: fixed; top: 0; left: 0; z-index: 100;
                   display: flex; flex-direction: column; background: #fff; border-right: 1px solid #e5e7eb; }
        .main-content { margin-left: 210px; min-height: 100vh; }

        /* ── Card preview ── */
        .card-preview {
            width: 100%; aspect-ratio: 1.586;
            border-radius: 1.25rem;
            background: linear-gradient(135deg, #1e2535 0%, #2d3650 100%);
            padding: 1.4rem 1.5rem;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        .card-preview::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 80% 20%, rgba(99,102,241,0.3) 0%, transparent 60%);
        }
        .card-preview.visa-card {
            background: linear-gradient(135deg, #0f1923 0%, #1a2744 50%, #0d2137 100%);
        }
        .card-preview.mc-card {
            background: linear-gradient(135deg, #1a0a2e 0%, #2d1060 50%, #1a1535 100%);
        }
        .card-number-preview {
            font-family: 'Share Tech Mono', monospace;
            font-size: 1.05rem; letter-spacing: 0.18em;
        }

        /* ── Form inputs ── */
        .form-input {
            width: 100%; border: 1.5px solid #e5e7eb; border-radius: 0.6rem;
            padding: 0.7rem 1rem; font-size: 0.95rem; background: #fff;
            transition: border-color 0.2s, box-shadow 0.2s; outline: none;
        }
        .form-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }
        .form-input.error { border-color: #ef4444; }
        .form-label { font-size: 0.82rem; font-weight: 600; color: #374151;
                      text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 0.4rem; display: block; }
        .error-msg { color: #ef4444; font-size: 0.78rem; margin-top: 0.3rem; display: none; }
    </style>
</head>
<body>
<div class="flex min-h-screen w-full">

    <!-- ── SIDEBAR ── -->
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

    <!-- ── MAIN ── -->
    <main class="main-content flex-1 lg:ml-64 p-8 overflow-y-auto min-h-screen">
        <div class="max-w-5xl mx-auto">

            <!-- Header -->
            <div class="flex items-center gap-4 mb-8">
                <a href="/dashboard/cards"
                   class="flex items-center gap-2 text-sm font-medium text-gray-600 hover:text-blue-600 transition-colors">
                    <i data-lucide="arrow-left" class="h-4 w-4"></i> Back to Cards
                </a>
                <div class="h-4 w-px bg-gray-300"></div>
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">Add New Card</h1>
                    <p class="text-sm text-gray-500 mt-0.5">Enter your credit card details</p>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">

                <!-- ── FORM ── -->
                <div class="lg:col-span-3">
                    <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-8">

                        <#if errorMessage??>
                        <div class="mb-6 flex items-center gap-3 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                            <i data-lucide="alert-circle" class="h-4 w-4 shrink-0"></i>
                            ${errorMessage}
                        </div>
                        </#if>

                        <form action="/dashboard/cards/add" method="POST" id="addCardForm" novalidate>

                            <!-- Card Number -->
                            <div class="mb-5">
                                <label class="form-label" for="cardNumber">Card Number <span class="text-red-500">*</span></label>
                                <input type="text" id="cardNumber" name="cardNumber"
                                       class="form-input" placeholder="1234 5678 9012 3456" maxlength="19" required autocomplete="cc-number">
                                <p class="error-msg" id="err-cardNumber">Please enter a valid 16-digit card number.</p>
                            </div>

                            <!-- Cardholder Name -->
                            <div class="mb-5">
                                <label class="form-label" for="cardholderName">Cardholder Name <span class="text-red-500">*</span></label>
                                <input type="text" id="cardholderName" name="cardholderName"
                                       class="form-input uppercase" placeholder="IVAN PETRENKO" required autocomplete="cc-name">
                                <p class="error-msg" id="err-cardholderName">Please enter the cardholder name.</p>
                            </div>

                            <!-- Expiry + CVV -->
                            <div class="grid grid-cols-2 gap-4 mb-5">
                                <div>
                                    <label class="form-label" for="expiryDate">Expiry Date <span class="text-red-500">*</span></label>
                                    <input type="text" id="expiryDate" name="expiryDate"
                                           class="form-input" placeholder="MM/YY" maxlength="5" required autocomplete="cc-exp">
                                    <p class="error-msg" id="err-expiryDate">Format: MM/YY</p>
                                </div>
                                <div>
                                    <label class="form-label" for="cvv">CVV <span class="text-red-500">*</span></label>
                                    <input type="password" id="cvv" name="cvv"
                                           class="form-input" placeholder="•••" maxlength="3" required autocomplete="cc-csc">
                                    <p class="error-msg" id="err-cvv">3-digit CVV required.</p>
                                </div>
                            </div>

                            <!-- Security note -->
                            <div class="mb-7 flex items-start gap-3 rounded-xl bg-blue-50 border border-blue-100 px-4 py-3">
                                <i data-lucide="shield-check" class="h-5 w-5 text-blue-600 shrink-0 mt-0.5"></i>
                                <div>
                                    <p class="text-sm font-semibold text-blue-900">Secure & Encrypted</p>
                                    <p class="text-xs text-blue-700 mt-0.5">Your card data is protected with 256-bit encryption. CVV is never stored.</p>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="flex items-center gap-3">
                                <button type="submit" id="submitBtn"
                                        class="flex items-center gap-2 rounded-xl bg-gray-900 px-6 py-2.5 text-sm font-semibold text-white hover:bg-black transition-colors">
                                    <i data-lucide="plus" class="h-4 w-4"></i> Add Card
                                </button>
                                <a href="/dashboard/cards"
                                   class="rounded-xl border border-gray-200 px-6 py-2.5 text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-colors">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ── PREVIEW ── -->
                <div class="lg:col-span-2">
                    <div class="sticky top-8">
                        <p class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3">Card Preview</p>

                        <div class="card-preview" id="cardPreview">
                            <!-- Card top row -->
                            <div class="relative z-10 flex justify-between items-start mb-4">
                                <div class="flex items-center gap-1.5">
                                    <i data-lucide="wallet" class="h-4 w-4 opacity-70"></i>
                                    <span class="text-sm font-semibold opacity-90">PayFlow</span>
                                </div>
                                <div id="previewNetwork" class="text-xl font-black italic tracking-tighter opacity-0 transition-opacity duration-300">VISA</div>
                            </div>

                            <!-- Chip -->
                            <div class="relative z-10 mb-4">
                                <div style="width:40px;height:30px;background:linear-gradient(135deg,#d4a017,#f5c842);border-radius:5px;border:1px solid rgba(255,255,255,0.3);"></div>
                            </div>

                            <!-- Card Number -->
                            <div class="relative z-10 mb-5">
                                <p class="card-number-preview text-white/90 text-lg" id="previewNumber">•••• •••• •••• ••••</p>
                            </div>

                            <!-- Bottom row -->
                            <div class="relative z-10 flex justify-between items-end">
                                <div>
                                    <p class="text-[8px] uppercase text-white/50 mb-0.5">Card Holder</p>
                                    <p class="font-medium text-sm uppercase tracking-wide" id="previewName">YOUR NAME</p>
                                </div>
                                <div>
                                    <p class="text-[8px] uppercase text-white/50 mb-0.5">Expires</p>
                                    <p class="font-medium text-sm" id="previewExpiry">MM/YY</p>
                                </div>
                            </div>
                        </div>

                        <!-- Hint -->
                        <p class="text-xs text-gray-400 text-center mt-3">
                            <i data-lucide="info" class="h-3 w-3 inline mr-1"></i>
                            Fill the form to see the preview
                        </p>

                        <!-- PIN hint box -->
                        <div class="mt-6 rounded-xl border border-amber-200 bg-amber-50 px-4 py-4">
                            <div class="flex items-start gap-2">
                                <i data-lucide="key-round" class="h-4 w-4 text-amber-600 shrink-0 mt-0.5"></i>
                                <div>
                                    <p class="text-sm font-semibold text-amber-900">PIN Code</p>
                                    <p class="text-xs text-amber-700 mt-1">After adding the card, you can set a PIN via the <span class="font-semibold">⚙ settings</span> button on the card. You can change it anytime — the old PIN will be required.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

<script>
    if (window.lucide) window.lucide.createIcons();

    // ── Live preview ──
    const numInput  = document.getElementById('cardNumber');
    const nameInput = document.getElementById('cardholderName');
    const expInput  = document.getElementById('expiryDate');

    numInput.addEventListener('input', function() {
        // Format as groups of 4
        let raw = this.value.replace(/\D/g, '').slice(0, 16);
        this.value = raw.match(/.{1,4}/g)?.join(' ') || raw;

        const display = raw.padEnd(16, '•');
        document.getElementById('previewNumber').textContent =
            display.slice(0,4) + ' ' + display.slice(4,8) + ' ' + display.slice(8,12) + ' ' + display.slice(12,16);

        // Detect network
        const net = document.getElementById('previewNetwork');
        const preview = document.getElementById('cardPreview');
        if (raw.startsWith('4')) {
            net.textContent = 'VISA';
            net.style.opacity = '0.9';
            preview.classList.add('visa-card');
            preview.classList.remove('mc-card');
        } else if (raw.startsWith('5') || raw.startsWith('2')) {
            // MasterCard — show circles
            net.innerHTML = '<div class="flex -space-x-2"><div class="w-6 h-6 rounded-full bg-red-500/80"></div><div class="w-6 h-6 rounded-full bg-yellow-500/80"></div></div>';
            net.style.opacity = '1';
            preview.classList.add('mc-card');
            preview.classList.remove('visa-card');
        } else {
            net.textContent = '';
            net.style.opacity = '0';
            preview.classList.remove('visa-card', 'mc-card');
        }
        if (window.lucide) window.lucide.createIcons();
    });

    nameInput.addEventListener('input', function() {
        this.value = this.value.toUpperCase();
        document.getElementById('previewName').textContent = this.value || 'YOUR NAME';
    });

    expInput.addEventListener('input', function() {
        let raw = this.value.replace(/\D/g, '');
        if (raw.length >= 2) raw = raw.slice(0,2) + '/' + raw.slice(2,4);
        this.value = raw;
        document.getElementById('previewExpiry').textContent = this.value || 'MM/YY';
    });

    // CVV — digits only
    document.getElementById('cvv').addEventListener('input', function() {
        this.value = this.value.replace(/\D/g, '').slice(0,3);
    });

    // ── Form validation ──
    document.getElementById('addCardForm').addEventListener('submit', function(e) {
        let valid = true;

        const cardNum = numInput.value.replace(/\s/g, '');
        if (!/^\d{16}$/.test(cardNum)) {
            showError('err-cardNumber', 'cardNumber'); valid = false;
        } else hideError('err-cardNumber', 'cardNumber');

        if (!nameInput.value.trim()) {
            showError('err-cardholderName', 'cardholderName'); valid = false;
        } else hideError('err-cardholderName', 'cardholderName');

        if (!/^\d{2}\/\d{2}$/.test(expInput.value)) {
            showError('err-expiryDate', 'expiryDate'); valid = false;
        } else hideError('err-expiryDate', 'expiryDate');

        const cvv = document.getElementById('cvv').value;
        if (!/^\d{3}$/.test(cvv)) {
            showError('err-cvv', 'cvv'); valid = false;
        } else hideError('err-cvv', 'cvv');

        if (!valid) e.preventDefault();
    });

    function showError(errId, inputId) {
        document.getElementById(errId).style.display = 'block';
        document.getElementById(inputId).classList.add('error');
    }
    function hideError(errId, inputId) {
        document.getElementById(errId).style.display = 'none';
        document.getElementById(inputId).classList.remove('error');
    }

    setTimeout(() => { if (window.lucide) window.lucide.createIcons(); }, 100);
</script>
</body>
</html>
