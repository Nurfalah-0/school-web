<template>
  <section class="form-section">
    <div class="form-deco form-deco-left" aria-hidden="true"></div>
    <div class="form-deco form-deco-right" aria-hidden="true"></div>

    <div class="form-inner">
      <div class="form-copy">
        <h2 class="form-title">{{ title }}</h2>
        <p class="form-desc">{{ description }}</p>

        <div class="form-checks">
          <div v-for="item in checks" :key="item.title" class="form-check">
            <span class="form-check-icon"><Check :size="16" color="#ffffff" /></span>
            <div>
              <h4 class="form-check-title">{{ item.title }}</h4>
              <p class="form-check-text">{{ item.text }}</p>
            </div>
          </div>
        </div>
      </div>

      <div class="form-card">
        <div class="card-cut" aria-hidden="true"></div>
        <div class="card-fold" aria-hidden="true"></div>

        <div v-if="successMessage" class="form-alert success">
          <Check :size="18" color="#15803d" /> {{ successMessage }}
        </div>
        <div v-if="errorMessage" class="form-alert error">
          <AlertTriangle :size="18" color="#b45309" /> {{ errorMessage }}
        </div>

        <form @submit.prevent="handleSubmit" class="form-form">
          <label class="form-group">
            <input v-model="form.name" type="text" placeholder="Nama Lengkap" required />
          </label>

          <label class="form-group">
            <input v-model="form.email" type="email" placeholder="Email Aktif" required />
          </label>

          <div class="form-row">
            <label class="form-group">
              <input v-model="form.nisn" type="text" placeholder="NISN" required />
            </label>

            <label class="form-group select-field">
              <div class="select-wrap">
                <select v-model="form.program" required>
                  <option value="" disabled selected>Pilih Jurusan</option>
                  <option v-for="m in majorOptions" :key="m" :value="m">{{ m }}</option>
                </select>
                <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                  <path d="M5 7.5L10 12.5L15 7.5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
            </label>
          </div>

          <label class="form-group">
            <div class="form-upload" @click.prevent="triggerUpload">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="form-upload-icon"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
              <span v-if="!fileName">Klik atau seret CV/Portofolio</span>
              <span v-if="!fileName" class="upload-meta">PDF, JPG (Max 5MB)</span>
              <span v-else class="form-file-name">{{ fileName }}</span>
            </div>
            <input
              ref="fileInput"
              type="file"
              accept=".pdf,.jpg,.jpeg,.png"
              class="file-input"
              @change="handleFileChange"
            />
          </label>

          <button type="submit" class="form-submit" :disabled="isSubmitting">
            {{ isSubmitting ? 'Mengirim Data...' : 'Kirim Lamaran' }}
          </button>
        </form>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { Check, AlertTriangle } from 'lucide-vue-next';
import { getMajors } from '@/api/endpoints';

const emit = defineEmits(['submit-lamaran']);

const props = defineProps({
  label: {
    type: String,
    default: 'SIAP MELANGKAH?'
  },
  title: {
    type: String,
    default: 'Siap Melangkah? Daftar Sekarang.'
  },
  description: {
    type: String,
    default: 'Lengkapi formulir pendaftaran karir Anda. Tim BKK kami akan melakukan verifikasi dan mencocokkan profil Anda dengan mitra industri terbaik.'
  },
  checks: {
    type: Array,
    default: () => [
      {
        title: 'Verifikasi Dokumen Cepat',
        text: 'Proses peninjauan berkas maksimal 2x24 jam kerja.'
      },
      {
        title: 'Konseling Karir Gratis',
        text: 'Siswa mendapatkan sesi bimbingan sebelum interview industri.'
      }
    ]
  }
});

const form = ref({
  name: '',
  email: '',
  nisn: '',
  program: ''
});

