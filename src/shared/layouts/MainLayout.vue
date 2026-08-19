<template>
  <div class="main-layout">
    <Navbar v-if="showNavbar" />
    <router-view v-slot="{ Component }">
      <transition name="page-fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import Navbar from '../../components/layout/Navbar.vue';

const route = useRoute();
const showNavbar = computed(() => route.meta.hideNavbar !== true);
</script>

<style scoped>
.main-layout {
  padding-top: var(--nav-height);
  min-height: calc(100vh - var(--nav-height));
  background: #f8f7fb;
}

.page-fade-enter-active,
.page-fade-leave-active {
  transition: opacity 0.2s ease;
}

.page-fade-enter-from,
.page-fade-leave-to {
  opacity: 0;
}
</style>
