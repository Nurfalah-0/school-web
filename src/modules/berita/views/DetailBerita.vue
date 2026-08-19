<template>
  <div class="detail-berita-page" v-if="artikelAktif">
    <div class="detail-berita-layout">
      <div class="detail-berita-main">
        <Breadcrumb :items="breadcrumbItems" />
        <ArtikelHeader :artikel="artikelAktif" />
        <div class="detail-berita-img-wrap">
          <img :src="artikelAktif.gambarUtama" :alt="artikelAktif.judul" class="detail-berita-img" />
        </div>
        <KontenArtikel :konten="artikelAktif.konten" />
        <TagsShareBar :tags="artikelAktif.tags" />
      </div>
      <aside class="detail-berita-sidebar">
        <BeritaLainnya :items="beritaLainnya" />
        <div class="sidebar-spacer"></div>
        <CtaPpdb />
      </aside>
    </div>
    <FooterSection />
  </div>

  <div v-else class="detail-berita-empty">
    <p class="detail-berita-empty-text">Artikel tidak ditemukan.</p>
    <router-link to="/berita" class="detail-berita-back">Kembali ke Semua Berita</router-link>
  </div>
</template>

<script setup>
import { computed, watch, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import { getBeritaBySlug, getBeritaLainnya } from '@/data/berita'
import Breadcrumb from '../components/Breadcrumb.vue'
import ArtikelHeader from '../components/ArtikelHeader.vue'
import KontenArtikel from '../components/KontenArtikel.vue'
import TagsShareBar from '../components/TagsShareBar.vue'
import BeritaLainnya from '../components/BeritaLainnya.vue'
import CtaPpdb from '../components/CtaPpdb.vue'
import FooterSection from '../../portal/components/FooterSection.vue'

const route = useRoute()

const artikelAktif = computed(() => getBeritaBySlug(route.params.slug))
const beritaLainnya = computed(() => getBeritaLainnya(route.params.slug, 3))

const breadcrumbItems = computed(() => [
  { label: 'Beranda', to: '/' },
  { label: 'Berita', to: '/berita' },
  { label: artikelAktif.value?.judul || 'Detail Berita' }
])

watch(
  () => route.params.slug,
  () => {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  },
  { immediate: true }
)

watchEffect(() => {
  document.title = artikelAktif.value
    ? `${artikelAktif.value.judul} - SMK Nurul Jadid`
    : 'Berita - SMK Nurul Jadid'
})
</script>

<style lang="scss" scoped>
.detail-berita-page {
  min-height: 100vh;
  background: #f8f7fb;
}

.detail-berita-layout {
  max-width: 84rem;
  margin: 0 auto;
  padding: 3rem 1.5rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
}

@media (min-width: 768px) {
  .detail-berita-layout {
    grid-template-columns: 1fr 300px;
    gap: 4rem;
    padding-top: 3rem;
  }
}

.detail-berita-main {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  min-width: 0;
}

.detail-berita-img-wrap {
  width: 100%;
  aspect-ratio: 16 / 10;
  border-radius: 1.25rem;
  overflow: hidden;
  margin-top: 2rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.detail-berita-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.detail-berita-sidebar {
  display: flex;
  flex-direction: column;
  gap: 3rem;
}

@media (max-width: 767px) {
  .detail-berita-sidebar {
    margin-top: 3rem;
  }
}

.detail-berita-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
  padding: 6rem 1rem;
  text-align: center;
  min-height: 60vh;
}

.detail-berita-empty-text {
  color: #64748b;
  font-size: 1.125rem;
  margin: 0;
}

.detail-berita-back {
  display: inline-flex;
  padding: 0.85rem 1.5rem;
  border-radius: 9999px;
  background: #1e3a5f;
  color: #ffffff;
  font-weight: 700;
  text-decoration: none;
  transition: background 0.2s ease;
}

.detail-berita-back:hover {
  background: #16264d;
}
</style>
