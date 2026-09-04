<template>
  <section class="profil-sekolah">
    <div class="profil-container">
      <div class="profil-grid">
        <!-- Kolom Kiri: Gedung Sekolah -->
        <div class="profil-col profil-col-left">
          <img
            :src="finalBuildingImage"
            alt="Foto gedung SMK Nurul Jadid"
            class="profil-building-img"
            loading="lazy"
          />
        </div>

        <!-- Kolom Tengah: Lab + Card -->
        <div class="profil-col profil-col-center">
          <div class="profil-lab-wrap">
            <img
              :src="finalLabImage"
              alt="Siswa sedang praktik di lab komputer"
              class="profil-lab-img"
              loading="lazy"
            />
          </div>
          <div class="profil-highlight-card">
            <svg
              class="profil-grad-icon"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              aria-hidden="true"
            >
              <path d="M12 2L9 9H2l6 4.5L5.5 22 12 17l6.5 5-2.5-8.5L22 9h-7z" />
            </svg>
            <p class="profil-highlight-text">Education for the Future</p>
          </div>
        </div>

        <!-- Kolom Kanan: Teks -->
        <div class="profil-col profil-col-right">
          <span class="profil-label">{{ label }}</span>
          <h2 class="profil-title">
            <span>{{ titleLine1 }}</span
            ><br />
            <span>{{ titleLine2 }}</span>
          </h2>
          <p class="profil-description">{{ description }}</p>

          <div class="profil-vm-row">
            <div class="profil-vm-card profil-vm-vision">
              <h4 class="profil-vm-title">{{ visionTitle }}</h4>
              <p class="profil-vm-text">{{ visionText }}</p>
            </div>
            <div class="profil-vm-card profil-vm-mission">
              <h4 class="profil-vm-title">{{ missionTitle }}</h4>
              <p class="profil-vm-text">{{ missionText }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from "vue";
import { useSiteImages } from "@/composables/useSiteImages";
import labImg from "../../../assets/hero-lab.webp";
import gedungImg from "../../../assets/gedung.png";

const { getImageByKey, images } = useSiteImages();

const props = defineProps({
  label: {
    type: String,
    default: "PROFIL SEKOLAH",
  },
  titleLine1: {
    type: String,
    default: "Tradisi Pesantren, Inovasi",
  },
  titleLine2: {
    type: String,
    default: "Masa Depan",
  },
  description: {
    type: String,
    default:
      "SMK Nurul Jadid bukan sekadar lembaga pendidikan vokasi. Kami adalah ekosistem yang menggabungkan nilai-nilai spiritual luhur dengan keahlian teknis mutakhir. Berdiri sejak puluhan tahun, kami terus bertransformasi menjadi pusat unggulan (Center of Excellence).",
  },
  buildingImage: {
    type: String,
    default: null,
  },
  labImage: {
    type: String,
    default: null,
  },
  visionTitle: {
    type: String,
    default: "Visi",
  },
  visionText: {
    type: String,
    default: "Menjadi SMK rujukan nasional berbasis iman dan teknologi.",
  },
  missionTitle: {
    type: String,
    default: "Misi",
  },
  missionText: {
    type: String,
    default: "Memberdayakan potensi siswa melalui pendidikan vokasi terapan.",
  },
});

// Use database images if available, fallback to props or assets
const finalBuildingImage = computed(() => {
  if (props.buildingImage) return props.buildingImage;
  const img = getImageByKey("about_image");
  return img?.image_url || gedungImg;
});

const finalLabImage = computed(() => {
  if (props.labImage) return props.labImage;
  const img = getImageByKey("facility_lab_komputer");
  return img?.image_url || labImg;
});
</script>

<style lang="scss" scoped>
@use "../../../assets/styles/variables" as *;

.profil-sekolah {
  background: #ffffff;
  padding: 5rem 0;
}

.profil-container {
  width: min($container-max, calc(100% - 48px));
  margin: 0 auto;
}

.profil-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
  align-items: stretch;
}

@media (min-width: 768px) {
  .profil-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 2.5rem;
  }
}

@media (min-width: 1024px) {
  .profil-grid {
    gap: 3rem;
  }
}

/* Kolom Kiri */
.profil-col-left {
  display: flex;
}

.profil-building-img {
  width: 100%;
  height: 100%;
  min-height: 480px;
  object-fit: cover;
  border-radius: 2rem;
  display: block;
}

@media (min-width: 768px) {
  .profil-building-img {
    min-height: 640px;
    border-radius: 2.5rem;
  }
}

/* Kolom Tengah */
.profil-col-center {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.profil-lab-wrap {
  flex: 0 0 auto;
}

.profil-lab-img {
  width: 100%;
  height: 320px;
  object-fit: cover;
  border-radius: 2rem;
  display: block;
}

@media (min-width: 768px) {
  .profil-lab-img {
    height: 380px;
    border-radius: 2.5rem;
  }
}

.profil-highlight-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  align-items: flex-start;
  gap: 1rem;
  padding: 2rem;
  background: #ccfbf1;
  border-radius: 2rem;
  min-height: 260px;
}

@media (min-width: 768px) {
  .profil-highlight-card {
    padding: 2.5rem;
    border-radius: 2.5rem;
    min-height: 320px;
  }
}

.profil-grad-icon {
  width: 3rem;
  height: 3rem;
  color: #0f766e;
}

@media (min-width: 768px) {
  .profil-grad-icon {
    width: 3.5rem;
    height: 3.5rem;
  }
}

.profil-highlight-text {
  margin: 0;
  font-family: $font-display;
  font-weight: 700;
  font-size: 1.25rem;
  color: #134e4a;
  line-height: 1.3;
}

@media (min-width: 768px) {
  .profil-highlight-text {
    font-size: 1.5rem;
  }
}

/* Kolom Kanan */
.profil-col-right {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.profil-label {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #042d86;
}

.profil-title {
  font-family: $font-display;
  font-weight: 800;
  font-size: clamp(1.6rem, 2.2vw, 2.1rem);
  line-height: 1.2;
  color: #0f172a;
  margin: 0;
}

.profil-description {
  color: #334155;
  font-size: 0.95rem;
  line-height: 1.75;
  margin: 0;
}

.profil-vm-row {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 0.5rem;
}

@media (min-width: 640px) {
  .profil-vm-row {
    flex-direction: row;
  }
}

.profil-vm-card {
  flex: 1;
  border-left: 5px solid transparent;
  border-radius: 0 1rem 1rem 0;
  padding: 1.25rem;
  background: #f5f3ff;
}

.profil-vm-vision {
  border-left-color: #042d86;
}

.profil-vm-mission {
  border-left-color: #b45309;
  background: #fffbeb;
}

.profil-vm-title {
  font-weight: 700;
  font-size: 1rem;
  margin: 0 0 0.5rem 0;
}

.profil-vm-vision .profil-vm-title {
  color: #042d86;
}

.profil-vm-mission .profil-vm-title {
  color: #b45309;
}

.profil-vm-text {
  margin: 0;
  font-size: 0.9rem;
  color: #334155;
  line-height: 1.6;
}
</style>
