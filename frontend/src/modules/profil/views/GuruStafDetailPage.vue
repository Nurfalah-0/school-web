<template>
  <div class="staff-detail-page">
    <main class="detail-content">
      <router-link class="back-link" to="/profil/guru-staf">Kembali ke Guru &amp; Staf</router-link>

      <div v-if="loading" class="state-message">Memuat profil...</div>
      <div v-else-if="!profile" class="state-message">
        <h1>Profil tidak ditemukan</h1>
        <p>Profil ini belum tersedia atau tidak dipublikasikan.</p>
      </div>

      <template v-else>
        <header class="profile-hero">
          <div class="portrait">
            <img v-if="profile.image" :src="profile.image" :alt="`Foto ${profile.name}`" />
            <span v-else class="portrait-placeholder" aria-hidden="true">{{ initials }}</span>
          </div>
          <div class="identity">
            <p class="eyebrow">{{ groupLabel(profile.staff_group) }}</p>
            <h1>{{ profile.name }}</h1>
            <p class="role">{{ profile.staff_role }}</p>
            <dl class="identity-list">
              <div>
                <dt>Instansi / Pekerjaan Saat Ini</dt>
                <dd>{{ profile.current_position || 'SMK Nurul Jadid' }}</dd>
              </div>
              <div v-if="profile.expertise">
                <dt>Bidang Keahlian / Mata Pelajaran</dt>
                <dd>{{ profile.expertise }}</dd>
              </div>
            </dl>
          </div>
        </header>

        <p v-if="profile.description" class="bio">{{ profile.description }}</p>

        <div class="detail-grid">
          <section v-if="education.length" class="detail-section">
            <p class="section-kicker">Kualifikasi &amp; Kompetensi</p>
            <h2>Riwayat Pendidikan</h2>
            <ul><li v-for="(item, index) in education" :key="index">{{ item }}</li></ul>
          </section>

          <section v-if="additionalRoles.length" class="detail-section">
            <p class="section-kicker">Peran di Sekolah</p>
            <h2>Jabatan &amp; Tugas Tambahan</h2>
            <ul><li v-for="(item, index) in additionalRoles" :key="index">{{ item }}</li></ul>
          </section>

          <section v-if="experience.length" class="detail-section">
            <p class="section-kicker">Rekam Jejak Profesional</p>
            <h2>Pengalaman Profesional</h2>
            <ul><li v-for="(item, index) in experience" :key="index">{{ item }}</li></ul>
          </section>

          <section v-if="awards.length" class="detail-section">
            <p class="section-kicker">Capaian</p>
            <h2>Prestasi &amp; Penghargaan</h2>
            <ul><li v-for="(item, index) in awards" :key="index">{{ item }}</li></ul>
          </section>

          <section v-if="publications.length" class="detail-section detail-section--wide">
            <p class="section-kicker">Karya &amp; Penelitian</p>
            <h2>Karya Tulis / Penelitian</h2>
            <ul><li v-for="(item, index) in publications" :key="index">{{ item }}</li></ul>
          </section>
        </div>

        <blockquote v-if="profile.motto" class="motto">
          <p>“{{ profile.motto }}”</p>
          <cite>{{ profile.name }}</cite>
        </blockquote>
      </template>
    </main>

    <FooterSection />
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';
import { getPublicContent, getSchoolProfile } from '@/api/endpoints';
import { useSiteImages } from '@/composables/useSiteImages';
import FooterSection from '../../portal/components/FooterSection.vue';

const route = useRoute();
const profile = ref(null);
const loading = ref(true);
const { getImageByKey, getImageUrl, fetchImages } = useSiteImages();
const groupNames = {
  headmaster: 'Kepala Sekolah',
  leadership: 'Guru Pimpinan / Waka',
  productive: 'Guru Produktif',
  class_subject: 'Wali Kelas & Guru Mata Pelajaran',
  staff: 'Staf & Karyawan',
};

function toList(value) {
  if (Array.isArray(value)) return value.filter(Boolean);
  if (typeof value !== 'string' || !value.trim()) return [];
  try {
    const parsed = JSON.parse(value);
    return Array.isArray(parsed) ? parsed.filter(Boolean) : [];
  } catch {
    return [];
  }
}

function groupLabel(group) {
  return groupNames[group] || 'Guru & Staf';
}

const initials = computed(() => (profile.value?.name || '')
  .split(/\s+/).filter(Boolean).slice(0, 2).map((part) => part[0]).join('') || 'GS');
const education = computed(() => toList(profile.value?.education));
const additionalRoles = computed(() => toList(profile.value?.additional_roles));
const experience = computed(() => toList(profile.value?.professional_experience));
const publications = computed(() => toList(profile.value?.publications));
const awards = computed(() => toList(profile.value?.awards));

