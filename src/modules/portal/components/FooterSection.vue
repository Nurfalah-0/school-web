<template>
  <footer class="footer" id="kontak">
    <div class="footer-inner">
      <div class="footer-grid">
        <!-- Kolom 1: Brand & Sosial Media -->
        <div class="footer-brand">
          <div class="footer-brand-top">
            <img :src="logo" alt="Logo SMK" class="footer-logo" />
          <div class="footer-brand-text">
            <h3 class="footer-school-name">{{ schoolName }}</h3>
            <p class="footer-brand-desc">{{ description }}</p>
          </div>
          </div>
          <div class="footer-socials">
            <a
              v-for="link in socialLinks"
              :key="link.label"
              :href="link.href"
              class="footer-social-link"
              :aria-label="link.label"
            >
              <span v-html="link.icon" class="footer-social-icon"></span>
            </a>
          </div>
        </div>

        <!-- Kolom 2: Quick Links -->
        <div class="footer-col">
          <h4 class="footer-heading">Quick Links</h4>
          <nav class="footer-links">
            <a v-for="link in quickLinks" :key="link" :href="link.href">{{ link.label }}</a>
          </nav>
        </div>

        <!-- Kolom 3: Hubungi Kami -->
        <div class="footer-col">
          <h4 class="footer-heading">Hubungi Kami</h4>
          <div class="footer-contact">
            <div v-for="item in contactInfo" :key="item.text" class="footer-contact-row">
              <span class="footer-contact-icon" v-html="item.icon"></span>
              <span class="footer-contact-text">{{ item.text }}</span>
            </div>
          </div>
        </div>

        <!-- Kolom 4: Newsletter -->
        <div class="footer-col">
          <h4 class="footer-heading">Newsletter</h4>
          <p class="footer-newsletter-desc">{{ newsletterDesc }}</p>
          <form class="footer-newsletter-form" @submit.prevent="handleSubscribe">
            <input
              v-model="email"
              type="email"
              :placeholder="emailPlaceholder"
              class="footer-newsletter-input"
              required
            />
            <button type="submit" class="footer-newsletter-btn" :disabled="isSubscribing">
              {{ isSubscribing ? 'Mengirim...' : subscribeText }}
            </button>
          </form>
          <p v-if="subscribeMessage" class="footer-newsletter-msg" :class="subscribeError ? 'error' : 'success'">
            {{ subscribeMessage }}
          </p>
        </div>
      </div>

      <!-- Bagian Bawah Footer -->
      <div class="footer-bottom">
        <p class="footer-copyright">{{ copyright }}</p>
        <div class="footer-bottom-links">
          <a v-for="link in bottomLinks" :key="link.label" :href="link.href">{{ link.label }}</a>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { ref } from 'vue';
import logo from '../../../assets/logo.webp';

const email = ref('');
const isSubscribing = ref(false);
const subscribeMessage = ref('');
const subscribeError = ref(false);

const props = defineProps({
  schoolName: {
    type: String,
    default: 'SMK Nurul Jadid'
  },
  description: {
    type: String,
    default: 'Pusat pendidikan vokasi unggulan yang melahirkan profesional berakhlak santri.'
  },
  quickLinks: {
    type: Array,
    default: () => [
      { label: 'Tentang Kami', href: '#profil' },
      { label: 'Program Keahlian', href: '#lowongan' },
      { label: 'Pendaftaran (PPDB)', href: '#pendaftaran' },
      { label: 'Fasilitas Sekolah', href: '#profil' }
    ]
  },
  contactInfo: {
    type: Array,
    default: () => [
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-12 14-12 14s-6-8-12-14a10 10 0 0 1 20-4Z"></path><circle cx="12" cy="10" r="3"></circle></svg>',
        text: 'Jl. Pondok Pesantren Nurul Jadid, Paiton, Probolinggo'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>',
        text: '(0335) 771732'
      },
      {
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="16" x="2" y="4" rx="2"></rect><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path></svg>',
        text: 'info@smknuruljadid.sch.id'
      }
    ]
  },
  socialLinks: {
    type: Array,
    default: () => [
      {
        label: 'QR Code',
        href: '#',
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="5" height="5" x="3" y="3" rx="1"/><rect width="5" height="5" x="16" y="3" rx="1"/><rect width="5" height="5" x="3" y="16" rx="1"/><path d="M21 16h-3a2 2 0 0 0-2 2v3"/><path d="M21 21h.01"/><path d="M12 7h3a2 2 0 0 1 2 2v3"/><path d="M12 12h.01"/><path d="M7 12h3a2 2 0 0 1 2 2v3"/><path d="M7 7h.01"/></svg>'
      },
      {
        label: 'Instagram',
        href: '#',
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="20" x="2" y="2" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/></svg>'
      },
      {
        label: 'YouTube',
        href: '#',
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2.5 17a24.12 24.12 0 0 1 0-10 2 2 0 0 1 1.4-1.4 49.56 49.56 0 0 1 16.2 0A2 2 0 0 1 21.5 7a24.12 24.12 0 0 1 0 10 2 2 0 0 1-1.4 1.4 49.55 49.55 0 0 1-16.2 0A2 2 0 0 1 2.5 17"/><path d="m10 15 5-3-5-3z"/></svg>'
      }
    ]
  },
  newsletterDesc: {
    type: String,
    default: 'Dapatkan info terbaru seputar kegiatan dan prestasi sekolah.'
  },
  emailPlaceholder: {
    type: String,
    default: 'Email Anda'
  },
  subscribeText: {
    type: String,
    default: 'Subscribe'
  },
  copyright: {
    type: String,
    default: '© 2024 SMK Nurul Jadid. Excellence in Vocational Education.'
  },
  bottomLinks: {
    type: Array,
    default: () => [
      { label: 'Privacy Policy', href: '#privacy' },
      { label: 'Terms of Service', href: '#terms' }
    ]
  }
});

