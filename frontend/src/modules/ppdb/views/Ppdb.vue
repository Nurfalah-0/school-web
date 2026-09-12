<template>
  <div class="ppdb-page">
    <AnimateOnScroll animation="fadeInDown">
      <PpdbHero :schedule="schedule" :loading="scheduleLoading" />
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
      <FormDanStatus :schedule="schedule" @submit-pendaftaran="handleSubmitPendaftaran" />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="600">
      <FooterSection />
    </AnimateOnScroll>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { getPpdbSchedule } from '../../../api/endpoints';
import PpdbHero from '../components/PpdbHero.vue';
import MengapaMemilihKami from '../components/MengapaMemilihKami.vue';
import LangkahPendaftaran from '../components/LangkahPendaftaran.vue';
import JalurPendaftaran from '../components/JalurPendaftaran.vue';
import PersyaratanJadwal from '../components/PersyaratanJadwal.vue';
import FormDanStatus from '../components/FormDanStatus.vue';
import FooterSection from '../../portal/components/FooterSection.vue';
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue';

const schedule = ref({ registration_start: null, registration_end: null, is_open: true });
const scheduleLoading = ref(true);

const handleSubmitPendaftaran = (payload) => {
  console.log('Pendaftaran submitted:', payload);
};

onMounted(async () => {
  try {
    const response = await getPpdbSchedule();
    schedule.value = response.data?.data || schedule.value;
  } catch (error) {
    // Keep the existing open state when the schedule service is unavailable.
  } finally {
    scheduleLoading.value = false;
  }
});
</script>

<style lang="scss" scoped>
.ppdb-page {
  min-height: 100vh;
  background: #ffffff;
}
</style>
