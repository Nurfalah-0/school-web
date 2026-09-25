<template>
  <div :class="['app-shell', { embedded }]">
    <!-- ===== SIDEBAR ===== -->
    <aside v-if="!embedded" :class="['sidebar', { open: sidebarOpen }]">
      <div class="sidebar-brand">
        <div class="brand-mark"><Palette :size="19" /></div>
        <div class="brand-text">
          <strong>Content Studio</strong>
          <span>SMK Nurul Jadid</span>
        </div>
        <button class="sidebar-close" @click="sidebarOpen = false"><X :size="18" /></button>
      </div>

      <nav class="sidebar-nav">
        <p class="nav-label">Jenis Konten</p>
        <button
          v-for="option in domains"
          :key="option.value"
          :class="['nav-item', { active: type === option.value }]"
          @click="selectDomain(option.value)"
        >
          <component :is="option.icon" :size="17" />
          <span class="nav-text">{{ option.label }}</span>
          <span v-if="records.length && type === option.value" class="nav-count">{{ records.length }}</span>
        </button>
      </nav>

      <div class="sidebar-footer">
        <router-link to="/admin/manage" class="nav-item"><ArrowLeft :size="17" /> <span class="nav-text">Pusat Admin</span></router-link>
        <button class="nav-item quit" @click="logout"><LogOut :size="17" /> <span class="nav-text">Keluar</span></button>
      </div>
    </aside>

    <div v-if="!embedded && sidebarOpen" class="sidebar-overlay" @click="sidebarOpen = false"></div>

    <!-- ===== MAIN AREA ===== -->
    <div class="main-area">
      <header v-if="!embedded" class="topbar">
        <div class="topbar-left">
          <button class="hamburger" @click="sidebarOpen = true"><Menu :size="20" /></button>
          <div>
            <h1 class="topbar-title">{{ currentDomain.label }}</h1>
            <p class="topbar-date">{{ currentDomain.description }}</p>
          </div>
        </div>
        <div class="topbar-actions">
          <button class="theme-toggle" type="button" :aria-label="currentTheme === 'dark' ? 'Gunakan mode terang' : 'Gunakan mode gelap'" :title="currentTheme === 'dark' ? 'Mode terang' : 'Mode gelap'" @click="toggleTheme">
            <Sun v-if="currentTheme === 'dark'" :size="16" />
            <Moon v-else :size="16" />
          </button>
          <button class="btn btn-outline btn-sm" @click="load"><RotateCw :size="14" /> Refresh</button>
        </div>
      </header>

      <!-- Toast -->
      <transition name="toast">
        <div v-if="notice" :class="['toast', noticeType]">
          <CheckCircle2 v-if="noticeType === 'success'" :size="18" />
          <XCircle v-else :size="18" />
          <span>{{ notice }}</span>
          <button class="toast-close" @click="notice = ''">&times;</button>
        </div>
      </transition>

      <main class="content">
        <div class="workspace">
          <!-- ============ FORM EDITOR ============ -->
          <section class="card editor">
            <div class="card-head">
              <div :class="['card-head-icon', currentDomain.iconColor]">
                <component :is="form.id ? Edit2 : Plus" :size="18" />
              </div>
              <div>
                <h3>{{ form.id ? 'Ubah Data' : 'Tambah Data Baru' }}</h3>
                <p>{{ form.id ? 'Perubahan tersimpan setelah klik Simpan.' : 'Lengkapi formulir lalu simpan.' }}</p>
              </div>
              <button v-if="form.id" class="btn btn-ghost btn-sm head-action" @click="reset">Batal</button>
            </div>

            <form class="form-grid" @submit.prevent="save">
              <div class="form-group">
                <label>{{ currentDomain.nameLabel }} <em>*</em></label>
                <input v-model="form.name" required :placeholder="currentDomain.namePlaceholder" />
              </div>

              <div class="form-group">
                <label>{{ currentDomain.categoryLabel }}</label>
                <input v-model="form.category" :placeholder="currentDomain.categoryPlaceholder" />
              </div>

              <div v-if="type === 'achievements'" class="form-group">
                <label>Tanggal Prestasi</label>
                <input v-model="form.achieved_at" type="date" />
              </div>

              <!-- Mitra Industri -->
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

              <!-- Lowongan Kerja -->
              <template v-if="type === 'job_vacancies'">
                <div class="form-group">
                  <label>Nama Perusahaan <em>*</em></label>
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
                  <input v-model="form.salary" placeholder="Rp 4.500.000 - Rp 6.000.000 / Kompetitif" />
                </div>
                <div class="form-group">
                  <label>Batas Akhir Lamaran</label>
                  <input v-model="form.deadline" type="date" />
                </div>
              </template>

              <!-- Produk TEFA -->
              <template v-if="type === 'products'">
                <div class="form-group">
                  <label>Harga Produk (Rp)</label>
                  <input v-model.number="form.price" type="number" min="0" placeholder="150000" />
                </div>
                <div class="form-group">
                  <label>Stok Tersedia</label>
                  <input v-model.number="form.stock" type="number" min="0" placeholder="25" />
                </div>
                <div class="form-group full product-options-editor">
                  <div class="field-heading">
                    <label>Pilihan Produk <small class="hint">(opsional)</small></label>
                    <button class="btn btn-outline btn-xs" type="button" @click="addOptionGroup"><Plus :size="13" /> Tambah Pilihan</button>
                  </div>
                  <p class="hint">Contoh: Warna → Merah, Biru, Hitam. Pisahkan nilainya dengan koma.</p>
                  <div v-for="(option, index) in form.pilihan" :key="index" class="option-row">
                    <input v-model="option.name" placeholder="Nama pilihan: Warna" />
                    <input v-model="option.values" placeholder="Nilai: Merah, Biru, Hitam" />
                    <button class="btn btn-danger-soft btn-xs" type="button" @click="removeOptionGroup(index)"><Trash2 :size="13" /></button>
                  </div>
                </div>
              </template>

              <div class="form-group">
                <label>Status Publikasi</label>
                <select v-model="form.status">
                  <option value="published">Dipublikasikan</option>
                  <option value="draft">Draft</option>
                  <option value="archived">Diarsipkan</option>
                </select>
              </div>

              <div class="form-group">
                <label>Slug URL (opsional)</label>
                <input v-model="form.slug" placeholder="otomatis-dibuat-jika-kosong" />
              </div>

              <div class="form-group full">
                <label>Deskripsi Lengkap</label>
                <textarea v-model="form.description" rows="4" placeholder="Tuliskan keterangan detail di sini…"></textarea>
              </div>

              <div class="form-group full">
                <label>{{ type === 'industry_partners' ? 'Logo Perusahaan' : 'Foto / Gambar' }}</label>
                <input type="file" accept="image/*" @change="form.image = $event.target.files[0]" />
              </div>

              <div class="form-footer full">
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="form.id" />
                  <Plus :size="15" v-else />
                  {{ form.id ? 'Simpan Perubahan' : 'Tambah ke Database' }}
                </button>
                <button v-if="form.id" class="btn btn-outline" type="button" @click="reset">Batal</button>
              </div>
            </form>
          </section>

          <!-- ============ RECORDS LIST ============ -->
          <section class="records-col">
            <div class="records-header">
              <div>
                <h2>Daftar {{ currentDomain.label }}</h2>
                <p class="records-desc">{{ records.length }} data tersimpan — klik Edit untuk mengubah.</p>
              </div>
            </div>

            <div v-if="records.length" class="record-list">
              <article v-for="record in records" :key="record.id" class="record-card">
                <div v-if="record.image_url || record.logo_url || record.image || record.logo" class="record-thumb">
                  <img :src="contentImageUrl(record.image_url || record.logo_url || record.image || record.logo)" :alt="displayName(record)" />
                </div>
                <div v-else class="record-thumb empty-thumb">
                  <component :is="currentDomain.icon" :size="24" />
                </div>

                <div class="record-info">
                  <div class="record-badge-row">
                    <span class="badge-soft">{{ record.category || record.industry_type || record.employment_type || 'Umum' }}</span>
                    <span :class="['status-pill', record.status === 'published' ? 'status-approved' : 'status-pending']">
                      {{ record.status || 'published' }}
                    </span>
                  </div>
                  <h3>{{ displayName(record) }}</h3>
                  <time v-if="type === 'achievements' && (record.achieved_at || record.year)" class="record-date">
                    <Calendar :size="12" /> {{ formatContentDate(record.achieved_at || `${record.year}-01-01`) }}
                  </time>
                  <p>{{ record.description || record.short_description || 'Belum ada deskripsi' }}</p>
                  <div v-if="type === 'products' && record.price" class="price-tag">
                    <Banknote :size="14" /> Rp {{ Number(record.price).toLocaleString('id-ID') }}
                  </div>
                </div>

                <div class="record-actions">
                  <button class="btn btn-outline btn-xs" @click="edit(record)"><Edit2 :size="13" /> Edit</button>
                  <button class="btn btn-danger-soft btn-xs" @click="remove(record.id)"><Trash2 :size="13" /> Hapus</button>
                </div>
              </article>
            </div>

            <div v-else class="empty-state card">
              <Inbox :size="36" />
              <p>Belum ada data pada kategori ini.</p>
              <span class="hint">Gunakan formulir di sebelah kiri untuk menambah yang pertama.</span>
            </div>
          </section>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue';
