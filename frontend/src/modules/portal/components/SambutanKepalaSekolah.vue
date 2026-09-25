<template>
  <section class="principal-section">
    <div class="principal-card">
      <div class="principal-photo-wrap">
        <img
          v-if="headmasterImage"
          :src="headmasterImage"
          :alt="`Foto ${headmasterName}`"
          class="principal-photo"
          loading="eager"
        />
        <div v-else class="principal-photo placeholder">
          <User :size="64" color="#94a3b8" />
        </div>
      </div>

      <div class="principal-text">
        <p class="eyebrow">Kepala Sekolah</p>
        <h2>{{ headmasterName }}</h2>
        <div class="principal-message">
          <p
            v-for="(paragraph, index) in headmasterMessageParagraphs"
            :key="`principal-paragraph-${index}`"
            class="principal-body"
          >
            {{ paragraph }}
          </p>
          <p v-if="headmasterMessageStatement" class="principal-statement">{{ headmasterMessageStatement }}</p>
          <p v-if="headmasterMessageClosing" class="principal-closing">{{ headmasterMessageClosing }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { getSchoolProfile } from '@/api/endpoints'
import { useSiteImages } from '@/composables/useSiteImages'
import { User } from 'lucide-vue-next'

const { getImageByKey, getImageUrl, fetchImages } = useSiteImages()
const schoolProfile = ref({})

const defaultHeadmasterMessage = 'Dengan semangat kolaborasi, inovasi, dan akhlak mulia, kami terus berupaya mencetak lulusan yang siap bersaing di dunia kerja dan berkontribusi bagi masyarakat.'
const defaultHeadmasterStatement = 'SMK Nurul Jadid Pusat Keunggulan, Mencetak Wirausaha, Menghadirkan Industri di Sekolah.'

const splitHeadmasterMessage = (value) => {
  const text = (value || '').replace(/\*\*/g, '').replace(/\r\n?/g, '\n').trim()

  if (!text) {
    return { body: defaultHeadmasterMessage, statement: defaultHeadmasterStatement, closing: '' }
  }

  const statementPattern = /SMK Nurul Jadid Pusat Keunggulan, Mencetak Wirausaha, Menghadirkan Industri di Sekolah\.?/i
  const statementMatch = text.match(statementPattern)
  if (statementMatch) {
    const statement = statementMatch[0]
    const beforeStatement = text.slice(0, statementMatch.index).trim()
    const afterStatement = text.slice(statementMatch.index + statement.length).trim()
    const closing = afterStatement.replace(/^\n+/, '').trim()
    return {
      body: beforeStatement || defaultHeadmasterMessage,
      statement,
      closing,
    }
  }

  return { body: text, statement: defaultHeadmasterStatement, closing: '' }
}

const headmasterName = computed(() => schoolProfile.value.headmaster_name || 'Kepala Sekolah')
const headmasterImage = computed(() => {
  const image = getImageByKey('headmaster_photo')
  return getImageUrl(image)
})
const headmasterMessageData = computed(() => splitHeadmasterMessage(schoolProfile.value.headmaster_message))
const headmasterMessageBody = computed(() => headmasterMessageData.value.body || defaultHeadmasterMessage)
const headmasterMessageParagraphs = computed(() =>
  headmasterMessageBody.value.split(/\n\s*\n/).map((paragraph) => paragraph.trim()).filter(Boolean)
)
const headmasterMessageStatement = computed(() => headmasterMessageData.value.statement || defaultHeadmasterStatement)
const headmasterMessageClosing = computed(() => headmasterMessageData.value.closing)

onMounted(async () => {
  await fetchImages()
  try {
    const response = await getSchoolProfile()
    schoolProfile.value = response.data?.data || {}
  } catch (error) {
    console.warn('Gagal memuat profil sekolah:', error)
  }
})
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.principal-section {
  width: min(1180px, 100%);
  box-sizing: border-box;
  margin: 0 auto;
  padding: 0 1.25rem 4rem;
}

.principal-card {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 2rem;
  padding: 2rem;
  box-shadow: 0 25px 60px rgba(15, 23, 42, 0.06);
  align-items: center;
}

@media (min-width: 768px) {
  .principal-card {
    grid-template-columns: 1.05fr 1.25fr;
  }
}

.principal-text {
  display: flex;
  flex-direction: column;
  gap: 0.9rem;
}

.eyebrow {
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #8b6914;
  margin: 0;
}

.principal-card h2 {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.5rem, 2.5vw, 2.25rem);
  color: #0f172a;
  margin: 0;
  line-height: 1.3;
}

.principal-message {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
  margin: 0;
  font-size: 1.03rem;
  line-height: 1.9;
  color: #475569;
}

.principal-closing {
  margin: 0;
  color: #475569;
}

.principal-body {
  margin: 0;
  color: #1f2937;
  white-space: pre-line;
}

.principal-statement {
  margin: 0;
  color: #1d4ed8;
  font-weight: 800;
}

.principal-photo-wrap {
  display: flex;
  justify-content: center;
  align-self: stretch;
  min-height: 100%;
}

.principal-photo {
  width: min(100%, 400px);
  height: 100%;
  min-height: 280px;
  object-fit: cover;
  border-radius: 1.5rem;
  box-shadow: 0 22px 50px rgba(15, 23, 42, 0.12);
  border: 1px solid rgba(148, 163, 184, 0.14);
  background: #e2e8f0;
}

.principal-photo.placeholder {
  display: grid;
  place-items: center;
  padding: 1.5rem;
  text-align: center;
  color: #64748b;
  font-weight: 700;
}

@media (max-width: 820px) {
  .principal-card {
    grid-template-columns: 1fr;
    gap: 1.25rem;
    padding: 1rem;
  }

  .principal-photo-wrap {
    min-height: auto;
  }

  .principal-photo {
    width: 100%;
    max-width: 400px;
    height: auto;
    min-height: 0;
    aspect-ratio: 4 / 3;
  }
}
</style>