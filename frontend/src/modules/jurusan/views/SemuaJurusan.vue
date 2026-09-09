<template>
  <section class="semua-jurusan-page">
    <AnimateOnScroll animation="fadeInDown">
      <div class="semua-jurusan-inner">
        <div class="semua-jurusan-header">
          <span class="semua-jurusan-label">PROGRAM KEAHLIAN</span>
          <h1 class="semua-jurusan-title">Semua Jurusan</h1>
          <p class="semua-jurusan-desc">
            Pilih program keahlian yang sesuai dengan passion dan tujuan
            karirmu.
          </p>
        </div>
        <AnimateOnScroll animation="fadeInUp" :delay="100">
          <div class="semua-jurusan-grid">
            <div
              v-for="item in jurusanList"
              :key="item.slug"
              class="semua-jurusan-card"
            >
              <div class="semua-jurusan-img-wrap">
                <img
                  :src="item.gambarHero"
                  :alt="item.nama"
                  class="semua-jurusan-img"
                  loading="lazy"
                />
                <span class="semua-jurusan-badge">{{ item.kategori }}</span>
              </div>
              <div class="semua-jurusan-body">
                <div class="semua-jurusan-card-header">
                  <span class="semua-jurusan-icon">
                    <component
                      :is="iconMap[item.icon]"
                      :size="20"
                      color="#042d86"
                    />
                  </span>
                  <h3 class="semua-jurusan-name">{{ item.nama }}</h3>
                </div>
                <p class="semua-jurusan-text">{{ item.deskripsi }}</p>
                <router-link
                  :to="`/jurusan/${item.slug}`"
                  class="semua-jurusan-detail"
                >
                  Detail Jurusan
                </router-link>
              </div>
            </div>
          </div>
        </AnimateOnScroll>
      </div>
    </AnimateOnScroll>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import {
  CodeXml,
  Briefcase,
  Network,
  Palette,
  Calculator,
} from "lucide-vue-next";
import { getMajors } from "@/api/endpoints";
import { jurusanList as fallbackJurusanList } from "@/data/jurusan";
import AnimateOnScroll from "@/shared/components/AnimateOnScroll.vue";

const iconMap = {
  CodeXml,
  Briefcase,
  Network,
  Palette,
  Calculator,
};
const API_BASE = (import.meta.env.VITE_API_URL || "http://localhost:8000/api").replace(/\/api\/?$/, "");

const normalizeImageUrl = (value) => {
  if (!value) return "";
  if (value.startsWith("http://") || value.startsWith("https://")) return value;
  if (value.startsWith("/storage/")) return `${API_BASE}${value}`;
  return value;
};

const jurusanList = ref([]);
onMounted(async () => {
  try {
    const response = await getMajors();
    const items = response.data?.data || [];

    if (items.length > 0) {
      jurusanList.value = items.map((item) => {
        const fallback = fallbackJurusanList.find((entry) => entry.slug === item.slug) || {};

        return {
          ...fallback,
          ...item,
          slug: item.slug || fallback.slug,
          nama: item.name || fallback.nama,
          kategori: item.code || fallback.kategori,
          deskripsi: item.description || fallback.deskripsi || "Program keahlian SMK Nurul Jadid.",
          gambarHero:
            normalizeImageUrl(item.image) ||
            fallback.gambarHero ||
            "https://placehold.co/1200x800/e2e8f0/475569?text=Program+Keahlian",
          icon: fallback.icon || "CodeXml",
        };
      });
      return;
    }
  } catch (err) {
    console.warn("Gagal memuat jurusan dari API, mencoba data dummy:", err);
  }

  jurusanList.value = fallbackJurusanList.map((item) => ({
    ...item,
    gambarHero: item.gambarHero || "https://placehold.co/1200x800/e2e8f0/475569?text=Program+Keahlian",
  }));
});
</script>

<style lang="scss" scoped>
@use "../../../assets/styles/variables" as *;

.semua-jurusan-page {
  min-height: 100vh;
  background: #ffffff;
  padding: 4rem 0;
}

.semua-jurusan-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.semua-jurusan-header {
  margin-bottom: 3rem;
}

.semua-jurusan-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #b45309;
  margin-bottom: 0.5rem;
}

.semua-jurusan-title {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 2.8vw, 2.4rem);
  color: #0f172a;
  margin: 0;
}

.semua-jurusan-desc {
  font-size: 1rem;
  color: #475569;
  margin: 0.5rem 0 0;
  max-width: 600px;
}

.semua-jurusan-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .semua-jurusan-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .semua-jurusan-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }
}

.semua-jurusan-card {
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: #ffffff;
  transition: box-shadow 0.2s ease;
}

.semua-jurusan-card:hover {
  box-shadow: 0 16px 40px rgba(15, 23, 42, 0.08);
}

.semua-jurusan-img-wrap {
  position: relative;
  aspect-ratio: 4/3;
  overflow: hidden;
}

.semua-jurusan-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.semua-jurusan-badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  padding: 0.35rem 0.9rem;
  border-radius: 9999px;
  background: rgba(4, 45, 134, 0.9);
  color: #ffffff;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.02em;
  backdrop-filter: blur(4px);
}

.semua-jurusan-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  flex: 1;
}

.semua-jurusan-card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.semua-jurusan-icon {
  width: 2.25rem;
  height: 2.25rem;
  display: grid;
  place-items: center;
  border-radius: 0.75rem;
  background: #f1f5f9;
  color: #042d86;
  flex-shrink: 0;
}

.semua-jurusan-name {
  font-family: "Plus Jakarta Sans", system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.15rem;
  color: #0f172a;
  margin: 0;
}

.semua-jurusan-text {
  font-size: 0.95rem;
  color: #334155;
  line-height: 1.7;
  margin: 0;
}

.semua-jurusan-detail {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 0.65rem;
  border: 1px solid #042d86;
  color: #042d86;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.9rem;
  text-decoration: none;
  margin-top: auto;
  transition:
    background-color 0.2s,
    color 0.2s;
}

.semua-jurusan-detail:hover {
  background: #042d86;
  color: #ffffff;
}
</style>
