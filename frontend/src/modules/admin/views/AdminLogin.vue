<template>
  <div class="login-page">
    <!-- Panel Kiri: Hero -->
    <div class="login-hero" aria-hidden="true">
      <div class="login-hero-overlay"></div>
      <div class="login-hero-body">
        <div class="login-hero-brand">
          <img :src="logoSrc" alt="Logo SMK Nurul Jadid" class="login-hero-logo" />
          <span class="login-hero-school">SMK Nurul Jadid</span>
        </div>
        <div class="login-hero-text">
          <span class="login-hero-badge">
            <span class="login-hero-dot"></span>
            ADMIN PORTAL
          </span>
          <h1 class="login-hero-title">
            Kelola Sekolah<br />dengan Mudah &<br />Efisien.
          </h1>
          <p class="login-hero-desc">
            Satu platform untuk mengelola data siswa, pendaftaran, berita, dan seluruh operasional SMK Nurul Jadid.
          </p>
        </div>
        <div class="login-hero-stats">
          <div class="login-hero-stat">
            <strong>1200+</strong>
            <span>Siswa Aktif</span>
          </div>
          <div class="login-hero-stat-divider"></div>
          <div class="login-hero-stat">
            <strong>85+</strong>
            <span>Guru & Staff</span>
          </div>
          <div class="login-hero-stat-divider"></div>
          <div class="login-hero-stat">
            <strong>5</strong>
            <span>Program Keahlian</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Panel Kanan: Form -->
    <div class="login-form-panel">
      <div class="login-form-wrap">
        <!-- Header mobile: brand -->
        <div class="login-mobile-brand">
          <img :src="logoSrc" alt="Logo" class="login-mobile-logo" />
          <div>
            <strong>SMK Nurul Jadid</strong>
            <span>Admin Portal</span>
          </div>
        </div>

        <div class="login-form-header">
          <h2 class="login-form-title">Selamat Datang</h2>
          <p class="login-form-desc">Masuk untuk mengakses dashboard admin.</p>
        </div>

        <!-- Alert error -->
        <div v-if="globalError" class="login-alert" role="alert">
          <AlertTriangle :size="16" />
          <span>{{ globalError }}</span>
        </div>

        <!-- Quick login -->
        <div class="login-quick">
          <span class="login-quick-label">Login Cepat</span>
          <div class="login-quick-chips">
            <button
              v-for="acc in presetAccounts"
              :key="acc.email"
              type="button"
              class="login-quick-chip"
              :class="{ active: email === acc.email }"
              @click="selectPreset(acc)"
            >
              {{ acc.label }}
            </button>
          </div>
        </div>

        <form class="login-form" @submit.prevent="handleLogin" novalidate>
          <!-- Email -->
          <div class="login-field">
            <label class="login-label" for="email">Email</label>
            <div class="login-input-wrap" :class="{ error: errors.email }">
              <Mail :size="18" class="login-input-icon" />
              <input
                id="email"
                v-model="email"
                type="email"
                class="login-input"
                placeholder="admin@smknuruljadid.sch.id"
                autocomplete="username"
                required
              />
            </div>
            <span v-if="errors.email" class="login-field-error">{{ errors.email }}</span>
          </div>

          <!-- Password -->
          <div class="login-field">
            <label class="login-label" for="password">Password</label>
            <div class="login-input-wrap" :class="{ error: errors.password }">
              <Lock :size="18" class="login-input-icon" />
              <input
                id="password"
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                class="login-input"
                placeholder="Masukkan password"
                autocomplete="current-password"
                required
              />
              <button
                type="button"
                class="login-eye-btn"
                @click="showPassword = !showPassword"
                :aria-label="showPassword ? 'Sembunyikan password' : 'Tampilkan password'"
              >
                <Eye v-if="!showPassword" :size="18" />
                <EyeOff v-else :size="18" />
              </button>
            </div>
            <span v-if="errors.password" class="login-field-error">{{ errors.password }}</span>
          </div>

          <!-- Remember & Forgot -->
          <div class="login-row">
            <label class="login-check">
              <input v-model="rememberMe" type="checkbox" />
              <span class="login-check-box"></span>
              <span>Ingat saya</span>
            </label>
            <router-link to="/admin/forgot-password" class="login-forgot">Lupa password?</router-link>
          </div>

          <!-- Submit -->
          <button
            type="submit"
            class="login-submit"
            :disabled="isLoading || isRateLimited"
          >
            <span v-if="isLoading" class="login-spinner"></span>
            <LogIn v-else :size="18" />
            <span>{{ isLoading ? 'Memproses...' : isRateLimited ? 'Coba lagi nanti' : 'Masuk ke Dashboard' }}</span>
          </button>
        </form>

        <div class="login-back">
          <router-link to="/" class="login-back-link">
            <ArrowLeft :size="15" />
            Kembali ke Beranda
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Mail, Lock, Eye, EyeOff, LogIn, ArrowLeft, AlertTriangle } from 'lucide-vue-next'
import { loginUser } from '@/api/endpoints'
import logoSrc from '@/assets/logo.webp'

