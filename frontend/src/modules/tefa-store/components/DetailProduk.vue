<template>
  <section class="detail-section" id="detail-produk-section" v-if="displayProduk">
    <div class="detail-inner">
      <div class="detail-grid">
        <!-- Image display -->
        <div class="detail-galeri">
          <div class="detail-thumbs" v-if="allThumbnails.length > 1">
            <button
              v-for="(img, idx) in allThumbnails"
              :key="idx"
              :class="['detail-thumb', { active: thumbnailAktif === idx }]"
              type="button"
              @click="thumbnailAktif = idx"
            >
              <img :src="img" :alt="`${displayProduk.nama} thumbnail ${idx + 1}`" loading="lazy" @error="onImgError" />
            </button>
          </div>
          <div class="detail-main-img">
            <img :src="currentImage" :alt="displayProduk.nama" loading="eager" @error="onImgError" />
          </div>
        </div>

        <!-- Product info & action -->
        <div class="detail-info">
          <div class="detail-meta">
            <span class="detail-stock">READY STOCK</span>
            <span class="detail-sku" v-if="displayProduk.id">SKU: TEFA-{{ String(displayProduk.id).padStart(3, '0') }}</span>
          </div>

          <h1 class="detail-nama">{{ displayProduk.nama }}</h1>

          <div class="detail-rating-row">
            <span class="detail-harga">{{ formatRupiah(displayProduk.harga || 0) }}</span>
            <span class="detail-rating-badge">
              <Star :size="14" color="#f59e0b" fill="#f59e0b" />
              {{ displayProduk.rating || '5.0' }} ({{ displayProduk.ulasan || 18 }} ulasan)
            </span>
          </div>

          <p class="detail-deskripsi">{{ displayProduk.deskripsi || 'Produk Teaching Factory (TEFA) unggulan berkualitas tinggi karya peserta didik SMK Nurul Jadid dengan standar industri.' }}</p>

          <div class="detail-size" v-for="option in optionGroups" :key="option.name">
            <span class="detail-size-label">{{ option.name }}:</span>
            <div class="detail-size-options">
              <button
                v-for="value in option.values"
                :key="value"
                :class="['detail-size-btn', { active: selectedOptions[option.name] === value }]"
                type="button"
                @click="selectedOptions[option.name] = value"
              >
                {{ value }}
              </button>
            </div>
          </div>

          <!-- Price & Order config box -->
          <div class="detail-config">
            <div class="detail-config-header">
              <span class="detail-config-title">Konfigurasi Pemesanan</span>
              <div class="detail-stepper">
                <button type="button" class="stepper-btn" @click="quantity = Math.max(1, quantity - 1)">
                  <Minus :size="16" />
                </button>
                <span class="stepper-value">{{ quantity }}</span>
                <button type="button" class="stepper-btn" @click="quantity = quantity + 1">
                  <Plus :size="16" />
                </button>
              </div>
            </div>

            <div class="detail-config-row">
              <span>Harga Satuan</span>
              <strong>{{ formatRupiah(displayProduk.harga || 0) }}</strong>
            </div>

            <div class="detail-config-row">
              <span>Jumlah Item</span>
              <strong>{{ quantity }} pcs</strong>
            </div>

            <div class="detail-config-row detail-config-total">
              <span>Total Estimasi</span>
              <strong>{{ formatRupiah(totalEstimasi) }}</strong>
            </div>

            <button class="detail-btn-primary" type="button" @click="pesanSekarang">
              <ShoppingBag :size="18" />
              Pesan Sekarang
            </button>
            <a :href="whatsappUrl" target="_blank" rel="noopener" class="detail-btn-whatsapp">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="display:block"><path d="M12.04 2c-5.46 0-9.91 4.45-9.91 9.91 0 1.75.46 3.45 1.32 4.95L2.05 22l5.25-1.38c1.45.79 3.08 1.21 4.74 1.21 5.46 0 9.91-4.45 9.91-9.91 0-2.65-1.03-5.14-2.9-7.01A9.816 9.816 0 0 0 12.04 2m.01 1.67c2.2 0 4.26.86 5.82 2.42a8.225 8.225 0 0 1 2.41 5.83c0 4.54-3.7 8.24-8.24 8.24-1.48 0-2.93-.4-4.2-1.15l-.3-.18-3.12.82.83-3.04-.2-.31a8.196 8.196 0 0 1-1.26-4.38c0-4.54 3.7-8.24 8.24-8.24m4.52 11.66c-.25-.13-1.47-.72-1.7-.81-.23-.08-.39-.13-.56.13-.17.25-.64.81-.79.97-.14.17-.29.19-.54.06-.25-.13-1.06-.39-2.03-1.25-.75-.67-1.26-1.5-1.41-1.75-.14-.25-.02-.39.11-.51.11-.11.25-.29.37-.44.13-.14.17-.25.25-.42.08-.17.04-.31-.02-.44-.06-.13-.56-1.34-.76-1.84-.2-.48-.41-.42-.56-.43h-.48c-.17 0-.44.06-.67.31-.23.25-.88.86-.88 2.1 0 1.24.9 2.44 1.03 2.61.13.17 1.77 2.7 4.29 3.79.6.26 1.07.41 1.44.53.6.19 1.15.16 1.58.1.48-.07 1.47-.6 1.68-1.18.21-.58.21-1.07.15-1.18-.06-.11-.23-.17-.48-.3Z"/></svg>
              Konsultasi WhatsApp
            </a>
          </div>
        </div>
      </div>

      <!-- Specs and Tabs -->
      <div class="detail-tabs">
        <div class="detail-tab-headers">
          <button
            :class="['detail-tab-btn', { active: tabAktif === 'spesifikasi' }]"
            type="button"
            @click="tabAktif = 'spesifikasi'"
          >
            Spesifikasi Lengkap
          </button>
          <button
            :class="['detail-tab-btn', { active: tabAktif === 'ulasan' }]"
            type="button"
            @click="tabAktif = 'ulasan'"
          >
            Ulasan Pembeli
          </button>
        </div>
        <div class="detail-tab-line"></div>

        <div v-if="tabAktif === 'spesifikasi'" class="detail-tab-content">
          <div class="detail-spec-grid">
            <div class="detail-spec-card">
              <h3 class="detail-spec-title">Detail & Standar Produksi</h3>
              <div class="detail-spec-row">
                <span>Unit Produksi</span>
                <strong>TEFA SMK Nurul Jadid</strong>
              </div>
              <div class="detail-spec-row">
                <span>Kategori</span>
                <strong>{{ displayProduk.kategori || 'Produk Kreatif' }}</strong>
              </div>
              <div class="detail-spec-row">
                <span>Standar Mutu</span>
                <strong>SOP Industri Terverifikasi</strong>
              </div>
              <div class="detail-spec-row">
                <span>Garansi</span>
                <strong>Jaminan Kualitas 100%</strong>
              </div>
            </div>

            <div class="detail-spec-card" v-if="sizeList.length > 0">
              <h3 class="detail-spec-title">Panduan Ukuran (cm)</h3>
              <div class="detail-size-table-wrap">
                <table class="detail-size-table">
                  <thead>
                    <tr>
                      <th>Ukuran</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="u in sizeList" :key="u.label">
                      <td><strong>{{ u.label }}</strong></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <div class="detail-spec-card" v-else>
              <h3 class="detail-spec-title">Layanan Kustomisasi</h3>
              <p style="color: #64748b; font-size: 0.9rem; line-height: 1.6; margin: 0;">
                Menerima pesanan dalam jumlah satuan maupun partai besar/grosir untuk instansi, perusahaan, dan perorangan dengan penawaran harga khusus.
              </p>
            </div>
          </div>
        </div>

        <div v-else class="detail-tab-content">
          <div class="detail-empty">
            <p><Star :size="16" color="#f59e0b" fill="#f59e0b" style="display: inline-block; vertical-align: middle; margin-right: 4px;" /> <strong>4.9 / 5.0</strong> — Produk ini mendapatkan ulasan sangat memuaskan dari konsumen.</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Success Order Alert / Modal -->
    <div v-if="showSuccessModal" class="order-modal-backdrop" @click="showSuccessModal = false">
      <div class="order-modal-card" @click.stop>
        <div class="modal-icon"><CheckCircle2 :size="48" color="#10b981" /></div>
        <h3>Pesanan Disiapkan!</h3>
        <p>Anda memesan <strong>{{ quantity }}x {{ displayProduk.nama }}</strong> (Total: {{ formatRupiah(totalEstimasi) }}).</p>
        <p class="modal-sub">Silakan hubungi WhatsApp CS kami untuk konfirmasi alamat dan metode pembayaran.</p>
        <div class="modal-actions">
          <a :href="whatsappUrl" target="_blank" rel="noopener" class="modal-btn-wa" @click="showSuccessModal = false">
            Lanjut ke WhatsApp
          </a>
          <button class="modal-btn-close" @click="showSuccessModal = false">Tutup</button>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { Star, Minus, Plus, ShoppingBag, CheckCircle2 } from 'lucide-vue-next'
