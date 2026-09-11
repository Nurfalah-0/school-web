<template>
  <aside class="prestasi-lainnya">
    <div class="prestasi-lainnya-header">
      <span class="prestasi-lainnya-line"></span>
      <h3 class="prestasi-lainnya-title">Prestasi Lainnya</h3>
    </div>
    <div class="prestasi-lainnya-list">
      <router-link
        v-for="item in items"
        :key="item.slug"
        :to="`/prestasi/${item.slug}`"
        class="prestasi-lainnya-card"
      >
        <div class="prestasi-lainnya-img-wrap">
          <img :src="item.gambar || ''" :alt="item.judul" class="prestasi-lainnya-img" loading="lazy" />
          <div v-if="!item.gambar" class="prestasi-lainnya-placeholder">
            <Medal :size="24" color="#6366f1" />
          </div>
          <span class="prestasi-lainnya-badge" :style="{ background: badgeBg(item.kategoriBadgeColor), color: badgeText(item.kategoriBadgeColor) }">
            {{ item.kategoriLabel }}
          </span>
        </div>
        <div class="prestasi-lainnya-body">
          <h4 class="prestasi-lainnya-name">{{ item.judul }}</h4>
          <span class="prestasi-lainnya-date">{{ item.nama }} • {{ item.tahun }}</span>
        </div>
      </router-link>
    </div>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { Medal } from 'lucide-vue-next'
import { kategoriBadgeColors } from '@/data/prestasi'

const props = defineProps({
  items: {
    type: Array,
    default: () => []
  }
})

const items = computed(() => props.items)

function badgeBg(colorKey) {
  return kategoriBadgeColors[colorKey]?.bg || '#eef2ff'
}

function badgeText(colorKey) {
  return kategoriBadgeColors[colorKey]?.text || '#334155'
}
</script>

<style lang="scss" scoped>
.prestasi-lainnya {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.prestasi-lainnya-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.5rem;
}

.prestasi-lainnya-line {
  width: 0.25rem;
  height: 1.5rem;
  border-radius: 9999px;
  background: #1e3a8a;
  flex-shrink: 0;
}

.prestasi-lainnya-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.prestasi-lainnya-list {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.prestasi-lainnya-card {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  text-decoration: none;
  color: inherit;
}

.prestasi-lainnya-img-wrap {
  position: relative;
  aspect-ratio: 16 / 10;
  border-radius: 0.75rem;
  overflow: hidden;
}

.prestasi-lainnya-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.prestasi-lainnya-placeholder {
  position: absolute;
  inset: 0;
  background: #eef2ff;
  display: grid;
  place-items: center;
}

.prestasi-lainnya-badge {
  position: absolute;
  top: 0.6rem;
  left: 0.6rem;
  padding: 0.3rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.04em;
}

.prestasi-lainnya-body {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.prestasi-lainnya-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 0.95rem;
  color: #0f172a;
  line-height: 1.4;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.prestasi-lainnya-date {
  font-size: 0.8rem;
  color: #64748b;
}
</style>
