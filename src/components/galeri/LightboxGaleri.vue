<template>
  <div class="lightbox" @click.self="emit('close')" @keydown.esc="emit('close')" @keydown.left.prevent="emit('prev')" @keydown.right.prevent="emit('next')" tabindex="0" ref="lightboxRef">
    <button type="button" class="lightbox-close" @click="emit('close')" aria-label="Tutup">
      <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
    </button>

    <button
      v-if="hasPrev"
      type="button"
      class="lightbox-nav lightbox-nav--prev"
      @click="emit('prev')"
      aria-label="Foto sebelumnya"
    >
      <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
    </button>

    <button
      v-if="hasNext"
      type="button"
      class="lightbox-nav lightbox-nav--next"
      @click="emit('next')"
      aria-label="Foto berikutnya"
    >
      <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
    </button>

    <div class="lightbox-body">
      <img :src="item.gambarFull" :alt="item.judul" class="lightbox-img" />
      <div class="lightbox-caption">
        <p class="lightbox-caption-title">{{ item.judul }}</p>
        <p class="lightbox-caption-date">{{ formatDate(item.tanggal) }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue';

defineOptions({
  name: 'LightboxGaleri'
});

const props = defineProps({
  item: {
    type: Object,
    default: null
  },
  hasPrev: {
    type: Boolean,
    default: false
  },
  hasNext: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['close', 'prev', 'next']);

const lightboxRef = ref(null);

function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
}

function onKey(e) {
  if (e.key === 'Escape') emit('close');
  if (e.key === 'ArrowLeft') emit('prev');
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
.lightbox {
  position: fixed;
  inset: 0;
  z-index: 50;
  background: rgba(0, 0, 0, 0.92);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
  outline: none;
}

.lightbox-close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: transparent;
  border: none;
  color: #ffffff;
  cursor: pointer;
  display: grid;
  place-items: center;
  z-index: 51;
}

.lightbox-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(255, 255, 255, 0.15);
  border: none;
  color: #ffffff;
  border-radius: 9999px;
  width: 3rem;
  height: 3rem;
  display: grid;
  place-items: center;
  cursor: pointer;
  backdrop-filter: blur(4px);
  transition: background 0.2s ease;
  z-index: 51;
}

.lightbox-nav:hover {
  background: rgba(255, 255, 255, 0.28);
}

.lightbox-nav--prev {
  left: 1rem;
}

.lightbox-nav--next {
  right: 1rem;
}

.lightbox-body {
  max-width: 56rem;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.lightbox-img {
  max-width: 100%;
  max-height: 85vh;
  object-fit: contain;
  border-radius: 0.5rem;
  display: block;
}

.lightbox-caption {
  text-align: center;
  color: #ffffff;
}

.lightbox-caption-title {
  margin: 0;
  font-weight: 700;
  font-size: 1.125rem;
}

.lightbox-caption-date {
  margin: 0.35rem 0 0;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.7);
}

@media (max-width: 639px) {
  .lightbox {
    padding: 1rem;
  }

  .lightbox-img {
    max-height: 75vh;
  }

  .lightbox-nav {
    width: 2.5rem;
    height: 2.5rem;
  }

  .lightbox-nav--prev {
    left: 0.5rem;
  }

  .lightbox-nav--next {
    right: 0.5rem;
  }
}
</style>
