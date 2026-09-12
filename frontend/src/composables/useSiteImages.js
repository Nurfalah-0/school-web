import { ref, computed, onMounted } from 'vue'
import { getSiteImages } from '@/api/endpoints'

export function useSiteImages() {
  const images = ref([])
  const loading = ref(false)
  const error = ref(null)

  const imagesBySection = computed(() => {
    const grouped = {}
    images.value.forEach(img => {
      if (!grouped[img.section]) {
        grouped[img.section] = []
      }
      grouped[img.section].push(img)
    })
    return grouped
  })

  const getImagesBySection = (section) => {
    return images.value.filter(img => img.section === section && img.is_active)
      .sort((a, b) => a.position - b.position)
  }

  const getImageByKey = (key) => {
    const found = images.value.find(img => img.key === key && img.is_active)
    return found
  }

  const getImageUrl = (image) => {
    if (!image) return ''

    const rawUrl = image.image_url || image.url || (image.image_path ? `/storage/${image.image_path}` : '')
    if (!rawUrl) return ''
    if (/^https?:\/\//i.test(rawUrl)) return rawUrl

    const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000/api'
    const serverUrl = apiUrl.replace(/\/api\/?$/, '')
    return `${serverUrl}${rawUrl.startsWith('/') ? rawUrl : `/${rawUrl}`}`
  }

  const fetchImages = async () => {
    try {
      loading.value = true
      error.value = null
      const response = await getSiteImages()
      
      // Handle different response formats
      let imageData = []
      if (response.data?.data?.images) {
        imageData = response.data.data.images
      } else if (response.data?.data) {
        imageData = Array.isArray(response.data.data) ? response.data.data : []
      } else if (response.data && Array.isArray(response.data)) {
        imageData = response.data
      } else {
        imageData = response.data || []
      }
      
      images.value = imageData
      console.log('Site images loaded:', imageData.length, 'images')
      
    } catch (err) {
      console.error('Error fetching site images:', err)
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  onMounted(() => {
    fetchImages()
  })

  return {
    images,
    loading,
    error,
    imagesBySection,
    getImagesBySection,
    getImageByKey,
    getImageUrl,
    fetchImages,
  }
}
