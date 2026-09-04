<template>
  <section class="filter-section">
    <div class="filter-inner">
      <div class="filter-header">
        <h2 class="filter-title">Pilih Kategori</h2>
        <button
          v-if="modelValue !== 'Semua Produk'"
          class="filter-reset-btn"
          @click="$emit('update:modelValue', 'Semua Produk')"
        >
          Reset Filter (Tampilkan Semua)
        </button>
      </div>
      <div class="filter-scroll">
        <button
          v-for="item in kategoriList"
          :key="item.value"
          :class="['filter-pill', { active: modelValue.toLowerCase() === item.value.toLowerCase() }]"
          type="button"
          @click="$emit('update:modelValue', item.value)"
        >
          <component :is="item.icon" :size="16" class="pill-icon" />
          {{ item.label }}
        </button>
      </div>
    </div>
  </section>
</template>

<script setup>
import {
  ShoppingBag,
  Printer,
  Monitor,
  Palette,
  Film,
  Sparkles,
  Wrench
} from 'lucide-vue-next'

defineProps({
  modelValue: {
    type: String,
    default: 'Semua Produk'
  }
})

defineEmits(['update:modelValue'])

const kategoriList = [
  { label: 'Semua Produk', value: 'Semua Produk', icon: ShoppingBag },
  { label: 'Percetakan Digital', value: 'Percetakan', icon: Printer },
  { label: 'Web Development', value: 'Web Development', icon: Monitor },
  { label: 'Design Grafis', value: 'Design Grafis', icon: Palette },
  { label: 'Multimedia & Film', value: 'Multimedia', icon: Film },
  { label: 'Produk Kreatif', value: 'Produk Kreatif', icon: Sparkles },
  { label: 'Jasa Servis', value: 'Jasa', icon: Wrench }
]
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.filter-section {
  background: #ffffff;
  padding: 1.5rem 0;
  border-bottom: 1px solid $border;
}

.filter-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.filter-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.25rem;
}

.filter-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.filter-reset-btn {
  background: none;
  border: none;
  color: $brand;
  font-weight: 700;
  font-size: 0.875rem;
  cursor: pointer;
  padding: 0;

  &:hover {
    text-decoration: underline;
  }
}

.filter-scroll {
  display: flex;
  gap: 0.75rem;
  overflow-x: auto;
  white-space: nowrap;
  padding-bottom: 0.5rem;
  scrollbar-width: thin;
}

.filter-pill {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  flex-shrink: 0;
  padding: 0.65rem 1.25rem;
  border-radius: 9999px;
  border: 1.5px solid #e2e8f0;
  background: #f8fafc;
  color: #334155;
  font-weight: 700;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s ease;

  .pill-icon {
    font-size: 1rem;
  }

  &:hover {
    background: #eef2ff;
    border-color: #cbd5e1;
  }

  &.active {
    background: $brand;
    border-color: $brand;
    color: #ffffff;
    box-shadow: 0 6px 16px rgba(4, 45, 134, 0.25);
  }
}
</style>
