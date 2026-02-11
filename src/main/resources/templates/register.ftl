<#-- @ftlvariable name="error" type="java.lang.String" -->
<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - PayFlow</title>
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
                        muted: {
                            DEFAULT: 'hsl(210, 40%, 96%)',
                            foreground: 'hsl(215, 16%, 47%)',
                        },
                        success: {
                            DEFAULT: 'hsl(160, 84%, 39%)',
                            foreground: 'hsl(0, 0%, 100%)',
                        },
                        card: {
                            DEFAULT: 'hsl(0, 0%, 100%)',
                            foreground: 'hsl(222, 47%, 11%)',
                        },
                    }
                }
            }
        }
    </script>
    <style>
        body {
            font-family: 'Inter', system-ui, sans-serif;
        }
        .step-hidden { display: none; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes scaleIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        .animate-fade-in { animation: fadeIn 0.5s ease-out; }
        .animate-scale-in { animation: scaleIn 0.3s ease-out; }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center px-4 bg-gradient-to-br from-primary/5 via-background to-primary/10">
    <div class="rounded-lg border border-border bg-card text-card-foreground shadow-sm w-full max-w-md animate-scale-in">
        
        <!-- Card Header -->
        <div class="flex flex-col space-y-1.5 p-6 text-center">
            <a href="/" class="inline-flex items-center justify-center gap-2 text-primary font-bold text-xl mb-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-6 w-6">
                    <path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/>
                    <path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/>
                </svg>
                PayFlow
            </a>
            <h3 class="text-2xl font-semibold leading-none tracking-tight">Create Account</h3>
            <p class="text-sm text-muted-foreground" id="step-indicator">Step 1 of 3</p>

            <!-- Progress Bar -->
            <div class="relative h-2 w-full overflow-hidden rounded-full bg-muted mt-3">
                <div id="progress-bar" class="h-full bg-primary transition-all duration-300" style="width: 33%"></div>
            </div>
        </div>

        <form id="registerForm" action="/register" method="POST">
            <!-- Card Content -->
            <div class="p-6 pt-0 space-y-4">
                <#-- Error Message -->
                <#if error?? && error?has_content>
                    <div class="p-3 rounded-md bg-red-50 border border-red-200" role="alert">
                        <p class="text-sm text-red-600">${error}</p>
                    </div>
                </#if>

                <!-- Step 1: Personal Info -->
                <div id="step-1" class="space-y-4 animate-fade-in">
                    <div class="space-y-2">
                        <label for="firstName" class="text-sm font-medium leading-none">First Name *</label>
                        <input
                            type="text"
                            name="firstName"
                            id="firstName"
                            placeholder="John"
                            required
                            class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"
                        />
                    </div>
                    <div class="space-y-2">
                        <label for="lastName" class="text-sm font-medium leading-none">Last Name *</label>
                        <input
                            type="text"
                            name="lastName"
                            id="lastName"
                            placeholder="Doe"
                            required
                            class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"
                        />
                    </div>
                    <div class="space-y-2">
                        <label for="email" class="text-sm font-medium leading-none">Email *</label>
                        <input
                            type="email"
                            name="email"
                            id="email"
                            placeholder="john@example.com"
                            required
                            autocomplete="email"
                            class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"
                        />
                    </div>
                </div>

                <!-- Step 2: Password -->
                <div id="step-2" class="space-y-4 step-hidden animate-fade-in">
                    <div class="space-y-2">
                        <label for="reg-password" class="text-sm font-medium leading-none">Password *</label>
                        <div class="relative">
                            <input
                                type="password"
                                name="password"
                                id="reg-password"
                                placeholder="••••••••"
                                required
                                autocomplete="new-password"
                                class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm pr-10"
                            />
                            <button
                                type="button"
                                id="togglePassword"
                                aria-label="Toggle password visibility"
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 rounded p-1"
                            >
                                <svg id="eyeIcon" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                                <svg id="eyeOffIcon" class="hidden h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/>
                                    <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/>
                                    <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/>
                                    <line x1="2" x2="22" y1="2" y2="22"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                    <div class="space-y-2">
                        <label for="confirmPassword" class="text-sm font-medium leading-none">Confirm Password *</label>
                        <input
                            type="password"
                            id="confirmPassword"
                            placeholder="••••••••"
                            required
                            autocomplete="new-password"
                            class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"
                        />
                        <p id="password-error" class="text-xs text-red-600 hidden">Passwords do not match</p>
                    </div>
                </div>

                <!-- Step 3: Success -->
                <div id="step-3" class="text-center py-6 step-hidden animate-fade-in">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-success mx-auto mb-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="m9 12 2 2 4-4"/>
                    </svg>
                    <h3 class="text-xl font-semibold mb-2">All Set!</h3>
                    <p class="text-sm text-muted-foreground" id="welcome-message">
                        Click below to create your account and access the dashboard.
                    </p>
                </div>
            </div>

            <!-- Card Footer -->
            <div class="flex items-center p-6 pt-0 flex-col gap-3">
                <div class="flex gap-3 w-full">
                    <button
                        type="button"
                        id="backBtn"
                        onclick="prevStep()"
                        class="hidden flex-1 inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2"
                    >
                        Back
                    </button>

                    <button
                        type="button"
                        id="nextBtn"
                        onclick="nextStep()"
                        class="flex-1 inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2"
                    >
                        Next
                    </button>

                    <button
                        type="submit"
                        id="submitBtn"
                        class="hidden flex-1 inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2"
                    >
                        Go to Dashboard
                    </button>
                </div>

                <p class="text-sm text-muted-foreground">
                    Already have an account?
                    <a href="/login" class="text-primary hover:underline font-medium">Sign in</a>
                </p>
            </div>
        </form>
    </div>

    <script>
        let currentStep = 1;
        const totalSteps = 3;

        function updateUI() {
            // Hide all steps
            const step1 = document.getElementById('step-1');
            const step2 = document.getElementById('step-2');
            const step3 = document.getElementById('step-3');

            step1.classList.add('step-hidden');
            step2.classList.add('step-hidden');
            step3.classList.add('step-hidden');

            // Show current step
            document.getElementById('step-' + currentStep).classList.remove('step-hidden');

            // Update Progress Bar
            const progress = (currentStep / totalSteps) * 100;
            const progressBar = document.getElementById('progress-bar');
            progressBar.style.width = progress + '%';

            const stepIndicator = document.getElementById('step-indicator');
            stepIndicator.innerText = 'Step ' + currentStep + ' of ' + totalSteps;

            // Handle Buttons Visibility
            const backBtn = document.getElementById('backBtn');
            const nextBtn = document.getElementById('nextBtn');
            const submitBtn = document.getElementById('submitBtn');

            if (currentStep === 1) {
                backBtn.classList.add('hidden');
                nextBtn.classList.remove('hidden');
                submitBtn.classList.add('hidden');
                nextBtn.innerText = "Next";
            } else if (currentStep === 2) {
                backBtn.classList.remove('hidden');
                nextBtn.classList.remove('hidden');
                submitBtn.classList.add('hidden');
                nextBtn.innerText = "Create Account";
            } else if (currentStep === 3) {
                backBtn.classList.add('hidden');
                nextBtn.classList.add('hidden');
                submitBtn.classList.remove('hidden');
                
                // Update welcome message with first name
                const firstName = document.getElementById('firstName').value;
                const welcomeMsg = document.getElementById('welcome-message');
                if (firstName) {
                    welcomeMsg.innerText = 'Welcome, ' + firstName + '! Click below to access your dashboard.';
                }
            }
        }

        function validateStep(step) {
            if (step === 1) {
                const fName = document.getElementById('firstName').value;
                const lName = document.getElementById('lastName').value;
                const email = document.getElementById('email').value;
                return fName && lName && email;
            }
            if (step === 2) {
                const pass = document.getElementById('reg-password').value;
                const confirm = document.getElementById('confirmPassword').value;
                const error = document.getElementById('password-error');

                if (!pass || !confirm) return false;
                if (pass !== confirm) {
                    error.classList.remove('hidden');
                    return false;
                } else {
                    error.classList.add('hidden');
                    return true;
                }
            }
            return true;
        }

        function nextStep() {
            if (!validateStep(currentStep)) {
                alert("Please fill in all required fields correctly.");
                return;
            }

            if (currentStep < totalSteps) {
                currentStep++;
                updateUI();
            }
        }

        function prevStep() {
            if (currentStep > 1) {
                currentStep--;
                updateUI();
            }
        }

        // Toggle password visibility
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('reg-password');
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
    </script>
</body>
</html>
