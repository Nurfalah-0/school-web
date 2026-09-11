<template>
  <section class="mitra-section">
    <div class="mitra-inner">
      <div class="mitra-header">
        <h2 class="mitra-title">{{ title }}</h2>
        <p class="mitra-subtitle">{{ subtitle }}</p>
      </div>
      <div class="mitra-grid">
        <div v-for="(partner, idx) in activePartners" :key="partner.name || idx" class="mitra-card">
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
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { getPublicContent } from '@/api/endpoints';
import { publicImage } from '@/modules/contentMapper';

defineProps({
  title: {
    type: String,
    default: 'Mitra Industri Terpercaya'
  },
  subtitle: {
    type: String,
    default: 'Bekerjasama dengan lebih dari 100+ perusahaan berskala nasional dan multinasional.'
  }
});

const apiPartners = ref([]);

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
  padding: 5rem 0;
}

.mitra-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.mitra-header {
  text-align: center;
  margin-bottom: 3rem;
}

.mitra-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 0.75rem;
}

.mitra-subtitle {
  color: #475569;
  font-size: 1rem;
  margin: 0;
}

.mitra-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1rem;
}

@media (min-width: 640px) {
  .mitra-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 1.25rem;
  }
}

@media (min-width: 1024px) {
  .mitra-grid {
    grid-template-columns: repeat(6, minmax(0, 1fr));
    gap: 1.5rem;
  }
}

.mitra-card {
  background: #ffffff;
  border-radius: 1rem;
  padding: 1rem;
  height: 6rem;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
  transition: all 0.25s ease;

  &:hover {
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    transform: translateY(-2px);
  }
}

.mitra-logo {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  filter: grayscale(100%) opacity(0.7);
  transition: filter 0.2s;
}

.mitra-card:hover .mitra-logo {
  filter: grayscale(0%) opacity(1);
}
</style>
