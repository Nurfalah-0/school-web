<template>
  <div class="gallery-section">
    <!-- Empty state -->
    <div v-if="!items.length" class="gallery-empty">
      <div class="empty-icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.25" stroke-linecap="round" stroke-linejoin="round">
          <rect width="18" height="18" x="3" y="3" rx="2"/>
          <circle cx="9" cy="9" r="2"/>
          <path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/>
        </svg>
      </div>
      <p class="empty-title">Belum Ada Foto</p>
      <p class="empty-desc">Foto untuk kategori ini belum tersedia. Coba pilih kategori lain.</p>
    </div>

    <!-- Masonry grid -->
    <div v-else class="gallery-grid" ref="gridRef">
      <div
        v-for="(item, index) in items"
        :key="item.id"
        class="gallery-item"
        :class="[`gallery-item--${getSize(index)}`, { 'gallery-item--featured': item.featured }]"
        @click="$emit('open', item)"
        :style="{ '--delay': `${(index % 9) * 0.05}s` }"
      >
        <!-- Image -->
        <img
          :src="item.gambar"
          :alt="item.judul"
          class="gallery-img"
          loading="lazy"
          @error="onImgError"
        />

        <!-- Category badge -->
        <div class="gallery-badge" v-if="item.kategori && item.kategori !== 'semua'">
          {{ formatKategori(item.kategori) }}
        </div>

        <!-- Featured star -->
        <div class="gallery-featured-badge" v-if="item.featured">
          <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        </div>

        <!-- Hover overlay -->
        <div class="gallery-overlay">
          <div class="overlay-content">
            <div class="overlay-zoom">
              <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/><path d="M11 8v6"/><path d="M8 11h6"/></svg>
            </div>
            <p class="overlay-title">{{ item.judul }}</p>
            <p class="overlay-date" v-if="item.tanggal">{{ formatDate(item.tanggal) }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

defineOptions({ name: 'GridGaleri' });

defineProps({
  items: { type: Array, default: () => [] }
});

defineEmits(['open']);

const gridRef = ref(null);

function getSize(index) {
  const pattern = ['medium', 'tall', 'medium', 'wide', 'medium', 'medium', 'tall', 'medium', 'wide'];
  return pattern[index % pattern.length];
}

function formatKategori(k) {
  return k.replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
}

function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' });
}

function onImgError(e) {
  e.target.src = 'https://placehold.co/600x400/e2e8f0/94a3b8?text=Foto';
}
</script>

<style lang="scss" scoped>
.gallery-section {
  padding: 2rem 1.5rem 3rem;
  background: #f8fafc;
}

/* Empty state */
.gallery-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 6rem 2rem;
  text-align: center;
}

.empty-icon {
  width: 96px;
  height: 96px;
  border-radius: 50%;
  background: #eef2ff;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #a5b4fc;
  margin-bottom: 1.25rem;
}

.empty-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0 0 0.5rem;
}

.empty-desc {
  font-size: 0.95rem;
  color: #64748b;
  margin: 0;
}

/* Grid */
.gallery-grid {
  max-width: 72rem;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: 200px;
  gap: 1rem;
}

.gallery-item {
  position: relative;
  border-radius: 1.25rem;
  overflow: hidden;
  cursor: pointer;
  background: #e2e8f0;
  grid-row: span 1;
  animation: fadeInUp 0.5s ease both;
  animation-delay: var(--delay);
  will-change: transform;
  transition: transform 0.3s ease, box-shadow 0.3s ease;

  &:hover {
    transform: translateY(-4px) scale(1.01);
    box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    z-index: 2;
  }
}

/* Span patterns for visual variety */
.gallery-item--tall {
  grid-row: span 2;
}
.gallery-item--wide {
  grid-column: span 2;
}
.gallery-item--medium {
  grid-row: span 1;
  grid-column: span 1;
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}

.gallery-img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.gallery-item:hover .gallery-img {
  transform: scale(1.06);
}

/* Category badge */
.gallery-badge {
  position: absolute;
  top: 0.75rem;
  left: 0.75rem;
  padding: 0.25rem 0.7rem;
  border-radius: 9999px;
  background: rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(6px);
  border: 1px solid rgba(255,255,255,0.2);
  font-size: 0.7rem;
  font-weight: 600;
  color: #ffffff;
  text-transform: capitalize;
  letter-spacing: 0.03em;
  pointer-events: none;
}

/* Featured badge */
.gallery-featured-badge {
  position: absolute;
  top: 0.75rem;
  right: 0.75rem;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ffffff;
  box-shadow: 0 2px 8px rgba(245, 158, 11, 0.5);
  pointer-events: none;
}

/* Hover overlay */
.gallery-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to top,
    rgba(10, 10, 30, 0.9) 0%,
    rgba(10, 10, 30, 0.4) 50%,
    rgba(10, 10, 30, 0.05) 100%
  );
  opacity: 0;
  transition: opacity 0.3s ease;
  display: flex;
  align-items: flex-end;
  padding: 1.25rem;
  pointer-events: none;
}

.gallery-item:hover .gallery-overlay {
  opacity: 1;
}

.overlay-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  text-align: center;
}

.overlay-zoom {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: rgba(255,255,255,0.15);
  border: 1.5px solid rgba(255,255,255,0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ffffff;
  margin-bottom: 0.625rem;
  backdrop-filter: blur(4px);
  transition: background 0.2s, transform 0.2s;
}

.gallery-item:hover .overlay-zoom {
  transform: scale(1.1);
  background: rgba(255,255,255,0.25);
}

.overlay-title {
  margin: 0;
  font-size: 0.9rem;
  font-weight: 700;
  color: #ffffff;
  line-height: 1.3;
  text-shadow: 0 1px 6px rgba(0,0,0,0.5);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.overlay-date {
  margin: 0.3rem 0 0;
  font-size: 0.75rem;
  color: rgba(255,255,255,0.65);
}

/* Responsive */
@media (max-width: 1023px) {
  .gallery-grid {
    grid-template-columns: repeat(2, 1fr);
    grid-auto-rows: 180px;
  }
  .gallery-item--wide {
    grid-column: span 2;
  }
}

@media (max-width: 639px) {
  .gallery-section {
    padding: 1.25rem 0.875rem 2.5rem;
  }
  .gallery-grid {
    grid-template-columns: repeat(2, 1fr);
    grid-auto-rows: 140px;
    gap: 0.625rem;
  }
  .gallery-item--wide { grid-column: span 2; }
  .gallery-item--tall { grid-row: span 2; }
  .gallery-item { border-radius: 0.875rem; }
  .gallery-badge { font-size: 0.65rem; padding: 0.2rem 0.5rem; }
}
</style>