const majorOptions = ref([
  'Pengembangan Perangkat Lunak & Gim (PPLG)',
  'Manajemen Perkantoran & Layanan Bisnis (MPLB)',
  'Teknik Jaringan Komputer & Telekomunikasi (TJKT)',
  'Desain Komunikasi Visual (DKV)',
  'Teknik Kendaraan Ringan (TKR)'
]);

const fileInput = ref(null);
const fileName = ref('');
const isSubmitting = ref(false);
const successMessage = ref('');
const errorMessage = ref('');

onMounted(async () => {
  try {
    const res = await getMajors();
    const list = res.data?.data || [];
    if (list.length > 0) {
      majorOptions.value = list.map(m => m.name || m.nama);
    }
  } catch (e) {
    // keep default
  }
});

const triggerUpload = () => {
  fileInput.value?.click();
};

const handleFileChange = (event) => {
  const file = event.target.files?.[0];
  fileName.value = file ? file.name : '';
};

const handleSubmit = async () => {
  successMessage.value = '';
  errorMessage.value = '';
  isSubmitting.value = true;

  try {
    // Simulate / Emit BKK Application Registration
    await new Promise(resolve => setTimeout(resolve, 800));
    emit('submit-lamaran', { ...form.value, file: fileName.value });

    successMessage.value = 'Pendaftaran PKL/BKK berhasil dikirim! Tim kami akan menghubungi Anda via Email/WhatsApp.';
    form.value = { name: '', email: '', nisn: '', program: '' };
    fileName.value = '';
    if (fileInput.value) fileInput.value.value = '';
  } catch (err) {
    errorMessage.value = err.message || 'Terjadi kendala saat mengirim data.';
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<style lang="scss" scoped>
.form-section {
  position: relative;
  overflow: hidden;
  background: linear-gradient(180deg, #f7f8fb 0%, #f3f4f6 100%);
  padding: 5rem 0;
  margin-top: -1px;
}

.form-deco {
  position: absolute;
  pointer-events: none;
  z-index: 0;
  opacity: 0.95;
}

.form-deco-left {
  left: -8rem;
  bottom: -5rem;
  width: 32rem;
  height: 26rem;
  background: rgba(148, 163, 184, 0.18);
  clip-path: polygon(0 100%, 79% 28%, 100% 48%, 100% 100%);
}

.form-deco-right {
  right: -6rem;
  top: 2rem;
  width: 20rem;
  height: 18rem;
  background: rgba(167, 139, 250, 0.12);
  clip-path: polygon(30% 0, 100% 0, 100% 100%, 0 100%);
}

.form-inner {
  position: relative;
  z-index: 1;
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
  align-items: center;
}

@media (min-width: 768px) {
  .form-inner {
    grid-template-columns: 1.1fr 1fr;
    gap: 4rem;
  }
}

.form-copy {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(2.2rem, 4vw, 3.4rem);
  line-height: 1.05;
  letter-spacing: -0.05em;
  color: #0f172a;
  margin: 0;
}

.form-desc {
  color: #334155;
  font-size: 1rem;
  line-height: 1.7;
  margin: 0;
}

.form-checks {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-top: 0.5rem;
}

.form-check {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
}

.form-check-icon {
  width: 2rem;
  height: 2rem;
  border-radius: 9999px;
  background: #bbf7d0;
  color: #166534;
  display: grid;
  place-items: center;
  font-weight: 700;
  font-size: 0.9rem;
  flex-shrink: 0;
}

.form-check-title {
  font-weight: 700;
  font-size: 1.05rem;
  color: #0f172a;
  margin: 0 0 0.25rem;
}

.form-check-text {
  font-size: 0.95rem;
  color: #475569;
  line-height: 1.6;
  margin: 0;
}

.form-card {
  position: relative;
  background: #faf7f0;
  border-radius: 1.75rem;
  padding: 2rem;
  box-shadow: 0 24px 50px rgba(15, 23, 42, 0.08);
  border: 1px solid rgba(148, 163, 184, 0.2);
  overflow: hidden;
}

.card-cut,
.card-fold {
  position: absolute;
  pointer-events: none;
  z-index: 0;
}

.card-cut {
  top: 0;
  right: 0;
  width: 7.5rem;
  height: 7.5rem;
  background: rgba(148, 163, 184, 0.22);
  clip-path: polygon(100% 0, 0 0, 100% 100%);
}

.card-fold {
  top: 0;
  right: 0;
  width: 5.5rem;
  height: 5.5rem;
  background: rgba(167, 139, 250, 0.28);
  clip-path: polygon(100% 0, 0 0, 100% 100%);
  transform: translate(0.05rem, -0.05rem);
}

.form-alert,
.form-form {
  position: relative;
  z-index: 1;
}

.form-form {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group input,
.form-group select {
  width: 100%;
  border: 0;
  border-bottom: 1px solid #d4d4d8;
  background: transparent;
  border-radius: 0;
  padding: 0.9rem 0.15rem 0.9rem 0.15rem;
  font-size: 0.96rem;
  color: #0f172a;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.form-group input::placeholder,
.form-group select::placeholder {
  color: #6b7280;
}

.form-group input:focus,
.form-group select:focus {
  border-bottom-color: #0b3ca8;
  box-shadow: 0 1px 0 0 #0b3ca8;
}

.form-group select {
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  color: #374151;
}

.select-field {
  justify-content: flex-end;
}

.select-wrap {
  position: relative;
  width: 100%;
}

.select-wrap svg {
  position: absolute;
  right: 0.15rem;
  top: 50%;
  width: 1rem;
  height: 1rem;
  transform: translateY(-50%);
  color: #64748b;
  pointer-events: none;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@media (min-width: 640px) {
  .form-row {
    grid-template-columns: 1fr 1fr;
  }
}

.form-upload {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 1.4rem 1rem;
  border: 2px dashed #d1d5db;
  border-radius: 0.9rem;
  background: #ffffff;
  cursor: pointer;
  transition: border-color 0.2s, background 0.2s;
  text-align: center;
  min-height: 150px;
}

.form-upload:hover {
  border-color: #0b3ca8;
  background: #f8fafc;
}

.form-upload-icon {
  color: #64748b;
}

.form-upload span {
  color: #475569;
  font-size: 0.9rem;
}

.upload-meta {
  color: #64748b;
  font-size: 0.82rem;
}

.form-file-name {
  color: #042d86;
  font-weight: 600;
  font-size: 0.9rem;
}

.file-input {
  display: none;
}

.form-submit {
  width: 100%;
  padding: 0.95rem 1rem;
  background: #042d86;
  color: #ffffff;
  border: none;
  border-radius: 0.9rem;
  font-size: 1.05rem;
  font-weight: 700;
  cursor: pointer;
  transition: background-color 0.2s, transform 0.2s;
}

.form-submit:hover:not(:disabled) {
  background: #032263;
}

.form-submit:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.form-alert {
  position: relative;
  z-index: 1;
  padding: 0.85rem 1rem;
  border-radius: 0.75rem;
  font-size: 0.9rem;
  font-weight: 500;
  margin-bottom: 0.75rem;
}

.form-alert.success {
  background: #dcfce7;
  color: #166534;
}

.form-alert.error {
  background: #fee2e2;
  color: #991b1b;
}

@media (max-width: 767px) {
  .form-section {
    padding: 4rem 0;
  }

  .form-inner {
    width: min(100% - 24px, 100%);
    gap: 2rem;
  }

  .form-card {
    border-radius: 1.35rem;
    padding: 1.25rem;
  }

  .card-cut {
    width: 4.5rem;
    height: 4.5rem;
  }

  .card-fold {
    width: 3.25rem;
    height: 3.25rem;
  }

  .form-deco-left {
    left: -7rem;
    bottom: -4rem;
    width: 18rem;
    height: 13rem;
  }

  .form-deco-right {
    right: -4rem;
    top: 1rem;
    width: 10rem;
    height: 9rem;
  }
}
</style>
