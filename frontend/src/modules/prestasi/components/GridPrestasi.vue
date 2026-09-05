<template>
  <section class="grid-section">
    <div class="grid-inner">
      <div v-if="items.length === 0" class="grid-empty">
        <p>Belum ada prestasi di kategori ini.</p>
      </div>
      <div v-else class="prestasi-grid">
        <div v-for="item in items" :key="item.slug" class="prestasi-card">
          <div class="prestasi-card-img-wrap">
            <img v-if="item.gambar" :src="item.gambar" :alt="item.judul" class="prestasi-card-img" loading="lazy" />
          <div v-else class="prestasi-card-img prestasi-placeholder">
            <component :is="iconMap[item.kategori] || Medal" :size="48" color="#6366f1" />
          </div>
          </div>
          <div class="prestasi-card-body">
            <span class="prestasi-card-badge" :style="{ background: badgeBg(item.kategoriBadgeColor), color: badgeText(item.kategoriBadgeColor) }">
              {{ item.kategoriLabel }}
            </span>
            <h3 class="prestasi-card-title">{{ item.judul }}</h3>
            <p class="prestasi-card-meta">{{ item.nama }} • {{ item.tahun }}</p>
            <div class="prestasi-card-divider"></div>
            <router-link :to="`/prestasi/${item.slug}`" class="prestasi-card-link">Detail ></router-link>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { BookOpen, Palette, Medal, Award } from 'lucide-vue-next'
import { kategoriBadgeColors } from '@/data/prestasi'

const props = defineProps({
  items: {
    type: Array,
    required: true
  }
})

const iconMap = {
  akademik: BookOpen,
  'non-akademik': Medal,
  'seni-budaya': Palette,
  olahraga: Award
}

function badgeBg(colorKey) {
  return kategoriBadgeColors[colorKey]?.bg || '#eef2ff'
}

function badgeText(colorKey) {
  return kategoriBadgeColors[colorKey]?.text || '#334155'
}
</script>

<style lang="scss" scoped>
.grid-section {
  background: #ffffff;
  padding: 2.5rem 0;
}

.grid-inner {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1.5rem;
}

.grid-empty {
  text-align: center;
  padding: 4rem 1rem;
  color: #64748b;
}

.prestasi-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .prestasi-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .prestasi-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }
}

.prestasi-card {
  border: 1px solid #e2e8f0;
  border-radius: 1.25rem;
  overflow: hidden;
  background: #ffffff;
  display: flex;
  flex-direction: column;
  transition: box-shadow 0.2s ease;
}

.prestasi-card:hover {
  box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
}

.prestasi-card-img-wrap {
  aspect-ratio: 4 / 3;
  overflow: hidden;
}

.prestasi-card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.prestasi-placeholder {
  background: #eef2ff;
  display: grid;
  place-items: center;
}

.prestasi-card-body {
  padding: 1.25rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.prestasi-card-badge {
  display: inline-flex;
  padding: 0.35rem 0.9rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.02em;
  width: fit-content;
}

.prestasi-card-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.1rem;
  color: #0f172a;
  line-height: 1.4;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.prestasi-card-meta {
  font-size: 0.9rem;
  color: #64748b;
  margin: 0;
}

.prestasi-card-divider {
  height: 1px;
  background: #f1f5f9;
  margin: 0.5rem 0;
}

.prestasi-card-link {
  font-size: 0.9rem;
  font-weight: 700;
  color: #1e3a8a;
  text-decoration: none;
  margin-top: 0.25rem;
}

.prestasi-card-link:hover {
  text-decoration: underline;
}
</style>