import { useRouter } from 'vue-router';
import {
  ArrowLeft, Menu, X, LogOut, Search, Inbox, Calendar,
  Trophy, Camera, Building2, Briefcase, ShoppingBag, Palette,
  Edit2, Plus, Save, RotateCw, Trash2, Banknote,
  CheckCircle2, XCircle, Sun, Moon
} from 'lucide-vue-next';
import { createAdminContent, deleteAdminContent, getAdminContent, updateAdminContent } from '../../../api/endpoints';

const props = defineProps({
  initialType: { type: String, default: 'achievements' },
  embedded: { type: Boolean, default: false },
});

const router = useRouter();
const API_BASE = (import.meta.env.VITE_API_URL || 'http://localhost:8000/api').replace(/\/api\/?$/, '');
const type = ref(props.initialType);
const records = ref([]);
const notice = ref('');
const noticeType = ref('success');
const sidebarOpen = ref(false);
const currentTheme = ref('light');

function applyTheme(preferredTheme) {
  const savedTheme = preferredTheme || localStorage.getItem('admin_theme');
  const theme = savedTheme || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
  currentTheme.value = theme === 'dark' ? 'dark' : 'light';
  document.querySelectorAll('.app-shell').forEach((shell) => {
    shell.setAttribute('data-theme', currentTheme.value);
  });
}