const router = useRouter()

const presetAccounts = [
  { label: 'Superadmin', email: 'superadmin@smknuruljadid.sch.id' },
  { label: 'Admin', email: 'admin@smknuruljadid.sch.id' },
  { label: 'Tata Usaha', email: 'tu@smknuruljadid.sch.id' },
  { label: 'Admin PPDB', email: 'ppdb@smknuruljadid.sch.id' },
  { label: 'Admin BKK', email: 'bkk@smknuruljadid.sch.id' },
]

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const rememberMe = ref(false)
const isLoading = ref(false)
const globalError = ref('')
const errors = reactive({ email: '', password: '' })

let failedAttempts = Number(sessionStorage.getItem('admin_login_failed') || 0)
let rateLimitedUntil = Number(sessionStorage.getItem('admin_login_limited_until') || 0)
const isRateLimited = ref(rateLimitedUntil > Date.now())

onMounted(() => {
  const savedEmail = localStorage.getItem('admin_remember_email')
  if (savedEmail) email.value = savedEmail
  if (isRateLimited.value) {
    const check = setInterval(() => {
      if (Date.now() >= rateLimitedUntil) {
        isRateLimited.value = false
        sessionStorage.removeItem('admin_login_limited_until')
        clearInterval(check)
      }
    }, 1000)
  }
})

function selectPreset(acc) {
  email.value = acc.email
  password.value = 'password123'
  errors.email = ''
  errors.password = ''
  globalError.value = ''
}

function validate() {
  errors.email = ''
  errors.password = ''
  let valid = true
  if (!email.value.trim()) {
    errors.email = 'Email wajib diisi.'
    valid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
    errors.email = 'Format email tidak valid.'
    valid = false
  }
  if (!password.value) {
    errors.password = 'Password wajib diisi.'
    valid = false
  }
  return valid
}

