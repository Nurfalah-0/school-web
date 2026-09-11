<template>
  <div class="admin-page">
    <!-- Header -->
    <header class="admin-header">
      <div class="header-title-wrap">
        <p class="eyebrow">SMK Nurul Jadid</p>
        <h1>Pusat Pengelolaan Admin</h1>
        <p class="subtitle">Kelola pendaftaran PPDB, data siswa, jurusan &amp; fasilitas, berita, gambar website, kategori, akun admin, dan profil sekolah.</p>
      </div>
      <div class="header-actions">
        <router-link to="/admin/dashboard" class="button secondary"><LayoutDashboard :size="15" /> Dashboard</router-link>
        <router-link to="/admin/content" class="button secondary"><Palette :size="15" /> Content Studio</router-link>
        <router-link to="/" class="button secondary"><Globe :size="15" /> Lihat Web</router-link>
        <button class="button danger" @click="logout"><LogOut :size="15" /> Keluar</button>
      </div>
    </header>

    <!-- Navigation Tabs -->
    <nav class="tabs" aria-label="Menu pengelolaan">
      <button
        v-for="tab in tabs"
        :key="tab.id"
        :class="['tab', { active: activeTab === tab.id }]"
        @click="activeTab = tab.id"
      >
        <component :is="tab.icon" :size="16" />
        {{ tab.label }}
        <span v-if="tab.count !== ''" class="tab-badge">{{ tab.count }}</span>
      </button>
    </nav>

    <!-- Notification / Alert -->
    <transition name="fade">
      <div v-if="message" :class="['notice', messageType]">
        <span>{{ message }}</span>
        <button class="notice-close" @click="message = ''">&times;</button>
      </div>
    </transition>

    <!-- ============================================= -->
    <!-- TAB 1: PENDAFTARAN PPDB                       -->
    <!-- ============================================= -->
    <section v-if="activeTab === 'applications'" class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">PPDB Online</p>
          <h2>Data Pendaftaran Siswa Baru</h2>
        </div>
        <div class="heading-controls">
          <input
            v-model="appFilter.search"
            type="text"
            placeholder="Cari nama, NISN, no daftar..."
            class="search-input"
            @input="filterApplications"
          />
          <select v-model="appFilter.status" class="filter-select" @change="filterApplications">
            <option value="">Semua Status</option>
            <option value="pending">Menunggu (Pending)</option>
            <option value="verifikasi">Verifikasi</option>
            <option value="diterima">Diterima</option>
            <option value="ditolak">Ditolak</option>
          </select>
          <button class="button secondary" @click="loadApplications"><RotateCw :size="13" /> Refresh</button>
        </div>
      </div>

      <form class="schedule-card" @submit.prevent="savePpdbSchedule">
        <div>
          <p class="eyebrow">Jadwal Pendaftaran</p>
          <h3>Atur waktu buka dan tutup PPDB</h3>
          <p class="schedule-help">Tombol pendaftaran aktif hanya di antara dua waktu ini.</p>
        </div>
        <div class="schedule-fields">
          <label class="form-group">
            <span>Mulai pendaftaran</span>
            <input v-model="ppdbSchedule.registration_start" type="datetime-local" required />
          </label>
          <label class="form-group">
            <span>Selesai pendaftaran</span>
            <input v-model="ppdbSchedule.registration_end" type="datetime-local" required />
          </label>
          <button class="button primary" type="submit"><Save :size="15" /> Simpan Jadwal</button>
        </div>
      </form>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>No. Daftar</th>
              <th>Nama Siswa</th>
              <th>NISN</th>
              <th>Pilihan Jurusan</th>
              <th>Tgl Daftar</th>
              <th>Status</th>
              <th class="applications-action-column">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in filteredApplications" :key="item.id">
              <td><code>{{ item.no_pendaftaran || '-' }}</code></td>
              <td>
                <strong>{{ item.nama || item.name }}</strong>
                <small v-if="item.email">{{ item.email }}</small>
                <small v-if="item.phone">{{ item.phone }}</small>
              </td>
              <td>{{ item.nisn || '-' }}</td>
              <td><span class="badge-jurusan">{{ item.program || '-' }}</span></td>
              <td>{{ item.created_at ? formatDate(item.created_at) : '-' }}</td>
              <td>
                <span :class="['status-pill', getStatusClass(item.status)]">
                  {{ item.status_label || item.status }}
                </span>
              </td>
              <td class="actions applications-actions">
                <button class="button small secondary" @click="viewAppDetail(item)">Detail</button>
                <button
                  v-if="item.status !== 'diterima' && item.status !== 'Disetujui'"
                  class="button small success"
                  @click="changeStatus(item, 'Disetujui')"
                >Terima</button>
                <button
                  v-if="item.status !== 'ditolak' && item.status !== 'Ditolak'"
                  class="button small warning"
                  @click="changeStatus(item, 'Ditolak')"
                >Tolak</button>
                <button class="button small danger" @click="removeApplication(item.id)">Hapus</button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-if="!filteredApplications.length" class="empty">Tidak ada data pendaftaran yang sesuai filter.</p>
      </div>
    </section>

    <!-- ============================================= -->
    <!-- TAB 2: DATA SISWA                             -->
    <!-- ============================================= -->
    <section v-else-if="activeTab === 'students'" class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">Akademik</p>
          <h2>{{ studentForm.id ? 'Edit Data Siswa' : 'Kelola Data Siswa' }}</h2>
        </div>
        <button class="button primary" @click="resetStudent">
          <Plus :size="15" />
          {{ studentForm.id ? 'Batal & Siswa Baru' : 'Tambah Siswa Baru' }}
        </button>
      </div>

      <!-- Form Tambah/Edit Siswa -->
      <form class="form-grid" @submit.prevent="saveStudent">
        <div class="form-group">
          <label>NISN</label>
          <input v-model="studentForm.nisn" placeholder="Nomor Induk Siswa Nasional" />
        </div>
        <div class="form-group">
          <label>NIS <span class="req">*</span></label>
          <input v-model="studentForm.nis" required placeholder="Nomor Induk Sekolah" />
        </div>
        <div class="form-group">
          <label>Nama Lengkap <span class="req">*</span></label>
          <input v-model="studentForm.name" required placeholder="Nama lengkap siswa" />
        </div>
        <div class="form-group">
          <label>Email Siswa</label>
          <input v-model="studentForm.email" type="email" placeholder="contoh@email.com" />
        </div>
        <div class="form-group">
          <label>No. Telepon / WhatsApp</label>
          <input v-model="studentForm.phone" placeholder="08xxxxxxxxxx" />
        </div>
        <div class="form-group">
          <label>Kelas <span class="req">*</span></label>
          <input v-model="studentForm.class" required placeholder="Contoh: X RPL 1, XI TKRO 2" />
        </div>
        <div class="form-group">
          <label>Jenis Kelamin</label>
          <select v-model="studentForm.gender">
            <option value="">Pilih Jenis Kelamin</option>
            <option value="Laki-laki">Laki-laki</option>
            <option value="Perempuan">Perempuan</option>
          </select>
        </div>
        <div class="form-group">
          <label>Jurusan <span class="req">*</span></label>
          <select v-model.number="studentForm.major_id" required>
            <option :value="null">Pilih Jurusan</option>
            <option v-for="major in majors" :key="major.id" :value="major.id">{{ major.name }}</option>
          </select>
        </div>
        <div class="form-group full-width">
          <label>Alamat Lengkap</label>
          <textarea v-model="studentForm.address" placeholder="Alamat tempat tinggal siswa"></textarea>
        </div>
        <div class="form-actions full-width">
          <button class="button primary" type="submit">
            <Save :size="15" v-if="studentForm.id" />
            <Plus :size="15" v-else />
            {{ studentForm.id ? 'Simpan Perubahan Siswa' : 'Tambahkan Siswa' }}
          </button>
          <button v-if="studentForm.id" class="button secondary" type="button" @click="resetStudent">
            Batal
          </button>
        </div>
      </form>

      <!-- Search & Filter Siswa -->
      <div class="list-toolbar">
        <input
          v-model="studentSearch"
          type="text"
          placeholder="Cari siswa berdasarkan nama, NIS, kelas..."
          class="search-input"
        />
        <select v-model.number="studentMajorFilter" class="filter-select">
          <option :value="null">Semua Jurusan</option>
          <option v-for="m in majors" :key="m.id" :value="m.id">{{ m.name }}</option>
        </select>
      </div>

      <!-- Table Siswa -->
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Nama Siswa</th>
              <th>NISN / NIS</th>
              <th>Jurusan</th>
              <th>Kelas</th>
              <th>Kontak</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in filteredStudents" :key="item.id">
              <td>
                <strong>{{ item.name }}</strong>
                <small>{{ item.gender || '-' }}</small>
              </td>
              <td>{{ item.nisn || '-' }} / {{ item.nis || '-' }}</td>
              <td><span class="badge-jurusan">{{ item.major?.name || majorName(item.major_id) }}</span></td>
              <td>{{ item.class || '-' }}</td>
              <td>
                <div>{{ item.phone || '-' }}</div>
                <small>{{ item.email || '-' }}</small>
              </td>
              <td class="actions">
                <button class="button small secondary" @click="editStudent(item)"><Edit2 :size="13" /> Edit</button>
                <button class="button small danger" @click="removeStudent(item.id)"><Trash2 :size="13" /> Hapus</button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-if="!filteredStudents.length" class="empty">Belum ada data siswa yang cocok.</p>
      </div>
    </section>

    <!-- ============================================= -->
    <!-- TAB 3: BERITA & PENGUMUMAN                    -->
    <!-- ============================================= -->
    <section v-else-if="activeTab === 'news'" class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">Publikasi</p>
          <h2>{{ newsForm.id ? 'Edit Berita' : 'Kelola Berita & Kegiatan' }}</h2>
        </div>
        <button class="button primary" @click="resetNews">
          <Plus :size="15" />
          {{ newsForm.id ? 'Batal & Buat Berita Baru' : 'Tulis Berita Baru' }}
        </button>
      </div>

      <!-- Form Berita -->
      <form class="form-grid" @submit.prevent="saveNews">
        <div class="form-group full-width">
          <label>Judul Berita <span class="req">*</span></label>
          <input v-model="newsForm.title" required placeholder="Judul artikel atau berita kegiatan" />
        </div>
        <div class="form-group">
          <label>Kategori Berita</label>
          <input v-model="newsForm.category" placeholder="Contoh: Prestasi, Kegiatan, Pengumuman, Akademik" />
        </div>
        <div class="form-group">
          <label>Foto Utama Berita</label>
          <input
            type="file"
            accept=".jpeg,.jpg,.png,.gif,.webp,image/*"
            @change="selectNewsImage"
          />
        </div>
        <div class="form-group full-width">
          <label>Ringkasan Singkat (Excerpt)</label>
          <div class="field-with-counter">
            <textarea v-model="newsForm.excerpt" maxlength="500" placeholder="Ringkasan isi berita untuk preview kartu"></textarea>
            <small>{{ (newsForm.excerpt || '').length }}/500 karakter</small>
          </div>
        </div>
        <div class="form-group full-width">
          <label>Isi Lengkap Berita <span class="req">*</span></label>
          <textarea v-model="newsForm.content" required rows="6" placeholder="Tuliskan isi lengkap artikel / berita di sini..."></textarea>
        </div>
        <div class="form-actions full-width">
          <button class="button primary" type="submit">
            <Save :size="15" v-if="newsForm.id" />
            <Send :size="15" v-else />
            {{ newsForm.id ? 'Simpan Perubahan Berita' : 'Terbitkan Berita' }}
          </button>
          <button v-if="newsForm.id" class="button secondary" type="button" @click="resetNews">Batal</button>
        </div>
      </form>

      <!-- List Berita -->
      <div class="news-grid-admin">
        <article v-for="item in news" :key="item.id" class="news-card-admin">
          <div class="news-thumb-wrap">
            <img :src="item.featured_image || item.gambarUtama || 'https://placehold.co/400x250?text=SMK+News'" :alt="item.title" />
            <span :class="['publish-badge', item.published !== false ? 'published' : 'draft']">
              <CheckCircle2 :size="12" v-if="item.published !== false" />
              <Clock :size="12" v-else />
              {{ item.published !== false ? 'Terbit' : 'Draft' }}
            </span>
          </div>
          <div class="news-card-body">
            <span class="news-cat">{{ item.category || 'Berita' }}</span>
            <h3>{{ item.title }}</h3>
            <p>{{ item.excerpt || (item.content ? item.content.substring(0, 120) + '...' : 'Tidak ada ringkasan') }}</p>
            <div class="news-card-footer">
              <small>{{ item.published_at ? formatDate(item.published_at) : 'Baru saja' }}</small>
              <div class="actions">
                <button class="button small secondary" @click="editNews(item)"><Edit2 :size="13" /> Edit</button>
                <button class="button small danger" @click="removeNews(item.id)"><Trash2 :size="13" /> Hapus</button>
              </div>
            </div>
          </div>
        </article>
      </div>
      <p v-if="!news.length" class="empty">Belum ada berita yang diterbitkan.</p>
    </section>

    <!-- ============================================= -->
    <!-- TAB 4: JURUSAN & FASILITAS                    -->
    <!-- ============================================= -->
    <section v-else-if="activeTab === 'majors'" class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">Program Keahlian</p>
          <h2>{{ majorForm.id ? 'Edit Jurusan' : 'Kelola Jurusan & Fasilitas' }}</h2>
        </div>
        <button class="button primary" @click="resetMajor">
          <Plus :size="15" />
          {{ majorForm.id ? 'Batal & Jurusan Baru' : 'Tambah Jurusan Baru' }}
        </button>
      </div>

      <!-- Form Jurusan -->
      <form class="form-grid" @submit.prevent="saveMajor">
        <div class="form-group">
          <label>Kode Jurusan <span class="req">*</span></label>
          <input v-model="majorForm.code" required placeholder="Contoh: RPL, TKRO, TBSM, TKJ, AKL" />
        </div>
        <div class="form-group">
          <label>Nama Jurusan <span class="req">*</span></label>
          <input v-model="majorForm.name" required placeholder="Contoh: Rekayasa Perangkat Lunak" />
        </div>
        <div class="form-group">
          <label>Daya Tampung / Kapasitas Siswa</label>
          <input v-model.number="majorForm.capacity" type="number" min="0" placeholder="Contoh: 72" />
        </div>
        <div class="form-group">
          <label>Status Aktif</label>
          <select v-model="majorForm.is_active">
            <option :value="true">Aktif (Tampil di Website)</option>
            <option :value="false">Non-aktif</option>
          </select>
        </div>
        <div class="form-group">
          <label>Gambar Jurusan</label>
          <input type="file" accept="image/*" @change="onMajorImageSelected" />
        </div>
        <div class="form-group">
          <label>URL Gambar Alternatif</label>
          <input v-model="majorForm.image_url" placeholder="https://example.com/image.jpg" />
        </div>
        <div class="form-group full-width">
          <label>Deskripsi Singkat</label>
          <textarea v-model="majorForm.description" placeholder="Deskripsi umum program keahlian"></textarea>
        </div>
        <div class="form-group">
          <label>Visi Jurusan</label>
          <textarea v-model="majorForm.vision" placeholder="Visi kejuruan"></textarea>
        </div>
        <div class="form-group">
          <label>Misi Jurusan</label>
          <textarea v-model="majorForm.mission" placeholder="Misi kejuruan"></textarea>
        </div>
        <div class="form-actions full-width">
          <button class="button primary" type="submit">
            <Save :size="15" v-if="majorForm.id" />
            <Plus :size="15" v-else />
            {{ majorForm.id ? 'Simpan Perubahan Jurusan' : 'Tambah Jurusan' }}
          </button>
          <button v-if="majorForm.id" class="button secondary" type="button" @click="resetMajor">Batal</button>
        </div>
      </form>

      <!-- List Jurusan -->
      <div class="major-cards-grid">
        <div v-for="item in majors" :key="item.id" class="major-admin-card">
          <div class="major-card-header">
            <div>
              <span class="major-code-badge">{{ item.code }}</span>
              <h3>{{ item.name }}</h3>
            </div>
            <span :class="['status-pill', isMajorActive(item) ? 'status-approved' : 'status-rejected']">
              {{ isMajorActive(item) ? 'Aktif' : 'Non-aktif' }}
            </span>
          </div>
          <div v-if="item.image" class="major-image-preview">
            <img :src="item.image" :alt="item.name" />
          </div>
          <p class="major-desc">{{ item.description || 'Belum ada deskripsi jurusan.' }}</p>
          <div class="major-meta">
            <span><Users :size="14" style="vertical-align: middle; margin-right: 4px;" /> Kapasitas: <strong>{{ item.capacity || item.student_count || 0 }} Siswa</strong></span>
          </div>
          <div class="major-card-actions">
            <button class="button small primary" @click="openFacilityModal(item)"><Building2 :size="13" /> Kelola Fasilitas</button>
            <button class="button small secondary" @click="editMajor(item)"><Edit2 :size="13" /> Edit</button>
            <button class="button small danger" @click="removeMajor(item.id)"><Trash2 :size="13" /> Hapus</button>
          </div>
        </div>
      </div>
      <p v-if="!majors.length" class="empty">Belum ada data jurusan.</p>
    </section>

    <!-- ============================================= -->
    <!-- TAB 5: GAMBAR WEBSITE                         -->
    <!-- ============================================= -->
    <section v-else-if="activeTab === 'images'" class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">Visual Website</p>
          <h2>Kelola Gambar &amp; Banner Website</h2>
        </div>
        <div class="heading-controls">
          <select v-model="selectedSectionFilter" class="filter-select">
            <option value="">Semua Section</option>
            <option value="homepage">Homepage / Hero</option>
            <option value="about">Tentang Sekolah</option>
            <option value="facilities">Fasilitas</option>
            <option value="homepage_slider">Slider Homepage</option>
            <option value="ppdb">PPDB</option>
            <option value="contact">Kontak</option>
          </select>
        </div>
      </div>

      <!-- Upload/Edit Form Gambar -->
      <form class="form-grid" @submit.prevent="saveImage">
        <div class="form-group">
          <label>Section Website <span class="req">*</span></label>
          <select v-model="imageForm.section" required>
            <option value="">Pilih Section</option>
            <option value="homepage">Homepage / Hero</option>
            <option value="about">Tentang Sekolah / About</option>
            <option value="facilities">Fasilitas Sekolah</option>
            <option value="homepage_slider">Slider Banner</option>
            <option value="ppdb">Halaman PPDB</option>
            <option value="contact">Kontak & Lokasi</option>
          </select>
        </div>
        <div class="form-group">
          <label>Key Identifier <span class="req">*</span></label>
          <input v-model="imageForm.key" required placeholder="Contoh: hero_banner, about_image, facility_lab" />
        </div>
        <div class="form-group">
          <label>Judul Gambar <span class="req">*</span></label>
          <input v-model="imageForm.title" required placeholder="Judul gambar atau banner" />
        </div>
        <div class="form-group">
          <label>Alt Text / Deskripsi</label>
          <input v-model="imageForm.alt_text" placeholder="Teks alternatif untuk SEO & aksesibilitas" />
        </div>
        <div class="form-group">
          <label>Pilih File Gambar <span class="req" v-if="!imageForm.id">*</span></label>
          <input type="file" accept="image/*" :required="!imageForm.id" @change="imageForm.file = $event.target.files[0]" />
        </div>
        <div class="form-group">
          <label>Atau Gunakan URL Gambar (Opsional)</label>
          <input v-model="imageForm.image_url" placeholder="https://images.unsplash.com/..." />
        </div>
        <div class="form-actions full-width">
          <button class="button primary" type="submit">
            <Save :size="15" v-if="imageForm.id" />
            <Upload :size="15" v-else />
            {{ imageForm.id ? 'Simpan Perubahan Gambar' : 'Upload Gambar Website' }}
          </button>
          <button v-if="imageForm.id" class="button secondary" type="button" @click="resetImageForm">Batal</button>
        </div>
      </form>

      <!-- Grid Gambar -->
      <div class="image-grid">
        <article v-for="item in filteredImages" :key="item.id" class="image-item">
          <div class="image-preview-box">
            <img :src="item.image_url" :alt="item.alt_text || item.title" />
          </div>
          <div class="image-info">
            <strong>{{ item.title }}</strong>
            <span class="img-badge">{{ item.section }}</span>
            <small>Key: <code>{{ item.key }}</code></small>
          </div>
          <div class="image-actions">
            <button class="button small secondary" @click="editImage(item)"><Edit2 :size="13" /> Edit</button>
            <button class="button small danger" @click="removeImage(item.id)"><Trash2 :size="13" /> Hapus</button>
          </div>
        </article>
      </div>
      <p v-if="!filteredImages.length" class="empty">Tidak ada gambar pada section ini.</p>
    </section>

    <!-- ============================================= -->
    <!-- TAB 6: KATEGORI                              -->
    <!-- ============================================= -->
    <section v-else-if="activeTab === 'categories'" class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">Taksonomi</p>
          <h2>{{ categoryForm.id ? 'Edit Kategori' : 'Kelola Kategori Konten' }}</h2>
        </div>
        <button class="button primary" @click="resetCategory">
          <Plus :size="15" />
          {{ categoryForm.id ? 'Batal & Buat Kategori Baru' : 'Tambah Kategori Baru' }}
        </button>
      </div>

      <form class="form-grid" @submit.prevent="saveCategory">
        <div class="form-group">
          <label>Nama Kategori <span class="req">*</span></label>
          <input v-model="categoryForm.name" required placeholder="Contoh: Prestasi Nasional, Robotik, Magang" />
        </div>
        <div class="form-group">
          <label>Tipe Kategori <span class="req">*</span></label>
          <select v-model="categoryForm.type" required>
            <option value="news">Berita (news)</option>
            <option value="achievements">Prestasi (achievements)</option>
            <option value="galleries">Galeri (galleries)</option>
            <option value="products">Produk TEFA (products)</option>
            <option value="general">Umum (general)</option>
          </select>
        </div>
        <div class="form-actions full-width">
          <button class="button primary" type="submit">
            <Save :size="15" v-if="categoryForm.id" />
            <Plus :size="15" v-else />
            {{ categoryForm.id ? 'Simpan Kategori' : 'Tambah Kategori' }}
          </button>
          <button v-if="categoryForm.id" class="button secondary" type="button" @click="resetCategory">Batal</button>
        </div>
      </form>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Nama Kategori</th>
              <th>Slug</th>
              <th>Tipe</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="cat in categories" :key="cat.id">
              <td><strong>{{ cat.name }}</strong></td>
              <td><code>{{ cat.slug }}</code></td>
              <td><span class="badge-jurusan">{{ cat.type }}</span></td>
              <td><span class="status-pill status-approved">Aktif</span></td>
              <td class="actions">
                <button class="button small secondary" @click="editCategory(cat)"><Edit2 :size="13" /> Edit</button>
                <button class="button small danger" @click="removeCategory(cat.id)"><Trash2 :size="13" /> Hapus</button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-if="!categories.length" class="empty">Belum ada kategori yang ditambahkan.</p>
      </div>
    </section>

    <!-- ============================================= -->
    <!-- TAB 7: AKUN ADMIN & PENGGUNA                  -->
    <!-- ============================================= -->
    <section v-else-if="activeTab === 'users'" class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">Manajemen Akses</p>
          <h2>{{ userForm.id ? 'Edit Akun Pengguna' : 'Kelola Pengguna & Staf Admin' }}</h2>
        </div>
        <button class="button primary" @click="resetUser">
          <Plus :size="15" />
          {{ userForm.id ? 'Batal & Pengguna Baru' : 'Tambah Pengguna Baru' }}
        </button>
      </div>

      <!-- Form Pengguna -->
      <form class="form-grid" @submit.prevent="saveUser">
        <div class="form-group">
          <label>Nama Lengkap <span class="req">*</span></label>
          <input v-model="userForm.name" required placeholder="Nama staf / admin" />
        </div>
        <div class="form-group">
          <label>Email Pengguna <span class="req">*</span></label>
          <input v-model="userForm.email" required type="email" placeholder="admin@smknuruljadid.sch.id" />
        </div>
        <div class="form-group">
          <label>Password <span class="req" v-if="!userForm.id">*</span> <small v-if="userForm.id">(Kosongkan jika tidak diganti)</small></label>
          <input v-model="userForm.password" type="password" :required="!userForm.id" placeholder="Minimal 6 karakter" />
        </div>
        <div class="form-group">
          <label>No. Telepon</label>
          <input v-model="userForm.phone" placeholder="08xxxxxxxxxx" />
        </div>
        <div class="form-group">
          <label>Role Akses <span class="req">*</span></label>
          <select v-model="userForm.role" required>
            <option value="admin_sekolah">Admin Sekolah (Pengelola Web & Siswa)</option>
            <option value="superadmin">Superadmin (Akses Penuh)</option>
            <option value="ppdb">Panitia PPDB</option>
            <option value="tu_sekolah">Tata Usaha (TU)</option>
            <option value="bkk">BKK / Hubungan Industri</option>
          </select>
        </div>
        <div class="form-group">
          <label>Status Akun</label>
          <select v-model="userForm.is_active">
            <option :value="true">Aktif</option>
            <option :value="false">Nonaktif</option>
          </select>
        </div>
        <div class="form-actions full-width">
          <button class="button primary" type="submit">
            <Save :size="15" v-if="userForm.id" />
            <Plus :size="15" v-else />
            {{ userForm.id ? 'Simpan Perubahan Pengguna' : 'Buat Pengguna Baru' }}
          </button>
          <button v-if="userForm.id" class="button secondary" type="button" @click="resetUser">Batal</button>
        </div>
      </form>

      <!-- Table Users -->
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Nama Pengguna</th>
              <th>Email</th>
              <th>Role</th>
              <th>No. Telepon</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="u in usersList" :key="u.id">
              <td><strong>{{ u.name }}</strong></td>
              <td>{{ u.email }}</td>
              <td>
                <span class="role-badge">
                  {{ u.roles && u.roles.length ? u.roles.map(r => r.name).join(', ') : 'admin_sekolah' }}
                </span>
              </td>
              <td>{{ u.phone || '-' }}</td>
              <td>
                <span :class="['status-pill', u.is_active !== false ? 'status-approved' : 'status-rejected']">
                  {{ u.is_active !== false ? 'Aktif' : 'Nonaktif' }}
                </span>
              </td>
              <td class="actions">
                <button class="button small secondary" @click="editUser(u)"><Edit2 :size="13" /> Edit</button>
                <button class="button small danger" @click="removeUser(u.id)"><Trash2 :size="13" /> Hapus</button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-if="!usersList.length" class="empty">Belum ada data pengguna.</p>
      </div>
    </section>

    <!-- ============================================= -->
    <!-- TAB 8: PROFIL SEKOLAH                         -->
    <!-- ============================================= -->
    <section v-else class="panel">
      <div class="section-heading">
        <div>
          <p class="eyebrow">Identitas Sekolah</p>
          <h2>Kelola Profil &amp; Informasi Sekolah</h2>
        </div>
      </div>
      <form class="form-grid" @submit.prevent="saveProfile">
        <div class="form-group">
          <label>Nama Sekolah <span class="req">*</span></label>
          <input v-model="profileForm.school_name" required placeholder="SMK Nurul Jadid" />
        </div>
        <div class="form-group">
          <label>Nama Kepala Sekolah</label>
          <input v-model="profileForm.headmaster_name" placeholder="Nama Kepala Sekolah beserta gelar" />
        </div>
        <div class="form-group">
          <label>Email Resmi Sekolah</label>
          <input v-model="profileForm.email" type="email" placeholder="info@smknuruljadid.sch.id" />
        </div>
        <div class="form-group">
          <label>Nomor Telepon</label>
          <input v-model="profileForm.phone" placeholder="(0335) xxxxxxx" />
        </div>
        <div class="form-group">
          <label>Website Resmi</label>
          <input v-model="profileForm.website" placeholder="https://smknuruljadid.sch.id" />
        </div>
        <div class="form-group">
          <label>Tahun Berdiri</label>
          <input v-model.number="profileForm.founded_year" type="number" placeholder="1995" />
        </div>
        <div class="form-group full-width">
          <label>Alamat Sekolah</label>
          <textarea v-model="profileForm.address" placeholder="Alamat lengkap lokasi sekolah"></textarea>
        </div>
        <div class="form-group">
          <label>Visi Sekolah</label>
          <textarea v-model="profileForm.vision" rows="4" placeholder="Visi sekolah"></textarea>
        </div>
        <div class="form-group">
          <label>Misi Sekolah</label>
          <textarea v-model="profileForm.mission" rows="4" placeholder="Misi sekolah"></textarea>
        </div>
        <div class="form-actions full-width">
          <button class="button primary" type="submit"><Save :size="15" /> Simpan Profil Sekolah</button>
        </div>
      </form>
    </section>

    <!-- ============================================= -->
    <!-- MODAL: DETAIL PENDAFTARAN PPDB                -->
    <!-- ============================================= -->
    <div v-if="selectedApp" class="modal-overlay" @click.self="selectedApp = null">
      <div class="modal-card">
        <div class="modal-header">
          <div>
            <p class="eyebrow">Detail Pendaftaran</p>
            <h3>{{ selectedApp.nama || selectedApp.name }}</h3>
          </div>
          <button class="modal-close" @click="selectedApp = null">&times;</button>
        </div>
        <div class="modal-body">
          <div class="detail-grid">
            <div><span>No. Pendaftaran:</span> <strong>{{ selectedApp.no_pendaftaran || '-' }}</strong></div>
            <div><span>NISN:</span> <strong>{{ selectedApp.nisn || '-' }}</strong></div>
            <div><span>Pilihan Jurusan:</span> <strong class="badge-jurusan">{{ selectedApp.program || '-' }}</strong></div>
            <div><span>Jalur:</span> <strong>{{ selectedApp.jalur_pendaftaran || 'Reguler' }}</strong></div>
            <div><span>Email:</span> <strong>{{ selectedApp.email || '-' }}</strong></div>
            <div><span>No. Telepon / WA:</span> <strong>{{ selectedApp.phone || '-' }}</strong></div>
            <div><span>Asal Sekolah:</span> <strong>{{ selectedApp.asal_sekolah || '-' }}</strong></div>
            <div><span>Status:</span> <span :class="['status-pill', getStatusClass(selectedApp.status)]">{{ selectedApp.status_label || selectedApp.status }}</span></div>
            <div class="full-width"><span>Alamat:</span> <strong>{{ selectedApp.alamat || '-' }}</strong></div>
            <div class="full-width berkas-box">
              <span>Dokumen Pendaftaran:</span>
              <div class="document-links">
                <a
                  v-for="document in applicationDocuments"
                  :key="document.key"
                  v-if="selectedApp[`${document.key}_url`] || selectedApp[`${document.key}_path`]"
                  :href="selectedApp[`${document.key}_url`] || ('/storage/' + selectedApp[`${document.key}_path`])"
                  target="_blank"
                  rel="noopener"
                  class="button small secondary"
                >
                  <FileText :size="14" /> {{ document.label }}
                </a>
                <a
                  v-if="selectedApp.berkas_url || selectedApp.berkas_path"
                  :href="selectedApp.berkas_url || ('/storage/' + selectedApp.berkas_path)"
                  target="_blank"
                  rel="noopener"
                  class="button small secondary"
                >
                  <FileText :size="14" /> Berkas Lama
                </a>
                <span v-if="!hasApplicationDocuments" class="empty-document">Belum ada dokumen.</span>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="button success" @click="changeStatus(selectedApp, 'Disetujui'); selectedApp = null;"><CheckCircle2 :size="14" /> Setujui Pendaftaran</button>
          <button class="button warning" @click="changeStatus(selectedApp, 'Ditolak'); selectedApp = null;"><XCircle :size="14" /> Tolak Pendaftaran</button>
          <button class="button secondary" @click="selectedApp = null">Tutup</button>
        </div>
      </div>
    </div>

    <!-- ============================================= -->
    <!-- MODAL: KELOLA FASILITAS JURUSAN               -->
    <!-- ============================================= -->
    <div v-if="selectedMajorForFacility" class="modal-overlay" @click.self="selectedMajorForFacility = null">
      <div class="modal-card">
        <div class="modal-header">
          <div>
            <p class="eyebrow">Fasilitas Jurusan</p>
            <h3>{{ selectedMajorForFacility.name }} ({{ selectedMajorForFacility.code }})</h3>
          </div>
          <button class="modal-close" @click="selectedMajorForFacility = null">&times;</button>
        </div>
        <div class="modal-body">
          <!-- Form Tambah Fasilitas -->
          <form class="facility-form" @submit.prevent="saveFacility">
            <input v-model="facilityForm.name" required placeholder="Nama Fasilitas, contoh: Lab Komputer iMac" />
            <input v-model="facilityForm.description" placeholder="Deskripsi fasilitas" />
            <button class="button primary small" type="submit"><Plus :size="14" /> Tambah</button>
          </form>

          <!-- List Fasilitas -->
          <div class="facility-list">
            <h4>Daftar Fasilitas</h4>
            <div v-if="majorFacilities.length" class="facility-items">
              <div v-for="fac in majorFacilities" :key="fac.id" class="facility-item">
                <div>
                  <strong>{{ fac.name }}</strong>
                  <p>{{ fac.description || 'Tidak ada deskripsi' }}</p>
                </div>
                <button class="button small danger" @click="removeFacility(fac.id)"><Trash2 :size="13" /> Hapus</button>
              </div>
            </div>
            <p v-else class="empty">Belum ada fasilitas untuk jurusan ini.</p>
          </div>
        </div>
        <div class="modal-footer">
          <button class="button secondary" @click="selectedMajorForFacility = null">Tutup</button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import {
  LayoutDashboard,
  Palette,
  Globe,
  LogOut,
  ClipboardList,
  GraduationCap,
  Newspaper,
  School,
  Image as ImageIcon,
  Tag,
  Users,
  Settings,
  RotateCw,
  Plus,
  Save,
  Send,
  Upload,
  Edit2,
  Trash2,
  Building2,
  FileText,
  CheckCircle2,
  XCircle,
  Clock
} from 'lucide-vue-next';
import {
  createNews,
  createMajor,
  createSiteImage,
  createStudent,
  createCategory,
  createUser,
  deleteNews,
  deleteMajor,
  deleteSiteImage,
  deleteStudent,
  deleteRegistration,
  deleteCategory,
  deleteUser,
  getMajors,
  getMajorDetail,
  getNews,
  getRegistrations,
  getSiteImages,
  getSchoolProfile,
  getStudents,
  getCategories,
  getUsers,
  updateNews,
  uploadNewsImage,
  updateMajor,
  uploadMajorImage,
  updateRegistrationStatus,
  updateSchoolProfile,
  updateStudent,
  updateSiteImage,
  updateCategory,
  updateUser,
  getPpdbSchedule,
  updatePpdbSchedule,
  addMajorFacility,
  deleteMajorFacility,
  getRegistrationDetail,
} from '../../../api/endpoints';

