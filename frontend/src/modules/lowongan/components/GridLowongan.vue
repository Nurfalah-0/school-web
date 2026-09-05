<template>
  <section class="grid-section">
    <div class="grid-inner">
      <div v-if="items.length === 0" class="grid-empty">
        <p>Tidak ada lowongan yang sesuai dengan filter.</p>
      </div>
      <div v-else class="lowongan-grid">
        <article v-for="item in items" :key="item.slug" class="lowongan-card">
          <div class="lowongan-top">
            <div class="lowongan-icon" :style="{ background: iconBg(item.kategori) }">
              <component :is="iconComponent(item.icon)" :size="22" :color="iconColor(item.kategori)" />
            </div>
            <span v-if="item.status === 'Baru'" class="lowongan-badge">Baru</span>
          </div>
          <h3 class="lowongan-name">{{ item.posisi }}</h3>
          <p class="lowongan-company">{{ item.perusahaan }}</p>
          <div class="lowongan-tags">
            <span class="lowongan-tag">
              <MapPin :size="14" color="#64748b" />
              {{ item.lokasi }}
            </span>
            <span class="lowongan-tag">
              <Briefcase :size="14" color="#64748b" />
              {{ item.tipePekerjaanLabel }}
            </span>
          </div>
          <div class="lowongan-divider"></div>
          <div class="lowongan-footer">
            <div class="lowongan-deadline">
              <span class="lowongan-deadline-label">Deadline</span>
              <span class="lowongan-deadline-value">{{ item.deadlineLabel }}</span>
            </div>
            <router-link :to="`/lowongan/${item.slug}`" class="lowongan-btn">
              {{ item.ctaLabel }}
              <ArrowRight :size="14" color="#ffffff" />
            </router-link>
          </div>
        </article>
      </div>

      <LoadMoreButton
        v-if="showMore"
        @click="$emit('load-more')"
      />
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { MapPin, Briefcase, ArrowRight, CodeXml, Car, Palette, Landmark } from 'lucide-vue-next'
import { kategoriList } from '@/data/lowongan'

const props = defineProps({
  items: {
    type: Array,
    required: true
  }
})

defineEmits(['load-more'])

const showMore = computed(() => props.items.length > 0)

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
.grid-section {
  background: #ffffff;
  padding: 1.5rem 0;
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

.lowongan-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .lowongan-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

.lowongan-card {
  border: 1px solid #e2e8f0;
  border-radius: 1.25rem;
  padding: 1.5rem;
  background: #ffffff;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
  transition: box-shadow 0.2s ease;
}

.lowongan-card:hover {
  box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
}

.lowongan-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.lowongan-icon {
  width: 3rem;
  height: 3rem;
  border-radius: 0.875rem;
  display: grid;
  place-items: center;
}

.lowongan-badge {
  padding: 0.35rem 0.85rem;
  border-radius: 9999px;
  background: #fef3c7;
  color: #92400e;
  font-size: 0.75rem;
  font-weight: 700;
}

.lowongan-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.15rem;
  color: #0f172a;
  margin: 0;
  line-height: 1.4;
}

.lowongan-company {
  color: #042d86;
  font-size: 0.95rem;
  margin: 0;
  font-weight: 600;
}

.lowongan-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 0.25rem;
}

.lowongan-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.4rem 0.85rem;
  border-radius: 9999px;
  background: #eef2ff;
  color: #334155;
  font-size: 0.85rem;
  font-weight: 600;
}

.lowongan-divider {
  height: 1px;
  background: #f1f5f9;
  margin: 0.75rem 0;
}

.lowongan-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
  margin-top: auto;
}

.lowongan-deadline {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.lowongan-deadline-label {
  font-size: 0.75rem;
  color: #94a3b8;
}

.lowongan-deadline-value {
  font-size: 0.9rem;
  font-weight: 700;
  color: #334155;
}

.lowongan-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.65rem 1.25rem;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.85rem;
  text-decoration: none;
  white-space: nowrap;
  transition: background 0.2s ease;
}

.lowongan-btn:hover {
  background: #16264d;
}
</style>
