<template>
  <div class="detail-jurusan-page">
    <div v-if="jurusanAktif" class="detail-jurusan-layout">
      <div class="detail-jurusan-main">
        <JurusanHero :jurusan="jurusanAktif" />
        <KeunggulanProgram :keunggulan="jurusanAktif.keunggulan" />
      </div>
      <SidebarJurusan :jurusan-lainnya="jurusanLainnya" :current-slug="route.params.slug" />
    </div>
    <JalurKurikulum v-if="jurusanAktif" :kurikulum="jurusanAktif.kurikulum" />
    <FooterSection />

    <div v-if="!jurusanAktif" class="detail-jurusan-empty">
      <h1>Jurusan tidak ditemukan</h1>
      <router-link to="/jurusan" class="detail-jurusan-back">Kembali ke Semua Jurusan</router-link>
    </div>
  </div>
</template>

<script setup>
import { computed, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getJurusanBySlug, getJurusanLainnya } from '@/data/jurusan'
import JurusanHero from '../components/JurusanHero.vue'
import KeunggulanProgram from '../components/KeunggulanProgram.vue'
import SidebarJurusan from '../components/SidebarJurusan.vue'
import JalurKurikulum from '../components/JalurKurikulum.vue'
import FooterSection from '../../portal/components/FooterSection.vue'

const route = useRoute()

const jurusanAktif = computed(() => getJurusanBySlug(route.params.slug))
const jurusanLainnya = computed(() => getJurusanLainnya(route.params.slug))

watch(
  () => route.params.slug,
  (slug) => {
    const jurusan = getJurusanBySlug(slug)
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
