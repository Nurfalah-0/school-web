<template>
  <main class="contact-page">
    <section class="contact-hero">
      <div class="contact-hero-inner">
        <p class="contact-eyebrow">HUBUNGI SMK NURUL JADID</p>
        <h1>Ruang untuk bertanya, berkolaborasi, dan terhubung.</h1>
        <p class="contact-intro">
          Sampaikan pertanyaan Anda kepada tim sekolah. Admin dan staf kami siap membantu informasi pendaftaran, program keahlian, kerja sama, dan kebutuhan lainnya.
        </p>
      </div>
    </section>

    <section class="contact-content">
      <div class="contact-details">
        <div class="contact-section-heading">
          <p class="contact-kicker">KONTAK RESMI</p>
          <h2>Temukan kami</h2>
        </div>

        <a class="contact-detail" href="https://maps.google.com/?q=SMK+Nurul+Jadid+Paiton+Probolinggo" target="_blank" rel="noreferrer">
          <MapPin :size="21" />
          <span><strong>Alamat</strong>Jl. Pondok Pesantren Nurul Jadid, Paiton, Probolinggo</span>
        </a>
        <a class="contact-detail" href="tel:+62335771732">
          <Phone :size="21" />
          <span><strong>Telepon</strong>(0335) 771732</span>
        </a>
        <a class="contact-detail" href="mailto:smknurja.paiton@gmail.com">
          <Mail :size="21" />
          <span><strong>Email</strong>smknurja.paiton@gmail.com</span>
        </a>
        <a class="contact-detail" href="https://wa.me/6282335585491" target="_blank" rel="noreferrer">
          <MessageCircle :size="21" />
          <span><strong>WhatsApp</strong>+62 823-3558-5491</span>
        </a>

        <div class="map-frame">
          <iframe
            title="Peta lokasi SMK Nurul Jadid"
            src="https://www.google.com/maps?q=SMK+Nurul+Jadid+Paiton+Probolinggo&output=embed"
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
          ></iframe>
        </div>
      </div>

      <form class="contact-form" @submit.prevent="sendMessage">
        <div class="contact-section-heading">
          <p class="contact-kicker">KIRIM PESAN</p>
          <h2>Butuh bantuan?</h2>
          <p>Pilih tim yang ingin dihubungi, lalu ceritakan kebutuhan Anda.</p>
        </div>

        <div v-if="formMessage" class="form-alert" :class="formStatus" role="status">
          {{ formMessage }}
        </div>

        <label>Nama lengkap <input v-model="form.name" type="text" autocomplete="name" placeholder="Nama Anda" required /></label>
        <label>Email <input v-model="form.email" type="email" autocomplete="email" placeholder="nama@email.com" required /></label>
        <label>Hubungi <select v-model="form.recipient" required><option value="admin">Admin sekolah</option><option value="staff">Staf sekolah</option></select></label>
        <label>Subjek <input v-model="form.subject" type="text" placeholder="Contoh: Informasi pendaftaran" required /></label>
        <label>Pesan <textarea v-model="form.message" rows="6" placeholder="Tulis pesan Anda..." required></textarea></label>
        <button class="contact-submit" type="submit" :disabled="isSending">
          <Send :size="18" /> {{ isSending ? 'Mengirim pesan...' : 'Kirim pesan' }}
        </button>
      </form>
    </section>

    <FooterSection />
  </main>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { Mail, MapPin, MessageCircle, Phone, Send } from 'lucide-vue-next'
import client from '../../../api/client'
import FooterSection from '../components/FooterSection.vue'

const form = reactive({ name: '', email: '', recipient: 'admin', subject: '', message: '' })
const isSending = ref(false)
const formMessage = ref('')
const formStatus = ref('')

async function sendMessage() {
  isSending.value = true
  formMessage.value = ''
  try {
    const { data } = await client.post('/contact', form)
    formMessage.value = data.message
    formStatus.value = 'success'
    Object.assign(form, { name: '', email: '', recipient: 'admin', subject: '', message: '' })
  } catch (error) {
    formMessage.value = error.response?.data?.message || 'Pesan belum dapat dikirim. Silakan coba lagi.'
    formStatus.value = 'error'
  } finally {
    isSending.value = false
  }
}
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.contact-page { min-height: 100vh; background: $bg; color: $text; }
.contact-hero { background: $brand; color: #fff; padding: 7rem 1.5rem 5rem; }
.contact-hero-inner, .contact-content { max-width: 1120px; margin: 0 auto; }
.contact-eyebrow, .contact-kicker { margin: 0 0 1rem; font-size: .74rem; font-weight: 800; letter-spacing: .14em; }
.contact-eyebrow { color: $accent; }
.contact-kicker { color: $brand; }
.contact-hero h1 { max-width: 760px; margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; font-size: clamp(2.3rem, 5vw, 4.7rem); line-height: 1.04; letter-spacing: 0; }
.contact-intro { max-width: 620px; margin: 1.5rem 0 0; color: rgba(255, 255, 255, .82); font-size: 1.05rem; line-height: 1.75; }
.contact-content { display: grid; grid-template-columns: .9fr 1.1fr; gap: 5rem; padding: 5rem 1.5rem 7rem; }
.contact-section-heading h2 { margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; font-size: clamp(1.8rem, 3vw, 2.6rem); }
.contact-section-heading > p:last-child { color: $muted; line-height: 1.7; }
.contact-detail { display: flex; align-items: flex-start; gap: 1rem; margin-top: 1.5rem; color: $text; text-decoration: none; line-height: 1.55; }
.contact-detail svg { flex: 0 0 auto; margin-top: .15rem; color: $brand; }
.contact-detail span { display: grid; gap: .2rem; }
.contact-detail strong { font-size: .8rem; color: $muted; text-transform: uppercase; letter-spacing: .08em; }
.map-frame { height: 245px; margin-top: 2.25rem; overflow: hidden; border: 1px solid $border; border-radius: 12px; background: #e5e7eb; }
.map-frame iframe { width: 100%; height: 100%; border: 0; }
.contact-form { padding: 2rem; border: 1px solid $border; border-radius: 12px; background: #fff; box-shadow: $shadow; }
.contact-form label { display: grid; gap: .5rem; margin-top: 1.15rem; color: #36455b; font-size: .88rem; font-weight: 700; }
.contact-form input, .contact-form select, .contact-form textarea { width: 100%; box-sizing: border-box; border: 1px solid $border; border-radius: 7px; padding: .85rem .9rem; color: $text; background: #fff; font: inherit; font-weight: 400; outline: none; }
.contact-form textarea { resize: vertical; }
.contact-form input:focus, .contact-form select:focus, .contact-form textarea:focus { border-color: $brand; box-shadow: 0 0 0 3px rgba(4, 45, 134, .12); }
.contact-submit { display: inline-flex; align-items: center; justify-content: center; gap: .55rem; width: 100%; margin-top: 1.5rem; border: 0; border-radius: 7px; padding: .95rem 1.2rem; background: $brand; color: #fff; font: inherit; font-weight: 800; cursor: pointer; }
.contact-submit:disabled { cursor: wait; opacity: .65; }
.form-alert { margin-top: 1rem; padding: .8rem 1rem; border-radius: 7px; font-size: .9rem; line-height: 1.5; }
.form-alert.success { background: #dcfce7; color: #166534; }
.form-alert.error { background: #fee2e2; color: #991b1b; }
@media (max-width: 800px) { .contact-content { grid-template-columns: 1fr; gap: 3rem; padding-top: 3.5rem; } .contact-hero { padding-top: 5.5rem; } }
</style>