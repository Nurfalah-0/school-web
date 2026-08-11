<template>
  <section class="teaching-factory">
    <div class="teaching-factory-inner">
      <div class="teaching-factory-grid">
        <!-- Kolom Kiri: Teks -->
        <div class="teaching-factory-left">
          <span class="teaching-factory-label">{{ label }}</span>
          <h2 class="teaching-factory-title">
            <span>{{ titleLine1 }}</span><br />
            <span>{{ titleLine2 }}</span>
          </h2>
          <p class="teaching-factory-desc">{{ description }}</p>

          <div class="teaching-factory-features">
            <div v-for="item in features" :key="item.judul" class="teaching-factory-feature">
              <span class="teaching-factory-feature-icon" v-html="item.icon"></span>
              <div>
                <h4 class="teaching-factory-feature-title">{{ item.judul }}</h4>
                <p class="teaching-factory-feature-text">{{ item.deskripsi }}</p>
              </div>
            </div>
          </div>

          <hr class="teaching-factory-divider" />

          <span class="teaching-factory-partner-label">{{ partnerLabel }}</span>
          <div class="teaching-factory-partners">
            <span v-for="partner in partners" :key="partner" class="teaching-factory-partner-badge">
              {{ partner }}
            </span>
          </div>
        </div>

        <!-- Kolom Kanan: Gambar Split -->
        <div class="teaching-factory-right">
          <div class="teaching-factory-split">
            <img :src="imageLeft" :alt="imageLeftAlt" class="teaching-factory-split-img" />
            <img :src="imageRight" :alt="imageRightAlt" class="teaching-factory-split-img" />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  label: {
    type: String,
    default: 'TEACHING FACTORY'
  },
  titleLine1: {
    type: String,
    default: 'Belajar Langsung dari'
  },
  titleLine2: {
    type: String,
    default: 'Alur Industri.'
  },
  description: {
    type: String,
    default: 'Program TEFA kami memastikan siswa tidak hanya belajar teori, tetapi terlibat langsung dalam produksi produk nyata yang dipasarkan secara luas, mulai dari software house hingga production house film.'
  },
  features: {
    type: Array,
    default: () => [
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>',
        judul: 'NJ Software House',
        deskripsi: 'Pengembangan Web & Apps komersial oleh siswa kelas industri.'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="20" rx="2.18"></rect><line x1="7" y1="2" x2="7" y2="22"></line><line x1="17" y1="2" x2="17" y2="22"></line><line x1="2" y1="12" x2="22" y2="12"></line><line x1="2" y1="7" x2="7" y2="7"></line><line x1="2" y1="17" x2="7" y2="17"></line><line x1="17" y1="17" x2="22" y2="17"></line><line x1="17" y1="7" x2="22" y2="7"></line></svg>',
        judul: 'NJ Creative Studio',
        deskripsi: 'Jasa produksi video, branding, dan animasi profesional.'
      }
    ]
  },
  partnerLabel: {
    type: String,
    default: 'PARTNER INDUSTRI STRATEGIS'
  },
  partners: {
    type: Array,
    default: () => ['GOOGLE CLOUD', 'MICROSOFT', 'AXIOO CLASS']
  },
  imageLeft: {
    type: String,
    default: 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=800&q=80'
  },
  imageLeftAlt: {
    type: String,
    default: 'Siswa coding di NJ Software House'
  },
  imageRight: {
    type: String,
    default: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=800&q=80'
  },
  imageRightAlt: {
    type: String,
    default: 'Peralatan produksi video NJ Creative Studio'
  }
});
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.teaching-factory {
  background: #f1f7ff;
  padding: 5.5rem 0;
}

.teaching-factory-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
  background: #ffffff;
  border-radius: 2rem;
  box-shadow: 0 35px 90px rgba(15, 23, 42, 0.12);
  padding: 2.5rem;
  position: relative;
  overflow: hidden;
}

.teaching-factory-inner::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at top right, rgba(59, 130, 246, 0.12), transparent 32%), radial-gradient(circle at bottom left, rgba(59, 130, 246, 0.08), transparent 25%);
  pointer-events: none;
}

.teaching-factory-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2.5rem;
  align-items: stretch;
}

@media (min-width: 768px) {
  .teaching-factory-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 4rem;
  }
}

.teaching-factory-left {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.teaching-factory-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #6B4400;
}

.teaching-factory-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.8rem, 2.8vw, 3rem);
  line-height: 1.2;
  color: #28469E;
  margin: 0;
}

.teaching-factory-desc {
  color: #334155;
  font-size: 1rem;
  line-height: 1.75;
  margin: 0;
}

.teaching-factory-features {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  margin-top: 0.5rem;
}

.teaching-factory-feature {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
}

.teaching-factory-feature-icon {
  width: 2.5rem;
  height: 2.5rem;
  display: grid;
  place-items: center;
  color: #0f172a;
  flex-shrink: 0;
}

.teaching-factory-feature-title {
  font-family: $font-display;
  font-weight: 700;
  font-size: 1.1rem;
  color: #0f172a;
  margin: 0 0 0.25rem;
}

.teaching-factory-feature-text {
  font-size: 0.95rem;
  color: #334155;
  line-height: 1.6;
  margin: 0;
}

.teaching-factory-divider {
  border: none;
  border-top: 1px solid #e2e8f0;
  margin: 1rem 0;
}

.teaching-factory-partner-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #475569;
}

.teaching-factory-partners {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 0.75rem;
}

.teaching-factory-partner-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.6rem 1.25rem;
  background: #f1f5f9;
  color: #334155;
  border-radius: 0.5rem;
  font-size: 0.85rem;
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}

.teaching-factory-right {
  display: flex;
  justify-content: center;
  align-items: center;
}

.teaching-factory-split {
  display: flex;
  width: 100%;
  height: 100%;
  border-radius: 0 3rem 3rem 0;
  overflow: hidden;
  box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.04);
}

.teaching-factory-split-img {
  width: 50%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.35s ease;
}

.teaching-factory-split-img:hover {
  transform: scale(1.03);
}

@media (max-width: 767px) {
  .teaching-factory-split {
    border-radius: 2rem;
    flex-direction: row;
  }

  .teaching-factory-split-img {
    width: 50%;
    aspect-ratio: 16/9;
    height: auto;
  }
}
</style>
