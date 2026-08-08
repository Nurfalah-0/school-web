<template>
  <footer class="footer" id="kontak">
    <div class="container footer-grid">
      <div class="footer-brand">
        <img :src="logo" alt="Logo SMK" class="footer-logo" />
        <div>
          <h3>SMK Nurul Jadid</h3>
          <p>Mencetak tenaga profesional, religius, dan siap bersaing di era digital global.</p>
        </div>
      </div>
      <div>
        <h4>Quick Links</h4>
        <a href="#hero">Beranda</a>
        <a href="#profil">Profil</a>
        <a href="#lowongan">Lowongan</a>
        <a href="#pendaftaran">Pendaftaran</a>
      </div>
      <div>
        <h4>Contact Details</h4>
        <p>Jl. KH. Zainul Mustofa, Paiton, Probolinggo</p>
        <p>+62 855 7112 1234</p>
        <p>bkk@smknuruljadid.sch.id</p>
      </div>
    </div>
  </footer>
</template>

<script setup>
import logo from '../../../assets/logo.webp';
</script>

<style scoped>
.footer-brand {
  display: flex;
  gap: 1rem;
  align-items: center;
  margin-bottom: 1rem;
}

.footer-logo {
  width: 3rem;
  height: 3rem;
  border-radius: 0.75rem;
  object-fit: cover;
}

.footer-grid h3,
.footer-grid h4 {
  margin: 0 0 0.75rem;
}

.footer-grid p {
  margin: 0.35rem 0;
}

.footer-grid a {
  display: block;
  margin-bottom: 0.75rem;
  color: rgba(255, 255, 255, 0.82);
}

@media (max-width: 900px) {
  .footer-grid {
    grid-template-columns: 1fr;
  }
}
</style>
