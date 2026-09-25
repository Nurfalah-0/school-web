<template>
  <section class="mitra-section" aria-label="Mitra sekolah">
    <div class="mitra-marquee">
      <div class="mitra-track">
        <div v-for="groupIndex in marqueeGroups" :key="groupIndex" class="mitra-group">
          <div
            v-for="(partner, partnerIndex) in activePartners"
            :key="`${groupIndex}-${partnerIndex}`"
            class="mitra-card"
            :aria-hidden="groupIndex > 1 ? 'true' : undefined"
          >
            <img
              v-if="partner.logoSrc"
              :src="partner.logoSrc"
              :alt="partner.name"
              class="mitra-logo"
              loading="lazy"
            />
            <div v-else class="mitra-logo image-placeholder" aria-hidden="true"></div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { getPublicContent } from '@/api/endpoints';
import { publicImage } from '@/modules/contentMapper';

const apiPartners = ref([]);
const marqueeGroups = 3;

onMounted(async () => {
  try {
    const res = await getPublicContent('partners');
    const data = res.data?.data || [];
    if (data.length > 0) {
      apiPartners.value = data.map(p => ({
        name: p.name || p.company_name,
        logoSrc: publicImage(p.logo || p.image)
      }));
    }
  } catch (err) {
    // Graceful fallback
  }
});

const activePartners = computed(() => {
  return apiPartners.value;
});
</script>

<style lang="scss" scoped>
.mitra-section {
  background: #eff6ff;
  padding: 6rem 0;
  overflow: hidden;
}

.mitra-marquee {
  overflow: hidden;
}

.mitra-track {
  display: flex;
  align-items: center;
  width: max-content;
  animation: mitra-slide 8s linear infinite;
}

.mitra-group {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding-right: 1.5rem;
}

@keyframes mitra-slide {
  to {
    transform: translateX(-33.333333%);
  }
}

.mitra-card {
  flex: 0 0 15rem;
  width: 15rem;
  height: 8.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: #ffffff;
  border-radius: 1rem;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.25s ease, transform 0.25s ease;

  &:hover {
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    transform: translateY(-2px);
  }
}

.mitra-logo {
  display: block;
  max-width: 70%;
  max-height: 70%;
  width: auto;
  height: auto;
  object-fit: contain;
  background: transparent;
}

.image-placeholder {
  width: 70%;
  height: 70%;
  background: #e2e8f0;
  border-radius: 0.5rem;
}

@media (max-width: 640px) {
  .mitra-card {
    flex-basis: 9rem;
    width: 9rem;
    height: 5.5rem;
  }
}
</style>
