<template>
  <div class="tefa-store-page">
    <AnimateOnScroll animation="fadeInDown">
      <TefaHero />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="100">
      <FilterKategori v-model="kategoriAktif" @reset-filter="resetKategori" />
    </AnimateOnScroll>

    <!-- Cart Bar -->
    <div v-if="cart.length > 0" class="cart-bar">
      <div class="cart-bar-inner">
        <div class="cart-bar-info">
          <ShoppingCart :size="20" color="#1e3a8a" />
          <span class="cart-bar-count">{{ cartTotalQty }} item</span>
          <span class="cart-bar-separator">|</span>
          <span class="cart-bar-total">{{ formatRupiah(cartTotal) }}</span>
        </div>
        <button class="cart-bar-btn" @click="cartOpen = true">
          Lihat Keranjang
          <ChevronRight :size="18" color="#ffffff" />
        </button>
      </div>
    </div>

    <AnimateOnScroll animation="fadeInUp" :delay="200">
      <GridProduk
        id="produk"
        :kategori-filter="kategoriAktif"
        :items="allProducts"
        :loading="isLoading"
        @pilih-produk="handlePilihProduk"
        @tambah-keranjang="tambahKeKeranjang"
      />
    </AnimateOnScroll>

    <DetailProduk
      id="detail-produk-section"
      :produk="produkAktif || allProducts[0] || null"
    />

    <AnimateOnScroll animation="fadeInUp" :delay="250">
      <section id="portofolio" class="portofolio-section">
        <div class="portofolio-inner">
          <div class="portofolio-header">
            <span class="portofolio-label">JASA PROFESIONAL</span>
            <h2 class="portofolio-title">Portofolio Jasa</h2>
            <p class="portofolio-desc">Layanan profesional berbasis kompetensi siswa dan tenaga pengajar.</p>
          </div>
          <div class="portofolio-grid">
            <div v-for="item in portofolioList" :key="item.nama" class="portofolio-card">
              <div class="portofolio-icon" :style="{ background: item.bg }">
                <component :is="item.icon" :size="24" :color="item.color" />
              </div>
              <h3 class="portofolio-name">{{ item.nama }}</h3>
              <p class="portofolio-text">{{ item.deskripsi }}</p>
              <button class="portofolio-btn" type="button" @click="pesanJasa(item)">
                Pesan Jasa
                <ArrowRight :size="16" :color="item.color" />
              </button>
            </div>
          </div>
        </div>
      </section>
    </AnimateOnScroll>

    <!-- Floating Cart Button -->
    <button v-if="cart.length > 0" class="cart-fab" @click="cartOpen = true" aria-label="Buka keranjang">
      <ShoppingCart :size="23" color="#ffffff" />
      <span class="cart-fab-badge">{{ cartTotalQty }}</span>
    </button>

    <!-- Cart Overlay -->
    <div v-if="cartOpen" class="cart-overlay" @click="cartOpen = false"></div>

    <!-- Cart Sidebar -->
    <div class="cart-sidebar" :class="{ 'cart-sidebar--open': cartOpen }">
      <div class="cart-header">
        <h3 class="cart-title">Keranjang ({{ cart.length }})</h3>
        <button class="cart-close" @click="cartOpen = false" aria-label="Tutup keranjang">
          <X :size="20" color="#1e293b" />
        </button>
      </div>

      <div class="cart-items">
        <div v-if="cart.length === 0" class="cart-empty">
          <ShoppingCart :size="48" color="#d1d5db" />
          <p>Keranjang kosong</p>
        </div>
        <div v-for="item in cart" :key="item.id" class="cart-item">
          <img :src="item.gambar" :alt="item.nama" class="cart-item-img" />
          <div class="cart-item-info">
            <h4 class="cart-item-name">{{ item.nama }}</h4>
            <p class="cart-item-price">{{ formatRupiah(item.harga) }}</p>
            <div v-if="item.pilihan?.length" class="cart-item-options">
              <label v-for="option in item.pilihan" :key="option.name">
                <span>{{ option.name }}</span>
                <select v-model="item.selectedOptions[option.name]">
                  <option v-for="value in option.values" :key="value" :value="value">{{ value }}</option>
                </select>
              </label>
            </div>
            <div class="cart-item-qty">
              <button class="qty-btn" @click="kurangiQty(item)">-</button>
              <span class="qty-value">{{ item.qty }}</span>
              <button class="qty-btn" @click="tambahQty(item)">+</button>
            </div>
          </div>
          <button class="cart-item-remove" @click="hapusDariKeranjang(item)" aria-label="Hapus">
            <Trash2 :size="16" color="#ef4444" />
          </button>
        </div>
      </div>

      <div v-if="cart.length > 0" class="cart-footer">
        <div class="cart-total">
          <span>Total</span>
          <span class="cart-total-price">{{ formatRupiah(cartTotal) }}</span>
        </div>
        <button class="cart-checkout-btn" @click="checkoutWhatsApp">
          <MessageCircle :size="20" color="#ffffff" />
          Pesan via WhatsApp
        </button>
      </div>
    </div>

    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <FooterSection />
    </AnimateOnScroll>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { getPublicContent } from '@/api/endpoints'
