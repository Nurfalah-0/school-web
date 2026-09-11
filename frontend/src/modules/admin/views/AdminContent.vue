<template>
  <div class="content-page">
    <header class="page-header">
      <div>
        <p class="eyebrow">Content Studio</p>
        <h1>Pengelolaan Konten Website</h1>
        <p class="subtitle">Kelola prestasi siswa, galeri kegiatan, mitra industri, lowongan kerja, dan produk TEFA dari satu tempat.</p>
      </div>
      <div class="actions">
        <router-link class="button secondary" to="/admin/manage"><ArrowLeft :size="15" /> Pusat Admin</router-link>
        <router-link class="button secondary" to="/admin/dashboard"><LayoutDashboard :size="15" /> Dashboard</router-link>
        <button class="button danger" @click="logout"><LogOut :size="15" /> Keluar</button>
      </div>
    </header>

    <!-- Domain Navigator -->
    <nav class="domain-nav">
      <button
        v-for="option in domains"
        :key="option.value"
        :class="['domain-button', { active: type === option.value }]"
        @click="selectDomain(option.value)"
      >
        <component :is="option.icon" :size="16" /> {{ option.label }}
        <span v-if="records.length && type === option.value" class="badge">{{ records.length }}</span>
      </button>
    </nav>

    <!-- Notice -->
    <transition name="fade">
      <p v-if="notice" :class="['notice', noticeType]">{{ notice }}</p>
    </transition>

    <main class="workspace">
      <!-- Form Editor -->
      <section class="editor">
        <div class="section-title">
          <div>
            <p class="eyebrow">{{ currentDomain.label }}</p>
            <h2>
              <component :is="form.id ? Edit2 : Plus" :size="20" style="vertical-align: middle; margin-right: 4px;" />
              {{ form.id ? 'Edit Data' : 'Tambah Data Baru' }}
            </h2>
          </div>
          <button v-if="form.id" class="button secondary small" @click="reset">Batal</button>
        </div>

        <form class="form-grid" @submit.prevent="save">
          <!-- Primary Name / Title -->
          <div class="form-group">
            <label>{{ currentDomain.nameLabel }} <span class="req">*</span></label>
            <input v-model="form.name" required :placeholder="currentDomain.namePlaceholder" />
          </div>

          <!-- Category / Type -->
          <div class="form-group">
            <label>{{ currentDomain.categoryLabel }}</label>
            <input v-model="form.category" :placeholder="currentDomain.categoryPlaceholder" />
          </div>

          <!-- Specific Fields for Partners -->
          <template v-if="type === 'industry_partners'">
            <div class="form-group">
              <label>Website Perusahaan</label>
              <input v-model="form.website" placeholder="https://perusahaan.com" />
            </div>
            <div class="form-group">
              <label>Alamat / Lokasi</label>
              <input v-model="form.address" placeholder="Kota / Alamat Kantor" />
            </div>
          </template>

          <!-- Specific Fields for Jobs -->
          <template v-if="type === 'job_vacancies'">
            <div class="form-group">
              <label>Nama Perusahaan <span class="req">*</span></label>
              <input v-model="form.company_name" required placeholder="PT. Mitra Sejahtera" />
            </div>
            <div class="form-group">
              <label>Tipe Pekerjaan</label>
              <select v-model="form.employment_type">
                <option value="Full Time">Full Time</option>
                <option value="Part Time">Part Time</option>
                <option value="Magang / Internship">Magang / Internship</option>
                <option value="Kontrak">Kontrak</option>
              </select>
            </div>
            <div class="form-group">
              <label>Estimasi Gaji / Benefit</label>
              <input v-model="form.salary" placeholder="Contoh: Rp 4.500.000 - Rp 6.000.000 / Kompetitif" />
            </div>
            <div class="form-group">
              <label>Batas Akhir Lamaran</label>
              <input v-model="form.deadline" type="date" />
            </div>
          </template>

          <!-- Specific Fields for Products -->
          <template v-if="type === 'products'">
            <div class="form-group">
              <label>Harga Produk (Rp)</label>
              <input v-model.number="form.price" type="number" min="0" placeholder="Contoh: 150000" />
            </div>
            <div class="form-group">
              <label>Stok Tersedia</label>
              <input v-model.number="form.stock" type="number" min="0" placeholder="Contoh: 25" />
            </div>
            <div class="form-group full-width product-options-editor">
              <div class="field-heading">
                <label>Pilihan Produk <small>(Opsional)</small></label>
                <button class="button secondary small" type="button" @click="addOptionGroup">+ Tambah Pilihan</button>
              </div>
              <p class="field-help">Tambahkan pilihan seperti Warna, Ukuran, Bahan, atau pilihan lain. Pisahkan nilainya dengan koma.</p>
              <div v-for="(option, index) in form.pilihan" :key="index" class="product-option-row">
                <input v-model="option.name" placeholder="Nama pilihan, contoh: Warna" />
                <input v-model="option.values" placeholder="Nilai, contoh: Merah, Biru, Hitam" />
                <button class="button small danger" type="button" @click="removeOptionGroup(index)">Hapus</button>
              </div>
            </div>
          </template>

          <!-- Status & Slug -->
          <div class="form-group">
            <label>Status Publikasi</label>
            <select v-model="form.status">
              <option value="published">Dipublikasikan (Published)</option>
              <option value="draft">Draft</option>
              <option value="archived">Diarsipkan</option>
            </select>
          </div>

          <div class="form-group">
            <label>Slug URL (Opsional)</label>
            <input v-model="form.slug" placeholder="otomatis-dibuat-jika-kosong" />
          </div>

          <!-- Description -->
          <div class="form-group full-width">
            <label>Deskripsi Lengkap</label>
            <textarea v-model="form.description" rows="4" placeholder="Tuliskan keterangan detail di sini..."></textarea>
          </div>

          <!-- Image Upload -->
          <div class="form-group full-width">
            <label>{{ type === 'industry_partners' ? 'Logo Perusahaan' : 'Foto / Gambar' }}</label>
            <input type="file" accept="image/*" @change="form.image = $event.target.files[0]" />
          </div>

          <div class="form-actions full-width">
            <button class="button primary" type="submit">
              <Save :size="15" v-if="form.id" />
              <Plus :size="15" v-else />
              {{ form.id ? 'Simpan Perubahan' : 'Tambah ke Database' }}
            </button>
            <button v-if="form.id" class="button secondary" type="button" @click="reset">Batal</button>
          </div>
        </form>
      </section>

      <!-- Records List -->
      <section class="records">
        <div class="section-title">
          <div>
            <p class="eyebrow">Database Live</p>
            <h2>Daftar {{ currentDomain.label }}</h2>
          </div>
          <button class="button secondary small" @click="load"><RotateCw :size="13" /> Refresh</button>
        </div>

        <div v-if="records.length" class="record-list">
          <article v-for="record in records" :key="record.id" class="record-card">
            <div v-if="record.image_url || record.logo_url || record.image || record.logo" class="record-thumb">
              <img :src="record.image_url || record.logo_url || ('/storage/' + (record.image || record.logo))" :alt="displayName(record)" />
            </div>
            <div class="record-info">
              <div class="record-badge-row">
                <span class="cat-badge">{{ record.category || record.industry_type || record.employment_type || 'Umum' }}</span>
                <span :class="['status-dot', record.status === 'published' ? 'published' : 'draft']">
                  {{ record.status || 'published' }}
                </span>
              </div>
              <h3>{{ displayName(record) }}</h3>
              <p>{{ record.description || record.short_description || 'Belum ada deskripsi' }}</p>
              <div v-if="type === 'products' && record.price" class="price-tag">
                <Banknote :size="14" style="vertical-align: middle; margin-right: 4px;" />Rp {{ Number(record.price).toLocaleString('id-ID') }}
              </div>
            </div>
            <div class="record-actions">
              <button class="button small secondary" @click="edit(record)"><Edit2 :size="13" /> Edit</button>
              <button class="button small danger" @click="remove(record.id)"><Trash2 :size="13" /> Hapus</button>
            </div>
          </article>
        </div>
        <p v-else class="empty">Belum ada data pada kategori ini.</p>
      </section>
    </main>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import {
  ArrowLeft,
  LayoutDashboard,
  LogOut,
  Trophy,
  Camera,
  Building2,
  Briefcase,
  ShoppingBag,
  Edit2,
  Plus,
  Save,
  RotateCw,
  Trash2,
  Banknote
} from 'lucide-vue-next';
import { createAdminContent, deleteAdminContent, getAdminContent, updateAdminContent } from '../../../api/endpoints';

