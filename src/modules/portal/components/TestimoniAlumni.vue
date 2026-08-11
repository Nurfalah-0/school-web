<template>
  <section class="testimoni-alumni">
    <div class="testimoni-inner">
      <h2 class="testimoni-title">{{ title }}</h2>
      <div class="testimoni-grid">
        <div v-for="item in testimoni" :key="item.nama" class="testimoni-card">
          <div class="testimoni-header">
            <div class="testimoni-avatar-wrap">
              <img :src="item.foto" :alt="`Foto ${item.nama}, alumni`" class="testimoni-avatar" />
            </div>
            <div class="testimoni-meta">
              <div class="testimoni-name">{{ item.nama }}</div>
              <div class="testimoni-role">{{ item.jabatan }}</div>
            </div>
            <div class="testimoni-quote-mark">&ldquo;</div>
          </div>
          <p class="testimoni-text">{{ item.kutipan }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import avatarAhmad from '../../../assets/profile-bintang.webp';
import avatarRina from '../../../assets/profile-penobatan.webp';

defineProps({
  title: {
    type: String,
    default: 'Apa Kata Alumni?'
  },
  testimoni: {
    type: Array,
    default: () => [
      {
        foto: avatarAhmad,
        nama: 'Ahmad Fauzi',
        jabatan: 'Alumni RPL - Senior Dev at GoTo',
        kutipan: 'SMK Nurul Jadid memberikan fondasi yang kuat, tidak hanya teknis tapi juga mentalitas pembelajar. Fasilitas TEFA benar-benar membantu saya merasakan atmosfer kerja sejak dini.'
      },
      {
        foto: avatarRina,
        nama: 'Rina Wijaya',
        jabatan: 'HR Director - PT. Tech Innovate',
        kutipan: 'Kami sering merekrut lulusan SMK Nurul Jadid karena mereka memiliki \'attitude\' yang luar biasa dan \'skill\' yang sangat relevan dengan kebutuhan industri saat ini.'
      }
    ]
  }
});
</script>

<style lang="scss" scoped>
.testimoni-alumni {
  position: relative;
  background: #f8fafc;
  padding: 5rem 0;
  border-top: 4px solid #042d86;
}

.testimoni-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.testimoni-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  text-align: center;
  margin: 0 0 3rem;
}

.testimoni-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .testimoni-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

.testimoni-card {
  background: #ffffff;
  border-radius: 1.5rem;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
  border: 1px solid #e2e8f0;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.testimoni-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
}

.testimoni-avatar-wrap {
  flex-shrink: 0;
}

.testimoni-avatar {
  width: 3rem;
  height: 3rem;
  border-radius: 9999px;
  object-fit: cover;
  display: block;
}

.testimoni-meta {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.testimoni-name {
  font-weight: 700;
  font-size: 1rem;
  color: #042d86;
}

.testimoni-role {
  font-size: 0.9rem;
  color: #64748b;
}

.testimoni-quote-mark {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-size: 4rem;
  line-height: 1;
  color: #e2e8f0;
  font-weight: 800;
}

.testimoni-text {
  font-size: 1rem;
  color: #334155;
  line-height: 1.75;
  margin: 0;
}

@media (max-width: 767px) {
  .testimoni-card {
    padding: 1.5rem;
  }
}
</style>
