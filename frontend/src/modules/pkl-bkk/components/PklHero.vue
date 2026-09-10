<template>
  <section class="pkl-hero">
    <div class="pkl-hero-inner">
      <div class="pkl-hero-copy">
        <span class="pkl-hero-label">PUSAT KARIR & PKL</span>
        <h1 class="pkl-hero-title">
          <span>Membangun</span><br />
          <span>Jembatan Menuju</span><br />
          <span>Dunia Kerja</span><br />
          <span>Profesional</span>
        </h1>
        <p class="pkl-hero-desc">
          Akses langsung ke ratusan mitra industri terkemuka. Temukan tempat Praktik Kerja Lapangan (PKL) impianmu atau mulai karir profesionalmu bersama BKK SMK Nurul Jadid.
        </p>
        <div class="pkl-hero-actions">
          <a class="pkl-btn-primary" href="#pendaftaran">Ajukan PKL</a>
          <router-link class="pkl-btn-secondary" to="/lowongan">Lihat Lowongan</router-link>
        </div>
      </div>

      <div class="pkl-hero-visual">
        <div class="pkl-hero-blob-wrap">
          <div class="pkl-hero-decor"></div>
          <div class="pkl-hero-blob">
            <img :src="heroImg" alt="Siswa SMK Nurul Jadid praktik di lab" class="pkl-hero-img" />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import heroImg from '../../../assets/hero-lab.webp';
</script>

<style lang="scss" scoped>
.pkl-hero {
  background: linear-gradient(90deg, #ffffff 0%, #ffffff 65%, #eff6ff 100%);
  padding: 5rem 0;
}

.pkl-hero-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
  align-items: center;
}

@media (min-width: 768px) {
  .pkl-hero-inner {
    grid-template-columns: 1fr 1fr;
    gap: 4rem;
  }
}

.pkl-hero-copy {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.pkl-hero-label {
  display: inline-flex;
  padding: 0.4rem 1rem;
  border-radius: 9999px;
  background: #fef3c7;
  color: #92400e;
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  width: fit-content;
}

.pkl-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(2rem, 3.2vw, 3.25rem);
  line-height: 1.1;
  color: #042D86;
  margin: 0;
}

.pkl-hero-desc {
  color: #334155;
  font-size: 1.05rem;
  line-height: 1.75;
  margin: 0;
  max-width: 520px;
}

.pkl-hero-actions {
  display: flex;
  gap: 1rem;
  margin-top: 0.5rem;
  flex-wrap: wrap;
}

.pkl-btn-primary {
  padding: 0.9rem 1.75rem;
  background: #042d86;
  color: #ffffff;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 1rem;
  text-decoration: none;
  transition: background-color 0.2s;
}

.pkl-btn-primary:hover {
  background: #032263;
}

.pkl-btn-secondary {
  padding: 0.9rem 1.75rem;
  background: #ccfbf1;
  color: #0f172a;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 1rem;
  text-decoration: none;
  transition: background-color 0.2s;
}

.pkl-btn-secondary:hover {
  background: #99f6e4;
}

.pkl-hero-visual {
  position: relative;
  display: flex;
  justify-content: center;
}

.pkl-hero-blob-wrap {
  position: relative;
  width: 100%;
  max-width: 520px;
}

.pkl-hero-decor {
  position: absolute;
  top: -2rem;
  right: -2rem;
  width: 220px;
  height: 220px;
  background: rgba(226, 232, 240, 0.75);
  border-radius: 9999px;
  z-index: 0;
}

.pkl-hero-blob {
  position: relative;
  z-index: 10;
  border-radius: 2rem;
  overflow: hidden;
  box-shadow: 0 30px 70px rgba(4, 45, 134, 0.12);
}

.pkl-hero-img {
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  display: block;
}

@media (max-width: 767px) {
  .pkl-hero {
    padding-top: 4rem;
    padding-bottom: 4rem;
  }

  .pkl-hero-copy {
    text-align: center;
    align-items: center;
  }

  .pkl-hero-label {
    margin: 0 auto;
  }

  .pkl-hero-desc {
    margin: 0 auto;
  }

  .pkl-hero-actions {
    justify-content: center;
  }

  .pkl-hero-blob-wrap {
    max-width: 100%;
  }

  .pkl-hero-decor {
    display: none;
  }

  .pkl-hero-img {
    height: 320px;
    aspect-ratio: auto;
  }
}
</style>
