<template>
  <div class="cta-ppdb">
    <div class="cta-ppdb-inner">
      <h3 class="cta-ppdb-title">Ingin tahu info PPDB terbaru?</h3>
      <p class="cta-ppdb-text">Bergabunglah bersama kami dan wujudkan mimpimu di dunia vokasi.</p>
      <router-link to="/ppdb" class="cta-ppdb-btn">
        Lihat PPDB
        <ArrowRight :size="16" color="#042d86" />
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { ArrowRight } from 'lucide-vue-next'
</script>

<style lang="scss" scoped>
.cta-ppdb {
  background: linear-gradient(135deg, #042d86 0%, #28469e 100%);
  border-radius: 1.5rem;
  padding: 2rem;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
  margin-top: 3rem;
}

.cta-ppdb-inner {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.cta-ppdb-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #ffffff;
  margin: 0;
  line-height: 1.35;
}

.cta-ppdb-text {
  font-size: 0.95rem;
  color: rgba(255, 255, 255, 0.9);
  margin: 0;
  line-height: 1.6;
}

.cta-ppdb-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.85rem 1.75rem;
  border-radius: 9999px;
  background: #ffddb4;
  color: #042d86;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  margin-top: 0.75rem;
  width: 100%;
  transition: background 0.2s ease, transform 0.2s ease;
}

.cta-ppdb-btn:hover {
  background: #ffc896;
  transform: translateY(-1px);
}
</style>
