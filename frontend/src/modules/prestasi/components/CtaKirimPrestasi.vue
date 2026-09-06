<template>
  <section class="cta-prestasi">
    <div class="cta-prestasi-inner">
      <h2 class="cta-prestasi-title">Terus Berusaha, Prestasi Menggapai Mereka yang Mencintai Proses</h2>
      <p class="cta-prestasi-desc">
        “Kegagalan adalah kesempatan untuk mulai lagi dengan lebih pintar.” — Jangan pernah berhenti mencoba, karena setiap usaha akan membawamu lebih dekat pada hasil yang membanggakan.
      </p>
      <div class="cta-prestasi-quotes">
        <blockquote class="cta-quote">“Senyumlah, karena kamu masih bisa berjuang.”</blockquote>
        <blockquote class="cta-quote">“Langkah kecil hari ini adalah langkah hebat esok hari.”</blockquote>
        <blockquote class="cta-quote">“Jangan takut gagal, takutlah untuk tidak mencoba.”</blockquote>
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

.cta-prestasi-quotes {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  width: 100%;
  max-width: 36rem;
}

.cta-quote {
  font-style: italic;
  font-weight: 600;
  font-size: 1.05rem;
  color: #fbbf24;
  margin: 0;
  padding: 0.75rem 1rem;
  border-left: 4px solid #fbbf24;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 0.5rem;
  text-align: left;
  line-height: 1.6;
}

@media (max-width: 767px) {
  .cta-prestasi {
    padding: 3rem 1.5rem;
    margin: 3rem 1rem;
    border-radius: 1.5rem;
  }

  .cta-prestasi-quotes {
    gap: 0.75rem;
  }
}
</style>
