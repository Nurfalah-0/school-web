<template>
  <div
    ref="rootRef"
    class="animate-on-scroll"
    :class="[`animate-on-scroll--${animation}`, { 'animate-on-scroll--delay': delay }]"
    :style="{ animationDelay: delay ? `${delay}ms` : undefined }"
  >
    <slot />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

defineOptions({
  name: 'AnimateOnScroll'
})

const props = defineProps({
  animation: {
    type: String,
    default: 'fadeInUp'
  },
  delay: {
    type: Number,
    default: 0
  },
  threshold: {
    type: Number,
    default: 0.1
  },
  once: {
    type: Boolean,
    default: true
  }
})

const rootRef = ref(null)
let observer = null

onMounted(() => {
  if (typeof window === 'undefined' || !('IntersectionObserver' in window)) {
    rootRef.value?.classList.add('animate-in')
    return
  }

  observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate-in')
        if (props.once) {
          observer.unobserve(entry.target)
        }
      } else if (!props.once) {
        entry.target.classList.remove('animate-in')
      }
    })
  }, {
    threshold: props.threshold,
    rootMargin: '0px 0px -40px 0px'
  })

  if (rootRef.value) {
    observer.observe(rootRef.value)
  }
})

onUnmounted(() => {
  if (observer) {
    observer.disconnect()
  }
})
</script>

<style lang="scss" scoped>
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
</style>
