<template>
  <section class="jobs-section" id="lowongan">
    <div class="container section-block jobs-block">
      <div class="section-heading section-heading-inline">
        <div>
          <h2>Lowongan Terkini</h2>
          <p>Temukan posisi yang sesuai dengan kompetensi dan jurusanmu.</p>
        </div>
        <div class="job-filters">
          <button class="filter-pill active">Semua</button>
          <button class="filter-pill">PKL</button>
          <button class="filter-pill">Full-time</button>
        </div>
      </div>

      <div class="job-grid">
        <article v-for="job in jobs" :key="job.title" class="job-card">
          <div class="job-top">
            <div class="job-icon">★</div>
            <span class="job-badge">{{ job.type }}</span>
          </div>
          <h3>{{ job.title }}</h3>
          <p class="job-company">{{ job.company }}</p>
          <ul>
            <li v-for="detail in job.details" :key="detail">{{ detail }}</li>
          </ul>
          <a class="button-primary button-small" href="#pendaftaran">Lamar Sekarang</a>
        </article>
      </div>

      <div class="jobs-footer-link">
        <a href="#pendaftaran">Lihat Semua 50+ Lowongan Lainnya →</a>
      </div>
    </div>
  </section>
</template>

<script setup>
const props = defineProps({
  jobs: {
    type: Array,
    default: () => []
  }
});
</script>
