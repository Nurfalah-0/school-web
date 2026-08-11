<template>
  <section class="statistik-sekolah">
    <div class="statistik-inner">
      <div class="statistik-grid">
        <div v-for="item in stats" :key="item.label" class="statistik-item">
          <div class="statistik-number">{{ animatedValues[item.label] || 0 }}</div>
          <div class="statistik-label">{{ item.label }}</div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, reactive, onMounted, onBeforeUnmount } from 'vue';

const props = defineProps({
  stats: {
    type: Array,
    default: () => [
      { angka: 1200, label: 'SISWA AKTIF' },
      { angka: 85, label: 'GURU & STAFF' },
      { angka: 4500, label: 'ALUMNI SUKSES' },
      { angka: 50, label: 'PARTNER INDUSTRI' }
    ]
  }
});

const animatedValues = reactive({});
let observer = null;

const animateCount = (entry) => {
  if (entry.isIntersecting) {
    const stat = props.stats.find(s => s.label === entry.target.dataset.label);
    if (!stat) return;

    const duration = 1800;
    const startTime = performance.now();
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (prefersReducedMotion) {
      animatedValues[stat.label] = stat.angka;
      return;
    }

    const step = (currentTime) => {
      const elapsed = currentTime - startTime;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      animatedValues[stat.label] = Math.floor(eased * stat.angka);
      if (progress < 1) {
        requestAnimationFrame(step);
      } else {
        animatedValues[stat.label] = stat.angka;
      }
    };

    requestAnimationFrame(step);
    observer.unobserve(entry.target);
  }
};

onMounted(() => {
  observer = new IntersectionObserver((entries) => {
    entries.forEach(animateCount);
  }, { threshold: 0.3 });

  props.stats.forEach((stat) => {
    const el = document.querySelector(`[data-label="${stat.label}"]`);
    if (el) observer.observe(el);
  });
});

onBeforeUnmount(() => {
  if (observer) observer.disconnect();
});
</script>

<style lang="scss" scoped>
.statistik-sekolah {
  background: #28469E;
  padding: 5rem 0;
}

.statistik-inner {
  width: min(1256px, calc(100% - 48px));
  margin: 0 auto;
}

.statistik-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
}

@media (min-width: 640px) {
  .statistik-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2.5rem;
  }
}

@media (min-width: 1024px) {
  .statistik-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 2rem;
  }
}

.statistik-item {
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.statistik-number {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(2.5rem, 3.5vw, 3.5rem);
  color: #ffffff;
  line-height: 1;
}

.statistik-label {
  margin-top: 0.5rem;
  color: #c7d2fe;
  font-size: 0.85rem;
  font-weight: 600;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}
</style>
