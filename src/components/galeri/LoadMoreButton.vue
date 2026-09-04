<template>
  <div class="load-more-wrap">
    <button type="button" class="load-more-btn" @click="$emit('click')">
      <span class="btn-ring"></span>
      <svg class="btn-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>
      <span>Muat Lebih Banyak</span>
    </button>
  </div>
</template>

<script setup>
defineOptions({ name: 'LoadMoreButton' });
defineEmits(['click']);
</script>

<style lang="scss" scoped>
.load-more-wrap {
  display: flex;
  justify-content: center;
  padding: 0 1.5rem 3rem;
}

.load-more-btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 2.25rem;
  border-radius: 9999px;
  border: 1.5px solid #e2e8f0;
  background: #ffffff;
  color: #1e293b;
  font-weight: 600;
  font-size: 0.925rem;
  cursor: pointer;
  overflow: hidden;
  transition: border-color 0.25s ease, box-shadow 0.25s ease, color 0.25s ease, transform 0.2s ease;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);

  &:hover {
    border-color: #7c3aed;
    color: #7c3aed;
    box-shadow: 0 8px 24px rgba(124, 58, 237, 0.18);
    transform: translateY(-2px);

    .btn-ring { opacity: 1; transform: scale(1); }
    .btn-icon { transform: translateY(2px); }
  }

  &:active { transform: translateY(0); }
}

.btn-ring {
  position: absolute;
  inset: 0;
  border-radius: 9999px;
  background: linear-gradient(135deg, rgba(124, 58, 237, 0.07), rgba(37, 99, 235, 0.07));
  opacity: 0;
  transform: scale(0.8);
  transition: opacity 0.25s ease, transform 0.25s ease;
  pointer-events: none;
}

.btn-icon {
  transition: transform 0.25s ease;
}
</style>
