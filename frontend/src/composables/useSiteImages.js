import { computed, onMounted } from 'vue'
import { useSiteImagesStore } from '@/stores/useSiteImagesStore'

export function useSiteImages() {
  const store = useSiteImagesStore()

  const images = computed(() => store.images)
  const loading = computed(() => store.loading)

  const getImagesBySection = (section) =>
    store.images.filter(img => img.section === section && img.is_active)
      .sort((a, b) => a.position - b.position)

  const getImageByKey = (key) =>
    store.images.find(img => img.key === key && img.is_active)

  const getImageUrl = (image) => {
    if (!image) return ''
    const rawUrl = image.image_url || image.url || (image.image_path ? `/storage/${image.image_path}` : '')
    if (!rawUrl) return ''
    if (/^https?:\/\//i.test(rawUrl)) return rawUrl
    const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000/api'
    const serverUrl = apiUrl.replace(/\/api\/?$/, '')
    return `${serverUrl}${rawUrl.startsWith('/') ? rawUrl : `/${rawUrl}`}`
  }

  const fetchImages = () => store.fetch()

  onMounted(() => store.fetch())

  return { images, loading, getImagesBySection, getImageByKey, getImageUrl, fetchImages }
}
