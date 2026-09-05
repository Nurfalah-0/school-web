<template>
  <section class="persiapan-section">
    <div class="persiapan-inner">
      <div class="persiapan-media">
        <div class="persiapan-frame">
          <img :src="image" :alt="alt" class="persiapan-img" />
        </div>
        <div class="persiapan-float-card">
          <strong>98%</strong>
          <span>Penyerapan lulusan ke industri dalam 6 bulan.</span>
        </div>
      </div>

      <div class="persiapan-copy">
        <h2 class="persiapan-title">
          <span>{{ titleLine1 }}</span><br />
          <span>{{ titleLine2 }}</span>
        </h2>
        <p class="persiapan-desc">{{ description }}</p>
        <div class="persiapan-features">
          <div v-for="item in features" :key="item.title" class="persiapan-feature">
            <div class="persiapan-feature-icon">
              <component :is="iconMap[item.icon]" />
            </div>
            <div>
              <h4 class="persiapan-feature-title">{{ item.title }}</h4>
              <p class="persiapan-feature-text">{{ item.text }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ShieldCheck, TrendingUp, Users } from 'lucide-vue-next';
import heroLabImage from '../../../assets/hero-lab.webp';

const iconMap = {
  ShieldCheck,
  TrendingUp,
  Users
};

defineProps({
  titleLine1: {
    type: String,
    default: 'Persiapkan Karirmu Sejak'
  },
  titleLine2: {
    type: String,
    default: 'Masa PKL'
  },
  description: {
    type: String,
    default: 'Program Praktik Kerja Lapangan (PKL) kami dirancang untuk menyinkronkan kurikulum sekolah dengan kebutuhan industri nyata.'
  },
  image: {
    type: String,
    default: heroLabImage
  },
  alt: {
    type: String,
    default: 'Siswa berkelompok berinteraksi dalam mockup aplikasi'
  },
  features: {
    type: Array,
    default: () => [
      {
        icon: 'ShieldCheck',
        title: 'Sertifikasi Kompetensi',
        text: 'Dapatkan sertifikat resmi dari mitra industri setelah menyelesaikan program.'
      },
      {
        icon: 'TrendingUp',
        title: 'Akses Jalur Cepat',
        text: 'Siswa berprestasi saat PKL memiliki peluang 85% untuk langsung direkrut.'
      },
      {
        icon: 'Users',
        title: 'Mentoring Industri',
        text: 'Bimbingan langsung dari praktisi profesional selama 3-6 bulan masa praktik.'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
.persiapan-section {
  background: #ffffff;
  padding: 5rem 0;
}

.persiapan-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
  align-items: center;
}

@media (min-width: 768px) {
  .persiapan-inner {
    grid-template-columns: 1fr 1fr;
    gap: 4rem;
  }
}

.persiapan-media {
  position: relative;
  display: flex;
  justify-content: flex-start;
  padding-left: 4rem;
}

.persiapan-frame {
  width: 100%;
  max-width: 1040px;
  background: #ffffff;
  border-radius: 2rem;
  overflow: hidden;
  box-shadow: 0 35px 80px rgba(15, 23, 42, 0.08);
}

.persiapan-img {
  width: calc(100% - 0.75rem);
  margin: 0.375rem;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  display: block;
  border-radius: 1.75rem;
}

.persiapan-float-card {
  position: absolute;
  bottom: 1.5rem;
  left: -2rem;
  background: rgba(255, 255, 255, 0.98);
  border-left: 4px solid #1e40af;
  border-radius: 1.5rem;
  padding: 1.25rem;
  box-shadow: 0 28px 60px rgba(15, 23, 42, 0.2);
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  width: 240px;
  z-index: 30;
}

.persiapan-float-card strong {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 2rem;
  color: #042d86;
  line-height: 1;
}

.persiapan-float-card span {
  font-size: 0.88rem;
  color: #475569;
  line-height: 1.5;
}

.persiapan-copy {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.persiapan-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(2.75rem, 4vw, 4.5rem);
  line-height: 1.05;
  color: #042d86;
  margin: 0;
}

.persiapan-desc {
  color: #334155;
  font-size: 1rem;
  line-height: 1.8;
  margin: 0;
}

.persiapan-features {
  display: flex;
  flex-direction: column;
  gap: 1.75rem;
  margin-top: 0.5rem;
}

.persiapan-feature {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
}

.persiapan-feature-icon {
  width: 3rem;
  height: 3rem;
  min-width: 3rem;
  border-radius: 1rem;
  background: #ccfbf1;
  display: grid;
  place-items: center;
  color: #0f172a;
  flex-shrink: 0;
}

.persiapan-feature-icon svg {
  width: 1.4rem;
  height: 1.4rem;
}

.persiapan-feature-title {
  font-weight: 700;
  font-size: 1.05rem;
  color: #0f172a;
  margin: 0 0 0.25rem;
}

.persiapan-feature-text {
  font-size: 0.95rem;
  color: #475569;
  line-height: 1.6;
  margin: 0;
}

@media (max-width: 767px) {
  .persiapan-media {
    justify-content: center;
    padding-left: 0;
  }

  .persiapan-frame {
    max-width: 100%;
  }

  .persiapan-img {
    width: calc(100% - 1.5rem);
    margin: 0.75rem;
    height: auto;
  }

  .persiapan-float-card {
    position: relative;
    top: auto;
    left: auto;
    transform: none;
    margin: 1.5rem auto 0;
    max-width: 220px;
    padding: 1rem;
  }

  .persiapan-float-card strong {
    font-size: 1.5rem;
  }

  .persiapan-feature-icon {
    width: 2.5rem;
    height: 2.5rem;
    min-width: 2.5rem;
  }

  .persiapan-feature-icon svg {
    width: 1.1rem;
    height: 1.1rem;
  }
}
</style>
