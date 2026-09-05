<template>
  <aside class="lowongan-lainnya">
    <div class="lowongan-lainnya-header">
      <span class="lowongan-lainnya-line"></span>
      <h3 class="lowongan-lainnya-title">Lowongan Lainnya</h3>
    </div>
    <div class="lowongan-lainnya-list">
      <router-link
        v-for="item in items"
        :key="item.slug || item.id"
        :to="`/lowongan/${item.slug}`"
        class="lowongan-lainnya-card"
      >
        <div class="lowongan-lainnya-top">
          <div class="lowongan-lainnya-icon" :style="{ background: iconBg(item.kategori) }">
            <component :is="iconComponent(item.icon)" :size="18" :color="iconColor(item.kategori)" />
          </div>
          <span v-if="item.status === 'Baru' || item.is_featured" class="lowongan-lainnya-badge">Baru</span>
        </div>
        <h4 class="lowongan-lainnya-name">{{ item.posisi }}</h4>
        <p class="lowongan-lainnya-company">{{ item.perusahaan }}</p>
        <div class="lowongan-lainnya-meta">
          <span>{{ item.lokasi || 'Probolinggo' }}</span>
          <span>{{ item.tipePekerjaanLabel || item.tipePekerjaan }}</span>
        </div>
      </router-link>
    </div>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { CodeXml, Car, Palette, Landmark } from 'lucide-vue-next'
import { getAllLowongan } from '@/data/lowongan'

const props = defineProps({
  currentSlug: {
    type: String,
    default: ''
  },
  allJobs: {
    type: Array,
    default: () => []
  }
})

const items = computed(() => {
  const all = props.allJobs && props.allJobs.length ? props.allJobs : getAllLowongan()
  const current = all.find(item => item.slug === props.currentSlug || String(item.id) === props.currentSlug)
  if (!current) return all.slice(0, 4)
  const others = all.filter(item => item.slug !== current.slug && String(item.id) !== String(current.id))
  return others.slice(0, 4)
})

function iconComponent(name) {
  const map = { CodeXml, Car, Palette, Landmark }
  return map[name] || Landmark
}

function iconColor(kategori) {
  const map = {
    'it-software': '#1e3a8a',
    'akuntansi-keuangan': '#047857',
    'teknik-otomotif': '#b45309',
    'desain-grafis': '#7e22ce'
  }
  return map[kategori] || '#334155'
}

function iconBg(kategori) {
  const map = {
    'it-software': '#dbeafe',
    'akuntansi-keuangan': '#d1fae5',
    'teknik-otomotif': '#fef3c7',
    'desain-grafis': '#f3e8ff'
  }
  return map[kategori] || '#f1f5f9'
}
</script>

<style lang="scss" scoped>
.lowongan-lainnya {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.lowongan-lainnya-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.5rem;
}

.lowongan-lainnya-line {
  width: 0.25rem;
  height: 1.5rem;
  border-radius: 9999px;
  background: #1e3a8a;
  flex-shrink: 0;
}

.lowongan-lainnya-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.lowongan-lainnya-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.lowongan-lainnya-card {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  text-decoration: none;
  color: inherit;
  padding: 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  transition: all 0.2s ease;

  &:hover {
    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
    border-color: #cbd5e1;
    transform: translateY(-2px);
  }
}

.lowongan-lainnya-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.lowongan-lainnya-icon {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.75rem;
  display: grid;
  place-items: center;
}

.lowongan-lainnya-badge {
  padding: 0.3rem 0.75rem;
  border-radius: 9999px;
  background: #fef3c7;
  color: #92400e;
  font-size: 0.7rem;
  font-weight: 700;
}

.lowongan-lainnya-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 0.95rem;
  color: #0f172a;
  margin: 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.lowongan-lainnya-company {
  font-size: 0.85rem;
  color: #042d86;
  margin: 0;
  font-weight: 600;
}

.lowongan-lainnya-meta {
  display: flex;
  gap: 0.75rem;
  font-size: 0.8rem;
  color: #64748b;
}
</style>
