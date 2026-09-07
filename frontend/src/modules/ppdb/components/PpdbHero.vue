<template>
  <section class="ppdb-hero">
    <div class="ppdb-hero-inner">
      <div class="ppdb-hero-copy">
        <span class="ppdb-hero-badge">
          <span class="ppdb-hero-dot"></span>
          PPDB Tahun Ajaran 2024/2025 Telah Dibuka
        </span>
        <h1 class="ppdb-hero-title">
          <span class="ppdb-hero-main-text">Wujudkan Masa</span>
          <span class="ppdb-hero-main-text ppdb-hero-main-line">
            <span class="ppdb-hero-prelude">Depan</span>
            <em class="ppdb-hero-accent">Vokasi</em>
            <span class="ppdb-hero-tail">Anda.</span>
          </span>
        </h1>

        <p class="ppdb-hero-desc">
          Bergabunglah dengan komunitas pembelajar inovatif di SMK Nurul Jadid. Kurikulum berbasis industri dan fasilitas modern siap menempa skill profesionalmu.
        </p>

        <div class="ppdb-hero-chip-row">
          <span>150+ Mitra Industri</span>
          <span>Teknologi Modern</span>
          <span>Career Ready</span>
        </div>

        <div class="ppdb-hero-countdown">
          <div class="ppdb-hero-count-box">
            <strong>{{ countdown.days }}</strong>
            <span>HARI</span>
          </div>
          <div class="ppdb-hero-count-box">
            <strong>{{ countdown.hours }}</strong>
            <span>JAM</span>
          </div>
          <div class="ppdb-hero-count-box">
            <strong>{{ countdown.minutes }}</strong>
            <span>MENIT</span>
          </div>
        </div>

        <div class="ppdb-hero-actions">
          <a class="ppdb-btn-primary" href="#pendaftaran" @click.prevent="scrollToSection('#pendaftaran')">Daftar Sekarang</a>
          <a class="ppdb-btn-secondary" href="#status" @click.prevent="scrollToSection('#status')">Cek Status</a>
        </div>
      </div>

      <div class="ppdb-hero-visual">
        <div class="ppdb-hero-blob-wrap">
          <div class="ppdb-hero-blob-bg"></div>
          <div class="ppdb-hero-blob-shadow"></div>

          <div class="ppdb-hero-float-card ppdb-hero-float-card-top">
            <div class="ppdb-float-icon-wrap">
              <BookOpen class="ppdb-float-icon" />
            </div>
            <div class="ppdb-float-text">
              <span class="ppdb-float-label">Kurikulum</span>
              <strong>Industri 4.0</strong>
            </div>
          </div>

          <div class="ppdb-hero-float-card ppdb-hero-float-card-bottom">
            <div class="ppdb-float-icon-wrap ppdb-float-icon-wrap-alt">
              <Users class="ppdb-float-icon" />
            </div>
            <div class="ppdb-float-text">
              <span class="ppdb-float-label">Peluang Kerja</span>
              <strong>94% Terserap</strong>
            </div>
          </div>

          <div class="ppdb-hero-blob">
            <img :src="heroImg" alt="Siswa SMK Nurul Jadid" class="ppdb-hero-img" />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { BookOpen, Users } from 'lucide-vue-next';
import heroImg from '../../../assets/hero-lab.webp';

const props = defineProps({
  deadline: {
    type: String,
    default: '2025-03-01T00:00:00'
  }
});

const countdown = ref({ days: 0, hours: 0, minutes: 0 });
let timer = null;

const scrollToSection = (selector) => {
  const el = document.querySelector(selector);
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    const input = el.querySelector('input');
    if (input) {
      setTimeout(() => input.focus(), 600);
    }
  }
};

const updateCountdown = () => {
  const target = new Date(props.deadline).getTime();
  const now = Date.now();
  const diff = Math.max(0, target - now);

  const days = Math.floor(diff / (1000 * 60 * 60 * 24));
  const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));

  countdown.value = { days, hours, minutes };
};

onMounted(() => {
  updateCountdown();
  timer = setInterval(updateCountdown, 60000);
});

onUnmounted(() => {
  if (timer) clearInterval(timer);
});
</script>