import { formatRupiah } from '../../../shared/utils/formatRupiah'

const props = defineProps({
  produk: {
    type: Object,
    default: null
  }
})

const selectedOptions = ref({})
const quantity = ref(1)
const tabAktif = ref('spesifikasi')
const thumbnailAktif = ref(0)
const showSuccessModal = ref(false)

const displayProduk = computed(() => {
  return props.produk || {
    id: 1,
    nama: 'Custom Sports Jersey PRO',
    kategori: 'PERCETAKAN',
    rating: 4.9,
    ulasan: 128,
    harga: 145000,
    gambar: 'https://placehold.co/600x600/1e3a8a/ffffff?text=Custom+Sports+Jersey',
    deskripsi: 'Jersey kualitas premium hasil karya siswa Jurusan Teknik Komputer dan Jaringan bekerjasama dengan Multimedia. Didesain dengan teknologi sublimation printing terbaru untuk ketajaman warna yang tahan lama.'
  }
})

const optionGroups = computed(() => Array.isArray(displayProduk.value.pilihan) ? displayProduk.value.pilihan.filter(option => option.name && option.values?.length) : [])
const sizeList = computed(() => {
  const option = optionGroups.value.find(item => /ukuran|size/i.test(item.name))
  return option ? option.values.map(label => ({ label })) : []
})

