<template>
  <section class="galeri-sekolah">
    <div class="galeri-inner">
      <h2 class="galeri-title">{{ title }}</h2>
      <div class="galeri-grid">
        <div
          v-for="item in galeri"
          :key="item.alt"
          class="galeri-item"
          :style="{ height: item.height }"
        >
          <img :src="item.src" :alt="item.alt" class="galeri-img" loading="lazy" />
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: 'Galeri Sekolah'
  },
  galeri: {
    type: Array,
    default: () => [
      {
        src: 'https://images.unsplash.com/photo-1523240794352-6c418994d2f7?w=600&q=80',
        alt: 'Area taman kampus SMK Nurul Jadid',
        height: '20rem'
      },
      {
        src: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=600&q=80',
        alt: 'Lab robotik dan 3D printing SMK Nurul Jadid',
        height: '26.25rem'
      },
      {
        src: 'https://images.unsplash.com/photo-1507842217122-3f45c7f39214?w=600&q=80',
        alt: 'Perpustakaan SMK Nurul Jadid',
        height: '26.25rem'
      },
      {
        src: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe89?w=600&q=80',
        alt: 'Gedung SMK Nurul Jadid di malam hari',
        height: '20rem'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
.galeri-sekolah {
  background: #f8fafc;
  padding: 6rem 0 2rem;
  position: relative;
}

.galeri-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto 2rem;
  background: #ffffff;
  border-radius: 2rem;
  box-shadow: 0 30px 80px rgba(15, 23, 42, 0.12);
  padding: 3rem 2rem 2rem;
  position: relative;
  overflow: hidden;
}

.galeri-inner::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 8rem;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0) 0%, rgba(248, 250, 252, 1) 100%);
  pointer-events: none;
}

.galeri-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.9rem, 3vw, 2.7rem);
  color: #0f172a;
  text-align: center;
  margin: 0 0 3rem;
}

.galeri-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@media (min-width: 640px) {
  .galeri-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1.5rem;
  }

  .galeri-item {
    height: 16rem;
  }
}

@media (min-width: 1024px) {
  .galeri-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 1.5rem;
    align-items: center;
  }
}

.galeri-item {
  border-radius: 1.5rem;
  overflow: hidden;
  background: #f8fafc;
  box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  position: relative;
}

.galeri-item:hover {
  transform: translateY(-6px);
  box-shadow: 0 26px 55px rgba(15, 23, 42, 0.16);
}

.galeri-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.galeri-item::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(248, 250, 252, 0.2), rgba(21, 21, 48, 0.08));
  opacity: 0.4;
  pointer-events: none;
}
</style>
