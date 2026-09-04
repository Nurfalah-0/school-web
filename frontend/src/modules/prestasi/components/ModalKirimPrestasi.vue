<template>
  <div v-if="open" class="modal-overlay" @click.self="$emit('update:open', false)">
    <div class="modal-card">
      <div class="modal-header">
        <h3 class="modal-title">Kirim Prestasi</h3>
        <button type="button" class="modal-close" @click="$emit('update:open', false)">
          <X :size="20" color="#64748b" />
        </button>
      </div>

      <form class="modal-form" @submit.prevent="handleSubmit">
        <div class="form-group">
          <label class="form-label">Nama Siswa</label>
          <input v-model="form.nama" type="text" class="form-input" placeholder="Nama lengkap siswa" required />
        </div>

        <div class="form-group">
          <label class="form-label">Kelas / Jurusan</label>
          <input v-model="form.kelas" type="text" class="form-input" placeholder="Contoh: XII RPL 1" required />
        </div>

        <div class="form-group">
          <label class="form-label">Judul Prestasi</label>
          <input v-model="form.judul" type="text" class="form-input" placeholder="Judul prestasi" required />
        </div>

        <div class="form-group">
          <label class="form-label">Kategori</label>
          <select v-model="form.kategori" class="form-input" required>
            <option value="" disabled>Pilih kategori</option>
            <option value="akademik">Akademik</option>
            <option value="non-akademik">Non-Akademik</option>
            <option value="seni-budaya">Seni & Budaya</option>
            <option value="olahraga">Olahraga</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Deskripsi</label>
          <textarea v-model="form.deskripsi" class="form-input" rows="4" placeholder="Ceritakan prestasimu..." required></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Bukti / Sertifikat (opsional)</label>
          <input v-model="form.bukti" type="text" class="form-input" placeholder="URL gambar atau link drive" />
        </div>

        <p v-if="message" :class="['form-message', messageType]">{{ message }}</p>

        <button type="submit" class="form-submit" :disabled="loading">
          {{ loading ? 'Mengirim...' : 'Kirim Prestasi' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { X } from 'lucide-vue-next'

const props = defineProps({
  open: {
    type: Boolean,
    default: false
  }
})

defineEmits(['update:open', 'submit'])

const loading = ref(false)
const message = ref('')
const messageType = ref('success')

const form = reactive({
  nama: '',
  kelas: '',
  judul: '',
  kategori: '',
  deskripsi: '',
  bukti: ''
})

watch(() => props.open, (val) => {
  if (!val) {
    Object.assign(form, {
      nama: '',
      kelas: '',
      judul: '',
      kategori: '',
      deskripsi: '',
      bukti: ''
    })
    message.value = ''
    loading.value = false
  }
})

async function handleSubmit() {
  loading.value = true
  message.value = ''
  messageType.value = 'success'

  try {
    const res = await fetch('/api/prestasi/submit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ...form })
    })

    const data = await res.json()
    if (!res.ok) throw new Error(data.message || 'Gagal mengirim')

    message.value = 'Prestasi berhasil dikirim! Tim kami akan meninjau sebelum ditampilkan.'
    Object.assign(form, {
      nama: '',
      kelas: '',
      judul: '',
      kategori: '',
      deskripsi: '',
      bukti: ''
    })
    setTimeout(() => {
      props.open && (props.open = false)
    }, 1500)
  } catch (err) {
    message.value = err.message || 'Gagal mengirim. Coba lagi nanti.'
    messageType.value = 'error'
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.6);
  display: grid;
  place-items: center;
  padding: 1.5rem;
  z-index: 100;
}

.modal-card {
  background: #ffffff;
  border-radius: 1.5rem;
  width: 100%;
  max-width: 32rem;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 24px 48px rgba(15, 23, 42, 0.18);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.modal-title {
  font-family: 'Plus Jakarta Sans', system-ui, sans-serif;
  font-weight: 800;
  font-size: 1.25rem;
  color: #0f172a;
  margin: 0;
}

.modal-close {
  width: 2.25rem;
  height: 2.25rem;
  display: grid;
  place-items: center;
  border: none;
  border-radius: 9999px;
  background: #f1f5f9;
  cursor: pointer;
}

.modal-form {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-label {
  font-size: 0.9rem;
  font-weight: 700;
  color: #0f172a;
}

.form-input {
  padding: 0.85rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 0.75rem;
  background: #f8fafc;
  color: #0f172a;
  font-size: 0.95rem;
  outline: none;
  transition: border-color 0.2s ease;
}

.form-input:focus {
  border-color: #1e3a8a;
}

.form-message {
  font-size: 0.9rem;
  margin: 0;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
}

.form-message.success {
  background: #dcfce7;
  color: #166534;
}

.form-message.error {
  background: #fee2e2;
  color: #991b1b;
}

.form-submit {
  padding: 1rem;
  border: none;
  border-radius: 9999px;
  background: #1e3a8a;
  color: #ffffff;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.form-submit:hover:not(:disabled) {
  background: #16264d;
}

.form-submit:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}
</style>
