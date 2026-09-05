<template>
  <aside class="sidebar-jurusan">
    <div class="sidebar-card">
      <h3 class="sidebar-title">Program Lainnya</h3>
      <div class="sidebar-list">
        <router-link
          v-for="item in jurusanLainnya"
          :key="item.slug"
          :to="`/jurusan/${item.slug}`"
          class="sidebar-item"
          :class="{ 'sidebar-item-active': item.slug === currentSlug }"
        >
          <div class="sidebar-item-icon" :style="{ background: item.slug === currentSlug ? '#1e3a5f' : item.iconBg }">
            <component :is="iconMap[item.icon]" :size="18" :color="item.slug === currentSlug ? '#ffffff' : '#ffffff'" />
          </div>
          <div class="sidebar-item-info">
            <span class="sidebar-item-name">{{ item.nama }}</span>
            <span class="sidebar-item-kategori">{{ item.kategori }}</span>
          </div>
        </router-link>
      </div>
    </div>

    <div class="sidebar-card sidebar-cta">
      <div class="sidebar-cta-inner">
        <div class="sidebar-cta-icon">
          <Headphones :size="20" color="#1e3a5f" />
        </div>
        <h3 class="sidebar-cta-title">Bingung Pilih Jurusan?</h3>
        <p class="sidebar-cta-text">Konsultasikan minat dan bakatmu dengan konselor kami secara gratis.</p>
        <button type="button" class="sidebar-cta-btn" @click="openChatbot">
          Tanya Sekarang
        </button>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { CodeXml, Briefcase, Network, Palette, Calculator, Headphones } from 'lucide-vue-next'

const props = defineProps({
  jurusanLainnya: {
    type: Array,
    required: true
  },
  currentSlug: {
    type: String,
    default: ''
  }
})

const iconMap = {
  CodeXml,
  Briefcase,
  Network,
  Palette,
  Calculator
}

function openChatbot() {
  window.dispatchEvent(new CustomEvent('chatbot:open'))
}
</script>

<style lang="scss" scoped>
.sidebar-jurusan {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

@media (min-width: 768px) {
  .sidebar-jurusan {
    position: sticky;
    top: 5.5rem;
    align-self: start;
  }
}

.sidebar-card {
  background: #ffffff;
  border-radius: 1.25rem;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.sidebar-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #1e3a5f;
  margin: 0 0 1.25rem;
}

.sidebar-list {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.sidebar-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  border-radius: 0.75rem;
  text-decoration: none;
  transition: background 0.2s ease;
}

.sidebar-item:hover {
  background: #f8fafc;
}

.sidebar-item-active {
  background: #eef2ff;
}

.sidebar-item-icon {
  width: 2.5rem;
  height: 2.5rem;
  display: grid;
  place-items: center;
  border-radius: 0.75rem;
  flex-shrink: 0;
}

.sidebar-item-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.sidebar-item-name {
  font-weight: 700;
  font-size: 0.95rem;
  color: #1e293b;
  line-height: 1.3;
}

.sidebar-item-kategori {
  font-size: 0.75rem;
  color: #64748b;
  line-height: 1.3;
}

.sidebar-cta {
  background: linear-gradient(135deg, #1e3a5f 0%, #16264d 100%);
  color: #ffffff;
  padding: 0;
  overflow: hidden;
}

.sidebar-cta-inner {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 0.75rem;
}

.sidebar-cta-icon {
  width: 2.5rem;
  height: 2.5rem;
  display: grid;
  place-items: center;
  border-radius: 9999px;
  background: #ccfbf1;
  color: #1e3a5f;
  margin-bottom: 0.25rem;
}

.sidebar-cta-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.125rem;
  color: #ffffff;
  margin: 0;
}

.sidebar-cta-text {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.85);
  margin: 0;
  line-height: 1.6;
}

.sidebar-cta-btn {
  width: 100%;
  padding: 0.75rem;
  border: none;
  border-radius: 9999px;
  background: #1e3a5f;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.95rem;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
  transition: background 0.2s ease, transform 0.2s ease;
  margin-top: 0.5rem;
}

.sidebar-cta-btn:hover {
  background: #2a4a7a;
  transform: translateY(-1px);
}
</style>
