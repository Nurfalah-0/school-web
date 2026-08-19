<template>
  <aside class="filter-card">
    <div class="filter-header">
      <SlidersHorizontal :size="18" color="#1e3a8a" />
      <span class="filter-title">Filter</span>
    </div>

    <div class="filter-group">
      <p class="filter-label">Kategori Pekerjaan</p>
      <label v-for="item in kategoriList" :key="item.value" class="filter-check">
        <input
          type="checkbox"
          :value="item.value"
          :checked="modelKategori.includes(item.value)"
          @change="toggleKategori(item.value)"
        />
        <span class="filter-check-box"></span>
        <span class="filter-check-label">{{ item.label }}</span>
        <span class="filter-check-count">({{ getCount(item.value) }})</span>
      </label>
    </div>

    <div class="filter-group">
      <p class="filter-label">Tipe Pekerjaan</p>
      <label v-for="item in tipeList" :key="item.value" class="filter-check">
        <input
          type="checkbox"
          :value="item.value"
          :checked="modelTipe.includes(item.value)"
          @change="toggleTipe(item.value)"
        />
        <span class="filter-check-box"></span>
        <span class="filter-check-label">{{ item.label }}</span>
      </label>
    </div>

    <button v-if="hasFilter" type="button" class="filter-reset" @click="reset">
      Reset Filter
    </button>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { SlidersHorizontal } from 'lucide-vue-next'
import { kategoriList, tipeList } from '@/data/lowongan'

const props = defineProps({
  modelKategori: {
    type: Array,
    default: () => []
  },
  modelTipe: {
    type: Array,
    default: () => []
  },
  counts: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['update:modelKategori', 'update:modelTipe'])

function toggleKategori(value) {
  const next = props.modelKategori.includes(value)
    ? props.modelKategori.filter(v => v !== value)
    : [...props.modelKategori, value]
  emit('update:modelKategori', next)
}

function toggleTipe(value) {
  const next = props.modelTipe.includes(value)
    ? props.modelTipe.filter(v => v !== value)
    : [...props.modelTipe, value]
  emit('update:modelTipe', next)
}

function reset() {
  emit('update:modelKategori', [])
  emit('update:modelTipe', [])
}

function getCount(value) {
  const found = props.counts.find(item => item.value === value)
  return found ? found.count : 0
}

const hasFilter = computed(() => props.modelKategori.length > 0 || props.modelTipe.length > 0)
</script>

<style lang="scss" scoped>
.filter-card {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 1.25rem;
  padding: 1.5rem;
  position: sticky;
  top: 5rem;
}

.filter-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.filter-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.1rem;
  color: #0f172a;
}

.filter-group {
  margin-bottom: 1.5rem;
}

.filter-label {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #64748b;
  margin: 0 0 1rem;
}

.filter-check {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  cursor: pointer;
  margin-bottom: 0.9rem;
}

.filter-check input {
  position: absolute;
  opacity: 0;
  pointer-events: none;
}

.filter-check-box {
  width: 1.1rem;
  height: 1.1rem;
  border-radius: 0.35rem;
  border: 2px solid #cbd5e1;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  transition: all 0.15s ease;
}

.filter-check input:checked + .filter-check-box {
  background: #1e3a8a;
  border-color: #1e3a8a;
}

.filter-check input:checked + .filter-check-box::after {
  content: '';
  width: 0.35rem;
  height: 0.65rem;
  border: solid #ffffff;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.filter-check-label {
  font-size: 0.95rem;
  color: #1e293b;
  flex: 1;
}

.filter-check-count {
  font-size: 0.85rem;
  color: #64748b;
}

.filter-reset {
  width: 100%;
  padding: 0.65rem;
  border-radius: 9999px;
  border: 1px solid #e2e8f0;
  background: #ffffff;
  color: #334155;
  font-weight: 600;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-reset:hover {
  border-color: #94a3b8;
  background: #f8fafc;
}

@media (max-width: 767px) {
  .filter-card {
    position: static;
    margin-bottom: 1rem;
  }
}
</style>
