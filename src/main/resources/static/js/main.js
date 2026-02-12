// PayFlow - Main JavaScript

// Toggle sidebar on mobile
function toggleSidebar() {
  const sidebar = document.querySelector('.sidebar');
  sidebar?.classList.toggle('show');
}

// Toggle password visibility
function togglePasswordVisibility(inputId) {
  const input = document.getElementById(inputId);
  const icon = event.target.closest('button').querySelector('i');

  if (input.type === 'password') {
    input.type = 'text';
    icon.classList.remove('bi-eye');
    icon.classList.add('bi-eye-slash');
  } else {
    input.type = 'password';
    icon.classList.remove('bi-eye-slash');
    icon.classList.add('bi-eye');
  }
}

// Show toast notification
function showToast(message, type = 'success') {
  const toastContainer = document.getElementById('toast-container');
  if (!toastContainer) return;

  const toast = document.createElement('div');
  toast.className = `toast align-items-center text-white bg-${type} border-0`;
  toast.setAttribute('role', 'alert');
  toast.setAttribute('aria-live', 'assertive');
  toast.setAttribute('aria-atomic', 'true');

  toast.innerHTML = `
    <div class="d-flex">
      <div class="toast-body">${message}</div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
  `;

  toastContainer.appendChild(toast);
  const bsToast = new bootstrap.Toast(toast);
  bsToast.show();

  toast.addEventListener('hidden.bs.toast', () => {
    toast.remove();
  });
}

// Format currency
function formatCurrency(amount) {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(amount);
}

