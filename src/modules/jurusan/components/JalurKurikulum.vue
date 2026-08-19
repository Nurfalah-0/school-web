<template>
  <section class="kurikulum-section" id="kurikulum">
    <div class="kurikulum-inner">
      <h2 class="kurikulum-title">Jalur Kurikulum</h2>
      <div class="kurikulum-timeline">
        <div v-for="(step, idx) in kurikulum" :key="idx" class="kurikulum-step">
          <div class="kurikulum-step-marker">
            <span class="kurikulum-dot" :style="{ background: dotColor(step.warna) }"></span>
          </div>
          <div class="kurikulum-step-card">
            <h3 class="kurikulum-step-title" :style="{ color: dotColor(step.warna) }">{{ step.kelas }}</h3>
            <p class="kurikulum-step-desc">{{ step.deskripsi }}</p>
            <div class="kurikulum-tags">
              <span v-for="tag in step.tags" :key="tag" class="kurikulum-tag">{{ tag }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  kurikulum: {
    type: Array,
    required: true
  }
})

function dotColor(warna) {
  if (warna === 'teal') return '#0f766e'
  if (warna === 'gold') return '#92400e'
  return '#1e3a5f'
}
</script>

<style lang="scss" scoped>
.kurikulum-section {
  background: transparent;
  padding: 0;
}

.kurikulum-inner {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1.5rem 2rem;
}

@media (min-width: 768px) {
  .kurikulum-inner {
    padding: 0 0 3rem;
  }
}

.kurikulum-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.5rem;
  color: #1e3a5f;
  margin: 0 0 2rem;
}

.kurikulum-timeline {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  position: relative;
  padding-left: 1.5rem;
  border-left: 2px solid #e2e8f0;
}

.kurikulum-step {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 1.5rem;
  align-items: start;
}

.kurikulum-step-marker {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
  margin-left: -1.85rem;
}

.kurikulum-dot {
  width: 0.875rem;
  height: 0.875rem;
  border-radius: 9999px;
  flex-shrink: 0;
  box-shadow: 0 0 0 4px rgba(30, 58, 95, 0.08);
}

.kurikulum-step-card {
  background: #ffffff;
  border-radius: 1.25rem;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.kurikulum-step-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  margin: 0 0 0.75rem;
}

.kurikulum-step-desc {
  font-size: 1rem;
  color: #64748b;
  line-height: 1.7;
  margin: 0 0 1rem;
  max-width: 42rem;
}

.kurikulum-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.kurikulum-tag {
  padding: 0.35rem 0.75rem;
  border-radius: 9999px;
  background: #eef2ff;
  color: #334155;
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.02em;
}
</style>
