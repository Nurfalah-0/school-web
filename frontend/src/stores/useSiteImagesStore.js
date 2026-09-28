import { defineStore } from 'pinia'
import { getSiteImages } from '@/api/endpoints'

export const useSiteImagesStore = defineStore('siteImages', {
  state: () => ({
    images: [],
    fetched: false,
    loading: false,
  }),
  actions: {
    async fetch() {
      if (this.fetched || this.loading) return
      this.loading = true
      try {
        const response = await getSiteImages()
        let data = []
        if (response.data?.data?.images) data = response.data.data.images
        else if (Array.isArray(response.data?.data)) data = response.data.data
        else if (Array.isArray(response.data)) data = response.data
        this.images = data
        this.fetched = true
      } catch {
        // interceptor sudah tampilkan toast
      } finally {
        this.loading = false
      }
    },
  },
})