async function handleLogin() {
  globalError.value = ''
  if (!validate() || isRateLimited.value) return

  isLoading.value = true
  try {
    const res = await loginUser({ email: email.value.trim(), password: password.value })
    const token = res.data?.access_token
    if (!token) throw new Error('Token tidak ditemukan.')

    const storage = rememberMe.value ? localStorage : sessionStorage
    storage.setItem('auth_token', token)
    storage.setItem('admin_token', token)
    if (res.data?.user) storage.setItem('user_info', JSON.stringify(res.data.user))
    if (rememberMe.value) localStorage.setItem('admin_remember_email', email.value.trim())
    else localStorage.removeItem('admin_remember_email')

    sessionStorage.removeItem('admin_login_failed')
    sessionStorage.removeItem('admin_login_limited_until')
    router.push('/admin/dashboard')
  } catch (err) {
    failedAttempts += 1
    sessionStorage.setItem('admin_login_failed', failedAttempts)
    if (failedAttempts >= 5) {
      const until = Date.now() + 60 * 1000
      rateLimitedUntil = until
      isRateLimited.value = true
      sessionStorage.setItem('admin_login_limited_until', String(until))
      globalError.value = 'Terlalu banyak percobaan. Coba lagi dalam 1 menit.'
    } else {
      globalError.value = err.response?.data?.message || 'Email atau password salah.'
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<style lang="scss" scoped>
.login-page {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 1fr;
  background: #f1f5f9;
  overflow-x: hidden;

  > * {
    min-width: 0;
  }

  @media (min-width: 768px) {
    grid-template-columns: 1fr 1fr;
  }

  @media (min-width: 1024px) {
    grid-template-columns: 1.1fr 0.9fr;
  }
}

/* ── Hero Panel ── */
.login-hero {
  display: none;
  position: relative;
  background-image: url('https://images.unsplash.com/photo-1497215842964-222b430dc094?w=1600&q=80');
  background-size: cover;
  background-position: center;
  overflow: hidden;

  @media (min-width: 768px) {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
  }
}

.login-hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    160deg,
    rgba(4, 45, 134, 0.92) 0%,
    rgba(10, 20, 60, 0.97) 100%
  );
}

.login-hero-body {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 100%;
  padding: 2.5rem;
  gap: 2rem;
}

.login-hero-brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.login-hero-logo {
  width: 2.75rem;
  height: 2.75rem;
  border-radius: 0.75rem;
  object-fit: contain;
  flex-shrink: 0;
}

.login-hero-school {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.1rem;
  color: #ffffff;
}

.login-hero-text {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  flex: 1;
  justify-content: center;
}

.login-hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.45rem 1rem;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #bfdbfe;
  font-size: 0.72rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  width: fit-content;
}

.login-hero-dot {
  width: 0.45rem;
  height: 0.45rem;
  border-radius: 9999px;
  background: #60a5fa;
  flex-shrink: 0;
}

.login-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(1.75rem, 2.8vw, 2.75rem);
  line-height: 1.1;
  letter-spacing: -0.03em;
  color: #ffffff;
  margin: 0;
}

.login-hero-desc {
  color: rgba(191, 219, 254, 0.85);
  font-size: 0.95rem;
  line-height: 1.7;
  margin: 0;
  max-width: 28rem;
}

.login-hero-stats {
  display: flex;
  align-items: center;
  gap: clamp(0.75rem, 2vw, 1.5rem);
  padding: 1rem clamp(1rem, 2vw, 1.5rem);
  background: rgba(255, 255, 255, 0.07);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 1rem;
  backdrop-filter: blur(8px);
  flex-wrap: wrap;
}

.login-hero-stat {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;

  strong {
    font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
    font-weight: 800;
    font-size: 1.4rem;
    color: #ffffff;
    line-height: 1;
  }

  span {
    font-size: 0.75rem;
    color: rgba(191, 219, 254, 0.8);
    font-weight: 500;
  }
}

.login-hero-stat-divider {
  width: 1px;
  height: 2.5rem;
  background: rgba(255, 255, 255, 0.15);
  flex-shrink: 0;
}

/* ── Form Panel ── */
.login-form-panel {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: clamp(1.25rem, 5vw, 2.5rem) clamp(1rem, 5vw, 2rem);
  background: #f1f5f9;
  overflow: hidden;
  box-sizing: border-box;
}

.login-form-wrap {
  width: 100%;
  max-width: min(420px, 100%);
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

/* Brand mobile only */
.login-mobile-brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding-bottom: 0.5rem;

  @media (min-width: 768px) {
    display: none;
  }

  img {
    width: 2.5rem;
    height: 2.5rem;
    border-radius: 0.6rem;
    object-fit: contain;
    flex-shrink: 0;
  }

  strong {
    display: block;
    font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
    font-weight: 700;
    font-size: 1rem;
    color: #0f172a;
  }

  span {
    display: block;
    font-size: 0.8rem;
    color: #64748b;
  }
}

.login-form-header {
  .login-form-title {
    font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
    font-weight: 900;
    font-size: clamp(1.6rem, 3vw, 2rem);
    color: #0f172a;
    margin: 0 0 0.4rem;
    letter-spacing: -0.02em;
  }

  .login-form-desc {
    color: #64748b;
    font-size: 0.9rem;
    margin: 0;
    line-height: 1.5;
  }
}

