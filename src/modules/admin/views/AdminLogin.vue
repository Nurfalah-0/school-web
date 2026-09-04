<template>
  <div class="admin-login-page">
    <header class="admin-topbar">
      <div class="admin-topbar-inner">
        <div class="admin-brand">
          <img :src="logoSrc" alt="Logo SMK" class="admin-brand-logo" />
          <div class="admin-brand-text-wrap">
            <span class="admin-brand-name">SMK Nurul Jadid</span>
            <span class="admin-brand-subtitle">Admin Portal</span>
          </div>
        </div>
        <nav class="admin-topbar-nav">
          <router-link to="/support" class="admin-topbar-link"
            >Support</router-link
          >
          <router-link to="/portal-guide" class="admin-topbar-link"
            >Portal Guide</router-link
          >
          <router-link to="/admin/contact" class="admin-topbar-btn"
            >Contact Admin</router-link
          >
        </nav>
      </div>
    </header>

    <div class="admin-login-grid">
      <div class="admin-hero-panel">
        <div class="admin-hero-overlay"></div>
        <div class="admin-hero-vignette"></div>
        <div class="admin-hero-content">
          <span class="admin-hero-badge">
            <span class="admin-hero-badge-dot"></span>
            ADMIN PORTAL ACCESS
          </span>
          <h1 class="admin-hero-title">
            Empowering<br />the Future<br />workforce<br />through Digital<br />Innovation.
          </h1>
          <p class="admin-hero-desc">
            Manage scholastic records, faculty configurations, and systemic
            operations with unparalleled clarity and speed.
          </p>
          <div class="admin-hero-indicators">
            <span class="admin-hero-indicator active"></span>
            <span class="admin-hero-indicator"></span>
            <span class="admin-hero-indicator"></span>
          </div>
        </div>
      </div>

      <div class="admin-form-panel">
        <div class="admin-form-card">
          <div class="admin-form-header">
            <h2 class="admin-form-title">Admin Login</h2>
            <p class="admin-form-desc">
              Please enter your credentials to access the portal.
            </p>
          </div>

          <div v-if="globalError" class="admin-alert">
            {{ globalError }}
          </div>

          <form class="admin-form" @submit.prevent="handleLogin">
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

            <div class="form-group">
              <label class="form-label" for="password">Password</label>
              <div class="input-wrap">
                <Lock :size="20" color="#64748b" />
                <input
                  id="password"
                  v-model="password"
                  :type="showPassword ? 'text' : 'password'"
                  class="form-input"
                  placeholder="Enter your password"
                  autocomplete="current-password"
                />
                <button
                  type="button"
                  class="input-icon-btn"
                  @click="showPassword = !showPassword"
                  :aria-label="showPassword ? 'Hide password' : 'Show password'"
                >
                  <Eye v-if="!showPassword" :size="20" color="#64748b" />
                  <EyeOff v-else :size="20" color="#64748b" />
                </button>
              </div>
              <p v-if="errors.password" class="form-error">
                {{ errors.password }}
              </p>
            </div>

            <div class="form-row">
              <label class="check-label">
                <input v-model="rememberMe" type="checkbox" />
                <span class="check-box"></span>
                <span class="check-text">Remember Me</span>
              </label>
              <router-link to="/admin/forgot-password" class="forgot-link"
                >Forgot Password?</router-link
              >
            </div>

            <button
              type="submit"
              class="submit-btn"
              :disabled="isLoading || isRateLimited"
            >
              <span v-if="isLoading" class="spinner"></span>
              <span>{{
                isLoading
                  ? "Signing In..."
                  : isRateLimited
                    ? "Coba lagi nanti"
                    : "Sign In"
              }}</span>
            </button>
          </form>

          <div class="admin-form-footer">
            <div class="admin-form-footer-links">
              <router-link to="/support" class="footer-link">
                <HelpCircle :size="16" color="#64748b" />
                Support
              </router-link>
              <span class="footer-dot"></span>
              <router-link to="/portal-guide" class="footer-link">
                <BookOpen :size="16" color="#64748b" />
                Portal Guide
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>

    <footer class="admin-footer">
      <span>© 2026 SMK Nurul Jadid. Empowering the future workforce.</span>
      <div class="admin-footer-links">
        <router-link to="/privacy" class="admin-footer-link"
          >Privacy Policy</router-link
        >
        <router-link to="/terms" class="admin-footer-link"
          >Terms of Service</router-link
        >
        <router-link to="/security" class="admin-footer-link"
          >Security</router-link
        >
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from "vue";
import { useRouter } from "vue-router";
import { Mail, Lock, Eye, EyeOff, HelpCircle, BookOpen } from "lucide-vue-next";
import { loginUser } from "@/api/endpoints";
import logoSrc from "@/assets/logo.webp";

