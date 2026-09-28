<template>
  <div class="staff-page">
    <main class="staff-content">
      <header class="page-heading">
        <p class="eyebrow">Keluarga Besar SMK Nurul Jadid</p>
        <h1 style="color: #2563eb;">Profile &amp; Guru</h1>
        <p class="intro">
          Kenali para pendidik dan tenaga kependidikan yang mendampingi perjalanan belajar di sekolah.
        </p> 
      </header>

      <section class="headmaster-section" aria-labelledby="headmaster-title">
        <div class="section-heading">
          <p class="section-kicker">Pimpinan Sekolah</p>
          <h2 id="headmaster-title">Kepala Sekolah</h2>
        </div>

        <article class="headmaster-card">
          <div class="headmaster-portrait">
            <img v-if="headmaster.image" :src="headmaster.image" :alt="`Foto ${headmaster.name}`" />
            <span v-else class="portrait-placeholder" aria-hidden="true">{{ headmaster.initials }}</span>
          </div>
          <div class="headmaster-copy">
            <p class="section-kicker">{{ headmaster.title }}</p>
            <h3>{{ headmaster.name }}</h3>
            <p v-if="headmaster.currentPosition" class="headmaster-position">{{ headmaster.currentPosition }}</p>
            <p class="headmaster-bio">{{ headmaster.description }}</p>
            <router-link
              class="detail-link"
              :to="{ name: 'ProfilGuruStafDetail', params: { id: headmaster.id } }"
            >
              Lihat detail profil <ArrowRight :size="17" aria-hidden="true" />
            </router-link>
          </div>
        </article>
      </section>

      <section class="staff-directory" aria-labelledby="staff-list-title">
        <header class="directory-heading">
          <p class="section-kicker">Tenaga Pendidik &amp; Kependidikan</p>
          <h2 id="staff-list-title">Guru &amp; Staf</h2>
        </header>

        <section
          v-for="group in groups"
          :key="group.key"
          class="staff-group"
          :aria-labelledby="`group-title-${group.key}`"
        >
          <div class="group-heading">
            <h2 :id="`group-title-${group.key}`">{{ group.title }}</h2>
            <div v-if="group.pageCount > 1" class="slider-controls" :aria-label="`Navigasi ${group.title}`">
              <button
                type="button"
                :aria-label="`Halaman sebelumnya: ${group.title}`"
                :disabled="group.pageIndex === 0"
                @click="pageIndexes[group.key] = Math.max(0, group.pageIndex - 1)"
              >
                <ArrowLeft :size="18" aria-hidden="true" />
              </button>
              <span class="page-count">{{ group.pageIndex + 1 }} / {{ group.pageCount }}</span>
              <button
                type="button"
                :aria-label="`Halaman berikutnya: ${group.title}`"
                :disabled="group.pageIndex >= group.pageCount - 1"
                @click="pageIndexes[group.key] = Math.min(group.pageCount - 1, group.pageIndex + 1)"
              >
                <ArrowRight :size="18" aria-hidden="true" />
              </button>
            </div>
          </div>

          <div v-if="group.visiblePeople.length" class="staff-grid" aria-live="polite">
            <router-link
              v-for="person in group.visiblePeople"
              :key="person.id"
              :to="{ name: 'ProfilGuruStafDetail', params: { id: person.id } }"
              class="person-card"
            >
              <div class="portrait-wrap">
                <img v-if="person.image" :src="person.image" :alt="`Foto ${person.name}`" loading="lazy" />
                <span v-else class="portrait-placeholder" aria-hidden="true">{{ person.initials }}</span>
              </div>
              <div class="person-copy">
                <h3>{{ person.name }}</h3>
                <span class="person-role">{{ person.title }}</span>
              </div>
            </router-link>
          </div>
          <div v-else class="empty-card">
            <h3>Profil {{ group.title.toLowerCase() }} belum tersedia</h3>
          </div>

          <nav v-if="group.pageCount > 1" class="page-indicators" :aria-label="`Pilih halaman ${group.title}`">
            <button
              v-for="page in group.pageCount"
              :key="page"
              type="button"
              :aria-label="`Buka halaman ${page} untuk ${group.title}`"
              :aria-current="group.pageIndex === page - 1 ? 'page' : undefined"
              :class="{ active: group.pageIndex === page - 1 }"
              @click="pageIndexes[group.key] = page - 1"
            ></button>
          </nav>
        </section>
      </section>
    </main>

    <FooterSection />
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { ArrowLeft, ArrowRight } from 'lucide-vue-next';
import { getPublicContent, getSchoolProfile } from '@/api/endpoints';
import { useSiteImages } from '@/composables/useSiteImages';
import FooterSection from '../../portal/components/FooterSection.vue';

const schoolProfile = ref({});
const staffProfiles = ref([]);
const pageIndexes = reactive({ leadership: 0, productive: 0, class_subject: 0, staff: 0 });
const { getImageByKey, getImageUrl, fetchImages } = useSiteImages();

