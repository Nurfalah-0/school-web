<template>
  <div class="load-more-wrap">
    <button type="button" class="load-more-btn" @click="$emit('click')">
      <span>Muat Lebih Banyak</span>
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>
    </button>
  </div>
</template>

<script setup>
defineOptions({
  name: 'LoadMoreButton'
});
</script>

<style lang="scss" scoped>
.load-more-wrap {
  display: flex;
  justify-content: center;
  margin-top: 2.5rem;
  padding-bottom: 2rem;
}

.load-more-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.75rem;
  border-radius: 9999px;
  border: none;
  background: #eef2ff;
  color: #0f172a;
  font-weight: 600;
  font-size: 0.95rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.load-more-btn:hover {
  background: #e0e7ff;
}
</style>
