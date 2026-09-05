<template>
  <section class="cta-prestasi">
    <div class="cta-prestasi-inner">
      <h2 class="cta-prestasi-title">Prestasi Membanggakan</h2>
      <p class="cta-prestasi-desc">
        Berikut adalah pencapaian siswa SMK CareerHub di berbagai bidang. Prestasi ini menjadi bukti komitmen kami dalam mencetak generasi unggul dan berdaya saing global.
      </p>
      <div class="cta-prestasi-stats">
        <div class="cta-stat">
          <span class="cta-stat-number">50+</span>
          <span class="cta-stat-label">Prestasi</span>
        </div>
        <div class="cta-stat">
          <span class="cta-stat-number">20+</span>
          <span class="cta-stat-label">Lomba</span>
        </div>
        <div class="cta-stat">
          <span class="cta-stat-number">15+</span>
          <span class="cta-stat-label">Medali</span>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
</script>

<style lang="scss" scoped>
.cta-prestasi {
  background: linear-gradient(135deg, #1e3a8a 0%, #16264d 100%);
  border-radius: 2rem;
  padding: 4rem 2rem;
  margin: 4rem auto;
  max-width: 80rem;
}

.cta-prestasi-inner {
  max-width: 48rem;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 1.5rem;
}

.cta-prestasi-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.75rem, 3vw, 2.5rem);
  color: #ffffff;
  margin: 0;
  line-height: 1.2;
}

.cta-prestasi-desc {
  font-size: 1.125rem;
  color: rgba(255, 255, 255, 0.85);
  line-height: 1.7;
  margin: 0;
  max-width: 36rem;
}

.cta-prestasi-stats {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 2rem;
  margin-top: 1rem;
}

.cta-stat {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
}

.cta-stat-number {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: 2.5rem;
  color: #fbbf24;
  line-height: 1;
}

.cta-stat-label {
  font-size: 0.9rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.8);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

@media (max-width: 767px) {
  .cta-prestasi {
    padding: 3rem 1.5rem;
    margin: 3rem 1rem;
    border-radius: 1.5rem;
  }

  .cta-prestasi-stats {
    gap: 1.5rem;
  }

  .cta-stat-number {
    font-size: 2rem;
  }
}
</style>
