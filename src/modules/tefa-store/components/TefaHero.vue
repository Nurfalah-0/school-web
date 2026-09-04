<template>
  <section class="tefa-hero">
    <div class="tefa-hero-inner">
      <div class="tefa-hero-bg">
        <img
          src="https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=1600&q=80"
          alt="Workshop Teaching Factory"
          loading="eager"
        />
        <div class="tefa-hero-overlay"></div>
      </div>

      <div class="tefa-hero-content">
        <div class="tefa-hero-copy">
          <span class="tefa-hero-badge">INOVASI SISWA</span>
          <h1 class="tefa-hero-title">
            Teaching Factory:<br />
            <span class="tefa-hero-accent">Karya Nyata</span> Dari Ruang Kelas.
          </h1>
          <p class="tefa-hero-desc">
            Mendukung kreativitas siswa melalui produk dan jasa profesional berkualitas tinggi.
            Hasil karya kurikulum berbasis industri.
          </p>
          <div class="tefa-hero-actions">
            <button type="button" class="tefa-btn-primary" @click="scrollTo('#produk')">
              Jelajahi Produk
              <ArrowRight :size="18" />
            </button>
            <button type="button" class="tefa-btn-secondary" @click="scrollTo('#portofolio')">Portofolio Jasa</button>
          </div>
        </div>

        <div class="tefa-hero-visual">
          <div class="tefa-hero-monitor">
            <div class="tefa-monitor-frame">
              <div class="tefa-monitor-screen">
                <div class="tefa-monitor-header">
                  <span class="tefa-monitor-dot"></span>
                  <span class="tefa-monitor-dot"></span>
                  <span class="tefa-monitor-dot"></span>
                </div>
                <div class="tefa-monitor-body">
                  <div class="tefa-chart-bar" style="height: 60%"></div>
                  <div class="tefa-chart-bar" style="height: 80%"></div>
                  <div class="tefa-chart-bar" style="height: 45%"></div>
                  <div class="tefa-chart-bar" style="height: 90%"></div>
                  <div class="tefa-chart-bar" style="height: 70%"></div>
                </div>
                <div class="tefa-monitor-footer">
                  <div class="tefa-line"></div>
                  <div class="tefa-line"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="tefa-hero-indicators">
        <button
          v-for="(_, idx) in 4"
          :key="idx"
          :class="['tefa-indicator', { active: currentSlide === idx }]"
          :aria-label="`Slide ${idx + 1}`"
          @click="currentSlide = idx"
        ></button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { ArrowRight } from 'lucide-vue-next'

const currentSlide = ref(0)
const totalSlides = 4
let timer = null

const nextSlide = () => {
  currentSlide.value = (currentSlide.value + 1) % totalSlides
}

function scrollTo(hash) {
  const el = document.querySelector(hash)
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}

onMounted(() => {
  timer = setInterval(nextSlide, 5000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.tefa-hero {
  position: relative;
  width: 100%;
  border-radius: 48px;
  overflow: hidden;
  min-height: 500px;
  background: #0f172a;
}

.tefa-hero-inner {
  position: relative;
  width: 100%;
  min-height: 500px;
}

.tefa-hero-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
}

.tefa-hero-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.tefa-hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    90deg,
    rgba(15, 23, 42, 0.88) 0%,
    rgba(15, 23, 42, 0.65) 50%,
    rgba(15, 23, 42, 0.15) 100%
  );
}

.tefa-hero-content {
  position: relative;
  z-index: 1;
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
  align-items: center;
  min-height: 500px;
  padding: 3rem 0;
}

@media (min-width: 1024px) {
  .tefa-hero-content {
    grid-template-columns: 1.1fr 0.9fr;
    gap: 4rem;
    padding: 4rem 0;
  }
}

.tefa-hero-copy {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.tefa-hero-badge {
  display: inline-flex;
  align-items: center;
  width: fit-content;
  padding: 0.5rem 1.1rem;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.25);
  color: #ffedd5;
  font-size: 0.75rem;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  backdrop-filter: blur(8px);
}

.tefa-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(1.5rem, 3vw, 2.8rem);
  line-height: 1.05;
  letter-spacing: -0.04em;
  color: #ffffff;
  margin: 0;
}

.tefa-hero-accent {
  font-style: italic;
  color: $accent;
}

.tefa-hero-desc {
  color: rgba(255, 255, 255, 0.85);
  font-size: 1rem;
  line-height: 1.7;
  margin: 0;
  max-width: 520px;
}

.tefa-hero-actions {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  margin-top: 0.5rem;
}

.tefa-btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.9rem 1.6rem;
  border-radius: 9999px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #1a1a2e;
  font-weight: 800;
  font-size: 0.95rem;
  text-decoration: none;
  box-shadow: 0 10px 24px rgba(245, 158, 11, 0.35);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.tefa-btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 14px 30px rgba(245, 158, 11, 0.45);
}

.tefa-btn-secondary {
  display: inline-flex;
  align-items: center;
  padding: 0.9rem 1.6rem;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.35);
  color: #ffffff;
  font-weight: 800;
  font-size: 0.95rem;
  text-decoration: none;
  backdrop-filter: blur(6px);
  transition: background 0.2s ease;
}

.tefa-btn-secondary:hover {
  background: rgba(255, 255, 255, 0.16);
}

.tefa-hero-visual {
  display: none;
}

@media (min-width: 1024px) {
  .tefa-hero-visual {
    display: flex;
    justify-content: center;
    align-items: center;
  }
}

.tefa-hero-monitor {
  position: relative;
  width: 100%;
  max-width: 420px;
}

.tefa-monitor-frame {
  background: #0f172a;
  border-radius: 24px;
  padding: 12px;
  box-shadow: 0 30px 60px rgba(0, 0, 0, 0.45);
  border: 2px solid rgba(255, 255, 255, 0.1);
}

.tefa-monitor-screen {
  background: #1e293b;
  border-radius: 16px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.tefa-monitor-header {
  display: flex;
  gap: 6px;
  padding: 10px 12px;
  background: rgba(255, 255, 255, 0.04);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

.tefa-monitor-dot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.25);
}

.tefa-monitor-body {
  display: flex;
  align-items: flex-end;
  gap: 10px;
  padding: 20px 16px;
  height: 180px;
}

.tefa-chart-bar {
  flex: 1;
  background: linear-gradient(180deg, #3b82f6, #1d4ed8);
  border-radius: 6px 6px 0 0;
  opacity: 0.9;
}

.tefa-monitor-footer {
  display: flex;
  gap: 8px;
  padding: 12px;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
}

.tefa-line {
  flex: 1;
  height: 8px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
}

.tefa-hero-indicators {
  position: absolute;
  bottom: 1.5rem;
  right: 1.5rem;
  display: flex;
  gap: 0.5rem;
  z-index: 2;
}

.tefa-indicator {
  width: 24px;
  height: 4px;
  border-radius: 999px;
  border: none;
  background: rgba(255, 255, 255, 0.35);
  cursor: pointer;
  transition: background 0.2s ease, width 0.2s ease;
}

.tefa-indicator.active {
  background: #ffffff;
  width: 32px;
}
</style>
