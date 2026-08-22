<template>
  <div class="detail-lowongan-page">
    <div v-if="lowongan">
      <AnimateOnScroll animation="fadeInDown">
        <div class="detail-lowongan-layout">
          <div class="detail-lowongan-main">
            <Breadcrumb :items="breadcrumbItems" />
            <div class="detail-lowongan-header">
              <div class="detail-lowongan-icon" :style="{ background: iconBg(lowongan.kategori) }">
                <component :is="iconComponent(lowongan.icon)" :size="32" :color="iconColor(lowongan.kategori)" />
              </div>
              <div class="detail-lowongan-info">
                <div class="detail-lowongan-pills">
                  <span v-if="lowongan.status === 'Baru'" class="detail-lowongan-pill detail-lowongan-pill-new">Baru</span>
                  <span class="detail-lowongan-pill detail-lowongan-pill-category">{{ lowongan.kategoriLabel }}</span>
                  <span class="detail-lowongan-pill">{{ lowongan.tipePekerjaanLabel }}</span>
                </div>
                <h1 class="detail-lowongan-title">{{ lowongan.posisi }}</h1>
                <p class="detail-lowongan-company">{{ lowongan.perusahaan }}</p>
              </div>
            </div>

            <AnimateOnScroll animation="fadeInUp" :delay="100">
              <div class="detail-lowongan-meta">
                <span class="detail-lowongan-meta-item">
                  <MapPin :size="16" color="#64748b" />
                  {{ lowongan.lokasi }}
                </span>
                <span class="detail-lowongan-meta-item">
                  <Clock :size="16" color="#64748b" />
                  {{ lowongan.deadlineLabel }}
                </span>
              </div>
            </AnimateOnScroll>

            <AnimateOnScroll animation="fadeInUp" :delay="150">
              <div class="detail-lowongan-section">
                <h2 class="detail-lowongan-section-title">Deskripsi</h2>
                <p class="detail-lowongan-text">{{ lowongan.deskripsiLengkap || lowongan.deskripsiSingkat }}</p>
              </div>
            </AnimateOnScroll>

            <AnimateOnScroll animation="fadeInUp" :delay="200">
              <div class="detail-lowongan-section">
                <h2 class="detail-lowongan-section-title">Kualifikasi</h2>
                <ul class="detail-lowongan-list">
                  <li v-for="(item, idx) in lowongan.kualifikasi" :key="idx" class="detail-lowongan-list-item">
                    <Check :size="16" color="#047857" />
                    {{ item }}
                  </li>
                </ul>
              </div>
            </AnimateOnScroll>

            <AnimateOnScroll animation="fadeInUp" :delay="250">
              <div class="detail-lowongan-section">
                <h2 class="detail-lowongan-section-title">Benefit</h2>
                <ul class="detail-lowongan-list">
                  <li v-for="(item, idx) in lowongan.benefit" :key="idx" class="detail-lowongan-list-item">
                    <Check :size="16" color="#047857" />
                    {{ item }}
                  </li>
                </ul>
              </div>
            </AnimateOnScroll>

            <AnimateOnScroll animation="fadeInUp" :delay="300">
              <div class="detail-lowongan-cta">
                <button type="button" class="detail-lowongan-btn" @click="openModal">
                  {{ lowongan.ctaLabel }}
                  <ArrowRight :size="18" color="#ffffff" />
                </button>
              </div>
            </AnimateOnScroll>

            <ModalLamaran v-model:open="isModalOpen" :posisi="lowongan.posisi" />
          </div>
          <AnimateOnScroll animation="fadeInRight" :delay="200">
            <aside class="detail-lowongan-sidebar">
              <LowonganLainnya :current-slug="slug" />
            </aside>
          </AnimateOnScroll>
        </div>
      </AnimateOnScroll>
      <AnimateOnScroll animation="fadeInUp" :delay="350">
        <FooterSection
          :quickLinks="bkkQuickLinks"
          :contactInfo="bkkContactInfo"
          :newsletterDesc="'Dapatkan info terbaru seputar lowongan kerja dan kegiatan BKK.'"
        />
      </AnimateOnScroll>
    </div>

    <div v-else class="detail-lowongan-empty">
      <p class="detail-lowongan-empty-text">Lowongan tidak ditemukan.</p>
      <router-link to="/lowongan" class="detail-lowongan-back">Kembali ke Lowongan</router-link>
    </div>
  </div>
</template>

<script setup>
import { computed, watch, watchEffect, ref } from 'vue'
import { useRoute } from 'vue-router'
import { getLowonganBySlug } from '@/data/lowongan'
import Breadcrumb from '../../berita/components/Breadcrumb.vue'
import LowonganLainnya from '../components/LowonganLainnya.vue'
import ModalLamaran from '../components/ModalLamaran.vue'
import FooterSection from '../../portal/components/FooterSection.vue'
import { MapPin, Clock, Check, ArrowRight, CodeXml, Car, Palette, Landmark } from 'lucide-vue-next'
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue'

const route = useRoute()
const slug = computed(() => route.params.slug)
const lowongan = computed(() => getLowonganBySlug(slug.value))
const isModalOpen = ref(false)

