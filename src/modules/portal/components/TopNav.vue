<template>
  <nav class="top-nav">
    <div class="container nav-inner">
      <a class="brand" href="#hero">
        <img :src="logo" alt="Logo SMK" class="brand-logo" />
        <span>SMK Nurul Jadid</span>
      </a>
      <div class="nav-links">
        <a href="#profil">Profil</a>
        <a href="#lowongan">Lowongan</a>
        <a href="#pendaftaran">Daftar PKL</a>
        <a href="#tracer">Timeline</a>
        <a href="#kontak">Kontak</a>
        <router-link to="/login">Login Admin</router-link>
      </div>
      <div style="display: flex; gap: 0.5rem; align-items: center;">
        <router-link to="/login" class="nav-cta" style="background: transparent; border: 1px solid var(--primary); color: var(--primary);">Login Admin</router-link>
        <a class="nav-cta" href="#pendaftaran">Daftar PKL</a>
      </div>
    </div>
  </nav>
</template>

<script setup>
import logo from '../../../assets/logo.webp';
</script>

<style scoped>
.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
}

.brand-logo {
  width: 2.3rem;
  height: auto;
  display: block;
  border-radius: 0.5rem;
}
</style>
