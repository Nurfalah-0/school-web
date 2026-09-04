<template>
  <section class="mengapa-section">
    <div class="mengapa-inner">
      <div class="mengapa-header">
        <h2 class="mengapa-title">{{ title }}</h2>
        <p class="mengapa-subtitle">{{ subtitle }}</p>
      </div>
      <div class="mengapa-grid">
        <div v-for="item in cards" :key="item.title" class="mengapa-card">
          <div class="mengapa-icon" :style="{ background: item.iconBg, color: item.iconColor }">
            <span v-html="item.icon"></span>
          </div>
          <h3 class="mengapa-card-title">{{ item.title }}</h3>
          <p class="mengapa-card-text">{{ item.text }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: 'Mengapa Memilih Kami?'
  },
  subtitle: {
    type: String,
    default: 'Kami menyediakan ekosistem pendidikan yang didesain untuk mencetak tenaga kerja profesional yang adaptif terhadap perubahan industri.'
  },
  cards: {
    type: Array,
    default: () => [
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>',
        title: 'Akreditasi A',
        text: 'Standar kualitas pendidikan nasional tertinggi untuk menjamin kompetensi lulusan.',
        iconBg: '#f3e8ff',
        iconColor: '#7e22ce'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>',
        title: 'Mitra Industri',
        text: 'Bekerja sama dengan lebih dari 50 perusahaan ternama untuk program PKL dan penempatan kerja.',
        iconBg: '#fef3c7',
        iconColor: '#b45309'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c0 2 6 3 6 3s6-1 6-3v-5"/></svg>',
        title: 'Beasiswa Penuh',
        text: 'Tersedia berbagai skema beasiswa bagi siswa berprestasi dan kurang mampu.',
        iconBg: '#dbeafe',
        iconColor: '#1e40af'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
.mengapa-section {
  background: #f0fdfa;
  padding: 5rem 0;
}

.mengapa-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.mengapa-header {
  text-align: center;
  margin-bottom: 3rem;
}

.mengapa-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 0.75rem;
}

.mengapa-subtitle {
  color: #475569;
  font-size: 1rem;
  margin: 0;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.7;
}

.mengapa-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .mengapa-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }
}

.mengapa-card {
  background: #ffffff;
  border-radius: 1.5rem;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 1rem;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
  border: 1px solid rgba(15, 23, 42, 0.04);
}

.mengapa-icon {
  width: 4rem;
  height: 4rem;
  border-radius: 1rem;
  display: grid;
  place-items: center;
}

.mengapa-icon span {
  display: grid;
  place-items: center;
}

.mengapa-card-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.mengapa-card-text {
  font-size: 0.95rem;
  color: #475569;
  line-height: 1.7;
  margin: 0;
}
</style>
