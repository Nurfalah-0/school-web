<template>
  <section class="guru-carousel-section section">
    <div class="section-header">
      <h2 class="guru-carousel-title">{{ title }}</h2>
      <p class="guru-carousel-subtitle">{{ subtitle }}</p>
    </div>

    <div class="guru-carousel-container">
      <div
        class="guru-carousel-track"
        :style="{ transform: trackTranslate }"
      >
        <div
          v-for="(item, idx) in items"
          :key="idx"
          class="guru-carousel-card"
        >
          <img
            v-if="item.photo"
            :src="item.photo"
            :alt="item.name"
            class="guru-card-img"
            loading="lazy"
          />
          <div v-else class="guru-carousel-card-placeholder">
            <UserRound :size="32" :color="varColorTextBody" />
          </div>
          <div class="guru-card-overlay">
            <p class="guru-card-name">{{ item.name }}</p>
            <p class="guru-card-position">{{ item.position }}</p>
          </div>
        </div>
      </div>

      <div class="guru-carousel-nav">
        <button
          type="button"
          class="guru-nav-btn"
          @click="prev"
          :aria-label="`Sebelumnya`"
        >
          <ChevronLeft :size="20" />
        </button>

        <div class="guru-dots">
          <button
            v-for="(dot, idx) in items.length"
            :key="idx"
            type="button"
            class="guru-dot"
            :class="{ active: currentIndex === idx }"
            @click="goTo(idx)"
            :aria-label="`Ke slide ${idx + 1}`"
          />
        </div>

        <button
          type="button"
          class="guru-nav-btn"
          @click="next"
          :aria-label="`Berikutnya`"
        >
          <ChevronRight :size="20" />
        </button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed, watch } from 'vue';
import { ChevronLeft, ChevronRight, UserRound } from 'lucide-vue-next';

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  subtitle: {
    type: String,
    default: '',
  },
  items: {
    type: Array,
    default: () => [],
  },
  currentIndex: {
    type: Number,
    default: 0,
  },
  visibleCount: {
    type: Number,
    default: 4,
  },
});

const emit = defineEmits(['next', 'prev', 'goto']);

const varColorTextBody = 'var(--color-text-body, #475569)';

const total = computed(() => props.items.length);
const maxIndex = computed(() => Math.max(0, props.items.length - props.visibleCount));

const clampedIndex = computed(() => {
  if (props.items.length <= props.visibleCount) return 0;
  return Math.min(props.currentIndex, maxIndex.value);
});

const trackTranslate = computed(() => {
  if (props.items.length <= props.visibleCount) return 'translateX(0)';
  const clamp = props.items.length - props.visibleCount;
  const idx = Math.min(props.currentIndex, clamp);
  return `translateX(-${idx * (100 / props.visibleCount)}%)`;
});

const emitDotsCount = computed(() => {
  if (props.items.length <= props.visibleCount) return 0;
  return props.items.length - props.visibleCount;
});

function next() {
  if (props.items.length <= props.visibleCount) return;
  emit('next');
}

function prev() {
  if (props.items.length <= props.visibleCount) return;
  emit('prev');
}

function goTo(idx) {
  emit('goto', idx);
}
</script>

<style lang="scss" scoped>
.section {
  width: min(1200px, calc(100% - 2rem));
  margin: 0 auto;
}

.guru-carousel-section {
  padding: 4rem 0;

  &:not(:last-child) {
    border-bottom: 1px solid var(--color-border, #e2e8f0);
  }
}

.section-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.guru-carousel-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.6rem, 2.5vw, 2.2rem);
  color: var(--color-text-heading, #0f172a);
  margin: 0;
}

.guru-carousel-subtitle {
  font-size: 0.95rem;
  color: var(--color-text-muted, #94a3b8);
  margin: 0.4rem 0 0;
}

.guru-carousel-container {
  position: relative;
  width: 100%;
}

.guru-carousel-track {
  display: flex;
  gap: 1.5rem;
  transition: transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  will-change: transform;
}

.guru-carousel-card {
  flex: 0 0 calc((100% - 3rem) / 4);
  position: relative;
  aspect-ratio: 3 / 4;
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
}

.guru-carousel-card-placeholder {
  width: 100%;
  height: 100%;
  background: var(--color-border-light, #e2e8f0);
  display: grid;
  place-items: center;
  color: var(--color-text-muted, #94a3b8);
}

.guru-card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.guru-card-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 1.25rem 1rem 1rem;
  background: var(--color-overlay-bg, rgba(15, 23, 42, 0.72));
  color: var(--color-overlay-text, #ffffff);
}

.guru-card-name {
  font-weight: 700;
  font-size: 0.95rem;
  margin: 0;
  line-height: 1.3;
}

.guru-card-position {
  font-size: 0.78rem;
  opacity: 0.85;
  margin: 0.15rem 0 0;
  line-height: 1.3;
}

.guru-carousel-nav {
  margin-top: 1.75rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.guru-nav-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  border-radius: 9999px;
  border: 1px solid var(--color-border, #cbd5e1);
  background: var(--color-bg-card, #ffffff);
  color: var(--color-text-body, #334155);
  cursor: pointer;
  transition: background 0.2s ease, color 0.2s ease;

  &:hover {
    background: var(--color-primary, #2563eb);
    color: var(--color-text-on-primary, #ffffff);
    border-color: var(--color-primary, #2563eb);
  }
}

.guru-dots {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  flex: 1;
}

.guru-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--color-border, #cbd5e1);
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    background: var(--color-primary, #2563eb);
  }
}

.guru-dot.active {
  width: 16px;
  background: var(--color-primary, #2563eb);
}

/* Desktop: 4 cards per row */
@media (min-width: 1025px) {
  .guru-carousel-card {
    flex: 0 0 calc((100% - 3rem) / 4);
  }
}

/* Tablet: 2 cards per row */
@media (max-width: 1024px) and (min-width: 601px) {
  .guru-carousel-track {
    gap: 1rem;
  }

  .guru-carousel-card {
    flex: 0 0 calc((100% - 1rem) / 2);
  }
}

/* Mobile: 1 card per row */
@media (max-width: 600px) {
  .guru-carousel-card {
    flex: 0 0 100%;
  }
}
</style>
