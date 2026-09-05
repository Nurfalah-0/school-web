<template>
  <div class="galeri-page">
    <AnimateOnScroll animation="fadeInDown">
      <GaleriHero />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="100">
      <FilterGaleri
        :aktif="kategoriAktif"
        @update:kategori="ubahFilter"
        @update:search="ubahSearch"
      />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="200">
      <GridGaleri :items="dataDitampilkan" @open="bukaLightbox" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <LoadMoreButton v-if="visibleCount < hasilFilter.length" @click="visibleCount += 9" />
    </AnimateOnScroll>

    <LightboxGaleri
      v-if="lightboxIndex !== null"
      :item="hasilFilter[lightboxIndex]"
      :has-prev="lightboxIndex > 0"
      :has-next="lightboxIndex < hasilFilter.length - 1"
      :current-index="lightboxIndex"
      :total="hasilFilter.length"
      @close="tutupLightbox"
      @prev="fotoSebelumnya"
      @next="fotoBerikutnya"
    />

    <AnimateOnScroll animation="fadeInUp" :delay="400">
      <FooterSection />
    </AnimateOnScroll>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { getPublicContent } from '@/api/endpoints';
import { mapGallery } from '@/modules/contentMapper';
import GaleriHero from '@/components/galeri/GaleriHero.vue';
import FilterGaleri from '@/components/galeri/FilterGaleri.vue';
import GridGaleri from '@/components/galeri/GridGaleri.vue';
import LightboxGaleri from '@/components/galeri/LightboxGaleri.vue';
import LoadMoreButton from '@/components/galeri/LoadMoreButton.vue';
import FooterSection from '@/modules/portal/components/FooterSection.vue';
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue';

const route = useRoute();
const router = useRouter();

const kategoriAktif = ref(route.query.kategori || 'semua');
const searchQuery = ref('');
const visibleCount = ref(9);
const lightboxIndex = ref(null);
const galeriItems = ref([]);

const hasilFilter = computed(() => {
  let items = galeriItems.value;

  // Filter kategori
  if (kategoriAktif.value !== 'semua') {
    items = items.filter(g => g.kategori === kategoriAktif.value);
  }

  // Filter search
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.trim().toLowerCase();
    items = items.filter(g => g.judul?.toLowerCase().includes(q));
  }

  return items;
});

const dataDitampilkan = computed(() => hasilFilter.value.slice(0, visibleCount.value));

function ubahFilter(kategori) {
  kategoriAktif.value = kategori;
  visibleCount.value = 9;
  router.replace({ query: kategori === 'semua' ? {} : { kategori } });
}

function ubahSearch(q) {
  searchQuery.value = q;
  visibleCount.value = 9;
}

function bukaLightbox(item) {
  lightboxIndex.value = hasilFilter.value.findIndex(g => g.id === item.id);
}

function tutupLightbox() { lightboxIndex.value = null; }
function fotoBerikutnya() {
  if (lightboxIndex.value < hasilFilter.value.length - 1) lightboxIndex.value++;
}
function fotoSebelumnya() {
  if (lightboxIndex.value > 0) lightboxIndex.value--;
}

watch(() => route.query.kategori, (val) => {
  kategoriAktif.value = val || 'semua';
});

onMounted(async () => {
  try {
    const response = await getPublicContent('galleries');
    galeriItems.value = (response.data?.data || []).map(mapGallery);
  } catch (e) {
    galeriItems.value = [];
  }
});
</script>

<style lang="scss" scoped>
.galeri-page {
  background: #f8fafc;
  min-height: 100vh;
}
</style>