<style lang="scss" scoped>
.ppdb-hero {
  background:
    radial-gradient(circle at top left, rgba(191, 219, 254, 0.8), transparent 28%),
    linear-gradient(135deg, #ffffff 0%, #eef4ff 45%, #dfeafc 100%);
  padding: 5rem 0;
  position: relative;
  overflow: hidden;
}

.ppdb-hero::before,
.ppdb-hero::after {
  content: '';
  position: absolute;
  border-radius: 50%;
  filter: blur(18px);
  opacity: 0.55;
  pointer-events: none;
}

.ppdb-hero::before {
  width: 22rem;
  height: 22rem;
  background: rgba(147, 197, 253, 0.22);
  top: -7rem;
  right: -4rem;
}

.ppdb-hero::after {
  width: 18rem;
  height: 18rem;
  background: rgba(191, 219, 254, 0.3);
  bottom: -4rem;
  left: -3rem;
}

.ppdb-hero-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
  align-items: center;
  position: relative;
  z-index: 1;
}

@media (min-width: 768px) {
  .ppdb-hero-inner {
    grid-template-columns: 1fr 1.1fr;
    gap: 4rem;
  }
}

.ppdb-hero-copy {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  position: relative;
  z-index: 2;
}

.ppdb-hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.55rem 1.25rem;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.72);
  border: 1px solid rgba(148, 163, 184, 0.2);
  box-shadow: 0 10px 24px rgba(59, 130, 246, 0.1);
  font-size: 0.82rem;
  font-weight: 700;
  color: #1e3a8a;
  width: fit-content;
  backdrop-filter: blur(10px);
}

.ppdb-hero-dot {
  width: 0.55rem;
  height: 0.55rem;
  border-radius: 9999px;
  background: #1d4ed8;
  flex-shrink: 0;
}

.ppdb-hero-title {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(2.4rem, 3.7vw, 4.2rem);
  line-height: 0.96;
  letter-spacing: -0.06em;
  margin: 0;
  text-shadow: 0 18px 26px rgba(15, 23, 42, 0.08);
}

.ppdb-hero-main-text {
  color: #042D86;
}

.ppdb-hero-main-line {
  display: inline-flex;
  flex-wrap: nowrap;
  align-items: baseline;
  gap: 0.18em;
  white-space: nowrap;
}

.ppdb-hero-prelude {
  font-size: 0.9em;
  color: #042D86;
}

.ppdb-hero-accent {
  font-style: italic;
  color: #6B4400;
  font-size: 1.02em;
}

.ppdb-hero-tail {
  font-size: 1em;
  color: #042D86;
}

.ppdb-hero-desc {
  color: #334155;
  font-size: 1.05rem;
  line-height: 1.75;
  margin: 0;
  max-width: 540px;
}

.ppdb-hero-chip-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 0.15rem;
}

.ppdb-hero-chip-row span {
  display: inline-flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.65);
  border: 1px solid rgba(37, 99, 235, 0.14);
  color: #1d4ed8;
  font-size: 0.76rem;
  font-weight: 800;
  letter-spacing: 0.04em;
  padding: 0.52rem 0.8rem;
  border-radius: 999px;
  box-shadow: 0 8px 18px rgba(37, 99, 235, 0.08);
}

.ppdb-hero-countdown {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
  margin-top: 0.3rem;
}

.ppdb-hero-count-box {
  background: rgba(255, 255, 255, 0.72);
  border: 1px solid rgba(255, 255, 255, 0.45);
  backdrop-filter: blur(12px);
  border-radius: 1rem;
  padding: 1rem 1.15rem;
  box-shadow: 0 18px 34px rgba(37, 99, 235, 0.09), 0 5px 12px rgba(15, 23, 42, 0.04);
  text-align: center;
  min-width: 5.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.ppdb-hero-count-box strong {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: 1.8rem;
  color: #0f2c7c;
  line-height: 1;
}

.ppdb-hero-count-box span {
  font-size: 0.72rem;
  font-weight: 800;
  color: #475569;
  letter-spacing: 0.08em;
}

.ppdb-hero-actions {
  display: flex;
  gap: 1rem;
  margin-top: 0.4rem;
  flex-wrap: wrap;
  position: relative;
  z-index: 2;
}

.ppdb-btn-primary,
.ppdb-btn-secondary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 3.25rem;
  padding: 0.95rem 1.75rem;
  border-radius: 1rem;
  font-weight: 800;
  font-size: 1rem;
  text-decoration: none;
  transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
  box-shadow: 0 10px 22px rgba(15, 23, 42, 0.14);
}

