<template>
  <section class="partners-section">
    <div class="container section-block partners-block">
      <div class="section-heading">
        <h2>Mitra Industri Terpercaya</h2>
        <p>Bekerja sama dengan lebih dari 100 perusahaan berskala nasional dan multinasional.</p>
      </div>
      <div class="partner-strip">
        <div v-for="partner in partners" :key="partner.name" class="partner-item">
          {{ partner.name }}
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
const props = defineProps({
  partners: {
    type: Array,
    default: () => []
  }
});
</script>
