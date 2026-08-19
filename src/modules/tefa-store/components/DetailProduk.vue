<template>
  <section class="detail-section" v-if="produk">
    <div class="detail-inner">
      <div class="detail-grid">
        <div class="detail-galeri">
          <div class="detail-thumbs">
            <button
              v-for="(img, idx) in thumbnails"
              :key="idx"
              :class="['detail-thumb', { active: thumbnailAktif === idx }]"
              type="button"
              @click="thumbnailAktif = idx"
            >
              <img :src="img" :alt="`${produk.nama} thumbnail ${idx + 1}`" loading="lazy" />
            </button>
          </div>
          <div class="detail-main-img">
            <img :src="thumbnails[thumbnailAktif]" :alt="produk.nama" loading="eager" />
          </div>
        </div>

        <div class="detail-info">
          <div class="detail-meta">
            <span class="detail-stock">READY STOCK</span>
            <span class="detail-sku">SKU: TEFA-PRT-001</span>
          </div>

          <h1 class="detail-nama">{{ produk.nama }}</h1>

          <div class="detail-rating-row">
            <span class="detail-harga">{{ formatRupiah(produk.harga) }}</span>
            <span class="detail-rating-badge">
              <Star :size="14" color="#f59e0b" fill="#f59e0b" />
              {{ produk.rating }}
            </span>
          </div>

          <p class="detail-deskripsi">{{ produk.deskripsi }}</p>

          <div class="detail-size">
            <span class="detail-size-label">Pilih Ukuran:</span>
            <div class="detail-size-options">
              <button
                v-for="u in produk.ukuran"
                :key="u.label"
                :class="['detail-size-btn', { active: ukuranTerpilih === u.label }]"
                type="button"
                @click="ukuranTerpilih = u.label"
              >
                {{ u.label }}
              </button>
            </div>
          </div>

          <div class="detail-config">
            <div class="detail-config-header">
              <span class="detail-config-title">Konfigurasi Pesanan</span>
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
              <strong>{{ formatRupiah(produk.harga) }}</strong>
            </div>

            <div class="detail-config-row">
              <span>Pajak (PPN 11%)</span>
              <strong>{{ formatRupiah(pajak) }}</strong>
            </div>

            <div class="detail-config-row detail-config-total">
              <span>Total Estimasi</span>
              <strong>{{ formatRupiah(totalEstimasi) }}</strong>
            </div>

            <button class="detail-btn-primary" type="button">
              <ShoppingBag :size="18" />
              Pesan Sekarang
            </button>
            <button class="detail-btn-whatsapp" type="button">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:block"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></svg>
              Tanya Penjual (WhatsApp)
            </button>
          </div>
        </div>
      </div>

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
              <h3 class="detail-spec-title">Detail Material</h3>
              <div class="detail-spec-row">
                <span>Bahan</span>
                <strong>{{ produk.bahan }}</strong>
              </div>
              <div class="detail-spec-row">
                <span>Metode Cetak</span>
                <strong>{{ produk.metodeCetak }}</strong>
              </div>
              <div class="detail-spec-row">
                <span>Jahitan</span>
                <strong>{{ produk.jahitan }}</strong>
              </div>
              <div class="detail-spec-row">
                <span>Produksi</span>
                <strong>{{ produk.produksi }}</strong>
              </div>
            </div>

            <div class="detail-spec-card">
              <h3 class="detail-spec-title">Panduan Ukuran (cm)</h3>
              <div class="detail-size-table-wrap">
                <table class="detail-size-table">
                  <thead>
                    <tr>
                      <th>Ukuran</th>
                      <th>Lebar Dada</th>
                      <th>Panjang Baju</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="u in produk.ukuran" :key="u.label">
                      <td><strong>{{ u.label }}</strong></td>
                      <td>{{ u.chest }}</td>
                      <td>{{ u.length }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="detail-tab-content">
          <div class="detail-empty">
            <p>Belum ada ulasan untuk produk ini.</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Star, Minus, Plus, ShoppingBag } from 'lucide-vue-next'
