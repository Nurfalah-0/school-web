<template>
  <div class="tefa-store-page">
    <TefaHero />
    <FilterKategori v-model:kategori="kategoriAktif" />
    <GridProduk
      :kategori-filter="kategoriAktif"
      :items="allProducts"
      :loading="isLoading"
      @pilih-produk="handlePilihProduk"
    />
    <DetailProduk
      id="detail-produk-section"
      :produk="produkAktif || allProducts[0] || null"
    />
    <FooterSection />
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { getPublicContent } from '@/api/endpoints'
import { mapProduct } from '@/modules/contentMapper'
import { useProdukAktif } from '@/shared/composables/useProdukAktif'
import TefaHero from '../components/TefaHero.vue'
import FilterKategori from '../components/FilterKategori.vue'
import GridProduk from '../components/GridProduk.vue'
import DetailProduk from '../components/DetailProduk.vue'
import FooterSection from '../../portal/components/FooterSection.vue'

const { produkAktif, pilihProduk } = useProdukAktif()

const kategoriAktif = ref('Semua Produk')
const allProducts = ref([])
const isLoading = ref(true)

const fallbackProducts = [
  {
    id: 1,
    nama: 'Custom Sports Jersey PRO',
    kategori: 'Percetakan',
    rating: 4.9,
    ulasan: 128,
    harga: 145000,
    gambar: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&q=80',
    deskripsi: 'Jersey kualitas premium hasil karya siswa Jurusan Teknik Komputer dan Jaringan bekerjasama dengan Multimedia. Didesain dengan teknologi sublimation printing terbaru untuk ketajaman warna yang tahan lama.'
  },
  {
    id: 2,
    nama: '3D Printed Geometric Lamp',
    kategori: 'Produk Kreatif',
    rating: 4.7,
    ulasan: 56,
    harga: 299000,
    gambar: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=800&q=80',
    deskripsi: 'Lampu hias geometris modern berbahan filament ramah lingkungan, diproduksi menggunakan printer 3D presisi tinggi oleh siswa Teknik Otomasi & Elektronika.'
  },
  {
    id: 3,
    nama: 'Paket Branding & Identitas Bisnis',
    kategori: 'Design Grafis',
    rating: 5.0,
    ulasan: 89,
    harga: 1500000,
    gambar: 'https://images.unsplash.com/photo-1542744094-3a31f272c490?w=800&q=80',
    deskripsi: 'Paket lengkap desain logo, kartu nama, kop surat, profil perusahaan, dan brand guideline eksklusif standar profesional untuk UMKM & korporat.'
  },
  {
    id: 4,
    nama: 'Video Company Profile & Iklan (30s)',
    kategori: 'Multimedia',
    rating: 4.8,
    ulasan: 42,
    harga: 750000,
    gambar: 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?w=800&q=80',
    deskripsi: 'Produksi video sinematik dengan peralatan kamera 4K dan drone oleh tim Multimedia untuk kebutuhan promosi media sosial perusahaan Anda.'
  }
]

onMounted(async () => {
  isLoading.value = true
  try {
    const response = await getPublicContent('products')
    const fetched = (response.data?.data || []).map(mapProduct)
    if (fetched.length > 0) {
      allProducts.value = fetched
      produkAktif.value = fetched[0]
    } else {
      allProducts.value = fallbackProducts
      produkAktif.value = fallbackProducts[0]
    }
  } catch (err) {
    allProducts.value = fallbackProducts
    produkAktif.value = fallbackProducts[0]
  } finally {
    isLoading.value = false
  }
})

function handlePilihProduk(item) {
  pilihProduk(item)
  nextTick(() => {
    const el = document.getElementById('detail-produk-section')
    if (el) {
      el.scrollIntoView({ behavior: 'smooth' })
    }
  })
}
</script>

<style lang="scss" scoped>
.tefa-store-page {
  min-height: 100vh;
  background: #ffffff;
}
</style>
