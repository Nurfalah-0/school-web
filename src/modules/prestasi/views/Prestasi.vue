<template>
  <div class="prestasi-page">
    <PrestasiHero :featured="featured" />
    <FilterPrestasi :aktif="kategoriAktif" @update:kategori="ubahFilter" />
    <GridPrestasi :items="daftarPrestasi" />
    <CtaKirimPrestasi />
    <FooterSection />
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getPrestasiFeatured, getAllPrestasi } from '@/data/prestasi'
import PrestasiHero from '../components/PrestasiHero.vue'
import FilterPrestasi from '../components/FilterPrestasi.vue'
import GridPrestasi from '../components/GridPrestasi.vue'
import CtaKirimPrestasi from '../components/CtaKirimPrestasi.vue'
import FooterSection from '../../portal/components/FooterSection.vue'

const route = useRoute()
const router = useRouter()

const kategoriAktif = ref(route.query.kategori || 'semua')

const featured = computed(() => getPrestasiFeatured())
const daftarPrestasi = computed(() => {
  const semua = getAllPrestasi()
  return kategoriAktif.value === 'semua' ? semua : semua.filter(p => p.kategori === kategoriAktif.value)
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
