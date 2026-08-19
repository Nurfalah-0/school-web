<template>
  <section class="langkah-section">
    <div class="langkah-inner">
      <div class="langkah-header">
        <div>
          <h2 class="langkah-title">{{ title }}</h2>
          <p class="langkah-subtitle">{{ subtitle }}</p>
        </div>
        <a class="langkah-guide" href="#panduan">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:inline;vertical-align:middle;margin-right:0.35rem;"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          Pelajari Panduan Lengkap
        </a>
      </div>
      <div class="langkah-grid">
        <div v-for="item in steps" :key="item.step" class="langkah-card">
          <div :class="['langkah-circle', { active: item.step === '01' }]">{{ item.step }}</div>
          <h3 class="langkah-name">{{ item.title }}</h3>
          <p class="langkah-text">{{ item.text }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: 'Langkah Pendaftaran'
  },
  subtitle: {
    type: String,
    default: 'Proses pendaftaran yang mudah dan transparan. Ikuti 5 langkah sederhana untuk bergabung bersama kami.'
  },
  steps: {
    type: Array,
    default: () => [
      { step: '01', title: 'Registrasi Akun', text: 'Buat akun menggunakan email atau nomor WhatsApp aktif.' },
      { step: '02', title: 'Lengkapi Data', text: 'Unggah dokumen persyaratan dan isi formulir biodata.' },
      { step: '03', title: 'Verifikasi Dokumen', text: 'Tim panitia akan memvalidasi kelengkapan berkas Anda.' },
      { step: '04', title: 'Tes Seleksi', text: 'Ikuti tes peminatan dan wawancara secara daring/luring.' },
      { step: '05', title: 'Pengumuman', text: 'Hasil seleksi dapat dilihat melalui portal status pendaftaran.' }
    ]
  }
});
</script>

<style lang="scss" scoped>
.langkah-section {
  background: #ffffff;
  padding: 5rem 0;
}

.langkah-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.langkah-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1.5rem;
  margin-bottom: 3rem;
  flex-wrap: wrap;
}

.langkah-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 0.5rem;
}

.langkah-subtitle {
  color: #475569;
  font-size: 1rem;
  margin: 0;
}

.langkah-guide {
  display: inline-flex;
  align-items: center;
  color: #042d86;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  flex-shrink: 0;
}

.langkah-guide:hover {
  text-decoration: underline;
}

.langkah-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .langkah-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .langkah-grid {
    grid-template-columns: repeat(5, minmax(0, 1fr));
    gap: 2rem;
  }
}

.langkah-card {
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.langkah-circle {
  width: 3.5rem;
  height: 3.5rem;
  border-radius: 9999px;
  background: #ffffff;
  border: 2px solid #042d86;
  color: #042d86;
  display: grid;
  place-items: center;
  font-weight: 800;
  font-size: 1.25rem;
}

.langkah-circle.active {
  background: #042d86;
  color: #ffffff;
  border-color: #042d86;
}

.langkah-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.1rem;
  color: #0f172a;
  margin: 0;
}

.langkah-text {
  color: #475569;
  font-size: 0.9rem;
  line-height: 1.6;
  margin: 0;
}
</style>
