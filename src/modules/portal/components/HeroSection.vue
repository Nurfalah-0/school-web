<template>
  <header class="hero-section" id="hero">
    <div class="container hero-inner">
      <div class="hero-copy">
        <span class="hero-label">Enrollment Open 2024/2025</span>
        <h1>
          Mencetak <span class="hero-accent">Generasi</span>
          <span class="hero-highlight">Unggul Masa Depan</span>
        </h1>
        <p>
          Vokasi SMK Nurul Jadid hadir dengan kurikulum berbasis industri dan karakter
          kepesantrenan untuk mewujudkan impian karirmu.
        </p>

        <div class="hero-actions">
          <a class="button-primary" href="#pendaftaran">Daftar PPDB Sekarang</a>
          <a class="button-secondary" href="#profil">Lihat Profil</a>
        </div>
      </div>

      <div class="hero-visual">
        <div class="hero-card">
          <img :src="heroImg" alt="Siswa SMK Nurul Jadid" />
        </div>

        <div class="hero-stat-grid">
          <article class="stat-box">
            <div class="stat-icon">👥</div>
            <div>
              <strong>1200+</strong>
              <p>Siswa Aktif</p>
            </div>
          </article>

          <article class="stat-box stat-box-secondary">
            <div class="stat-icon">🏆</div>
            <div>
              <strong>85%</strong>
              <p>Lulusan Bekerja</p>
            </div>
          </article>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import heroImg from '../../../assets/hero-lab.webp';
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.hero-copy {
  width: $hero-left-width;
  max-width: $hero-left-width;
}

.hero-actions a {
  min-width: 180px;
}

.hero-visual {
  display: block;
  position: relative;
  width: calc(100% - #{$hero-left-width});
}

.hero-card {
  border-radius: 48px;
  overflow: hidden;
  width: 100%;
  max-width: 720px;
}

.hero-stat-grid {
  right: -24px;
  bottom: 24px;
}

@media (max-width: 1100px) {
  .hero-inner {
    grid-template-columns: 1fr;
  }

  .hero-copy {
    width: 100%;
    max-width: 100%;
  }

  .hero-card img {
    height: 320px;
  }
}

</style>

