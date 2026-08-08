<template>
  <div id="app">
    <transition name="page-fade" mode="out-in">
      <div v-if="isLoading" key="loading" class="page-loading" aria-live="polite">
        <div class="loading-ring">
          <div></div>
          <div></div>
          <div></div>
          <div></div>
        </div>
      </div>
    </transition>

    <MainLayout />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import MainLayout from './shared/layouts/MainLayout.vue';

const isLoading = ref(false);
let loadingTimer = null;
const router = useRouter();

const showLoading = () => {
  clearTimeout(loadingTimer);
  isLoading.value = true;
};

const hideLoading = () => {
  clearTimeout(loadingTimer);
  loadingTimer = setTimeout(() => {
    isLoading.value = false;
  }, 250);
};

router.beforeEach((to, from, next) => {
  showLoading();
  next();
});

router.afterEach(() => {
  hideLoading();
});

router.onError(() => {
  hideLoading();
});
</script>

<style scoped>
#app {
  min-height: 100vh;
  position: relative;
}

.page-loading {
  position: fixed;
  inset: 0;
  z-index: 9999;
  display: grid;
  place-items: center;
  background: rgba(255, 255, 255, 0.78);
  backdrop-filter: blur(4px);
}

.loading-ring {
  display: inline-block;
  position: relative;
  width: 56px;
  height: 56px;
}

.loading-ring div {
  box-sizing: border-box;
  display: block;
  position: absolute;
  width: 44px;
  height: 44px;
  margin: 6px;
  border: 4px solid #2563eb;
  border-radius: 50%;
  animation: loading-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
  border-color: #2563eb transparent transparent transparent;
}

.loading-ring div:nth-child(1) { animation-delay: -0.45s; }
.loading-ring div:nth-child(2) { animation-delay: -0.3s; }
.loading-ring div:nth-child(3) { animation-delay: -0.15s; }
.loading-ring div:nth-child(4) { animation-delay: 0s; }

.page-fade-enter-active,
.page-fade-leave-active {
  transition: opacity 0.2s ease;
}

.page-fade-enter-from,
.page-fade-leave-to {
  opacity: 0;
}

@keyframes loading-ring {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>