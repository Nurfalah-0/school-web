<template>
  <section class="cta-prestasi">
    <div class="cta-prestasi-inner">
      <div class="cta-prestasi-icon">
        <Megaphone :size="48" color="#ffffff" />
      </div>
      <h2 class="cta-prestasi-title">Punya Prestasi Baru?</h2>
      <p class="cta-prestasi-desc">
        Laporkan prestasimu untuk ditampilkan di halaman ini dan inspirasi teman-teman lainnya!
      </p>
      <button type="button" class="cta-prestasi-btn" @click="openModal">
        Kirim Prestasi
        <ArrowRight :size="18" color="#1e3a8a" />
      </button>
    </div>

    <ModalKirimPrestasi v-model:open="isModalOpen" @submit="handleSubmit" />
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { Megaphone, ArrowRight } from 'lucide-vue-next'
import ModalKirimPrestasi from './ModalKirimPrestasi.vue'

const isModalOpen = ref(false)

function openModal() {
  isModalOpen.value = true
}

function handleSubmit() {
  isModalOpen.value = false
}
</script>

<style lang="scss" scoped>
.cta-prestasi {
  background: linear-gradient(135deg, #1e3a8a 0%, #16264d 100%);
  border-radius: 2rem;
  padding: 4rem 2rem;
  margin: 4rem auto;
  max-width: 80rem;
}

.cta-prestasi-inner {
  max-width: 48rem;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 1.25rem;
}

.cta-prestasi-icon {
  margin-bottom: 0.5rem;
}

.cta-prestasi-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.75rem, 3vw, 2.5rem);
  color: #ffffff;
  margin: 0;
  line-height: 1.2;
}

.cta-prestasi-desc {
  font-size: 1.125rem;
  color: rgba(255, 255, 255, 0.85);
  line-height: 1.7;
  margin: 0;
  max-width: 36rem;
}

.cta-prestasi-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 1rem 2rem;
  border-radius: 9999px;
  background: #fbbf24;
  color: #1e3a8a;
  font-weight: 700;
  font-size: 1rem;
  border: none;
  cursor: pointer;
  margin-top: 0.75rem;
  transition: background 0.2s ease, transform 0.2s ease;
}

.cta-prestasi-btn:hover {
  background: #f59e0b;
  transform: translateY(-1px);
}

@media (max-width: 767px) {
  .cta-prestasi {
    padding: 3rem 1.5rem;
    margin: 3rem 1rem;
    border-radius: 1.5rem;
  }

  .cta-prestasi-btn {
    width: 100%;
  }
}
</style>
