<template>
  <div class="konten-artikel">
    <template v-for="(block, idx) in konten" :key="idx">
      <p v-if="block.tipe === 'paragraf'" class="konten-paragraf">
        {{ block.teks }}
      </p>
      <h2 v-else-if="block.tipe === 'heading'" class="konten-heading">
        {{ block.teks }}
      </h2>
      <blockquote v-else-if="block.tipe === 'kutipan'" class="konten-kutipan">
        <span class="konten-kutipan-mark">&ldquo;</span>
        <p class="konten-kutipan-teks">{{ block.teks }}</p>
      </blockquote>
    </template>
  </div>
</template>

<script setup>
defineProps({
  konten: {
    type: Array,
    required: true
  }
})
</script>

<style lang="scss" scoped>
.konten-artikel {
  margin-top: 3rem;
}

.konten-paragraf {
  color: #475569;
  font-size: 1.05rem;
  line-height: 1.85;
  margin: 0 0 1.5rem;
}

.konten-heading {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.5rem;
  color: #0f172a;
  margin: 3rem 0 1.5rem;
}

.konten-kutipan {
  position: relative;
  border-left: 4px solid #1e3a8a;
  background: rgba(238, 242, 255, 0.6);
  border-radius: 0 1.25rem 1.25rem 0;
  padding: 2.5rem;
  margin: 2.5rem 0;
}

.konten-kutipan-mark {
  position: absolute;
  top: 1.5rem;
  right: 2rem;
  font-size: 4.5rem;
  font-weight: 900;
  color: #e2e8f0;
  line-height: 1;
  z-index: 0;
  pointer-events: none;
}

.konten-kutipan-teks {
  position: relative;
  z-index: 1;
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e3a8a;
  line-height: 1.35;
  margin: 0;
  max-width: 85%;
}
</style>
