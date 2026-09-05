<template>
  <nav class="top-nav">
    <div class="container nav-inner">
      <router-link to="/" class="brand" @click="isMenuOpen = false">
        <img :src="logo" alt="Logo SMK" class="brand-logo" />
        <span>SMK Nurul Jadid</span>
      </router-link>

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
        <router-link
          v-for="item in menuItems"
          :key="item.label"
          :to="item.to"
          class="nav-link"
          :class="{ active: isActive(item) }"
          @click="isMenuOpen = false"
        >
          {{ item.label }}
        </router-link>
      </div>

      <div class="nav-actions">
        <router-link class="nav-cta" :to="ctaLink" @click="isMenuOpen = false">
          {{ ctaLabel }}
        </router-link>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useRoute } from 'vue-router';
import logo from '../../assets/logo.webp';

const route = useRoute();
const isMenuOpen = ref(false);

const menuItems = computed(() => {
  if (route.path === '/pkl-bkk') {
    return [
      { label: 'Beranda', to: '/' },
      { label: 'Lowongan', to: { path: '/pkl-bkk', hash: '#lowongan' } },
      { label: 'Daftar', to: { path: '/pkl-bkk', hash: '#pendaftaran' } },
      { label: 'Timeline', to: { path: '/pkl-bkk', hash: '#timeline' } },
      { label: 'Tracer', to: { path: '/pkl-bkk', hash: '#tracer' } }
    ];
  }

  return [
    { label: 'Dashboard', to: '/' },
    { label: 'Jurusan', to: { path: '/', hash: '#lowongan' } },
    { label: 'Prestasi', to: { path: '/', hash: '#alumni' } },
    { label: 'TEFA', to: '/tefa-store' },
    { label: 'PPDB', to: '/ppdb' },
    { label: 'PKL & BKK', to: '/pkl-bkk' }
  ];
});

const ctaLink = computed(() => {
  if (route.path === '/pkl-bkk') {
    return { path: '/pkl-bkk', hash: '#pendaftaran' };
  }
  return '/ppdb';
});

const ctaLabel = computed(() => (route.path === '/pkl-bkk' ? 'Daftar PKL' : 'Daftar PPDB'));

const isActive = (item) => {
  if (typeof item.to === 'string') {
    return route.path === item.to;
  }
  const pathMatch = route.path === item.to.path;
  const hashMatch = (item.to.hash || '') === (route.hash || '');
  return pathMatch && hashMatch;
};
</script>

<style lang="scss" scoped>
@use '../../assets/styles/variables' as *;

.top-nav {
  position: sticky;
  top: 0;
  z-index: 999;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(16px);
  border-bottom: 1px solid rgba(15, 23, 42, 0.05);
}

.nav-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 0;
  gap: 1rem;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  font-weight: 900;
  text-decoration: none;
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
  align-items: center;
}

.nav-link {
  color: #334155;
  font-weight: 600;
  text-decoration: none;
  transition: color 0.2s ease;
}

.nav-link:hover,
.nav-link:focus,
.nav-link.active {
  color: #0f172a;
}

.nav-actions {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.nav-cta {
  padding: 12px 22px;
  background: $brand;
  color: white;
  border-radius: 9999px;
  font-weight: 800;
  text-decoration: none;
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