const breadcrumbItems = computed(() => [
  { label: 'Beranda', to: '/' },
  { label: 'Lowongan', to: '/lowongan' },
  { label: lowongan.value?.posisi || 'Detail Lowongan' }
])

const bkkQuickLinks = [
  { label: 'Tentang BKK', href: '#profil' },
  { label: 'Panduan PKL', href: '#panduan' },
  { label: 'Download Dokumen', href: '#dokumen' },
  { label: 'Kontak Admin', href: '#kontak' }
]

const bkkContactInfo = [
  {
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-12 14-12 14s-6-8-12-14a10 10 0 0 1 20-4Z"></path><circle cx="12" cy="10" r="3"></circle></svg>',
    text: 'Jl. KH. Zaini Mun\'im, Paiton, Probolinggo, Jawa Timur'
  },
  {
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>',
    text: '+62 335 771732'
  },
  {
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="16" x="2" y="4" rx="2"></rect><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path></svg>',
    text: 'bkk@smknurjad.sch.id'
  }
]

watch(() => route.params.slug, () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}, { immediate: true })

watchEffect(() => {
  document.title = lowongan.value
    ? `${lowongan.value.posisi} - SMK Nurul Jadid`
    : 'Lowongan - SMK Nurul Jadid'
})

function openModal() {
  isModalOpen.value = true
}

function iconComponent(name) {
  const map = { CodeXml, Car, Palette, Landmark }
  return map[name] || Landmark
}

function iconColor(kategori) {
  const map = {
    'it-software': '#1e3a8a',
    'akuntansi-keuangan': '#047857',
    'teknik-otomotif': '#b45309',
    'desain-grafis': '#7e22ce'
  }
  return map[kategori] || '#334155'
}

function iconBg(kategori) {
  const map = {
    'it-software': '#dbeafe',
    'akuntansi-keuangan': '#d1fae5',
    'teknik-otomotif': '#fef3c7',
    'desain-grafis': '#f3e8ff'
  }
  return map[kategori] || '#f1f5f9'
}
</script>

<style lang="scss" scoped>
.detail-lowongan-page {
  min-height: 100vh;
  background: #f8f7fb;
}

.detail-lowongan-layout {
  max-width: 80rem;
  margin: 0 auto;
  padding: 2rem 1.5rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 2.5rem;
}

@media (min-width: 768px) {
  .detail-lowongan-layout {
    grid-template-columns: 1fr 340px;
    gap: 4rem;
    padding-top: 3rem;
  }
}

.detail-lowongan-main {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  min-width: 0;
}

.detail-lowongan-header {
  display: flex;
  gap: 1.25rem;
  align-items: flex-start;
}

.detail-lowongan-icon {
  width: 4rem;
  height: 4rem;
  border-radius: 1rem;
  display: grid;
  place-items: center;
  flex-shrink: 0;
}

.detail-lowongan-info {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.detail-lowongan-pills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.detail-lowongan-pill {
  padding: 0.35rem 0.85rem;
  border-radius: 9999px;
  background: #eef2ff;
  color: #334155;
  font-size: 0.8rem;
  font-weight: 700;
}

.detail-lowongan-pill-new {
  background: #fef3c7;
  color: #92400e;
}

.detail-lowongan-pill-category {
  background: #dbeafe;
  color: #1e40af;
}

.detail-lowongan-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.5rem;
  color: #0f172a;
  margin: 0;
  line-height: 1.3;
}

.detail-lowongan-company {
  color: #042d86;
  font-size: 1rem;
  font-weight: 600;
  margin: 0;
}

.detail-lowongan-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 1.25rem;
  padding: 1rem 0;
  border-top: 1px solid #e2e8f0;
  border-bottom: 1px solid #e2e8f0;
}

.detail-lowongan-meta-item {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.95rem;
  color: #334155;
  font-weight: 600;
}

.detail-lowongan-section {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.detail-lowongan-section-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.detail-lowongan-text {
  color: #334155;
  line-height: 1.75;
  margin: 0;
}

.detail-lowongan-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.detail-lowongan-list-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  color: #334155;
  line-height: 1.6;
}

.detail-lowongan-cta {
  margin-top: 1rem;
}

.detail-lowongan-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.9rem 2rem;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 1rem;
  border: none;
  cursor: pointer;
  transition: background 0.2s ease;
}

.detail-lowongan-btn:hover {
  background: #16264d;
}

.detail-lowongan-sidebar {
  display: flex;
  flex-direction: column;
  gap: 2.5rem;
}

@media (max-width: 767px) {
  .detail-lowongan-sidebar {
    margin-top: 2rem;
  }
}

.detail-lowongan-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
  padding: 6rem 1rem;
  text-align: center;
  min-height: 60vh;
}

.detail-lowongan-empty-text {
  color: #64748b;
  font-size: 1.125rem;
  margin: 0;
}

.detail-lowongan-back {
  display: inline-flex;
  padding: 0.85rem 1.5rem;
  border-radius: 9999px;
  background: #1e3a5f;
  color: #ffffff;
  font-weight: 700;
  text-decoration: none;
  transition: background 0.2s ease;
}

.detail-lowongan-back:hover {
  background: #16264d;
}
</style>
