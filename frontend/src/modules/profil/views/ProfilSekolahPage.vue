<template>
  <div class="profil-page">
    <main class="profil-content">
      <section id="profil-sekolah" class="hero-box section-anchor">
        <div class="hero-image-wrap">
          <img
            v-if="schoolImage"
            :src="schoolImage"
            :alt="`Foto ${schoolName}`"
            class="hero-image"
            loading="lazy"
          />
          <span v-else class="image-empty">Gambar profil belum diupload</span>
        </div>

        <div class="hero-copy">
          <p class="eyebrow">Profil Sekolah</p>
          <h1>{{ profileTitle }}</h1>
          <p class="lead">{{ profileDescription }}</p>

          <div class="detail-copy" v-if="schoolProfile.profile_page_content">
            <p>{{ schoolProfile.profile_page_content }}</p>
          </div>
        </div>
      </section>

      <section id="visi-misi" class="vision-mission-section section-anchor">
        <div class="section-header">
          <p class="eyebrow">Visi &amp; Misi</p>
          <h2>{{ schoolName }}</h2>
          <p class="section-intro">
            {{ schoolProfile.vision_page_intro || schoolProfile.profile_description || 'Komitmen kami menyiapkan lulusan yang beriman, cakap, dan siap menghadapi tantangan masa depan.' }}
          </p>
        </div>

        <div class="content-grid">
          <article class="content-card">
            <div class="image-panel">
              <img v-if="visionImage" :src="visionImage" alt="Visi sekolah" loading="lazy" />
              <span v-else class="image-empty">Gambar visi belum diupload</span>
            </div>
            <div class="text-panel">
              <span class="badge">Visi</span>
              <h3>Visi Sekolah</h3>
              <p>{{ schoolProfile.vision_page_content || schoolProfile.vision || defaultVision }}</p>
            </div>
          </article>

          <article class="content-card mission-card">
            <div class="image-panel lower-panel">
              <img v-if="missionImage" :src="missionImage" alt="Misi sekolah" loading="lazy" />
              <span v-else class="image-empty">Gambar misi belum diupload</span>
            </div>
            <div class="text-panel">
              <span class="badge">Misi</span>
              <h3>Misi Sekolah</h3>
              <div class="mission-list" v-if="missionList.length">
                <div v-for="(item, index) in missionList" :key="index" class="mission-item">
                  <span class="mission-number">{{ index + 1 }}</span>
                  <p>{{ item }}</p>
                </div>
              </div>
              <p v-else>{{ schoolProfile.mission_page_content || schoolProfile.mission || defaultMission }}</p>
            </div>
          </article>
        </div>
      </section>
    </main>

    <FooterSection />
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { getSchoolProfile } from '@/api/endpoints';
import { useSiteImages } from '@/composables/useSiteImages';
import FooterSection from '../../portal/components/FooterSection.vue';

const { getImageByKey, getImageUrl, fetchImages } = useSiteImages();
const schoolProfile = ref({});

const defaultVision = 'Menjadi sekolah unggulan yang menghasilkan lulusan berkompeten, berakhlak mulia, dan mampu bersaing di era global.';
const defaultMission = 'Menyelenggarakan pendidikan yang berkualitas, mengembangkan potensi siswa, dan membangun karakter yang berakhlak mulia.';

const sanitizeSchoolName = (value) => {
  if (!value || typeof value !== 'string') return 'SMK Nurul Jadid';
  return value.replace(/\s*\(\s*SMKNJ\s*\)\s*$/i, '').trim() || 'SMK Nurul Jadid';
};

const schoolName = computed(() => sanitizeSchoolName(schoolProfile.value.school_name));
const profileTitle = computed(
  () =>
    sanitizeSchoolName(schoolProfile.value.profile_page_title || schoolProfile.value.profile_title_line1) ||
    schoolName.value
);
const profileDescription = computed(
  () =>
    schoolProfile.value.profile_description ||
    'SMK Nurul Jadid adalah lembaga pendidikan vokasi yang mengintegrasikan nilai karakter, keunggulan akademik, dan kesiapan kerja di era industri.'
);
const schoolImage = computed(() => {
  const image = getImageByKey('school_profile_image');
  return getImageUrl(image);
});

const visionImage = computed(() => {
  const image = getImageByKey('vision_image');
  return getImageUrl(image);
});

const missionImage = computed(() => {
  const image = getImageByKey('mission_image');
  return getImageUrl(image);
});

