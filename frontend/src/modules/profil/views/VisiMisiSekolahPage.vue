<template>
  <div class="vision-mission-page">
    <main class="vision-mission-content">
      <section class="top-section">
        <div class="top-copy">
          <p class="eyebrow">Visi & Misi</p>
          <h1>{{ schoolName }}</h1>
          <p class="lead">
            {{ schoolProfile.vision_page_intro || schoolProfile.profile_description || 'Komitmen kami menyiapkan lulusan yang beriman, cakap, dan siap menghadapi tantangan masa depan.' }}
          </p>
        </div>
      </section>

      <section class="content-grid">
        <article class="content-card">
          <div class="image-panel">
            <img v-if="visionImage" :src="visionImage" alt="Visi sekolah" loading="lazy" />
            <span v-else class="image-empty">Gambar visi belum diupload</span>
          </div>
          <div class="text-panel">
            <span class="badge">Visi</span>
            <h2>Visi Sekolah</h2>
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
            <h2>Misi Sekolah</h2>
            <div class="mission-list" v-if="missionList.length">
              <div v-for="(item, index) in missionList" :key="index" class="mission-item">
                <span class="mission-number">{{ index + 1 }}</span>
                <p>{{ item }}</p>
              </div>
            </div>
            <p v-else>{{ schoolProfile.mission_page_content || schoolProfile.mission || defaultMission }}</p>
          </div>
        </article>
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

const schoolName = computed(() => {
  const name = schoolProfile.value.school_name || 'SMK Nurul Jadid';
  return name.replace(/\s*\(SMKNJ\)\s*$/i, '').trim();
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
    console.warn('Gagal memuat visi dan misi sekolah:', error);
  }
});
</script>

<style scoped>
.vision-mission-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #f8fafc 0%, #eef4ff 100%);
}

.vision-mission-content {
  padding: 4rem 1.25rem 5rem;
}

.top-section,
.content-grid {
  width: min(1180px, 100%);
  margin: 0 auto;
}

.top-section {
  margin-bottom: 2rem;
}

.top-copy {
  background: rgba(255, 255, 255, 0.85);
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 2rem;
  padding: 2rem;
  box-shadow: 0 20px 60px rgba(15, 23, 42, 0.05);
}

.eyebrow {
  margin: 0 0 0.75rem;
  font-size: 0.72rem;
  font-weight: 800;
  letter-spacing: 0.18rem;
  text-transform: uppercase;
  color: #2563eb;
}

h1 {
  margin: 0;
  font-size: clamp(2rem, 3vw, 3rem);
  color: #0f172a;
}

.lead {
  margin: 1rem 0 0;
  color: #475569;
  line-height: 1.8;
  max-width: 760px;
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

.image-panel {
  overflow: hidden;
  border-radius: 1.5rem;
  min-height: 340px;
  background: #dfeafc;
}

.lower-panel {
  order: 2;
}

.image-panel img {
  width: 100%;
  height: 100%;
  min-height: 340px;
  object-fit: cover;
  display: block;
}

.image-empty {
  display: grid;
  place-items: center;
  min-height: 340px;
  padding: 2rem;
  color: #64748b;
  text-align: center;
  font-weight: 700;
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
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.08rem;
  text-transform: uppercase;
}

h2 {
  margin: 0;
  font-size: clamp(1.5rem, 2vw, 2.2rem);
  color: #0f172a;
}

.text-panel p,
.mission-item p {
  margin: 0;
  color: #475569;
  line-height: 1.9;
  font-size: 1rem;
}

.mission-list {
  display: flex;
  flex-direction: column;
  gap: 0.9rem;
}

.mission-item {
  display: flex;
  align-items: flex-start;
  gap: 0.8rem;
  padding: 0.8rem 0.9rem;
  border-radius: 1rem;
  background: #f8fafc;
  border: 1px solid rgba(148, 163, 184, 0.14);
}

.mission-number {
  flex-shrink: 0;
  display: inline-grid;
  place-items: center;
  width: 2rem;
  height: 2rem;
  border-radius: 999px;
  background: #1d4ed8;
  color: #fff;
  font-weight: 700;
}

@media (max-width: 820px) {
  .content-card,
  .mission-card {
    grid-template-columns: 1fr;
  }

  .image-panel,
  .image-panel img,
  .image-empty {
    min-height: 260px;
  }

  .lower-panel {
    order: 0;
  }
}
</style>