/* Alert */
.login-alert {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.85rem 1rem;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 0.75rem;
  color: #991b1b;
  font-size: 0.875rem;
  font-weight: 500;
}

/* Quick login */
.login-quick {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.login-quick-label {
  font-size: 0.72rem;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.login-quick-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  min-width: 0;
}

.login-quick-chip {
  padding: 0.35rem 0.85rem;
  border-radius: 9999px;
  border: 1px solid #e2e8f0;
  background: #f8fafc;
  color: #334155;
  font-size: 0.8rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s ease;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;

  &:hover {
    border-color: #93c5fd;
    background: #eff6ff;
    color: #1e3a8a;
  }

  &.active {
    background: #1e3a8a;
    border-color: #1e3a8a;
    color: #ffffff;
  }
}

/* Form */
.login-form {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 1.25rem;
  padding: clamp(1.25rem, 5vw, 1.75rem);
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  box-shadow: 0 4px 24px rgba(15, 23, 42, 0.06);
}

.login-field {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
}

.login-label {
  font-size: 0.875rem;
  font-weight: 700;
  color: #0f172a;
}

.login-input-wrap {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.85rem 1rem;
  border-radius: 0.75rem;
  border: 1.5px solid #e2e8f0;
  background: #f8fafc;
  transition: border-color 0.2s, box-shadow 0.2s;

  &:focus-within {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    background: #ffffff;
  }

  &.error {
    border-color: #fca5a5;
    background: #fff5f5;
  }
}

.login-input-icon {
  color: #94a3b8;
  flex-shrink: 0;
}

.login-input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 0.95rem;
  color: #0f172a;
  outline: none;
  min-width: 0;
  width: 100%;
  box-sizing: border-box;

  &::placeholder {
    color: #94a3b8;
  }
}

.login-eye-btn {
  display: grid;
  place-items: center;
  border: none;
  background: transparent;
  cursor: pointer;
  color: #94a3b8;
  padding: 0.2rem;
  flex-shrink: 0;
  transition: color 0.15s;

  &:hover {
    color: #475569;
  }
}

.login-field-error {
  font-size: 0.8rem;
  color: #dc2626;
  font-weight: 500;
}

/* Remember & Forgot */
.login-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.login-check {
  display: inline-flex;
  align-items: center;
  gap: 0.55rem;
  cursor: pointer;
  font-size: 0.875rem;
  color: #334155;
  user-select: none;

  input {
    position: absolute;
    opacity: 0;
    pointer-events: none;
  }
}

.login-check-box {
  width: 1.1rem;
  height: 1.1rem;
  border-radius: 0.3rem;
  border: 1.5px solid #cbd5e1;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  transition: all 0.15s;

  .login-check input:checked + & {
    background: #1e3a8a;
    border-color: #1e3a8a;

    &::after {
      content: '';
      width: 0.3rem;
      height: 0.55rem;
      border: solid #ffffff;
      border-width: 0 2px 2px 0;
      transform: rotate(45deg);
    }
  }
}

.login-forgot {
  font-size: 0.875rem;
  font-weight: 600;
  color: #1e3a8a;
  text-decoration: none;
  white-space: nowrap;

  &:hover {
    text-decoration: underline;
  }
}

/* Submit */
.login-submit {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  width: 100%;
  padding: 1rem;
  border: none;
  border-radius: 0.75rem;
  background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 100%);
  color: #ffffff;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: opacity 0.2s, transform 0.15s;
  box-shadow: 0 4px 16px rgba(30, 58, 138, 0.3);

  &:hover:not(:disabled) {
    opacity: 0.92;
    transform: translateY(-1px);
  }

  &:disabled {
    opacity: 0.65;
    cursor: not-allowed;
    transform: none;
  }
}

.login-spinner {
  width: 1rem;
  height: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #ffffff;
  border-radius: 9999px;
  animation: spin 0.7s linear infinite;
  flex-shrink: 0;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* Back link */
.login-back {
  display: flex;
  justify-content: center;
}

.login-back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.875rem;
  color: #64748b;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s;

  &:hover {
    color: #1e3a8a;
  }
}

</style>
