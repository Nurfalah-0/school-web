<template>
  <nav class="top-nav">
    <div class="container nav-inner">
      <a class="brand" href="#hero">
        <img :src="logo" alt="Logo SMK" class="brand-logo" />
        <span>SMK Nurul Jadid</span>
      </a>

      <button
        type="button"
        class="nav-toggle"
        @click="isMenuOpen = !isMenuOpen"
        :aria-expanded="isMenuOpen.toString()"
        aria-label="Toggle navigasi"
      >
        <span></span>
        <span></span>
        <span></span>
      </button>

      <div :class="['nav-links', { open: isMenuOpen }]">
        <a href="#profil" @click="isMenuOpen = false">Profil</a>
        <a href="#lowongan" @click="isMenuOpen = false">Jurusan</a>
        <a href="#alumni" @click="isMenuOpen = false">Prestasi</a>
        <a href="#tracer" @click="isMenuOpen = false">TEFA</a>
        <a href="#pendaftaran" @click="isMenuOpen = false">PPDB</a>
        <a href="#kontak" @click="isMenuOpen = false">Kontak</a>
      </div>

      <div class="nav-actions">
        <a class="nav-cta" href="#pendaftaran">Daftar PPDB</a>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref } from 'vue';
import logo from '../../../assets/logo.webp';

const isMenuOpen = ref(false);
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  font-weight: 900;
}

.brand-logo {
  width: 3rem;
  height: 3rem;
  display: block;
  border-radius: 0.75rem;
}

.brand span {
  font-family: $font-display;
  font-size: 1.1rem;
  color: $brand;
}

.nav-toggle {
  display: none;
  border: none;
  background: transparent;
  padding: 0.5rem;
  gap: 0.35rem;
  flex-direction: column;
  justify-content: center;
  cursor: pointer;
}

.nav-toggle span {
  display: block;
  width: 1.6rem;
  height: 2px;
  background: $brand;
  border-radius: 1px;
}

.nav-links {
  display: flex;
  gap: 1.6rem;
  color: #334155;
  font-weight: 600;
  align-items: center;
}

.nav-links a {
  transition: color 0.2s ease;
}

.nav-links a:hover,
.nav-links a:focus {
  color: #0f172a;
}

.nav-cta {
  padding: 12px 22px;
  background: $brand;
  color: white;
  border-radius: 9999px;
  font-weight: 800;
}

.nav-actions {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

@media (max-width: 1100px) {
  .nav-links {
    display: none;
  }

  .nav-toggle {
    display: inline-flex;
  }
}

@media (max-width: 760px) {
  .nav-links.open {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    margin: 0.75rem auto;
    width: min(95%, 420px);
    flex-direction: column;
    gap: 0.9rem;
    padding: 1rem;
    background: rgba(255, 255, 255, 0.96);
    backdrop-filter: blur(16px);
    border-radius: 24px;
    border: 1px solid rgba(4, 45, 134, 0.12);
    transform: translateY(0);
    opacity: 1;
    pointer-events: auto;
  }

  .nav-actions {
    display: none;
  }
}

</style>
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

@media (max-width: 1100px) {
  .nav-links {
    display: none;
  }

  .nav-toggle {
    display: inline-flex;
  }
}

@media (max-width: 760px) {
  .nav-links.open {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    margin: 0.75rem auto;
    width: min(95%, 420px);
    flex-direction: column;
    gap: 0.9rem;
    padding: 1rem;
    background: rgba(255, 255, 255, 0.96);
    backdrop-filter: blur(16px);
    border-radius: 24px;
    border: 1px solid rgba(4, 45, 134, 0.12);
    transform: translateY(0);
    opacity: 1;
    pointer-events: auto;
  }

  .nav-actions {
    display: none;
  }
}
</style>
