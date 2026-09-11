<template>
  <section class="grid-section" id="katalog-produk">
    <div class="grid-inner">
      <!-- Loading state -->
      <div v-if="loading" class="produk-loading">
        <div v-for="n in 4" :key="n" class="produk-skeleton">
          <div class="skeleton-img"></div>
          <div class="skeleton-line w-60"></div>
          <div class="skeleton-line w-80"></div>
          <div class="skeleton-line w-40"></div>
        </div>
      </div>

      <!-- Empty state -->
      <div v-else-if="!filteredProduk.length" class="produk-empty">
        <div class="empty-icon"><ShoppingBag :size="48" color="#94a3b8" /></div>
        <h3>Belum Ada Produk</h3>
        <p>Produk untuk kategori "{{ kategoriFilter }}" belum tersedia saat ini.</p>
      </div>

      <!-- Grid list -->
      <div v-else class="produk-grid">
        <div
          v-for="item in filteredProduk"
          :key="item.id"
          class="produk-card"
          @click="$emit('pilih-produk', item)"
        >
          <div class="produk-img-wrap">
            <img
              v-if="item.gambar"
              :src="item.gambar"
              :alt="item.nama"
              loading="lazy"
              @error="item.gambar = ''"
            />
            <div v-else class="produk-image-placeholder" aria-hidden="true"></div>
            <span class="produk-badge" v-if="item.kategori">{{ item.kategori }}</span>
          </div>
          <div class="produk-info">
            <span class="produk-kategori">{{ item.kategori }}</span>
            <h3 class="produk-nama">{{ item.nama }}</h3>
            <div class="produk-rating">
              <Star :size="14" color="#f59e0b" fill="#f59e0b" />
              <span class="produk-rating-num">{{ item.rating || '4.9' }}</span>
              <span class="produk-rating-count">({{ item.ulasan || 12 }} Ulasan)</span>
            </div>
            <div class="produk-bottom">
              <span class="produk-harga">{{ formatRupiah(item.harga) }}</span>
              <button
                class="produk-cart-btn"
                type="button"
                aria-label="Tambah ke keranjang"
                @click.stop="$emit('tambah-keranjang', item)"
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
  },
  items: {
    type: Array,
    default: () => []
  },
  loading: {
    type: Boolean,
    default: false
  }
})

defineEmits(['tambah-keranjang'])

const filteredProduk = computed(() => {
  if (!props.items || props.items.length === 0) return []
  if (!props.kategoriFilter || props.kategoriFilter === 'Semua Produk' || props.kategoriFilter === 'semua') {
    return props.items
  }
  const target = props.kategoriFilter.toLowerCase()
  return props.items.filter(item => {
    const k = (item.kategori || '').toLowerCase()
    return k.includes(target) || target.includes(k)
  })
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

.produk-loading {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 1.5rem;
}

.produk-skeleton {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;

  .skeleton-img {
    width: 100%;
    aspect-ratio: 4 / 3;
    background: #e2e8f0;
    border-radius: 20px;
    animation: pulse 1.5s infinite ease-in-out;
  }

  .skeleton-line {
    height: 14px;
    background: #e2e8f0;
    border-radius: 4px;
    animation: pulse 1.5s infinite ease-in-out;

    &.w-60 { width: 60%; }
    &.w-80 { width: 80%; }
    &.w-40 { width: 40%; }
  }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

.produk-empty {
  text-align: center;
  padding: 4rem 1.5rem;
  background: #f8fafc;
  border-radius: 1.5rem;
  border: 1px dashed #cbd5e1;

  .empty-icon {
    font-size: 2.5rem;
    margin-bottom: 0.75rem;
  }

  h3 {
    font-size: 1.25rem;
    font-weight: 800;
    color: #0f172a;
    margin: 0 0 0.5rem;
  }

  p {
    color: #64748b;
    font-size: 0.95rem;
    margin: 0;
  }
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
  cursor: pointer;
  padding: 0.75rem;
  border-radius: 24px;
  border: 1.5px solid transparent;
  transition: all 0.25s ease;

  &:hover {
    background: #f8fafc;
    border-color: #e2e8f0;
    transform: translateY(-4px);
    box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08);

    .produk-img-wrap img {
      transform: scale(1.06);
    }
  }
}

.produk-img-wrap {
  position: relative;
  width: 100%;
  aspect-ratio: 4 / 3;
  border-radius: 18px;
  overflow: hidden;
  background: #f1f5f9;
}

.produk-img-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.35s ease;
}

.produk-badge {
  position: absolute;
  top: 0.75rem;
  left: 0.75rem;
  padding: 0.25rem 0.65rem;
  background: rgba(15, 23, 42, 0.75);
  backdrop-filter: blur(4px);
  color: #ffffff;
  border-radius: 9999px;
  font-size: 0.65rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.produk-info {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  padding: 0 0.25rem;
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
  -webkit-line-clamp: 2;
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

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 20px rgba(245, 158, 11, 0.45);
  }
}
</style>
