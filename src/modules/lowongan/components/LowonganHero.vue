<template>
  <section class="lowongan-hero">
    <div class="lowongan-hero-inner">
      <h1 class="lowongan-hero-title">
        Pusat Karir &<br />Lowongan Kerja
      </h1>
      <p class="lowongan-hero-desc">
        Temukan peluang karir terbaik dari mitra industri SMK Nurul Jadid. Wujudkan masa depan profesional Anda hari ini.
      </p>

      <div class="lowongan-search">
        <Search :size="20" color="#64748b" />
        <input
          v-model="searchQuery"
          type="text"
          class="lowongan-search-input"
          placeholder="Cari posisi atau perusahaan..."
          @keyup.enter="$emit('search')"
        />
        <button type="button" class="lowongan-search-btn" @click="$emit('search')">
          Cari <ArrowRight :size="16" color="#ffffff" />
        </button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { Search, ArrowRight } from 'lucide-vue-next'

const searchQuery = ref('')

defineEmits(['search'])

defineExpose({ searchQuery })
</script>

<style lang="scss" scoped>
.lowongan-hero {
  background: linear-gradient(to bottom, #eef2ff, #ffffff);
  padding: 4rem 0;
}

.lowongan-hero-inner {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1.5rem;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.lowongan-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(1.75rem, 3.5vw, 3rem);
  color: #1e3a8a;
  line-height: 1.15;
  margin: 0;
  max-width: 48rem;
}

.lowongan-hero-desc {
  margin-top: 1.25rem;
  color: #475569;
  font-size: 1.125rem;
  line-height: 1.7;
  max-width: 36rem;
}

.lowongan-search {
  margin-top: 2rem;
  width: 100%;
  max-width: 42rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: #ffffff;
  border-radius: 9999px;
  padding: 0.5rem 0.75rem;
  box-shadow: 0 20px 40px rgba(15, 23, 42, 0.12);
  border: 1px solid #e2e8f0;
}

.lowongan-search-input {
  flex: 1;
  border: none;
  background: transparent;
  padding: 0.75rem 0.5rem;
  font-size: 1rem;
  color: #0f172a;
  outline: none;
  min-width: 0;
}

.lowongan-search-input::placeholder {
  color: #94a3b8;
}

.lowongan-search-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.95rem;
  border: none;
  cursor: pointer;
  white-space: nowrap;
  transition: background 0.2s ease;
}

.lowongan-search-btn:hover {
  background: #16264d;
}

@media (max-width: 640px) {
  .lowongan-search {
    flex-wrap: wrap;
    border-radius: 1.25rem;
    padding: 0.75rem;
  }

  .lowongan-search-input {
    width: 100%;
  }

  .lowongan-search-btn {
    width: 100%;
    justify-content: center;
  }
}
</style>
