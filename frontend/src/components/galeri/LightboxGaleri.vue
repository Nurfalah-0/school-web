<template>
  <Teleport to="body">
    <Transition name="lb">
      <div
        v-if="item"
        class="lightbox"
        @click.self="emit('close')"
        tabindex="0"
        ref="lightboxRef"
        role="dialog"
        aria-modal="true"
        aria-label="Lihat foto"
      >
        <!-- Blurred background hint from actual image -->
        <div class="lb-bg-blur" :style="{ backgroundImage: `url(${item.gambarFull})` }"></div>

        <!-- Toolbar -->
        <div class="lb-toolbar">
          <div class="lb-counter" v-if="total > 1">
            {{ currentIndex + 1 }} / {{ total }}
          </div>
          <div class="lb-toolbar-actions">
            <a
              :href="item.gambarFull"
              target="_blank"
              rel="noopener"
              class="lb-action-btn"
              title="Buka di tab baru"
              @click.stop
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.25" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
            </a>
            <button type="button" class="lb-action-btn lb-close" @click="emit('close')" aria-label="Tutup">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
            </button>
          </div>
        </div>

        <!-- Navigation prev -->
        <button
          v-if="hasPrev"
          type="button"
          class="lb-nav lb-nav--prev"
          @click="emit('prev')"
          aria-label="Foto sebelumnya"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>

        <!-- Navigation next -->
        <button
          v-if="hasNext"
          type="button"
          class="lb-nav lb-nav--next"
          @click="emit('next')"
          aria-label="Foto berikutnya"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
        </button>

        <!-- Main image -->
        <div class="lb-stage" @click.stop>
          <Transition name="lb-img" mode="out-in">
            <img
              v-if="item.gambarFull"
              :key="item.id"
              :src="item.gambarFull"
              :alt="item.judul"
              class="lb-img"
              draggable="false"
            />
            <div v-else class="lb-img image-placeholder" aria-hidden="true"></div>
          </Transition>
        </div>

        <!-- Caption -->
        <div class="lb-caption" @click.stop>
          <div class="lb-caption-inner">
            <div class="lb-caption-info">
              <span class="lb-caption-badge" v-if="item.kategori && item.kategori !== 'semua'">{{ formatKategori(item.kategori) }}</span>
              <p class="lb-caption-title">{{ item.judul }}</p>
              <p class="lb-caption-date" v-if="item.tanggal">
                <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                {{ formatDate(item.tanggal) }}
              </p>
            </div>
          </div>
        </div>

        <!-- Keyboard hint -->
        <div class="lb-hint" v-if="total > 1">
          <span>← → untuk navigasi</span>
          <span>ESC untuk tutup</span>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, computed } from 'vue';

defineOptions({ name: 'LightboxGaleri' });

const props = defineProps({
  item:         { type: Object,  default: null  },
  hasPrev:      { type: Boolean, default: false },
  hasNext:      { type: Boolean, default: false },
  currentIndex: { type: Number,  default: 0     },
  total:        { type: Number,  default: 0     }
});

const emit = defineEmits(['close', 'prev', 'next']);
const lightboxRef = ref(null);

function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
}

function formatKategori(k) {
  return k.replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
}

function onKey(e) {
  if (e.key === 'Escape')     emit('close');
  if (e.key === 'ArrowLeft')  emit('prev');
  if (e.key === 'ArrowRight') emit('next');
}

onMounted(() => {
  document.body.style.overflow = 'hidden';
  window.addEventListener('keydown', onKey);
  lightboxRef.value?.focus();
});

onUnmounted(() => {
  document.body.style.overflow = '';
  window.removeEventListener('keydown', onKey);
});

watch(() => props.item, () => {
  lightboxRef.value?.focus();
});
</script>

<style lang="scss" scoped>
/* Transition */
.lb-enter-active, .lb-leave-active { transition: opacity 0.25s ease; }
.lb-enter-from, .lb-leave-to { opacity: 0; }

.lb-img-enter-active, .lb-img-leave-active { transition: opacity 0.18s ease, transform 0.18s ease; }
.lb-img-enter-from { opacity: 0; transform: scale(0.97); }
.lb-img-leave-to   { opacity: 0; transform: scale(1.03); }

