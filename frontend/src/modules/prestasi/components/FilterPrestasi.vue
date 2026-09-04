<template>
  <section class="filter-section">
    <div class="filter-inner">
      <div class="filter-scroll">
        <button
          v-for="item in kategoriList"
          :key="item.value"
          :class="['filter-pill', { active: aktif === item.value }]"
          type="button"
          @click="pilihKategori(item.value)"
        >
          {{ item.label }}
        </button>
      </div>
    </div>
  </section>
</template>

<script setup>
defineProps({
  aktif: {
    type: String,
    default: "semua",
  },
});

const emit = defineEmits(["update:kategori"]);

const kategoriList = [
  { label: "Semua", value: "semua" },
  { label: "Akademik", value: "akademik" },
  { label: "Non-Akademik", value: "non-akademik" },
  { label: "Seni & Budaya", value: "seni-budaya" },
  { label: "Olahraga", value: "olahraga" },
];

function pilihKategori(value) {
  emit("update:kategori", value);
}
</script>

<style lang="scss" scoped>
.filter-section {
  background: #ffffff;
  padding: 1.5rem 0;
}

.filter-inner {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1.5rem;
}

.filter-scroll {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 0.75rem;
}

.filter-pill {
  padding: 0.65rem 1.5rem;
  border-radius: 9999px;
  border: 1px solid #e2e8f0;
  background: #ffffff;
  color: #334155;
  font-weight: 600;
  font-size: 0.95rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-pill:hover {
  border-color: #93c5fd;
}

.filter-pill.active {
  background: #1e3a8a;
  color: #ffffff;
  border-color: #1e3a8a;
}
</style>
