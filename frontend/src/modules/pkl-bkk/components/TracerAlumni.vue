<template>
  <section class="tracer-section">
    <div class="tracer-inner">
      <div class="tracer-copy">
        <h2 class="tracer-title">
          <span>{{ titleLine1 }}</span>
          <span>{{ titleLine2 }}</span>
        </h2>
        <p class="tracer-desc">{{ description }}</p>

        <div class="tracer-bars">
          <div v-for="item in metrics" :key="item.label" class="tracer-bar">
            <div class="tracer-bar-head">
              <span>{{ item.label }}</span>
              <strong :style="{ color: item.warnaTeks }">{{ item.value }}</strong>
            </div>
            <div class="tracer-bar-track">
              <div
                class="tracer-bar-fill"
                :class="[`tracer-bar-fill--${item.warnaBar}`]"
                :style="{ width: item.value }"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <div class="tracer-card">
        <div class="tracer-card-header">
          <h3 class="tracer-card-title">Sebaran Wilayah Penempatan</h3>
          <p class="tracer-card-subtitle">Data penyerapan alumni tahun 2023-2024</p>
        </div>

        <div class="dashboard-window">
          <div class="browser-chrome">
            <span class="browser-title">Career &amp; PKL Center - SMK Nurul Jadid</span>
            <div class="browser-tabs">
              <span>Dashboard</span>
              <span>Student Opportunities</span>
              <span>Industry Partners</span>
              <span class="tab-active">Analytics</span>
              <span>Settings</span>
            </div>
          </div>

          <div class="dashboard-content">
            <div class="map-panel">
              <svg class="indonesia-map" viewBox="0 0 700 420" aria-hidden="true">
                <defs>
                  <linearGradient id="seaGlow" x1="0" y1="0" x2="1" y2="1">
                    <stop offset="0%" stop-color="#edf6ff" />
                    <stop offset="100%" stop-color="#dfeeff" />
                  </linearGradient>
                </defs>

                <rect x="0" y="0" width="700" height="420" fill="url(#seaGlow)" rx="22" />
                <path
                  d="M174 82 L214 60 L277 72 L326 90 L384 112 L436 150 L477 171 L503 214 L492 252 L473 282 L435 308 L397 334 L350 352 L309 335 L287 286 L251 266 L226 234 L199 216 L180 170 L156 138 Z"
                  fill="#dfe7f2"
                  stroke="#c9d5e6"
                  stroke-width="2"
                />
                <path
                  d="M130 156 L170 142 L198 144 L210 162 L186 182 L148 176 Z"
                  fill="#dfe7f2"
                  stroke="#c9d5e6"
                  stroke-width="2"
                />
                <path
                  d="M235 242 L254 226 L287 236 L294 252 L270 268 L245 260 Z"
                  fill="#dfe7f2"
                  stroke="#c9d5e6"
                  stroke-width="2"
                />
                <path
                  d="M360 310 L384 290 L420 298 L432 320 L398 338 L365 325 Z"
                  fill="#dfe7f2"
                  stroke="#c9d5e6"
                  stroke-width="2"
                />
              </svg>

              <svg class="connection-lines" viewBox="0 0 700 420" aria-hidden="true">
                <path d="M205 156 C 245 130, 320 120, 390 150 S 520 190, 575 183" fill="none" stroke="#bfdaf8" stroke-width="2.5" stroke-linecap="round" />
                <path d="M216 222 C 300 210, 350 220, 430 240 S 530 280, 585 275" fill="none" stroke="#bfdaf8" stroke-width="2.5" stroke-linecap="round" />
                <path d="M283 298 C 340 330, 395 330, 465 308" fill="none" stroke="#bfdaf8" stroke-width="2.5" stroke-linecap="round" />
              </svg>

              <div
                v-for="location in locations"
                :key="location.name"
                class="location-marker"
                :style="{ top: location.top, left: location.left }"
              >
                <span v-if="location.hasLabel" class="location-badge">{{ location.name }}</span>
                <span class="location-dot" :class="{ 'location-dot--small': !location.hasLabel }"></span>
              </div>

              <div class="map-scale">500 km</div>

              <div class="legend-panel">
                <span class="legend-title">Legend</span>
                <div class="legend-row">
                  <span class="legend-pin"></span>
                  <span>Aktif</span>
                </div>
                <div class="legend-row">
                  <span class="legend-dot-small"></span>
                  <span>Partner</span>
                </div>
              </div>
            </div>

            <aside class="side-panel">
              <span class="side-panel-label">HUB OVER...</span>
              <div class="stat-row"><span>Total Activ...</span><strong>1,236</strong></div>
              <div class="stat-row"><span>Opportuniti...</span><strong>842</strong></div>
              <div class="stat-row"><span>Students Pl...</span><strong>627</strong></div>
              <div class="stat-row"><span>Industry En...</span><strong>94%</strong></div>
            </aside>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
