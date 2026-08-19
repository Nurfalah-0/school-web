<template>
  <section class="keunggulan-section">
    <div class="keunggulan-inner">
      <h2 class="keunggulan-title">Keunggulan Program</h2>
      <div class="keunggulan-grid">
        <div v-for="(item, idx) in keunggulan" :key="idx" class="keunggulan-card">
          <div class="keunggulan-icon" :style="{ background: iconBg(idx) }">
            <component :is="iconMap[item.icon]" :size="24" :color="iconColor(idx)" />
          </div>
          <h3 class="keunggulan-name">{{ item.judul }}</h3>
          <p class="keunggulan-text">{{ item.deskripsi }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { Rocket, Handshake, Award } from 'lucide-vue-next'

const props = defineProps({
  keunggulan: {
    type: Array,
    required: true
  }
})

const iconMap = {
  Rocket,
  Handshake,
  Award
}

function iconBg(idx) {
  if (idx === 0) return '#1e3a5f'
  if (idx === 1) return '#ccfbf1'
  return '#fef3c7'
}

function iconColor(idx) {
  if (idx === 0) return '#ffffff'
  if (idx === 1) return '#0f766e'
  return '#8b6914'
}
</script>

<style lang="scss" scoped>
.keunggulan-section {
  background: transparent;
  padding: 0;
}

.keunggulan-inner {
  width: 100%;
}

.keunggulan-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.5rem;
  color: #1e3a5f;
  margin: 0 0 1.25rem;
}

.keunggulan-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@media (min-width: 768px) {
  .keunggulan-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 1rem;
  }
}

.keunggulan-card {
  background: #ffffff;
  border-radius: 1.25rem;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.keunggulan-icon {
  width: 3rem;
  height: 3rem;
  display: grid;
  place-items: center;
  border-radius: 9999px;
  flex-shrink: 0;
}

.keunggulan-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.125rem;
  color: #1e293b;
  margin: 0.5rem 0 0;
}

.keunggulan-text {
  font-size: 0.875rem;
  color: #64748b;
  line-height: 1.6;
  margin: 0;
}
</style>
