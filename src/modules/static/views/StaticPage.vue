<template>
  <div class="static-page">
    <div class="static-inner">
      <h1 class="static-title">{{ pageData.title }}</h1>
      <div class="static-body" v-html="pageData.content"></div>
    </div>
    <FooterSection />
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import FooterSection from '../../portal/components/FooterSection.vue';

const route = useRoute();

const pageData = computed(() => {
  const path = route.path;
  const pages = {
    '/support': {
      title: 'Support',
      content: '<p>Untuk mendapatkan bantuan, Anda dapat menghubungi kami melalui WhatsApp di <strong>+62 812-5907-5405</strong> atau email di <strong>smknurja.paiton@gmail.com</strong>. Tim kami siap membantu Anda Senin - Jumat, 08.00 - 16.00 WIB.</p>'
    },
    '/portal-guide': {
      title: 'Portal Guide',
      content: '<p>Portal ini menyediakan informasi lengkap seputar SMK Nurul Jadid. Anda dapat mengeksplorasi program keahlian, melihat prestasi siswa, mencari lowongan kerja, dan melakukan pendaftaran PPDB secara online.</p>'
    },
    '/admin/contact': {
      title: 'Contact Admin',
      content: '<p>Hubungi tim administrasi SMK Nurul Jadid untuk pertanyaan seputar pendaftaran, kemitraan industri, atau informasi umum.</p><p><strong>WhatsApp:</strong> +62 812-5907-5405<br><strong>Email:</strong> smknurja.paiton@gmail.com<br><strong>Alamat:</strong> Jl. KH. Zaini Mun\'im, Paiton, Probolinggo, Jawa Timur</p>'
    },
    '/privacy': {
      title: 'Privacy Policy',
      content: '<p>Kami menghormati privasi Anda. Data yang Anda berikan akan digunakan hanya untuk keperluan pendaftaran dan komunikasi resmi sekolah. Data tidak akan dibagikan kepada pihak ketiga tanpa persetujuan Anda.</p>'
    },
    '/terms': {
      title: 'Terms of Service',
      content: '<p>Dengan menggunakan portal ini, Anda setuju untuk menggunakan layanan dengan baik dan tidak menyalahgunakan sistem. SMK Nurul Jadid berhak mengubah ketentuan ini sewaktu-waktu.</p>'
    },
    '/security': {
      title: 'Security',
      content: '<p>Keamanan data Anda adalah prioritas kami. Semua transmisi data dienkripsi dan disimpan dengan aman. Jika Anda menemukan kerentanan keamanan, silakan laporkan ke tim IT kami.</p>'
    }
  };
  return pages[path] || { title: 'Halaman Tidak Ditemukan', content: '<p>Halaman yang Anda cari tidak tersedia.</p>' };
});
</script>

<style lang="scss" scoped>
.static-page {
  min-height: 100vh;
  background: #f8f7fb;
}

.static-inner {
  max-width: 800px;
  margin: 0 auto;
  padding: 4rem 1.5rem;
}

.static-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 900;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 2rem;
}

.static-body {
  background: #ffffff;
  border-radius: 1.5rem;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
  line-height: 1.8;
  color: #334155;
}
</style>