const router = useRouter();
const type = ref('achievements');
const records = ref([]);
const notice = ref('');
const noticeType = ref('success');

const domains = [
  { value: 'achievements', label: 'Prestasi Siswa', icon: Trophy, nameLabel: 'Judul Prestasi', namePlaceholder: 'Contoh: Juara 1 LKS Web Tech 2024', categoryLabel: 'Kategori Lomba', categoryPlaceholder: 'Tingkat Nasional / Provinsi' },
  { value: 'galleries', label: 'Galeri Foto', icon: Camera, nameLabel: 'Judul Foto / Kegiatan', namePlaceholder: 'Contoh: Kunjungan Industri PT Telkom', categoryLabel: 'Kategori Album', categoryPlaceholder: 'Kegiatan Siswa, Workshop' },
  { value: 'industry_partners', label: 'Mitra Industri', icon: Building2, nameLabel: 'Nama Perusahaan', namePlaceholder: 'Contoh: PT Astra Honda Motor', categoryLabel: 'Bidang Industri', categoryPlaceholder: 'Teknologi Informasi, Otomotif' },
  { value: 'job_vacancies', label: 'Lowongan Kerja', icon: Briefcase, nameLabel: 'Posisi Lowongan', namePlaceholder: 'Contoh: Junior Web Developer', categoryLabel: 'Keahlian / Jurusan', categoryPlaceholder: 'RPL, TKJ' },
  { value: 'products', label: 'Produk TEFA', icon: ShoppingBag, nameLabel: 'Nama Produk / Jasa', namePlaceholder: 'Contoh: Jasa Pembuatan Website Profil', categoryLabel: 'Kategori Produk', categoryPlaceholder: 'Software, Hardware, Merchandise' },
];

