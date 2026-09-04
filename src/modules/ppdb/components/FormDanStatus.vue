<template>
  <section class="form-section" id="pendaftaran">
    <div class="form-deco form-deco-left" aria-hidden="true"></div>
    <div class="form-deco form-deco-right" aria-hidden="true"></div>
    <div class="form-inner">
      <div class="form-card-main" id="formulir">
        <h2 class="form-main-title">Formulir Pendaftaran</h2>

        <form @submit.prevent="handleSubmit" class="form-form">
          <div class="form-row">
            <label class="form-group">
              <span>NAMA LENGKAP SESUAI IJAZAH</span>
              <input ref="namaInput" v-model="form.nama" type="text" placeholder="Nama Lengkap" required />
            </label>

            <label class="form-group">
              <span>NOMOR INDUK SISWA NASIONAL</span>
              <input v-model="form.nisn" type="text" placeholder="NISN" required />
            </label>
          </div>

          <div class="form-row">
            <label class="form-group">
              <span>EMAIL AKTIF</span>
              <input v-model="form.email" type="email" placeholder="contoh@email.com" />
            </label>

            <label class="form-group">
              <span>NO. TELEPON / WHATSAPP</span>
              <input v-model="form.phone" type="tel" placeholder="08xxxxxxxxxx" />
            </label>
          </div>

          <label class="form-group">
            <span>Pilihan Jurusan Utama</span>
            <div class="select-wrap">
              <select v-model="form.jurusan" required>
                <option value="" disabled>Pilih Program Keahlian</option>
                <option v-for="m in majorOptions" :key="m" :value="m">{{ m }}</option>
              </select>
              <ChevronDown class="select-icon" />
            </div>
          </label>

          <label class="form-group">
            <span>ALAMAT RUMAH LENGKAP</span>
            <textarea v-model="form.alamat" rows="3" placeholder="Alamat lengkap" required></textarea>
          </label>

          <label class="form-group">
            <span>UPLOAD BERKAS (PDF/JPG/PNG, MAX 2MB)</span>
            <div class="form-upload" @click.prevent="triggerUpload">
              <CloudUpload class="form-upload-icon" />
              <span v-if="!fileName">Tarik file ke sini atau pilih dari perangkat</span>
              <span v-else class="form-file-name">{{ fileName }}</span>
            </div>
            <small class="form-upload-hint">*Ijazah/SKL, Kartu Keluarga, atau Akta Kelahiran*</small>
            <input ref="fileInput" type="file" accept=".pdf,.jpg,.jpeg,.png" class="file-input" @change="handleFileChange" />
          </label>

          <button type="submit" class="form-submit" :disabled="isSubmitting">
            {{ isSubmitting ? 'Mengirim Pendaftaran...' : 'Kirim Pendaftaran' }}
          </button>
          <p v-if="submitMessage" :class="['form-message', submitMessageType]">{{ submitMessage }}</p>
        </form>
      </div>

      <div class="form-side">
        <div class="form-status-card" id="status">
          <h3 class="form-status-title">Cek Status Pendaftaran</h3>

          <form @submit.prevent="handleSearchStatus" class="form-search">
            <input v-model="searchNo" type="text" placeholder="Masukkan No. Pendaftaran / NISN" required />
            <button class="form-search-btn" type="submit" :disabled="isSearching" aria-label="Cari">
              <Search :size="18" />
            </button>
          </form>

          <!-- Search Result Display -->
          <div v-if="searchResult" class="search-result-box">
            <div class="result-header">
              <strong>{{ searchResult.nama }}</strong>
              <span class="result-badge" :class="resultBadgeClass">
                {{ searchResult.status_label || searchResult.status }}
              </span>
            </div>
            <div class="result-details">
              <p><span>No. Daftar:</span> <code>{{ searchResult.no_pendaftaran }}</code></p>
              <p><span>Jurusan:</span> {{ searchResult.program }}</p>
              <p v-if="searchResult.tanggal_daftar"><span>Tgl Daftar:</span> {{ searchResult.tanggal_daftar }}</p>
              <p v-if="searchResult.catatan_admin" class="result-note"><span>Catatan:</span> {{ searchResult.catatan_admin }}</p>
            </div>
          </div>
          <p v-else-if="searchError" class="search-error-msg">{{ searchError }}</p>

          <div v-if="!searchResult" class="form-status-list">
            <div v-for="item in statusList" :key="item.label" class="form-status-item">
              <div class="form-status-row">
                <div class="form-status-main">
                  <span class="form-status-icon" :style="{ background: item.iconBg, color: item.iconColor }">
                    <component :is="item.icon" :size="15" />
                  </span>
                  <span class="form-status-label">{{ item.label }}</span>
                </div>
                <span class="form-status-badge" :style="{ background: item.badgeBg, color: item.badgeColor }">
                  {{ item.status }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <div class="form-help-card">
          <h4 class="form-help-title">Butuh Bantuan?</h4>
          <p class="form-help-text">
            Tim admin kami siap membantu proses pendaftaran Anda melalui WhatsApp atau telepon langsung.
          </p>
          <a class="form-help-link" href="#contact">Hubungi Helpdesk PPDB -&gt;</a>
          <span class="form-help-face"><CircleHelp :size="22" /></span>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import {
  BadgeCheck,
  ChevronDown,
  CircleHelp,
  CloudUpload,
  Search,
  ShieldCheck,
  UserRound
} from 'lucide-vue-next';
import { applyPpdb, checkPpdbStatus, getMajors } from '../../../api/endpoints';

const emit = defineEmits(['submit-pendaftaran']);

const majorOptions = ref([
  'Pengembangan Perangkat Lunak & Gim (PPLG)',
  'Manajemen Perkantoran & Layanan Bisnis (MPLB)',
  'Teknik Jaringan Komputer & Telekomunikasi (TJKT)',
  'Desain Komunikasi Visual (DKV)',
  'Teknik Kendaraan Ringan (TKR)'
]);

const form = reactive({
  nama: '',
  nisn: '',
  email: '',
  phone: '',
  jurusan: '',
  alamat: ''
});

const fileInput = ref(null);
const fileObject = ref(null);
const fileName = ref('');
const isSubmitting = ref(false);
const submitMessage = ref('');
const submitMessageType = ref('success');

const searchNo = ref('');
const isSearching = ref(false);
const searchResult = ref(null);
const searchError = ref('');

const statusList = ref([
  {
    label: 'Diproses',
    status: 'WAITING',
    icon: UserRound,
    iconBg: '#f3f4f6',
    iconColor: '#6b7280',
    badgeBg: '#eef2ff',
    badgeColor: '#4b5563'
  },
  {
    label: 'Verifikasi',
    status: 'PROGRESS',
    icon: ShieldCheck,
    iconBg: '#fde7e7',
    iconColor: '#df6f34',
    badgeBg: '#fee2e2',
    badgeColor: '#b45309'
  },
  {
    label: 'Diterima',
    status: 'ACCEPTED',
    icon: BadgeCheck,
    iconBg: '#dbeafe',
    iconColor: '#1d4ed8',
    badgeBg: '#dbeafe',
    badgeColor: '#1d4ed8'
  }
]);

const resultBadgeClass = computed(() => {
  const s = (searchResult.value?.status || '').toLowerCase();
  if (s === 'diterima' || s === 'approved') return 'badge-success';
  if (s === 'ditolak' || s === 'rejected') return 'badge-danger';
  return 'badge-warning';
});

const triggerUpload = () => {
  fileInput.value?.click();
};

const handleFileChange = (event) => {
  const file = event.target.files?.[0];
  if (file) {
    if (file.size > 2 * 1024 * 1024) {
      alert('Ukuran file maksimal 2MB');
      event.target.value = '';
      return;
    }
    fileObject.value = file;
    fileName.value = file.name;
  } else {
    fileObject.value = null;
    fileName.value = '';
  }
};

const handleSubmit = async () => {
  isSubmitting.value = true;
  submitMessage.value = '';
  try {
    const formData = new FormData();
    formData.append('nama', form.nama);
    formData.append('nisn', form.nisn);
    if (form.email) formData.append('email', form.email);
    if (form.phone) formData.append('phone', form.phone);
    formData.append('program', form.jurusan);
    formData.append('alamat', form.alamat);
    if (fileObject.value) {
      formData.append('berkas', fileObject.value);
    }

    const res = await applyPpdb(formData);
    const data = res.data;
    const noPendaftaran = data.no_pendaftaran || data.data?.no_pendaftaran;
    submitMessage.value = data.message || `Pendaftaran berhasil! No. Pendaftaran Anda: ${noPendaftaran}`;
    submitMessageType.value = 'success';
    emit('submit-pendaftaran', { ...form, no_pendaftaran: noPendaftaran, file: fileName.value });

    // Reset form
    form.nama = '';
    form.nisn = '';
    form.email = '';
    form.phone = '';
    form.jurusan = '';
    form.alamat = '';
    fileObject.value = null;
    fileName.value = '';
    if (fileInput.value) fileInput.value.value = '';
  } catch (err) {
    const validationErrors = Object.values(err.response?.data?.errors || {}).flat().join(' ');
    submitMessage.value = validationErrors || err.response?.data?.message || err.message || 'Gagal mengirim pendaftaran.';
    submitMessageType.value = 'error';
  } finally {
    isSubmitting.value = false;
  }
};

const handleSearchStatus = async () => {
  if (!searchNo.value.trim()) return;
  isSearching.value = true;
  searchError.value = '';
  searchResult.value = null;
  try {
    const res = await checkPpdbStatus(encodeURIComponent(searchNo.value.trim()));
    searchResult.value = res.data?.data || null;
    if (!searchResult.value) {
      searchError.value = 'Data pendaftaran tidak ditemukan.';
    }
  } catch (err) {
    searchError.value = err.response?.data?.message || 'Nomor pendaftaran atau NISN tidak ditemukan.';
  } finally {
    isSearching.value = false;
  }
};

onMounted(async () => {
  try {
    const res = await getMajors();
    const list = res.data?.data || [];
    if (list.length > 0) {
      majorOptions.value = list.map(m => m.name || m.nama);
    }
  } catch (e) {
    // keep default fallback majors
  }

  const hash = window.location.hash;
  if (hash === '#pendaftaran' || hash === '#formulir') {
    setTimeout(() => {
      namaInput.value?.focus();
    }, 400);
  }
});
</script>

<style lang="scss" scoped>
.form-section {
  position: relative;
  overflow: hidden;
  background: linear-gradient(180deg, #f7fafc 0%, #eef7ff 100%);
  padding: 5rem 0 6rem;
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
  gap: 2rem;
}

@media (min-width: 768px) {
  .form-inner {
    grid-template-columns: 1.08fr 0.92fr;
    gap: 2.5rem;
    align-items: start;
  }
}

.form-card-main {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 1.8rem;
  padding: 2rem;
  border: 1px solid rgba(148, 163, 184, 0.14);
  box-shadow: 0 18px 42px rgba(15, 23, 42, 0.08);
}

.form-main-title {
  margin: 0 0 1.6rem;
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-size: clamp(1.8rem, 2vw, 2.4rem);
  font-weight: 800;
  color: #0f172a;
}

.form-form {
  display: flex;
  flex-direction: column;
  gap: 1.15rem;
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

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.55rem;
}

.form-group span {
  font-size: 0.72rem;
  color: #3a4a65;
  font-weight: 800;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  border: 1px solid #dfe7f2;
  border-radius: 0.9rem;
  background: #f8fafc;
  padding: 0.9rem 1rem;
  color: #0f172a;
  font-size: 0.96rem;
  outline: none;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.form-group input::placeholder,
.form-group textarea::placeholder {
  color: #94a3b8;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  border-color: rgba(4, 45, 134, 0.5);
  box-shadow: 0 0 0 4px rgba(30, 64, 175, 0.08);
  background: #ffffff;
}

.select-wrap {
  position: relative;
}

.select-wrap select {
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  padding-right: 2.8rem;
}

.select-icon {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: #475569;
  pointer-events: none;
}

.form-upload {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 0.75rem;
  min-height: 150px;
  padding: 1.5rem 1rem;
  border: 2px dashed #cbd5e1;
  border-radius: 1rem;
  background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%);
  color: #64748b;
  text-align: center;
  cursor: pointer;
}

.form-upload-icon {
  width: 2rem;
  height: 2rem;
  color: #64748b;
}

.form-upload-hint {
  color: #64748b;
  font-size: 0.72rem;
  font-style: italic;
  margin-top: 0.25rem;
}

.form-file-name {
  color: #042d86;
  font-weight: 700;
}

.file-input {
  display: none;
}

.form-submit {
  width: 100%;
  border: none;
  border-radius: 1rem;
  background: linear-gradient(135deg, #0d3ea7 0%, #072b72 100%);
  color: #ffffff;
  font-size: 1rem;
  font-weight: 800;
  padding: 1rem 1.2rem;
  cursor: pointer;
  box-shadow: 0 16px 28px rgba(13, 62, 167, 0.24);
}

.form-submit:disabled {
  opacity: 0.75;
  cursor: not-allowed;
}

.form-message {
  margin-top: 0.75rem;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  font-size: 0.875rem;
}

.form-message.success {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.form-message.error {
  background: #fef2f2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.form-side {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-status-card {
  background: #39B1D1;
  border-radius: 1.8rem;
  padding: 1.8rem 1.4rem;
  box-shadow: 0 18px 36px rgba(15, 23, 42, 0.12);
  border: 1px solid rgba(148, 163, 184, 0.12);
}

.form-status-title {
  margin: 0 0 1.1rem;
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-size: clamp(1.3rem, 2vw, 1.75rem);
  font-weight: 800;
  color: #102b69;
}

.form-search {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  padding: 0.45rem 0.5rem 0.45rem 0.9rem;
  background: rgba(255, 255, 255, 0.76);
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 1rem;
  box-shadow: inset 0 1px 2px rgba(15, 23, 42, 0.04);
}

.form-search input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  color: #0f172a;
  font-size: 0.95rem;
  padding: 0.7rem 0.2rem;
}

.form-search input::placeholder {
  color: #64748b;
}

.form-search-btn {
  width: 2.9rem;
  height: 2.9rem;
  display: grid;
  place-items: center;
  border: none;
  border-radius: 50%;
  background: linear-gradient(135deg, #0c3ea5 0%, #082b70 100%);
  color: #ffffff;
  cursor: pointer;
}

.search-result-box {
  margin-top: 1rem;
  background: #ffffff;
  border-radius: 1.2rem;
  padding: 1.2rem;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
  border: 1px solid rgba(148, 163, 184, 0.2);
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.8rem;
  padding-bottom: 0.6rem;
  border-bottom: 1px solid #f1f5f9;
  font-size: 1.05rem;
  color: #0f172a;
}

.result-badge {
  padding: 0.3rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
}

.badge-success {
  background: #dcfce7;
  color: #166534;
}

.badge-warning {
  background: #fef3c7;
  color: #b45309;
}

.badge-danger {
  background: #fee2e2;
  color: #991b1b;
}

.result-details p {
  margin: 0.35rem 0;
  font-size: 0.88rem;
  color: #334155;
  display: flex;
  justify-content: space-between;
}

.result-details p span {
  color: #64748b;
  font-weight: 500;
}

.result-details code {
  background: #f1f5f9;
  padding: 0.15rem 0.4rem;
  border-radius: 4px;
  font-weight: 600;
  color: #042d86;
}

.result-note {
  margin-top: 0.5rem !important;
  padding-top: 0.5rem;
  border-top: 1px dashed #e2e8f0;
  font-style: italic;
}

.search-error-msg {
  margin-top: 0.8rem;
  padding: 0.75rem 1rem;
  background: #fee2e2;
  color: #991b1b;
  border-radius: 0.8rem;
  font-size: 0.85rem;
  font-weight: 500;
}

.form-status-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-top: 1rem;
}

.form-status-item {
  background: rgba(255, 255, 255, 0.18);
  border: 1px solid rgba(148, 163, 184, 0.1);
  border-radius: 1rem;
  padding: 0.7rem 0.8rem;
}

.form-status-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 0.75rem;
}

.form-status-main {
  display: flex;
  align-items: center;
  gap: 0.7rem;
}

.form-status-icon {
  width: 2rem;
  height: 2rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.75rem;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.5);
}

.form-status-label {
  color: #0f172a;
  font-size: 0.82rem;
  font-weight: 700;
}

.form-status-badge {
  white-space: nowrap;
  border-radius: 9999px;
  padding: 0.38rem 0.7rem;
  font-size: 0.62rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.form-help-card {
  position: relative;
  overflow: hidden;
  background: rgba(243, 244, 246, 0.84);
  border-radius: 1.6rem;
  border: 1px solid rgba(148, 163, 184, 0.12);
  padding: 1.6rem 1.4rem;
  box-shadow: 0 18px 32px rgba(15, 23, 42, 0.04);
  margin-top: -0.3rem;
}

.form-help-card::after {
  content: '';
  position: absolute;
  right: -1rem;
  bottom: -1rem;
  width: 6rem;
  height: 6rem;
  border-radius: 50%;
  background: rgba(59, 130, 246, 0.07);
}

.form-help-title {
  margin: 0 0 0.7rem;
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-size: 1.25rem;
  font-weight: 800;
  color: #0f172a;
}

.form-help-text {
  margin: 0;
  color: #475569;
  font-size: 0.95rem;
  line-height: 1.7;
}

.form-help-link {
  display: inline-flex;
  margin-top: 1rem;
  color: #0a2c7a;
  text-decoration: none;
  font-weight: 800;
  font-size: 0.95rem;
}

.form-help-face {
  position: absolute;
  right: 1rem;
  bottom: 1rem;
  display: grid;
  place-items: center;
  width: 2.8rem;
  height: 2.8rem;
  border-radius: 50%;
  background: rgba(59, 130, 246, 0.08);
  color: #0f2c7c;
}

@media (max-width: 767px) {
  .form-section {
    padding-top: 4rem;
    padding-bottom: 5rem;
  }

  .form-card-main,
  .form-status-card,
  .form-help-card {
    border-radius: 1.3rem;
  }

  .form-status-row {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>

