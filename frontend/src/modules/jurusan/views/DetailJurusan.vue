<template>
  <div class="detail-jurusan-page">
    <AnimateOnScroll animation="fadeInDown" v-if="jurusanAktif">
      <div class="detail-jurusan-layout">
        <div class="detail-jurusan-main">
          <JurusanHero :jurusan="jurusanAktif" />
          <AnimateOnScroll animation="fadeInUp" :delay="150">
            <KeunggulanProgram :keunggulan="jurusanAktif.keunggulan" />
          </AnimateOnScroll>
        </div>
        <AnimateOnScroll animation="fadeInRight" :delay="200">
          <SidebarJurusan :jurusan-lainnya="jurusanLainnya" :current-slug="route.params.slug" />
        </AnimateOnScroll>
      </div>
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="250" v-if="jurusanAktif">
      <JalurKurikulum :kurikulum="jurusanAktif.kurikulum" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <FooterSection />
    </AnimateOnScroll>

    <div v-if="isLoading" class="detail-jurusan-empty">
      <p>Memuat data jurusan...</p>
    </div>
    <div v-else-if="!jurusanAktif" class="detail-jurusan-empty">
      <h1>Jurusan tidak ditemukan</h1>
      <router-link to="/jurusan" class="detail-jurusan-back">Kembali ke Semua Jurusan</router-link>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getMajors } from '@/api/endpoints'
import { jurusanList as fallbackJurusanList } from '@/data/jurusan'
import JurusanHero from '../components/JurusanHero.vue'
import KeunggulanProgram from '../components/KeunggulanProgram.vue'
import SidebarJurusan from '../components/SidebarJurusan.vue'
import JalurKurikulum from '../components/JalurKurikulum.vue'
import FooterSection from '../../portal/components/FooterSection.vue'
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue'

const route = useRoute()
const apiMajors = ref([])
const isLoading = ref(true)
const API_BASE = (import.meta.env.VITE_API_URL || 'http://localhost:8000/api').replace(/\/api\/?$/, '')

function normalizeImageUrl(value) {
  if (!value) return ''
  if (value.startsWith('http://') || value.startsWith('https://')) return value
  if (value.startsWith('/storage/')) return `${API_BASE}${value}`
  return value
}

function textValue(value, fallback) {
  if (Array.isArray(value)) return value.join(', ')
  if (typeof value === 'string' && value.trim()) {
    try {
      const parsed = JSON.parse(value)
      if (Array.isArray(parsed)) return parsed.join(', ')
    } catch {
      return value
    }
    return value
  }
  return fallback
}

function mapMajor(item) {
  const fallback = fallbackJurusanList.find((entry) => entry.slug === item.slug) || {}
  const name = item.name || fallback.nama || 'Program Keahlian'
  const description = textValue(item.description, fallback.deskripsi || `Program keahlian ${name}.`)
  const vision = textValue(item.vision, description)
  const mission = textValue(item.mission, description)
  const facilities = textValue(item.facilities, `Fasilitas pembelajaran ${name}.`)
  const iconByCode = {
    RPL: 'CodeXml',
    TKRO: 'Briefcase',
    TBSM: 'Briefcase',
    AKL: 'Calculator',
    TJKT: 'Network',
    DKV: 'Palette'
  }

  return {
    ...fallback,
    ...item,
    slug: item.slug || fallback.slug,
    kategori: item.code || 'Program Keahlian',
    nama: name,
    deskripsi: description,
    gambarHero: normalizeImageUrl(item.image) || fallback.gambarHero || `https://placehold.co/1200x800/e2e8f0/475569?text=${encodeURIComponent(name)}`,
    icon: iconByCode[item.code] || fallback.icon || 'Briefcase',
    iconBg: fallback.iconBg || '#1e3a5f',
    keunggulan: [
      { icon: 'Rocket', judul: 'Profil Program', deskripsi: description },
      { icon: 'Handshake', judul: 'Visi Program', deskripsi: vision },
      { icon: 'Award', judul: 'Fasilitas Program', deskripsi: facilities }
    ],
    kurikulum: [
      { kelas: 'Kelas 10: Dasar Program', warna: 'navy', deskripsi: description, tags: [item.code || 'Dasar Keahlian'] },
      { kelas: 'Kelas 11: Pengembangan Kompetensi', warna: 'teal', deskripsi: vision, tags: ['Kompetensi', item.code || 'Program Keahlian'] },
      { kelas: 'Kelas 12: Spesialisasi & PKL', warna: 'gold', deskripsi: mission, tags: ['Spesialisasi', 'PKL'] }
    ]
  }
}

onMounted(async () => {
  try {
    const response = await getMajors()
    const items = response.data?.data || []

    if (items.length > 0) {
      apiMajors.value = items.map(mapMajor)
    } else {
      apiMajors.value = fallbackJurusanList.map((item) => ({
        ...item,
        slug: item.slug,
        kategori: item.kategori,
        nama: item.nama,
        deskripsi: item.deskripsi,
        gambarHero: item.gambarHero,
        icon: item.icon,
        iconBg: item.iconBg,
        keunggulan: item.keunggulan,
        kurikulum: item.kurikulum,
      }))
    }
  } catch (error) {
    console.warn('Gagal memuat jurusan dari API, mencoba data dummy:', error)
    apiMajors.value = fallbackJurusanList
  }

  isLoading.value = false
})

const jurusanAktif = computed(() => apiMajors.value.find((item) => item.slug === route.params.slug))
const jurusanLainnya = computed(() => apiMajors.value.filter((item) => item.slug !== route.params.slug))

watch(
  [() => route.params.slug, apiMajors],
  ([slug]) => {
    const jurusan = apiMajors.value.find((item) => item.slug === slug)
    if (jurusan) {
      document.title = `${jurusan.nama} - SMK Nurul Jadid`
    } else {
      document.title = 'Jurusan - SMK Nurul Jadid'
    }
    window.scrollTo({ top: 0, behavior: 'smooth' })
  },
  { immediate: true }
)

onMounted(() => {
  if (!jurusanAktif.value) {
    document.title = 'Jurusan - SMK Nurul Jadid'
  }
})
</script>

<style lang="scss" scoped>
.detail-jurusan-page {
  min-height: 100vh;
  background: #f8f7fb;
}

.detail-jurusan-layout {
  max-width: 80rem;
  margin: 0 auto;
  padding: 2rem 1.5rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .detail-jurusan-layout {
    grid-template-columns: 1fr 320px;
    gap: 1.5rem;
  }
}

.detail-jurusan-main {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.detail-jurusan-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
  padding: 6rem 1rem;
  text-align: center;
}

.detail-jurusan-empty h1 {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.75rem;
  color: #0f172a;
  margin: 0;
}

.detail-jurusan-back {
  display: inline-flex;
  padding: 0.85rem 1.5rem;
  border-radius: 9999px;
  background: #042d86;
  color: #ffffff;
  font-weight: 800;
  text-decoration: none;
  transition: background 0.2s ease;
}

.detail-jurusan-back:hover {
  background: #032263;
}
</style>
