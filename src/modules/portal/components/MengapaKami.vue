<template>
  <section class="mengapa-kami">
    <div class="mengapa-kami-inner">
      <h2 class="mengapa-kami-title">{{ title }}</h2>
      <div class="mengapa-kami-grid">
        <div v-for="card in cards" :key="card.title" class="mengapa-kami-card">
          <div class="mengapa-kami-icon" :style="{ background: card.iconBg, color: card.iconColor }">
            <Award v-if="card.icon === 'award'" :size="24" color="#ffffff" />
            <Bot v-else-if="card.icon === 'bot'" :size="24" color="#ffffff" />
            <Handshake v-else-if="card.icon === 'handshake'" :size="24" color="#ffffff" />
            <Heart v-else-if="card.icon === 'heart'" :size="24" color="#ffffff" />
          </div>
          <h3 class="mengapa-kami-card-title">{{ card.title }}</h3>
          <p class="mengapa-kami-card-text">{{ card.text }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { Award, Bot, Handshake, Heart } from 'lucide-vue-next';

defineProps({
  title: {
    type: String,
    default: 'Mengapa SMK Nurul Jadid?'
  },
  cards: {
    type: Array,
    default: () => [
      {
        icon: 'award',
        title: 'Akreditasi A',
        text: 'Standar mutu pendidikan terjamin dengan pengakuan nasional tertinggi untuk semua program keahlian.',
        iconBg: '#7e22ce',
        iconColor: '#ffffff'
      },
      {
        icon: 'bot',
        title: 'Teaching Factory',
        text: 'Belajar langsung dengan simulasi industri nyata di dalam lingkungan sekolah yang modern.',
        iconBg: '#0f766e',
        iconColor: '#ffffff'
      },
      {
        icon: 'handshake',
        title: 'Mitra Industri',
        text: 'Jejaring luas dengan perusahaan nasional dan internasional untuk penempatan magang dan kerja.',
        iconBg: '#c2410c',
        iconColor: '#ffffff'
      },
      {
        icon: 'heart',
        title: 'Karakter Santri',
        text: 'Membentuk pribadi yang jujur, amanah, dan berakhlak mulia sebagai landasan profesionalisme.',
        iconBg: '#7e22ce',
        iconColor: '#ffffff'
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