const form = reactive({
  id: null,
  name: '',
  category: '',
  company_name: '',
  employment_type: 'Full Time',
  salary: '',
  deadline: '',
  price: null,
  stock: null,
  pilihan: [],
  website: '',
  address: '',
  slug: '',
  status: 'published',
  description: '',
  image: null,
});

const currentDomain = computed(() => domains.find(item => item.value === type.value) || domains[0]);

function notify(text, kind = 'success') {
  notice.value = text;
  noticeType.value = kind;
  window.setTimeout(() => { notice.value = ''; }, 4000);
}

function errorMessage(error) {
  const err = Object.values(error.response?.data?.errors || {}).flat().join(' ');
  const message = err || error.response?.data?.message || '';
  const isDatabaseError = /SQLSTATE|General error|insert into|update .* set/i.test(message);
  notify(isDatabaseError ? 'Data gagal disimpan. Periksa kembali isian lalu coba lagi.' : (message || 'Perubahan gagal disimpan.'), 'error');
}

async function load() {
  try {
    const response = await getAdminContent(type.value);
    records.value = response.data?.data || response.data || [];
  } catch (error) { errorMessage(error); }
}

async function selectDomain(value) {
  type.value = value;
  reset();
  await load();
}

function displayName(record) {
  return record.title || record.name || record.company_name || '-';
}

function reset() {
  Object.assign(form, {
    id: null,
    name: '',
    category: '',
    company_name: '',
    employment_type: 'Full Time',
    salary: '',
    deadline: '',
    price: null,
    stock: null,
    pilihan: [],
    website: '',
    address: '',
    slug: '',
    status: 'published',
    description: '',
    image: null,
  });
}

