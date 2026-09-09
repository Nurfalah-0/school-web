<template>
  <aside class="berita-lainnya">
    <div class="berita-lainnya-header">
      <span class="berita-lainnya-line"></span>
      <h3 class="berita-lainnya-title">Berita Lainnya</h3>
    </div>
    <div class="berita-lainnya-list">
      <router-link
        v-for="item in items"
        :key="item.slug"
        :to="`/berita/${item.slug}`"
        class="berita-lainnya-card"
      >
        <div class="berita-lainnya-img-wrap">
          <img
            :src="item.gambarUtama"
            :alt="item.judul"
            class="berita-lainnya-img"
            loading="lazy"
            @error="item.gambarUtama = 'https://placehold.co/500x300/e2e8f0/475569?text=Berita'"
          />
          <span
            class="berita-lainnya-badge"
            :style="{ background: kategoriColor(item.kategori) }"
          >
            {{ item.kategori }}
          </span>
        </div>
        <div class="berita-lainnya-body">
          <h4 class="berita-lainnya-name">{{ item.judul }}</h4>
          <span class="berita-lainnya-date">
            <Calendar :size="14" color="#94a3b8" />
            {{ item.tanggalDisplay }}
          </span>
        </div>
      </router-link>
    </div>
  </aside>
</template>

<script setup>
import { Calendar } from "lucide-vue-next";

defineProps({
  items: {
    type: Array,
    required: true,
  },
});

function kategoriColor(kategori) {
  const colors = ["#1e3a8a", "#0f766e", "#b45309", "#7c3aed", "#be123c"];
  const index =
    [...(kategori || "")].reduce(
      (sum, letter) => sum + letter.charCodeAt(0),
      0,
    ) % colors.length;
  return colors[index];
}
</script>

<style lang="scss" scoped>
.berita-lainnya {
  align-self: start;
  display: flex;
  flex-direction: column;
  gap: 0;
}

@media (max-width: 767px) {
  .berita-lainnya {
    position: static;
  }
}

.berita-lainnya-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.berita-lainnya-line {
  width: 0.25rem;
  height: 1.5rem;
  border-radius: 9999px;
  background: #1e3a8a;
  flex-shrink: 0;
}

.berita-lainnya-title {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.berita-lainnya-list {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.berita-lainnya-card {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  text-decoration: none;
  color: inherit;
}

.berita-lainnya-img-wrap {
  position: relative;
  aspect-ratio: 16 / 10;
  border-radius: 1rem;
  overflow: hidden;
}

.berita-lainnya-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.3s ease;
}

.berita-lainnya-card:hover .berita-lainnya-img {
  transform: scale(1.05);
}

.berita-lainnya-badge {
  position: absolute;
  top: 0.75rem;
  left: 0.75rem;
  padding: 0.35rem 0.85rem;
  border-radius: 9999px;
  color: #ffffff;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.04em;
}

.berita-lainnya-body {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.berita-lainnya-name {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 700;
  font-size: 1rem;
  color: #0f172a;
  line-height: 1.45;
  margin: 0;
  margin-top: 0.25rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.berita-lainnya-date {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.875rem;
  color: #64748b;
  margin-top: 0.25rem;
}
</style>
