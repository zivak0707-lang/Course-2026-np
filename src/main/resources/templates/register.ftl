<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // noinspection JSUnresolvedVariable
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: { DEFAULT: "hsl(221.2 83.2% 53.3%)", foreground: "hsl(210 40% 98%)" },
                        background: "hsl(0 0% 100%)",
                        foreground: "hsl(222.2 84% 4.9%)",
                        muted: { DEFAULT: "hsl(210 40% 96.1%)", foreground: "hsl(215.4 16.3% 46.9%)" },
                        input: "hsl(214.3 31.8% 91.4%)",
                        success: "hsl(142 76% 36%)"
                    }
                }
            }
        }
    </script>
    <style>
        .step-hidden { display: none; }
        .animate-fade-in { animation: fadeIn 0.5s ease-out forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center px-4 bg-gradient-to-br from-blue-50 via-white to-blue-100 font-sans text-slate-900">

<div class="rounded-lg border bg-white text-slate-950 shadow-sm w-full max-w-md">

    <div class="flex flex-col space-y-1.5 p-6 text-center">
        <a href="/" class="inline-flex items-center justify-center gap-2 text-primary font-bold text-xl mb-2 no-underline">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-6 w-6"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/></svg>
            PayFlow
        </a>
        <h3 class="text-2xl font-semibold leading-none tracking-tight">Create Account</h3>
        <p class="text-sm text-slate-500" id="step-indicator">Step 1 of 3</p>

        <div class="relative h-2 w-full overflow-hidden rounded-full bg-slate-100 mt-3">
            <div id="progress-bar" class="h-full w-full flex-1 bg-blue-600 transition-all duration-300" style="width: 33%"></div>
        </div>
    </div>

    <form id="registerForm" action="/register" method="POST">

        <div class="p-6 pt-0 space-y-4">

            <div id="step-1" class="space-y-4 animate-fade-in">
                <div class="space-y-2">
                    <label for="firstName" class="text-sm font-medium leading-none">First Name *</label>
                    <input type="text" name="firstName" id="firstName" placeholder="John" required
                           class="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm focus-visible:ring-2 focus-visible:ring-blue-600 outline-none">
                </div>
                <div class="space-y-2">
                    <label for="lastName" class="text-sm font-medium leading-none">Last Name *</label>
                    <input type="text" name="lastName" id="lastName" placeholder="Doe" required
                           class="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm focus-visible:ring-2 focus-visible:ring-blue-600 outline-none">
                </div>
                <div class="space-y-2">
                    <label for="email" class="text-sm font-medium leading-none">Email *</label>
                    <input type="email" name="email" id="email" placeholder="john@example.com" required
                           class="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm focus-visible:ring-2 focus-visible:ring-blue-600 outline-none">
                </div>
            </div>

            <div id="step-2" class="space-y-4 step-hidden animate-fade-in">
                <div class="space-y-2">
                    <label for="reg-password" class="text-sm font-medium leading-none">Password *</label>
                    <div class="relative">
                        <input type="password" name="password" id="reg-password" placeholder="••••••••" required
                               class="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm focus-visible:ring-2 focus-visible:ring-blue-600 outline-none">
                        <button type="button" onclick="toggleRegPassword()"
                                aria-label="Toggle password visibility"
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-600 focus:ring-offset-2 rounded">
                            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                </div>
                <div class="space-y-2">
                    <label for="confirmPassword" class="text-sm font-medium leading-none">Confirm Password *</label>
                    <input type="password" id="confirmPassword" placeholder="••••••••" required
                           class="flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm focus-visible:ring-2 focus-visible:ring-blue-600 outline-none">
                    <p id="password-error" class="text-xs text-red-500 hidden">Passwords do not match</p>
                </div>
            </div>

            <div id="step-3" class="text-center py-6 step-hidden animate-fade-in">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-green-600 mx-auto mb-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="m9 12 2 2 4-4"/>
                </svg>
                <h3 class="text-xl font-semibold mb-2">All Set!</h3>
                <p class="text-sm text-slate-500">
                    Click below to create your account and access the dashboard.
                </p>
            </div>

        </div>

        <div class="flex items-center p-6 pt-0 flex-col gap-3">
            <div class="flex gap-3 w-full">
                <button type="button" id="backBtn" onclick="prevStep()" class="hidden flex-1 inline-flex items-center justify-center rounded-md text-sm font-medium border border-slate-200 bg-white hover:bg-slate-100 h-10 px-4 py-2">
                    Back
                </button>

                <button type="button" id="nextBtn" onclick="nextStep()" class="flex-1 inline-flex items-center justify-center rounded-md text-sm font-medium bg-blue-600 text-white hover:bg-blue-600/90 h-10 px-4 py-2">
                    Next
                </button>

                <button type="submit" id="submitBtn" class="hidden flex-1 inline-flex items-center justify-center rounded-md text-sm font-medium bg-blue-600 text-white hover:bg-blue-600/90 h-10 px-4 py-2">
                    Go to Dashboard
                </button>
            </div>

            <p class="text-sm text-slate-500">
                Already have an account?
                <a href="/login" class="text-blue-600 hover:underline">Sign in</a>
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

    function toggleRegPassword() {
        const input = document.getElementById('reg-password');
        input.type = input.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>