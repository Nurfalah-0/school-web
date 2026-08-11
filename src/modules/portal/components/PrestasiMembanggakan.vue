<template>
  <section class="prestasi">
    <div class="prestasi-inner">
      <div class="prestasi-header">
        <h2 class="prestasi-title">{{ title }}</h2>
        <p class="prestasi-subtitle">{{ subtitle }}</p>
      </div>

      <div class="prestasi-scroll">
        <div v-for="item in prestasi" :key="item.judul" class="prestasi-card">
          <div class="prestasi-card-top">
            <span class="prestasi-icon" :style="{ background: item.iconBg }">
              <svg v-if="item.icon === 'medal'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="prestasi-svg">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
              </svg>
              <svg v-else-if="item.icon === 'ribbon'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="prestasi-svg">
                <path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6-4.8-6 4.8 2.4-7.2-6-4.8h7.6z"/>
              </svg>
              <svg v-else-if="item.icon === 'star'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="prestasi-svg">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
              </svg>
              <svg v-else-if="item.icon === 'trophy'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="prestasi-svg">
                <path d="M19 5h-2V3H7v2H5c-1.1 0-2 .9-2 2v1c0 2.42 1.72 4.44 4 4.9V15c0 1.66 1.34 3 3 3h1v2H8v2h8v-2h-4v-2h1c1.66 0 3-1.34 3-3v-2.1c2.28-.46 4-2.48 4-4.9V7c0-1.1-.9-2-2-2zM5 9V7h2v2.83c-.84-.44-2-1.15-2-2.83V7h2v2c0 1.31.84 2.44 2 2.83zM19 9c0 1.31-.84 2.44-2 2.83V7h2v2c0 1.68-1.16 3.39-2 2.83z"/>
              </svg>
            </span>
            <span class="prestasi-year">{{ item.tahun }}</span>
          </div>
          <h3 class="prestasi-name">{{ item.judul }}</h3>
          <p class="prestasi-text">{{ item.deskripsi }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: 'Prestasi Membanggakan'
  },
  subtitle: {
    type: String,
    default: 'Siswa kami secara konsisten meraih penghargaan di tingkat regional hingga nasional.'
  },
  prestasi: {
    type: Array,
    default: () => [
      {
        icon: 'medal',
        iconBg: '#fef3c7',
        tahun: '2023',
        judul: 'Juara 1 LKS Nasional',
        deskripsi: 'Bidang Web Technology yang diselenggarakan di Jawa Timur.'
      },
      {
        icon: 'ribbon',
        iconBg: '#f3e8ff',
        tahun: '2023',
        judul: 'Top 10 Startup Inovasi',
        deskripsi: 'Kompetisi Kreativitas Siswa Vokasi tingkat Kementerian Pendidikan.'
      },
      {
        icon: 'star',
        iconBg: '#ccfbf1',
        tahun: '2022',
        judul: 'Medali Emas O2SN',
        deskripsi: 'Cabang Pencak Silat kategori tanding tingkat Provinsi.'
      },
      {
        icon: 'trophy',
        iconBg: '#fef3c7',
        tahun: '2022',
        judul: 'Juara 2 Robotik',
        deskripsi: 'Inovasi Robot Penyelamat, kompetisi antar SMK se-Jawa Timur.'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.prestasi {
  background: #ffffff;
  padding: 5rem 0;
}

.prestasi-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
}

.prestasi-header {
  text-align: center;
  max-width: 42rem;
  margin: 0 auto 3rem;
}

.prestasi-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 0.75rem;
}

.prestasi-subtitle {
  font-size: 1.05rem;
  color: #334155;
  line-height: 1.7;
  margin: 0;
}

.prestasi-scroll {
  display: flex;
  gap: 1.5rem;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  padding: 0.5rem 0 1rem;
  -webkit-overflow-scrolling: touch;

  &::-webkit-scrollbar {
    display: none;
  }

  scrollbar-width: none;
}

.prestasi-card {
  flex: 0 0 auto;
  width: 18rem;
  scroll-snap-align: start;
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  padding: 1.5rem;
  background: #ffffff;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.prestasi-card-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.prestasi-icon {
  width: 3rem;
  height: 3rem;
  display: grid;
  place-items: center;
  border-radius: 0.75rem;
  color: #0f172a;
}

.prestasi-svg {
  width: 1.5rem;
  height: 1.5rem;
}

.prestasi-year {
  font-size: 0.8rem;
  color: #64748b;
  font-weight: 600;
}

.prestasi-name {
  font-family: $font-display;
  font-weight: 700;
  font-size: 1.15rem;
  color: #0f172a;
  margin: 0;
}

.prestasi-text {
  font-size: 0.9rem;
  color: #334155;
  line-height: 1.65;
  margin: 0;
}

@media (min-width: 768px) {
  .prestasi-scroll {
    padding-left: 0.5rem;
  }
}

@media (min-width: 1024px) {
  .prestasi-scroll {
    padding-left: 1rem;
  }
}
</style>