const router = useRouter();
const activeTab = ref('applications');
const message = ref('');
const messageType = ref('success');

// Data state
const applications = ref([]);
const students = ref([]);
const news = ref([]);
const majors = ref([]);
const images = ref([]);
const categories = ref([]);
const usersList = ref([]);

// Modals
const selectedApp = ref(null);
const applicationDocuments = [
  { key: 'kk', label: 'Kartu Keluarga' },
  { key: 'ktp_ayah', label: 'KTP Ayah' },
  { key: 'ktp_ibu', label: 'KTP Ibu' },
  { key: 'akta_kelahiran', label: 'Akta Kelahiran' },
  { key: 'ijazah_menengah', label: 'Ijazah Menengah' },
  { key: 'dokumen_lain', label: 'Dokumen Lain' },
];
const selectedMajorForFacility = ref(null);
const majorFacilities = ref([]);
const facilityForm = reactive({ name: '', description: '' });

// Filter state
const appFilter = reactive({ search: '', status: '' });
const studentSearch = ref('');
const studentMajorFilter = ref(null);
const selectedSectionFilter = ref('');

// Forms
const newsForm = reactive({ id: null, title: '', category: '', excerpt: '', content: '', image: null });
const majorForm = reactive({ id: null, code: '', name: '', capacity: null, description: '', vision: '', mission: '', image: null, image_url: '', is_active: true });
const imageForm = reactive({ id: null, key: '', title: '', section: '', alt_text: '', image_url: '', file: null });
const studentForm = reactive({ id: null, nisn: '', nis: '', name: '', email: '', phone: '', class: '', gender: '', major_id: null, address: '' });
const profileForm = reactive({ school_name: '', email: '', phone: '', website: '', headmaster_name: '', founded_year: null, address: '', vision: '', mission: '' });
const categoryForm = reactive({ id: null, name: '', type: 'news' });
const userForm = reactive({ id: null, name: '', email: '', password: '', phone: '', role: 'admin_sekolah', is_active: true });
const ppdbSchedule = reactive({ registration_start: '', registration_end: '' });

