<template>
  <section class="filter-section">
    <div class="filter-inner">
      <div class="filter-header">
        <h2 class="filter-title">Pilih Kategori</h2>
        <button type="button" class="filter-link" @click="$emit('reset-filter')">Lihat Semua</button>
      </div>
      <div class="filter-scroll">
        <button
          v-for="item in kategoriList"
          :key="item.value"
          :class="['filter-pill', { active: modelValue === item.value }]"
          type="button"
          @click="$emit('update:modelValue', item.value)"
        >
          {{ item.label }}
        </button>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  modelValue: {
    type: String,
    default: 'Semua Produk'
  }
})

defineEmits(['update:modelValue', 'reset-filter'])

const kategoriList = [
  { label: 'Semua Produk', value: 'Semua Produk' },
  { label: 'Web Development', value: 'Web Development' },
  { label: 'Design Grafis', value: 'Design Grafis' },
  { label: 'Percetakan Digital', value: 'Percetakan Digital' },
  { label: 'Multimedia & Film', value: 'Multimedia & Film' },
  { label: 'Produk Kreatif', value: 'Produk Kreatif' }
]
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.filter-section {
  background: #ffffff;
  padding: 2rem 0;
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

.filter-link {
  color: $brand;
  font-weight: 700;
  font-size: 0.9rem;
  text-decoration: none;
  transition: opacity 0.2s ease;
}

.filter-link:hover {
  opacity: 0.8;
  text-decoration: underline;
}

.filter-scroll {
  display: flex;
  gap: 0.75rem;
  overflow-x: auto;
  white-space: nowrap;
  padding-bottom: 0.5rem;
  scrollbar-width: none;

  &::-webkit-scrollbar {
    display: none;
  }
}

.filter-pill {
  flex-shrink: 0;
  padding: 0.65rem 1.25rem;
  border-radius: 9999px;
  border: none;
  background: #eef2ff;
  color: #334155;
  font-weight: 700;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background 0.2s ease, color 0.2s ease, box-shadow 0.2s ease;
}

.filter-pill:hover {
  background: #e0e7ff;
}

.filter-pill.active {
  background: $brand;
  color: #ffffff;
  box-shadow: 0 6px 16px rgba(4, 45, 134, 0.25);
}
</style>
