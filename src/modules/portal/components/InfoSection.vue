<template>
  <section class="info-section" id="profil">
    <div class="container section-block info-block">
      <div class="info-media">
        <img
          src="https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=900&q=80"
          alt="Pelajar SMK praktik di bengkel"
        />
        <div class="info-badge">
          <strong>98%</strong>
          <span>Penyerapan lulusan dalam 6 bulan</span>
        </div>
      </div>
      <div class="info-copy">
        <h2>Persiapkan Karirmu Sejak Masa PKL</h2>
        <p>
          Program Praktik Kerja Lapangan (PKL) kami dirancang untuk menyinkronkan kurikulum
          sekolah dengan kebutuhan industri nyata.
        </p>
        <div class="feature-list">
          <div class="feature-item" v-for="item in highlights" :key="item.title">
            <div class="feature-icon">✓</div>
            <div>
              <h3>{{ item.title }}</h3>
              <p>{{ item.text }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
const props = defineProps({
  highlights: {
    type: Array,
    default: () => []
  }
});
</script>