const router = useRouter();

const email = ref("");
const password = ref("");
const showPassword = ref(false);
const rememberMe = ref(false);
const isLoading = ref(false);
const globalError = ref("");
const errors = reactive({ email: "", password: "" });

let failedAttempts = Number(sessionStorage.getItem("admin_login_failed") || 0);
let rateLimitedUntil = Number(
  sessionStorage.getItem("admin_login_limited_until") || 0,
);
const isRateLimited = ref(rateLimitedUntil > Date.now());

onMounted(() => {
  document.body.style.overflow = "hidden";
  document.documentElement.style.overflow = "hidden";
  const savedEmail = localStorage.getItem("admin_remember_email");
  if (savedEmail) email.value = savedEmail;
  if (isRateLimited.value) {
    const check = setInterval(() => {
      if (Date.now() >= rateLimitedUntil) {
        isRateLimited.value = false;
        sessionStorage.removeItem("admin_login_limited_until");
        clearInterval(check);
      }
    }, 1000);
  }
});

onUnmounted(() => {
  document.body.style.overflow = "";
  document.documentElement.style.overflow = "";
});

function validate() {
  errors.email = "";
  errors.password = "";
  let valid = true;
  if (!email.value.trim()) {
    errors.email = "Email wajib diisi.";
    valid = false;
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
    errors.email = "Format email tidak valid.";
    valid = false;
  }
  if (!password.value) {
    errors.password = "Password wajib diisi.";
    valid = false;
  }
  return valid;
}

async function handleLogin() {
  globalError.value = "";
  if (!validate()) return;
  if (isRateLimited.value) return;

  isLoading.value = true;
  try {
    const res = await loginUser({
      email: email.value.trim(),
      password: password.value,
    });

    const token = res.data?.access_token;
    if (!token) throw new Error("Token tidak ditemukan.");

    const storage = rememberMe.value ? localStorage : sessionStorage;
    storage.setItem("auth_token", token);
    storage.setItem("admin_email", email.value.trim());
    if (rememberMe.value)
      localStorage.setItem("admin_remember_email", email.value.trim());
    else localStorage.removeItem("admin_remember_email");

    if (res.data?.user) {
      storage.setItem("user_info", JSON.stringify(res.data.user));
    }

    sessionStorage.removeItem("admin_login_failed");
    sessionStorage.removeItem("admin_login_limited_until");

    router.push("/admin/dashboard");
  } catch (err) {
    failedAttempts += 1;
    sessionStorage.setItem("admin_login_failed", failedAttempts);

    if (failedAttempts >= 5) {
      const until = Date.now() + 60 * 1000;
      rateLimitedUntil = until;
      isRateLimited.value = true;
      sessionStorage.setItem("admin_login_limited_until", String(until));
      globalError.value =
        "Terlalu banyak percobaan. Coba lagi dalam beberapa menit.";
    } else {
      globalError.value =
        err.response?.data?.message ||
        "Email atau password salah. Silakan coba lagi.";
    }
  } finally {
    isLoading.value = false;
  }
}
</script>

