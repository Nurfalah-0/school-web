<template>
  <div class="profil-page">
    <main class="profil-content">
      <section class="hero-box">
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

const schoolName = computed(() => schoolProfile.value.school_name || 'SMK Nurul Jadid');
const profileTitle = computed(
  () =>
    schoolProfile.value.profile_page_title ||
    schoolProfile.value.profile_title_line1 ||
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
  min-height: 100vh;
  background: linear-gradient(180deg, #f8fafc 0%, #eef6ff 100%);
}

.profil-content {
  padding: 4rem 1.25rem 5rem;
}

.hero-box {
  width: min(1180px, 100%);
  margin: 0 auto;
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

.hero-image-wrap {
  overflow: hidden;
  border-radius: 1.5rem;
  min-height: 420px;
  background: #dfeafc;
  height: 100%;
}

.hero-image {
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

.hero-copy {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.eyebrow {
  margin: 0;
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.18rem;
  text-transform: uppercase;
  color: #2563eb;
}

h1 {
  margin: 0;
  font-size: clamp(2rem, 3vw, 3.25rem);
  line-height: 1.1;
  color: #0f172a;
}

.lead {
  margin: 0;
  font-size: 1.04rem;
  line-height: 1.9;
  color: #475569;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
  padding: 0.9rem 1rem;
  border-radius: 1rem;
  background: #f8fafc;
  border: 1px solid rgba(148, 163, 184, 0.16);
}

.label {
  font-size: 0.72rem;
  letter-spacing: 0.08rem;
  text-transform: uppercase;
  color: #64748b;
}

strong {
  color: #0f172a;
  font-size: 0.96rem;
  line-height: 1.6;
}

@media (max-width: 820px) {
  .hero-box {
    grid-template-columns: 1fr;
    padding: 1rem;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .hero-image-wrap,
  .hero-image,
  .image-empty {
    min-height: 280px;
  }
}
</style>
