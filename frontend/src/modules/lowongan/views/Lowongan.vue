<template>
  <div class="lowongan-page">
    <AnimateOnScroll animation="fadeInDown">
      <LowonganHero v-model:search="searchQuery" @search="resetPagination" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="100">
      <div class="lowongan-layout">
        <FilterLowongan
          v-model:kategori="kategoriFilter"
          v-model:tipe="tipeFilter"
          :counts="getKategoriCounts()"
          @change="resetPagination"
        />
        <div class="lowongan-main">
          <GridLowongan :items="dataDitampilkan" @load-more="loadMore" />
        </div>
      </div>
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="200">
      <CtaRekrutmen />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <FooterSection
        :quickLinks="bkkQuickLinks"
        :contactInfo="bkkContactInfo"
        :newsletterDesc="'Dapatkan info terbaru seputar lowongan kerja dan kegiatan BKK.'"
      />
    </AnimateOnScroll>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getPublicContent } from '@/api/endpoints'
import { mapVacancy } from '@/modules/contentMapper'
import LowonganHero from '../components/LowonganHero.vue'
import FilterLowongan from '../components/FilterLowongan.vue'
import GridLowongan from '../components/GridLowongan.vue'
import CtaRekrutmen from '../components/CtaRekrutmen.vue'
import FooterSection from '../../portal/components/FooterSection.vue'
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue'

const route = useRoute()

const searchQuery = ref('')
const kategoriFilter = ref([])
const tipeFilter = ref([])
const visibleCount = ref(4)
const lowonganItems = ref([])

const hasilFilter = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  return lowonganItems.value.filter(item => {
    const cocokSearch = !q ||
      item.posisi.toLowerCase().includes(q) ||
      item.perusahaan.toLowerCase().includes(q)
    const cocokKategori = kategoriFilter.value.length === 0 || kategoriFilter.value.includes(item.kategori)
    const cocokTipe = tipeFilter.value.length === 0 || tipeFilter.value.includes(item.tipePekerjaan)
    return cocokSearch && cocokKategori && cocokTipe
  })
})
onMounted(async () => {
  try {
    const response = await getPublicContent('job_vacancies')
    const fetched = (response.data?.data || []).map(mapVacancy)
    if (fetched.length > 0) {
      lowonganItems.value = fetched
    }
  } catch (err) {
    console.warn('Gagal memuat lowongan dari API:', err)
  }
})

function getKategoriCounts() {
  return lowonganItems.value.reduce((counts, item) => {
    counts[item.kategori] = (counts[item.kategori] || 0) + 1
    return counts
  }, {})
}

const dataDitampilkan = computed(() => hasilFilter.value.slice(0, visibleCount.value))

function resetPagination() {
  visibleCount.value = 4
}

function loadMore() {
  visibleCount.value += 4
}

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

watch(() => route.query.kategori, (val) => {
  if (val) kategoriFilter.value = Array.isArray(val) ? val : [val]
})
</script>

<style lang="scss" scoped>
.lowongan-page {
  min-height: 100vh;
  background: #ffffff;
}

.lowongan-layout {
  max-width: 80rem;
  margin: 0 auto;
  padding: 2rem 1.5rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
}

@media (min-width: 768px) {
  .lowongan-layout {
    grid-template-columns: 280px 1fr;
    gap: 2rem;
  }
}

.lowongan-main {
  min-width: 0;
}
</style>
