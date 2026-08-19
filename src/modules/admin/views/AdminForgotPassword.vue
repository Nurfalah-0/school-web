<template>
  <div class="admin-forgot-page">
    <div class="admin-forgot-card">
      <h2 class="admin-forgot-title">Reset Password</h2>
      <p class="admin-forgot-desc">Masukkan email administrator untuk menerima tautan reset password.</p>

      <div v-if="message" :class="['admin-alert', messageType]">
        {{ message }}
      </div>

      <form class="admin-form" @submit.prevent="handleSubmit">
        <div class="form-group">
          <label class="form-label" for="email">Administrator Email</label>
          <div class="input-wrap">
            <Mail :size="20" color="#64748b" />
            <input
              id="email"
              v-model="email"
              type="email"
              class="form-input"
              placeholder="admin@smknuruljadid.edu"
              autocomplete="email"
            />
          </div>
          <p v-if="errors.email" class="form-error">{{ errors.email }}</p>
        </div>

        <button type="submit" class="submit-btn" :disabled="isLoading">
          <span v-if="isLoading" class="spinner"></span>
          <span>{{ isLoading ? 'Mengirim...' : 'Kirim Link Reset' }}</span>
        </button>
      </form>

      <p class="admin-forgot-footer">
        <router-link to="/login" class="admin-back-link">← Kembali ke Login</router-link>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Mail } from 'lucide-vue-next'
import { adminForgotPassword } from '@/api/endpoints'

const email = ref('')
const isLoading = ref(false)
const message = ref('')
const messageType = ref('success')
const errors = reactive({ email: '' })

function validate() {
  errors.email = ''
  if (!email.value.trim()) {
    errors.email = 'Email wajib diisi.'
    return false
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
    errors.email = 'Format email tidak valid.'
    return false
  }
  return true
}

async function handleSubmit() {
  message.value = ''
  if (!validate()) return

  isLoading.value = true
  try {
    await adminForgotPassword({ email: email.value.trim() })
    message.value = 'Link reset password telah dikirim ke email Anda.'
    messageType.value = 'success'
    email.value = ''
  } catch (err) {
    message.value = err.response?.data?.message || 'Gagal mengirim. Coba lagi nanti.'
    messageType.value = 'error'
  } finally {
    isLoading.value = false
  }
}
</script>

<style lang="scss" scoped>
.admin-forgot-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f8f7fb;
  padding: 2rem 1.25rem;
}

.admin-forgot-card {
  background: #ffffff;
  border-radius: 1.5rem;
  padding: 2.5rem;
  width: 100%;
  max-width: 28rem;
  box-shadow: 0 20px 48px rgba(15, 23, 42, 0.12);
}

.admin-forgot-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: 1.75rem;
  color: #0f172a;
  margin: 0;
}

.admin-forgot-desc {
  margin-top: 0.5rem;
  font-size: 0.9rem;
  color: #64748b;
  line-height: 1.5;
}

.admin-alert {
  margin-top: 1.25rem;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  font-size: 0.875rem;
}

.admin-alert.success {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.admin-alert.error {
  background: #fef2f2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.admin-form {
  margin-top: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.form-label {
  font-size: 0.875rem;
  font-weight: 700;
  color: #0f172a;
}

.input-wrap {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.9rem 1rem;
  border-radius: 0.875rem;
  background: #eef2ff;
  border: 1px solid transparent;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.input-wrap:focus-within {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
}

.form-input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 0.95rem;
  color: #0f172a;
  outline: none;
  min-width: 0;
}

.form-input::placeholder {
  color: #94a3b8;
}

.form-error {
  font-size: 0.8rem;
  color: #991b1b;
  margin: 0;
}

.submit-btn {
  width: 100%;
  padding: 0.95rem;
  border: none;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: background 0.2s ease;
}

.submit-btn:hover:not(:disabled) {
  background: #16264d;
}

.submit-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.spinner {
  width: 1.1rem;
  height: 1.1rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #ffffff;
  border-radius: 9999px;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.admin-forgot-footer {
  margin-top: 1.25rem;
  text-align: center;
}

.admin-back-link {
  font-size: 0.875rem;
  color: #334155;
  text-decoration: none;
}

.admin-back-link:hover {
  color: #1e3a8a;
}
</style>
