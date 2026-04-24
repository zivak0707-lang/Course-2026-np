/* ============================================================
   PayFlow — My Cards Modal Interactions
   cards-modal.js
   ============================================================ */

'use strict';

// ── Shared state ─────────────────────────────────────────────
let _activeCardId  = null;
let _cardIsActive  = null;


/* ════════════════════════════════════════════════════════════
   GENERIC MODAL HELPERS
   ════════════════════════════════════════════════════════════ */

function openModal(id) {
  const el = document.getElementById(id);
  if (!el) return;
  el.classList.add('is-open');
  el.setAttribute('aria-hidden', 'false');
  document.body.style.overflow = 'hidden';
}

function closeModal(id) {
  const el = document.getElementById(id);
  if (!el) return;
  el.classList.remove('is-open');
  el.setAttribute('aria-hidden', 'true');
  document.body.style.overflow = '';
  // Clear all error messages inside this modal
  el.querySelectorAll('.pf-error-msg').forEach(e => {
    e.style.display = 'none';
    e.textContent   = '';
  });
}

// Close modal when clicking the dark backdrop
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.pf-modal-backdrop').forEach(backdrop => {
    backdrop.addEventListener('click', e => {
      if (e.target === backdrop) closeModal(backdrop.id);
    });
  });
});

// Close topmost open modal on ESC
document.addEventListener('keydown', e => {
  if (e.key !== 'Escape') return;
  const open = document.querySelector('.pf-modal-backdrop.is-open');
  if (open) closeModal(open.id);
});


/* ════════════════════════════════════════════════════════════
   MODAL 1 — BLOCK / UNBLOCK CARD
   ════════════════════════════════════════════════════════════ */

/**
 * Opens the block/unblock confirmation modal.
 *
 * @param {number}  cardId   - the card's database ID
 * @param {boolean} isActive - current state (true = card is active/unblocked)
 */
function openToggleBlockModal(cardId, isActive) {
  _activeCardId = cardId;
  _cardIsActive = isActive;

  const title  = document.getElementById('modal-block-title');
  const desc   = document.getElementById('modal-block-desc');
  const icon   = document.getElementById('modal-block-icon');
  const btn    = document.getElementById('btn-confirm-block');

  if (isActive) {
    // Currently active → offer to BLOCK
    title.textContent  = 'Block Card';
    desc.textContent   = 'Are you sure? All transactions on this card will be declined until you unblock it.';
    icon.className     = 'pf-modal-icon pf-modal-icon--warning';
    icon.innerHTML     = '<i class="bi bi-slash-circle"></i>';
    btn.textContent    = 'Block Card';
    btn.className      = 'pf-btn pf-btn--warning';
  } else {
    // Currently blocked → offer to UNBLOCK
    title.textContent  = 'Unblock Card';
    desc.textContent   = 'This will restore full functionality to your card. Do you want to continue?';
    icon.className     = 'pf-modal-icon pf-modal-icon--success';
    icon.innerHTML     = '<i class="bi bi-check-circle"></i>';
    btn.textContent    = 'Unblock Card';
    btn.className      = 'pf-btn pf-btn--success';
  }

  openModal('modal-block');
}

async function confirmToggleBlock() {
  const btn = document.getElementById('btn-confirm-block');
  btn.disabled    = true;
  const origText  = btn.textContent;
  btn.textContent = 'Processing…';

  try {
    const res  = await fetch(`/cards/${_activeCardId}/toggle-block`, { method: 'POST' });
    const data = await res.json();

    if (data.success) {
      showToast(data.message, 'success');
      closeModal('modal-block');
      _updateCardTileState(_activeCardId, data.isActive);
    } else {
      showToast(data.message || 'Operation failed', 'danger');
    }
  } catch {
    showToast('Network error — please try again.', 'danger');
  } finally {
    btn.disabled    = false;
    btn.textContent = origText;
  }
}

/**
 * Updates the card tile DOM to reflect the new block/unblock state
 * without a full page reload.
 */
function _updateCardTileState(cardId, isActive) {
  const tile = document.getElementById(`card-tile-${cardId}`);
  if (!tile) return;

  const card = tile.querySelector('.pf-credit-card');

  if (isActive) {
    // Unblocked
    card.classList.remove('pf-credit-card--blocked');
    tile.querySelector('.pf-blocked-overlay')?.remove();
  } else {
    // Blocked
    card.classList.add('pf-credit-card--blocked');
    if (!card.querySelector('.pf-blocked-overlay')) {
      card.insertAdjacentHTML('beforeend', `
                <div class="pf-blocked-overlay">
                    <i class="bi bi-slash-circle"></i>
                    <span>BLOCKED</span>
                </div>`);
    }
  }

  // Refresh the dropdown label for this card
  const toggleBtn = tile.querySelector('[onclick*="openToggleBlockModal"]');
  if (toggleBtn) {
    if (isActive) {
      toggleBtn.innerHTML = `
                <i class="bi bi-slash-circle" style="color:#f59e0b;"></i>
                <span>Block Card</span>`;
    } else {
      toggleBtn.innerHTML = `
                <i class="bi bi-check-circle" style="color:#10b981;"></i>
                <span>Unblock Card</span>`;
    }
    toggleBtn.setAttribute('onclick',
        `openToggleBlockModal(${cardId}, ${isActive})`);
  }
}


/* ════════════════════════════════════════════════════════════
   MODAL 2 — CHANGE PIN
   ════════════════════════════════════════════════════════════ */

