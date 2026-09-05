<template>
  <section class="galeri-hero">
    <!-- Decorative blobs -->
    <div class="hero-blob hero-blob--1"></div>
    <div class="hero-blob hero-blob--2"></div>
    <div class="hero-blob hero-blob--3"></div>

    <!-- Floating photo frames -->
    <div class="hero-floating-frames" aria-hidden="true">
      <div class="frame frame--1">
        <div class="frame-inner">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect width="18" height="18" x="3" y="3" rx="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>
        </div>
      </div>
      <div class="frame frame--2">
        <div class="frame-inner">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3z"/><circle cx="12" cy="13" r="3"/></svg>
        </div>
      </div>
      <div class="frame frame--3">
        <div class="frame-inner">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        </div>
      </div>
    </div>

    <div class="galeri-hero-inner">
      <div class="hero-badge">
        <span class="badge-dot"></span>
        <span>Galeri Sekolah</span>
      </div>
      <h1 class="galeri-hero-title">
        Momen <span class="title-gradient">Berharga</span><br />di SMK Nurul Jadid
      </h1>
      <p class="galeri-hero-desc">
        Dokumentasi fasilitas, kegiatan, dan perjalanan inovasi siswa kami.<br class="hide-mobile"/>
        Setiap foto bercerita tentang semangat dan kreativitas yang tak tertandingi.
      </p>
      <div class="hero-stats">
        <div class="stat-item">
          <span class="stat-num">500+</span>
          <span class="stat-label">Foto Kegiatan</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-num">50+</span>
          <span class="stat-label">Album</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-num">10+</span>
          <span class="stat-label">Kategori</span>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
</script>

<style lang="scss" scoped>
.galeri-hero {
  position: relative;
  background: linear-gradient(135deg, #0f0c29 0%, #1a1a6e 40%, #24243e 100%);
  padding: 6rem 1.5rem 5rem;
  text-align: center;
  overflow: hidden;
}

/* Decorative blobs */
.hero-blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.35;
  pointer-events: none;
}

.hero-blob--1 {
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, #7c3aed, transparent);
  top: -150px;
  left: -100px;
  animation: blobFloat 8s ease-in-out infinite;
}

.hero-blob--2 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, #2563eb, transparent);
  bottom: -100px;
  right: -80px;
  animation: blobFloat 10s ease-in-out infinite reverse;
}

.hero-blob--3 {
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, #ec4899, transparent);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation: blobFloat 12s ease-in-out infinite 2s;
}

@keyframes blobFloat {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33% { transform: translate(20px, -20px) scale(1.05); }
  66% { transform: translate(-15px, 15px) scale(0.95); }
}

/* Floating frames decoration */
.hero-floating-frames {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.frame {
  position: absolute;
  border-radius: 16px;
  border: 2px solid rgba(255,255,255,0.12);
  background: rgba(255,255,255,0.05);
  backdrop-filter: blur(8px);
  animation: frameFloat linear infinite;
}

.frame-inner {
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255,255,255,0.5);
}

.frame--1 {
  width: 72px;
  height: 72px;
  top: 20%;
  left: 5%;
  padding: 20px;
  animation-duration: 6s;
}

.frame--2 {
  width: 60px;
  height: 60px;
  top: 15%;
  right: 8%;
  padding: 18px;
  animation-duration: 8s;
  animation-delay: -2s;
}

.frame--3 {
  width: 54px;
  height: 54px;
  bottom: 20%;
  right: 12%;
  padding: 16px;
  animation-duration: 7s;
  animation-delay: -4s;
}

@keyframes frameFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-14px); }
}

/* Content */
.galeri-hero-inner {
  position: relative;
  z-index: 2;
  max-width: 50rem;
  margin: 0 auto;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.4rem 1.1rem;
  border-radius: 9999px;
  background: rgba(255,255,255,0.1);
  border: 1px solid rgba(255,255,255,0.18);
  font-size: 0.8rem;
  font-weight: 600;
  color: rgba(255,255,255,0.8);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 1.5rem;
  backdrop-filter: blur(8px);
}

.badge-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #a78bfa;
  box-shadow: 0 0 8px #a78bfa;
  animation: pulseDot 2s ease-in-out infinite;
}

@keyframes pulseDot {
  0%, 100% { opacity: 1; box-shadow: 0 0 8px #a78bfa; }
  50% { opacity: 0.6; box-shadow: 0 0 16px #a78bfa; }
}

.galeri-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(2rem, 5vw, 3.5rem);
  color: #ffffff;
  margin: 0;
  letter-spacing: -0.025em;
  line-height: 1.2;
}

.title-gradient {
  background: linear-gradient(135deg, #a78bfa 0%, #60a5fa 50%, #f472b6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.galeri-hero-desc {
  margin-top: 1.25rem;
  font-size: 1.05rem;
  line-height: 1.75;
  color: rgba(255,255,255,0.65);
}

.hide-mobile {
  @media (max-width: 639px) { display: none; }
}

/* Stats */
.hero-stats {
  display: inline-flex;
  align-items: center;
  gap: 2rem;
  margin-top: 2.5rem;
  padding: 1rem 2.5rem;
  background: rgba(255,255,255,0.07);
  border: 1px solid rgba(255,255,255,0.12);
  border-radius: 1rem;
  backdrop-filter: blur(12px);
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.2rem;
}

.stat-num {
  font-size: 1.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, #a78bfa, #60a5fa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.stat-label {
  font-size: 0.75rem;
  color: rgba(255,255,255,0.55);
  font-weight: 500;
}

.stat-divider {
  width: 1px;
  height: 36px;
  background: rgba(255,255,255,0.15);
}

@media (max-width: 639px) {
  .galeri-hero {
    padding: 4.5rem 1rem 3.5rem;
  }

  .hero-stats {
    gap: 1.25rem;
    padding: 0.875rem 1.5rem;
  }

  .stat-num { font-size: 1.25rem; }
  .frame--1, .frame--3 { display: none; }
}
</style>
