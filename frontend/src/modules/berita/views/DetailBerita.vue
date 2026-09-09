<template>
  <div class="detail-berita-page">
    <AnimateOnScroll animation="fadeInDown" v-if="artikelAktif">
      <div class="detail-berita-layout">
        <div class="detail-berita-main">
          <Breadcrumb :items="breadcrumbItems" />
          <ArtikelHeader :artikel="artikelAktif" />
          <AnimateOnScroll animation="scaleIn" :delay="100">
            <div class="detail-berita-img-wrap">
              <img
                :src="artikelAktif.gambarUtama"
                :alt="artikelAktif.judul"
                class="detail-berita-img"
                @error="artikelAktif.gambarUtama = 'https://placehold.co/1200x700/e2e8f0/475569?text=Berita'"
              />
            </div>
          </AnimateOnScroll>
          <AnimateOnScroll animation="fadeInUp" :delay="200">
            <KontenArtikel :konten="artikelAktif.konten" />
          </AnimateOnScroll>
          <AnimateOnScroll animation="fadeInUp" :delay="250">
            <TagsShareBar :tags="artikelAktif.tags" />
          </AnimateOnScroll>
        </div>
        <AnimateOnScroll animation="fadeInRight" :delay="300">
          <aside class="detail-berita-sidebar">
            <BeritaLainnya :items="beritaLainnya" />
            <div class="sidebar-spacer"></div>
            <CtaPpdb />
          </aside>
        </AnimateOnScroll>
      </div>
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="350" v-if="artikelAktif">
      <FooterSection />
    </AnimateOnScroll>

    <div v-if="!artikelAktif" class="detail-berita-empty">
      <p class="detail-berita-empty-text">Artikel tidak ditemukan.</p>
      <router-link to="/berita" class="detail-berita-back"
        >Kembali ke Semua Berita</router-link
      >
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch, watchEffect } from "vue";
import { useRoute } from "vue-router";
import { getNews, getNewsDetail } from "@/api/endpoints";
import { mapNews } from "../services/newsMapper";
import Breadcrumb from "../components/Breadcrumb.vue";
import ArtikelHeader from "../components/ArtikelHeader.vue";
import KontenArtikel from "../components/KontenArtikel.vue";
import TagsShareBar from "../components/TagsShareBar.vue";
import BeritaLainnya from "../components/BeritaLainnya.vue";
import CtaPpdb from "../components/CtaPpdb.vue";
import FooterSection from "../../portal/components/FooterSection.vue";
import AnimateOnScroll from "@/shared/components/AnimateOnScroll.vue";

const route = useRoute();

const artikelAktif = ref(null);
const beritaLainnya = ref([]);

const breadcrumbItems = computed(() => [
  { label: "Beranda", to: "/" },
  { label: "Berita", to: "/berita" },
  { label: artikelAktif.value?.judul || "Detail Berita" },
]);

async function loadArticle(slug) {
  artikelAktif.value = null;
  try {
    const [detailResponse, listResponse] = await Promise.allSettled([
      getNewsDetail(slug),
      getNews(1, 12),
    ]);

    if (
      detailResponse.status === "fulfilled" &&
      (detailResponse.value?.data?.data || detailResponse.value?.data)
    ) {
      artikelAktif.value = mapNews(
        detailResponse.value.data?.data || detailResponse.value.data,
      );
    }

    const articles =
      listResponse.status === "fulfilled"
        ? listResponse.value.data?.data?.data ||
          listResponse.value.data?.data ||
          []
        : [];

    // If detail failed, check if article is in list
    if (!artikelAktif.value && articles.length) {
      const match = articles.find(
        (a) => String(a.slug || a.id) === String(slug),
      );
      if (match) {
        artikelAktif.value = mapNews(match);
      }
    }

    beritaLainnya.value = articles
      .filter((item) => String(item.slug || item.id) !== String(slug))
      .slice(0, 3)
      .map(mapNews);
  } catch (e) {
    artikelAktif.value = null;
    beritaLainnya.value = [];
  }
}

watch(
  () => route.params.slug,
  (slug) => {
    loadArticle(slug);
    window.scrollTo({ top: 0, behavior: "smooth" });
  },
  { immediate: true },
);

watchEffect(() => {
  document.title = artikelAktif.value
    ? `${artikelAktif.value.judul} - SMK Nurul Jadid`
    : "Berita - SMK Nurul Jadid";
});
</script>

<style lang="scss" scoped>
.detail-berita-page {
  min-height: 100vh;
  background: #f8f7fb;
}

.detail-berita-layout {
  max-width: 84rem;
  margin: 0 auto;
  padding: 3rem 1.5rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
}

@media (min-width: 768px) {
  .detail-berita-layout {
    grid-template-columns: 1fr 300px;
    gap: 4rem;
    padding-top: 3rem;
  }
}

.detail-berita-main {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  min-width: 0;
}

.detail-berita-img-wrap {
  width: 100%;
  aspect-ratio: 16 / 10;
  border-radius: 1.25rem;
  overflow: hidden;
  margin-top: 2rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.detail-berita-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.detail-berita-sidebar {
  display: flex;
  flex-direction: column;
  gap: 3rem;
}

@media (max-width: 767px) {
  .detail-berita-sidebar {
    margin-top: 3rem;
  }
}

.detail-berita-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
  padding: 6rem 1rem;
  text-align: center;
  min-height: 60vh;
}

.detail-berita-empty-text {
  color: #64748b;
  font-size: 1.125rem;
  margin: 0;
}

.detail-berita-back {
  display: inline-flex;
  padding: 0.85rem 1.5rem;
  border-radius: 9999px;
  background: #1e3a5f;
  color: #ffffff;
  font-weight: 700;
  text-decoration: none;
  transition: background 0.2s ease;
}

.detail-berita-back:hover {
  background: #16264d;
}
</style>
