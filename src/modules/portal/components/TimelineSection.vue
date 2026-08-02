<template>
  <section class="timeline-section">
    <div class="container section-block timeline-block">
      <div class="section-heading section-heading-center white-text">
        <h2>Timeline Seleksi &amp; Penempatan</h2>
        <p>Panduan waktu untuk persiapan karirmu tahun ajaran ini.</p>
      </div>
      <div class="timeline-line"></div>
      <div class="timeline-grid">
        <div v-for="item in timeline" :key="item.step" class="timeline-card timeline-card-dark">
          <div class="timeline-circle">{{ item.step }}</div>
          <h3>{{ item.title }}</h3>
          <p>{{ item.text }}</p>
          <span>{{ item.duration }}</span>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
const props = defineProps({
  timeline: {
    type: Array,
    default: () => []
  }
});
</script>