import { mapProduct } from '@/modules/contentMapper'
import { useProdukAktif } from '@/shared/composables/useProdukAktif'
import TefaHero from '../components/TefaHero.vue'
import FilterKategori from '../components/FilterKategori.vue'
import GridProduk from '../components/GridProduk.vue'
import DetailProduk from '../components/DetailProduk.vue'
import FooterSection from '../../portal/components/FooterSection.vue'
import { X, Trash2, ShoppingCart, MessageCircle, ChevronRight, CodeXml, Palette, Megaphone, Wrench, ArrowRight } from 'lucide-vue-next'
import { formatRupiah } from '../../../shared/utils/formatRupiah'
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue'

const { produkAktif, pilihProduk } = useProdukAktif()

const kategoriAktif = ref('Semua Produk')
const allProducts = ref([])
const isLoading = ref(true)
const cartOpen = ref(false)
const cart = ref([])

const portofolioList = [
  {
    nama: 'Web Development',
    deskripsi: 'Website company profile, e-commerce, dan sistem informasi berbasis web.',
    icon: CodeXml,
    color: '#1e3a8a',
    bg: '#dbeafe'
  },
  {
    nama: 'Design Grafis',
    deskripsi: 'Branding, media sosial, packaging, dan materi cetak profesional.',
    icon: Palette,
    color: '#7e22ce',
    bg: '#f3e8ff'
  },
  {
    nama: 'Multimedia & Film',
    deskripsi: 'Produksi video, motion graphic, dan dokumentasi kegiatan sekolah.',
    icon: Megaphone,
    color: '#b45309',
    bg: '#fef3c7'
  },
  {
    nama: 'Teknik & Fabrikasi',
    deskripsi: 'Jasa perbaikan, modifikasi perangkat, dan produksi karya teknik.',
    icon: Wrench,
    color: '#047857',
    bg: '#d1fae5'
  }
]

function resetKategori() {
  kategoriAktif.value = 'Semua Produk'
}