// Tabs config
const tabs = computed(() => [
  { id: 'applications', label: 'Pendaftaran PPDB', icon: ClipboardList, count: applications.value.length },
  { id: 'students', label: 'Data Siswa', icon: GraduationCap, count: students.value.length },
  { id: 'news', label: 'Berita & Kegiatan', icon: Newspaper, count: news.value.length },
  { id: 'majors', label: 'Jurusan & Fasilitas', icon: School, count: majors.value.length },
  { id: 'images', label: 'Gambar Website', icon: ImageIcon, count: images.value.length },
  { id: 'categories', label: 'Kategori', icon: Tag, count: categories.value.length },
  { id: 'users', label: 'Pengguna & Admin', icon: Users, count: usersList.value.length },
  { id: 'profile', label: 'Profil Sekolah', icon: Settings, count: '' },
]);

// Filtered lists
const filteredApplications = computed(() => {
  return applications.value.filter(item => {
    const matchSearch = !appFilter.search ||
      (item.nama && item.nama.toLowerCase().includes(appFilter.search.toLowerCase())) ||
      (item.no_pendaftaran && item.no_pendaftaran.toLowerCase().includes(appFilter.search.toLowerCase())) ||
      (item.nisn && item.nisn.includes(appFilter.search));
    const matchStatus = !appFilter.status || item.status === appFilter.status;
    return matchSearch && matchStatus;
  });
});