const props = defineProps({
  titleLine1: {
    type: String,
    default: 'Tracer Alumni &'
  },
  titleLine2: {
    type: String,
    default: 'Penyerapan Lulusan'
  },
  description: {
    type: String,
    default: 'Lulusan SMK Nurul Jadid tersebar di berbagai sektor industri, melanjutkan pendidikan tinggi, hingga membangun bisnis sendiri.'
  },
  metrics: {
    type: Array,
    default: () => [
      { label: 'Bekerja di Industri (Nasional/Inter)', value: '65%', warnaBar: 'navy', warnaTeks: '#0f2c7c' },
      { label: 'Melanjutkan ke Perguruan Tinggi', value: '25%', warnaBar: 'teal', warnaTeks: '#2f6d6a' },
      { label: 'Wirausaha / Entrepreneur', value: '10%', warnaBar: 'amber', warnaTeks: '#8b5e34' }
    ]
  },
  locations: {
    type: Array,
    default: () => [
      { name: 'Batam', top: '24%', left: '21%', hasLabel: true },
      { name: 'Kalimantan', top: '38%', left: '45%', hasLabel: true },
      { name: 'Jakarta', top: '34%', left: '62%', hasLabel: true },
      { name: 'Surabaya', top: '58%', left: '72%', hasLabel: true },
      { name: '', top: '55%', left: '58%', hasLabel: false },
      { name: '', top: '48%', left: '28%', hasLabel: false },
      { name: '', top: '68%', left: '52%', hasLabel: false }
    ]
  }
});
</script>

<style lang="scss" scoped>
.tracer-section {
  background: #ffffff;
  padding: 5rem 0;
}

.tracer-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
  align-items: stretch;
}

@media (min-width: 768px) {
  .tracer-inner {
    grid-template-columns: 1fr 1.1fr;
    gap: 4rem;
  }
}