const groupOptions = [
  { key: 'leadership', title: 'Guru Pimpinan / Waka' },
  { key: 'productive', title: 'Guru Produktif' },
  { key: 'class_subject', title: 'Guru Mata Pelajaran & Wali Kelas' },
  { key: 'staff', title: 'Staf & Karyawan' },
];

const imageUrl = (path) => {
  if (!path) return '';
  if (/^https?:\/\//i.test(path)) return path;
  const apiBase = (import.meta.env.VITE_API_URL || 'http://localhost:8000/api').replace(/\/api\/?$/, '');
  return `${apiBase}/storage/${String(path).replace(/^\/+|^storage\/+/, '')}`;
};

const headmaster = computed(() => {
  const profile = staffProfiles.value.find((person) => person.staff_group === 'headmaster');
  const name = profile?.name || schoolProfile.value.headmaster_name || 'Kepala Sekolah';
  const fallbackImage = getImageUrl(getImageByKey('headmaster_photo'));

  return {
    id: profile?.id || 'legacy-headmaster',
    title: profile?.staff_role || 'Kepala Sekolah',
    name,
    currentPosition: profile?.current_position || '',
    description: profile?.description || schoolProfile.value.headmaster_message_body || schoolProfile.value.headmaster_message || 'Memimpin dan mengembangkan pendidikan di SMK Nurul Jadid.',
    image: imageUrl(profile?.image) || fallbackImage,
    initials: name.split(/\s+/).filter(Boolean).slice(0, 2).map((part) => part[0]).join('') || 'KS',
  };
});

const groups = computed(() => groupOptions.map((group) => {
  const people = staffProfiles.value
    .filter((person) => person.staff_group === group.key)
    .map((person) => ({
      id: person.id,
      title: person.staff_role,
      name: person.name,
      image: imageUrl(person.image),
      initials: person.name.split(/\s+/).filter(Boolean).slice(0, 2).map((part) => part[0]).join(''),
    }));
  const pageCount = Math.ceil(people.length / 4);
  const pageIndex = Math.min(pageIndexes[group.key], Math.max(0, pageCount - 1));

  return {
    ...group,
    people,
    pageCount,
    pageIndex,
    visiblePeople: people.slice(pageIndex * 4, pageIndex * 4 + 4),
  };
}));

onMounted(async () => {
  await fetchImages();

  try {
    const response = await getSchoolProfile();
    schoolProfile.value = response.data?.data || {};
  } catch (error) {
    console.warn('Gagal memuat profil kepala sekolah:', error);
  }

  try {
    const response = await getPublicContent('staff_profiles');
    staffProfiles.value = response.data?.data || [];
  } catch (error) {
    console.warn('Gagal memuat daftar guru dan staf:', error);
  }
});
</script>

<style scoped>
.staff-page {
  min-height: calc(100vh - var(--nav-height, 60px));
  background: linear-gradient(180deg, #f8fafc 0%, #eef6ff 100%);
  color: #0f172a;
}

.staff-content {
  width: min(1180px, 100%);
  margin: 0 auto;
  padding: 4rem 1.25rem 5rem;
}

.page-heading {
  max-width: 760px;
  margin-bottom: 3rem;
}

.section-kicker {
  margin: 0 0 0.65rem;
  color: #2563eb;
  font-size: 0.72rem;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

h1,
h2,
h3,
p {
  margin-top: 0;
}

h1 {
  margin-bottom: 0.8rem;
  font-size: clamp(2.3rem, 5vw, 4.2rem);
  line-height: 1.05;
}

.intro {
  max-width: 620px;
  margin-bottom: 0;
  color: #475569;
  font-size: 1.05rem;
  line-height: 1.7;
}

.headmaster-section,
.staff-directory {
  margin-top: 3.5rem;
}

.section-heading {
  display: flex;
  align-items: flex-end;
  margin-bottom: 1.15rem;
}

.directory-heading {
  margin-bottom: 2.5rem;
  text-align: center;
}

.directory-heading h2 {
  font-size: 2rem;
}

.staff-group {
  margin-top: 2.75rem;
}

.group-heading {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 1.15rem;
}

h2 {
  margin-bottom: 0;
  font-size: 1.7rem;
  line-height: 1.25;
}

.headmaster-card {
  display: grid;
  grid-template-columns: minmax(300px, 0.85fr) 1.15fr;
  gap: 2.5rem;
  min-height: 430px;
  padding: 1.5rem;
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 1.25rem;
  background: #fff;
  box-shadow: 0 22px 54px rgba(15, 23, 42, 0.07);
}

.headmaster-portrait {
  display: grid;
  min-height: 390px;
  place-items: center;
  overflow: hidden;
  border-radius: 0.85rem;
  background: #d9eee8;
}

.headmaster-portrait img {
  width: 100%;
  height: 100%;
  min-height: 390px;
  object-fit: cover;
}

.headmaster-copy {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  padding: 1.5rem 1.25rem 1.5rem 0;
}

.headmaster-copy h3 {
  margin: 0;
  font-size: clamp(1.8rem, 3vw, 2.6rem);
}

.headmaster-position {
  margin: 0.75rem 0 0;
  color: #2563eb;
  font-weight: 700;
}

.headmaster-bio {
  max-width: 620px;
  margin: 1rem 0 1.4rem;
  color: #475569;
  font-size: 1.02rem;
  line-height: 1.8;
  white-space: pre-line;
}

.detail-link {
  display: inline-flex;
  align-items: center;
  gap: 0.55rem;
  min-height: 44px;
  color: #176a59;
  font-weight: 800;
  text-decoration: none;
}

.detail-link:hover,
.detail-link:focus-visible {
  color: #0f4c40;
  text-decoration: underline;
}

.staff-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1rem;
}

.person-card {
  position: relative;
  display: block;
  min-width: 0;
  aspect-ratio: 0.82;
  min-height: 320px;
  overflow: hidden;
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 0.85rem;
  background: #fff;
  box-shadow: 0 18px 42px rgba(15, 23, 42, 0.06);
  color: inherit;
  text-decoration: none;
  transition: transform 180ms ease, box-shadow 180ms ease;
}

.person-card:hover,
.person-card:focus-visible {
  transform: translateY(-3px);
  box-shadow: 0 22px 48px rgba(15, 23, 42, 0.12);
}

.portrait-wrap {
  display: grid;
  position: absolute;
  inset: 0;
  place-items: center;
  overflow: hidden;
  background: #dfeafc;
}

.portrait-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.portrait-placeholder {
  display: grid;
  width: 4rem;
  aspect-ratio: 1;
  place-items: center;
  border: 1px solid #bfdbfe;
  border-radius: 50%;
  color: #1d4ed8;
  font-size: 1.1rem;
  font-weight: 800;
}

.person-copy {
  display: flex;
  position: absolute;
  right: 0.7rem;
  bottom: 0.7rem;
  left: 0.7rem;
  z-index: 1;
  flex-direction: column;
  gap: 0.3rem;
  padding: 0.85rem 1rem;
  border: 1px solid rgba(148, 163, 184, 0.16);
  border-radius: 0.65rem;
  background: rgba(255, 255, 255, 0.97);
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.12);
}

.person-role {
  display: -webkit-box;
  overflow: hidden;
  color: #475569;
  font-size: 0.88rem;
  line-height: 1.4;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

h3 {
  margin-bottom: 0;
  color: #0f172a;
  font-size: 1.15rem;
  line-height: 1.35;
  overflow-wrap: anywhere;
}

.empty-card {
  min-height: 136px;
  padding: 1.25rem;
  border-style: dashed;
  background: rgba(255, 255, 255, 0.8);
  color: #475569;
}

.empty-card h3 {
  margin: 0;
}

.slider-controls {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.slider-controls button,
.page-indicators button {
  display: grid;
  flex: 0 0 42px;
  width: 42px;
  height: 42px;
  place-items: center;
  border: 1px solid #cbd5e1;
  border-radius: 50%;
  background: #fff;
  color: #176a59;
  cursor: pointer;
}

.slider-controls button:disabled {
  color: #94a3b8;
  cursor: not-allowed;
}

.slider-controls button:not(:disabled):hover {
  border-color: #176a59;
  background: #e8f4ef;
}

.page-count {
  min-width: 3.5rem;
  color: #475569;
  font-size: 0.85rem;
  font-variant-numeric: tabular-nums;
  text-align: center;
}

.page-indicators {
  display: flex;
  justify-content: center;
  gap: 0.55rem;
  margin-top: 1rem;
}

.page-indicators button {
  flex-basis: 10px;
  width: 10px;
  height: 10px;
  border: 0;
  background: #cbd5e1;
}

.page-indicators button.active {
  width: 26px;
  flex-basis: 26px;
  border-radius: 8px;
  background: #176a59;
}

@media (max-width: 600px) {
  .staff-content {
    padding: 3rem 1rem 4rem;
  }

  .page-heading {
    margin-bottom: 2.25rem;
  }

  .headmaster-section,
  .staff-directory {
    margin-top: 2.5rem;
  }

  .staff-group {
    margin-top: 2.2rem;
  }

  .headmaster-card {
    grid-template-columns: 1fr;
    gap: 1rem;
    padding: 1rem;
  }

  .headmaster-portrait,
  .headmaster-portrait img {
    min-height: 320px;
    max-height: 420px;
  }

  .headmaster-copy {
    padding: 0.5rem;
  }

  .group-heading {
    align-items: center;
    gap: 0.75rem;
  }

  .directory-heading {
    margin-bottom: 2rem;
  }

  h2 {
    font-size: 1.2rem;
  }
}

@media (max-width: 960px) {
  .staff-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 760px) {
  .headmaster-card {
    grid-template-columns: minmax(220px, 0.8fr) 1.2fr;
    gap: 1.25rem;
    min-height: 340px;
  }

  .headmaster-portrait,
  .headmaster-portrait img {
    min-height: 310px;
  }
}

@media (max-width: 600px) {
  .headmaster-card {
    grid-template-columns: 1fr;
  }

  .staff-grid {
    gap: 0.75rem;
  }

  .person-card {
    min-height: 270px;
  }
}
</style>