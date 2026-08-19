<template>
  <section class="prestasi">
    <div class="prestasi-inner">
      <div class="prestasi-header">
        <h2 class="prestasi-title">{{ title }}</h2>
        <p class="prestasi-subtitle">{{ subtitle }}</p>
      </div>

      <div class="prestasi-scroll">
        <router-link
          v-for="item in prestasi"
          :key="item.slug"
          :to="`/prestasi/${item.slug}`"
          class="prestasi-card"
        >
          <div class="prestasi-card-top">
            <span class="prestasi-icon" :style="{ background: iconBg(item.kategoriBadgeColor) }">
              <component :is="iconFor(item)" :size="20" color="#ffffff" />
            </span>
            <span class="prestasi-year">{{ item.tahun }}</span>
          </div>
          <h3 class="prestasi-name">{{ item.judul }}</h3>
          <p class="prestasi-text">{{ item.deskripsiSingkat }}</p>
        </router-link>
      </div>

      <div class="prestasi-footer">
        <router-link to="/prestasi" class="prestasi-cta">Lihat Semua</router-link>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { getAllPrestasi } from '@/data/prestasi'
import { BookOpen, Trophy, Palette, Heart } from 'lucide-vue-next'

defineProps({
  title: {
    type: String,
    default: 'Prestasi Membanggakan'
  },
  subtitle: {
    type: String,
    default: 'Siswa kami secara konsisten meraih penghargaan di tingkat regional hingga nasional.'
  }
})

const prestasi = computed(() => getAllPrestasi().slice(0, 4))

function iconBg(colorKey) {
  const colors = {
    blue: '#1e40af',
    amber: '#92400e',
    rose: '#9f1239',
    purple: '#6b21a8'
  }
  return colors[colorKey] || '#1e40af'
}

function iconFor(item) {
  if (item.kategori === 'akademik') return BookOpen
  if (item.kategori === 'olahraga') return Trophy
  if (item.kategori === 'seni-budaya') return Palette
  return Heart
}
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.prestasi {
  background: #ffffff;
  padding: 5rem 0;
}

.prestasi-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
}

.prestasi-header {
  text-align: center;
  max-width: 42rem;
  margin: 0 auto 3rem;
}

.prestasi-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 0.75rem;
}

.prestasi-subtitle {
  font-size: 1.05rem;
  color: #334155;
  line-height: 1.7;
  margin: 0;
}

.prestasi-scroll {
  display: flex;
  gap: 1.5rem;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  padding: 0.5rem 0 1rem;
  -webkit-overflow-scrolling: touch;

  &::-webkit-scrollbar {
    display: none;
  }

  scrollbar-width: none;
}

.prestasi-card {
  flex: 0 0 auto;
  width: 18rem;
  scroll-snap-align: start;
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  padding: 1.5rem;
  background: #ffffff;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  text-decoration: none;
  color: inherit;
  transition: box-shadow 0.2s ease;
}

.prestasi-card:hover {
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
}

.prestasi-card-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.prestasi-icon {
  width: 3rem;
  height: 3rem;
  display: grid;
  place-items: center;
  border-radius: 0.75rem;
  color: #ffffff;
}

.prestasi-year {
  font-size: 0.8rem;
  color: #64748b;
  font-weight: 600;
}

.prestasi-name {
  font-family: $font-display;
  font-weight: 700;
  font-size: 1.15rem;
  color: #0f172a;
  margin: 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.prestasi-text {
  font-size: 0.9rem;
  color: #334155;
  line-height: 1.65;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.prestasi-footer {
  display: flex;
  justify-content: center;
  margin-top: 2.5rem;
}

.prestasi-cta {
  display: inline-flex;
  align-items: center;
  padding: 0.85rem 2rem;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  transition: background 0.2s ease;
}

.prestasi-cta:hover {
  background: #16264d;
}

@media (min-width: 768px) {
  .prestasi-scroll {
    padding-left: 0.5rem;
  }
}

@media (min-width: 1024px) {
  .prestasi-scroll {
    padding-left: 1rem;
  }
}
</style>