const filteredStudents = computed(() => {
  return students.value.filter(item => {
    const search = studentSearch.value.toLowerCase();
    const matchSearch = !search ||
      (item.name && item.name.toLowerCase().includes(search)) ||
      (item.nis && item.nis.toLowerCase().includes(search)) ||
      (item.nisn && item.nisn.toLowerCase().includes(search)) ||
      (item.class && item.class.toLowerCase().includes(search));
    const matchMajor = !studentMajorFilter.value || item.major_id === studentMajorFilter.value || item.major?.id === studentMajorFilter.value;
    return matchSearch && matchMajor;
  });
});

const filteredImages = computed(() => {
  if (!selectedSectionFilter.value) return images.value;
  return images.value.filter(img => img.section === selectedSectionFilter.value);
});

function notify(text, type = 'success') {
  message.value = text;
  messageType.value = type;
  window.setTimeout(() => { message.value = ''; }, 4000);
}

function errorMessage(error) {
  const validationErrors = Object.values(error.response?.data?.errors || {}).flat().join(' ');
  notify(validationErrors || error.response?.data?.message || 'Terjadi kesalahan sistem.', 'error');
}

function formatDate(dateStr) {
  if (!dateStr) return '-';
  const d = new Date(dateStr);
  return d.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' });
}

