<template>
  <section class="semua-berita-page">
    <AnimateOnScroll animation="fadeInDown">
      <div class="semua-berita-inner">
        <div class="semua-berita-header">
          <span class="semua-berita-label">INFORMASI & KEGIATAN</span>
          <h1 class="semua-berita-title">Semua Berita</h1>
          <p class="semua-berita-desc">
            Dapatkan informasi terbaru seputar kegiatan, prestasi, dan
            pengumuman SMK Nurul Jadid.
          </p>
        </div>

        <AnimateOnScroll animation="fadeInUp" :delay="100">
          <div class="semua-berita-filters">
            <button
              v-for="kat in kategoriList"
              :key="kat.value"
              :class="['filter-pill', { active: kategoriAktif === kat.value }]"
              type="button"
              @click="kategoriAktif = kat.value"
            >
              {{ kat.label }}
            </button>
          </div>
        </AnimateOnScroll>

        <AnimateOnScroll animation="fadeInUp" :delay="200">
          <div class="semua-berita-grid">
            <div
              v-for="item in filteredBerita"
              :key="item.slug"
              class="semua-berita-card"
            >
              <router-link
                :to="`/berita/${item.slug}`"
                class="semua-berita-card-link"
              >
                <div class="semua-berita-img-wrap">
                  <img
                    :src="item.gambarUtama"
                    :alt="item.judul"
                    class="semua-berita-img"
                    loading="lazy"
                    crossorigin="anonymous"
                  />
                  <span
                    class="semua-berita-badge"
                    :style="{ background: kategoriColor(item.kategori) }"
                  >
                    {{ item.kategori }}
                  </span>
                </div>
                <div class="semua-berita-body">
                  <span class="semua-berita-date">{{
                    item.tanggalDisplay
                  }}</span>
                  <h3 class="semua-berita-name">{{ item.judul }}</h3>
                  <p class="semua-berita-excerpt">{{ excerpt(item) }}</p>
                </div>
              </router-link>
            </div>
          </div>
        </AnimateOnScroll>

        <AnimateOnScroll animation="fadeInUp" :delay="300">
          <div v-if="filteredBerita.length === 0" class="semua-berita-empty">
            <p>Belum ada berita di kategori ini.</p>
          </div>
        </AnimateOnScroll>
      </div>
    </AnimateOnScroll>
  </section>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRoute } from "vue-router";
import { getNews } from "@/api/endpoints";
import { mapNews } from "../services/newsMapper";
import AnimateOnScroll from "@/shared/components/AnimateOnScroll.vue";

const route = useRoute();
const kategoriAktif = ref("Semua");
const beritaList = ref([]);

const kategoriList = computed(() => [
  { label: "Semua", value: "Semua" },
  ...[...new Set(beritaList.value.map((item) => item.kategori))].map(
    (kategori) => ({ label: kategori, value: kategori }),
  ),
]);

const filteredBerita = computed(() => {
  let list = beritaList.value;

  if (route.query.tag) {
    const tag = route.query.tag;
    list = list.filter((b) => b.tags && b.tags.includes(tag));
  }

  if (kategoriAktif.value !== "Semua") {
    list = list.filter((b) => b.kategori === kategoriAktif.value);
  }

  return list;
});

function excerpt(artikel) {
  const txt = artikel.konten.find((b) => b.tipe === "paragraf")?.teks || "";
  return txt.length > 120 ? txt.slice(0, 120).trim() + "..." : txt;
}

function kategoriColor(kategori) {
  const colors = ["#1e3a8a", "#0f766e", "#b45309", "#7c3aed", "#be123c"];
  const index =
    [...(kategori || "")].reduce(
      (sum, letter) => sum + letter.charCodeAt(0),
      0,
    ) % colors.length;
  return colors[index];
}

async function loadBerita() {
  const response = await getNews(1, 100);
  const articles = response.data?.data?.data || response.data?.data || [];
  beritaList.value = articles.map(mapNews);
}

onMounted(async () => {
  try {
    await loadBerita();
  } catch {
    beritaList.value = [];
  }
  if (route.query.tag) {
    kategoriAktif.value = "Semua";
  }
});

watch(
  () => route.query.tag,
  () => {
    kategoriAktif.value = "Semua";
  },
);
</script>

<style lang="scss" scoped>
.semua-berita-page {
  min-height: 100vh;
  background: #f8f7fb;
  padding: 2rem 0 4rem;
}

.semua-berita-inner {
  max-width: 80rem;
  margin: 0 auto;
  padding: 0 1.5rem;
}

.semua-berita-header {
  margin-bottom: 2rem;
}

.semua-berita-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #b45309;
  margin-bottom: 0.5rem;
}

.semua-berita-title {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 2.8vw, 2.4rem);
  color: #1e293b;
  margin: 0;
}

.semua-berita-desc {
  font-size: 1rem;
  color: #475569;
  margin: 0.5rem 0 0;
  max-width: 600px;
}

.semua-berita-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-bottom: 2rem;
}

.filter-pill {
  padding: 0.6rem 1.25rem;
  border-radius: 9999px;
  border: none;
  background: #eef2ff;
  color: #334155;
  font-weight: 700;
  font-size: 0.9rem;
  cursor: pointer;
  transition:
    background 0.2s ease,
    color 0.2s ease,
    box-shadow 0.2s ease;
}

.filter-pill:hover {
  background: #e0e7ff;
}

.filter-pill.active {
  background: #1e3a5f;
  color: #ffffff;
  box-shadow: 0 6px 16px rgba(30, 58, 95, 0.25);
}

.semua-berita-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .semua-berita-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .semua-berita-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }
}

.semua-berita-card {
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  overflow: hidden;
  background: #ffffff;
  transition: box-shadow 0.2s ease;
}

.semua-berita-card:hover {
  box-shadow: 0 16px 40px rgba(15, 23, 42, 0.08);
}

.semua-berita-card-link {
  display: flex;
  flex-direction: column;
  height: 100%;
  text-decoration: none;
  color: inherit;
}

.semua-berita-img-wrap {
  position: relative;
  aspect-ratio: 16 / 10;
  overflow: hidden;
}

.semua-berita-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.semua-berita-badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  padding: 0.35rem 0.9rem;
  border-radius: 9999px;
  color: #ffffff;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.02em;
}

.semua-berita-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  flex: 1;
}

.semua-berita-date {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.85rem;
  color: #1e3a5f;
  font-weight: 700;
}

.semua-berita-name {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.15rem;
  color: #1e293b;
  line-height: 1.4;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.semua-berita-excerpt {
  font-size: 0.95rem;
  color: #475569;
  line-height: 1.7;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.semua-berita-empty {
  text-align: center;
  padding: 4rem 1rem;
  color: #64748b;
}
</style>
