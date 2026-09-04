<template>
  <div class="tags-share">
    <div class="tags-share-divider"></div>
    <div class="tags-share-inner">
      <div class="tags-share-tags">
        <router-link
          v-for="tag in tags"
          :key="tag"
          :to="`/berita?tag=${encodeURIComponent(tag)}`"
          class="tag-pill"
        >
          {{ tag }}
        </router-link>
      </div>
      <div class="tags-share-actions">
        <span class="tags-share-label">Bagikan:</span>
        <button type="button" class="share-btn" aria-label="Comment" @click="copyLink">
          <MessageCircle :size="16" color="#64748b" />
        </button>
        <button type="button" class="share-btn" aria-label="Website" @click="copyLink">
          <Globe :size="16" color="#64748b" />
        </button>
        <button type="button" class="share-btn" aria-label="Share" @click="handleShare">
          <Share2 :size="16" color="#64748b" />
        </button>
        <button type="button" class="share-btn" aria-label="Copy link" @click="copyLink">
          <Link :size="16" color="#64748b" />
        </button>
        <span v-if="copied" class="copy-feedback">Link disalin!</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Share2, Link, MessageCircle, Globe } from 'lucide-vue-next'

const props = defineProps({
  tags: {
    type: Array,
    required: true
  }
})

const copied = ref(false)

async function copyLink() {
  try {
    await navigator.clipboard.writeText(window.location.href)
    copied.value = true
    setTimeout(() => (copied.value = false), 2000)
  } catch {
    copied.value = true
    setTimeout(() => (copied.value = false), 2000)
  }
}

async function handleShare() {
  const url = window.location.href
  if (navigator.share) {
    try {
      await navigator.share({ title: document.title, url })
    } catch {
      copyLink()
    }
  } else {
    copyLink()
  }
}
</script>

<style lang="scss" scoped>
.tags-share {
  margin-top: 3rem;
}

.tags-share-divider {
  height: 1px;
  background: #e2e8f0;
  margin-bottom: 2rem;
}

.tags-share-inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  gap: 1.5rem;
}

.tags-share-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
}

.tag-pill {
  padding: 0.6rem 1.5rem;
  border-radius: 9999px;
  background: #eef2ff;
  color: #334155;
  font-size: 0.875rem;
  font-weight: 600;
  text-decoration: none;
  transition: background 0.2s ease, color 0.2s ease;
}

.tag-pill:hover {
  background: #e0e7ff;
  color: #1e3a5f;
}

.tags-share-actions {
  display: inline-flex;
  align-items: center;
  gap: 1rem;
}

.tags-share-label {
  font-size: 0.875rem;
  color: #64748b;
  font-weight: 600;
}

.share-btn {
  width: 2.5rem;
  height: 2.5rem;
  display: grid;
  place-items: center;
  border: none;
  border-radius: 9999px;
  background: #eef2ff;
  cursor: pointer;
  transition: background 0.2s ease;
}

.share-btn:hover {
  background: #e0e7ff;
}

.copy-feedback {
  font-size: 0.8rem;
  color: #0f766e;
  font-weight: 700;
}
</style>