function getStatusClass(status) {
  if (status === 'diterima' || status === 'Disetujui') return 'status-approved';
  if (status === 'ditolak' || status === 'Ditolak') return 'status-rejected';
  if (status === 'verifikasi') return 'status-verified';
  return 'status-pending';
}

function majorName(id) {
  return majors.value.find(m => m.id === id)?.name || '-';
}

function toDateTimeLocal(value) {
  if (!value) return '';
  const date = new Date(value);
  const pad = (number) => String(number).padStart(2, '0');
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

function toIsoString(value) {
  return value ? new Date(value).toISOString() : null;
}

// =============================================
// LOADERS
// =============================================
async function loadApplications() {
  try {
    const response = await getRegistrations();
    applications.value = response.data?.data?.data || response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadPpdbSchedule() {
  try {
    const response = await getPpdbSchedule();
    const schedule = response.data?.data || {};
    ppdbSchedule.registration_start = toDateTimeLocal(schedule.registration_start);
    ppdbSchedule.registration_end = toDateTimeLocal(schedule.registration_end);
  } catch (error) { errorMessage(error); }
}

async function loadStudents() {
  try {
    const response = await getStudents(1, 200);
    students.value = response.data?.data?.data || response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadNews() {
  try {
    const response = await getNews(1, 100);
    news.value = response.data?.data?.data || response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadMajors() {
  try {
    const response = await getMajors();
    majors.value = response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadImages() {
  try {
    const response = await getSiteImages();
    images.value = response.data?.data?.images || response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadCategories() {
  try {
    const response = await getCategories();
    categories.value = response.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadUsers() {
  try {
    const response = await getUsers();
    usersList.value = response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadProfile() {
  try {
    const response = await getSchoolProfile();
    Object.assign(profileForm, response.data?.data || {});
  } catch (error) { errorMessage(error); }
}

// =============================================
// PPDB ACTIONS
// =============================================
async function savePpdbSchedule() {
  try {
    await updatePpdbSchedule({
      registration_start: toIsoString(ppdbSchedule.registration_start),
      registration_end: toIsoString(ppdbSchedule.registration_end),
    });
    notify('Jadwal pendaftaran PPDB berhasil disimpan.');
  } catch (error) { errorMessage(error); }
}

const hasApplicationDocuments = computed(() => {
  if (!selectedApp.value) return false;
  return applicationDocuments.some(({ key }) => selectedApp.value[`${key}_url`] || selectedApp.value[`${key}_path`])
    || selectedApp.value.berkas_url || selectedApp.value.berkas_path;
});

async function viewAppDetail(item) {
  selectedApp.value = item;
  try {
    const response = await getRegistrationDetail(item.id);
    selectedApp.value = response.data?.data || item;
  } catch (error) {
    errorMessage(error);
  }
}

async function changeStatus(item, status) {
  try {
    await updateRegistrationStatus(item.id, status);
    item.status = status === 'Disetujui' ? 'diterima' : 'ditolak';
    item.status_label = status === 'Disetujui' ? 'Diterima' : 'Ditolak';
    notify(`Status pendaftaran untuk ${item.nama || item.name} berhasil diperbarui.`);
  } catch (error) { errorMessage(error); }
}

async function removeApplication(id) {
  if (!window.confirm('Apakah Anda yakin ingin menghapus data pendaftaran ini?')) return;
  try {
    await deleteRegistration(id);
    notify('Data pendaftaran berhasil dihapus.');
    await loadApplications();
  } catch (error) { errorMessage(error); }
}

// =============================================
// SISWA ACTIONS
// =============================================
function resetStudent() {
  Object.assign(studentForm, { id: null, nisn: '', nis: '', name: '', email: '', phone: '', class: '', gender: '', major_id: null, address: '' });
}

function editStudent(item) {
  Object.assign(studentForm, {
    id: item.id,
    nisn: item.nisn || '',
    nis: item.nis || '',
    name: item.name || '',
    email: item.email || '',
    phone: item.phone || '',
    class: item.class || '',
    gender: item.gender || '',
    major_id: item.major_id || item.major?.id || null,
    address: item.address || '',
  });
  window.scrollTo({ top: 150, behavior: 'smooth' });
}

async function saveStudent() {
  try {
    const data = { ...studentForm };
    if (studentForm.id) {
      delete data.id;
      await updateStudent(studentForm.id, data);
      notify('Data siswa berhasil diperbarui.');
    } else {
      delete data.id;
      await createStudent(data);
      notify('Siswa baru berhasil ditambahkan.');
    }
    resetStudent();
    await loadStudents();
  } catch (error) { errorMessage(error); }
}

async function removeStudent(id) {
  if (!window.confirm('Hapus siswa ini dari database?')) return;
  try {
    await deleteStudent(id);
    notify('Data siswa berhasil dihapus.');
    await loadStudents();
  } catch (error) { errorMessage(error); }
}

// =============================================
// BERITA ACTIONS
// =============================================
function resetNews() {
  Object.assign(newsForm, { id: null, title: '', category: '', excerpt: '', content: '', image: null });
}

function editNews(item) {
  Object.assign(newsForm, {
    id: item.id,
    title: item.title || '',
    category: item.category || '',
    excerpt: item.excerpt || '',
    content: item.content || '',
    image: null,
  });
  window.scrollTo({ top: 150, behavior: 'smooth' });
}

function selectNewsImage(event) {
  const file = event.target.files?.[0];
  if (!file) { newsForm.image = null; return; }
  if (file.size > 5 * 1024 * 1024) {
    event.target.value = '';
    notify('Ukuran gambar maksimal 5MB.', 'error');
    return;
  }
  newsForm.image = file;
}

async function saveNews() {
  try {
    const selectedImage = newsForm.image;
    const data = new FormData();
    data.append('title', newsForm.title);
    data.append('category', newsForm.category);
    data.append('excerpt', newsForm.excerpt);
    data.append('content', newsForm.content);

    let newsId = newsForm.id;
    if (newsForm.id) {
      await updateNews(newsForm.id, data);
      notify('Berita berhasil diperbarui.');
    } else {
      const response = await createNews(data);
      newsId = response.data?.id || response.data?.data?.id;
      notify('Berita berhasil diterbitkan.');
    }

    if (selectedImage && newsId) {
      await uploadNewsImage(newsId, selectedImage);
    }

    resetNews();
    await loadNews();
  } catch (error) { errorMessage(error); }
}

async function removeNews(id) {
  if (!window.confirm('Hapus artikel berita ini?')) return;
  try {
    await deleteNews(id);
    notify('Berita berhasil dihapus.');
    await loadNews();
  } catch (error) { errorMessage(error); }
}

// =============================================
// JURUSAN & FASILITAS ACTIONS
// =============================================
function resetMajor() {
  Object.assign(majorForm, { id: null, code: '', name: '', capacity: null, description: '', vision: '', mission: '', image: null, image_url: '', is_active: true });
}

function isMajorActive(item) {
  return item.is_active === true || item.is_active === 1 || item.is_active === '1';
}

function onMajorImageSelected(event) {
  const file = event.target.files?.[0];
  if (!file) {
    majorForm.image = null;
    return;
  }

  if (file.size > 5 * 1024 * 1024) {
    notify('Ukuran gambar jurusan maksimal 5MB.', 'error');
    event.target.value = '';
    majorForm.image = null;
    return;
  }

  majorForm.image = file;
}

function editMajor(item) {
  Object.assign(majorForm, {
    id: item.id,
    code: item.code || '',
    name: item.name || '',
    capacity: item.capacity || item.student_count || null,
    description: item.description || '',
    vision: item.vision || '',
    mission: item.mission || '',
    image: null,
    image_url: item.image || '',
    is_active: isMajorActive(item),
  });
  window.scrollTo({ top: 150, behavior: 'smooth' });
}

async function saveMajor() {
  try {
    const selectedImage = majorForm.image;
    const formData = new FormData();
    formData.append('code', majorForm.code);
    formData.append('name', majorForm.name);
    if (majorForm.capacity !== null && majorForm.capacity !== '') formData.append('capacity', String(majorForm.capacity));
    formData.append('description', majorForm.description || '');
    formData.append('vision', majorForm.vision || '');
    formData.append('mission', majorForm.mission || '');
    formData.append('is_active', majorForm.is_active ? '1' : '0');
    if (majorForm.image_url) formData.append('image_url', majorForm.image_url);

    let majorId = majorForm.id;
    if (majorForm.id) {
      await updateMajor(majorForm.id, formData);
      notify('Jurusan berhasil diperbarui.');
    } else {
      const response = await createMajor(formData);
      majorId = response.data?.id || response.data?.data?.id;
      notify('Jurusan baru berhasil ditambahkan.');
    }

    if (selectedImage && majorId) {
      await uploadMajorImage(majorId, selectedImage);
    }

    resetMajor();
    await loadMajors();
  } catch (error) { errorMessage(error); }
}

async function removeMajor(id) {
  if (!window.confirm('Hapus jurusan ini? Siswa terkait mungkin terdampak.')) return;
  try {
    await deleteMajor(id);
    notify('Jurusan berhasil dihapus.');
    await loadMajors();
  } catch (error) { errorMessage(error); }
}

async function openFacilityModal(major) {
  selectedMajorForFacility.value = major;
  facilityForm.name = '';
  facilityForm.description = '';
  try {
    const res = await getMajorDetail(major.id);
    majorFacilities.value = res.data?.data?.facilities || [];
  } catch (e) {
    majorFacilities.value = [];
  }
}

async function saveFacility() {
  if (!selectedMajorForFacility.value) return;
  try {
    await addMajorFacility(selectedMajorForFacility.value.id, {
      name: facilityForm.name,
      description: facilityForm.description,
    });
    notify('Fasilitas berhasil ditambahkan ke jurusan.');
    facilityForm.name = '';
    facilityForm.description = '';
    const res = await getMajorDetail(selectedMajorForFacility.value.id);
    majorFacilities.value = res.data?.data?.facilities || [];
  } catch (error) { errorMessage(error); }
}

async function removeFacility(facilityId) {
  if (!window.confirm('Hapus fasilitas ini?')) return;
  try {
    await deleteMajorFacility(selectedMajorForFacility.value.id, facilityId);
    notify('Fasilitas dihapus.');
    majorFacilities.value = majorFacilities.value.filter(f => f.id !== facilityId);
  } catch (error) { errorMessage(error); }
}

// =============================================
// GAMBAR WEBSITE ACTIONS
// =============================================
function resetImageForm() {
  Object.assign(imageForm, { id: null, key: '', title: '', section: '', alt_text: '', image_url: '', file: null });
}

function editImage(item) {
  Object.assign(imageForm, {
    id: item.id,
    key: item.key || '',
    title: item.title || '',
    section: item.section || '',
    alt_text: item.alt_text || '',
    image_url: item.image_url || '',
    file: null,
  });
  window.scrollTo({ top: 150, behavior: 'smooth' });
}

async function saveImage() {
  try {
    if (imageForm.id) {
      // Update
      const data = {
        key: imageForm.key,
        title: imageForm.title,
        section: imageForm.section,
        alt_text: imageForm.alt_text,
        image_url: imageForm.image_url,
      };
      await updateSiteImage(imageForm.id, data);
      notify('Data gambar berhasil diperbarui.');
    } else {
      // Create / upload
      const data = new FormData();
      data.append('key', imageForm.key);
      data.append('title', imageForm.title);
      data.append('section', imageForm.section);
      data.append('alt_text', imageForm.alt_text);
      if (imageForm.file) data.append('image', imageForm.file);
      if (imageForm.image_url) data.append('image_url', imageForm.image_url);
      await createSiteImage(data);
      notify('Gambar baru berhasil diupload.');
    }
    resetImageForm();
    await loadImages();
  } catch (error) { errorMessage(error); }
}

async function removeImage(id) {
  if (!window.confirm('Hapus gambar ini?')) return;
  try {
    await deleteSiteImage(id);
    notify('Gambar berhasil dihapus.');
    await loadImages();
  } catch (error) { errorMessage(error); }
}

// =============================================
// KATEGORI ACTIONS
// =============================================
function resetCategory() {
  Object.assign(categoryForm, { id: null, name: '', type: 'news' });
}

function editCategory(item) {
  Object.assign(categoryForm, { id: item.id, name: item.name, type: item.type || 'news' });
  window.scrollTo({ top: 150, behavior: 'smooth' });
}

async function saveCategory() {
  try {
    if (categoryForm.id) {
      await updateCategory(categoryForm.id, { name: categoryForm.name, type: categoryForm.type });
      notify('Kategori berhasil diperbarui.');
    } else {
      await createCategory({ name: categoryForm.name, type: categoryForm.type });
      notify('Kategori baru berhasil ditambahkan.');
    }
    resetCategory();
    await loadCategories();
  } catch (error) { errorMessage(error); }
}

async function removeCategory(id) {
  if (!window.confirm('Hapus kategori ini?')) return;
  try {
    await deleteCategory(id);
    notify('Kategori dihapus.');
    await loadCategories();
  } catch (error) { errorMessage(error); }
}

// =============================================
// USER ACTIONS
// =============================================
function resetUser() {
  Object.assign(userForm, { id: null, name: '', email: '', password: '', phone: '', role: 'admin_sekolah', is_active: true });
}

function editUser(u) {
  const currentRole = u.roles && u.roles.length ? u.roles[0].name : 'admin_sekolah';
  Object.assign(userForm, {
    id: u.id,
    name: u.name,
    email: u.email,
    password: '',
    phone: u.phone || '',
    role: currentRole,
    is_active: u.is_active !== false,
  });
  window.scrollTo({ top: 150, behavior: 'smooth' });
}

async function saveUser() {
  try {
    const data = {
      name: userForm.name,
      email: userForm.email,
      phone: userForm.phone,
      role: userForm.role,
      is_active: userForm.is_active,
    };
    if (userForm.password) data.password = userForm.password;

    if (userForm.id) {
      await updateUser(userForm.id, data);
      notify('Data pengguna berhasil diperbarui.');
    } else {
      await createUser(data);
      notify('Pengguna baru berhasil dibuat.');
    }
    resetUser();
    await loadUsers();
  } catch (error) { errorMessage(error); }
}

async function removeUser(id) {
  if (!window.confirm('Hapus akun pengguna ini?')) return;
  try {
    await deleteUser(id);
    notify('Pengguna berhasil dihapus.');
    await loadUsers();
  } catch (error) { errorMessage(error); }
}

// =============================================
// PROFIL SEKOLAH ACTIONS
// =============================================
async function saveProfile() {
  try {
    await updateSchoolProfile({ ...profileForm });
    notify('Profil sekolah berhasil diperbarui.');
  } catch (error) { errorMessage(error); }
}

function logout() {
  localStorage.removeItem('auth_token');
  sessionStorage.removeItem('auth_token');
  router.push('/login');
}

onMounted(() => {
  Promise.all([
    loadApplications(),
    loadPpdbSchedule(),
    loadStudents(),
    loadNews(),
    loadMajors(),
    loadImages(),
    loadCategories(),
    loadUsers(),
    loadProfile(),
  ]);
});
</script>

<style scoped>
.admin-page {
  min-height: 100vh;
  padding: 36px clamp(16px, 4vw, 64px);
  background: #f4f6fa;
  color: #111827;
  font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
}

.admin-header {
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
  font-size: 22px;
  font-weight: 700;
  color: #1e293b;
}

.subtitle {
  color: #64748b;
  margin: 0;
  font-size: 14px;
}

.header-actions, .actions {
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
.button.success { background: #10b981; color: #fff; }
.button.success:hover { background: #059669; }
.button.warning { background: #f59e0b; color: #fff; }
.button.warning:hover { background: #d97706; }
.button.danger { background: #fee2e2; color: #b91c1c; }
.button.danger:hover { background: #fecaca; }
.button.small { padding: 6px 10px; font-size: 12px; }

/* Tabs */
.tabs {
  max-width: 1320px;
  margin: 0 auto 24px;
  display: flex;
  gap: 6px;
  overflow-x: auto;
  border-bottom: 2px solid #e2e8f0;
  padding-bottom: 2px;
}

.tab {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  border: 0;
  border-bottom: 3px solid transparent;
  background: transparent;
  padding: 12px 16px;
  color: #64748b;
  font: inherit;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.15s ease;
}

.tab:hover { color: #1e3a8a; }
.tab.active {
  border-color: #1e3a8a;
  color: #1e3a8a;
}

.tab-badge {
  background: #e2e8f0;
  color: #475569;
  border-radius: 9999px;
  padding: 2px 7px;
  font-size: 11px;
}

.tab.active .tab-badge {
  background: #e0e7ff;
  color: #1e3a8a;
}

/* Panel */
.panel {
  max-width: 1320px;
  margin: 0 auto;
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: clamp(20px, 3vw, 32px);
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
}

.section-heading {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.applications-action-column { min-width: 235px; }
.applications-actions { min-width: 235px; flex-wrap: wrap; }
.document-links { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
.empty-document { color: #64748b; font-size: 13px; }

.schedule-card {
  display: grid;
  grid-template-columns: minmax(220px, 0.8fr) 1.7fr;
  gap: 24px;
  align-items: end;
  margin-bottom: 24px;
  padding: 18px;
  border: 1px solid #bfdbfe;
  border-radius: 10px;
  background: #eff6ff;
}

.schedule-card h3 { margin: 0 0 6px; font-size: 16px; }
.schedule-help { margin: 0; color: #64748b; font-size: 13px; }
.schedule-fields { display: grid; grid-template-columns: 1fr 1fr auto; gap: 12px; align-items: end; }
.schedule-fields .form-group { margin: 0; }

@media (max-width: 800px) {
  .schedule-card, .schedule-fields { grid-template-columns: 1fr; }
}

.heading-controls, .list-toolbar {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.list-toolbar {
  margin: 20px 0 16px;
}

.search-input, .filter-select {
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  padding: 9px 12px;
  font: inherit;
  font-size: 13px;
  color: #1e293b;
  background: #fff;
}

.search-input { min-width: 240px; }

/* Notice */
.notice {
  max-width: 1320px;
  margin: 0 auto 20px;
  padding: 12px 18px;
  border-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  font-weight: 600;
}

.notice.success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
.notice.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
.notice-close {
  background: transparent;
  border: 0;
  font-size: 18px;
  cursor: pointer;
  color: inherit;
}

/* Forms */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 28px;
  background: #f8fafc;
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
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

input:focus, textarea:focus, select:focus, .search-input:focus, .filter-select:focus {
  outline: none;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
}

.field-with-counter textarea {
  min-height: 80px;
}

.field-with-counter small {
  display: block;
  text-align: right;
  color: #64748b;
  margin-top: 4px;
}

/* Table */
.table-wrap {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px 14px;
  border-bottom: 1px solid #f1f5f9;
  text-align: left;
  font-size: 13px;
}

th {
  color: #64748b;
  font-size: 11px;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  background: #f8fafc;
}

tbody tr:hover {
  background: #f8fafc;
}

/* Badges & Status */
.status-pill {
  display: inline-block;
  border-radius: 9999px;
  padding: 4px 10px;
  font-size: 11px;
  font-weight: 700;
}

.status-pending { background: #fef3c7; color: #92400e; }
.status-verified { background: #e0f2fe; color: #0369a1; }
.status-approved { background: #d1fae5; color: #065f46; }
.status-rejected { background: #fee2e2; color: #991b1b; }

.badge-jurusan {
  display: inline-block;
  background: #f1f5f9;
  color: #334155;
  border-radius: 6px;
  padding: 3px 8px;
  font-weight: 600;
  font-size: 12px;
}

.role-badge {
  display: inline-block;
  background: #ede9fe;
  color: #5b21b6;
  border-radius: 6px;
  padding: 3px 8px;
  font-weight: 700;
  font-size: 11px;
  text-transform: uppercase;
}

/* News Admin Grid */
.news-grid-admin {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 18px;
}

.news-card-admin {
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  overflow: hidden;
  background: #fff;
  display: flex;
  flex-direction: column;
}

.news-thumb-wrap {
  position: relative;
  height: 160px;
  background: #f1f5f9;
}

.news-thumb-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.publish-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  border-radius: 9999px;
  padding: 3px 8px;
  font-size: 11px;
  font-weight: 700;
}

.publish-badge.published { background: rgba(16, 185, 129, 0.9); color: #fff; }
.publish-badge.draft { background: rgba(100, 116, 139, 0.9); color: #fff; }

.news-card-body {
  padding: 16px;
  display: flex;
  flex-direction: column;
  flex: 1;
}

.news-cat {
  font-size: 11px;
  font-weight: 800;
  color: #0284c7;
  text-transform: uppercase;
}

.news-card-body h3 {
  margin: 6px 0;
  font-size: 15px;
  font-weight: 700;
  color: #0f172a;
}

.news-card-body p {
  font-size: 13px;
  color: #64748b;
  margin: 0 0 14px;
  flex: 1;
}

.news-card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1px solid #f1f5f9;
  padding-top: 10px;
}

/* Major Grid */
.major-cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 18px;
}

.major-admin-card {
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  padding: 20px;
  background: #fff;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.major-card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.major-code-badge {
  font-size: 11px;
  font-weight: 800;
  background: #0284c7;
  color: #fff;
  padding: 2px 7px;
  border-radius: 4px;
  text-transform: uppercase;
}

.major-admin-card h3 {
  margin: 4px 0 0;
  font-size: 16px;
  color: #0f172a;
}

.major-desc {
  font-size: 13px;
  color: #64748b;
  margin: 0;
  flex: 1;
}

.major-meta {
  font-size: 12px;
  color: #475569;
  padding: 6px 0;
  border-top: 1px dashed #e2e8f0;
}

.major-card-actions {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

/* Image Grid */
.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 18px;
}

.image-item {
  border: 1px solid #e2e8f0;
  border-radius: 10px;
  overflow: hidden;
  background: #fff;
  display: flex;
  flex-direction: column;
}

.image-preview-box {
  height: 150px;
  background: #f8fafc;
}

.image-preview-box img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-info {
  padding: 14px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
}

.img-badge {
  font-size: 10px;
  font-weight: 800;
  color: #0284c7;
  background: #e0f2fe;
  padding: 2px 6px;
  border-radius: 4px;
  width: fit-content;
  text-transform: uppercase;
}

.image-actions {
  padding: 10px 14px;
  border-top: 1px solid #f1f5f9;
  display: flex;
  justify-content: flex-end;
  gap: 6px;
}

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  z-index: 999;
}

.modal-card {
  background: #ffffff;
  border-radius: 14px;
  width: 100%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

.modal-header {
  padding: 20px 24px;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 { margin: 0; font-size: 18px; color: #0f172a; }
.modal-close {
  background: transparent;
  border: 0;
  font-size: 24px;
  color: #94a3b8;
  cursor: pointer;
}

.modal-body { padding: 24px; }
.modal-footer {
  padding: 16px 24px;
  border-top: 1px solid #e2e8f0;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  flex-wrap: wrap;
}

.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px;
  font-size: 13px;
}

.detail-grid .full-width { grid-column: 1 / -1; }
.detail-grid span { color: #64748b; font-size: 11px; display: block; text-transform: uppercase; }
.berkas-box {
  background: #f8fafc;
  padding: 12px;
  border-radius: 8px;
  border: 1px dashed #cbd5e1;
}

/* Facility */
.facility-form {
  display: flex;
  gap: 8px;
  margin-bottom: 18px;
}

.facility-items {
  display: grid;
  gap: 8px;
  margin-top: 10px;
}

.facility-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 10px 14px;
}

.facility-item p { margin: 0; font-size: 12px; color: #64748b; }

.empty {
  text-align: center;
  color: #94a3b8;
  padding: 36px 0;
  font-size: 14px;
}

@media (max-width: 768px) {
  .admin-header { flex-direction: column; align-items: flex-start; }
  .form-grid { grid-template-columns: 1fr; }
  .detail-grid { grid-template-columns: 1fr; }
}
</style>