function toggleTheme() {
  applyTheme(currentTheme.value === 'dark' ? 'light' : 'dark');
  localStorage.setItem('admin_theme', currentTheme.value);
}

const domains = [
  { value: 'achievements', label: 'Prestasi Siswa', icon: Trophy, iconColor: 'soft-amber', description: 'Capaian lomba & penghargaan siswa', nameLabel: 'Judul Prestasi', namePlaceholder: 'Contoh: Juara 1 LKS Web Tech 2024', categoryLabel: 'Kategori Lomba', categoryPlaceholder: 'Tingkat Nasional / Provinsi' },
  { value: 'galleries', label: 'Galeri Foto', icon: Camera, iconColor: 'soft-blue', description: 'Dokumentasi kegiatan sekolah', nameLabel: 'Judul Foto / Kegiatan', namePlaceholder: 'Contoh: Kunjungan Industri PT Telkom', categoryLabel: 'Kategori Album', categoryPlaceholder: 'Kegiatan Siswa, Workshop' },
  { value: 'industry_partners', label: 'Mitra Industri', icon: Building2, iconColor: 'soft-green', description: 'Perusahaan yang bekerja sama dengan sekolah', nameLabel: 'Nama Perusahaan', namePlaceholder: 'Contoh: PT Astra Honda Motor', categoryLabel: 'Bidang Industri', categoryPlaceholder: 'Teknologi Informasi, Otomotif' },
  { value: 'job_vacancies', label: 'Lowongan Kerja', icon: Briefcase, iconColor: 'soft-violet', description: 'Info kerja & magang dari mitra', nameLabel: 'Posisi Lowongan', namePlaceholder: 'Contoh: Junior Web Developer', categoryLabel: 'Keahlian / Jurusan', categoryPlaceholder: 'RPL, TKJ' },
  { value: 'products', label: 'Produk TEFA', icon: ShoppingBag, iconColor: 'soft-red', description: 'Produk & jasa yang dijual sekolah', nameLabel: 'Nama Produk / Jasa', namePlaceholder: 'Contoh: Jasa Pembuatan Website Profil', categoryLabel: 'Kategori Produk', categoryPlaceholder: 'Software, Hardware, Merchandise' },
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
  achieved_at: '',
  image: null,
});

