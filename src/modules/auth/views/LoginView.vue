<template>
  <div class="login-wrapper">
    <div class="login-card">
      <div class="login-header">
        <router-link to="/" class="back-link">← Kembali ke Beranda</router-link>
        <h2>Portal Login Admin</h2>
        <p>Masuk untuk mengelola data pendaftaran PKL &amp; kemitraan BKK SMK.</p>
      </div>

      <div v-if="errorMessage" class="login-alert">
        <span>⚠️</span> {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="username">Username / Email</label>
          <input
            id="username"
            v-model="username"
            type="text"
            placeholder="Masukkan username (mis: admin)"
            required
          />
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <div class="password-input">
            <input
              id="password"
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Masukkan password"
              required
            />
            <button
              type="button"
              class="toggle-pwd"
              @click="showPassword = !showPassword"
            >
              {{ showPassword ? '🙈' : '👁️' }}
            </button>
          </div>
        </div>

        <div class="demo-info">
          <p><strong>Info Akses Demo:</strong> Username: <code>admin</code> | Password: <code>admin123</code></p>
        </div>

        <button type="submit" class="button-primary login-btn" :disabled="isLoading">
          {{ isLoading ? 'Memproses...' : 'Masuk ke Dashboard' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { loginUser } from '../../../api/endpoints';

const router = useRouter();

const username = ref('admin');
const password = ref('admin123');
const showPassword = ref(false);
const isLoading = ref(false);
const errorMessage = ref('');

const handleLogin = async () => {
  isLoading.value = true;
  errorMessage.value = '';

  try {
    const res = await loginUser({ username: username.value, password: password.value });
    if (res.data && res.data.token) {
      localStorage.setItem('auth_token', res.data.token);
      localStorage.setItem('user_info', JSON.stringify(res.data.user || { name: username.value }));
      router.push('/admin/dashboard');
    }
  } catch (error) {
    console.error('Login gagal:', error);
    errorMessage.value = error.response?.data?.message || 'Gagal masuk. Periksa username dan password Anda.';
  } finally {
    isLoading.value = false;
  }
};
</script>

<style scoped>
.login-wrapper {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  padding: 1.5rem;
  font-family: inherit;
}

.login-card {
  background: #ffffff;
  width: 100%;
  max-width: 440px;
  border-radius: 16px;
  padding: 2.5rem;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2), 0 10px 10px -5px rgba(0, 0, 0, 0.1);
}

.back-link {
  display: inline-block;
  font-size: 0.875rem;
  color: #64748b;
  text-decoration: none;
  margin-bottom: 1rem;
  font-weight: 500;
  transition: color 0.2s;
}

.back-link:hover {
  color: #2563eb;
}

.login-header h2 {
  font-size: 1.625rem;
  color: #0f172a;
  margin: 0 0 0.5rem 0;
  font-weight: 700;
}

.login-header p {
  color: #64748b;
  font-size: 0.9rem;
  margin-bottom: 1.75rem;
  line-height: 1.4;
}

.login-alert {
  background: #fef2f2;
  border: 1px solid #fecaca;
  color: #991b1b;
  padding: 0.75rem 1rem;
  border-radius: 8px;
  font-size: 0.875rem;
  margin-bottom: 1.25rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.form-group label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #334155;
}

.form-group input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  font-size: 0.95rem;
  transition: border-color 0.2s, box-shadow 0.2s;
  box-sizing: border-box;
}

.form-group input:focus {
  outline: none;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
}

.password-input {
  position: relative;
  display: flex;
  align-items: center;
}

.toggle-pwd {
  position: absolute;
  right: 0.75rem;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1rem;
  padding: 0.25rem;
}

.demo-info {
  background: #f8fafc;
  border: 1px dashed #cbd5e1;
  padding: 0.75rem;
  border-radius: 8px;
  font-size: 0.825rem;
  color: #475569;
}

.demo-info code {
  background: #e2e8f0;
  padding: 0.15rem 0.4rem;
  border-radius: 4px;
  font-weight: 600;
  color: #0f172a;
}

.login-btn {
  width: 100%;
  padding: 0.85rem;
  background: #2563eb;
  color: #ffffff;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.2s;
  margin-top: 0.5rem;
}

.login-btn:hover:not(:disabled) {
  background: #1d4ed8;
}

.login-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}
</style>
