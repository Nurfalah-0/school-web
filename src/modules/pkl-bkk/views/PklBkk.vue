<template>
  <div class="pkl-page">
    <AnimateOnScroll animation="fadeInDown">
      <PklHero />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="100">
      <MitraIndustri />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="200">
      <PersiapanKarir />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <LowonganTerkini />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="400">
      <FormPendaftaran @submit-lamaran="handleSubmitLamaran" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="500">
      <TimelineSeleksi />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="600">
      <TracerAlumni />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="700">
      <FooterSection />
    </AnimateOnScroll>
  </div>
</template>

<script setup>
import PklHero from '../components/PklHero.vue';
import MitraIndustri from '../components/MitraIndustri.vue';
import PersiapanKarir from '../components/PersiapanKarir.vue';
import LowonganTerkini from '../components/LowonganTerkini.vue';
import FormPendaftaran from '../components/FormPendaftaran.vue';
import TimelineSeleksi from '../components/TimelineSeleksi.vue';
import TracerAlumni from '../components/TracerAlumni.vue';
import FooterSection from '../../portal/components/FooterSection.vue';
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue';

const handleSubmitLamaran = (payload) => {
  console.log('Lamaran submitted:', payload);
};
</script>

<style lang="scss" scoped>
.pkl-page {
  min-height: 100vh;
  background: #ffffff;
}
</style>
