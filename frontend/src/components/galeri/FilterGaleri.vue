<template>
  <div class="filter-galeri">
    <div class="filter-galeri-inner">
      <!-- Search bar -->
      <div class="search-box">
        <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Cari foto..."
          class="search-input"
          @input="$emit('update:search', searchQuery)"
        />
      </div>

      <!-- Category pills -->
      <div class="filter-pills">
        <button
          v-for="item in kategoriList"
          :key="String(item.value)"
          type="button"
          class="filter-pill"
          :class="{ 'filter-pill--active': aktif === item.value }"
          @click="emit('update:kategori', item.value)"
        >
          <component :is="iconMap[item.value] || ImageIcon" :size="15" class="pill-icon" />
          {{ item.label }}
          <span v-if="aktif === item.value" class="pill-active-dot"></span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import {
  Image as ImageIcon,
  Building2,
  GraduationCap,
  Microscope,
  Trophy,
  PartyPopper
} from 'lucide-vue-next';
import { kategoriList } from '@/data/galeri';

defineOptions({ name: 'FilterGaleri' });

defineProps({
  aktif: { type: String, default: 'semua' }
});

const emit = defineEmits(['update:kategori', 'update:search']);
const searchQuery = ref('');

const iconMap = {
  semua: ImageIcon,
  fasilitas: Building2,
  'kegiatan-siswa': GraduationCap,
  'lab-praktik': Microscope,
  prestasi: Trophy,
  'acara-sekolah': PartyPopper
};
</script>

<style lang="scss" scoped>
.filter-galeri {
  background: #ffffff;
  position: sticky;
  top: 0;
  z-index: 20;
  border-bottom: 1px solid #f1f5f9;
  box-shadow: 0 1px 12px rgba(0,0,0,0.05);
  padding: 1rem 1.5rem;
}

.filter-galeri-inner {
  max-width: 72rem;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
}

/* Search */
.search-box {
  position: relative;
  max-width: 320px;
}

.search-icon {
  position: absolute;
  left: 0.875rem;
  top: 50%;
  transform: translateY(-50%);
  color: #94a3b8;
  pointer-events: none;
}

.search-input {
  width: 100%;
  padding: 0.625rem 1rem 0.625rem 2.5rem;
  border-radius: 9999px;
  border: 1.5px solid #e2e8f0;
  background: #f8fafc;
  font-size: 0.875rem;
  color: #0f172a;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
  box-sizing: border-box;

  &:focus {
    border-color: #7c3aed;
    box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1);
    background: #ffffff;
  }

  &::placeholder { color: #94a3b8; }
}

/* Pills */
.filter-pills {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.filter-pill {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.5rem 1.125rem;
  border-radius: 9999px;
  border: 1.5px solid #e2e8f0;
  font-weight: 500;
  font-size: 0.825rem;
  cursor: pointer;
  background: #ffffff;
  color: #475569;
  transition: all 0.2s ease;
  white-space: nowrap;

  &:hover:not(.filter-pill--active) {
    background: #f8fafc;
    border-color: #cbd5e1;
    color: #1e293b;
    transform: translateY(-1px);
  }
}

.filter-pill--active {
  background: linear-gradient(135deg, #7c3aed, #2563eb);
  border-color: transparent;
  color: #ffffff;
  box-shadow: 0 4px 12px rgba(124, 58, 237, 0.3);
  transform: translateY(-1px);
}

.pill-icon {
  font-size: 0.9rem;
}

.pill-active-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: rgba(255,255,255,0.8);
  margin-left: 2px;
}

@media (max-width: 639px) {
  .filter-galeri {
    padding: 0.875rem 1rem;
  }
  .search-box { max-width: 100%; }
  .filter-pills { gap: 0.375rem; }
  .filter-pill { padding: 0.4375rem 0.875rem; font-size: 0.8rem; }
}
</style>