const apiImageUrl = (path) => {
  if (!path) return '';
  if (/^https?:\/\//i.test(path)) return path;
  const apiBase = (import.meta.env.VITE_API_URL || 'http://localhost:8000/api').replace(/\/api\/?$/, '');
  return `${apiBase}/storage/${String(path).replace(/^\/+|^storage\/+/, '')}`;
};

onMounted(async () => {
  try {
    if (route.params.id === 'legacy-headmaster') {
      await fetchImages();
      const response = await getSchoolProfile();
      const schoolProfile = response.data?.data || {};
      profile.value = {
        name: schoolProfile.headmaster_name || 'Kepala Sekolah',
        staff_role: 'Kepala Sekolah',
        staff_group: 'headmaster',
        current_position: 'Kepala Sekolah di SMK Nurul Jadid',
        description: schoolProfile.headmaster_message_body || '',
        image: getImageUrl(getImageByKey('headmaster_photo')),
      };
    } else {
      const response = await getPublicContent('staff_profiles');
      const profiles = response.data?.data || [];
      const found = profiles.find((item) => String(item.id) === String(route.params.id));
      if (found) profile.value = { ...found, image: apiImageUrl(found.image) };
    }
  } catch (error) {
    console.warn('Gagal memuat detail profil guru/staf:', error);
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
.staff-detail-page {
  min-height: calc(100vh - var(--nav-height, 60px));
  background: linear-gradient(180deg, #f8fafc 0%, #eef6ff 100%);
  color: #0f172a;
}

.detail-content {
  width: min(1120px, 100%);
  margin: 0 auto;
  padding: 3rem 1.25rem 5rem;
}

.back-link {
  display: inline-flex;
  margin-bottom: 1.5rem;
  color: #1d4ed8;
  font-weight: 700;
  text-decoration: none;
}

.back-link:hover {
  text-decoration: underline;
}

.profile-hero {
  display: grid;
  grid-template-columns: minmax(220px, 0.7fr) 1.3fr;
  gap: 2rem;
  padding: 1.5rem;
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 2rem;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 25px 60px rgba(15, 23, 42, 0.06);
}

.portrait {
  display: grid;
  min-height: 320px;
  place-items: center;
  overflow: hidden;
  border-radius: 1.5rem;
  background: #dfeafc;
}

.portrait img {
  width: 100%;
  height: 100%;
  min-height: 320px;
  object-fit: cover;
}

.portrait-placeholder {
  display: grid;
  width: 6rem;
  aspect-ratio: 1;
  place-items: center;
  border: 1px solid #bfdbfe;
  border-radius: 50%;
  color: #1d4ed8;
  font-size: 1.5rem;
  font-weight: 800;
}

.identity {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 0.8rem;
  padding: 0.5rem;
}

.eyebrow,
.section-kicker {
  margin: 0;
  color: #2563eb;
  font-size: 0.72rem;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

h1,
h2,
p {
  margin-top: 0;
}

h1 {
  margin-bottom: 0;
  font-size: clamp(2rem, 5vw, 3.5rem);
  line-height: 1.1;
}

.role {
  margin-bottom: 0;
  color: #1d4ed8;
  font-size: 1.05rem;
  font-weight: 700;
}

.identity-list {
  display: grid;
  gap: 0.8rem;
  margin: 0.5rem 0 0;
}

.identity-list dt {
  margin-bottom: 0.2rem;
  color: #64748b;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
}

.identity-list dd {
  margin: 0;
  color: #334155;
  line-height: 1.65;
}

.bio {
  margin: 1.25rem 0 0;
  padding: 1.25rem 1.5rem;
  border: 1px solid rgba(148, 163, 184, 0.16);
  border-radius: 1rem;
  background: rgba(255, 255, 255, 0.8);
  color: #475569;
  line-height: 1.8;
  white-space: pre-line;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.detail-section {
  padding: 1.4rem 1.5rem;
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 1.25rem;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 18px 42px rgba(15, 23, 42, 0.04);
}

.detail-section--wide {
  grid-column: 1 / -1;
}

.detail-section h2 {
  margin: 0.5rem 0 0.85rem;
  font-size: 1.2rem;
}

.detail-section ul {
  display: grid;
  gap: 0.65rem;
  margin: 0;
  padding-left: 1.15rem;
  color: #475569;
  line-height: 1.7;
}

.motto {
  margin: 1rem 0 0;
  padding: 1.5rem 1.75rem;
  border-left: 4px solid #3b82f6;
  border-radius: 0 1rem 1rem 0;
  background: #dbeafe;
}

.motto p {
  margin-bottom: 0.6rem;
  color: #1e3a8a;
  font-size: 1.2rem;
  font-weight: 700;
  line-height: 1.6;
}

.motto cite {
  color: #475569;
  font-size: 0.9rem;
  font-style: normal;
}

.state-message {
  padding: 3rem 1rem;
  color: #475569;
  text-align: center;
}

@media (max-width: 760px) {
  .detail-content {
    padding: 2rem 1rem 4rem;
  }

  .profile-hero {
    grid-template-columns: 1fr;
    gap: 1.25rem;
    padding: 1rem;
  }

  .portrait,
  .portrait img {
    min-height: 280px;
    max-height: 380px;
  }

  .detail-grid {
    grid-template-columns: 1fr;
  }
}
</style>
