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

    <MainLayout v-if="!isBlankLayout" />
    <router-view v-if="isBlankLayout" v-slot="{ Component }">
      <transition name="page-fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
    <ChatbotWidget v-if="!isBlankLayout" />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import MainLayout from './shared/layouts/MainLayout.vue';
import ChatbotWidget from './modules/chatbot/components/ChatbotWidget.vue';

const route = useRoute();
const isLoading = ref(false);
let loadingTimer = null;
const router = useRouter();

const isBlankLayout = computed(() => route.meta.blankLayout === true);

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
  background: #f8f7fb;
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

<style>
/* Global scroll animation utilities */
.animate-on-scroll {
  opacity: 0;
  will-change: transform, opacity;
}

.animate-on-scroll--fadeInUp {
  transform: translateY(30px);
}

.animate-on-scroll--fadeInDown {
  transform: translateY(-30px);
}

.animate-on-scroll--fadeInLeft {
  transform: translateX(-30px);
}

.animate-on-scroll--fadeInRight {
  transform: translateX(30px);
}

.animate-on-scroll--scaleIn {
  transform: scale(0.95);
}

.animate-on-scroll--fadeIn {
  transform: none;
}

.animate-on-scroll.animate-in {
  animation-duration: 0.55s;
  animation-fill-mode: both;
  animation-timing-function: cubic-bezier(0.22, 0.61, 0.36, 1);
}

.animate-on-scroll--fadeInUp.animate-in {
  animation-name: animateFadeInUp;
}

.animate-on-scroll--fadeInDown.animate-in {
  animation-name: animateFadeInDown;
}

.animate-on-scroll--fadeInLeft.animate-in {
  animation-name: animateFadeInLeft;
}

.animate-on-scroll--fadeInRight.animate-in {
  animation-name: animateFadeInRight;
}

.animate-on-scroll--scaleIn.animate-in {
  animation-name: animateScaleIn;
}

.animate-on-scroll--fadeIn.animate-in {
  animation-name: animateFadeIn;
}

.animate-on-scroll--delay.animate-in {
  animation-delay: var(--delay, 0ms);
}

@keyframes animateFadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes animateFadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes animateFadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes animateFadeInRight {
  from {
    opacity: 0;
    transform: translateX(30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes animateScaleIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes animateFadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Global hover micro-interactions */
.card-hover {
  transition: transform 0.25s cubic-bezier(0.22, 0.61, 0.36, 1), box-shadow 0.25s ease;
}

.card-hover:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px rgba(15, 23, 42, 0.1);
}

.btn-hover {
  transition: transform 0.15s ease, box-shadow 0.15s ease, background-color 0.2s ease;
}

.btn-hover:active {
  transform: scale(0.97);
}

.img-zoom {
  overflow: hidden;
}

.img-zoom img {
  transition: transform 0.5s cubic-bezier(0.22, 0.61, 0.36, 1);
}

.img-zoom:hover img {
  transform: scale(1.05);
}

/* Floating animation for chat button */
@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-6px);
  }
}

.chat-bot {
  animation: float 3s ease-in-out infinite;
}
</style>
