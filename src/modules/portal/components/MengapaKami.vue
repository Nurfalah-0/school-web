<template>
  <section class="mengapa-kami">
    <div class="mengapa-kami-inner">
      <h2 class="mengapa-kami-title">{{ title }}</h2>
      <div class="mengapa-kami-grid">
        <div v-for="card in cards" :key="card.title" class="mengapa-kami-card">
          <div class="mengapa-kami-icon" :style="{ background: card.iconBg, color: card.iconColor }">
            <svg v-if="card.icon === 'badge'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="mengapa-kami-svg">
              <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
            </svg>
            <svg v-else-if="card.icon === 'robot'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mengapa-kami-svg">
              <rect x="3" y="11" width="18" height="10" rx="2"/>
              <circle cx="12" cy="5" r="2"/>
              <path d="M12 7v4"/>
              <line x1="8" y1="16" x2="8" y2="16"/>
              <line x1="16" y1="16" x2="16" y2="16"/>
            </svg>
            <svg v-else-if="card.icon === 'handshake'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="mengapa-kami-svg">
              <path d="M20.5 17.5L12 12l-8.5 5.5 1.5-2.5L12 9.5l7 5.5 1.5 2.5zM4 19h16v2H4z"/>
              <path d="M18 13l2.5-2.5L22 13l-1.5 1.5L18 13zM6 13l-2.5-2.5L2 13l1.5 1.5L6 13z"/>
            </svg>
            <svg v-else-if="card.icon === 'building'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="mengapa-kami-svg">
              <path d="M4 21V10l8-6 8 6v11H4z"/>
              <path d="M10 21v-6h4v6"/>
              <path d="M9 10h6"/>
              <path d="M8 6h8"/>
            </svg>
          </div>
          <h3 class="mengapa-kami-card-title">{{ card.title }}</h3>
          <p class="mengapa-kami-card-text">{{ card.text }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: 'Mengapa SMK Nurul Jadid?'
  },
  cards: {
    type: Array,
    default: () => [
      {
        icon: 'badge',
        title: 'Akreditasi A',
        text: 'Standar mutu pendidikan terjamin dengan pengakuan nasional tertinggi untuk semua program keahlian.',
        iconBg: '#f3e8ff',
        iconColor: '#7e22ce'
      },
      {
        icon: 'robot',
        title: 'Teaching Factory',
        text: 'Belajar langsung dengan simulasi industri nyata di dalam lingkungan sekolah yang modern.',
        iconBg: '#ccfbf1',
        iconColor: '#0f766e'
      },
      {
        icon: 'handshake',
        title: 'Mitra Industri',
        text: 'Jejaring luas dengan perusahaan nasional dan internasional untuk penempatan magang dan kerja.',
        iconBg: '#ffedd5',
        iconColor: '#c2410c'
      },
      {
        icon: 'building',
        title: 'Karakter Santri',
        text: 'Membentuk pribadi yang jujur, amanah, dan berakhlak mulia sebagai landasan profesionalisme.',
        iconBg: '#f3e8ff',
        iconColor: '#7e22ce'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.mengapa-kami {
  background: #f0fdfa;
  padding: 5rem 0;
}

.mengapa-kami-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
}

.mengapa-kami-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.6rem);
  color: #0f172a;
  text-align: center;
  margin: 0 0 3rem 0;
}

.mengapa-kami-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .mengapa-kami-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .mengapa-kami-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 2rem;
  }
}

.mengapa-kami-card {
  background: #ffffff;
  border-radius: 1.5rem;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
  border: 1px solid rgba(15, 23, 42, 0.04);
}

.mengapa-kami-icon {
  width: 3rem;
  height: 3rem;
  display: grid;
  place-items: center;
  border-radius: 1rem;
  flex-shrink: 0;
}

.mengapa-kami-svg {
  width: 1.5rem;
  height: 1.5rem;
}

.mengapa-kami-card-title {
  font-family: $font-display;
  font-weight: 700;
  font-size: 1.15rem;
  color: #0f172a;
  margin: 0;
}

.mengapa-kami-card-text {
  font-size: 0.95rem;
  color: #334155;
  line-height: 1.7;
  margin: 0;
}
</style>
