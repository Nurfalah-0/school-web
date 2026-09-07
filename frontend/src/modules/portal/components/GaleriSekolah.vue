<template>
  <section class="galeri-sekolah">
    <div class="galeri-inner">
      <div class="galeri-header">
        <h2 class="galeri-title">Galeri Sekolah</h2>
        <router-link to="/galeri" class="galeri-link">Semua Galeri</router-link>
      </div>

      <div class="galeri-grid">
        <div
          v-for="(item, idx) in galeri"
          :key="item.id"
          class="galeri-item"
          :class="[item.heightClass]"
        >
          <img
            :src="item.src"
            :alt="item.alt"
            class="galeri-img"
            loading="lazy"
            crossorigin="anonymous"
          />
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { getPublicContent } from "@/api/endpoints";
import { mapGallery } from "@/modules/contentMapper";
import { galeriList } from "@/data/galeri";

defineOptions({
  name: "GaleriSekolah",
});

defineProps({
  title: {
    type: String,
    default: "Galeri Sekolah",
  },
});

const rawGalleries = ref([]);

onMounted(async () => {
  try {
    const res = await getPublicContent("galleries");
    const data = (res.data?.data || []).map(mapGallery);
    if (data.length > 0) {
      rawGalleries.value = data;
    } else {
      rawGalleries.value = galeriList;
    }
  } catch (err) {
    rawGalleries.value = galeriList;
  }
});

const galeri = computed(() => {
  const list = rawGalleries.value;
  const featured = list.filter((g) => g.featured || g.is_featured);
  const selected =
    featured.length >= 4 ? featured.slice(0, 4) : list.slice(0, 4);

  const heightMap = [
    "item-height-1",
    "item-height-2",
    "item-height-3",
    "item-height-4",
  ];

  return selected.map((item, idx) => ({
    id: item.id || idx,
    src: item.gambar || item.src,
    alt: item.judul || item.title || "Galeri SMK",
    heightClass: heightMap[idx] || "item-height-1",
  }));
});
</script>

<style lang="scss" scoped>
.galeri-sekolah {
  background: #f8fafc;
  padding: 6rem 0 2rem;
  position: relative;
}

.galeri-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto 2rem;
  background: #ffffff;
  border-radius: 2rem;
  box-shadow: 0 30px 80px rgba(15, 23, 42, 0.12);
  padding: 3rem 2rem 2rem;
  position: relative;
  overflow: hidden;
}

.galeri-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 3rem;
}

.galeri-title {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(1.9rem, 4vw, 3rem);
  color: #0f172a;
  margin: 0;
  letter-spacing: -0.02em;
}

.galeri-link {
  font-weight: 700;
  font-size: 1.125rem;
  color: #1e40af;
  text-decoration: none;
  white-space: nowrap;
  transition: color 0.2s ease;
}

.galeri-link:hover {
  color: #1e3a8a;
  text-decoration: underline;
}

.galeri-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1.5rem;
  align-items: end;
}

@media (max-width: 1023px) {
  .galeri-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 639px) {
  .galeri-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }

  .galeri-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .galeri-item {
    height: 16rem !important;
  }
}

.galeri-item {
  overflow: hidden;
  border-radius: 2rem;
  background: #f8fafc;
  box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
  transition:
    opacity 0.3s ease,
    box-shadow 0.3s ease;
  position: relative;
}

.galeri-item:hover {
  opacity: 0.9;
  box-shadow: 0 26px 55px rgba(15, 23, 42, 0.16);
}

.item-height-1 {
  height: 320px;
}

.item-height-2 {
  height: 400px;
}

.item-height-3 {
  height: 360px;
}

.item-height-4 {
  height: 280px;
}

.galeri-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.galeri-item::before {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(
    180deg,
    rgba(248, 250, 252, 0.2),
    rgba(21, 21, 48, 0.08)
  );
  opacity: 0.4;
  pointer-events: none;
}
</style>
