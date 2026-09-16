<template>
  <nav ref="navbarElement" class="navbar">
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
        <div
          v-for="item in menuItems"
          :key="item.label"
          class="nav-item"
          :class="{ 'has-dropdown': !!item.children, 'active-group': isGroupActive(item), 'dropdown-open': openDropdown === item.label }"
        >
          <template v-if="item.children">
            <button
              class="nav-link nav-trigger"
              type="button"
              @pointerdown.prevent.stop="toggleDropdown(item.label, $event)"
              @keydown.enter.prevent.stop="toggleDropdown(item.label, $event)"
              @keydown.space.prevent.stop="toggleDropdown(item.label, $event)"
              @mouseenter="handleTriggerMouseEnter(item)"
              @mouseleave="handleTriggerMouseLeave(item)"
            >
              {{ item.label }}
              <span class="caret">▾</span>
            </button>

            <div
              :class="['dropdown-menu', { open: openDropdown === item.label } ]"
              @mouseenter="handleDropdownMouseEnter(item)"
              @mouseleave="handleDropdownMouseLeave(item)"
            >
              <router-link
                v-for="child in item.children"
                :key="child.label"
                :to="child.to"
                class="dropdown-link"
                :class="{ active: isActive(child) }"
                @click="closeMenu"
              >
                {{ child.label }}
              </router-link>
            </div>
          </template>

          <router-link
            v-else
            :to="item.to"
            class="nav-link"
            :class="{ active: isActive(item) }"
            @click="closeMenu"
          >
            {{ item.label }}
          </router-link>
        </div>

      </div>

      <router-link
        class="nav-contact button-secondary"
        to="/contact"
        @click="closeMenu"
      >
        Contact
      </router-link>
    </div>
  </nav>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref } from 'vue';
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
      {
        label: 'Profil',
        children: [
          { label: 'SMK Nurul Jadid', to: { path: '/profil', hash: '#profil-sekolah' } },
          { label: 'Visi & Misi Sekolah', to: { path: '/profil', hash: '#visi-misi' } },
          { label: 'Kepala Sekolah', to: { path: '/profil', hash: '#kepala-sekolah' } },
        ],
      },
      { label: 'Jurusan', to: '/jurusan' },
      { label: 'Prestasi', to: '/prestasi' },
      { label: 'TEFA', to: '/tefa-store' },
      { label: 'PPDB', to: '/ppdb' },
      { label: 'PKL & BKK', to: '/pkl-bkk' },
      { label: 'News', to: '/berita' },
    ],
  },
});

const route = useRoute();
const navbarElement = ref(null);
const isMenuOpen = ref(false);
const openDropdown = ref(null);
const dropdownCloseTimers = ref({});
const triggerHoverState = ref({});
const dropdownHoverState = ref({});

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value;
};

const handleOutsidePointerDown = (event) => {
  if (!isMenuOpen.value || window.innerWidth > 900) return;
  if (!navbarElement.value?.contains(event.target)) {
    closeMenu();
  }
};

const closeMenu = () => {
  isMenuOpen.value = false;
  openDropdown.value = null;
};

const clearDropdownTimer = (label) => {
  if (dropdownCloseTimers.value[label]) {
    clearTimeout(dropdownCloseTimers.value[label]);
    delete dropdownCloseTimers.value[label];
  }
};

const scheduleDropdownClose = (label) => {
  clearDropdownTimer(label);
  dropdownCloseTimers.value[label] = setTimeout(() => {
    const isTriggerHovered = !!triggerHoverState.value[label];
    const isDropdownHovered = !!dropdownHoverState.value[label];

    if (!isTriggerHovered && !isDropdownHovered && openDropdown.value === label) {
      openDropdown.value = null;
    }
  }, 180);
};

const handleDropdownMouseEnter = (item) => {
  dropdownHoverState.value[item.label] = true;
  clearDropdownTimer(item.label);
  openDropdown.value = item.label;
};

const handleDropdownMouseLeave = (item) => {
  dropdownHoverState.value[item.label] = false;
  scheduleDropdownClose(item.label);
};

const handleTriggerMouseEnter = (item) => {
  if (!item.children) return;
  triggerHoverState.value[item.label] = true;
  clearDropdownTimer(item.label);
  openDropdown.value = item.label;
};

const handleTriggerMouseLeave = (item) => {
  if (!item.children) return;
  triggerHoverState.value[item.label] = false;
  scheduleDropdownClose(item.label);
};

const toggleDropdown = (label, event) => {
  if (event) {
    event.preventDefault();
    event.stopPropagation();
  }

  openDropdown.value = openDropdown.value === label ? null : label;
};

