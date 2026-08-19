<template>
  <div class="tefa-store-page">
    <TefaHero />
    <FilterKategori v-model:kategori="kategoriAktif" />
    <GridProduk :kategori-filter="kategoriAktif" @pilih-produk="pilihProduk" />
    <DetailProduk :produk="produkAktif || produkDefault" />
    <FooterSection />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useProdukAktif } from '../../../shared/composables/useProdukAktif'
import TefaHero from '../components/TefaHero.vue'
import FilterKategori from '../components/FilterKategori.vue'
import GridProduk from '../components/GridProduk.vue'
import DetailProduk from '../components/DetailProduk.vue'
import FooterSection from '../../portal/components/FooterSection.vue'

const { produkAktif, pilihProduk, reset } = useProdukAktif()

const kategoriAktif = ref('Semua Produk')

const produkDefault = {
  id: 1,
  nama: 'Custom Sports Jersey PRO',
  kategori: 'PERCETAKAN',
  rating: 4.9,
  ulasan: 128,
  harga: 145000,
  gambar: 'https://placehold.co/600x600/1e3a8a/ffffff?text=Custom+Sports+Jersey',
  deskripsi: 'Jersey kualitas premium hasil karya siswa Jurusan Teknik Komputer dan Jaringan bekerjasama dengan Multimedia. Didesain dengan teknologi sublimation printing terbaru untuk ketajaman warna yang tahan lama.',
  bahan: 'Dryfit Premium (Wicking Technology)',
  metodeCetak: 'Sublimasi Epson HD',
  jahitan: 'Double Stitches (Tahan Lama)',
  produksi: 'Siswa Multimedia & Tata Busana',
  ukuran: [
    { label: 'S', chest: 48, length: 68 },
    { label: 'M', chest: 50, length: 70 },
    { label: 'L', chest: 52, length: 72 },
    { label: 'XL', chest: 54, length: 74 }
  ]
}
</script>

<style lang="scss" scoped>
.tefa-store-page {
  min-height: 100vh;
  background: #ffffff;
}
</style>
