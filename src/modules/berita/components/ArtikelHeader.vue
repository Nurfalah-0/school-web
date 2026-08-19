<template>
  <header class="artikel-header">
    <div v-if="artikel.status === 'UTAMA'" class="artikel-badge">
      <span class="artikel-badge-dot"></span>
      UTAMA
    </div>
    <h1 class="artikel-title">{{ artikel.judul }}</h1>
    <div class="artikel-meta">
      <span class="artikel-meta-item">
        <Calendar :size="16" color="#94a3b8" />
        {{ artikel.tanggalDisplay }}
      </span>
      <span class="artikel-meta-item">
        <User :size="16" color="#94a3b8" />
        {{ artikel.penulis }}
      </span>
      <span class="artikel-meta-item artikel-meta-badge">
        <Clock :size="14" color="#64748b" />
        {{ artikel.waktuBaca }}
      </span>
    </div>
  </header>
</template>

<script setup>
import { Calendar, User, Clock } from 'lucide-vue-next'

defineProps({
  artikel: {
    type: Object,
    required: true
  }
})
</script>

<style lang="scss" scoped>
.artikel-header {
  margin-bottom: 0.75rem;
}

.artikel-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1.25rem;
  border-radius: 9999px;
  background: #fce8c9;
  color: #92400e;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  margin-bottom: 1rem;
}

.artikel-badge-dot {
  width: 6px;
  height: 6px;
  border-radius: 9999px;
  background: #d97706;
}

.artikel-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.5rem, 3vw, 2.25rem);
  color: #0f172a;
  line-height: 1.2;
  margin: 0 0 1.25rem;
}

.artikel-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 1.5rem;
  margin-top: 1.25rem;
}

.artikel-meta-item {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #64748b;
}

.artikel-meta-badge {
  padding: 0.35rem 0.85rem;
  border-radius: 9999px;
  background: #f1f5f9;
  font-weight: 500;
}
</style>
