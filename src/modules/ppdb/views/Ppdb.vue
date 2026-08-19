<template>
  <div class="ppdb-page">
    <PpdbHero />
    <MengapaMemilihKami />
    <LangkahPendaftaran />
    <JalurPendaftaran />
    <PersyaratanJadwal />
    <FormDanStatus @submit-pendaftaran="handleSubmitPendaftaran" />
    <FooterSection />
  </div>
</template>

<script setup>
import PpdbHero from '../components/PpdbHero.vue';
import MengapaMemilihKami from '../components/MengapaMemilihKami.vue';
import LangkahPendaftaran from '../components/LangkahPendaftaran.vue';
import JalurPendaftaran from '../components/JalurPendaftaran.vue';
import PersyaratanJadwal from '../components/PersyaratanJadwal.vue';
import FormDanStatus from '../components/FormDanStatus.vue';
import FooterSection from '../../portal/components/FooterSection.vue';

const handleSubmitPendaftaran = (payload) => {
  console.log('Pendaftaran submitted:', payload);
};
</script>

<style lang="scss" scoped>
.ppdb-page {
  min-height: 100vh;
  background: #ffffff;
}
</style>