import { formatRupiah } from '../../../shared/utils/formatRupiah'

const props = defineProps({
  produk: {
    type: Object,
    default: null
  }
})

const ukuranTerpilih = ref('M')
const quantity = ref(1)
const tabAktif = ref('spesifikasi')
const thumbnailAktif = ref(0)

const thumbnails = [
  'https://placehold.co/600x750/1e3a8a/ffffff?text=Jersey+Custom+TEFA',
  'https://placehold.co/600x750/0f172a/ffffff?text=Detail+Front',
  'https://placehold.co/600x750/1e3a8a/ffffff?text=Detail+Back',
  'https://placehold.co/600x750/0f172a/ffffff?text=Studio+Shot'
]

const pajak = computed(() => Math.round(props.produk.harga * 0.11))
const totalEstimasi = computed(() => (props.produk.harga * quantity.value) + pajak.value)
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.detail-section {
  background: #ffffff;
  padding: 3rem 0 4rem;
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
}

@media (min-width: 1024px) {
  .detail-thumb {
    width: 100%;
    height: auto;
    aspect-ratio: 1;
  }
}

.detail-thumb.active {
  border-color: $brand;
}

.detail-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.detail-main-img {
  flex: 1;
  border-radius: 20px;
  overflow: hidden;
  background: #f1f5f9;
}

.detail-main-img img {
  width: 100%;
  height: auto;
  aspect-ratio: 4 / 5;
  object-fit: cover;
  display: block;
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
}

.detail-size-btn:hover {
  border-color: #94a3b8;
}

.detail-size-btn.active {
  background: $brand;
  color: #ffffff;
  border-color: $brand;
}

.detail-config {
  margin-top: 0.5rem;
  background: #ccfbf1;
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
  border: none;
  border-radius: 9999px;
  background: #ffffff;
  color: #0f172a;
  cursor: pointer;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  transition: background 0.2s ease;
}

.stepper-btn:hover {
  background: #f1f5f9;
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
}

.detail-config-row strong {
  color: #0f172a;
  font-weight: 800;
}

.detail-config-total {
  padding-top: 0.75rem;
  margin-top: 0.25rem;
  border-top: 1px solid rgba(15, 23, 42, 0.08);
  font-size: 1rem;
  color: #0f172a;
}

.detail-config-total strong {
  font-size: 1.5rem;
  color: #042d86;
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
  background: $brand;
  color: #ffffff;
  font-weight: 800;
  font-size: 1rem;
  cursor: pointer;
  box-shadow: 0 10px 24px rgba(4, 45, 134, 0.25);
  transition: background 0.2s ease, transform 0.2s ease;
}

.detail-btn-primary:hover {
  background: #03348f;
  transform: translateY(-1px);
}

.detail-btn-whatsapp {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  width: 100%;
  padding: 1rem;
  border: 1px solid rgba(4, 45, 134, 0.15);
  border-radius: 14px;
  background: #ffffff;
  color: $brand;
  font-weight: 800;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.detail-btn-whatsapp:hover {
  background: #f8fafc;
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
}

.detail-tab-btn.active {
  color: #042d86;
  font-weight: 800;
}

.detail-tab-btn.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: #042d86;
  border-radius: 9999px;
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
}

.detail-spec-row:last-child {
  border-bottom: none;
}

.detail-spec-row span {
  color: #64748b;
  font-size: 0.9rem;
}

.detail-spec-row strong {
  color: #042d86;
  font-weight: 700;
  font-size: 0.9rem;
  text-align: right;
  max-width: 60%;
}

.detail-size-table-wrap {
  overflow-x: auto;
}

.detail-size-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9rem;
}

.detail-size-table th {
  background: #eef2ff;
  color: #0f172a;
  font-weight: 700;
  padding: 0.75rem 1rem;
  text-align: left;
}

.detail-size-table td {
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #f1f5f9;
  color: #334155;
}

.detail-empty {
  text-align: center;
  padding: 3rem 1rem;
  color: #64748b;
}
</style>
