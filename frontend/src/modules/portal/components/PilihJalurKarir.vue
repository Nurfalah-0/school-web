<template>
  <section class="pilih-jalur">
    <div class="pilih-jalur-inner">
      <div class="pilih-jalur-header">
        <div>
          <span class="pilih-jalur-label">{{ label }}</span>
          <h2 class="pilih-jalur-title">{{ title }}</h2>
        </div>
        <router-link to="/jurusan" class="pilih-jalur-btn">{{
          seeAllText
        }}</router-link>
      </div>

      <div class="pilih-jalur-grid">
        <div v-for="card in programs" :key="card.slug" class="pilih-jalur-card">
          <div class="pilih-jalur-img-wrap">
            <img
              :src="card.gambarHero"
              :alt="`Siswa praktik jurusan ${card.nama}`"
              class="pilih-jalur-img"
              loading="lazy"
            />
            <span class="pilih-jalur-badge">{{ card.kategori }}</span>
          </div>
          <div class="pilih-jalur-body">
            <div class="pilih-jalur-card-header">
              <span class="pilih-jalur-icon">
                <component
                  :is="iconMap[card.icon]"
                  :size="20"
                  color="#042d86"
                />
              </span>
              <h3 class="pilih-jalur-name">{{ card.nama }}</h3>
            </div>
            <p class="pilih-jalur-text">{{ card.deskripsi }}</p>
            <router-link
              :to="`/jurusan/${card.slug}`"
              class="pilih-jalur-detail"
              >Detail Jurusan</router-link
            >
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { onMounted, ref } from "vue";
import {
  CodeXml,
  Briefcase,
  Network,
  Palette,
  Calculator,
} from "lucide-vue-next";
import { getMajors } from "@/api/endpoints";
import { jurusanList as fallbackJurusanList } from "@/data/jurusan";

const iconMap = {
  CodeXml,
  Briefcase,
  Network,
  Palette,
  Calculator,
};

const programs = ref([]);
const API_BASE = (import.meta.env.VITE_API_URL || "http://localhost:8000/api").replace(/\/api\/?$/, "");

const normalizeImageUrl = (value) => {
  if (!value) return "";
  if (value.startsWith("http://") || value.startsWith("https://")) return value;
  if (value.startsWith("/storage/")) return `${API_BASE}${value}`;
  return value;
};

onMounted(async () => {
  try {
    const response = await getMajors();
    const items = response.data?.data || [];

    if (items.length > 0) {
      programs.value = items.slice(0, 3).map((item) => {
        const fallback = fallbackJurusanList.find((entry) => entry.slug === item.slug) || {};

        return {
          ...fallback,
          ...item,
          slug: item.slug || fallback.slug,
          nama: item.name || fallback.nama,
          kategori: item.code || fallback.kategori,
          deskripsi: item.description || fallback.deskripsi || "Program keahlian SMK Nurul Jadid.",
          gambarHero: normalizeImageUrl(item.image) || fallback.gambarHero || "https://placehold.co/1200x800/e2e8f0/475569?text=Program+Keahlian",
          icon: fallback.icon || "CodeXml",
        };
      });
      return;
    }
  } catch (error) {
    console.warn("Gagal memuat jurusan API, fallback ke data dummy:", error);
  }

  programs.value = fallbackJurusanList.slice(0, 3).map((item) => ({
    ...item,
    gambarHero: item.gambarHero || "https://placehold.co/1200x800/e2e8f0/475569?text=Program+Keahlian",
  }));
});

defineProps({
  label: {
    type: String,
    default: "PROGRAM KEAHLIAN",
  },
  title: {
    type: String,
    default: "Pilih Jalur Karirmu",
  },
  seeAllText: {
    type: String,
    default: "Lihat Semua Jurusan",
  },
});
</script>

<style lang="scss" scoped>
@use "../../../assets/styles/variables" as *;

.pilih-jalur {
  background: #ffffff;
  padding: 5rem 0;
}

.pilih-jalur-inner {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
}

.pilih-jalur-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1.5rem;
  margin-bottom: 3rem;
  flex-wrap: wrap;
}

.pilih-jalur-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #b45309;
  margin-bottom: 0.5rem;
}

.pilih-jalur-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.8rem, 2.8vw, 2.4rem);
  color: #0f172a;
  margin: 0;
}

.pilih-jalur-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  background: #042d86;
  color: #ffffff;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  white-space: nowrap;
  flex-shrink: 0;
}

.pilih-jalur-btn:hover {
  background: #032263;
}

.pilih-jalur-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 640px) {
  .pilih-jalur-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .pilih-jalur-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }
}

.pilih-jalur-card {
  border: 1px solid #e2e8f0;
  border-radius: 1rem;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: #ffffff;
}

.pilih-jalur-img-wrap {
  position: relative;
  aspect-ratio: 4/3;
  overflow: hidden;
}

.pilih-jalur-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.pilih-jalur-badge {
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

.pilih-jalur-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  flex: 1;
}

.pilih-jalur-card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.pilih-jalur-icon {
  width: 2.25rem;
  height: 2.25rem;
  display: grid;
  place-items: center;
  border-radius: 0.75rem;
  background: #f1f5f9;
  color: #042d86;
  flex-shrink: 0;
}

.pilih-jalur-name {
  font-family: $font-display;
  font-weight: 800;
  font-size: 1.35rem;
  color: #0f172a;
  margin: 0;
}

.pilih-jalur-text {
  font-size: 0.95rem;
  color: #334155;
  line-height: 1.7;
  margin: 0;
}

.pilih-jalur-detail {
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

.pilih-jalur-detail:hover {
  background: #042d86;
  color: #ffffff;
}
</style>