const allThumbnails = computed(() => {
  if (!displayProduk.value?.gambar) return []
  return [displayProduk.value.gambar]
})

const currentImage = computed(() => {
  if (allThumbnails.value.length && allThumbnails.value[thumbnailAktif.value]) {
    return allThumbnails.value[thumbnailAktif.value]
  }
  return displayProduk.value?.gambar || 'https://placehold.co/600x600/1e3a8a/ffffff?text=Produk+TEFA'
})

const totalEstimasi = computed(() => {
  const price = Number(displayProduk.value.harga) || 0
  return price * quantity.value
})

const whatsappUrl = computed(() => {
  const p = displayProduk.value
  const text = encodeURIComponent(
    `Halo Admin TEFA SMK Nurul Jadid, saya berminat memesan:\n\n*Produk:* ${p.nama}\n*Jumlah:* ${quantity.value} pcs\n${Object.entries(selectedOptions.value).map(([name, value]) => `*${name}:* ${value}`).join('\\n')}\n*Total Estimasi:* ${formatRupiah(totalEstimasi.value)}\n\nMohon info ketersediaan dan cara pembayarannya. Terima kasih!`
  )
  return `https://wa.me/6282335585491?text=${text}`
})

function pesanSekarang() {
  showSuccessModal.value = true
}

function onImgError(e) {
  e.target.src = 'https://placehold.co/600x600/1e3a8a/ffffff?text=Produk+TEFA'
}

watch(() => props.produk, () => {
  quantity.value = 1
  thumbnailAktif.value = 0
  selectedOptions.value = Object.fromEntries(optionGroups.value.map(option => [option.name, option.values[0]]))
}, { immediate: true })
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.detail-section {
  background: #ffffff;
  padding: 3rem 0 4rem;
  scroll-margin-top: 5rem;
}

