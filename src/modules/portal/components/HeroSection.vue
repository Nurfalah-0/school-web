<template>
  <header class="hero-section" id="hero">
    <div class="container hero-grid">
      <div class="hero-copy">
        <span class="eyebrow">Pusat Karir &amp; PKL</span>
        <h1>Membangun Jembatan Menuju Dunia Kerja Profesional</h1>
        <p>
          Akses langsung ke ratusan mitra industri terkemuka. Temukan tempat Praktik Kerja
          Lapangan (PKL) impianmu atau mulai karir profesionalmu bersama BKK SMK Nurul Jadid.
        </p>
        <div class="hero-actions">
          <a class="button-primary" href="#pendaftaran">Ajukan PKL</a>
          <a class="button-secondary" href="#lowongan">Lihat Lowongan</a>
        </div>
      </div>

      <div class="hero-card">
        <img
          :src="heroImg"
          alt="Praktik Kerja Lab Komputer SMK Nurul Jadid"
        />
      </div>
    </div>
  </header>
</template>

<script setup>
import heroImg from '../../../assets/hero-lab.jpg';
</script>

