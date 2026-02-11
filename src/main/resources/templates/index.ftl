<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PayFlow - Manage Your Payments Seamlessly</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script>
        // noinspection JSUnresolvedVariable
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                    },
                    colors: {
                        border: 'hsl(214, 32%, 91%)',
                        input: 'hsl(214, 32%, 91%)',
                        ring: 'hsl(217, 91%, 60%)',
                        background: 'hsl(0, 0%, 100%)',
                        foreground: 'hsl(222, 47%, 11%)',
                        primary: {
                            DEFAULT: 'hsl(217, 91%, 60%)',
                            foreground: 'hsl(0, 0%, 100%)',
                        },
                        secondary: {
                            DEFAULT: 'hsl(215, 16%, 47%)',
                            foreground: 'hsl(0, 0%, 100%)',
                        },
                        muted: {
                            DEFAULT: 'hsl(210, 40%, 96%)',
                            foreground: 'hsl(215, 16%, 47%)',
                        },
                        accent: {
                            DEFAULT: 'hsl(210, 40%, 96%)',
                            foreground: 'hsl(222, 47%, 11%)',
                        },
                        success: {
                            DEFAULT: 'hsl(160, 84%, 39%)',
                            foreground: 'hsl(0, 0%, 100%)',
                        },
                    },
                    borderRadius: {
                        lg: `var(--radius)`,
                        md: `calc(var(--radius) - 2px)`,
                        sm: `calc(var(--radius) - 4px)`,
                    },
                }
            }
        }
    </script>
    <style>
        :root {
            --radius: 0.5rem;
        }
        body {
            font-family: 'Inter', system-ui, sans-serif;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        .animate-slide-up {
            animation: slideUp 0.5s ease-out;
        }
    </style>
</head>
<body class="bg-background text-foreground antialiased">
<nav class="fixed top-0 left-0 right-0 z-50 bg-background/80 backdrop-blur-md border-b border-border">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            <a href="/" class="flex items-center gap-2 text-primary font-bold text-xl">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-6 w-6">
                    <path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/>
                    <path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/>
                </svg>
                <span>PayFlow</span>
            </a>

            <div class="hidden md:flex items-center gap-6">
                <a href="/" class="text-sm font-medium text-muted-foreground hover:text-foreground transition-colors">Home</a>
                <a href="#features" class="text-sm font-medium text-muted-foreground hover:text-foreground transition-colors">Features</a>
                <a href="#" class="text-sm font-medium text-muted-foreground hover:text-foreground transition-colors">About</a>
                <a href="/login">
                    <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-full text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9 px-4">
                        Sign In
                    </button>
                </a>
                <a href="/register">
                    <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-full text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-9 px-4">
                        Get Started
                    </button>
                </a>
            </div>

            <button class="md:hidden" id="mobile-menu-button" aria-label="Toggle mobile menu" aria-expanded="false">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-6 w-6" id="menu-icon">
                    <line x1="4" x2="20" y1="12" y2="12"/>
                    <line x1="4" x2="20" y1="6" y2="6"/>
                    <line x1="4" x2="20" y1="18" y2="18"/>
                </svg>
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-6 w-6 hidden" id="close-icon">
                    <path d="M18 6 6 18"/>
                    <path d="m6 6 12 12"/>
                </svg>
            </button>
        </div>
    </div>

    <div class="md:hidden bg-background border-b border-border hidden animate-fade-in" id="mobile-menu">
        <div class="px-4 py-4 flex flex-col gap-3">
            <a href="/" class="text-sm font-medium py-2">Home</a>
            <a href="#features" class="text-sm font-medium py-2">Features</a>
            <a href="/login">
                <button class="w-full inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-full text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                    Sign In
                </button>
            </a>
            <a href="/register">
                <button class="w-full inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-full text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">
                    Get Started
                </button>
            </a>
        </div>
    </div>
</nav>

<main>
    <section class="relative pt-32 pb-20 px-4 overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-br from-primary/10 via-background to-primary/5" aria-hidden="true"></div>
        <div class="absolute top-20 right-0 w-96 h-96 bg-primary/10 rounded-full blur-3xl" aria-hidden="true"></div>
        <div class="absolute bottom-0 left-0 w-72 h-72 bg-success/10 rounded-full blur-3xl" aria-hidden="true"></div>

        <div class="relative max-w-4xl mx-auto text-center animate-fade-in">
            <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight mb-6">
                Manage Your Payments
                <span class="text-primary">Seamlessly</span>
            </h1>
            <p class="text-lg sm:text-xl text-muted-foreground max-w-2xl mx-auto mb-10">
                A modern platform for secure transactions, real-time monitoring, and effortless card management — all in one place.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="/register">
                    <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-full text-base font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-11 px-8">
                        Get Started
                    </button>
                </a>
                <a href="/login">
                    <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-full text-base font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-11 px-8">
                        Sign In
                    </button>
                </a>
            </div>
        </div>
    </section>

    <section id="features" class="py-20 px-4 bg-muted/30">
        <div class="max-w-6xl mx-auto">
            <h2 class="text-3xl font-bold text-center mb-12">Why Choose PayFlow?</h2>
            <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="rounded-xl border border-border bg-background p-6 text-center hover:shadow-lg transition-shadow animate-slide-up">
                    <div class="inline-flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-primary mb-4" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-8 w-8">
                            <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
                        </svg>
                    </div>
                    <h3 class="font-semibold text-lg mb-2">Secure Transactions</h3>
                    <p class="text-sm text-muted-foreground">Bank-grade encryption protects every transaction you make.</p>
                </div>

                <div class="rounded-xl border border-border bg-background p-6 text-center hover:shadow-lg transition-shadow animate-slide-up" style="animation-delay: 0.1s;">
                    <div class="inline-flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-primary mb-4" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-8 w-8">
                            <path d="M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2"/>
                        </svg>
                    </div>
                    <h3 class="font-semibold text-lg mb-2">Real-time Monitoring</h3>
                    <p class="text-sm text-muted-foreground">Track your spending and income with live dashboards.</p>
                </div>

                <div class="rounded-xl border border-border bg-background p-6 text-center hover:shadow-lg transition-shadow animate-slide-up" style="animation-delay: 0.2s;">
                    <div class="inline-flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-primary mb-4" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-8 w-8">
                            <rect width="20" height="14" x="2" y="5" rx="2"/>
                            <line x1="2" x2="22" y1="10" y2="10"/>
                        </svg>
                    </div>
                    <h3 class="font-semibold text-lg mb-2">Multi-card Management</h3>
                    <p class="text-sm text-muted-foreground">Manage all your cards in one place with ease.</p>
                </div>

                <div class="rounded-xl border border-border bg-background p-6 text-center hover:shadow-lg transition-shadow animate-slide-up" style="animation-delay: 0.3s;">
                    <div class="inline-flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-primary mb-4" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-8 w-8">
                            <path d="M3 11h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-5Zm0 0a9 9 0 1 1 18 0m0 0v5a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3Z"/>
                        </svg>
                    </div>
                    <h3 class="font-semibold text-lg mb-2">24/7 Support</h3>
                    <p class="text-sm text-muted-foreground">Our team is always available to assist you.</p>
                </div>
            </div>
        </div>
    </section>
</main>

<footer class="py-8 px-4 border-t border-border text-center text-sm text-muted-foreground">
    © 2026 PayFlow. All rights reserved.
</footer>

<script>
    // Mobile menu toggle
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');
    const menuIcon = document.getElementById('menu-icon');
    const closeIcon = document.getElementById('close-icon');

    if (mobileMenuButton && mobileMenu && menuIcon && closeIcon) {
        mobileMenuButton.addEventListener('click', function() {
            const isHidden = mobileMenu.classList.toggle('hidden');
            mobileMenuButton.setAttribute('aria-expanded', isHidden ? 'false' : 'true');
            menuIcon.classList.toggle('hidden');
            closeIcon.classList.toggle('hidden');
        });

        // Close mobile menu when clicking on links
        const mobileLinks = mobileMenu.querySelectorAll('a');
        mobileLinks.forEach(link => {
            link.addEventListener('click', function() {
                mobileMenu.classList.add('hidden');
                mobileMenuButton.setAttribute('aria-expanded', 'false');
                menuIcon.classList.remove('hidden');
                closeIcon.classList.add('hidden');
            });
        });
    }
</script>
</body>
</html>