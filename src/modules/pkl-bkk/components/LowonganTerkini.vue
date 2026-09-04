<template>
  <section class="lowongan-section">
    <div class="lowongan-inner">
      <div class="lowongan-header">
        <div>
          <h2 class="lowongan-title">{{ title }}</h2>
          <p class="lowongan-subtitle">{{ subtitle }}</p>
        </div>
      </div>

      <div class="lowongan-grid">
        <article v-for="job in previewJobs" :key="job.slug" class="lowongan-card">
          <div class="lowongan-top">
            <div class="lowongan-icon" :style="{ background: iconBg(job.kategori) }">
              <component :is="iconComponent(job.icon)" :size="20" :color="iconColor(job.kategori)" />
            </div>
            <span v-if="job.status === 'Baru'" class="lowongan-badge">Baru</span>
          </div>
          <h3 class="lowongan-name">{{ job.posisi }}</h3>
          <p class="lowongan-company">{{ job.perusahaan }}</p>
          <ul class="lowongan-details">
            <li>{{ job.lokasi }}</li>
            <li>{{ job.tipePekerjaanLabel }}</li>
            <li>Deadline: {{ job.deadlineLabel }}</li>
          </ul>
          <router-link :to="`/lowongan/${job.slug}`" class="lowongan-btn">
            {{ job.ctaLabel }}
            <ArrowRight :size="14" color="#ffffff" />
          </router-link>
        </article>
      </div>

      <div class="lowongan-footer">
        <router-link to="/lowongan" class="lowongan-more">Lihat Semua Lowongan Lainnya →</router-link>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ArrowRight, CodeXml, Car, Palette, Landmark } from 'lucide-vue-next'
import { getPublicContent } from '@/api/endpoints'
import { mapVacancy } from '@/modules/contentMapper'
import { getAllLowongan } from '@/data/lowongan'

defineProps({
  title: {
    type: String,
    default: 'Lowongan Terkini'
  },
  subtitle: {
    type: String,
    default: 'Temukan posisi yang sesuai dengan kompetensi jurusanmu.'
  }
})

const dbJobs = ref([])

onMounted(async () => {
  try {
    const res = await getPublicContent('job_vacancies')
    const fetched = (res.data?.data || []).map(mapVacancy)
    if (fetched.length > 0) {
      dbJobs.value = fetched
    } else {
      dbJobs.value = getAllLowongan()
    }
  } catch (err) {
    dbJobs.value = getAllLowongan()
  }
})

const previewJobs = computed(() => {
  const list = dbJobs.value.length ? dbJobs.value : getAllLowongan()
  return list.slice(0, 3)
})

function iconComponent(name) {
  const map = { CodeXml, Car, Palette, Landmark }
  return map[name] || Landmark
}

function iconColor(kategori) {
  const map = {
    'it-software': '#1e3a8a',
    'akuntansi-keuangan': '#047857',
    'teknik-otomotif': '#b45309',
    'desain-grafis': '#7e22ce'
  }
  return map[kategori] || '#334155'
}

function iconBg(kategori) {
  const map = {
    'it-software': '#dbeafe',
    'akuntansi-keuangan': '#d1fae5',
    'teknik-otomotif': '#fef3c7',
    'desain-grafis': '#f3e8ff'
  }
  return map[kategori] || '#f1f5f9'
}
</script>

<style lang="scss" scoped>
.lowongan-section {
  background: #ffffff;
  padding: 5rem 0;
}

.lowongan-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.lowongan-header {
  margin-bottom: 2.5rem;
}

.lowongan-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: clamp(1.8rem, 3vw, 2.5rem);
  color: #0f172a;
  margin: 0 0 0.5rem;
}

.lowongan-subtitle {
  color: #475569;
  font-size: 1rem;
  margin: 0;
}

.lowongan-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .lowongan-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 2rem;
  }
}

@media (min-width: 1024px) {
  .lowongan-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2rem;
  }
}

.lowongan-card {
  border: 1px solid #e2e8f0;
  border-radius: 1.25rem;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.lowongan-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.lowongan-icon {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.75rem;
  display: grid;
  place-items: center;
}

.lowongan-badge {
  padding: 0.35rem 0.85rem;
  border-radius: 9999px;
  background: #fff7ed;
  color: #c2410c;
  font-size: 0.75rem;
  font-weight: 700;
}

.lowongan-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.15rem;
  color: #0f172a;
  margin: 0;
}

.lowongan-company {
  color: #042d86;
  font-size: 0.95rem;
  margin: 0;
  font-weight: 600;
}

.lowongan-details {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  color: #475569;
  font-size: 0.9rem;
}

.lowongan-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  width: 100%;
  padding: 0.75rem;
  background: #042d86;
  color: #ffffff;
  border: none;
  border-radius: 9999px;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  margin-top: auto;
  transition: background-color 0.2s;
}

.lowongan-btn:hover {
  background: #032263;
}

.lowongan-footer {
  margin-top: 2.5rem;
  text-align: center;
}

.lowongan-more {
  display: inline-flex;
  align-items: center;
  padding: 0.85rem 2rem;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 0.95rem;
  text-decoration: none;
  transition: background 0.2s ease;
}

.lowongan-more:hover {
  background: #16264d;
}
</style>