const missionList = computed(() => {
  const missionText = schoolProfile.value.mission_page_content || schoolProfile.value.mission || defaultMission;
  if (!missionText) return [];

  const normalizedText = missionText.replace(/\r\n?/g, '\n').trim();
  const numberedItems = [...normalizedText.matchAll(/(?:^|\s)\d+\.\s+([\s\S]*?)(?=\s+\d+\.\s+|$)/g)]
    .map((match) => match[1].replace(/\s*\n\s*/g, ' ').trim())
    .filter(Boolean);

  if (numberedItems.length) return numberedItems;

  return normalizedText
    .split(/\n\s*(?=[-•]\s*)/)
    .map((item) => item.replace(/^\s*[-•]\s*/, '').replace(/\s*\n\s*/g, ' ').trim())
    .filter(Boolean);
});

onMounted(async () => {
  await fetchImages();

  try {
    const response = await getSchoolProfile();
    schoolProfile.value = response.data?.data || {};
  } catch (error) {
    console.warn('Gagal memuat profil sekolah:', error);
  }
});
</script>

<style scoped>
.profil-page {
  min-height: calc(100vh - var(--nav-height, 60px));
  width: 100%;
  overflow-x: clip;
  background: linear-gradient(180deg, #f8fafc 0%, #eef6ff 100%);
}

.profil-content {
  padding: 4rem 1.25rem 5rem;
}

.section-anchor {
  scroll-margin-top: 100px;
}

.hero-box,
.vision-mission-section {
  width: min(1180px, 100%);
  margin: 0 auto;
}

.hero-box {
  display: grid;
  grid-template-columns: 1.1fr 1.2fr;
  gap: 2.25rem;
  align-items: stretch;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: 2rem;
  padding: 2rem;
  box-shadow: 0 35px 80px rgba(15, 23, 42, 0.08);
}

.vision-mission-section {
  margin-top: 2.5rem;
  background: transparent;
}

.section-header {
  margin-bottom: 1.5rem;
  padding: 1.5rem 1rem 0;
}

.eyebrow {
  margin: 0;
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.18rem;
  text-transform: uppercase;
  color: #2563eb;
}

h1,
h2,
h3 {
  margin: 0;
  color: #0f172a;
}

h1 {
  font-size: clamp(2rem, 3vw, 3.25rem);
  line-height: 1.1;
}

h2 {
  font-size: clamp(1.8rem, 2vw, 2.6rem);
}

h3 {
  font-size: clamp(1.5rem, 2vw, 2rem);
}

.lead,
.section-intro,
.text-panel p,
.mission-item p {
  margin: 0;
  line-height: 1.9;
  color: #475569;
}

.lead {
  font-size: 1.04rem;
}

.hero-copy {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.detail-copy {
  background: #f8fafc;
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 1rem;
  padding: 1rem 1.1rem;
}

.hero-image-wrap,
.image-panel {
  overflow: hidden;
  border-radius: 1.5rem;
  min-height: 420px;
  background: #dfeafc;
  height: 100%;
}

.hero-image,
.image-panel img {
  width: 100%;
  height: 100%;
  min-height: 420px;
  object-fit: cover;
  display: block;
}

.image-empty {
  display: grid;
  place-items: center;
  height: 100%;
  min-height: 420px;
  padding: 2rem;
  color: #64748b;
  text-align: center;
  font-weight: 700;
}

.content-grid {
  display: grid;
  gap: 2rem;
}

.content-card {
  display: grid;
  grid-template-columns: 1.1fr 1.15fr;
  gap: 2rem;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 2rem;
  padding: 1.5rem;
  box-shadow: 0 25px 60px rgba(15, 23, 42, 0.06);
}

.mission-card {
  grid-template-columns: 1.15fr 1.1fr;
}

.lower-panel {
  order: 2;
}

.text-panel {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 0.85rem;
  padding: 0.5rem 0;
}

.badge {
  display: inline-flex;
  width: fit-content;
  padding: 0.45rem 0.8rem;
  border-radius: 999px;
  background: #dbeafe;
  color: #1d4ed8;
  font-size: 0.76rem;
  font-weight: 800;
  letter-spacing: 0.08rem;
  text-transform: uppercase;
}

.mission-list {
  display: grid;
  gap: 0.8rem;
}

.mission-item {
  display: flex;
  align-items: flex-start;
  gap: 0.8rem;
  padding: 0.9rem 1rem;
  background: #f8fafc;
  border-radius: 1rem;
  border: 1px solid rgba(148, 163, 184, 0.14);
}

.mission-number {
  flex-shrink: 0;
  display: inline-grid;
  place-items: center;
  width: 2rem;
  height: 2rem;
  border-radius: 50%;
  background: #dbeafe;
  color: #1d4ed8;
  font-weight: 800;
}

@media (max-width: 820px) {
  .hero-box,
  .content-card,
  .mission-card {
    grid-template-columns: 1fr;
    padding: 1rem;
  }

  .hero-image-wrap,
  .image-panel,
  .hero-image,
  .image-panel img,
  .image-empty {
    min-height: 280px;
  }

  .lower-panel {
    order: 0;
  }

  .principal-card {
    grid-template-columns: 1fr;
  }
}
</style>