<style lang="scss" scoped>
.admin-login-page {
  height: 100vh;
  height: 100dvh;
  width: 100%;
  display: flex;
  flex-direction: column;
  background: #f8f7fb;
  overflow: hidden;
}

.admin-topbar {
  background: #ffffff;
  border-bottom: 1px solid #e2e8f0;
  padding: 1.25rem 2.5rem;
  flex-shrink: 0;
  overflow: hidden;
}

.admin-topbar-inner {
  max-width: 1440px;
  margin: 0 auto;
  height: auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.admin-brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.admin-brand-logo {
  width: 2.75rem;
  height: 2.75rem;
  border-radius: 0.75rem;
  object-fit: contain;
  flex-shrink: 0;
}

.admin-brand-text-wrap {
  display: flex;
  flex-direction: column;
  line-height: 1.1;
}

.admin-brand-name {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #1e3a8a;
  display: block;
  line-height: 1.2;
}

.admin-brand-subtitle {
  font-size: 0.75rem;
  color: #64748b;
  display: block;
  margin-top: -0.125rem;
}

.admin-topbar-nav {
  display: flex;
  align-items: center;
  gap: 2.5rem;
}

.admin-topbar-link {
  font-size: 0.875rem;
  font-weight: 500;
  color: #334155;
  text-decoration: none;
  transition: color 0.2s;
}

.admin-topbar-link:hover {
  color: #1e3a8a;
}

.admin-topbar-btn {
  padding: 0.75rem 1.5rem;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 600;
  font-size: 0.875rem;
  text-decoration: none;
  transition: background 0.2s;
}

.admin-topbar-btn:hover {
  background: #16264d;
}

.admin-login-grid {
  flex: 1;
  min-height: 0;
  display: grid;
  grid-template-columns: minmax(0, 45fr) minmax(0, 55fr);
  overflow: hidden;
}

.admin-hero-panel {
  position: relative;
  height: 100%;
  overflow: hidden;
  background-image: url("https://images.unsplash.com/photo-1497215842964-222b430dc094?w=1600&q=80");
  background-size: cover;
  background-position: center;
}

.admin-hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to top,
    rgba(10, 15, 46, 0.95),
    rgba(30, 58, 138, 0.85),
    rgba(30, 58, 138, 0.7)
  );
  z-index: 1;
}

.admin-hero-vignette {
  position: absolute;
  inset: 0;
  background: radial-gradient(
    circle at center,
    rgba(59, 130, 246, 0.08) 0%,
    transparent 70%
  );
  z-index: 2;
  pointer-events: none;
}

.admin-hero-content {
  position: relative;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 1.5rem;
  z-index: 3;
  color: #ffffff;
  overflow: hidden;
  gap: 0.75rem;
}

.admin-hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1.25rem;
  border-radius: 9999px;
  background: rgba(30, 58, 138, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.2);
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  width: fit-content;
  flex-shrink: 0;
}

.admin-hero-badge-dot {
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 9999px;
  background: #ffffff;
  flex-shrink: 0;
}

.admin-hero-title {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(1.5rem, 3vw, 2.5rem);
  line-height: 1.02;
  margin: 0;
  color: #ffffff;
  letter-spacing: -0.02em;
  overflow-wrap: break-word;
  max-width: 100%;
  flex-shrink: 0;
}

.admin-hero-desc {
  margin-top: 0;
  font-size: 0.9rem;
  line-height: 1.5;
  color: rgba(191, 219, 254, 0.9);
  max-width: 100%;
  font-weight: 500;
  flex-shrink: 0;
}

.admin-hero-indicators {
  display: flex;
  gap: 0.5rem;
  margin-top: 1rem;
  flex-shrink: 0;
}

.admin-hero-indicator {
  height: 4px;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.3);
  flex-shrink: 0;
}

.admin-hero-indicator.active {
  width: 2rem;
  background: #ffffff;
}

.admin-hero-indicator:not(.active) {
  width: 1rem;
}