.detail-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.detail-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2.5rem;
}

@media (min-width: 1024px) {
  .detail-grid {
    grid-template-columns: 1fr 1fr;
    gap: 4rem;
  }
}

.detail-galeri {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

@media (min-width: 1024px) {
  .detail-galeri {
    flex-direction: row;
    gap: 1rem;
  }
}

.detail-thumbs {
  display: flex;
  flex-direction: row;
  gap: 0.75rem;
  overflow-x: auto;
}

@media (min-width: 1024px) {
  .detail-thumbs {
    flex-direction: column;
    overflow-x: visible;
    width: 4rem;
    flex-shrink: 0;
  }
}

.detail-thumb {
  width: 4rem;
  height: 4rem;
  flex-shrink: 0;
  border-radius: 12px;
  overflow: hidden;
  border: 2px solid transparent;
  background: transparent;
  padding: 0;
  cursor: pointer;
  transition: border-color 0.2s ease;

  &.active {
    border-color: $brand;
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }
}

.detail-main-img {
  flex: 1;
  border-radius: 24px;
  overflow: hidden;
  background: #f1f5f9;
  border: 1px solid #e2e8f0;

  img {
    width: 100%;
    height: auto;
    aspect-ratio: 4 / 4;
    object-fit: cover;
    display: block;
  }
}

.detail-info {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.detail-meta {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.detail-stock {
  display: inline-flex;
  padding: 0.35rem 0.85rem;
  border-radius: 9999px;
  background: #dcfce7;
  color: #166534;
  font-size: 0.75rem;
  font-weight: 800;
  letter-spacing: 0.04em;
}

.detail-sku {
  color: #64748b;
  font-size: 0.85rem;
}

.detail-nama {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.5rem, 2.5vw, 2rem);
  color: #0f172a;
  margin: 0;
  line-height: 1.2;
}

.detail-rating-row {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.detail-harga {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(1.75rem, 3vw, 2.5rem);
  color: #042d86;
}

.detail-rating-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.4rem 0.75rem;
  border-radius: 9999px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  font-weight: 800;
  font-size: 0.9rem;
  color: #0f172a;
}

.detail-deskripsi {
  color: #475569;
  font-size: 0.95rem;
  line-height: 1.75;
  margin: 0;
}

.detail-size {
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.detail-size-label {
  font-weight: 800;
  font-size: 0.9rem;
  color: #0f172a;
}

.detail-size-options {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.detail-size-btn {
  min-width: 3rem;
  padding: 0.6rem 1rem;
  border-radius: 12px;
  border: 1px solid #cbd5e1;
  background: #ffffff;
  color: #334155;
  font-weight: 700;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    border-color: #94a3b8;
  }

  &.active {
    background: $brand;
    color: #ffffff;
    border-color: $brand;
  }
}

.detail-config {
  margin-top: 0.5rem;
  background: #f0fdf4;
  border: 1.5px solid #bbf7d0;
  border-radius: 20px;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.detail-config-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-config-title {
  font-weight: 800;
  font-size: 1rem;
  color: #0f172a;
}

.detail-stepper {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.stepper-btn {
  width: 2rem;
  height: 2rem;
  display: grid;
  place-items: center;
  border: 1px solid #cbd5e1;
  border-radius: 9999px;
  background: #ffffff;
  color: #0f172a;
  cursor: pointer;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  transition: background 0.2s ease;

  &:hover {
    background: #f1f5f9;
  }
}

.stepper-value {
  font-weight: 800;
  font-size: 1rem;
  min-width: 1.5rem;
  text-align: center;
  color: #0f172a;
}

.detail-config-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.9rem;
  color: #475569;

  strong {
    color: #0f172a;
    font-weight: 800;
  }
}

.detail-config-total {
  padding-top: 0.75rem;
  margin-top: 0.25rem;
  border-top: 1px solid rgba(15, 23, 42, 0.08);
  font-size: 1rem;
  color: #0f172a;

  strong {
    font-size: 1.5rem;
    color: #042d86;
  }
}

.detail-btn-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  width: 100%;
  padding: 1rem;
  border: none;
  border-radius: 14px;
  background: #042d86;
  color: #ffffff;
  font-weight: 800;
  font-size: 1rem;
  cursor: pointer;
  box-shadow: 0 10px 24px rgba(4, 45, 134, 0.25);
  transition: all 0.2s ease;

  &:hover {
    background: #03348f;
    transform: translateY(-1px);
  }
}

.detail-btn-whatsapp {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  width: 100%;
  padding: 1rem;
  border: 1.5px solid #10b981;
  border-radius: 14px;
  background: #ffffff;
  color: #059669;
  font-weight: 800;
  font-size: 1rem;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    background: #ecfdf5;
  }
}

.detail-tabs {
  margin-top: 4rem;
}

.detail-tab-headers {
  display: flex;
  gap: 2rem;
}

.detail-tab-btn {
  background: transparent;
  border: none;
  padding: 0.75rem 0;
  font-weight: 700;
  font-size: 1rem;
  color: #64748b;
  cursor: pointer;
  position: relative;
  transition: color 0.2s ease;

  &.active {
    color: #042d86;
    font-weight: 800;

    &::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: #042d86;
      border-radius: 9999px;
    }
  }
}

.detail-tab-line {
  height: 1px;
  background: #e2e8f0;
  margin-top: 0.5rem;
}

.detail-tab-content {
  padding-top: 2rem;
}

.detail-spec-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
}

