<template>
  <div class="login-wrapper">
    <div class="login-card">
      <div class="login-brand">
        <img :src="logo" alt="Logo SMK" class="login-logo" />
        <div>
          <strong>SMK Nurul Jadid</strong>
          <p>Portal Admin</p>
        </div>
      </div>
      <div class="login-header">
        <router-link to="/" class="back-link">← Kembali ke Beranda</router-link>
        <h2>Masuk ke Dashboard</h2>
        <p>Masuk untuk mengelola data pendaftaran dan kemitraan SMK.</p>
      </div>

      <div v-if="errorMessage" class="login-alert">
        <AlertTriangle :size="18" color="#991b1b" /> {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="email">Email</label>
          <input
            id="email"
            v-model="email"
            type="email"
            placeholder="Contoh: superadmin@smknuruljadid.sch.id"
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
              <Eye v-if="!showPassword" :size="18" color="#64748b" />
              <EyeOff v-else :size="18" color="#64748b" />
            </button>
          </div>
        </div>

        <div class="demo-info">
          <p><strong>Pilih Akun Demo (Login Cepat):</strong></p>
          <div class="quick-logins">
            <button
              type="button"
              @click="setDemoAccount('superadmin')"
              class="demo-btn"
            >
              Superadmin
            </button>
            <button
              type="button"
              @click="setDemoAccount('admin')"
              class="demo-btn"
            >
              Admin Sekolah
            </button>
            <button
              type="button"
              @click="setDemoAccount('tu')"
              class="demo-btn"
            >
              TU Sekolah
            </button>
          </div>
        </div>

        <button
          type="submit"
          class="button-primary login-btn"
          :disabled="isLoading"
        >
          {{ isLoading ? "Memproses..." : "Masuk ke Dashboard" }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import logo from "../../../assets/logo.webp";
import { loginUser } from "../../../api/endpoints";
import { AlertTriangle, Eye, EyeOff } from "lucide-vue-next";

const router = useRouter();

const email = ref("superadmin@smknuruljadid.sch.id");
const password = ref("password123");
const showPassword = ref(false);
const isLoading = ref(false);
const errorMessage = ref("");

const setDemoAccount = (role) => {
  if (role === "superadmin") {
    email.value = "superadmin@smknuruljadid.sch.id";
  } else if (role === "admin") {
    email.value = "admin@smknuruljadid.sch.id";
  } else if (role === "tu") {
    email.value = "tu@smknuruljadid.sch.id";
  }
  password.value = "password123";
};

const handleLogin = async () => {
  isLoading.value = true;
  errorMessage.value = "";

  try {
    // Step 1: Get CSRF cookie from backend
    await fetch("http://localhost:8000/api/sanctum/csrf-cookie", {
      credentials: "include",
    });

    // Step 2: Login with credentials
    const res = await loginUser({
      email: email.value,
      password: password.value,
    });

    if (res.data?.access_token) {
      // Store token
      localStorage.setItem("auth_token", res.data.access_token);

      // Store user info
      if (res.data.user) {
        localStorage.setItem("user_info", JSON.stringify(res.data.user));
      }

      // Redirect to dashboard
      router.push("/admin/dashboard");
    } else {
      errorMessage.value = "Response tidak valid dari server";
    }
  } catch (error) {
    console.error("Login gagal:", error);
    const errorMsg =
      error.response?.data?.message ||
      error.response?.data?.error ||
      "Email atau password salah. Silakan coba lagi.";
    errorMessage.value = errorMsg;
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
  box-shadow:
    0 20px 25px -5px rgba(0, 0, 0, 0.2),
    0 10px 10px -5px rgba(0, 0, 0, 0.1);
}

.login-brand {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.login-logo {
  width: 50px;
  height: 50px;
  border-radius: 8px;
}

.login-brand strong {
  display: block;
  font-size: 1.1rem;
  color: #0f172a;
}

.login-brand p {
  color: #64748b;
  font-size: 0.85rem;
  margin: 0;
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
  transition:
    border-color 0.2s,
    box-shadow 0.2s;
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
  background: #f0fdf4;
  border: 1px solid #dcfce7;
  padding: 0.75rem;
  border-radius: 8px;
  font-size: 0.825rem;
  color: #166534;
}

.demo-info p {
  margin: 0.25rem 0;
}

.demo-info code {
  background: #e7f5ff;
  padding: 0.15rem 0.4rem;
  border-radius: 4px;
  font-weight: 600;
  color: #1e40af;
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

.quick-logins {
  display: flex;
  gap: 0.5rem;
  margin-top: 0.5rem;
  flex-wrap: wrap;
}

.demo-btn {
  background: #e7f5ff;
  border: 1px solid #bae6fd;
  color: #0369a1;
  padding: 0.4rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.demo-btn:hover {
  background: #bae6fd;
  color: #0c4a6e;
}
</style>