const handleSubscribe = async () => {
  subscribeMessage.value = '';
  subscribeError.value = false;

  const emailValue = email.value.trim();
  if (!emailValue) {
    subscribeMessage.value = 'Mohon masukkan email Anda.';
    subscribeError.value = true;
    return;
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(emailValue)) {
    subscribeMessage.value = 'Format email tidak valid.';
    subscribeError.value = true;
    return;
  }

  isSubscribing.value = true;
  try {
    await new Promise((resolve) => setTimeout(resolve, 800));
    subscribeMessage.value = 'Berhasil subscribe! Terima kasih.';
    email.value = '';
  } catch {
    subscribeMessage.value = 'Gagal subscribe. Coba lagi nanti.';
    subscribeError.value = true;
  } finally {
    isSubscribing.value = false;
  }
};
</script>

<style lang="scss" scoped>
.footer {
  background: #151530;
  color: #e2e8f0;
  padding: 5rem 0 0;
  border-radius: 3rem 3rem 0 0;
}

.footer-inner {
  width: min(1200px, calc(100% - 48px));
  margin: 0 auto;
}

.footer-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2.5rem;
}

@media (min-width: 640px) {
  .footer-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 3rem;
  }
}

@media (min-width: 1024px) {
  .footer-grid {
    grid-template-columns: 1.3fr 1fr 1fr 1fr;
    gap: 4rem;
  }
}

.footer-brand {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.footer-brand-top {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.footer-brand-text {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.footer-logo {
  width: 3.5rem;
  height: 3.5rem;
  border-radius: 0.75rem;
  object-fit: cover;
  flex-shrink: 0;
}

.footer-school-name {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.75rem;
  color: #ffffff;
  margin: 0;
  line-height: 1.2;
}

.footer-brand-desc {
  color: #94a3b8;
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0;
  max-width: 26rem;
}

.footer-socials {
  display: flex;
  gap: 0.75rem;
}

.footer-social-link {
  width: 2.75rem;
  height: 2.75rem;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.1);
  display: grid;
  place-items: center;
  color: #ffffff;
  transition: background-color 0.2s;
}

.footer-social-link:hover {
  background: rgba(255, 255, 255, 0.2);
}

.footer-social-icon {
  display: grid;
  place-items: center;
}

.footer-col {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.footer-heading {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 700;
  font-size: 1.1rem;
  color: #ffffff;
  margin: 0 0 0.25rem;
}

.footer-links a {
  display: block;
  color: #94a3b8;
  font-size: 0.95rem;
  margin-bottom: 0.75rem;
  text-decoration: none;
  transition: color 0.2s;
}

.footer-links a:hover {
  color: #ffffff;
}

.footer-contact {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.footer-contact-row {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
}

.footer-contact-icon {
  color: #60a5fa;
  flex-shrink: 0;
  margin-top: 0.1rem;
  display: grid;
  place-items: center;
}

.footer-contact-text {
  color: #94a3b8;
  font-size: 0.95rem;
  line-height: 1.5;
}

.footer-newsletter-desc {
  color: #94a3b8;
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0 0 1rem;
}

.footer-newsletter-form {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.footer-newsletter-input {
  width: 100%;
  padding: 0.85rem 1rem;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 0.5rem;
  color: #f8fafc;
  font-size: 0.95rem;
  outline: none;
  transition: border-color 0.2s;
}

.footer-newsletter-input::placeholder {
  color: #64748b;
}

.footer-newsletter-input:focus {
  border-color: #3b82f6;
}

.footer-newsletter-btn {
  width: 100%;
  padding: 0.85rem;
  background: #2563eb;
  color: #ffffff;
  border: none;
  border-radius: 0.5rem;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: background-color 0.2s;
}

.footer-newsletter-btn:hover:not(:disabled) {
  background: #1d4ed8;
}

.footer-newsletter-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.footer-newsletter-msg {
  font-size: 0.85rem;
  margin: 0.25rem 0 0;
}

.footer-newsletter-msg.success {
  color: #86efac;
}

.footer-newsletter-msg.error {
  color: #fca5a5;
}

.footer-bottom {
  margin-top: 4rem;
  padding: 1.5rem 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

@media (min-width: 640px) {
  .footer-bottom {
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
  }
}

.footer-copyright {
  color: #64748b;
  font-size: 0.85rem;
  margin: 0;
}

.footer-bottom-links {
  display: flex;
  gap: 1.5rem;
}

.footer-bottom-links a {
  color: #64748b;
  font-size: 0.85rem;
  text-decoration: none;
  transition: color 0.2s;
}

.footer-bottom-links a:hover {
  color: #ffffff;
}
</style>
