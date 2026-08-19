<template>
  <section class="grid-section">
    <div class="grid-inner">
      <div class="produk-grid">
        <div v-for="item in filteredProduk" :key="item.id" class="produk-card">
          <div class="produk-img-wrap">
            <img
              :src="item.gambar"
              :alt="item.nama"
              loading="lazy"
            />
          </div>
          <div class="produk-info">
            <span class="produk-kategori">{{ item.kategori }}</span>
            <h3 class="produk-nama">{{ item.nama }}</h3>
            <div class="produk-rating">
              <Star :size="14" color="#f59e0b" fill="#f59e0b" />
              <span class="produk-rating-num">{{ item.rating }}</span>
              <span class="produk-rating-count">({{ item.ulasan }} Ulasan)</span>
            </div>
            <div class="produk-bottom">
              <span class="produk-harga">{{ formatRupiah(item.harga) }}</span>
              <button
                class="produk-cart-btn"
                type="button"
                aria-label="Tambah ke keranjang"
                @click="$emit('pilih-produk', item)"
              >
                <ShoppingCart :size="16" color="#ffffff" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { Star, ShoppingCart } from 'lucide-vue-next'
import { formatRupiah } from '../../../shared/utils/formatRupiah'

const props = defineProps({
  kategoriFilter: {
    type: String,
    default: 'Semua Produk'
  }
})

defineEmits(['pilih-produk'])

const produkList = [
  {
    id: 1,
    nama: 'Custom Sports Jersey PRO',
    kategori: 'PERCETAKAN',
    rating: 4.9,
    ulasan: 128,
    harga: 145000,
    gambar: 'https://placehold.co/600x600/1e3a8a/ffffff?text=Custom+Sports+Jersey'
  },
  {
    id: 2,
    nama: '3D Printed Geometric Lamp',
    kategori: 'PRODUK KREATIF',
    rating: 4.7,
    ulasan: 56,
    harga: 299000,
    gambar: 'https://placehold.co/600x600/0f766e/ffffff?text=3D+Printed+Geometric'
  },
  {
    id: 3,
    nama: 'Paket Branding Perusahaan',
    kategori: 'DESIGN GRAFIS',
    rating: 5.0,
    ulasan: 89,
    harga: 1500000,
    gambar: 'https://placehold.co/600x600/7e22ce/ffffff?text=Branding+Kit'
  },
  {
    id: 4,
    nama: 'Video Iklan Pendek (30s)',
    kategori: 'MULTIMEDIA',
    rating: 4.8,
    ulasan: 42,
    harga: 750000,
    gambar: 'https://placehold.co/600x600/b45309/ffffff?text=Video+Iklan'
  }
]

const filteredProduk = computed(() => {
  if (!props.kategoriFilter || props.kategoriFilter === 'Semua Produk') {
    return produkList
  }
  return produkList.filter(item => item.kategori === props.kategoriFilter)
})
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.grid-section {
  background: #ffffff;
  padding: 2.5rem 0;
}

.grid-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.produk-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .produk-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .produk-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 2rem;
  }
}

.produk-card {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.produk-img-wrap {
  width: 100%;
  aspect-ratio: 4 / 3;
  border-radius: 20px;
  overflow: hidden;
  background: #f1f5f9;
}

.produk-img-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.3s ease;
}

.produk-card:hover .produk-img-wrap img {
  transform: scale(1.05);
}

.produk-info {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  padding-top: 0.25rem;
}

.produk-kategori {
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #64748b;
}

.produk-nama {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1rem;
  color: #0f172a;
  margin: 0;
  line-height: 1.35;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
}

.produk-rating {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  margin-top: 0.1rem;
}

.produk-rating-num {
  font-weight: 800;
  font-size: 0.9rem;
  color: #0f172a;
}

.produk-rating-count {
  color: #64748b;
  font-size: 0.85rem;
}

.produk-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 0.5rem;
}

.produk-harga {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.15rem;
  color: #042d86;
}

.produk-cart-btn {
  width: 2.25rem;
  height: 2.25rem;
  display: grid;
  place-items: center;
  border: none;
  border-radius: 9999px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #ffffff;
  cursor: pointer;
  box-shadow: 0 6px 14px rgba(245, 158, 11, 0.35);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.produk-cart-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(245, 158, 11, 0.45);
}
</style>
