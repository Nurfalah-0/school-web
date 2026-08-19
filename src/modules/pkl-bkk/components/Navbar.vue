<template>
  <nav class="pkl-nav">
    <div class="pkl-nav-inner">
      <a class="pkl-brand" href="#">
        <img :src="logo" alt="Logo SMK" class="pkl-brand-logo" />
        <span>SMK Nurul Jadid</span>
      </a>

      <div class="pkl-nav-menu">
        <a
          v-for="item in menuItems"
          :key="item.label"
          :href="item.link"
          :class="['pkl-nav-link', { active: item.active }]"
        >
          {{ item.label }}
        </a>
      </div>

      <div class="pkl-nav-actions">
        <a class="pkl-nav-outline" href="#contact">Contact</a>
        <a class="pkl-nav-solid" href="#pendaftaran">Daftar PPDB</a>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import logo from '../../../assets/logo.webp';

const route = useRoute();

const menuItems = computed(() => {
  const baseItems = [
    { label: 'Profile', link: '/', active: route.path === '/' },
    { label: 'Jurusan', link: '/#jurusan', active: false },
    { label: 'Prestasi', link: '/#prestasi', active: false },
    { label: 'TEFA', link: '/#tefa', active: false },
    { label: 'PPDB', link: '/ppdb', active: route.path === '/ppdb' },
    { label: 'PKL & BKK', link: '/pkl-bkk', active: route.path === '/pkl-bkk' },
    { label: 'News', link: '/#news', active: false }
  ];

  if (route.path === '/pkl-bkk') {
    baseItems.find(item => item.label === 'PKL & BKK').active = true;
  } else if (route.path === '/ppdb') {
    baseItems.find(item => item.label === 'PPDB').active = true;
  } else if (route.path === '/') {
    baseItems.find(item => item.label === 'Profile').active = true;
  }

  return baseItems;
});
</script>

<style lang="scss" scoped>
.pkl-nav {
  position: sticky;
  top: 0;
  z-index: 50;
  background: #ffffff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  padding: 1rem 0;
}

.pkl-nav-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1.5rem;
}

.pkl-brand {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  font-weight: 800;
  font-size: 1.1rem;
  color: #0f172a;
  text-decoration: none;
  flex-shrink: 0;
}

.pkl-brand-logo {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.75rem;
  object-fit: cover;
}

.pkl-nav-menu {
  display: none;
  gap: 1.75rem;
  align-items: center;
}

@media (min-width: 768px) {
  .pkl-nav-menu {
    display: flex;
  }
}

.pkl-nav-link {
  font-size: 0.95rem;
  font-weight: 600;
  color: #334155;
  text-decoration: none;
  padding: 0.4rem 0;
  border-bottom: 2px solid transparent;
  transition: color 0.2s, border-color 0.2s;
}

.pkl-nav-link:hover {
  color: #0f172a;
}

.pkl-nav-link.active {
  color: #042d86;
  border-bottom-color: #042d86;
}

.pkl-nav-actions {
  display: flex;
  gap: 0.75rem;
  align-items: center;
  flex-shrink: 0;
}

.pkl-nav-outline {
  padding: 0.55rem 1.25rem;
  border: 1px solid #042d86;
  color: #042d86;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.9rem;
  text-decoration: none;
  transition: background-color 0.2s, color 0.2s;
}

.pkl-nav-outline:hover {
  background: #042d86;
  color: #ffffff;
}

.pkl-nav-solid {
  padding: 0.55rem 1.25rem;
  background: #042d86;
  color: #ffffff;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.9rem;
  text-decoration: none;
  transition: background-color 0.2s;
}

.pkl-nav-solid:hover {
  background: #032263;
}

@media (max-width: 767px) {
  .pkl-nav-actions {
    display: none;
  }
}
</style>