const isGroupActive = (item) => {
  if (!item.children) return false;
  return item.children.some((child) => isActive(child));
};

const isActive = (item) => {
  const target = item.to;
  if (typeof target === 'string') {
    if (target === '/profil') {
      return route.path === '/profil'
    }
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

onMounted(() => {
  document.addEventListener('pointerdown', handleOutsidePointerDown);
});

onBeforeUnmount(() => {
  document.removeEventListener('pointerdown', handleOutsidePointerDown);
});
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
  position: relative;
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
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  gap: 2rem;
}

.nav-contact {
  position: relative;
  z-index: 1;
  padding: 0.55rem 1rem;
  font-size: 0.9rem;
  text-decoration: none;
  white-space: nowrap;
}

.nav-item {
  position: relative;
}

.nav-link,
.nav-trigger {
  color: #334155;
  text-decoration: none;
  position: relative;
  transition: color 0.2s ease;
  background: transparent;
  border: none;
  font: inherit;
  font-weight: 800;
  cursor: pointer;
  padding: 0;
}

.nav-trigger {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  touch-action: manipulation;
}

.nav-link:hover,
.nav-link:focus,
.nav-trigger:hover,
.nav-trigger:focus {
  color: #0f172a;
}

.nav-link.active,
.dropdown-link.active {
  color: #1e40af;
  font-weight: 700;
}

.nav-link.active::after,
.active-group > .nav-trigger::after,
.dropdown-open > .nav-trigger::after,
.dropdown-link.active::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: -0.35rem;
  height: 2px;
  background: #1e40af;
}

.caret {
  font-size: 0.8rem;
  color: inherit;
}

.dropdown-menu {
  position: absolute;
  top: calc(100% + 0.75rem);
  left: 0;
  min-width: 220px;
  padding: 0.7rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  background: rgba(255, 255, 255, 0.98);
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: 1rem;
  box-shadow: 0 24px 60px rgba(15, 23, 42, 0.08);
  z-index: 60;
  opacity: 0;
  visibility: hidden;
  pointer-events: none;
  transform: translateY(10px);
  transition: opacity 0.2s ease, transform 0.2s ease, visibility 0.2s ease;
  margin-top: 0.25rem;
}

.dropdown-menu.open {
  opacity: 1;
  visibility: visible;
  pointer-events: auto;
  transform: translateY(0);
}

.dropdown-link {
  position: relative;
  color: #334155;
  text-decoration: none;
  padding: 0.7rem 0.8rem;
  border-radius: 0.75rem;
  font-weight: 800;
}

.dropdown-link:hover,
.dropdown-link:focus {
  color: #0f172a;
  background: #f8fafc;
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
  font-weight: 800;
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
  .nav-contact {
    margin-left: auto;
    margin-right: 0.25rem;
    padding: 0.45rem 0.75rem;
    font-size: 0.8rem;
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
    top: calc(100% + 0.5rem);
    left: 0;
    right: 0;
    transform: none;
    flex-direction: column;
    align-items: stretch;
    gap: 0.7rem;
    margin: 0 auto;
    padding: 0.75rem;
    background: #edf2f7;
    border: 1px solid rgba(148, 163, 184, 0.18);
    border-radius: 1rem;
    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
    z-index: 49;
  }

  .nav-item {
    width: 100%;
  }

  .nav-link,
  .nav-trigger {
    display: flex;
    align-items: center;
    width: 100%;
    padding: 0.85rem 1rem;
    border-radius: 0.85rem;
    background: rgba(255, 255, 255, 0.88);
    border: 1px solid rgba(148, 163, 184, 0.14);
    justify-content: space-between;
  }

  .nav-trigger {
    transition: none;
    -webkit-tap-highlight-color: transparent;
  }

  .dropdown-menu {
    position: static;
    margin-top: 0.45rem;
    min-width: 0;
    width: 100%;
    background: rgba(255, 255, 255, 0.9);
    box-shadow: none;
    border: 1px solid rgba(148, 163, 184, 0.12);
    border-radius: 0.8rem;
    opacity: 1;
    visibility: visible;
    pointer-events: auto;
    transform: none;
    padding: 0.5rem;
  }

  .dropdown-menu:not(.open) {
    display: none;
  }

  .dropdown-menu,
  .dropdown-menu.open {
    transition: none;
  }

  .dropdown-link {
    padding: 0.7rem 0.8rem;
    border-radius: 0.7rem;
  }

  .nav-cta-mobile {
    display: inline-flex;
    width: 100%;
    justify-content: center;
  }
}
</style>
