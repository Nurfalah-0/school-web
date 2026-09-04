<template>
  <div class="prestasi-page">
    <AnimateOnScroll animation="fadeInDown">
      <PrestasiHero :featured="featured" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="100">
      <FilterPrestasi :aktif="kategoriAktif" @update:kategori="ubahFilter" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="200">
      <GridPrestasi :items="daftarPrestasi" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <CtaKirimPrestasi />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="400">
      <FooterSection />
    </AnimateOnScroll>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getPublicContent } from '@/api/endpoints'
import { mapAchievement } from '@/modules/contentMapper'
import PrestasiHero from '../components/PrestasiHero.vue'
import FilterPrestasi from '../components/FilterPrestasi.vue'
import GridPrestasi from '../components/GridPrestasi.vue'
import CtaKirimPrestasi from '../components/CtaKirimPrestasi.vue'
import FooterSection from '../../portal/components/FooterSection.vue'
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue'

const route = useRoute()
const router = useRouter()

const kategoriAktif = ref(route.query.kategori || 'semua')

const items = ref([])
const featured = computed(() => items.value.find(item => item.featured) || items.value[0])
const daftarPrestasi = computed(() => {
  const semua = items.value
  return kategoriAktif.value === 'semua' ? semua : semua.filter(p => p.kategori === kategoriAktif.value)
})
onMounted(async () => {
  try {
    const response = await getPublicContent('achievements')
    const fetched = (response.data?.data || []).map(mapAchievement)
    if (fetched.length > 0) {
      items.value = fetched
    }
  } catch (err) {
    console.warn('Gagal memuat prestasi dari API:', err)
  }
})

function ubahFilter(kategori) {
  kategoriAktif.value = kategori
  router.replace({ query: kategori === 'semua' ? {} : { kategori } })
}

watch(() => route.query.kategori, (val) => {
  kategoriAktif.value = val || 'semua'
})
</script>

<style lang="scss" scoped>
.prestasi-page {
  min-height: 100vh;
  background: #f8f7fb;
}
</style>
