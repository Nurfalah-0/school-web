<template>
  <section class="timeline-section">
    <div class="timeline-inner">
      <div class="timeline-header">
        <h2 class="timeline-title">{{ title }}</h2>
        <p class="timeline-subtitle">{{ subtitle }}</p>
      </div>
      <div class="timeline-line"></div>
      <div class="timeline-grid">
        <div v-for="item in steps" :key="item.step" class="timeline-card">
          <div class="timeline-circle">{{ item.step }}</div>
          <h3 class="timeline-name">{{ item.title }}</h3>
          <p class="timeline-text">{{ item.text }}</p>
          <span class="timeline-duration">{{ item.duration }}</span>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: 'Timeline Seleksi & Penempatan'
  },
  subtitle: {
    type: String,
    default: 'Panduan waktu untuk persiapan karirmu tahun ajaran ini.'
  },
  steps: {
    type: Array,
    default: () => [
      {
        step: '01',
        title: 'Pendaftaran',
        text: 'Pengumpulan berkas dan verifikasi data administrasi siswa.',
        duration: 'Januari - Februari'
      },
      {
        step: '02',
        title: 'Workshop & Pre-Test',
        text: 'Pembekalan soft-skills dan tes teknis awal oleh tim BKK.',
        duration: 'Maret'
      },
      {
        step: '03',
        title: 'Wawancara Industri',
        text: 'Proses seleksi langsung oleh HRD mitra perusahaan kami.',
        duration: 'April - Mei'
      },
      {
        step: '04',
        title: 'Penempatan',
        text: 'Pelepasan resmi siswa ke lokasi PKL atau penandatanganan kontrak kerja.',
        duration: 'Juni - Juli'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
.timeline-section {
  background: #1e3a8a;
  padding: 5rem 0;
  border-radius: 2.5rem 2.5rem 0 0;
  margin-top: -1px;
}

.timeline-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.timeline-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.timeline-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #ffffff;
  margin: 0 0 0.75rem;
}

.timeline-subtitle {
  color: #bfdbfe;
  font-size: 1rem;
  margin: 0;
}

.timeline-line {
  height: 1px;
  background: rgba(255, 255, 255, 0.2);
  margin-bottom: 3rem;
}

.timeline-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
}

@media (min-width: 768px) {
  .timeline-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2.5rem;
  }
}

@media (min-width: 1024px) {
  .timeline-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 2rem;
  }
}

.timeline-card {
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.timeline-circle {
  width: 3.5rem;
  height: 3.5rem;
  border-radius: 9999px;
  background: #ffffff;
  color: #1e3a8a;
  display: grid;
  place-items: center;
  font-weight: 800;
  font-size: 1.25rem;
}

.timeline-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #ffffff;
  margin: 0;
}

.timeline-text {
  color: #bfdbfe;
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0;
}

.timeline-duration {
  color: #93c5fd;
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
</style>