function edit(record) {
  Object.assign(form, {
    id: record.id,
    name: displayName(record),
    category: record.category || record.industry_type || record.employment_type || '',
    company_name: record.company_name || '',
    employment_type: record.employment_type || 'Full Time',
    salary: record.salary || '',
    deadline: record.deadline ? record.deadline.substring(0, 10) : '',
    price: record.price || null,
    stock: record.stock || null,
    pilihan: normalizeOptions(record.options),
    website: record.website || '',
    address: record.address || '',
    slug: record.slug || '',
    status: record.status || 'published',
    description: record.description || record.short_description || '',
    image: null,
  });
  window.scrollTo({ top: 120, behavior: 'smooth' });
}

function buildPayload() {
  const data = new FormData();
  const nameField = type.value === 'industry_partners' ? 'company_name' : type.value === 'products' ? 'name' : 'title';
  data.append(nameField, form.name);
  if (form.category) data.append(type.value === 'industry_partners' ? 'industry_type' : 'category', form.category);
  if (form.slug) data.append('slug', form.slug);
  if (form.description) data.append('description', form.description);
  if (form.status) data.append('status', form.status);

  if (type.value === 'job_vacancies') {
    if (form.company_name) data.append('company_name', form.company_name);
    if (form.employment_type) data.append('employment_type', form.employment_type);
    if (form.salary) data.append('salary', form.salary);
    if (form.deadline) data.append('deadline', form.deadline);
  }

  if (type.value === 'industry_partners') {
    if (form.website) data.append('website', form.website);
    if (form.address) data.append('address', form.address);
    if (form.image) data.append('logo', form.image);
  } else {
    if (form.image) data.append('image', form.image);
  }

  if (type.value === 'products') {
    if (form.price !== null && form.price !== '') {
      data.append('price', form.price);
      data.append('base_price', form.price);
    }
    if (form.stock !== null && form.stock !== '') data.append('stock', form.stock);
    const options = form.pilihan
      .map(option => ({ name: option.name.trim(), values: option.values.split(',').map(value => value.trim()).filter(Boolean) }))
      .filter(option => option.name && option.values.length);
    data.append('options', JSON.stringify(options));
  }

  return data;
}

function normalizeOptions(options) {
  if (typeof options === 'string') {
    try { options = JSON.parse(options); } catch { options = []; }
  }
  return Array.isArray(options)
    ? options.map(option => ({ name: option.name || '', values: Array.isArray(option.values) ? option.values.join(', ') : (option.values || '') }))
    : [];
}

function addOptionGroup() {
  form.pilihan.push({ name: '', values: '' });
}

function removeOptionGroup(index) {
  form.pilihan.splice(index, 1);
}

async function save() {
  try {
    const data = buildPayload();
    if (form.id) {
      await updateAdminContent(type.value, form.id, data);
      notify('Konten berhasil diperbarui.');
    } else {
      await createAdminContent(type.value, data);
      notify('Konten baru berhasil ditambahkan.');
    }
    reset();
    await load();
  } catch (error) { errorMessage(error); }
}

async function remove(id) {
  if (!window.confirm('Hapus item konten ini?')) return;
  try {
    await deleteAdminContent(type.value, id);
    notify('Konten berhasil dihapus.');
    await load();
  } catch (error) { errorMessage(error); }
}

function logout() {
  localStorage.removeItem('auth_token');
  sessionStorage.removeItem('auth_token');
  router.push('/login');
}

onMounted(load);
</script>

<style scoped>
.content-page {
  min-height: 100vh;
  padding: 36px clamp(16px, 4vw, 64px);
  background: #f4f6fa;
  color: #0f172a;
  font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
}

.page-header {
  max-width: 1320px;
  margin: 0 auto 28px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

.eyebrow {
  margin: 0 0 6px;
  color: #1e3a8a;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

h1 {
  margin: 0 0 8px;
  font-size: clamp(26px, 3.5vw, 40px);
  font-weight: 800;
  color: #0f172a;
}

h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
  color: #1e293b;
}

.subtitle {
  color: #64748b;
  margin: 0;
  font-size: 14px;
}

.actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  border: 0;
  border-radius: 8px;
  padding: 10px 16px;
  font: inherit;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  text-decoration: none;
  transition: all 0.15s ease;
}

