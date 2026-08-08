<template>
  <section class="apply-section" id="pendaftaran">
    <div class="container section-block apply-block">
      <div class="apply-copy">
        <span class="section-label">Siap Melangkah?</span>
        <h2>Daftar Sekarang.</h2>
        <p>
          Lengkapi formulir pendaftaran karir Anda. Tim BKK kami akan melakukan verifikasi dan
          mencocokkan profil Anda dengan mitra industri terbaik.
        </p>
        <div class="check-list">
          <div v-for="point in registrationPoints" :key="point" class="check-item">
            <span>✓</span>
            <p>{{ point }}</p>
          </div>
        </div>
      </div>

      <div class="form-card">
        <div v-if="successMessage" style="padding: 1rem; background: #e6f4ea; color: #137333; border-radius: 8px; margin-bottom: 1rem; font-weight: 500;">
          ✓ {{ successMessage }}
        </div>
        <div v-if="errorMessage" style="padding: 1rem; background: #fce8e6; color: #c5221f; border-radius: 8px; margin-bottom: 1rem; font-weight: 500;">
          ⚠ {{ errorMessage }}
        </div>
        <form @submit.prevent="submitRegistration">
          <label>
            <span>Nama Lengkap</span>
            <input v-model="form.name" type="text" placeholder="Nama Lengkap" required />
          </label>
          <label>
            <span>Email Aktif</span>
            <input v-model="form.email" type="email" placeholder="Email Aktif" required />
          </label>
          <div class="form-row">
            <label>
              <span>NISN</span>
              <input v-model="form.nisn" type="text" placeholder="NISN" required />
            </label>
            <label>
              <span>Pilih Jurusan</span>
              <select v-model="form.program">
                <option value="Teknologi Informatika">Teknologi Informatika</option>
                <option value="Teknik Otomotif">Teknik Otomotif</option>
                <option value="Bisnis dan Manajemen">Bisnis dan Manajemen</option>
              </select>
            </label>
          </div>
          <label class="upload-box" @click.prevent="triggerUpload">
            <span>Klik atau seret CV / Portofolio</span>
            <small>PDF / JPG / PNG maksimal 5 MB</small>
            <input
              ref="fileInput"
              type="file"
              accept=".pdf,.jpg,.jpeg,.png"
              class="file-input"
              @change="handleFileChange"
            />
          </label>
          <p v-if="fileName" class="file-summary">File terpilih: {{ fileName }}</p>
          <button type="submit" class="button-primary" :disabled="isSubmitting" style="width: 100%;">
            {{ isSubmitting ? 'Mengirim Data...' : 'Kirim Lamaran' }}
          </button>
        </form>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue';

const props = defineProps({
  registrationPoints: {
    type: Array,
    default: () => []
  },
  form: {
    type: Object,
    required: true
  },
  submitRegistration: {
    type: Function,
    required: true
  },
  isSubmitting: {
    type: Boolean,
    default: false
  },
  successMessage: {
    type: String,
    default: ''
  },
  errorMessage: {
    type: String,
    default: ''
  }
});

const fileInput = ref(null);
const fileName = ref('');

const triggerUpload = () => {
  fileInput.value?.click();
};

const handleFileChange = (event) => {
  const file = event.target.files?.[0];
  fileName.value = file ? file.name : '';
};
</script>

<style scoped>
.file-input {
  display: none;
}

.file-summary {
  margin: 0 0 1rem;
  color: #374151;
  font-size: 0.95rem;
}
</style>
