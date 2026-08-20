<template>
  <div class="detail-prestasi-page" v-if="prestasi">
    <AnimateOnScroll animation="fadeInDown">
      <div class="detail-prestasi-layout">
        <div class="detail-prestasi-main">
          <Breadcrumb :items="breadcrumbItems" />
          <ArtikelHeader :artikel="prestasi" />
          <AnimateOnScroll animation="scaleIn" :delay="100">
            <div class="detail-prestasi-img-wrap">
              <img v-if="prestasi.gambar" :src="prestasi.gambar" :alt="prestasi.judul" class="detail-prestasi-img" />
              <div v-else class="detail-prestasi-img detail-prestasi-placeholder">
                <Medal :size="64" color="#6366f1" />
              </div>
            </div>
          </AnimateOnScroll>
          <AnimateOnScroll animation="fadeInUp" :delay="200">
            <KontenArtikel :konten="kontenArtikel" />
          </AnimateOnScroll>
          <AnimateOnScroll animation="fadeInUp" :delay="250">
            <TagsShareBar :tags="[prestasi.kategoriLabel]" />
          </AnimateOnScroll>
        </div>
        <AnimateOnScroll animation="fadeInRight" :delay="300">
          <aside class="detail-prestasi-sidebar">
            <PrestasiLainnya :current-slug="slug" />
            <CtaPpdb />
          </aside>
        </AnimateOnScroll>
      </div>
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="350">
      <FooterSection />
    </AnimateOnScroll>
  </div>

  <div v-else class="detail-prestasi-empty">
    <p class="detail-prestasi-empty-text">Prestasi tidak ditemukan.</p>
    <router-link to="/prestasi" class="detail-prestasi-back">Kembali ke Prestasi</router-link>
  </div>
</template>

<script setup>
import { computed, watch, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import { getPrestasiBySlug, getPrestasiLainnya } from '@/data/prestasi'
import Breadcrumb from '../../berita/components/Breadcrumb.vue'
import ArtikelHeader from '../../berita/components/ArtikelHeader.vue'
import KontenArtikel from '../../berita/components/KontenArtikel.vue'
import TagsShareBar from '../../berita/components/TagsShareBar.vue'
import PrestasiLainnya from '../components/PrestasiLainnya.vue'
import CtaPpdb from '../../berita/components/CtaPpdb.vue'
import FooterSection from '../../portal/components/FooterSection.vue'
import { Medal } from 'lucide-vue-next'
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue'

const route = useRoute()
const slug = computed(() => route.params.slug)
const prestasi = computed(() => getPrestasiBySlug(slug.value))

const breadcrumbItems = computed(() => [
  { label: 'Beranda', to: '/' },
  { label: 'Prestasi', to: '/prestasi' },
  { label: prestasi.value?.judul || 'Detail Prestasi' }
])

const kontenArtikel = computed(() => {
  if (!prestasi.value) return []
  return [
    { tipe: 'paragraf', teks: prestasi.value.deskripsiLengkap || prestasi.value.deskripsiSingkat }
  ]
})

watch(() => route.params.slug, () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}, { immediate: true })

watchEffect(() => {
  document.title = prestasi.value
    ? `${prestasi.value.judul} - SMK Nurul Jadid`
    : 'Prestasi - SMK Nurul Jadid'
})
</script>

<style lang="scss" scoped>
.detail-prestasi-page {
  min-height: 100vh;
  background: #f8f7fb;
}

.detail-prestasi-layout {
  max-width: 80rem;
  margin: 0 auto;
  padding: 2rem 1.5rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 2.5rem;
}

@media (min-width: 768px) {
  .detail-prestasi-layout {
    grid-template-columns: 1fr 340px;
    gap: 4rem;
    padding-top: 3rem;
  }
}

.detail-prestasi-main {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  min-width: 0;
}

.detail-prestasi-img-wrap {
  width: 100%;
  aspect-ratio: 16 / 10;
  border-radius: 1.25rem;
  overflow: hidden;
  margin-top: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.detail-prestasi-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.detail-prestasi-placeholder {
  background: #eef2ff;
  display: grid;
  place-items: center;
}

.detail-prestasi-sidebar {
  display: flex;
  flex-direction: column;
  gap: 2.5rem;
}

@media (max-width: 767px) {
  .detail-prestasi-sidebar {
    margin-top: 2rem;
  }
}

.detail-prestasi-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
  padding: 6rem 1rem;
  text-align: center;
  min-height: 60vh;
}

.detail-prestasi-empty-text {
  color: #64748b;
  font-size: 1.125rem;
  margin: 0;
}

.detail-prestasi-back {
  display: inline-flex;
  padding: 0.85rem 1.5rem;
  border-radius: 9999px;
  background: #1e3a5f;
  color: #ffffff;
  font-weight: 700;
  text-decoration: none;
  transition: background 0.2s ease;
}

.detail-prestasi-back:hover {
  background: #16264d;
}
</style>