.button.primary { background: #1e3a8a; color: #fff; }
.button.primary:hover { background: #16264d; }
.button.secondary { background: #e2e8f0; color: #334155; }
.button.secondary:hover { background: #cbd5e1; }
.button.danger { background: #fee2e2; color: #b91c1c; }
.button.danger:hover { background: #fecaca; }
.button.small { padding: 6px 10px; font-size: 12px; }

/* Domain Navigator */
.domain-nav {
  max-width: 1320px;
  margin: 0 auto 24px;
  display: flex;
  gap: 8px;
  overflow-x: auto;
  border-bottom: 2px solid #e2e8f0;
  padding-bottom: 2px;
}

.domain-button {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  border: 0;
  border-bottom: 3px solid transparent;
  background: transparent;
  padding: 12px 18px;
  color: #64748b;
  font: inherit;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.15s ease;
}

.domain-button:hover { color: #1e3a8a; }
.domain-button.active {
  border-color: #1e3a8a;
  color: #1e3a8a;
}

.domain-button .badge {
  background: #e0e7ff;
  color: #1e3a8a;
  border-radius: 9999px;
  padding: 2px 7px;
  font-size: 11px;
}

/* Notice */
.notice {
  max-width: 1320px;
  margin: 0 auto 20px;
  padding: 12px 18px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
}

.notice.success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
.notice.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

/* Workspace */
.workspace {
  max-width: 1320px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: minmax(320px, 0.8fr) minmax(380px, 1.2fr);
  gap: 24px;
}

.editor, .records {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
}

.section-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

/* Form */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-group.full-width, .form-actions.full-width {
  grid-column: 1 / -1;
}

.form-group label {
  font-size: 12px;
  font-weight: 700;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.req { color: #dc2626; }

input, textarea, select {
  box-sizing: border-box;
  width: 100%;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  padding: 10px 12px;
  color: #0f172a;
  background: #ffffff;
  font: inherit;
  font-size: 14px;
}

input:focus, textarea:focus, select:focus {
  outline: 2px solid #bae6fd;
  border-color: #0284c7;
}

.form-actions {
  display: flex;
  gap: 8px;
  margin-top: 8px;
}

/* Records */
.record-list {
  display: grid;
  gap: 14px;
}

.record-card {
  display: flex;
  gap: 16px;
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  padding: 16px;
  background: #fff;
  transition: all 0.15s ease;
}

.record-card:hover {
  border-color: #cbd5e1;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.05);
}

.record-thumb {
  width: 90px;
  height: 90px;
  border-radius: 8px;
  overflow: hidden;
  background: #f1f5f9;
  flex-shrink: 0;
}

.record-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.record-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.record-badge-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.cat-badge {
  font-size: 11px;
  font-weight: 700;
  background: #f1f5f9;
  color: #334155;
  padding: 2px 7px;
  border-radius: 4px;
}

.status-dot {
  font-size: 11px;
  font-weight: 700;
  text-transform: capitalize;
}

.status-dot.published { color: #059669; }
.status-dot.draft { color: #64748b; }

.record-info h3 {
  margin: 2px 0 4px;
  font-size: 16px;
  color: #0f172a;
}

.record-info p {
  font-size: 13px;
  color: #64748b;
  margin: 0;
  line-height: 1.4;
}

.price-tag {
  font-size: 13px;
  font-weight: 700;
  color: #0284c7;
  margin-top: 4px;
}

.record-actions {
  display: flex;
  flex-direction: column;
  gap: 6px;
  justify-content: center;
  flex-shrink: 0;
}

.empty {
  text-align: center;
  color: #94a3b8;
  padding: 40px 0;
}

@media (max-width: 900px) {
  .workspace { grid-template-columns: 1fr; }
  .record-card { flex-direction: column; }
  .record-actions { flex-direction: row; justify-content: flex-end; }
}
</style>
