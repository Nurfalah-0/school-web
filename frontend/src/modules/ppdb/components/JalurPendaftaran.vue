<template>
  <section class="jalur-section">
    <div class="jalur-inner">
      <div class="jalur-header">
        <h2 class="jalur-title">{{ title }}</h2>
        <p class="jalur-subtitle">{{ subtitle }}</p>
      </div>
      <div class="jalur-grid">
        <div
          v-for="item in jalur"
          :key="item.judul"
          :class="['jalur-card', { highlighted: item.highlighted }]"
        >
          <span class="jalur-badge" :style="{ background: item.badgeBg, color: item.badgeColor }">
            {{ item.badge }}
          </span>
          <h3 class="jalur-name">{{ item.judul }}</h3>
          <p class="jalur-text">{{ item.deskripsi }}</p>
          <ul class="jalur-features">
            <li v-for="poin in item.poin" :key="poin">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              {{ poin }}
            </li>
          </ul>
          <a :href="item.link" :class="['jalur-btn', { primary: item.highlighted }]" @click.prevent="scrollToPendaftaran">
            {{ item.btnText }}
          </a>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: 'Pilih Jalur Pendaftaranmu'
  },
  subtitle: {
    type: String,
    default: 'Tersedia berbagai pilihan jalur masuk yang sesuai dengan potensi dan kondisi Anda.'
  },
  jalur: {
    type: Array,
    default: () => [
      {
        badge: 'Umum',
        badgeBg: '#dbeafe',
        badgeColor: '#1e40af',
        judul: 'Jalur Reguler',
        deskripsi: 'Terbuka untuk seluruh lulusan SMP/MTs sederajat melalui seleksi nilai rapor dan tes.',
        poin: ['Nilai Rapor Sem 1-5', 'Tes Peminatan'],
        btnText: 'Pilih Jalur',
        link: '#pendaftaran',
        highlighted: false
      },
      {
        badge: 'Unggulan',
        badgeBg: '#fef3c7',
        badgeColor: '#92400e',
        judul: 'Jalur Prestasi',
        deskripsi: 'Bagi siswa dengan capaian akademik maupun non-akademik di tingkat regional/nasional.',
        poin: ['Bebas Tes Akademik', 'Sertifikat Kejuaraan', 'Potongan Biaya SPP'],
        btnText: 'Daftar Sekarang',
        link: '#pendaftaran',
        highlighted: true
      },
      {
        badge: 'Khusus',
        badgeBg: '#bbf7d0',
        badgeColor: '#166534',
        judul: 'Jalur Afirmasi',
        deskripsi: 'Ditujukan bagi siswa dari keluarga kurang mampu atau wilayah tertinggal/terluar.',
        poin: ['Bantuan Pendidikan', 'Kartu KIP/PKH'],
        btnText: 'Pilih Jalur',
        link: '#pendaftaran',
        highlighted: false
      }
    ]
  }
});

const scrollToPendaftaran = () => {
  const el = document.querySelector('#pendaftaran');
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    const input = el.querySelector('input');
    if (input) {
      setTimeout(() => input.focus(), 600);
    }
  }
};
</script>

<style lang="scss" scoped>
.jalur-section {
  background: #f0fdfa;
  padding: 5rem 0;
  border-radius: 2.5rem 2.5rem 0 0;
  margin-top: -1px;
}

.jalur-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.jalur-header {
  text-align: center;
  margin-bottom: 3rem;
}

.jalur-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 0.75rem;
}

.jalur-subtitle {
  color: #475569;
  font-size: 1rem;
  margin: 0;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.7;
}

.jalur-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .jalur-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
    align-items: start;
  }
}

.jalur-card {
  background: #ffffff;
  border-radius: 1.5rem;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  border: 2px solid #e2e8f0;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
  position: relative;
  transition: transform 0.2s, box-shadow 0.2s;
}

.jalur-card.highlighted {
  border-color: #d97706;
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(217, 119, 6, 0.12);
}

.jalur-badge {
  display: inline-flex;
  padding: 0.35rem 0.9rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 800;
  letter-spacing: 0.06em;
  width: fit-content;
}

.jalur-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.35rem;
  color: #0f172a;
  margin: 0;
}

.jalur-text {
  color: #475569;
  font-size: 0.95rem;
  line-height: 1.7;
  margin: 0;
}

.jalur-features {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.jalur-features li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #334155;
  font-size: 0.95rem;
}

.jalur-features li svg {
  color: #042d86;
  flex-shrink: 0;
}

.jalur-card.highlighted .jalur-features li svg {
  color: #d97706;
}

.jalur-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 0.75rem;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  margin-top: auto;
  transition: background-color 0.2s, color 0.2s;
}

.jalur-btn:not(.primary) {
  background: transparent;
  color: #042d86;
  border: 1.5px solid #042d86;
}

.jalur-btn:not(.primary):hover {
  background: #042d86;
  color: #ffffff;
}

.jalur-btn.primary {
  background: #042d86;
  color: #ffffff;
  border: 1.5px solid #042d86;
}

.jalur-btn.primary:hover {
  background: #032263;
}
</style>
