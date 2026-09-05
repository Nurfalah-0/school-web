<template>
  <section class="jurusan-hero">
    <div class="jurusan-hero-inner">
      <div class="jurusan-hero-copy">
        <span class="jurusan-hero-badge">
          <CodeXml :size="14" color="#042d86" />
          {{ jurusan.kategori }}
        </span>
        <h1 class="jurusan-hero-title">
          {{ jurusan.nama }}
        </h1>
        <p class="jurusan-hero-desc">{{ jurusan.deskripsi }}</p>
        <div class="jurusan-hero-actions">
          <router-link to="/ppdb" class="jurusan-btn-primary">Daftar Sekarang</router-link>
          <a href="#kurikulum" class="jurusan-btn-secondary">Lihat Silabus</a>
        </div>
      </div>
      <div class="jurusan-hero-visual">
        <div class="jurusan-hero-img-wrap">
          <img :src="jurusan.gambarHero" :alt="jurusan.nama" class="jurusan-hero-img" loading="eager" />
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { CodeXml } from 'lucide-vue-next'

const props = defineProps({
  jurusan: {
    type: Object,
    required: true
  }
})
</script>

<style lang="scss" scoped>
.jurusan-hero {
  background: linear-gradient(135deg, #ffffff 0%, #eef2ff 60%, rgba(232, 230, 247, 0.4) 100%);
  border-radius: 1.75rem;
  padding: 2.5rem;
}

@media (min-width: 768px) {
  .jurusan-hero {
    padding: 3rem;
  }
}

.jurusan-hero-inner {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
  align-items: center;
}

@media (min-width: 768px) {
  .jurusan-hero-inner {
    grid-template-columns: 1fr 1.25fr;
    gap: 3.5rem;
  }
}

.jurusan-hero-copy {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.jurusan-hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  width: fit-content;
  padding: 0.5rem 1.25rem;
  border-radius: 9999px;
  background: #ccfbf1;
  color: #1e293b;
  font-size: 0.875rem;
  font-weight: 500;
  margin-top: 0.25rem;
}

.jurusan-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.75rem, 2.5vw, 2.25rem);
  line-height: 1.15;
  letter-spacing: -0.02em;
  color: #1e3a5f;
  margin: 0.75rem 0 0;
}

.jurusan-hero-desc {
  color: #64748b;
  font-size: 1rem;
  line-height: 1.75;
  margin: 0;
  max-width: 32rem;
}

.jurusan-hero-actions {
  display: flex;
  gap: 0.75rem;
  margin-top: 1.25rem;
  flex-wrap: wrap;
}

.jurusan-btn-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  border-radius: 9999px;
  background: #8b6914;
  color: #ffffff;
  font-weight: 600;
  font-size: 0.95rem;
  text-decoration: none;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.jurusan-btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 24px rgba(139, 105, 20, 0.35);
}

.jurusan-btn-secondary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  border-radius: 9999px;
  background: #e8e6f7;
  color: #1e3a5f;
  font-weight: 600;
  font-size: 0.95rem;
  text-decoration: none;
  transition: background 0.2s ease;
}

.jurusan-btn-secondary:hover {
  background: #ddd9f5;
}

.jurusan-hero-visual {
  display: flex;
  justify-content: center;
}

.jurusan-hero-img-wrap {
  width: 100%;
  aspect-ratio: 4 / 5;
  min-height: 420px;
  border-radius: 1.25rem;
  overflow: hidden;
  box-shadow: 0 24px 60px rgba(15, 23, 42, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.7);
}

.jurusan-hero-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

@media (max-width: 767px) {
  .jurusan-hero {
    padding: 1.5rem;
  }

  .jurusan-hero-inner {
    gap: 1.5rem;
  }

  .jurusan-hero-img-wrap {
    min-height: 260px;
    aspect-ratio: 4 / 3;
  }

  .jurusan-hero-copy {
    text-align: center;
    align-items: center;
  }

  .jurusan-hero-badge {
    margin: 0 auto;
  }

  .jurusan-hero-desc {
    margin: 0 auto;
  }

  .jurusan-hero-actions {
    justify-content: center;
  }
}
</style>