const currentDomain = computed(() => domains.find(item => item.value === type.value) || domains[0]);

function contentImageUrl(value) {
  if (!value) return '';
  if (/^https?:\/\//i.test(value)) return value;
  const path = String(value).replace(/^\/+/, '').replace(/^storage\/+/, '');
  return `${API_BASE}/storage/${path}`;
}

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
  sidebarOpen.value = false;
  await load();
}

function displayName(record) {
  return record.title || record.name || record.company_name || '-';
}

function formatContentDate(value) {
  if (!value) return '-';
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? value : date.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
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
    achieved_at: '',
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
    achieved_at: record.achieved_at || '',
    image: null,
  });
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function buildPayload() {
  const data = new FormData();
  const nameField = type.value === 'industry_partners' ? 'company_name' : type.value === 'products' ? 'name' : 'title';
  data.append(nameField, form.name);
  if (form.category) data.append(type.value === 'industry_partners' ? 'industry_type' : 'category', form.category);
  if (form.slug) data.append('slug', form.slug);
  if (form.description) data.append('description', form.description);
  if (type.value === 'achievements' && form.achieved_at) data.append('achieved_at', form.achieved_at);
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

onMounted(() => {
  applyTheme();
  load();
});

watch(() => props.initialType, async (value) => {
  if (value === type.value) return;
  type.value = value;
  reset();
  await load();
});
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

/* ===== Token warna — sama persis dengan Pusat Admin ===== */
.app-shell {
  --bg: #f4f6f9;
  --surface: #ffffff;
  --surface-subtle: #fbfcfe;
  --surface-muted: #f9fafc;
  --surface-soft: #eef1f5;
  --surface-hover: #f8fafd;
  --border: #e4e8ee;
  --border-strong: #d3d9e2;
  --border-subtle: #f0f3f7;
  --text: #1b2434;
  --text-2: #515d6f;
  --text-3: #8a94a5;
  --placeholder: #a5aeba;
  --empty-thumb: #c3cbd7;
  --accent: #2e63e7;
  --accent-hover: #1f4fc4;
  --accent-soft: #ecf1fe;
  --green: #1d9e62;
  --green-soft: #e6f6ee;
  --amber: #d98a06;
  --amber-soft: #fdf3e0;
  --red: #d64545;
  --red-soft: #fdeeee;
  --violet: #7c3aed;
  --violet-soft: #f1eafd;
  --green-strong: #157a4c;
  --amber-strong: #a36a04;
  --red-strong: #b03636;
  --focus-ring: rgba(46, 99, 231, 0.14);
  --shadow-card: 0 1px 3px rgba(27, 36, 52, 0.05);
  --shadow-float: 0 8px 30px rgba(27, 36, 52, 0.14);
  --sidebar-bg: #10192b;
  --sidebar-border: rgba(255, 255, 255, 0.07);
  --sidebar-w: 262px;

  display: block;
  min-height: 100vh;
  background: var(--bg);
  color: var(--text);
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: 14px;
  line-height: 1.5;
  color-scheme: light;
  -webkit-font-smoothing: antialiased;
}

.app-shell.embedded {
  min-height: auto;
  background: transparent;
}

.embedded .main-area {
  margin-left: 0;
  min-height: auto;
}

.embedded .content {
  padding: 0;
}

.app-shell[data-theme="dark"] {
  --bg: #0f141b;
  --surface: #161d27;
  --surface-subtle: #1b2430;
  --surface-muted: #1e2834;
  --surface-soft: #222d3a;
  --surface-hover: #202b38;
  --border: #242d3a;
  --border-strong: #344252;
  --border-subtle: #2b3542;
  --text: #edf2f7;
  --text-2: #b6c1cf;
  --text-3: #8e9baa;
  --placeholder: #778493;
  --empty-thumb: #536171;
  --accent: #6f9af5;
  --accent-hover: #8aafff;
  --accent-soft: rgba(111, 154, 245, 0.18);
  --green: #55c58e;
  --green-soft: rgba(85, 197, 142, 0.16);
  --amber: #e5aa45;
  --amber-soft: rgba(229, 170, 69, 0.16);
  --red: #ef7777;
  --red-soft: rgba(239, 119, 119, 0.16);
  --violet: #b18aff;
  --violet-soft: rgba(177, 138, 255, 0.16);
  --green-strong: #75dbaa;
  --amber-strong: #f0bd68;
  --red-strong: #ff9a9a;
  --focus-ring: rgba(111, 154, 245, 0.24);
  --shadow-card: 0 1px 4px rgba(0, 0, 0, 0.32);
  --shadow-float: 0 10px 34px rgba(0, 0, 0, 0.46);
  color-scheme: dark;
}

.app-shell,
.main-area,
.topbar,
.card,
.record-card,
.empty-state,
input,
textarea,
select,
option {
  transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease;
}

/* ================= SIDEBAR ================= */
.sidebar {
  position: fixed;
  inset: 0 auto 0 0;
  width: var(--sidebar-w);
  background: var(--sidebar-bg);
  display: flex;
  flex-direction: column;
  z-index: 200;
}

.sidebar-brand {
  display: flex;
  align-items: center;
  gap: 11px;
  padding: 20px 18px;
  border-bottom: 1px solid var(--sidebar-border);
}

.brand-mark {
  width: 38px;
  height: 38px;
  flex-shrink: 0;
  border-radius: 10px;
  background: var(--accent);
  color: #fff;
  display: grid;
  place-items: center;
}

.brand-text { display: flex; flex-direction: column; line-height: 1.25; }
.brand-text strong { color: #fff; font-size: 14.5px; font-weight: 700; letter-spacing: -0.01em; }
.brand-text span { color: #7c8aa3; font-size: 11.5px; }

.sidebar-close {
  margin-left: auto;
  background: transparent;
  border: 0;
  color: #7c8aa3;
  cursor: pointer;
  display: none;
  padding: 4px;
}

.sidebar-nav {
  flex: 1;
  overflow-y: auto;
  padding: 16px 12px;
}

.nav-label {
  margin: 0 10px 8px;
  color: #5d6b84;
  font-size: 10.5px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1.1px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  min-height: 40px;
  padding: 9px 11px;
  margin-bottom: 2px;
  border: 0;
  border-radius: 8px;
  background: transparent;
  color: #9aa7bd;
  font: inherit;
  font-size: 13.5px;
  font-weight: 500;
  text-align: left;
  text-decoration: none;
  cursor: pointer;
  transition: background 0.12s ease, color 0.12s ease;
}

.nav-item:hover { background: rgba(255, 255, 255, 0.06); color: #e6ebf3; }

.nav-item.active {
  background: rgba(46, 99, 231, 0.18);
  color: #fff;
  font-weight: 600;
}
.nav-item.active svg { color: #7ba3f5; }

.nav-text { flex: 1; }

.nav-count {
  min-width: 22px;
  text-align: center;
  background: rgba(255, 255, 255, 0.1);
  color: #b9c4d6;
  border-radius: 99px;
  padding: 2px 7px;
  font-size: 11px;
  font-weight: 600;
}
.nav-item.active .nav-count { background: var(--accent); color: #fff; }

.nav-item.quit { color: #c98a8a; }
.nav-item.quit:hover { background: rgba(214, 69, 69, 0.14); color: #f3b8b8; }

.sidebar-footer {
  padding: 12px;
  border-top: 1px solid var(--sidebar-border);
}

.sidebar-overlay {
  position: fixed;
  inset: 0;
  background: rgba(16, 25, 43, 0.5);
  z-index: 190;
}

/* ================= MAIN / TOPBAR ================= */
.main-area {
  margin-left: var(--sidebar-w);
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 14px 28px;
  background: var(--surface);
  backdrop-filter: blur(8px);
  border-bottom: 1px solid var(--border);
}

.topbar-left { display: flex; align-items: center; gap: 14px; }

.hamburger {
  display: none;
  background: transparent;
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 7px;
  color: var(--text-2);
  cursor: pointer;
}

.topbar-title { margin: 0; font-size: 17px; font-weight: 700; letter-spacing: -0.015em; }
.topbar-date { margin: 0; color: var(--text-3); font-size: 12px; }

.topbar-actions { display: flex; align-items: center; gap: 8px; }

.theme-toggle {
  display: inline-grid;
  place-items: center;
  width: 34px;
  height: 34px;
  padding: 0;
  border: 1px solid var(--border-strong);
  border-radius: 8px;
  background: var(--surface);
  color: var(--text-2);
  cursor: pointer;
  transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease;
}
.theme-toggle:hover { color: var(--accent); border-color: var(--accent); background: var(--accent-soft); }

.content {
  flex: 1;
  width: 100%;
  max-width: 1360px;
  margin: 0 auto;
  padding: 26px 28px 64px;
}

/* ================= TOAST ================= */
.toast {
  position: fixed;
  top: 18px;
  right: 18px;
  z-index: 500;
  display: flex;
  align-items: center;
  gap: 10px;
  max-width: 380px;
  padding: 13px 16px;
  border-radius: 10px;
  background: var(--surface);
  border: 1px solid var(--border);
  box-shadow: var(--shadow-float);
  font-size: 13.5px;
}

.toast.success { color: var(--green); }
.toast.error { color: var(--red); }
.toast span { color: var(--text); }

.toast-close {
  margin-left: auto;
  background: transparent;
  border: 0;
  color: var(--text-3);
  font-size: 18px;
  line-height: 1;
  cursor: pointer;
}

.toast-enter-active, .toast-leave-active { transition: all 0.25s ease; }
.toast-enter-from, .toast-leave-to { opacity: 0; transform: translateX(24px); }

/* ================= BUTTONS ================= */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  height: 38px;
  padding: 0 16px;
  border: 1px solid transparent;
  border-radius: 8px;
  font: inherit;
  font-size: 13.5px;
  font-weight: 600;
  white-space: nowrap;
  cursor: pointer;
  text-decoration: none;
  transition: background 0.12s ease, border-color 0.12s ease, color 0.12s ease;
}

.btn-sm { height: 34px; padding: 0 13px; font-size: 13px; }
.btn-xs { height: 28px; padding: 0 10px; font-size: 12px; border-radius: 6px; }

.btn-primary { background: var(--accent); color: #fff; }
.btn-primary:hover { background: var(--accent-hover); }

.btn-outline { background: var(--surface); border-color: var(--border-strong); color: var(--text-2); }
.btn-outline:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-soft); }

.btn-ghost { background: transparent; color: var(--text-2); }
.btn-ghost:hover { background: var(--surface-soft); color: var(--text); }

.btn-danger-soft { background: var(--red-soft); color: var(--red); }
.btn-danger-soft:hover { background: var(--red-soft); }

/* ================= CARD ================= */
.card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  box-shadow: var(--shadow-card);
}

.card-head {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 18px 22px;
  border-bottom: 1px solid var(--border);
  background: var(--surface-subtle);
}

.card-head h3 { margin: 0; font-size: 15px; font-weight: 700; letter-spacing: -0.01em; }
.card-head p { margin: 2px 0 0; color: var(--text-3); font-size: 12.5px; }

.card-head-icon {
  width: 36px;
  height: 36px;
  flex-shrink: 0;
  border-radius: 9px;
  display: grid;
  place-items: center;
}

.soft-blue { background: var(--accent-soft); color: var(--accent); }
.soft-green { background: var(--green-soft); color: var(--green); }
.soft-amber { background: var(--amber-soft); color: var(--amber); }
.soft-violet { background: var(--violet-soft); color: var(--violet); }
.soft-red { background: var(--red-soft); color: var(--red); }

.head-action { margin-left: auto; }

/* ================= LAYOUT WORKSPACE ================= */
.workspace {
  display: grid;
  grid-template-columns: minmax(340px, 0.85fr) minmax(400px, 1.15fr);
  gap: 22px;
  align-items: start;
}

.editor { position: sticky; top: 86px; }

.records-col { min-width: 0; }

.records-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 12px;
  flex-wrap: wrap;
  padding: 2px 4px 16px;
}

.records-header h2 { margin: 0; font-size: 16px; font-weight: 700; letter-spacing: -0.01em; }
.records-desc { margin: 3px 0 0; color: var(--text-3); font-size: 12.5px; }

/* ================= FORM ================= */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px 16px;
  padding: 20px 22px;
}

.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group.full, .form-footer.full { grid-column: 1 / -1; }

.form-group label { display: inline-flex; align-items: baseline; gap: 3px; font-size: 12.5px; font-weight: 600; color: var(--text-2); }
.form-group label em { color: var(--red); font-style: normal; }

.hint { color: var(--text-3); font-size: 12px; }

input, textarea, select {
  box-sizing: border-box;
  width: 100%;
  border: 1px solid var(--border-strong);
  border-radius: 8px;
  padding: 9px 12px;
  background: var(--surface);
  color: var(--text);
  font: inherit;
  font-size: 13.5px;
  transition: border-color 0.12s ease, box-shadow 0.12s ease;
}

option { background: var(--surface); color: var(--text); }

textarea { resize: vertical; }

input:focus, textarea:focus, select:focus {
  outline: none;
  border-color: var(--accent);
  box-shadow: 0 0 0 3px var(--focus-ring);
}

input::placeholder, textarea::placeholder { color: var(--placeholder); }

.form-footer {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  padding: 14px 22px;
  margin: 5px -22px -20px;
  border-top: 1px solid var(--border);
  background: var(--surface-subtle);
}

.field-heading {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
}

.product-options-editor { background: var(--surface-muted); border: 1px dashed var(--border-strong); border-radius: 10px; padding: 14px 16px; gap: 10px; }
.product-options-editor input { background: var(--surface); }

.option-row { display: grid; grid-template-columns: 1fr 1.4fr auto; gap: 8px; align-items: center; }

/* ================= RECORD LIST ================= */
.record-list { display: grid; gap: 12px; }

.record-card {
  display: flex;
  gap: 14px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 14px 16px;
  box-shadow: var(--shadow-card);
  transition: box-shadow 0.15s ease, border-color 0.15s ease;
}

.record-card:hover { border-color: var(--accent); box-shadow: var(--shadow-float); }

.record-thumb {
  width: 86px;
  height: 86px;
  border-radius: 9px;
  overflow: hidden;
  background: var(--surface-soft);
  flex-shrink: 0;
}

.record-thumb img { width: 100%; height: 100%; object-fit: cover; }

.empty-thumb { display: grid; place-items: center; color: var(--empty-thumb); }

.record-info { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 4px; }

.record-badge-row { display: flex; align-items: center; gap: 7px; flex-wrap: wrap; }

.badge-soft {
  display: inline-block;
  background: var(--surface-soft);
  color: var(--text-2);
  border-radius: 6px;
  padding: 2px 8px;
  font-size: 11.5px;
  font-weight: 600;
}

.status-pill {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  border-radius: 99px;
  padding: 2px 9px;
  font-size: 11.5px;
  font-weight: 600;
  text-transform: capitalize;
  white-space: nowrap;
}

.status-pill::before {
  content: '';
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: currentColor;
}

.status-approved { background: var(--green-soft); color: var(--green-strong); }
.status-pending { background: var(--amber-soft); color: var(--amber-strong); }

.record-info h3 {
  margin: 2px 0 0;
  font-size: 14.5px;
  font-weight: 700;
  letter-spacing: -0.01em;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
}

.record-date {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  color: var(--accent);
  font-size: 12px;
  font-weight: 600;
}

.record-info p {
  font-size: 12.5px;
  color: var(--text-3);
  margin: 0;
  line-height: 1.45;
  display: -webkit-box;
  line-clamp: 2;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.price-tag {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 13px;
  font-weight: 700;
  color: var(--green);
  margin-top: 2px;
}

.record-actions {
  display: flex;
  flex-direction: column;
  gap: 6px;
  justify-content: center;
  flex-shrink: 0;
}

/* ================= EMPTY STATE ================= */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 52px 20px;
  color: var(--text-3);
  text-align: center;
}
.empty-state p { margin: 0; font-size: 13.5px; font-weight: 600; color: var(--text-2); }

/* ================= RESPONSIVE ================= */
@media (max-width: 1024px) {
  .sidebar { transform: translateX(-100%); transition: transform 0.22s ease; }
  .sidebar.open { transform: translateX(0); }
  .sidebar-close { display: block; }
  .main-area { margin-left: 0; }
  .hamburger { display: grid; place-items: center; }
  .workspace { grid-template-columns: 1fr; }
  .editor { position: static; }
}

@media (max-width: 768px) {
  .topbar { padding: 12px 16px; }
  .content { padding: 18px 16px 56px; }
  .form-grid { grid-template-columns: 1fr; }
  .option-row { grid-template-columns: 1fr; }
  .record-card { flex-wrap: wrap; }
  .record-thumb { width: 100%; height: 150px; }
  .record-actions { flex-direction: row; width: 100%; justify-content: flex-end; }
  .record-info { flex-basis: calc(100% - 100px); }
}
</style>