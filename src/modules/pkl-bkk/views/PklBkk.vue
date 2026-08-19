<template>
  <div class="pkl-page">
    <PklHero />
    <MitraIndustri />
    <PersiapanKarir />
    <LowonganTerkini />
    <FormPendaftaran @submit-lamaran="handleSubmitLamaran" />
    <TimelineSeleksi />
    <TracerAlumni />
    <FooterSection />
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
