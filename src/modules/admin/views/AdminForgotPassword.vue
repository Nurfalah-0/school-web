<template>
  <div class="admin-forgot-page">
    <div class="admin-forgot-card">
      <div class="brand-badge-wrap">
        <div class="brand-icon-circle">
          <KeyRound :size="24" color="#1e3a8a" />
        </div>
      </div>

      <h2 class="admin-forgot-title">Reset Password</h2>
      <p class="admin-forgot-desc">
        Masukkan email administrator akun sekolah untuk menerima tautan instruksi pemulihan kata sandi.
      </p>

      <div v-if="message" :class="['admin-alert', messageType]">
        <CheckCircle2 v-if="messageType === 'success'" :size="18" class="alert-icon" />
        <AlertCircle v-else :size="18" class="alert-icon" />
        <span>{{ message }}</span>
      </div>

      <form class="admin-form" @submit.prevent="handleSubmit">
        <div class="form-group">
          <label class="form-label" for="email">Email Administrator</label>
          <div class="input-wrap">
            <Mail :size="18" class="input-icon" />
            <input
              id="email"
              v-model="email"
              type="email"
              class="form-input"
              placeholder="admin@smknuruljadid.sch.id"
              autocomplete="email"
            />
          </div>
          <p v-if="errors.email" class="form-error">{{ errors.email }}</p>
        </div>

        <button type="submit" class="submit-btn" :disabled="isLoading">
          <span v-if="isLoading" class="spinner"></span>
          <span>{{ isLoading ? "Mengirim Instruksi..." : "Kirim Tautan Reset" }}</span>
        </button>
      </form>

      <p class="admin-forgot-footer">
        <router-link to="/login" class="admin-back-link">
          <ArrowLeft :size="16" />
          <span>Kembali ke Halaman Login</span>
        </router-link>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from "vue";
import { Mail, ArrowLeft, KeyRound, CheckCircle2, AlertCircle } from "lucide-vue-next";
import { adminForgotPassword } from "@/api/endpoints";

const email = ref("");
const isLoading = ref(false);
const message = ref("");
const messageType = ref("success");
const errors = reactive({ email: "" });

onMounted(() => {
  document.body.style.overflow = "hidden";
  document.documentElement.style.overflow = "hidden";
});

onUnmounted(() => {
  document.body.style.overflow = "";
  document.documentElement.style.overflow = "";
});

function validate() {
  errors.email = "";
  if (!email.value.trim()) {
    errors.email = "Email wajib diisi.";
    return false;
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
    errors.email = "Format email tidak valid.";
    return false;
  }
  return true;
}

async function handleSubmit() {
  message.value = "";
  if (!validate()) return;

  isLoading.value = true;
  try {
    await adminForgotPassword({ email: email.value.trim() });
    message.value = "Link reset password telah dikirim ke email Anda.";
    messageType.value = "success";
    email.value = "";
  } catch (err) {
    message.value =
      err.response?.data?.message || "Gagal mengirim. Coba lagi nanti.";
    messageType.value = "error";
  } finally {
    isLoading.value = false;
  }
}
</script>

<style lang="scss" scoped>
.admin-forgot-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f8fafc;
  padding: 2rem 1.25rem;
}

.admin-forgot-card {
  background: #ffffff;
  border-radius: 1.5rem;
  padding: 2.5rem;
  width: 100%;
  max-width: 28rem;
  box-shadow: 0 10px 30px -5px rgba(15, 23, 42, 0.08), 0 0 0 1px rgba(226, 232, 240, 0.8);
  text-align: center;
}

.brand-badge-wrap {
  display: flex;
  justify-content: center;
  margin-bottom: 1.25rem;
}

.brand-icon-circle {
  width: 3.5rem;
  height: 3.5rem;
  border-radius: 1rem;
  background: #eff6ff;
  border: 1px solid #dbeafe;
  display: flex;
  align-items: center;
  justify-content: center;
}

.admin-forgot-title {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.6rem;
  color: #0f172a;
  margin: 0;
  letter-spacing: -0.02em;
}

.admin-forgot-desc {
  margin-top: 0.6rem;
  font-size: 0.875rem;
  color: #64748b;
  line-height: 1.5;
}

.admin-alert {
  margin-top: 1.25rem;
  padding: 0.85rem 1rem;
  border-radius: 0.75rem;
  font-size: 0.85rem;
  display: flex;
  align-items: center;
  gap: 0.65rem;
  text-align: left;
}

.admin-alert.success {
  background: #f0fdf4;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.admin-alert.error {
  background: #fef2f2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.alert-icon {
  flex-shrink: 0;
}

.admin-form {
  margin-top: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  text-align: left;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.form-label {
  font-size: 0.825rem;
  font-weight: 700;
  color: #334155;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.input-wrap {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.85rem 1rem;
  border-radius: 0.75rem;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  transition: all 0.2s ease;
}

.input-wrap:focus-within {
  background: #ffffff;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

.input-icon {
  color: #94a3b8;
  flex-shrink: 0;
}

.form-input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 0.925rem;
  color: #0f172a;
  outline: none;
  min-width: 0;
}

.form-input::placeholder {
  color: #94a3b8;
}

.form-error {
  font-size: 0.8rem;
  color: #ef4444;
  margin: 0;
}

.submit-btn {
  width: 100%;
  padding: 0.9rem 1.25rem;
  border: none;
  border-radius: 0.75rem;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.95rem;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25);
  transition: all 0.2s ease;
}

.submit-btn:hover:not(:disabled) {
  background: #172554;
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(30, 58, 138, 0.35);
}

.submit-btn:active:not(:disabled) {
  transform: translateY(0);
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
  margin-top: 1.75rem;
  text-align: center;
}

.admin-back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: #64748b;
  text-decoration: none;
  transition: color 0.2s ease;
}

.admin-back-link:hover {
  color: #1e3a8a;
}
</style>
