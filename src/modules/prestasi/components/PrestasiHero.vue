<template>
  <section class="prestasi-hero">
    <div class="prestasi-hero-inner">
      <div class="prestasi-hero-copy">
        <span class="prestasi-hero-badge">
          <Medal :size="16" color="#042d86" />
          Hall of Fame
        </span>
        <h1 class="prestasi-hero-title">Prestasi Siswa</h1>
        <p class="prestasi-hero-desc">
          Mencetak Generasi Unggul dan Berdaya Saing Global. Jelajahi karya dan pencapaian membanggakan dari siswa-siswi SMK CareerHub.
        </p>
      </div>

      <div v-if="featured" class="prestasi-hero-card">
        <div class="prestasi-hero-card-img-wrap">
          <img v-if="featured.gambar" :src="featured.gambar" :alt="featured.judul" class="prestasi-hero-card-img" loading="eager" />
          <div v-else class="prestasi-hero-card-img prestasi-hero-placeholder">
            <Medal :size="48" color="#042d86" />
          </div>
          <span v-if="featured.status" class="prestasi-hero-card-badge">Terbaru</span>
        </div>
        <div class="prestasi-hero-card-body">
          <span class="prestasi-hero-card-kategori" :style="{ color: badgeTextColor(featured.kategoriBadgeColor) }">{{ featured.kategoriLabel }}</span>
          <h2 class="prestasi-hero-card-title">{{ featured.judul }}</h2>
          <p class="prestasi-hero-card-desc">{{ featured.deskripsiSingkat }}</p>
          <router-link :to="`/prestasi/${featured.slug}`" class="prestasi-hero-card-btn">
            Baca Selengkapnya
            <ArrowRight :size="18" color="#ffffff" />
          </router-link>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { Medal, ArrowRight } from 'lucide-vue-next'
import { kategoriBadgeColors } from '@/data/prestasi'

defineProps({
  featured: {
    type: Object,
    default: null
  }
})

function badgeTextColor(colorKey) {
  return kategoriBadgeColors[colorKey]?.text || '#1e40af'
}
</script>

<style lang="scss" scoped>
.prestasi-hero {
  background: linear-gradient(135deg, #ffffff 0%, #eef2ff 60%, rgba(232, 230, 247, 0.4) 100%);
  padding: 4rem 0;
}

.prestasi-hero-inner {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1.5rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
  align-items: center;
}

@media (min-width: 768px) {
  .prestasi-hero-inner {
    grid-template-columns: 1fr 1.1fr;
    gap: 4rem;
  }
}

.prestasi-hero-copy {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.prestasi-hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  width: fit-content;
  padding: 0.5rem 1.25rem;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.7);
  border: 1px solid rgba(4, 45, 134, 0.1);
  color: #042d86;
  font-size: 0.875rem;
  font-weight: 600;
  backdrop-filter: blur(8px);
}

.prestasi-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(2rem, 4vw, 3.5rem);
  line-height: 1.1;
  letter-spacing: -0.03em;
  color: #1e3a5f;
  margin: 0;
}

.prestasi-hero-desc {
  color: #475569;
  font-size: 1.125rem;
  line-height: 1.75;
  margin: 0;
  max-width: 32rem;
}

.prestasi-hero-card {
  background: #ffffff;
  border-radius: 1.75rem;
  box-shadow: 0 24px 48px rgba(15, 23, 42, 0.1);
  overflow: hidden;
}

.prestasi-hero-card-img-wrap {
  position: relative;
  aspect-ratio: 16 / 10;
  overflow: hidden;
}

.prestasi-hero-card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.prestasi-hero-placeholder {
  background: #eef2ff;
  display: grid;
  place-items: center;
}

.prestasi-hero-card-badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  padding: 0.5rem 1.25rem;
  border-radius: 9999px;
  background: #fbbf24;
  color: #1a1a2e;
  font-size: 0.875rem;
  font-weight: 700;
}

.prestasi-hero-card-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.prestasi-hero-card-kategori {
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.prestasi-hero-card-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.5rem;
  color: #0f172a;
  line-height: 1.3;
  margin: 0;
}

.prestasi-hero-card-desc {
  color: #475569;
  font-size: 1rem;
  line-height: 1.7;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.prestasi-hero-card-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.85rem 1.5rem;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  margin-top: 0.5rem;
  width: fit-content;
  transition: background 0.2s ease;
}

.prestasi-hero-card-btn:hover {
  background: #16264d;
}
</style>