.admin-form-panel {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: clamp(2rem, 5vh, 4rem) 1.5rem;
  overflow: hidden;
  background: #f8f7fb;
}

.admin-form-card {
  background: #ffffff;
  border-radius: 1.25rem;
  padding: 1.5rem;
  width: 100%;
  max-width: 380px;
  box-shadow: 0 20px 48px rgba(15, 23, 42, 0.08);
}

.admin-form-header {
  margin-bottom: 1.75rem;
}

.admin-form-title {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 900;
  font-size: 1.875rem;
  color: #0f172a;
  margin: 0;
  line-height: 1.2;
}

.admin-form-desc {
  margin-top: 0.5rem;
  font-size: 0.875rem;
  color: #64748b;
  line-height: 1.5;
}

.admin-alert {
  background: #fef2f2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 0.75rem;
  padding: 0.75rem 1rem;
  font-size: 0.875rem;
  margin-bottom: 1.25rem;
}

.admin-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
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
  padding: 1rem 1.25rem;
  border-radius: 1rem;
  background: #eef0fc;
  border: 1px solid transparent;
  transition:
    border-color 0.2s ease,
    box-shadow 0.2s ease;
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

.input-icon-btn {
  display: grid;
  place-items: center;
  border: none;
  background: transparent;
  cursor: pointer;
  padding: 0.25rem;
  color: inherit;
  flex-shrink: 0;
}

.form-error {
  font-size: 0.8rem;
  color: #991b1b;
  margin: 0;
}

.form-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.check-label {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  cursor: pointer;
  font-size: 0.875rem;
  color: #334155;
}

.check-label input {
  position: absolute;
  opacity: 0;
  pointer-events: none;
}

.check-box {
  width: 1.1rem;
  height: 1.1rem;
  border-radius: 0.35rem;
  border: 2px solid #cbd5e1;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  transition: all 0.15s ease;
}

.check-label input:checked + .check-box {
  background: #1e3a8a;
  border-color: #1e3a8a;
}

.check-label input:checked + .check-box::after {
  content: "";
  width: 0.35rem;
  height: 0.65rem;
  border: solid #ffffff;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.forgot-link {
  font-size: 0.875rem;
  font-weight: 700;
  color: #1e3a8a;
  text-decoration: none;
}

.forgot-link:hover {
  text-decoration: underline;
}

.submit-btn {
  margin-top: 0.5rem;
  width: 100%;
  padding: 1.1rem;
  border: none;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 1.125rem;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: background 0.2s ease;
  flex-shrink: 0;
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

.admin-form-footer {
  margin-top: 1.25rem;
  padding-top: 1.25rem;
  border-top: 1px solid #e2e8f0;
  display: flex;
  justify-content: center;
  flex-shrink: 0;
}

.admin-form-footer-links {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.footer-link {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.875rem;
  color: #64748b;
  text-decoration: none;
}

.footer-link:hover {
  color: #1e3a8a;
}

.footer-dot {
  width: 0.25rem;
  height: 0.25rem;
  border-radius: 9999px;
  background: #cbd5e1;
  flex-shrink: 0;
}

.admin-footer {
  background: #f8f7fb;
  border-top: 1px solid #e2e8f0;
  padding: 1rem 2.5rem;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.875rem;
  color: #94a3b8;
  flex-shrink: 0;
  overflow: hidden;
}

.admin-footer-links {
  display: flex;
  gap: 2rem;
}

.admin-footer-link {
  font-size: 0.875rem;
  color: #94a3b8;
  text-decoration: none;
}

.admin-footer-link:hover {
  color: #1e3a8a;
}

@media (max-width: 640px) {
  .admin-topbar {
    padding: 1rem 1.25rem;
  }

  .admin-topbar-nav {
    gap: 1rem;
  }

  .admin-topbar-link {
    display: none;
  }

  .admin-form-panel {
    padding: 1.5rem 1rem;
  }

  .admin-form-card {
    padding: 2rem 1.25rem;
  }

  .admin-footer {
    padding: 1rem;
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
