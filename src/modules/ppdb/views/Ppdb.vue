<template>
  <div class="ppdb-page">
    <AnimateOnScroll animation="fadeInDown">
      <PpdbHero />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="100">
      <MengapaMemilihKami />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="200">
      <LangkahPendaftaran />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <JalurPendaftaran />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="400">
      <PersyaratanJadwal />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="500">
      <FormDanStatus @submit-pendaftaran="handleSubmitPendaftaran" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="600">
      <FooterSection />
    </AnimateOnScroll>
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
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue';

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
