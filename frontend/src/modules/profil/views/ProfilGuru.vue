<template>
  <div class="profil-guru-page">
    <section class="guru-hero">
      <div class="guru-hero-inner">
        <div class="guru-hero-left">
          <div class="guru-hero-shape"></div>
          <div class="guru-hero-photo-wrap">
            <img
              v-if="heroPhoto"
              :src="heroPhoto"
              alt="Foto Guru"
              class="guru-hero-photo"
            />
            <div v-else class="guru-hero-photo-placeholder">
              <UserRound :size="64" :color="varColorTextBody" />
            </div>
          </div>
        </div>
        <div class="guru-hero-right">
          <nav class="guru-breadcrumb">
            <ol class="guru-breadcrumb-list">
              <li v-for="(item, idx) in breadcrumbItems" :key="idx" class="guru-breadcrumb-item">
                <span
                  v-if="idx < breadcrumbItems.length - 1"
                  class="guru-breadcrumb-link"
                >{{ item }}</span>
                <span
                  v-else
                  class="guru-breadcrumb-current"
                >{{ item }}</span>
                <span
                  v-if="idx < breadcrumbItems.length - 1"
                  class="guru-breadcrumb-sep"
                >&gt;</span>
              </li>
            </ol>
          </nav>
          <h1 class="guru-hero-title">
            <span class="guru-hero-title-part">Profil</span>
            <span class="guru-hero-title-part accent">Guru</span>
          </h1>
          <p class="guru-hero-desc">
            Kami hadirkan profil lengkap para guru dan staf pendidik di SMK Nurul Jadid.
            Setiap individu memberikan kontribusi terbaik untuk mewujudkan visi misi
            sekolah. Temukan berbagai informasi mengenai latar belakang, keahlian,
            dan peran mereka dalam mendukung proses pembelajaran dan pengembangan
            sumber daya manusia yang berkualitas.
          </p>
          <button type="button" class="guru-hero-cta button-primary">
            <span>Hubungi Kami</span>
            <ArrowRight :size="18" />
          </button>
        </div>
      </div>
    </section>

    <section class="guru-featured-profile section">
      <div class="guru-section-inner">
        <div class="guru-profile-grid">
          <div class="guru-profile-left">
            <div class="guru-profile-frame">
              <img
                v-if="featuredGuru.photo"
                :src="featuredGuru.photo"
                :alt="featuredGuru.name"
                class="guru-profile-photo"
              />
              <div v-else class="guru-profile-photo-placeholder">
                <UserRound :size="56" :color="varColorTextBody" />
              </div>
            </div>
          </div>
          <div class="guru-profile-right">
            <span class="guru-profile-label">
              <span class="guru-profile-label-highlight">Kepala</span> Sekolah SMK Nurul Jadid
            </span>
            <h2 class="guru-profile-name">{{ featuredGuru.name }}</h2>
            <p class="guru-profile-bio">
              {{ featuredGuru.bio || defaultBio }}
            </p>
            <div class="guru-info-grid">
              <div
                v-for="(info, idx) in profileInfoList"
                :key="idx"
                class="guru-info-block"
              >
                <dt class="guru-info-label">{{ info.label }}</dt>
                <dd class="guru-info-value">{{ info.value }}</dd>
              </div>
            </div>
            <div class="guru-contact-block">
              <span class="guru-contact-label">Kontak Profesional</span>
              <div class="guru-contact-value">
                <span class="guru-contact-item">
                  <Mail :size="14" />
                  <span>{{ featuredGuru.email || 'guru@smknurjad.sch.id' }}</span>
                </span>
                <span class="guru-contact-item">
                  <Phone :size="14" />
                  <span>{{ featuredGuru.phone || '+62 335 771732' }}</span>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <SectionCarousel
      v-for="(cfg, idx) in carouselConfigs"
      :key="idx"
      :title="cfg.title"
      :subtitle="cfg.subtitle"
      :items="cfg.items"
      :current-index="currentIndices[idx]"
      @next="nextSlide(idx, cfg.items.length)"
      @prev="prevSlide(idx, cfg.items.length)"
      @goto="goToSlide(idx, $event, cfg.items.length)"
    />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import {
  ArrowRight,
  ChevronLeft,
  ChevronRight,
  UserRound,
  Mail,
  Phone,
} from 'lucide-vue-next';

import SectionCarousel from '../components/SectionCarousel.vue';

