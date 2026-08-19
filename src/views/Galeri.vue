<template>
  <div class="galeri-page">
    <GaleriHero />
    <FilterGaleri :aktif="kategoriAktif" @update:kategori="ubahFilter" />
    <GridGaleri :items="dataDitampilkan" @open="bukaLightbox" />
    <LoadMoreButton v-if="visibleCount < hasilFilter.length" @click="visibleCount += 9" />

    <LightboxGaleri
      v-if="lightboxIndex !== null"
      :item="hasilFilter[lightboxIndex]"
      :has-prev="lightboxIndex > 0"
      :has-next="lightboxIndex < hasilFilter.length - 1"
      @close="tutupLightbox"
      @prev="fotoSebelumnya"
      @next="fotoBerikutnya"
    />

    <FooterSection />
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { getAllGaleri, getKategoriList } from '@/data/galeri';
import GaleriHero from '@/components/galeri/GaleriHero.vue';
import FilterGaleri from '@/components/galeri/FilterGaleri.vue';
import GridGaleri from '@/components/galeri/GridGaleri.vue';
import LightboxGaleri from '@/components/galeri/LightboxGaleri.vue';
import LoadMoreButton from '@/components/galeri/LoadMoreButton.vue';
import FooterSection from '@/modules/portal/components/FooterSection.vue';

const route = useRoute();
const router = useRouter();

const kategoriAktif = ref(route.query.kategori || 'semua');
const visibleCount = ref(9);
const lightboxIndex = ref(null);

const hasilFilter = computed(() => {
  const semua = getAllGaleri();
  return kategoriAktif.value === 'semua'
    ? semua
    : semua.filter(g => g.kategori === kategoriAktif.value);
});

const dataDitampilkan = computed(() => hasilFilter.value.slice(0, visibleCount.value));

function ubahFilter(kategori) {
  kategoriAktif.value = kategori;
  visibleCount.value = 9;
  router.replace({ query: kategori === 'semua' ? {} : { kategori } });
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
</script>

<style lang="scss" scoped>
.galeri-page {
  background: #f8fafc;
  min-height: 100vh;
}
</style>
