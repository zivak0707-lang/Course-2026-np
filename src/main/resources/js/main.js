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