function pesanJasa(item) {
  const phoneNumber = '6282335585491'
  const message = `Halo Admin Tefa Store! Saya tertarik dengan jasa: ${item.nama}. ${item.deskripsi} Mohon info lebih lanjut.`
  const waUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`
  window.open(waUrl, '_blank')
}

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

const cartTotalQty = computed(() => cart.value.reduce((sum, item) => sum + item.qty, 0))
const cartTotal = computed(() => cart.value.reduce((sum, item) => sum + item.harga * item.qty, 0))

function tambahKeKeranjang(produk) {
  const selectedOptions = Object.fromEntries((produk.pilihan || []).map(option => [option.name, option.values[0]]))
  const optionKey = JSON.stringify(selectedOptions)
  const existing = cart.value.find(item => item.id === produk.id && JSON.stringify(item.selectedOptions) === optionKey)
  if (existing) {
    existing.qty += 1
  } else {
    cart.value.push({ ...produk, selectedOptions, qty: 1 })
  }
  cartOpen.value = true
}

function kurangiQty(item) {
  if (item.qty > 1) {
    item.qty -= 1
  } else {
    hapusDariKeranjang(item)
  }
}

function tambahQty(item) {
  item.qty += 1
}

function hapusDariKeranjang(item) {
  const index = cart.value.findIndex(i => i.id === item.id)
  if (index > -1) {
    cart.value.splice(index, 1)
  }
}

function checkoutWhatsApp() {
  if (cart.value.length === 0) return

  const phoneNumber = '6282335585491'
  let message = 'Halo Admin Tefa Store SMK Nurul Jadid! Saya ingin memesan:\n\n'

  cart.value.forEach((item, index) => {
    message += `${index + 1}. ${item.nama}\n`
    if (item.selectedOptions && Object.keys(item.selectedOptions).length) {
      message += `   Pilihan: ${Object.entries(item.selectedOptions).map(([name, value]) => `${name}: ${value}`).join(', ')}\n`
    }
    message += `   Harga: ${formatRupiah(item.harga)}\n`
    message += `   Qty: ${item.qty}\n`
    message += `   Subtotal: ${formatRupiah(item.harga * item.qty)}\n\n`
  })

  message += `----------------------------\n`
  message += `Total Pesanan: ${formatRupiah(cartTotal.value)}\n\n`
  message += `Mohon info lebih lanjut untuk pembayaran dan pengiriman. Terima kasih!`

  const encodedMessage = encodeURIComponent(message)
  const waUrl = `https://wa.me/${phoneNumber}?text=${encodedMessage}`

  window.open(waUrl, '_blank')
}
</script>

<style lang="scss" scoped>
.tefa-store-page {
  min-height: 100vh;
  background: #ffffff;
}

/* Cart Bar */
.cart-bar {
  background: #ffffff;
  border-bottom: 1px solid #e5e7eb;
  padding: 12px 0;
  position: sticky;
  top: 0;
  z-index: 35;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

.cart-bar-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.cart-bar-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.cart-bar-count {
  font-weight: 700;
  font-size: 0.9rem;
  color: #1e293b;
}

.cart-bar-separator {
  color: #d1d5db;
  font-weight: 700;
}

.cart-bar-total {
  font-weight: 800;
  font-size: 1rem;
  color: #1e3a8a;
}

.cart-bar-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 10px 20px;
  border: none;
  border-radius: 9999px;
  background: #25d366;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background 0.2s ease;
  white-space: nowrap;
}

.cart-bar-btn:hover {
  background: #128c7e;
}

/* Cart Overlay */
.cart-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 40;
  transition: opacity 0.3s ease;
}

/* Cart Sidebar */
.cart-sidebar {
  position: fixed;
  top: 0;
  right: 0;
  width: 400px;
  max-width: 90vw;
  height: 100vh;
  background: #ffffff;
  box-shadow: -4px 0 20px rgba(0, 0, 0, 0.15);
  z-index: 50;
  transform: translateX(100%);
  transition: transform 0.3s ease;
  display: flex;
  flex-direction: column;
}

.cart-sidebar--open {
  transform: translateX(0);
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #e5e7eb;
}

.cart-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.cart-close {
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  display: grid;
  place-items: center;
}

.cart-items {
  flex: 1;
  overflow-y: auto;
  padding: 16px 24px;
}

.cart-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 48px 0;
  color: #9ca3af;
  text-align: center;
}

.cart-empty p {
  margin: 0;
  font-size: 0.95rem;
  color: #6b7280;
}

.cart-item {
  display: flex;
  gap: 12px;
  padding: 16px 0;
  border-bottom: 1px solid #f1f5f9;
}

.cart-item-img {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  object-fit: cover;
  flex-shrink: 0;
}

.cart-item-info {
  flex: 1;
  min-width: 0;
}