@media (min-width: 768px) {
  .detail-spec-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 3rem;
  }
}

.detail-spec-card {
  background: #ffffff;
  border: 1px solid $border;
  border-radius: 20px;
  padding: 1.5rem;
}

.detail-spec-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.1rem;
  color: #0f172a;
  margin: 0 0 1.25rem;
}

.detail-spec-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.85rem 0;
  border-bottom: 1px solid #f1f5f9;

  &:last-child {
    border-bottom: none;
  }

  span {
    color: #64748b;
    font-size: 0.9rem;
  }

  strong {
    color: #042d86;
    font-weight: 700;
    font-size: 0.9rem;
    text-align: right;
    max-width: 60%;
  }
}

.detail-size-table-wrap {
  overflow-x: auto;
}

.detail-size-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9rem;

  th {
    background: #eef2ff;
    color: #0f172a;
    font-weight: 700;
    padding: 0.75rem 1rem;
    text-align: left;
  }

  td {
    padding: 0.75rem 1rem;
    border-bottom: 1px solid #f1f5f9;
    color: #334155;
  }
}

.detail-empty {
  text-align: center;
  padding: 3rem 1rem;
  color: #64748b;
}

/* Modal */
.order-modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
  padding: 1rem;
}

.order-modal-card {
  background: #ffffff;
  border-radius: 24px;
  padding: 2rem;
  max-width: 440px;
  width: 100%;
  text-align: center;
  box-shadow: 0 20px 40px rgba(0,0,0,0.2);

  .modal-icon {
    font-size: 3rem;
    margin-bottom: 0.5rem;
  }

  h3 {
    font-size: 1.35rem;
    font-weight: 800;
    color: #0f172a;
    margin: 0 0 0.5rem;
  }

  p {
    font-size: 0.95rem;
    color: #334155;
    margin: 0 0 0.5rem;
  }

  .modal-sub {
    font-size: 0.85rem;
    color: #64748b;
    margin-bottom: 1.5rem;
  }

  .modal-actions {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  }

  .modal-btn-wa {
    display: block;
    padding: 0.875rem;
    background: #059669;
    color: #ffffff;
    font-weight: 700;
    border-radius: 12px;
    text-decoration: none;
    transition: background 0.2s;

    &:hover { background: #047857; }
  }

  .modal-btn-close {
    padding: 0.75rem;
    background: #f1f5f9;
    border: none;
    border-radius: 12px;
    color: #475569;
    font-weight: 600;
    cursor: pointer;

    &:hover { background: #e2e8f0; }
  }
}
</style>