function openPinModal(cardId, hasPin) {
  _activeCardId = cardId;

  const p0wrap = document.getElementById('pin-current-wrap');
  const p0     = document.getElementById('pin-current');
  const p1     = document.getElementById('pin-new');
  const p2     = document.getElementById('pin-confirm');

  if (p0) p0.value = '';
  if (p1) p1.value = '';
  if (p2) p2.value = '';

  // Show current PIN field only if card already has a PIN
  if (p0wrap) p0wrap.style.display = String(hasPin) === 'true' ? 'block' : 'none';

  // Reset eye-toggle icons
  [p1, p2].filter(Boolean).forEach(input => {
    input.type = 'password';
    const eye  = input.parentElement?.querySelector('.pf-eye-btn i');
    if (eye) eye.className = 'bi bi-eye';
  });

  openModal('modal-pin');
  setTimeout(() => {
    if (String(hasPin) === 'true' && p0) p0.focus();
    else if (p1) p1.focus();
  }, 120);
}

/** Toggle PIN field between text and password. */
function togglePinVisibility(inputId, btn) {
  const input = document.getElementById(inputId);
  const icon  = btn.querySelector('i');
  if (input.type === 'password') {
    input.type    = 'text';
    icon.className = 'bi bi-eye-slash';
  } else {
    input.type    = 'password';
    icon.className = 'bi bi-eye';
  }
}

// Restrict PIN inputs to digits only
document.addEventListener('DOMContentLoaded', () => {
  ['pin-current', 'pin-new', 'pin-confirm'].forEach(id => {
    const el = document.getElementById(id);
    if (!el) return;
    el.addEventListener('input', () => {
      el.value = el.value.replace(/\D/g, '').slice(0, 4);
    });
  });
});

async function submitChangePin() {
  const p0wrap     = document.getElementById('pin-current-wrap');
  const currentPin = document.getElementById('pin-current')?.value.trim() ?? '';
  const newPin     = document.getElementById('pin-new').value.trim();
  const confirmPin = document.getElementById('pin-confirm').value.trim();
  const errEl      = document.getElementById('pin-error');
  const btnText    = document.getElementById('pin-btn-text');
  const spinner    = document.getElementById('pin-btn-spinner');

  errEl.style.display = 'none';

  const currentPinRequired = p0wrap && p0wrap.style.display !== 'none';

  // Client-side validation
  if (currentPinRequired && !/^\d{4}$/.test(currentPin)) {
    _showError('pin-error', 'Current PIN must be exactly 4 digits.');
    return;
  }
  if (!/^\d{4}$/.test(newPin)) {
    _showError('pin-error', 'New PIN must be exactly 4 digits.');
    return;
  }
  if (newPin !== confirmPin) {
    _showError('pin-error', 'PINs do not match. Please try again.');
    return;
  }

  _setLoading(btnText, spinner, true);

  try {
    const body = { newPin, confirmPin };
    if (currentPinRequired && currentPin) body.currentPin = currentPin;
    const res  = await fetch(`/cards/${_activeCardId}/change-pin`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    const data = await res.json();

    if (data.success) {
      showToast('PIN updated successfully!', 'success');
      closeModal('modal-pin');
    } else {
      _showError('pin-error', data.message || 'Failed to update PIN.');
    }
  } catch {
    _showError('pin-error', 'Network error — please try again.');
  } finally {
    _setLoading(btnText, spinner, false);
  }
}


/* ════════════════════════════════════════════════════════════
   MODAL 3 — SPENDING LIMIT
   ════════════════════════════════════════════════════════════ */

/**
 * @param {number}        cardId        - card database ID
 * @param {string|number} currentLimit  - existing limit value (0 or null-ish = no limit)
 */
function openLimitModal(cardId, currentLimit) {
  _activeCardId = cardId;

  const input = document.getElementById('limit-amount');
  const parsed = parseFloat(currentLimit);
  input.value = (!isNaN(parsed) && parsed > 0) ? parsed.toFixed(2) : '';

  openModal('modal-limit');
  setTimeout(() => input.focus(), 120);
}

async function submitSpendingLimit() {
  const raw     = document.getElementById('limit-amount').value.trim();
  const btnText = document.getElementById('limit-btn-text');
  const spinner = document.getElementById('limit-btn-spinner');

  document.getElementById('limit-error').style.display = 'none';

  const limit = raw === '' ? 0 : parseFloat(raw);
  if (isNaN(limit) || limit < 0) {
    _showError('limit-error', 'Please enter a valid positive amount.');
    return;
  }

  _setLoading(btnText, spinner, true);

  try {
    const res  = await fetch(`/cards/${_activeCardId}/spending-limit`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ limit: limit === 0 ? null : limit })
    });
    const data = await res.json();

    if (data.success) {
      const msg = limit === 0
          ? 'Spending limit removed.'
          : `Daily limit set to $${limit.toFixed(2)}`;
      showToast(msg, 'success');
      closeModal('modal-limit');
    } else {
      _showError('limit-error', data.message || 'Failed to update limit.');
    }
  } catch {
    _showError('limit-error', 'Network error — please try again.');
  } finally {
    _setLoading(btnText, spinner, false);
  }
}


/* ════════════════════════════════════════════════════════════
   PRIVATE UTILITIES
   ════════════════════════════════════════════════════════════ */

function _showError(errorElId, message) {
  const el = document.getElementById(errorElId);
  if (!el) return;
  el.textContent   = message;
  el.style.display = 'block';
}

function _setLoading(textEl, spinnerEl, loading) {
  if (textEl)    textEl.style.display   = loading ? 'none'         : 'inline';
  if (spinnerEl) spinnerEl.style.display = loading ? 'inline-block' : 'none';
}