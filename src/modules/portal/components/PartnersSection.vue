<template>
  <section class="partners-section">
    <div class="container section-block partners-block">
      <div class="section-heading">
        <h2>Mitra Industri Terpercaya</h2>
        <p>Bekerja sama dengan lebih dari 100 perusahaan berskala nasional dan multinasional.</p>
      </div>
      <div class="partner-strip">
        <div v-for="partner in partners" :key="partner.name" class="partner-item">
          <img
            v-if="partner.logo"
            :src="partner.logo"
            :alt="`${partner.name} logo`"
            class="partner-logo"
            @error="handleLogoError(partner)"
          />
          <span v-else class="partner-fallback">{{ partner.name }}</span>
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

const handleLogoError = (partner) => {
  partner.logo = null;
};
</script>

<style scoped>
.partner-strip {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  justify-content: center;
  align-items: center;
  margin-top: 2rem;
}

.partner-item {
  min-width: 10rem;
  height: 6rem;
  padding: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(33, 37, 41, 0.08);
  border-radius: 1rem;
  background: #ffffff;
  box-shadow: 0 8px 30px rgba(15, 23, 42, 0.03);
}

.partner-logo {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.partner-fallback {
  font-weight: 700;
  color: #1f2937;
  text-align: center;
}
</style>
