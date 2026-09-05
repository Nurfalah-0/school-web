<template>
  <section class="cta-rekrutmen">
    <div class="cta-rekrutmen-inner">
      <div class="cta-rekrutmen-copy">
        <h2 class="cta-rekrutmen-title">
          Ingin Merekrut Talenta<br />Terbaik?
        </h2>
        <p class="cta-rekrutmen-desc">
          Bergabunglah dengan program Kerjasama Industri kami. Pasang lowongan kerja Anda dan temukan lulusan siap kerja dari SMK Nurul Jadid.
        </p>
      </div>
      <button type="button" class="cta-rekrutmen-btn" @click="openModal">
        <Tag :size="18" color="#ffffff" />
        Hubungi Kami
      </button>
    </div>

    <ModalPasangLowongan v-model:open="isOpen" @submit="isOpen = false" />
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { Tag } from 'lucide-vue-next'
import ModalPasangLowongan from './ModalPasangLowongan.vue'

const isOpen = ref(false)

function openModal() {
  isOpen.value = true
}
</script>

<style lang="scss" scoped>
.cta-rekrutmen {
  background: #1e3a8a;
  border-radius: 2rem;
  padding: 3.5rem 2rem;
  margin: 4rem auto;
  max-width: 80rem;
}

.cta-rekrutmen-inner {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1.5rem;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  gap: 2rem;
}

.cta-rekrutmen-copy {
  flex: 1 1 18rem;
}

.cta-rekrutmen-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.5rem, 2.5vw, 2.25rem);
  color: #ffffff;
  margin: 0;
  line-height: 1.25;
}

.cta-rekrutmen-desc {
  margin-top: 1rem;
  color: rgba(255, 255, 255, 0.85);
  font-size: 1rem;
  line-height: 1.7;
  max-width: 36rem;
}

.cta-rekrutmen-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.9rem 1.75rem;
  border-radius: 9999px;
  background: #8b6914;
  color: #ffffff;
  font-weight: 700;
  font-size: 1rem;
  border: none;
  cursor: pointer;
  transition: background 0.2s ease;
}

.cta-rekrutmen-btn:hover {
  background: #6e5510;
}

@media (max-width: 767px) {
  .cta-rekrutmen {
    padding: 2.5rem 1.25rem;
    border-radius: 1.5rem;
  }

  .cta-rekrutmen-inner {
    flex-direction: column;
    align-items: flex-start;
  }

  .cta-rekrutmen-btn {
    width: 100%;
    justify-content: center;
  }
}
</style>
