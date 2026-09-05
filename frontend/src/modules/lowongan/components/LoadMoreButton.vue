<template>
  <div class="load-more-wrap">
    <button type="button" class="load-more-btn" @click="$emit('click')">
      Muat Lebih Banyak
      <ChevronDown :size="18" color="#1e3a8a" />
    </button>
  </div>
</template>

<script setup>
import { ChevronDown } from 'lucide-vue-next'
defineEmits(['click'])
</script>

<style lang="scss" scoped>
.load-more-wrap {
  display: flex;
  justify-content: center;
  margin-top: 2rem;
}

.load-more-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.75rem;
  border-radius: 9999px;
  background: #eef2ff;
  color: #1e3a8a;
  font-weight: 700;
  font-size: 0.95rem;
  border: none;
  cursor: pointer;
  transition: background 0.2s ease;
}

.load-more-btn:hover {
  background: #e0e7ff;
}
</style>