const varColorTextBody = 'var(--color-text-body, #475569)';

const props = defineProps({
  heroPhoto: {
    type: String,
    default: '',
  },
  featuredGuru: {
    type: Object,
    default: () => ({
      name: 'Dr. Ahmad Fahrul, S.Pd., M.Pd.',
      photo: '',
      email: 'ahmad.fahrul@smknurjad.sch.id',
      phone: '+62 812-3456-7890',
      bio: '',
      education: 'S2 Pendidikan Teknologi Informasi - Universitas Brawijaya',
      expertise: 'Pengembangan Kurikulum Berbasis Kompetensi',
      position: 'Kepala Sekolah',
      motto: 'Pendidikan adalah kunci pembuka pintu masa depan',
    }),
  },
});

const breadcrumbItems = computed(() => ['Beranda', 'Profil', 'Guru']);

const defaultBio =
  'Seorang profesional yang memiliki latar belakang kuat di bidang pendidikan dan pengabdian pada bangsa. ' +
  'Komitmennya demi memberikan pendidikan yang berkualitas, inovatif, dan berbasis karakter untuk menghasilkan ' +
  'generasi muda yang siap menghadapi tantangan zaman.';

const profileInfoList = computed(() => [
  { label: 'Pendidikan Terakhir', value: props.featuredGuru.education },
  { label: 'Bidang Keahlian', value: props.featuredGuru.expertise },
  { label: 'Jabatan/Posisi', value: props.featuredGuru.position },
  { label: 'Motto', value: props.featuredGuru.motto },
]);

