<template>
  <section class="galeri-hero">
    <div class="galeri-hero-inner">
      <h1 class="galeri-hero-title">Galeri Sekolah</h1>
      <p class="galeri-hero-desc">
        Dokumentasi fasilitas, kegiatan, dan momen berharga di SMK Nurul Jadid.
        Jelajahi perjalanan inovasi dan prestasi siswa kami.
      </p>
    </div>
  </section>
</template>

<script setup>
</script>

<style lang="scss" scoped>
.galeri-hero {
  background: #ffffff;
  padding: 4rem 1.5rem;
  text-align: center;
}

.galeri-hero-inner {
  max-width: 42rem;
  margin: 0 auto;
}

.galeri-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(2rem, 4vw, 3rem);
  color: #0f172a;
  margin: 0;
  letter-spacing: -0.02em;
}

.galeri-hero-desc {
  margin-top: 1rem;
  font-size: 1.125rem;
  line-height: 1.6;
  color: #475569;
}
</style>