.lightbox {
  position: fixed;
  inset: 0;
  z-index: 200;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  outline: none;
  background: rgba(5, 5, 15, 0.93);
  backdrop-filter: blur(2px);
  padding: 1rem;
}

/* Blurred bg from image */
.lb-bg-blur {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  filter: blur(60px) saturate(0.4);
  opacity: 0.2;
  pointer-events: none;
  transform: scale(1.1);
}

/* Toolbar */
.lb-toolbar {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.25rem;
  background: linear-gradient(to bottom, rgba(0,0,0,0.6), transparent);
  z-index: 10;
}

.lb-counter {
  font-size: 0.825rem;
  font-weight: 600;
  color: rgba(255,255,255,0.7);
  background: rgba(0,0,0,0.4);
  border: 1px solid rgba(255,255,255,0.15);
  padding: 0.35rem 0.8rem;
  border-radius: 9999px;
  backdrop-filter: blur(6px);
}

.lb-toolbar-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.lb-action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  border-radius: 50%;
  border: 1.5px solid rgba(255,255,255,0.2);
  background: rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.85);
  cursor: pointer;
  text-decoration: none;
  transition: all 0.2s ease;
  backdrop-filter: blur(6px);

  &:hover {
    background: rgba(255,255,255,0.2);
    border-color: rgba(255,255,255,0.35);
    color: #ffffff;
  }
}

.lb-close { border: none; }

/* Nav buttons */
.lb-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 52px;
  height: 52px;
  border-radius: 50%;
  border: 1.5px solid rgba(255,255,255,0.2);
  background: rgba(255,255,255,0.1);
  color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  backdrop-filter: blur(8px);
  transition: all 0.25s ease;
  z-index: 10;

  &:hover {
    background: rgba(255,255,255,0.22);
    border-color: rgba(255,255,255,0.4);
    transform: translateY(-50%) scale(1.08);
  }
}

.lb-nav--prev { left: 1.25rem; }
.lb-nav--next { right: 1.25rem; }

/* Stage */
.lb-stage {
  position: relative;
  z-index: 5;
  display: flex;
  align-items: center;
  justify-content: center;
  max-width: 80vw;
  max-height: 70vh;
}

.lb-img {
  max-width: 100%;
  max-height: 70vh;
  object-fit: contain;
  border-radius: 0.875rem;
  box-shadow: 0 32px 80px rgba(0,0,0,0.7);
  display: block;
}

/* Caption */
.lb-caption {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 10;
  background: linear-gradient(to top, rgba(0,0,0,0.75), transparent);
  padding: 3rem 1.5rem 1.25rem;
}

.lb-caption-inner {
  max-width: 56rem;
  margin: 0 auto;
}

.lb-caption-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.4rem;
  text-align: center;
}

.lb-caption-badge {
  display: inline-block;
  padding: 0.2rem 0.7rem;
  border-radius: 9999px;
  background: rgba(124, 58, 237, 0.7);
  border: 1px solid rgba(167, 139, 250, 0.4);
  font-size: 0.7rem;
  font-weight: 600;
  color: #e9d5ff;
  text-transform: capitalize;
  letter-spacing: 0.04em;
}

.lb-caption-title {
  margin: 0;
  font-weight: 700;
  font-size: 1rem;
  color: #ffffff;
  text-shadow: 0 1px 8px rgba(0,0,0,0.6);
}

.lb-caption-date {
  margin: 0;
  display: flex;
  align-items: center;
  gap: 0.3rem;
  font-size: 0.8rem;
  color: rgba(255,255,255,0.55);
}

/* Keyboard hint */
.lb-hint {
  position: absolute;
  bottom: 1.25rem;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 1rem;
  font-size: 0.725rem;
  color: rgba(255,255,255,0.3);
  white-space: nowrap;
  pointer-events: none;
}

@media (max-width: 639px) {
  .lb-stage { max-width: 95vw; max-height: 55vh; }
  .lb-img { max-height: 55vh; }
  .lb-nav { width: 40px; height: 40px; }
  .lb-nav--prev { left: 0.5rem; }
  .lb-nav--next { right: 0.5rem; }
  .lb-hint { display: none; }
  .lb-caption { padding: 2rem 1rem 1rem; }
}
</style>