// Format date
function formatDate(dateString) {
  const options = { year: 'numeric', month: 'short', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('en-US', options);
}

// Mask card number
function maskCardNumber(number) {
  return `**** **** **** ${number.slice(-4)}`;
}

// Mask account number
function maskAccountNumber(number) {
  return `****${number.slice(-4)}`;
}

// Credit card flip animation
document.addEventListener('DOMContentLoaded', () => {
  const creditCards = document.querySelectorAll('.credit-card');

  creditCards.forEach(card => {
    card.addEventListener('click', () => {
      card.classList.toggle('flipped');
    });
  });
});

// Form validation
function validateForm(formId) {
  const form = document.getElementById(formId);
  if (!form) return false;

  form.classList.add('was-validated');
  return form.checkValidity();
}

// Confirm delete action
function confirmDelete(message = 'Are you sure you want to delete this?') {
  return confirm(message);
}

// Filter table
function filterTable(searchInput, tableId) {
  const filter = searchInput.value.toUpperCase();
  const table = document.getElementById(tableId);
  const rows = table.getElementsByTagName('tr');

  for (let i = 1; i < rows.length; i++) {
    const row = rows[i];
    const cells = row.getElementsByTagName('td');
    let found = false;

    for (let j = 0; j < cells.length; j++) {
      const cell = cells[j];
      if (cell) {
        const textValue = cell.textContent || cell.innerText;
        if (textValue.toUpperCase().indexOf(filter) > -1) {
          found = true;
          break;
        }
      }
    }

    row.style.display = found ? '' : 'none';
  }
}

// Sort table
function sortTable(tableId, columnIndex) {
  const table = document.getElementById(tableId);
  const rows = Array.from(table.querySelectorAll('tbody tr'));
  const isAscending = table.getAttribute('data-sort-order') === 'asc';

  rows.sort((a, b) => {
    const aValue = a.cells[columnIndex].textContent.trim();
    const bValue = b.cells[columnIndex].textContent.trim();

    return isAscending
        ? aValue.localeCompare(bValue)
        : bValue.localeCompare(aValue);
  });

  const tbody = table.querySelector('tbody');
  tbody.innerHTML = '';
  rows.forEach(row => tbody.appendChild(row));

  table.setAttribute('data-sort-order', isAscending ? 'desc' : 'asc');
}

// Copy to clipboard
async function copyToClipboard(text) {
  try {
    await navigator.clipboard.writeText(text);
    showToast('Copied to clipboard!', 'success');
  } catch (err) {
    showToast('Failed to copy', 'danger');
  }
}

// Initialize Bootstrap tooltips
document.addEventListener('DOMContentLoaded', () => {
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  tooltipTriggerList.map(el => new bootstrap.Tooltip(el));
});

// Initialize Bootstrap popovers
document.addEventListener('DOMContentLoaded', () => {
  const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
  popoverTriggerList.map(el => new bootstrap.Popover(el));
});

// Auto-hide alerts
document.addEventListener('DOMContentLoaded', () => {
  const alerts = document.querySelectorAll('.alert-dismissible');
  alerts.forEach(alert => {
    setTimeout(() => {
      const bsAlert = new bootstrap.Alert(alert);
      bsAlert.close();
    }, 5000);
  });
});

// Handle account/card deletion
function deleteItem(type, id) {
  if (confirmDelete(`Are you sure you want to delete this ${type}?`)) {
    // In real implementation, this would make an AJAX call to the server
    fetch(`/api/${type}/${id}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
      },
    })
        .then(response => {
          if (response.ok) {
            showToast(`${type.charAt(0).toUpperCase() + type.slice(1)} deleted successfully!`, 'success');
            // Reload page or remove element
            location.reload();
          } else {
            showToast(`Failed to delete ${type}`, 'danger');
          }
        })
        .catch(error => {
          console.error('Error:', error);
          showToast('An error occurred', 'danger');
        });
  }
}

// Handle payment submission
function submitPayment(formId) {
  if (!validateForm(formId)) {
    return false;
  }

  const form = document.getElementById(formId);
  const formData = new FormData(form);

  fetch('/api/payments', {
    method: 'POST',
    body: JSON.stringify(Object.fromEntries(formData)),
    headers: {
      'Content-Type': 'application/json',
    },
  })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          showToast('Payment submitted successfully!', 'success');
          setTimeout(() => {
            window.location.href = '/dashboard';
          }, 1500);
        } else {
          showToast('Payment failed: ' + data.message, 'danger');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showToast('An error occurred', 'danger');
      });

  return false;
}

// Toggle account status (admin)
function toggleAccountStatus(accountId, currentStatus) {
  const newStatus = currentStatus === 'ACTIVE' ? 'BLOCKED' : 'ACTIVE';

  fetch(`/admin/accounts/${accountId}/status`, {
    method: 'PATCH',
    body: JSON.stringify({ status: newStatus }),
    headers: {
      'Content-Type': 'application/json',
    },
  })
      .then(response => {
        if (response.ok) {
          showToast(`Account ${newStatus.toLowerCase()} successfully!`, 'success');
          location.reload();
        } else {
          showToast('Failed to update account status', 'danger');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showToast('An error occurred', 'danger');
      });
}

// Export table to CSV
function exportTableToCSV(tableId, filename = 'data.csv') {
  const table = document.getElementById(tableId);
  const rows = Array.from(table.querySelectorAll('tr'));

  const csv = rows.map(row => {
    const cells = Array.from(row.querySelectorAll('th, td'));
    return cells.map(cell => `"${cell.textContent.trim()}"`).join(',');
  }).join('\n');

  const blob = new Blob([csv], { type: 'text/csv' });
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
  window.URL.revokeObjectURL(url);

  showToast('Table exported to CSV!', 'success');
}

// Real-time search
let searchTimeout;
function searchTable(input, tableId) {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(() => {
    filterTable(input, tableId);
  }, 300);
}

// Chart initialization (for admin dashboard)
function initializeCharts() {
  // Transaction Volume Chart
  const ctx1 = document.getElementById('transactionVolumeChart');
  if (ctx1) {
    new Chart(ctx1, {
      type: 'line',
      data: {
        labels: ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
        datasets: [{
          label: 'Transaction Volume',
          data: [42000, 53000, 48000, 61000, 55000, 67000],
          borderColor: '#2563eb',
          backgroundColor: 'rgba(37, 99, 235, 0.1)',
          tension: 0.4,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    });
  }

  // User Growth Chart
  const ctx2 = document.getElementById('userGrowthChart');
  if (ctx2) {
    new Chart(ctx2, {
      type: 'bar',
      data: {
        labels: ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
        datasets: [{
          label: 'Users',
          data: [820, 910, 980, 1050, 1150, 1248],
          backgroundColor: '#10b981'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    });
  }

  // Status Distribution Chart
  const ctx3 = document.getElementById('statusDistributionChart');
  if (ctx3) {
    new Chart(ctx3, {
      type: 'pie',
      data: {
        labels: ['Completed', 'Pending', 'Failed'],
        datasets: [{
          data: [68, 22, 10],
          backgroundColor: ['#10b981', '#2563eb', '#ef4444']
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    });
  }
}

// Initialize charts on page load
document.addEventListener('DOMContentLoaded', () => {
  initializeCharts();
});

// 🆕 Account Details Modal Functions
async function showAccountDetails(accountId) {
  const modal = document.getElementById('accountDetailsModal');
  if (!modal) return;

  modal.classList.remove('hidden');
  modal.classList.add('flex');

  // Show loading spinner
  const activityContainer = document.getElementById('modal-activity');
  if (activityContainer) {
    activityContainer.innerHTML = `
      <div class="flex justify-center py-8">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    `;
  }

  try {
    // Fetch account details
    const response = await fetch(`/api/accounts/${accountId}/details`);

    if (!response.ok) {
      throw new Error('Failed to fetch account details');
    }

    const data = await response.json();

    // Update modal content
    const accountNumberEl = document.getElementById('modal-account-number');
    const balanceEl = document.getElementById('modal-balance');
    const statusEl = document.getElementById('modal-status');

    if (accountNumberEl) accountNumberEl.textContent = data.accountNumber;
    if (balanceEl) balanceEl.textContent = `$${parseFloat(data.balance).toFixed(2)}`;

    if (statusEl) {
      statusEl.textContent = data.status;
      statusEl.className = data.status === 'ACTIVE'
          ? 'inline-flex items-center rounded-full bg-blue-600 px-2.5 py-0.5 text-xs font-semibold text-white'
          : 'inline-flex items-center rounded-full bg-red-600 px-2.5 py-0.5 text-xs font-semibold text-white';
    }

    // Render recent activity
    if (activityContainer) {
      const activityHtml = data.recentActivity && data.recentActivity.length > 0
          ? data.recentActivity.map(payment => {
            const isIncoming = payment.paymentType === 'DEPOSIT';
            const iconName = isIncoming ? 'arrow-down-left' : 'arrow-up-right';
            const iconColor = isIncoming ? 'text-green-600' : 'text-red-600';
            const iconBg = isIncoming ? 'bg-green-50' : 'bg-red-50';
            const amountColor = isIncoming ? 'text-green-600' : 'text-red-600';
            const amountSign = isIncoming ? '+' : '';

            return `
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-lg ${iconBg} flex items-center justify-center ${iconColor}">
                    <i data-lucide="${iconName}" class="h-4 w-4"></i>
                  </div>
                  <div>
                    <p class="text-sm font-medium text-gray-900">${payment.description || payment.paymentType}</p>
                    <p class="text-xs text-gray-500">${formatDate(payment.createdAt)}</p>
                  </div>
                </div>
                <p class="text-sm font-semibold ${amountColor}">${amountSign}$${parseFloat(payment.amount).toFixed(2)}</p>
              </div>
            `;
          }).join('')
          : '<p class="text-sm text-gray-500 text-center py-4">No recent transactions</p>';

      activityContainer.innerHTML = activityHtml;

      // Reinitialize Lucide icons if available
      if (typeof lucide !== 'undefined') {
        lucide.createIcons();
      }
    }
  } catch (error) {
    console.error('Error fetching account details:', error);
    if (activityContainer) {
      activityContainer.innerHTML = '<p class="text-sm text-red-500 text-center py-4">Error loading transactions</p>';
    }
  }
}

function closeAccountDetailsModal() {
  const modal = document.getElementById('accountDetailsModal');
  if (modal) {
    modal.classList.add('hidden');
    modal.classList.remove('flex');
  }
}