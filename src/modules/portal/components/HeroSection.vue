<template>
  <section class="hero-section" id="hero">
    <div class="hero-inner">
      <div class="hero-copy">
        <span class="hero-label">Enrollment Open 2024/2025</span>
        <h1 class="hero-title">
          <span class="hero-accent">Mencetak</span> <span class="hero-highlight">Generasi</span>
          <br />
          <span class="hero-accent">Unggul</span> <span class="hero-highlight">Masa Depan</span>
        </h1>
        <p class="hero-description">
          Vokasi SMK Nurul Jadid hadir dengan kurikulum berbasis industri dan
          karakter kepesantrenan untuk mewujudkan impian karirmu.
        </p>

        <div class="hero-actions">
          <a class="button-primary" href="#pendaftaran">Daftar PPDB Sekarang</a>
          <a class="button-secondary" href="#profil">Lihat Profil</a>
        </div>
      </div>

      <div class="hero-visual">
        <div class="hero-card-wrap">
          <div class="hero-card">
            <img :src="heroImg" alt="Siswa SMK Nurul Jadid" />
          </div>

          <div class="hero-stat-card hero-stat-top">
            <div class="hero-stat-icon bg-teal">👥</div>
            <div class="hero-stat-text">
              <strong>1200+</strong>
              <p>Siswa Aktif</p>
            </div>
          </div>

          <div class="hero-stat-card hero-stat-bottom">
            <div class="hero-stat-icon bg-amber">🏆</div>
            <div class="hero-stat-text">
              <strong>85%</strong>
              <p>Lulusan Bekerja</p>
            </div>
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
@use '../../../assets/styles/variables' as *;

.hero-section {
  position: relative;
  padding: 100px 0 100px;
  min-height: 760px;
  background: linear-gradient(90deg, #ffffff 0%, #bfdbfe 45%, #1e3a8a 100%);
}

.hero-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: $hero-left-width 1fr;
  align-items: center;
  gap: 32px;
}

.hero-copy {
  display: flex;
  flex-direction: column;
  gap: 18px;
  position: relative;
  z-index: 2;
}

.hero-label {
  display: inline-flex;
  align-items: center;
  padding: 8px 20px;
  border-radius: 9999px;
  background: #8a7141;
  color: #fff;
  font-size: 1rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  width: fit-content;
}

.hero-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(3rem, 4.8vw, 5.75rem);
  line-height: 1.05;
  letter-spacing: -0.04em;
  color: #0f172a;
  margin: 0;
}

.hero-accent {
  color: #8a7141;
}

.hero-highlight {
  color: #1e3a8a;
  display: inline;
}

.hero-description {
  max-width: 600px;
  color: #1e293b;
  font-size: 1.15rem;
  line-height: 1.8;
  margin: 0;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
  flex-wrap: wrap;
}

.hero-actions .button-primary {
  padding: 18px 32px;
  background: $accent;
  color: #291800;
  border: none;
}

.hero-actions .button-secondary {
  padding: 18px 32px;
  border: 2px solid rgba(30, 58, 138, 0.6);
  color: #1e3a8a;
  background: rgba(255, 255, 255, 0.25);
  backdrop-filter: blur(6px);
}

.hero-visual {
  position: relative;
  display: block;
}

.hero-card-wrap {
  position: relative;
  width: 100%;
  max-width: 540px;
  margin-left: auto;
}

.hero-card {
  position: relative;
  border-radius: 62% 38% 55% 45% / 50% 60% 40% 50%;
  overflow: hidden;
  background: #efecff;
  min-height: $hero-visual-height;
  box-shadow: 0 35px 80px rgba(40, 70, 158, 0.25);
}

.hero-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, rgba(4, 45, 134, 0) 0%, rgba(4, 45, 134, 0.15) 100%);
  pointer-events: none;
}

.hero-card img {
  width: 100%;
  height: $hero-visual-height;
  object-fit: cover;
  display: block;
}

.hero-stat-card {
  position: absolute;
  z-index: 20;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 20px 24px;
  border-radius: 24px;
  background: #ffffff;
  box-shadow: 0 20px 25px rgba(0, 0, 0, 0.1);
}

.hero-stat-top {
  top: -24px;
  left: -24px;
}

.hero-stat-bottom {
  bottom: -24px;
  right: -24px;
}

.hero-stat-icon {
  width: 48px;
  height: 48px;
  display: grid;
  place-items: center;
  border-radius: 16px;
  font-size: 1.4rem;
}

.hero-stat-icon.bg-teal {
  background: #cae8e8;
  color: #0f172a;
}

.hero-stat-icon.bg-amber {
  background: #fef3c7;
  color: #92400e;
}

.hero-stat-text {
  display: flex;
  flex-direction: column;
}

.hero-stat-text strong {
  font-family: $font-display;
  font-size: 1.35rem;
  color: #042d86;
  line-height: 1.2;
}

.hero-stat-text p {
  margin: 0;
  color: #042d86;
  font-weight: 600;
  font-size: 0.9rem;
}

@media (max-width: 1100px) {
  .hero-section {
    background: linear-gradient(180deg, #ffffff 0%, #bfdbfe 50%, #1e3a8a 100%);
    padding-top: 80px;
    padding-bottom: 80px;
  }

  .hero-inner {
    grid-template-columns: 1fr;
    gap: 3rem;
  }

  .hero-copy {
    width: 100%;
    max-width: 100%;
    text-align: center;
    align-items: center;
  }

  .hero-label {
    margin: 0 auto;
  }

  .hero-description {
    margin: 0 auto;
    max-width: 100%;
  }

  .hero-actions {
    justify-content: center;
  }

  .hero-visual {
    order: -1;
  }

  .hero-card-wrap {
    max-width: 420px;
    margin: 0 auto;
  }

  .hero-card img {
    height: 360px;
  }

  .hero-stat-top {
    top: -12px;
    left: 12px;
  }

  .hero-stat-bottom {
    bottom: -12px;
    right: 12px;
  }
}

@media (max-width: 760px) {
  .hero-section {
    padding-top: 4rem;
    padding-bottom: 4rem;
  }

  .hero-copy {
    gap: 14px;
  }

  .hero-card img {
    height: 280px;
  }

  .hero-stat-card {
    padding: 14px 18px;
    gap: 0.75rem;
  }

  .hero-stat-icon {
    width: 40px;
    height: 40px;
    font-size: 1.1rem;
  }

  .hero-stat-text strong {
    font-size: 1.1rem;
  }
}
</style>
