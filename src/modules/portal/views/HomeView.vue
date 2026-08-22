<template>
  <div class="page-shell">
    <AnimateOnScroll animation="fadeInDown">
      <HeroSection />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="100">
      <ProfilSekolah />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="150">
      <MengapaKami />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="200">
      <PilihJalurKarir />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="250">
      <PrestasiMembanggakan />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="300">
      <TeachingFactory />
    </AnimateOnScroll>
    <AnimateOnScroll animation="scaleIn" :delay="350">
      <StatistikSekolah />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="400">
      <TestimoniAlumni />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="450">
      <BeritaKegiatan />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="500">
      <GaleriSekolah />
    </AnimateOnScroll>
    <AnimateOnScroll animation="fadeInUp" :delay="550">
      <FooterSection />
    </AnimateOnScroll>
    <button class="chat-bot" aria-label="Buka asisten karier">?</button>
  </div>
</template>

<script setup>
import HeroSection from '../components/HeroSection.vue';
import ProfilSekolah from '../components/ProfilSekolah.vue';
import MengapaKami from '../components/MengapaKami.vue';
import PilihJalurKarir from '../components/PilihJalurKarir.vue';
import PrestasiMembanggakan from '../components/PrestasiMembanggakan.vue';
import TeachingFactory from '../components/TeachingFactory.vue';
import StatistikSekolah from '../components/StatistikSekolah.vue';
import TestimoniAlumni from '../components/TestimoniAlumni.vue';
import BeritaKegiatan from '../components/BeritaKegiatan.vue';
import GaleriSekolah from '../components/GaleriSekolah.vue';
import FooterSection from '../components/FooterSection.vue';
import AnimateOnScroll from '@/shared/components/AnimateOnScroll.vue';
</script>
