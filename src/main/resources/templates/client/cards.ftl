<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cards - PayFlow</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
    <style>
        .credit-card-3d {
            perspective: 1000px;
            cursor: pointer;
        }
        .credit-card-inner {
            position: relative;
            width: 100%;
            height: 200px;
            transition: transform 0.6s;
            transform-style: preserve-3d;
        }
        .credit-card-3d:hover .credit-card-inner {
            transform: rotateY(180deg);
        }
        .credit-card-front, .credit-card-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            border-radius: 1rem;
            padding: 1.5rem;
            color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        .credit-card-back {
            transform: rotateY(180deg);
        }
        .card-chip {
            width: 50px;
            height: 35px;
            background: linear-gradient(135deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0.1) 100%);
            border-radius: 6px;
            position: relative;
            overflow: hidden;
        }
        .card-chip::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 70%;
            height: 70%;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            border-radius: 3px;
        }
        .magnetic-strip {
            width: calc(100% + 3rem);
            height: 45px;
            background: rgba(0,0,0,0.4);
            margin: -1.5rem -1.5rem 1rem -1.5rem;
        }
    </style>
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="p-3 border-bottom">
                <a href="/" class="text-decoration-none">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-wallet2 fs-4 text-primary"></i>
                        <span class="fs-5 fw-bold text-primary">PayFlow</span>
                    </div>
                </a>
            </div>

            <nav class="sidebar-nav p-3">
                <a href="/dashboard" class="nav-link">
                    <i class="bi bi-grid-fill"></i>
                    <span>Dashboard</span>
                </a>
                <a href="/dashboard/accounts" class="nav-link">
                    <i class="bi bi-wallet2"></i>
                    <span>My Accounts</span>
                </a>
                <a href="/dashboard/cards" class="nav-link active">
                    <i class="bi bi-credit-card"></i>
                    <span>My Cards</span>
                </a>
                <a href="/dashboard/payment" class="nav-link">
                    <i class="bi bi-send"></i>
                    <span>Make Payment</span>
                </a>
                <a href="/dashboard/transactions" class="nav-link">
                    <i class="bi bi-list-ul"></i>
                    <span>Transactions</span>
                </a>
                <a href="/dashboard/settings" class="nav-link">
                    <i class="bi bi-gear"></i>
                    <span>Settings</span>
                </a>
            </nav>

            <div class="p-3 border-top mt-auto">
                <a href="/logout" class="nav-link text-muted">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Bar -->
            <header class="bg-white border-bottom sticky-top">
                <div class="d-flex align-items-center justify-content-between p-3 p-lg-4">
                    <button class="btn btn-link d-lg-none p-0 text-dark" onclick="toggleSidebar()">
                        <i class="bi bi-list fs-3"></i>
                    </button>
                    
                    <div class="flex-grow-1"></div>

                    <div class="dropdown">
                        <button class="btn btn-link text-dark text-decoration-none dropdown-toggle d-flex align-items-center gap-2" 
                                type="button" data-bs-toggle="dropdown">
                            <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center" 
                                 style="width: 40px; height: 40px;">
                                <span class="fw-semibold text-primary">JD</span>
                            </div>
                            <span class="fw-medium d-none d-sm-inline">John Doe</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-person me-2"></i> Profile</a></li>
                            <li><a class="dropdown-item" href="/dashboard/settings"><i class="bi bi-gear me-2"></i> Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="/logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <!-- Content -->
            <main class="p-3 p-lg-4">
                <div class="animate-fade-in">
                    <!-- Header -->
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3 mb-4">
                        <div>
                            <h1 class="h3 fw-bold mb-1">My Cards</h1>
                            <p class="text-muted mb-0">Manage your payment cards</p>
                        </div>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCardModal">
                            <i class="bi bi-plus-lg me-2"></i> Add Card
                        </button>
                    </div>

                    <!-- Cards Grid -->
                    <div class="row g-4">
                        <#if cards?? && cards?size gt 0>
                            <#list cards as card>
                            <#-- Визначаємо тип картки за номером --/>
                            <#assign cardType = "VISA">
                            <#assign cardGradient = "linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%)">
                            <#if card.cardNumber?ends_with("7890")>
                                <#assign cardType = "MASTERCARD">
                                <#assign cardGradient = "linear-gradient(135deg, #f97316 0%, #ea580c 100%)">
                            <#elseif card.cardNumber?ends_with("1098")>
                                <#assign cardType = "VISA">
                                <#assign cardGradient = "linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)">
                            </#if>
                            
                            <div class="col-md-6 col-lg-4">
                                <div class="credit-card-3d">
                                    <div class="credit-card-inner">
                                        <!-- Front -->
                                        <div class="credit-card-front" style="background: ${cardGradient};">
                                            <div class="d-flex justify-content-between align-items-start mb-4">
                                                <span class="text-white fw-semibold small text-uppercase">${cardType}</span>
                                                <div class="card-chip"></div>
                                            </div>
                                            <div class="mb-4 mt-auto">
                                                <div class="fs-5 font-monospace" style="letter-spacing: 0.15em;">
                                                    •••• •••• •••• ${card.cardNumber?substring(card.cardNumber?length - 4)}
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-end">
                                                <div>
                                                    <div class="text-white-50 mb-1" style="font-size: 0.65rem; text-transform: uppercase;">Cardholder</div>
                                                    <div class="small fw-semibold text-uppercase">${card.cardholderName}</div>
                                                </div>
                                                <div class="text-end">
                                                    <div class="text-white-50 mb-1" style="font-size: 0.65rem; text-transform: uppercase;">Expires</div>
                                                    <div class="small fw-semibold">${card.expiryDate?string('MM/yy')}</div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Back -->
                                        <div class="credit-card-back" style="background: ${cardGradient};">
                                            <div class="magnetic-strip"></div>
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <span class="small text-white-50">CVV</span>
                                                <span class="bg-white text-dark px-3 py-1 rounded font-monospace fw-semibold">${card.cvv}</span>
                                            </div>
                                            <div class="text-center mt-auto">
                                                <small class="text-white-50">PayFlow Bank</small>
                                                <div class="mt-2 small text-white-50">For customer service: 1-800-PAYFLOW</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="mt-3 text-center">
                                    <button class="btn btn-sm btn-outline-danger" onclick="confirmDeleteCard('${card.id}')">
                                        <i class="bi bi-trash"></i> Remove
                                    </button>
                                </div>
                            </div>
                            </#list>
                        <#else>
                            <div class="col-12">
                                <div class="text-center py-5">
                                    <i class="bi bi-credit-card fs-1 text-muted"></i>
                                    <h5 class="mt-3 text-muted">You don't have any cards yet</h5>
                                    <p class="text-muted">Add your first card to make payments</p>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCardModal">
                                        <i class="bi bi-plus-lg me-2"></i> Add Card
                                    </button>
                                </div>
                            </div>
                        </#if>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add Card Modal -->
    <div class="modal fade" id="addCardModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-semibold">Add New Card</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="/dashboard/cards/add" method="POST" class="needs-validation" novalidate>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="cardNumber" class="form-label">Card Number *</label>
                            <input type="text" class="form-control font-monospace" id="cardNumber" name="cardNumber" 
                                   placeholder="1234 5678 9012 3456" maxlength="19" required>
                            <div class="invalid-feedback">Please enter card number</div>
                        </div>
                        <div class="mb-3">
                            <label for="cardholderName" class="form-label">Cardholder Name *</label>
                            <input type="text" class="form-control text-uppercase" id="cardholderName" name="cardholderName" 
                                   placeholder="JOHN DOE" required>
                            <div class="invalid-feedback">Please enter cardholder name</div>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <div class="mb-3">
                                    <label for="expiryDate" class="form-label">Expiry Date *</label>
                                    <input type="text" class="form-control font-monospace" id="expiryDate" name="expiryDate" 
                                           placeholder="MM/YY" maxlength="5" required>
                                    <div class="invalid-feedback">MM/YY</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="mb-3">
                                    <label for="cvv" class="form-label">CVV *</label>
                                    <input type="text" class="form-control font-monospace" id="cvv" name="cvv" 
                                           placeholder="123" maxlength="3" required>
                                    <div class="invalid-feedback">3 digits</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Card</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999" id="toast-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/main.js"></script>
    <script>
        // Auto-format card number
        document.getElementById('cardNumber')?.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s/g, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
            e.target.value = formattedValue;
        });

        // Auto-format expiry date
        document.getElementById('expiryDate')?.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\//g, '');
            if (value.length >= 2) {
                e.target.value = value.slice(0, 2) + '/' + value.slice(2, 4);
            } else {
                e.target.value = value;
            }
        });
        
        // Confirm card deletion
        function confirmDeleteCard(cardId) {
            if (confirm('Are you sure you want to remove this card?')) {
                window.location.href = '/dashboard/cards/delete/' + cardId;
            }
        }
    </script>
</body>
</html>
