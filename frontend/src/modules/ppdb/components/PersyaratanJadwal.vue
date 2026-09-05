<template>
  <section class="syarat-section">
    <div class="syarat-inner">
      <div class="syarat-col">
        <h2 class="syarat-title">{{ titleSyarat }}</h2>
        <div class="syarat-grid">
          <div v-for="item in syarat" :key="item.nama" class="syarat-item">
            <span class="syarat-icon" v-html="item.icon"></span>
            <div>
              <strong class="syarat-name">{{ item.nama }}</strong>
              <p class="syarat-sub">{{ item.sub }}</p>
            </div>
          </div>
        </div>
      </div>

      <div class="syarat-col">
        <h2 class="syarat-title">{{ titleJadwal }}</h2>
        <div class="syarat-timeline">
          <div v-for="(item, idx) in jadwal" :key="item.tanggal" :class="['syarat-timeline-item', { highlighted: item.highlighted }]">
            <div class="syarat-date-box">
              <strong>{{ item.tanggal }}</strong>
              <span>{{ item.bulan }}</span>
            </div>
            <div class="syarat-event">
              <h4 class="syarat-event-title">{{ item.title }}</h4>
              <p class="syarat-event-text">{{ item.text }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  titleSyarat: {
    type: String,
    default: 'Persyaratan Berkas'
  },
  titleJadwal: {
    type: String,
    default: 'Jadwal Penting'
  },
  syarat: {
    type: Array,
    default: () => [
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>',
        nama: 'FC Ijazah/SKL',
        sub: 'Dilegalisir 2 lembar'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="M2 7h20"/></svg>',
        nama: 'Kartu Keluarga',
        sub: 'Scan asli/fotokopi'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="3" rx="2" ry="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>',
        nama: 'Pas Foto 3x4',
        sub: 'Latar belakang merah (4 lbr)'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/></svg>',
        nama: 'Rapor SMP',
        sub: 'Semester 1 s.d 5'
      }
    ]
  },
  jadwal: {
    type: Array,
    default: () => [
      { tanggal: '15', bulan: 'JANUARI', title: 'Pembukaan Gelombang 1', text: 'Pendaftaran online & luring dimulai.', highlighted: false },
      { tanggal: '20', bulan: 'MARET', title: 'Tes Seleksi Akademik', text: 'Gelombang 1 serentak di kampus.', highlighted: false },
      { tanggal: '01', bulan: 'APRIL', title: 'Pengumuman Kelulusan', text: 'Cek hasil melalui dashboard portal.', highlighted: true },
      { tanggal: '10', bulan: 'APRIL', title: 'Daftar Ulang', text: 'Melengkapi administrasi & ukuran seragam.', highlighted: false }
    ]
  }
});
</script>

<style lang="scss" scoped>
.syarat-section {
  background: #ffffff;
  padding: 5rem 0;
}

.syarat-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
}

@media (min-width: 768px) {
  .syarat-inner {
    grid-template-columns: 1fr 1fr;
    gap: 4rem;
  }
}

.syarat-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.6rem, 2.5vw, 2rem);
  color: #0f172a;
  margin: 0 0 1.5rem;
}

.syarat-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.25rem;
}

@media (min-width: 640px) {
  .syarat-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

.syarat-item {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
}

.syarat-icon {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.75rem;
  background: #eff6ff;
  color: #042d86;
  display: grid;
  place-items: center;
  flex-shrink: 0;
}

.syarat-name {
  display: block;
  font-weight: 700;
  font-size: 0.95rem;
  color: #0f172a;
  margin: 0 0 0.15rem;
}

.syarat-sub {
  font-size: 0.85rem;
  color: #64748b;
  margin: 0;
}

.syarat-timeline {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.syarat-timeline-item {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
  padding: 1rem;
  border-radius: 1rem;
  transition: background-color 0.2s;
}

.syarat-timeline-item.highlighted {
  background: #fffbeb;
  border: 1px solid #fde68a;
}

.syarat-date-box {
  width: 4.5rem;
  height: 4.5rem;
  border-radius: 1rem;
  background: #ffffff;
  border: 1.5px solid #042d86;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.15rem;
  flex-shrink: 0;
}

.syarat-timeline-item.highlighted .syarat-date-box {
  background: #fffbeb;
  border-color: #d97706;
}

.syarat-date-box strong {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.25rem;
  color: #042d86;
  line-height: 1;
}

.syarat-timeline-item.highlighted .syarat-date-box strong {
  color: #b45309;
}

.syarat-date-box span {
  font-size: 0.65rem;
  font-weight: 700;
  color: #64748b;
  letter-spacing: 0.08em;
}

.syarat-timeline-item.highlighted .syarat-date-box span {
  color: #92400e;
}

.syarat-event {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding-top: 0.25rem;
}

.syarat-event-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1rem;
  color: #0f172a;
  margin: 0;
}

.syarat-event-text {
  font-size: 0.9rem;
  color: #475569;
  line-height: 1.5;
  margin: 0;
}
</style>
