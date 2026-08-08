<template>
  <section class="alumni-section" id="alumni">
    <div class="container section-block alumni-block">
      <div class="alumni-copy">
        <h2>Tracer Alumni &amp; Penyerapan Lulusan</h2>
        <p>
          Lulusan SMK Nurul Jadid tersebar di berbagai sektor industri, melanjutkan pendidikan
          tinggi, hingga membangun bisnis sendiri.
        </p>
        <div class="progress-list">
          <div v-for="metric in metrics" :key="metric.label" class="progress-item">
            <div class="progress-head">
              <span>{{ metric.label }}</span>
              <strong>{{ metric.value }}</strong>
            </div>
            <div class="progress-bar">
              <div :style="{ width: metric.value }"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="alumni-visual">
        <div class="map-card">
          <div class="map-title">Sebaran Wilayah Penempatan</div>
          <div class="map-dot dot-1"></div>
          <div class="map-dot dot-2"></div>
          <div class="map-dot dot-3"></div>
          <div class="map-dot dot-4"></div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
const props = defineProps({
  metrics: {
    type: Array,
    default: () => []
  }
});
</script>