.ppdb-btn-primary {
  background: linear-gradient(135deg, #1e40af 0%, #0b2d7a 100%);
  color: #ffffff;
  margin-right: 0.3rem;
  margin-bottom: 0.2rem;
}

.ppdb-btn-primary:hover,
.ppdb-btn-secondary:hover {
  transform: translateY(-2px);
}

.ppdb-btn-secondary {
  background: rgba(255, 255, 255, 0.68);
  color: #0f2c7c;
  border: 1px solid rgba(13, 44, 119, 0.18);
  backdrop-filter: blur(8px);
  margin-left: 0.3rem;
  margin-top: 0.1rem;
}

.ppdb-hero-visual {
  position: relative;
  display: flex;
  justify-content: center;
  z-index: 1;
}

.ppdb-hero-blob-wrap {
  position: relative;
  width: 100%;
  max-width: 540px;
  transform: translateX(1.5rem);
  padding: 1.2rem 0 0.8rem;
}

.ppdb-hero-blob-bg {
  position: absolute;
  inset: 8% 4% 6% 8%;
  background: linear-gradient(135deg, rgba(191, 219, 254, 0.9), rgba(147, 197, 253, 0.7));
  border-radius: 30% 70% 55% 45% / 40% 34% 66% 60%;
  filter: blur(35px);
  opacity: 0.9;
  z-index: 0;
}

.ppdb-hero-blob-shadow {
  position: absolute;
  inset: auto 1.5rem 0.4rem 1.5rem;
  height: 2.4rem;
  background: rgba(30, 64, 175, 0.12);
  filter: blur(18px);
  border-radius: 50%;
  z-index: 0;
}

.ppdb-hero-float-card {
  position: absolute;
  z-index: 2;
  display: flex;
  align-items: center;
  gap: 0.8rem;
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 0.8rem 1rem;
  box-shadow: 0 18px 30px rgba(15, 23, 42, 0.12);
  color: #0f172a;
}

.ppdb-hero-float-card-top {
  top: 1.2rem;
  left: 0.25rem;
}

.ppdb-hero-float-card-bottom {
  right: 0.25rem;
  bottom: 1rem;
}

.ppdb-float-icon-wrap {
  width: 2.5rem;
  height: 2.5rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.85rem;
  background: linear-gradient(135deg, #e0edff 0%, #cfe0ff 100%);
  color: #0f2c7c;
  flex-shrink: 0;
}

.ppdb-float-icon {
  width: 1.15rem;
  height: 1.15rem;
}

.ppdb-float-text {
  display: flex;
  flex-direction: column;
  gap: 0.1rem;
}

.ppdb-float-label {
  font-size: 0.68rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #475569;
  font-weight: 700;
}

.ppdb-hero-float-card strong {
  font-size: 1rem;
  font-weight: 800;
  color: #0f2c7c;
}

.ppdb-hero-blob {
  position: relative;
  z-index: 1;
  border-radius: 36% 64% 52% 48% / 41% 42% 58% 59%;
  overflow: hidden;
  border: 1px solid rgba(148, 163, 184, 0.18);
  box-shadow: 0 40px 80px rgba(30, 64, 175, 0.18);
  background: #eff6ff;
}

.ppdb-hero-img {
  width: 100%;
  height: 440px;
  object-fit: cover;
  display: block;
  transform: scale(1.02);
}

@media (max-width: 767px) {
  .ppdb-hero {
    padding-top: 4rem;
    padding-bottom: 4rem;
  }

  .ppdb-hero-inner {
    gap: 2.5rem;
  }

  .ppdb-hero-copy {
    text-align: center;
    align-items: center;
  }

  .ppdb-hero-badge {
    margin: 0 auto;
  }

  .ppdb-hero-desc {
    margin: 0 auto;
  }

  .ppdb-hero-chip-row,
  .ppdb-hero-countdown,
  .ppdb-hero-actions {
    justify-content: center;
  }

  .ppdb-hero-float-card {
    position: static;
    margin-bottom: 1rem;
    width: fit-content;
    margin-inline: auto;
  }

  .ppdb-hero-blob-wrap {
    max-width: 100%;
    transform: none;
    padding-top: 0;
  }

  .ppdb-hero-img {
    height: 320px;
  }
}
</style>
