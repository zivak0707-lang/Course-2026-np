<#-- @ftlvariable name="error" type="java.lang.String" -->
<#-- @ftlvariable name="success" type="java.lang.String" -->
<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - PayFlow</title>
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
                        card: {
                            DEFAULT: 'hsl(0, 0%, 100%)',
                            foreground: 'hsl(222, 47%, 11%)',
                        },
                    },
                }
            }
        }
    </script>
    <style>
        body {
            font-family: 'Inter', system-ui, sans-serif;
        }
        @keyframes scaleIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        .animate-scale-in {
            animation: scaleIn 0.3s ease-out;
        }
    </style>
</head>
<body class="bg-background text-foreground antialiased">
<div class="min-h-screen flex items-center justify-center px-4 bg-gradient-to-br from-primary/5 via-background to-primary/10">
    <div class="absolute top-20 right-10 w-72 h-72 bg-primary/10 rounded-full blur-3xl" aria-hidden="true"></div>
    <div class="absolute bottom-10 left-10 w-56 h-56 bg-success/10 rounded-full blur-3xl" aria-hidden="true"></div>

    <div class="rounded-lg border border-border bg-card text-card-foreground shadow-sm w-full max-w-md relative animate-scale-in">
        <div class="flex flex-col space-y-1.5 p-6 text-center">
            <a href="/" class="inline-flex items-center justify-center gap-2 text-primary font-bold text-xl mb-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-6 w-6">
                    <path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/>
                    <path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/>
                </svg>
                PayFlow
            </a>
            <h3 class="text-2xl font-semibold leading-none tracking-tight">Welcome Back</h3>
            <p class="text-sm text-muted-foreground">Enter your credentials to access your account</p>
        </div>

        <form action="/login" method="POST">
            <div class="p-6 pt-0 space-y-4">
                <#-- Success Message -->
                <#if success?? && success?has_content>
                    <div class="p-3 rounded-md bg-green-50 border border-green-200" role="alert">
                        <p class="text-sm text-green-600">${success}</p>
                    </div>
                </#if>

                <#-- Error Message -->
                <#if error?? && error?has_content>
                    <div class="p-3 rounded-md bg-red-50 border border-red-200" role="alert">
                        <p class="text-sm text-red-600">${error}</p>
                    </div>
                </#if>

                <div class="space-y-2">
                    <label for="email" class="text-sm font-medium leading-none">Email *</label>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="john@example.com"
                            required
                            autocomplete="email"
                            class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"
                    />
                </div>

                <div class="space-y-2">
                    <label for="password" class="text-sm font-medium leading-none">Password *</label>
                    <div class="relative">
                        <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="••••••••"
                                required
                                autocomplete="current-password"
                                class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm pr-10"
                        />
                        <button
                                type="button"
                                id="togglePassword"
                                aria-label="Toggle password visibility"
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 rounded p-1"
                        >
                            <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4">
                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                            <svg id="eyeOffIcon" class="hidden h-4 w-4" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/>
                                <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/>
                                <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/>
                                <line x1="2" x2="22" y1="2" y2="22"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <div class="relative flex items-center">
                            <input
                                    type="checkbox"
                                    id="remember"
                                    name="remember-me"
                                    class="peer h-4 w-4 cursor-pointer appearance-none rounded-full border border-primary transition-all checked:bg-primary checked:border-primary"
                            />
                            <svg
                                    class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-3 h-3 text-white pointer-events-none opacity-0 peer-checked:opacity-100 transition-opacity"
                                    xmlns="http://www.w3.org/2000/svg"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="3"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                            >
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                        </div>
                        <label for="remember" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 cursor-pointer select-none">
                            Remember me
                        </label>
                    </div>
                    <a href="#" class="text-sm font-medium text-primary hover:underline">Forgot password?</a>
                </div>
            </div>

            <div class="flex flex-col gap-3 p-6 pt-0">
                <button
                        type="submit"
                        class="w-full inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2"
                >
                    Sign In
                </button>
                <p class="text-sm text-muted-foreground text-center">
                    Don't have an account?
                    <a href="/register" class="text-primary hover:underline font-medium">Sign up</a>
                </p>
            </div>
        </form>
    </div>
</div>

<script>
    // Toggle password visibility
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');
    const eyeOffIcon = document.getElementById('eyeOffIcon');

    if (togglePassword && passwordInput && eyeIcon && eyeOffIcon) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);

            eyeIcon.classList.toggle('hidden');
            eyeOffIcon.classList.toggle('hidden');
        });
    }

    // JS для чекбокса видалено, оскільки тепер це робиться через CSS класи
</script>
</body>
</html>