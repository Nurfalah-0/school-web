<template>
  <section class="pilih-jalur">
    <div class="pilih-jalur-inner">
      <div class="pilih-jalur-header">
        <div>
          <span class="pilih-jalur-label">{{ label }}</span>
          <h2 class="pilih-jalur-title">{{ title }}</h2>
        </div>
        <a class="pilih-jalur-btn" :href="seeAllLink">{{ seeAllText }}</a>
      </div>

      <div class="pilih-jalur-grid">
        <div v-for="card in programs" :key="card.nama" class="pilih-jalur-card">
          <div class="pilih-jalur-img-wrap">
            <img :src="card.image" :alt="`Siswa praktik jurusan ${card.nama}`" class="pilih-jalur-img" />
            <span v-if="card.badge" class="pilih-jalur-badge" :style="{ background: card.badgeColor }">{{ card.badge }}</span>
          </div>
          <div class="pilih-jalur-body">
            <div class="pilih-jalur-card-header">
              <span class="pilih-jalur-icon" v-html="card.icon"></span>
              <h3 class="pilih-jalur-name">{{ card.nama }}</h3>
            </div>
            <p class="pilih-jalur-text">{{ card.deskripsi }}</p>
            <a class="pilih-jalur-detail" :href="card.link">Detail Jurusan</a>
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
    default: 'PROGRAM KEAHLIAN'
  },
  title: {
    type: String,
    default: 'Pilih Jalur Karirmu'
  },
  seeAllText: {
    type: String,
    default: 'Lihat Semua Jurusan'
  },
  seeAllLink: {
    type: String,
    default: '#pendaftaran'
  },
  programs: {
    type: Array,
    default: () => [
      {
        badge: 'Populer',
        badgeColor: '#042d86',
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>',
        nama: 'RPL',
        deskripsi: 'Pengembangan Perangkat Lunak & Gim. Belajar coding, UI/UX, dan data science dengan kurikulum industri.',
        image: 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=800&q=80',
        link: '#pendaftaran'
      },
      {
        badge: 'Center of Excellence',
        badgeColor: '#b45309',
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"></path><path d="m3.3 7 8.7 5 8.7-5"></path><path d="M12 22V12"></path></svg>',
        nama: 'MPLB',
        deskripsi: 'Manajemen Perkantoran & Layanan Bisnis. Menguasai tata kelola bisnis digital dan administrasi modern.',
        image: 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=800&q=80',
        link: '#pendaftaran'
      },
      {
        badge: null,
        badgeColor: null,
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.55a11 11 0 0 1 14.08 0"></path><path d="M1.42 9a16 16 0 0 1 21.16 0"></path><path d="M8.53 16.11a6 6 0 0 1 6.95 0"></path><circle cx="12" cy="20" r="1"></circle></svg>',
        nama: 'TKJ',
        deskripsi: 'Teknik Jaringan Komputer & Telekomunikasi. Menjadi ahli infrastruktur IT, cloud, dan cyber security.',
        image: 'https://images.unsplash.com/photo-1558494949-ef526b0042a0?w=800&q=80',
        link: '#pendaftaran'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.pilih-jalur {
  background: #ffffff;
  padding: 5rem 0;
}

.pilih-jalur-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
}

.pilih-jalur-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1.5rem;
  margin-bottom: 3rem;
  flex-wrap: wrap;
}

.pilih-jalur-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #b45309;
  margin-bottom: 0.5rem;
}

.pilih-jalur-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.8rem, 2.8vw, 2.4rem);
  color: #0f172a;
  margin: 0;
}

.pilih-jalur-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  background: #042d86;
  color: #ffffff;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  white-space: nowrap;
  flex-shrink: 0;
}

.pilih-jalur-btn:hover {
  background: #032263;
}

.pilih-jalur-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .pilih-jalur-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .pilih-jalur-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }
}

.pilih-jalur-card {
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: #ffffff;
}

.pilih-jalur-img-wrap {
  position: relative;
  aspect-ratio: 4/3;
  overflow: hidden;
}

.pilih-jalur-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.pilih-jalur-badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  padding: 0.35rem 0.9rem;
  border-radius: 9999px;
  color: #ffffff;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.02em;
}

.pilih-jalur-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  flex: 1;
}

.pilih-jalur-card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.pilih-jalur-icon {
  width: 2.25rem;
  height: 2.25rem;
  display: grid;
  place-items: center;
  border-radius: 0.75rem;
  background: #f1f5f9;
  color: #042d86;
  flex-shrink: 0;
}

.pilih-jalur-name {
  font-family: $font-display;
  font-weight: 800;
  font-size: 1.35rem;
  color: #0f172a;
  margin: 0;
}

.pilih-jalur-text {
  font-size: 0.95rem;
  color: #334155;
  line-height: 1.7;
  margin: 0;
}

.pilih-jalur-detail {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 0.65rem;
  border: 1px solid #042d86;
  color: #042d86;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.9rem;
  text-decoration: none;
  margin-top: auto;
  transition: background-color 0.2s, color 0.2s;
}

.pilih-jalur-detail:hover {
  background: #042d86;
  color: #ffffff;
}
</style>