.cart-item-name {
  font-weight: 700;
  font-size: 0.9rem;
  color: #0f172a;
  margin: 0 0 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.cart-item-price {
  font-size: 0.85rem;
  color: #64748b;
  margin: 0 0 8px;
}

.cart-item-options {
  display: grid;
  gap: 6px;
  margin: 8px 0 10px;
}

.cart-item-options label {
  display: grid;
  grid-template-columns: 64px 1fr;
  align-items: center;
  gap: 6px;
  font-size: 0.75rem;
  color: #64748b;
}

.cart-item-options select {
  min-width: 0;
  padding: 5px 7px;
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  background: #ffffff;
  color: #1e293b;
  font-size: 0.78rem;
}

.cart-item-qty {
  display: flex;
  align-items: center;
  gap: 8px;
}

.qty-btn {
  width: 28px;
  height: 28px;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  background: #ffffff;
  cursor: pointer;
  font-weight: 700;
  color: #1e293b;
  display: grid;
  place-items: center;
  transition: all 0.2s ease;
}

.qty-btn:hover {
  background: #f3f4ff;
  border-color: #1e3a8a;
}

.qty-value {
  font-weight: 700;
  font-size: 0.9rem;
  color: #1e293b;
  min-width: 24px;
  text-align: center;
}

.cart-item-remove {
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  display: grid;
  place-items: center;
  align-self: flex-start;
}

.cart-footer {
  padding: 20px 24px;
  border-top: 1px solid #e5e7eb;
  background: #ffffff;
}

.cart-total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  font-weight: 700;
  font-size: 1.1rem;
  color: #0f172a;
}

.cart-total-price {
  color: #1e3a8a;
  font-size: 1.25rem;
}

.cart-checkout-btn {
  width: 100%;
  padding: 14px;
  border: none;
  border-radius: 12px;
  background: #25d366;
  color: #ffffff;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: background 0.2s ease;
}

.cart-checkout-btn:hover {
  background: #128c7e;
}

/* Responsive */
@media (max-width: 639px) {
  .cart-sidebar {
    width: 100%;
    max-width: 100%;
  }

  .cart-bar-inner {
    flex-direction: column;
    align-items: stretch;
  }

  .cart-bar-btn {
    justify-content: center;
  }
}

/* Floating Cart Button */
.cart-fab {
  position: fixed;
  bottom: 24px;
  left: 24px;
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  border: none;
  box-shadow: 0 8px 24px rgba(245, 158, 11, 0.4);
  cursor: pointer;
  display: grid;
  place-items: center;
  z-index: 30;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.cart-fab:hover {
  transform: scale(1.05);
  box-shadow: 0 12px 32px rgba(245, 158, 11, 0.5);
}

.cart-fab-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: #ef4444;
  color: #ffffff;
  font-size: 0.75rem;
  font-weight: 800;
  display: grid;
  place-items: center;
}

/* Portofolio Section */
.portofolio-section {
  background: #ffffff;
  padding: 4rem 0;
  border-top: 1px solid #e5e7eb;
}

.portofolio-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.portofolio-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.portofolio-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #b45309;
  margin-bottom: 0.5rem;
}

.portofolio-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.5rem, 2.5vw, 2rem);
  color: #0f172a;
  margin: 0;
}

.portofolio-desc {
  color: #475569;
  margin: 0.5rem 0 0;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

.portofolio-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .portofolio-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .portofolio-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 2rem;
  }
}

.portofolio-card {
  border: 1px solid #e2e8f0;
  border-radius: 1.25rem;
  padding: 1.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  background: #ffffff;
  transition: box-shadow 0.2s ease, transform 0.2s ease;
}

.portofolio-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
}

.portofolio-icon {
  width: 3rem;
  height: 3rem;
  border-radius: 1rem;
  display: grid;
  place-items: center;
}

.portofolio-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.1rem;
  color: #0f172a;
  margin: 0;
}

.portofolio-text {
  color: #475569;
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0;
  flex: 1;
}

.portofolio-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  width: 100%;
  padding: 0.85rem;
  border-radius: 9999px;
  border: none;
  background: #042d86;
  color: #ffffff;
  font-weight: 800;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.portofolio-btn:hover {
  background: #032263;
}
</style>
