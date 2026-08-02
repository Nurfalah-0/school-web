<template>
  <div class="page-shell">
    <TopNav />
    <HeroSection />
    <PartnersSection :partners="partners" />
    <InfoSection :highlights="highlights" />
    <JobSection :jobs="jobs" />
    <ApplySection
      :registrationPoints="registrationPoints"
      :form="form"
      :submitRegistration="submitRegistration"
      :isSubmitting="isSubmitting"
      :successMessage="successMessage"
      :errorMessage="errorMessage"
    />
    <TimelineSection :timeline="timeline" />
    <AlumniSection :metrics="metrics" />
    <FooterSection />
    <button class="chat-bot" aria-label="Buka asisten karier">?</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { registerApplicant } from '../../../api/endpoints';
import TopNav from '../components/TopNav.vue';
import HeroSection from '../components/HeroSection.vue';
import PartnersSection from '../components/PartnersSection.vue';
import InfoSection from '../components/InfoSection.vue';
import JobSection from '../components/JobSection.vue';
import ApplySection from '../components/ApplySection.vue';
import TimelineSection from '../components/TimelineSection.vue';
import AlumniSection from '../components/AlumniSection.vue';
import FooterSection from '../components/FooterSection.vue';

const partners = [
  { name: 'PT. Integra' },
  { name: 'Gajah Tunggal' },
  { name: 'Bank BRI' },
  { name: 'Astra' },
  { name: 'BCA' }
];

const highlights = [
  { title: 'Sertifikasi Kompetensi', text: 'Dapatkan sertifikat resmi dari mitra industri sesuai dengan program.' },
  { title: 'Akses Jalur Cepat', text: 'Siswa berprestasi saat PKL memiliki peluang 85% untuk langsung direkrut.' },
  { title: 'Mentoring Industri', text: 'Pendampingan intensif dari profesional selama 3-6 bulan masa praktik.' }
];

const jobs = [
  {
    title: 'Junior Network Engineer',
    company: 'PT Solusi Data Indonesia',
    type: 'PKL',
    details: ['Jurusan: Teknik Komputer', 'Lokasi: Jakarta', 'Allowance + Sertifikat']
  },
  {
    title: 'Maintenance Technician',
    company: 'United Tractors Tbk',
    type: 'PKL',
    details: ['Jurusan: Teknik Otomotif', 'Lokasi: Jawa Timur', 'Full-time / Magang']
  },
  {
    title: 'UI/UX Designer Apprentice',
    company: 'Glow Digital Studio',
    type: 'Full-time',
    details: ['Jurusan: Multimedia', 'Lokasi: Surabaya', 'Project-based']
  }
];

const registrationPoints = [
  'Verifikasi dokumen cepat',
  'Rekomendasi karier berbasis jurusan',
  'Pendampingan karier oleh tim BKK'
];

const timeline = [
  { step: '01', title: 'Pendaftaran', text: 'Pengumpulan data dan verifikasi administrasi.', duration: 'Jan - Feb' },
  { step: '02', title: 'Workshop & Pre-Test', text: 'Persiapan soft skill dan asesmen awal.', duration: 'Mar' },
  { step: '03', title: 'Wawancara Industri', text: 'Seleksi lapangan oleh mitra kerja.', duration: 'Apr - Mei' },
  { step: '04', title: 'Penempatan', text: 'Penugasan PKL dan pembinaan lanjutan.', duration: 'Jun - Jul' }
];

const metrics = [
  { label: 'Bekerja di industri (Nasional/Inter)', value: '65%' },
  { label: 'Melanjutkan ke Perguruan Tinggi', value: '25%' },
  { label: 'Wirausaha / Entrepreneur', value: '10%' }
];

const form = ref({
  name: '',
  email: '',
  nisn: '',
  program: 'Teknologi Informatika'
});

const isSubmitting = ref(false);
const successMessage = ref('');
const errorMessage = ref('');

const submitRegistration = async () => {
  isSubmitting.value = true;
  successMessage.value = '';
  errorMessage.value = '';
  try {
    const response = await registerApplicant(form.value);
    successMessage.value = response.data?.message || `Pendaftaran ${form.value.name} berhasil!`;
    form.value = { name: '', email: '', nisn: '', program: 'Teknologi Informatika' };
  } catch (error) {
    console.error('Gagal mengirim pendaftaran:', error);
    errorMessage.value = error.response?.data?.message || 'Gagal mengirim pendaftaran. Pastikan server backend berjalan.';
  } finally {
    isSubmitting.value = false;
  }
};
</script>
