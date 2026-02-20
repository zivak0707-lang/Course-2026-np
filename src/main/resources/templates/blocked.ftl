<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Blocked — PayFlow</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', system-ui, sans-serif; }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center bg-gradient-to-br from-red-50 via-white to-red-100 px-4">

    <div class="max-w-md w-full text-center">

        <!-- Icon -->
        <div class="mx-auto mb-6 flex h-24 w-24 items-center justify-center rounded-full bg-red-100">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
            </svg>
        </div>

        <!-- Title -->
        <h1 class="text-3xl font-extrabold text-gray-900 mb-3">Account Blocked</h1>

        <!-- Message -->
        <p class="text-gray-500 text-base mb-2">
            Your account has been temporarily suspended by an administrator.
        </p>
        <p class="text-gray-400 text-sm mb-8">
            If you believe this is a mistake, please contact our support team.
        </p>

        <!-- Info box -->
        <div class="rounded-xl border border-red-200 bg-red-50 p-4 mb-8 text-left">
            <div class="flex gap-3">
                <div class="flex-shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <div>
                    <p class="text-sm font-semibold text-red-800 mb-1">What does this mean?</p>
                    <ul class="text-sm text-red-700 space-y-1 list-disc list-inside">
                        <li>All transactions are suspended</li>
                        <li>You cannot access your dashboard</li>
                        <li>Your data remains safe</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex flex-col gap-3">
            <a href="mailto:support@payflow.com"
               class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-red-600 px-6 py-3 text-sm font-semibold text-white hover:bg-red-700 transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
                Contact Support
            </a>
            <a href="/logout"
               class="w-full inline-flex items-center justify-center gap-2 rounded-xl border border-gray-200 bg-white px-6 py-3 text-sm font-semibold text-gray-600 hover:bg-gray-50 transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                </svg>
                Sign Out
            </a>
        </div>

        <!-- Footer -->
        <p class="mt-8 text-xs text-gray-400">
            © 2026 PayFlow. If you need urgent assistance, call <span class="font-medium">+380 800 123 456</span>
        </p>
    </div>

</body>
</html>
