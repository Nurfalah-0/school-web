<template>
  <section class="berita-kegiatan">
    <div class="berita-inner">
      <div class="berita-header">
        <h2 class="berita-title">{{ title }}</h2>
        <router-link to="/berita" class="berita-link">{{ seeAllText }}</router-link>
      </div>

      <div class="berita-grid">
        <div class="berita-featured">
          <router-link v-if="beritaUtama" :to="`/berita/${beritaUtama.slug}`" class="berita-featured-link">
            <div class="berita-featured-img-wrap">
              <img :src="beritaUtama.gambarUtama" :alt="beritaUtama.judul" class="berita-featured-img" />
              <span class="berita-featured-badge">UTAMA</span>
            </div>
            <div class="berita-featured-body">
              <span class="berita-featured-date">{{ beritaUtama.tanggalDisplay }}</span>
              <h3 class="berita-featured-title">{{ beritaUtama.judul }}</h3>
              <p class="berita-featured-text">{{ excerpt(beritaUtama) }}</p>
            </div>
          </router-link>
        </div>

        <div class="berita-list">
          <router-link
            v-for="item in daftarBerita"
            :key="item.slug"
            :to="`/berita/${item.slug}`"
            class="berita-list-item"
          >
            <div class="berita-list-thumb">
              <img :src="item.gambarUtama" :alt="item.judul" class="berita-list-img" />
            </div>
            <div class="berita-list-body">
              <span class="berita-list-kategori" :style="{ color: kategoriColor(item.kategori) }">{{ item.kategori }}</span>
              <h4 class="berita-list-title">{{ item.judul }}</h4>
              <span class="berita-list-date">{{ item.tanggalDisplay }}</span>
            </div>
          </router-link>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { getBeritaUtama, getBeritaTerbaru, kategoriColorMap } from '@/data/berita'

defineProps({
  title: {
    type: String,
    default: 'Berita & Kegiatan'
  },
  seeAllText: {
    type: String,
    default: 'Semua Berita'
  }
})

const beritaUtama = computed(() => getBeritaUtama())
const daftarBerita = computed(() => getBeritaTerbaru(3))

function excerpt(artikel) {
  const txt = artikel.konten.find(b => b.tipe === 'paragraf')?.teks || ''
  return txt.length > 140 ? txt.slice(0, 140).trim() + '...' : txt
}

function kategoriColor(kategori) {
  return kategoriColorMap[kategori]?.bg || '#042d86'
}
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.berita-kegiatan {
  background: #ffffff;
  padding: 5rem 0;
}

.berita-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
}

.berita-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 1.5rem;
  margin-bottom: 3rem;
  flex-wrap: wrap;
}

.berita-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 3rem);
  color: #0f172a;
  margin: 0;
}

.berita-link {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  color: #042d86;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  border-bottom: 2px solid transparent;
  padding-bottom: 0.15rem;
  transition: border-color 0.2s;
  flex-shrink: 0;
}

.berita-link:hover {
  border-bottom-color: #042d86;
}

.berita-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2.5rem;
  align-items: start;
}

@media (min-width: 768px) {
  .berita-grid {
    grid-template-columns: 1.6fr 1fr;
    gap: 4rem;
  }
}

.berita-featured-link {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  text-decoration: none;
  color: inherit;
}

.berita-featured-img-wrap {
  position: relative;
  aspect-ratio: 16/10;
  border-radius: 1.5rem;
  overflow: hidden;
}

.berita-featured-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.berita-featured-badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  padding: 0.4rem 1rem;
  background: #042d86;
  color: #ffffff;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 800;
  letter-spacing: 0.08em;
}

.berita-featured-body {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.berita-featured-date {
  color: #042d86;
  font-weight: 700;
  font-size: 0.9rem;
}

.berita-featured-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.3rem, 2vw, 1.75rem);
  color: #0f172a;
  line-height: 1.3;
  margin: 0;
}

.berita-featured-text {
  color: #475569;
  font-size: 1rem;
  line-height: 1.7;
  margin: 0;
}

.berita-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.berita-list-item {
  display: flex;
  gap: 1rem;
  text-decoration: none;
  color: inherit;
  align-items: flex-start;
}

.berita-list-thumb {
  width: 7rem;
  height: 7rem;
  border-radius: 1rem;
  overflow: hidden;
  flex-shrink: 0;
}

.berita-list-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.berita-list-body {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  padding-top: 0.15rem;
}

.berita-list-kategori {
  font-size: 0.75rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
}

.berita-list-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1rem;
  color: #0f172a;
  line-height: 1.4;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.berita-list-date {
  font-size: 0.85rem;
  color: #64748b;
  margin-top: 0.25rem;
}

@media (max-width: 767px) {
  .berita-featured-img-wrap {
    aspect-ratio: 16/9;
  }

  .berita-list-thumb {
    width: 6rem;
    height: 6rem;
  }
}
</style>
