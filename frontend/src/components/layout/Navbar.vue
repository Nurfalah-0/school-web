<template>
  <nav class="navbar">
    <div class="container nav-inner">
      <router-link to="/" class="brand" @click="closeMenu">
        <img :src="logoSrc" alt="Logo SMK" class="brand-logo" />
        <span class="brand-text">{{ schoolName }}</span>
      </router-link>

      <button
        type="button"
        class="nav-toggle"
        @click="toggleMenu"
        :aria-expanded="isMenuOpen.toString()"
        aria-label="Toggle navigasi"
      >
        <span></span>
        <span></span>
        <span></span>
      </button>

      <div :class="['navbar-menu', { open: isMenuOpen }]" id="navbar-menu">
        <router-link
          v-for="item in menuItems"
          :key="item.label"
          :to="item.to"
          class="nav-link"
          :class="{ active: isActive(item) }"
          @click="closeMenu"
        >
          {{ item.label }}
        </router-link>

        <router-link class="nav-cta nav-cta-mobile" :to="ctaLink" @click="closeMenu">
          {{ ctaLabel }}
        </router-link>
      </div>

      <router-link class="nav-cta nav-cta-desktop" :to="ctaLink">
        {{ ctaLabel }}
      </router-link>
    </div>
  </nav>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useRoute } from 'vue-router';
import defaultLogo from '../../assets/logo.webp';

const props = defineProps({
  logoSrc: {
    type: String,
    default: defaultLogo,
  },
  schoolName: {
    type: String,
    default: 'SMK Nurul Jadid',
  },
  menuItems: {
    type: Array,
    default: () => [
      { label: 'Dashboard', to: '/' },
      { label: 'Jurusan', to: '/jurusan' },
      { label: 'Prestasi', to: '/prestasi' },
      { label: 'TEFA', to: '/tefa-store' },
      { label: 'PPDB', to: '/ppdb' },
      { label: 'PKL & BKK', to: '/pkl-bkk' },
      { label: 'News', to: '/berita' },
    ],
  },
  ctaLink: {
    type: [String, Object],
    default: '/ppdb',
  },
  ctaLabel: {
    type: String,
    default: 'Daftar PPDB',
  },
});

const route = useRoute();
const isMenuOpen = ref(false);

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value;
};

const closeMenu = () => {
  isMenuOpen.value = false;
};

const isActive = (item) => {
  const target = item.to;
  if (typeof target === 'string') {
    if (target === '/jurusan') {
      return route.path === '/jurusan' || route.path.startsWith('/jurusan/')
    }
    if (target === '/berita') {
      return route.path === '/berita' || route.path.startsWith('/berita/')
    }
    if (target === '/prestasi') {
      return route.path === '/prestasi' || route.path.startsWith('/prestasi/')
    }
    if (target === '/pkl-bkk') {
      return route.path === '/pkl-bkk' || route.path.startsWith('/pkl-bkk/') || route.path.startsWith('/lowongan')
    }
    return route.path === target;
  }
  if (target.hash) {
    return route.path === target.path && route.hash === target.hash;
  }
  return route.path === target.path;
};
</script>

<style lang="scss" scoped>
@use '../../assets/styles/variables' as *;

.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  width: 100%;
  height: var(--nav-height, 64px);
  background: #f8fafc;
  border-bottom: 1px solid rgba(148, 163, 184, 0.16);
  backdrop-filter: blur(18px);
}

.nav-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  width: min(1200px, calc(100% - 2rem));
  margin: 0 auto;
  height: 100%;
  padding: 0;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  text-decoration: none;
}

.brand-logo {
  width: 3rem;
  height: 3rem;
  object-fit: contain;
  border-radius: 9999px;
}

.brand-text {
  font-family: $font-display;
  font-size: 1.25rem;
  font-weight: 800;
  color: #0f172a;
  white-space: nowrap;
}

.navbar-menu {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2rem;
}

.nav-link {
  color: #334155;
  font-weight: 600;
  text-decoration: none;
  position: relative;
  transition: color 0.2s ease;
}

.nav-link:hover,
.nav-link:focus {
  color: #0f172a;
}

.nav-link.active {
  color: #0f172a;
  font-weight: 700;
}

.nav-link.active::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: -0.35rem;
  height: 2px;
  background: #1e40af;
}

.nav-actions {
  display: flex;
  align-items: center;
}

.nav-cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  border-radius: 9999px;
  background: #1e40af;
  color: #ffffff;
  font-weight: 700;
  text-decoration: none;
  transition: background-color 0.2s ease;
}

.nav-cta:hover {
  background: #1e3a8a;
}

.nav-cta-mobile {
  display: none;
}

.nav-toggle {
  display: none;
  border: none;
  background: transparent;
  cursor: pointer;
  padding: 0.5rem;
  gap: 0.35rem;
  flex-direction: column;
  justify-content: center;
}

.nav-toggle span {
  display: block;
  width: 1.75rem;
  height: 2px;
  background: #1e293b;
  border-radius: 9999px;
}

@media (max-width: 1200px) {
  .navbar-menu {
    gap: 1.25rem;
  }
}

@media (max-width: 1024px) {
  .nav-link {
    font-size: 0.95rem;
  }
}

@media (max-width: 900px) {
  .navbar-menu,
  .nav-cta-desktop {
    display: none;
  }

  .nav-toggle {
    display: inline-flex;
  }
}

@media (max-width: 760px) {
  .nav-inner {
    width: min(100%, calc(100% - 1.5rem));
    padding: 0.75rem 0;
  }

  .brand-text {
    display: none;
  }

  .navbar-menu.open {
    display: flex;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    flex-direction: column;
    align-items: stretch;
    gap: 1rem;
    margin: 0.75rem auto;
    padding: 1rem;
    background: #ffffff;
    border: 1px solid rgba(148, 163, 184, 0.16);
    border-radius: 1rem;
    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
    z-index: 49;
  }

  .nav-link {
    padding: 0.8rem 1rem;
    border-radius: 0.85rem;
    background: #f8fafc;
  }

  .nav-cta-mobile {
    display: inline-flex;
    width: 100%;
    justify-content: center;
  }
}
</style>
