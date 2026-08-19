<template>
  <div class="filter-galeri">
    <div class="filter-galeri-inner">
      <button
        v-for="item in kategoriList"
        :key="String(item.value)"
        type="button"
        class="filter-btn"
        :class="{ 'filter-btn--active': aktif === item.value }"
        @click="emit('update:kategori', item.value)"
      >
        {{ item.label }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { kategoriList } from '@/data/galeri';

defineOptions({
  name: 'FilterGaleri'
});

const props = defineProps({
  aktif: {
    type: String,
    default: 'semua'
  }
});

const emit = defineEmits(['update:kategori']);
</script>

<style lang="scss" scoped>
.filter-galeri {
  margin-top: 2rem;
}

.filter-galeri-inner {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 0.75rem;
  padding: 0 1rem;
}

.filter-btn {
  padding: 0.625rem 1.5rem;
  border-radius: 9999px;
  border: none;
  font-weight: 500;
  font-size: 0.875rem;
  cursor: pointer;
  transition: background 0.2s ease, color 0.2s ease;
  background: #eef2ff;
  color: #334155;
}

.filter-btn:hover {
  background: #e0e7ff;
}

.filter-btn--active {
  background: #0f172a;
  color: #ffffff;
}

.filter-btn--active:hover {
  background: #1e293b;
}
</style>
