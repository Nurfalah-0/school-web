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
          <label class="upload-box">
            <span>Klik atau seret CV / Portofolio</span>
            <small>PDF / JPG / PNG maksimal 5 MB</small>
          </label>
          <button type="submit" class="button-primary">Kirim Lamaran</button>
        </form>
      </div>
    </div>
  </section>
</template>

<script setup>
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
  }
});
</script>