const allCarouselItems = {
  wakilKepala: [
    { photo: '', name: 'Siti Rahayu, S.Pd.', position: 'Wakil Kepala Sekolah Bidang Kurikulum' },
    { photo: '', name: 'Budi Santoso, S.Kom.', position: 'Wakil Kepala Sekolah Bidang Sarana & Prasarana' },
    { photo: '', name: 'Rina Melati, S.Pd.I.', position: 'Wakil Kepala Sekolah Bidang Kesiswaan' },
    { photo: '', name: 'Andi Wijaya, S.E.', position: 'Wakil Kepala Sekolah Bidang Administrasi' },
    { photo: '', name: 'Dewi Lestari, S.Pd.', position: 'Koordinator Program Keahlian' },
    { photo: '', name: 'Heri Kurniawan, S.Pd.', position: 'Koordinator Ekstrakurikuler' },
  ],
  guruProduktif: [
    { photo: '', name: 'Rudi Hartono, S.Kom.', position: 'Guru Produktif Teknik Informatika' },
    { photo: '', name: 'Agus Prasetyo, S.T.', position: 'Guru Produktif Teknik Otomasi Industri' },
    { photo: '', name: 'Sari Wulandari, S.T.', position: 'Guru Produktif Teknik Elektronik' },
    { photo: '', name: 'Dian Puspitasari, S.Ak.', position: 'Guru Produktif Akuntansi' },
    { photo: '', name: 'Fajar Nugroho, S.P.', position: 'Guru Produktif Pemasaran' },
    { photo: '', name: 'Lina Kartini, S.Kom.', position: 'Guru Produktif Sistem Informasi' },
    { photo: '', name: 'Wahyu Setiawan, S.Pd.', position: 'Guru Produktif Rekayasa Perangkat Lunak' },
    { photo: '', name: 'Maya Sari, S.ST.', position: 'Guru Produktif Teknik Jaringan Komunikasi' },
  ],
  staff: [
    { photo: '', name: 'Nurul Fitri, S.Kep.', position: 'Staff Kesiswaan & Bimbingan Konseling' },
    { photo: '', name: 'Teguh Santoso, S.E.', position: 'Staff Bagian Keuangan' },
    { photo: '', name: 'Vina Marlina, S.Pd.', position: 'Staff Bagian Administrasi Umum' },
    { photo: '', name: 'Dedi Kurniawan, S.I.', position: 'Staff HRD & Kepegawaian' },
    { photo: '', name: 'Sinta Ayu, S.A.P.', position: 'Staff Perpustakaan' },
    { photo: '', name: 'Rifa'i, S.Kom.', position: 'Staff TI & Dukungan Akademik' },
    { photo: '', name: 'Yuni Lestari, S.Pd.', position: 'Staff Pengembangan Kurikulum' },
  ],
};

const currentIndices = ref([0, 0, 0]);

const carouselConfigs = computed(() => [
  {
    title: 'Wakil Kepala Sekolah',
    subtitle: 'Tim Manajemen Sekolah',
    items: allCarouselItems.wakilKepala,
  },
  {
    title: 'Guru Produktif & Non-Produktif',
    subtitle: 'Tenaga Pengajar',
    items: allCarouselItems.guruProduktif,
  },
  {
    title: 'Staff Pendukung Sekolah',
    subtitle: 'Staf Administrasi & Operasional',
    items: allCarouselItems.staff,
  },
]);

function nextSlide(idx, total) {
  currentIndices.value[idx] =
    currentIndices.value[idx] >= total - 1 ? 0 : currentIndices.value[idx] + 1;
}

function prevSlide(idx, total) {
  currentIndices.value[idx] =
    currentIndices.value[idx] <= 0
      ? total - 1
      : currentIndices.value[idx] - 1;
}

function goToSlide(idx, slideIdx, total) {
  if (slideIdx < 0) slideIdx = total - 1;
  if (slideIdx >= total) slideIdx = 0;
  currentIndices.value[idx] = slideIdx;
}
</script>

<style lang="scss" scoped>

.profil-guru-page {
  min-height: calc(100vh - var(--nav-height, 64px));
  width: 100%;
  overflow-x: clip;
  background: var(--color-bg-page, #f8f7fb);
  color: var(--color-text-body, #475569);
}

.guru-hero {
  background: var(--bg-section-hero, #ffffff);
  padding: 5rem 0;
}

.guru-hero-inner {
  width: min(1200px, calc(100% - 2rem));
  margin: 0 auto;
  display: grid;
  grid-template-columns: 0.9fr 1.1fr;
  gap: 3rem;
  align-items: center;
}

.guru-hero-left {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 380px;
}

.guru-hero-shape {
  position: absolute;
  width: 280px;
  height: 360px;
  border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
  background: var(--color-shape-accent, #e0e7ff);
  filter: blur(0);
  transform: rotate(-15deg);
  z-index: 0;
}

.guru-hero-photo-wrap {
  position: relative;
  z-index: 1;
  width: 240px;
  height: 320px;
  border-radius: 1.5rem;
  overflow: hidden;
  box-shadow: 0 25px 60px rgba(15, 23, 42, 0.1);
}

.guru-hero-photo,
.guru-hero-photo-placeholder {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-border-light, #e2e8f0);
}

.guru-hero-right {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.guru-hero-cta {
  align-self: flex-start;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.8rem 1.75rem;
  border-radius: 9999px;
  border: none;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: opacity 0.2s ease, transform 0.2s ease;

  &:hover {
    opacity: 0.9;
    transform: translateY(-1px);
  }
}

.guru-hero-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(2rem, 3.5vw, 3rem);
  line-height: 1.1;
  margin: 0;
  color: var(--color-text-heading, #0f172a);

  &-part {
    display: inline-block;
  }

  &-part.accent {
    color: var(--color-primary, #2563eb);
  }
}

.guru-hero-desc {
  font-size: 1.05rem;
  line-height: 1.8;
  margin: 0;
  max-width: 42rem;
}

.guru-breadcrumb {
  padding: 0.5rem 0;
}

.guru-breadcrumb-list {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.4rem;
  list-style: none;
  margin: 0;
  padding: 0;
  font-size: 0.85rem;
}

.guru-breadcrumb-item {
  display: inline-flex;
  align-items: center;
}

.guru-breadcrumb-link {
  color: var(--color-text-muted, #94a3b8);
  text-decoration: none;
}

.guru-breadcrumb-current {
  color: var(--color-text-heading, #0f172a);
  font-weight: 600;
}

.guru-breadcrumb-sep {
  color: var(--color-border, #cbd5e1);
}

/* Section 2: Featured Profile */
.guru-featured-profile {
  padding: 5rem 0;
}

.guru-section-inner {
  width: min(1200px, calc(100% - 2rem));
  margin: 0 auto;
}

.guru-profile-grid {
  display: grid;
  grid-template-columns: 0.6fr 1.1fr;
  gap: 3rem;
  align-items: start;
}

.guru-profile-left {
  display: flex;
  justify-content: center;
  min-width: 0;
}

.guru-profile-frame {
  position: relative;
  padding: 1.25rem;
  border: 2px dashed var(--color-border, #cbd5e1);
  border-radius: 1.5rem;
  width: fit-content;
}

.guru-profile-photo,
.guru-profile-photo-placeholder {
  width: 220px;
  height: 280px;
  object-fit: cover;
  border-radius: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-border-light, #e2e8f0);
}

.guru-profile-right {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.guru-profile-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1rem;
  color: var(--color-text-muted, #94a3b8);

  &-highlight {
    color: var(--color-primary, #2563eb);
  }
}

.guru-profile-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.5rem, 2.5vw, 2rem);
  color: var(--color-text-heading, #0f172a);
  margin: 0;
}

.guru-profile-bio {
  font-size: 1.05rem;
  line-height: 1.8;
  margin: 0;
}

.guru-info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
}

.guru-info-block {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.guru-info-label {
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08rem;
  color: var(--color-text-muted, #94a3b8);
  margin: 0;
}

.guru-info-value {
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--color-text-body, #334155);
  margin: 0;
}

.guru-contact-block {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding-top: 1rem;
  border-top: 1px solid var(--color-border, #e2e8f0);
}

.guru-contact-label {
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08rem;
  color: var(--color-text-muted, #94a3b8);
}

.guru-contact-value {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.guru-contact-item {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.95rem;
  color: var(--color-text-body, #334155);
}

/* Carousel */
.guru-carousel-section {
  padding: 4rem 0;

  &:not(:last-child) {
    border-bottom: 1px solid var(--color-border, #e2e8f0);
  }
}

.guru-carousel-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.guru-carousel-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.6rem, 2.5vw, 2.2rem);
  color: var(--color-text-heading, #0f172a);
  margin: 0;
}

.guru-carousel-subtitle {
  font-size: 0.95rem;
  color: var(--color-text-muted, #94a3b8);
  margin: 0.4rem 0 0;
}

.guru-carousel-container {
  position: relative;
  width: 100%;
}

.guru-carousel-track {
  display: flex;
  gap: 1.5rem;
  transition: transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  will-change: transform;
}

.guru-carousel-card {
  flex: 0 0 calc((100% - 3rem) / 4);
  position: relative;
  aspect-ratio: 3 / 4;
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
}

.guru-carousel-card-placeholder {
  width: 100%;
  height: 100%;
  background: var(--color-border-light, #e2e8f0);
  display: grid;
  place-items: center;
  color: var(--color-text-muted, #94a3b8);
}

.guru-card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.guru-card-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 1.25rem 1rem 1rem;
  background: var(--color-overlay-bg, rgba(15, 23, 42, 0.72));
  color: var(--color-overlay-text, #ffffff);
}

.guru-card-name {
  font-weight: 700;
  font-size: 0.95rem;
  margin: 0;
  line-height: 1.3;
}

.guru-card-position {
  font-size: 0.78rem;
  opacity: 0.85;
  margin: 0.15rem 0 0;
  line-height: 1.3;
}

.guru-carousel-nav {
  margin-top: 1.75rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.guru-nav-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  border-radius: 9999px;
  border: 1px solid var(--color-border, #cbd5e1);
  background: var(--color-bg-card, #ffffff);
  color: var(--color-text-body, #334155);
  cursor: pointer;
  transition: background 0.2s ease, color 0.2s ease;

  &:hover {
    background: var(--color-primary, #2563eb);
    color: var(--color-text-on-primary, #ffffff);
    border-color: var(--color-primary, #2563eb);
  }
}

.guru-dots {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  flex: 1;
}

.guru-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--color-border, #cbd5e1);
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    background: var(--color-primary, #2563eb);
  }
}

.guru-dot.active {
  width: 16px;
  background: var(--color-primary, #2563eb);
}

/* Responsive */
@media (max-width: 768px) {
  .guru-hero-inner {
    grid-template-columns: 1fr;
    text-align: center;
  }

  .guru-hero-left {
    min-height: 280px;
  }

  .guru-hero-shape {
    width: 180px;
    height: 240px;
  }

  .guru-hero-photo-wrap {
    width: 180px;
    height: 240px;
  }

  .guru-hero-right {
    align-items: center;
  }

  .guru-hero-cta {
    align-self: center;
  }

  .guru-profile-grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .guru-info-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .guru-carousel-card {
    flex: 0 0 50%;
    max-width: 50%;
  }

  .guru-carousel-track {
    gap: 1rem;
  }
}

@media (max-width: 600px) {
  .guru-carousel-card {
    flex: 0 0 80%;
    max-width: 80%;
  }
}
</style>
