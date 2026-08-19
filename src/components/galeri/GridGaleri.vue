<template>
  <div class="gallery-section">
    <div class="gallery-grid">
      <div
        v-for="item in items"
        :key="item.id"
        class="gallery-item"
        @click="$emit('open', item)"
      >
        <img
          :src="item.gambar"
          :alt="item.judul"
          class="gallery-img"
          loading="lazy"
        />
        <div class="gallery-overlay">
          <span class="gallery-zoom-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/><path d="M11 8v6"/><path d="M8 11h6"/></svg>
          </span>
        </div>
      </div>

      <router-link to="/galeri" class="gallery-more-card">
        <span class="gallery-more-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="3" rx="2" ry="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>
        </span>
        <span class="gallery-more-text">Lihat Lebih Banyak Album</span>
      </router-link>
    </div>
  </div>
</template>

<script setup>
defineOptions({
  name: 'GridGaleri'
});

defineProps({
  items: {
    type: Array,
    default: () => []
  }
});

defineEmits(['open']);
</script>

<style lang="scss" scoped>
.gallery-section {
  padding: 0 1.5rem 2rem;
}

.gallery-grid {
  max-width: 72rem;
  margin: 0 auto;
  columns: 3;
  column-gap: 1.5rem;
}

.gallery-item {
  break-inside: avoid;
  margin-bottom: 1.5rem;
  position: relative;
  border-radius: 1.25rem;
  overflow: hidden;
  cursor: pointer;
  background: #f1f5f9;
}

.gallery-img {
  display: block;
  width: 100%;
  height: auto;
  object-fit: cover;
}

.gallery-overlay {
  position: absolute;
  inset: 0;
  background: rgba(15, 23, 42, 0.45);
  opacity: 0;
  transition: opacity 0.25s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  pointer-events: none;
}

.gallery-item:hover .gallery-overlay {
  opacity: 1;
}

.gallery-zoom-icon {
  color: #ffffff;
  display: grid;
  place-items: center;
}

.gallery-more-card {
  break-inside: avoid;
  margin-bottom: 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  border-radius: 1.25rem;
  background: #f0fdfa;
  border: 2px dashed #99f6e4;
  padding: 2rem 1rem;
  text-decoration: none;
  color: #0f172a;
  transition: background 0.2s ease;
}

.gallery-more-card:hover {
  background: #ccfbf1;
}

.gallery-more-icon {
  color: #0d9488;
  display: grid;
  place-items: center;
}

.gallery-more-text {
  font-weight: 600;
  font-size: 0.95rem;
  text-align: center;
  color: #334155;
}

@media (max-width: 1023px) {
  .gallery-grid {
    columns: 2;
  }
}

@media (max-width: 639px) {
  .gallery-grid {
    columns: 1;
  }

  .gallery-section {
    padding: 0 1rem 2rem;
  }
}
</style>
