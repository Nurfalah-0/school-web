import { ref, onMounted, onUnmounted } from 'vue'

export function useScrollAnimation(options = {}) {
  const refs = ref([])
  const observer = ref(null)

  const defaultOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -40px 0px',
    once: true,
    ...options
  }

  function addRef(el) {
    if (el) refs.value.push(el)
    return el
  }

  function observe() {
    if (typeof window === 'undefined' || !('IntersectionObserver' in window)) {
      refs.value.forEach(el => el && el.classList.add('animate-in'))
      return
    }

    observer.value = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-in')
          if (defaultOptions.once) {
            observer.value.unobserve(entry.target)
          }
        } else if (!defaultOptions.once) {
          entry.target.classList.remove('animate-in')
        }
      })
    }, defaultOptions)

    refs.value.forEach(el => el && observer.value.observe(el))
  }

  onMounted(() => {
    observe()
  })

  onUnmounted(() => {
    if (observer.value) {
      observer.value.disconnect()
    }
  })

  return {
    refs,
    addRef,
    observe
  }
}