.tracer-copy {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.tracer-title {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(2.6rem, 4vw, 4rem);
  line-height: 1.02;
  letter-spacing: -0.06em;
  color: #0f172a;
  margin: 0;
}

.tracer-desc {
  color: #334155;
  font-size: 1rem;
  line-height: 1.7;
  margin: 0;
}

.tracer-bars {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-top: 1rem;
}

.tracer-bar {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.tracer-bar-head {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  align-items: center;
}

.tracer-bar-head span {
  font-size: 0.95rem;
  color: #334155;
  font-weight: 600;
}

.tracer-bar-head strong {
  font-size: 1rem;
  font-weight: 700;
}

.tracer-bar-track {
  width: 100%;
  height: 0.375rem;
  background: #eef2ff;
  border-radius: 9999px;
  overflow: hidden;
}

.tracer-bar-fill {
  height: 100%;
  border-radius: 9999px;
  transition: width 0.6s ease;
}

.tracer-bar-fill--navy {
  background: #0f2c7c;
}

.tracer-bar-fill--teal {
  background: #2f6d6a;
}

.tracer-bar-fill--amber {
  background: #8b5e34;
}

.tracer-card {
  background: linear-gradient(135deg, #ffffff 0%, #f2f7ff 100%);
  border-radius: 2rem;
  padding: 2rem;
  box-shadow: 0 30px 50px rgba(15, 23, 42, 0.1);
  border: 1px solid rgba(148, 163, 184, 0.2);
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  transform: rotate(0.8deg);
}

.tracer-card-header {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.tracer-card-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.65rem;
  line-height: 1.2;
  color: #0f172a;
  margin: 0;
}

.tracer-card-subtitle {
  color: #475569;
  font-size: 0.9rem;
  margin: 0;
}

.dashboard-window {
  position: relative;
  background: rgba(255, 255, 255, 0.72);
  border: 1px solid rgba(148, 163, 184, 0.22);
  border-radius: 1.5rem;
  overflow: hidden;
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.7);
}

.browser-chrome {
  background: rgba(248, 250, 252, 0.9);
  border-bottom: 1px solid rgba(148, 163, 184, 0.2);
  padding: 0.85rem 1rem 0;
}

.browser-title {
  display: block;
  color: #0f172a;
  font-size: 0.72rem;
  font-weight: 700;
  margin-bottom: 0.8rem;
}

.browser-tabs {
  display: flex;
  gap: 0.8rem;
  flex-wrap: wrap;
  padding-bottom: 0.7rem;
  color: #64748b;
  font-size: 0.72rem;
}

.browser-tabs span {
  position: relative;
  padding: 0.5rem 0.35rem;
}

.tab-active {
  color: #0f2c7c;
  font-weight: 700;
}

.tab-active::after {
  content: '';
  position: absolute;
  left: 0.35rem;
  right: 0.35rem;
  bottom: 0;
  height: 2px;
  border-radius: 9999px;
  background: #0f2c7c;
}

.dashboard-content {
  position: relative;
  background: rgba(248, 250, 252, 0.78);
  min-height: 420px;
  padding: 0.75rem;
}

.map-panel {
  position: relative;
  height: 430px;
  background: #f8fbff;
  border-radius: 1.2rem;
  overflow: hidden;
  border: 1px solid rgba(148, 163, 184, 0.2);
}

.indonesia-map,
.connection-lines {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

.connection-lines {
  z-index: 2;
  pointer-events: none;
}

.location-marker {
  position: absolute;
  z-index: 3;
  display: flex;
  flex-direction: column;
  align-items: center;
  transform: translate(-50%, -50%);
}

.location-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 1.7rem;
  padding: 0.3rem 0.55rem;
  border-radius: 0.5rem;
  background: rgba(15, 44, 124, 1);
  color: #ffffff;
  font-size: 0.62rem;
  font-weight: 700;
  box-shadow: 0 8px 16px rgba(15, 44, 124, 0.18);
}

.location-dot {
  width: 0.7rem;
  height: 0.7rem;
  margin-top: 0.2rem;
  border-radius: 50%;
  background: #0f2c7c;
  position: relative;
  box-shadow: 0 0 0 4px rgba(15, 44, 124, 0.12);
}

.location-dot::after {
  content: '';
  position: absolute;
  left: 50%;
  top: 100%;
  width: 2px;
  height: 0.7rem;
  transform: translateX(-50%);
  background: rgba(15, 44, 124, 0.3);
}

.location-dot--small {
  width: 0.5rem;
  height: 0.5rem;
  box-shadow: 0 0 0 3px rgba(15, 44, 124, 0.1);
}

.location-dot--small::after {
  display: none;
}

.map-scale {
  position: absolute;
  left: 1rem;
  bottom: 1rem;
  z-index: 3;
  color: #475569;
  font-size: 0.62rem;
  font-weight: 700;
  letter-spacing: 0.04em;
}

.map-scale::before {
  content: '';
  display: block;
  width: 2.5rem;
  height: 2px;
  background: rgba(71, 85, 105, 0.9);
  margin-bottom: 0.3rem;
}

.legend-panel {
  position: absolute;
  right: 0.75rem;
  bottom: 0.75rem;
  z-index: 3;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(148, 163, 184, 0.25);
  border-radius: 0.75rem;
  padding: 0.5rem 0.6rem;
  box-shadow: 0 8px 18px rgba(15, 23, 42, 0.05);
}

.legend-title {
  font-size: 0.62rem;
  font-weight: 700;
  color: #0f172a;
}

.legend-row {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  color: #475569;
  font-size: 0.56rem;
}

.legend-pin,
.legend-dot-small {
  display: inline-block;
  width: 0.55rem;
  height: 0.55rem;
  border-radius: 50%;
  background: #0f2c7c;
  position: relative;
}

.legend-pin::after {
  content: '';
  position: absolute;
  left: 50%;
  top: 100%;
  width: 1px;
  height: 0.4rem;
  transform: translateX(-50%);
  background: rgba(15, 44, 124, 0.4);
}

.legend-dot-small {
  background: #3182ce;
}

.side-panel {
  position: absolute;
  right: -1.25rem;
  top: 3.25rem;
  z-index: 4;
  width: 11.5rem;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: 1rem;
  padding: 0.85rem 0.8rem;
  box-shadow: 0 18px 28px rgba(15, 23, 42, 0.08);
}

.side-panel-label {
  display: block;
  margin-bottom: 0.7rem;
  color: #475569;
  font-size: 0.58rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.stat-row {
  display: flex;
  justify-content: space-between;
  gap: 0.5rem;
  font-size: 0.58rem;
  color: #334155;
  padding: 0.25rem 0;
}

.stat-row strong {
  color: #0f172a;
  font-weight: 700;
}

@media (max-width: 767px) {
  .tracer-section {
    padding: 4rem 0;
  }

  .tracer-inner {
    width: min(100% - 24px, 100%);
    gap: 2rem;
  }

  .tracer-title {
    font-size: clamp(2.1rem, 9vw, 3rem);
  }

  .tracer-bar-head {
    align-items: flex-start;
    flex-direction: column;
    gap: 0.2rem;
  }

  .tracer-card {
    border-radius: 1.5rem;
    padding: 1.3rem;
    transform: none;
  }

  .dashboard-content {
    min-height: 360px;
  }

  .map-panel {
    height: 350px;
  }

  .browser-tabs {
    gap: 0.35rem;
    font-size: 0.62rem;
  }

  .location-badge {
    font-size: 0.52rem;
    padding: 0.22rem 0.4rem;
  }

  .side-panel {
    display: none;
  }

  .legend-panel {
    right: 0.5rem;
    bottom: 0.5rem;
  }
}
</style>
