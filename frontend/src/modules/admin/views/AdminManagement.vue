<template>
  <div class="app-shell">
    <!-- ===== SIDEBAR ===== -->
    <aside :class="['sidebar', { open: sidebarOpen }]">
      <div class="sidebar-brand">
        <div class="brand-mark"><School :size="20" /></div>
        <div class="brand-text">
          <strong>SMK Nurul Jadid</strong>
          <span>Admin Panel</span>
        </div>
        <button class="sidebar-close" @click="sidebarOpen = false"><X :size="18" /></button>
      </div>

      <nav class="sidebar-nav">
        <template v-for="group in navGroups" :key="group.label">
          <p class="nav-label">{{ group.label }}</p>
          <button
            v-for="item in group.items"
            :key="item.id"
            :class="['nav-item', { active: activeTab === item.id }]"
            @click="goTo(item.id)"
          >
            <component :is="item.icon" :size="17" />
            <span class="nav-text">{{ item.label }}</span>
            <span v-if="item.count" class="nav-count">{{ item.count }}</span>
          </button>
        </template>
      </nav>

      <div class="sidebar-footer">
        <router-link to="/" class="nav-item"><Globe :size="17" /> <span class="nav-text">Lihat Website</span></router-link>
        <button class="nav-item quit" @click="logout"><LogOut :size="17" /> <span class="nav-text">Keluar</span></button>
      </div>
    </aside>

    <div v-if="sidebarOpen" class="sidebar-overlay" @click="sidebarOpen = false"></div>

    <!-- ===== MAIN AREA ===== -->
    <div class="main-area">
      <!-- Topbar -->
      <header class="topbar">
        <div class="topbar-left">
          <button class="hamburger" @click="sidebarOpen = true"><Menu :size="20" /></button>
          <div>
            <h1 class="topbar-title">{{ pageTitle }}</h1>
            <p class="topbar-date">{{ todayDate }}</p>
          </div>
        </div>
        <div class="topbar-actions">
          <button class="theme-toggle" type="button" :aria-label="currentTheme === 'dark' ? 'Gunakan mode terang' : 'Gunakan mode gelap'" :title="currentTheme === 'dark' ? 'Mode terang' : 'Mode gelap'" @click="toggleTheme">
            <Sun v-if="currentTheme === 'dark'" :size="16" />
            <Moon v-else :size="16" />
          </button>
          <button class="btn btn-danger-soft btn-sm" @click="logout"><LogOut :size="15" /> <span>Keluar</span></button>
        </div>
      </header>

      <!-- Toast notification -->
      <transition name="toast">
        <div v-if="message" :class="['toast', messageType]">
          <CheckCircle2 v-if="messageType === 'success'" :size="18" />
          <XCircle v-else :size="18" />
          <span>{{ message }}</span>
          <button class="toast-close" @click="message = ''">&times;</button>
        </div>
      </transition>

      <main class="content">

        <!-- ============================================= -->
        <!-- PPDB -->
        <!-- ============================================= -->
        <section v-if="activeTab === 'applications'">
          <!-- Statistik -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon blue"><ClipboardList :size="20" /></div>
              <div><span class="stat-value">{{ appStats.total }}</span><span class="stat-label">Total Pendaftar</span></div>
            </div>
            <div class="stat-card">
              <div class="stat-icon amber"><Clock :size="20" /></div>
              <div><span class="stat-value">{{ appStats.pending }}</span><span class="stat-label">Menunggu Review</span></div>
            </div>
            <div class="stat-card">
              <div class="stat-icon green"><CheckCircle2 :size="20" /></div>
              <div><span class="stat-value">{{ appStats.diterima }}</span><span class="stat-label">Diterima</span></div>
            </div>
            <div class="stat-card">
              <div class="stat-icon red"><XCircle :size="20" /></div>
              <div><span class="stat-value">{{ appStats.ditolak }}</span><span class="stat-label">Ditolak</span></div>
            </div>
          </div>

          <div class="card schedule-card">
            <div class="card-head">
              <div class="card-head-icon soft-blue"><Clock :size="18" /></div>
              <div>
                <h3>Jadwal Pendaftaran PPDB</h3>
                <p>Tombol "Daftar" di website hanya aktif di antara dua waktu ini.</p>
              </div>
            </div>
            <form class="schedule-fields" @submit.prevent="savePpdbSchedule">
              <label class="form-group">
                <span>Mulai Pendaftaran</span>
                <input v-model="ppdbSchedule.registration_start" type="datetime-local" step="1" required />
              </label>
              <label class="form-group">
                <span>Selesai Pendaftaran</span>
                <input v-model="ppdbSchedule.registration_end" type="datetime-local" step="1" required />
              </label>
              <button class="btn btn-primary" type="submit"><Save :size="15" /> Simpan Jadwal</button>
            </form>
          </div>

          <div class="card">
            <div class="panel-header">
              <div>
                <h2>Data Pendaftaran Siswa Baru</h2>
                <p class="panel-desc">Periksa dokumen sebelum menerima pendaftar.</p>
              </div>
              <div class="panel-controls">
                <div class="search-box">
                  <Search :size="15" class="search-icon" />
                  <input v-model="appFilter.search" type="text" placeholder="Cari nama, NISN, no daftar…" />
                </div>
                <select v-model="appFilter.status" class="select-input">
                  <option value="">Semua Status</option>
                  <option value="pending">Menunggu</option>
                  <option value="verifikasi">Verifikasi</option>
                  <option value="diterima">Diterima</option>
                  <option value="ditolak">Ditolak</option>
                </select>
                <button class="btn btn-outline btn-sm" @click="loadApplications"><RotateCw :size="14" /> Refresh</button>
              </div>
            </div>

            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>No. Daftar</th>
                    <th>Nama Siswa</th>
                    <th>NISN</th>
                    <th>Jurusan</th>
                    <th>Tgl Daftar</th>
                    <th>Status</th>
                    <th class="col-actions">Aksi</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="item in filteredApplications" :key="item.id">
                    <td><code>{{ item.no_pendaftaran || '—' }}</code></td>
                    <td>
                      <strong>{{ item.nama || item.name }}</strong>
                      <small v-if="item.email">{{ item.email }}</small>
                    </td>
                    <td>{{ item.nisn || '—' }}</td>
                    <td><span class="badge-soft">{{ item.program || '—' }}</span></td>
                    <td>{{ item.created_at ? formatDate(item.created_at) : '—' }}</td>
                    <td><span :class="['status-pill', getStatusClass(item.status)]">{{ item.status_label || item.status }}</span></td>
                    <td class="actions">
                      <button class="btn btn-outline btn-xs" @click="viewAppDetail(item)">Detail</button>
                      <button v-if="item.status !== 'diterima' && item.status !== 'Disetujui'" class="btn btn-success btn-xs" @click="changeStatus(item, 'Disetujui')">Terima</button>
                      <button v-if="item.status !== 'ditolak' && item.status !== 'Ditolak'" class="btn btn-warn btn-xs" @click="changeStatus(item, 'Ditolak')">Tolak</button>
                      <button class="btn btn-danger-soft btn-xs" @click="removeApplication(item.id)">Hapus</button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!filteredApplications.length" class="empty-state">
                <Inbox :size="36" />
                <p>Tidak ada pendaftaran yang cocok dengan filter.</p>
              </div>
            </div>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- SISWA -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'students'">
          <div class="card">
            <div class="card-head">
              <div class="card-head-icon soft-green"><GraduationCap :size="18" /></div>
              <div>
                <h3>{{ studentForm.id ? 'Ubah Data Siswa' : 'Tambah Siswa Baru' }}</h3>
                <p>{{ studentForm.id ? `Sedang mengubah: ${studentForm.name}` : 'Lengkapi formulir di bawah ini.' }}</p>
              </div>
              <button v-if="studentForm.id" class="btn btn-ghost btn-sm head-action" @click="resetStudent">Batal Edit</button>
            </div>
            <form class="form-grid" @submit.prevent="saveStudent">
              <div class="form-group">
                <label>NISN</label>
                <input v-model="studentForm.nisn" placeholder="Nomor Induk Siswa Nasional" />
              </div>
              <div class="form-group">
                <label>NIS <em>*</em></label>
                <input v-model="studentForm.nis" required placeholder="Nomor Induk Sekolah" />
              </div>
              <div class="form-group">
                <label>Nama Lengkap <em>*</em></label>
                <input v-model="studentForm.name" required placeholder="Nama lengkap siswa" />
              </div>
              <div class="form-group">
                <label>Kelas <em>*</em></label>
                <input v-model="studentForm.class" required placeholder="Contoh: X RPL 1" />
              </div>
              <div class="form-group">
                <label>Jurusan <em>*</em></label>
                <select v-model.number="studentForm.major_id" required>
                  <option :value="null">Pilih Jurusan</option>
                  <option v-for="major in majors" :key="major.id" :value="major.id">{{ major.name }}</option>
                </select>
              </div>
              <div class="form-group">
                <label>Jenis Kelamin</label>
                <select v-model="studentForm.gender">
                  <option value="">Pilih</option>
                  <option value="Laki-laki">Laki-laki</option>
                  <option value="Perempuan">Perempuan</option>
                </select>
              </div>
              <div class="form-group">
                <label>Email</label>
                <input v-model="studentForm.email" type="email" placeholder="contoh@email.com" />
              </div>
              <div class="form-group">
                <label>No. Telepon / WhatsApp</label>
                <input v-model="studentForm.phone" placeholder="08xxxxxxxxxx" />
              </div>
              <div class="form-group full">
                <label>Alamat Lengkap</label>
                <textarea v-model="studentForm.address" rows="2" placeholder="Alamat tempat tinggal siswa"></textarea>
              </div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="studentForm.id" /><Plus :size="15" v-else />
                  {{ studentForm.id ? 'Simpan Perubahan' : 'Tambahkan Siswa' }}
                </button>
              </div>
            </form>
          </div>

          <div class="card">
            <div class="panel-header">
              <div>
                <h2>Daftar Siswa</h2>
                <p class="panel-desc">{{ filteredStudents.length }} siswa ditampilkan</p>
              </div>
              <div class="panel-controls">
                <div class="search-box">
                  <Search :size="15" class="search-icon" />
                  <input v-model="studentSearch" type="text" placeholder="Cari nama, NIS, kelas…" />
                </div>
                <select v-model.number="studentMajorFilter" class="select-input">
                  <option :value="null">Semua Jurusan</option>
                  <option v-for="m in majors" :key="m.id" :value="m.id">{{ m.name }}</option>
                </select>
              </div>
            </div>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Nama Siswa</th>
                    <th>NISN / NIS</th>
                    <th>Jurusan</th>
                    <th>Kelas</th>
                    <th>Kontak</th>
                    <th class="col-actions">Aksi</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="item in filteredStudents" :key="item.id">
                    <td>
                      <strong>{{ item.name }}</strong>
                      <small>{{ item.gender || '—' }}</small>
                    </td>
                    <td>{{ item.nisn || '—' }} / {{ item.nis || '—' }}</td>
                    <td><span class="badge-soft">{{ item.major?.name || majorName(item.major_id) }}</span></td>
                    <td>{{ item.class || '—' }}</td>
                    <td>
                      {{ item.phone || '—' }}
                      <small v-if="item.email">{{ item.email }}</small>
                    </td>
                    <td class="actions">
                      <button class="btn btn-outline btn-xs" @click="editStudent(item)"><Edit2 :size="13" /> Edit</button>
                      <button class="btn btn-danger-soft btn-xs" @click="removeStudent(item.id)"><Trash2 :size="13" /> Hapus</button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!filteredStudents.length" class="empty-state">
                <Inbox :size="36" />
                <p>Belum ada siswa yang cocok dengan pencarian.</p>
              </div>
            </div>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- BERITA -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'news'">
          <div class="card">
            <div class="card-head">
              <div class="card-head-icon soft-blue"><Newspaper :size="18" /></div>
              <div>
                <h3>{{ newsForm.id ? 'Ubah Berita' : 'Tulis Berita Baru' }}</h3>
                <p>{{ newsForm.id ? `Sedang menyunting: ${newsForm.title}` : 'Kabar atau kegiatan terbaru sekolah.' }}</p>
              </div>
              <button v-if="newsForm.id" class="btn btn-ghost btn-sm head-action" @click="resetNews">Batal Edit</button>
            </div>
            <form class="form-grid" @submit.prevent="saveNews">
              <div class="form-group full">
                <label>Judul Berita <em>*</em></label>
                <input v-model="newsForm.title" required placeholder="Judul artikel atau kegiatan" />
              </div>
              <div class="form-group">
                <label>Kategori</label>
                <input v-model="newsForm.category" placeholder="Prestasi, Kegiatan, Pengumuman…" />
              </div>
              <div class="form-group">
                <label>Tanggal Terbit</label>
                <input v-model="newsForm.published_at" type="datetime-local" />
              </div>
              <div class="form-group">
                <label>Foto Utama</label>
                <input type="file" accept=".jpeg,.jpg,.png,.gif,.webp,image/*" @change="selectNewsImage" />
                <small class="hint">Maksimal 5MB. Format: JPG, PNG, WebP.</small>
              </div>
              <div class="form-group full">
                <label>Ringkasan Singkat</label>
                <textarea v-model="newsForm.excerpt" rows="2" maxlength="500" placeholder="Ringkasan untuk preview kartu berita"></textarea>
                <small class="hint char-count">{{ (newsForm.excerpt || '').length }}/500 karakter</small>
              </div>
              <div class="form-group full">
                <label>Isi Lengkap <em>*</em></label>
                <textarea v-model="newsForm.content" required rows="7" placeholder="Tuliskan isi lengkap berita di sini…"></textarea>
              </div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="newsForm.id" /><Send :size="15" v-else />
                  {{ newsForm.id ? 'Simpan Perubahan' : 'Terbitkan Berita' }}
                </button>
              </div>
            </form>
          </div>

          <div class="panel-header standalone">
            <div>
              <h2>Semua Berita</h2>
              <p class="panel-desc">{{ news.length }} artikel diterbitkan</p>
            </div>
          </div>
          <div class="news-grid">
            <article v-for="item in news" :key="item.id" class="news-card">
              <div class="news-thumb">
                <img v-if="item.featured_image || item.gambarUtama" :src="item.featured_image || item.gambarUtama" :alt="item.title" />
                <div v-else class="news-thumb-empty"><Newspaper :size="24" /></div>
                <span :class="['publish-flag', item.published !== false ? 'on' : 'off']">
                  {{ item.published !== false ? 'Terbit' : 'Draft' }}
                </span>
              </div>
              <div class="news-body">
                <span class="news-cat">{{ item.category || 'Berita' }}</span>
                <h3>{{ item.title }}</h3>
                <p>{{ item.excerpt || (item.content ? item.content.substring(0, 110) + '…' : 'Tanpa ringkasan') }}</p>
                <div class="news-foot">
                  <small>{{ item.published_at ? formatDate(item.published_at) : 'Baru saja' }}</small>
                  <div class="actions">
                    <button class="btn btn-outline btn-xs" @click="editNews(item)"><Edit2 :size="13" /> Edit</button>
                    <button class="btn btn-danger-soft btn-xs" @click="removeNews(item.id)"><Trash2 :size="13" /></button>
                  </div>
                </div>
              </div>
            </article>
          </div>
          <div v-if="!news.length" class="empty-state card">
            <Inbox :size="36" />
            <p>Belum ada berita. Tulis yang pertama di atas.</p>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- JURUSAN -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'majors'">
          <div class="card">
            <div class="card-head">
              <div class="card-head-icon soft-green"><School :size="18" /></div>
              <div>
                <h3>{{ majorForm.id ? 'Ubah Jurusan' : 'Tambah Jurusan Baru' }}</h3>
                <p>{{ majorForm.id ? `Sedang mengubah: ${majorForm.name}` : 'Program keahlian yang tampil di website.' }}</p>
              </div>
              <button v-if="majorForm.id" class="btn btn-ghost btn-sm head-action" @click="resetMajor">Batal Edit</button>
            </div>
            <form class="form-grid" @submit.prevent="saveMajor">
              <div class="form-group">
                <label>Kode Jurusan <em>*</em></label>
                <input v-model="majorForm.code" required placeholder="RPL, TKRO, TBSM…" />
              </div>
              <div class="form-group">
                <label>Nama Jurusan <em>*</em></label>
                <input v-model="majorForm.name" required placeholder="Rekayasa Perangkat Lunak" />
              </div>
              <div class="form-group">
                <label>Daya Tampung</label>
                <input v-model.number="majorForm.capacity" type="number" min="0" placeholder="72" />
              </div>
              <div class="form-group">
                <label>Status</label>
                <select v-model="majorForm.is_active">
                  <option :value="true">Aktif (tampil di web)</option>
                  <option :value="false">Non-aktif</option>
                </select>
              </div>
              <div class="form-group">
                <label>Gambar Jurusan</label>
                <input type="file" accept="image/*" @change="onMajorImageSelected" />
              </div>
              <div class="form-group">
                <label>Atau URL Gambar</label>
                <input v-model="majorForm.image_url" placeholder="https://…" />
              </div>
              <div class="form-group full">
                <label>Deskripsi Singkat</label>
                <textarea v-model="majorForm.description" rows="2" placeholder="Deskripsi umum program keahlian"></textarea>
              </div>
              <div class="form-group">
                <label>Visi Jurusan</label>
                <textarea v-model="majorForm.vision" rows="3"></textarea>
              </div>
              <div class="form-group">
                <label>Misi Jurusan</label>
                <textarea v-model="majorForm.mission" rows="3"></textarea>
              </div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="majorForm.id" /><Plus :size="15" v-else />
                  {{ majorForm.id ? 'Simpan Perubahan' : 'Tambah Jurusan' }}
                </button>
              </div>
            </form>
          </div>

          <div class="major-grid">
            <div v-for="item in majors" :key="item.id" class="major-card">
              <div class="major-top">
                <span class="major-code">{{ item.code }}</span>
                <span :class="['status-pill', isMajorActive(item) ? 'status-approved' : 'status-rejected']">
                  {{ isMajorActive(item) ? 'Aktif' : 'Non-aktif' }}
                </span>
              </div>
              <h3>{{ item.name }}</h3>
              <div v-if="item.image" class="major-img"><img :src="item.image" :alt="item.name" /></div>
              <p class="major-desc">{{ item.description || 'Belum ada deskripsi.' }}</p>
              <div class="major-meta"><Users :size="14" /> Kapasitas: <strong>{{ item.capacity || item.student_count || 0 }} siswa</strong></div>
              <div class="major-actions">
                <button class="btn btn-primary btn-xs" @click="openFacilityModal(item)"><Building2 :size="13" /> Fasilitas</button>
                <button class="btn btn-outline btn-xs" @click="editMajor(item)"><Edit2 :size="13" /> Edit</button>
                <button class="btn btn-danger-soft btn-xs" @click="removeMajor(item.id)"><Trash2 :size="13" /></button>
              </div>
            </div>
          </div>
          <div v-if="!majors.length" class="empty-state card">
            <Inbox :size="36" />
            <p>Belum ada jurusan yang ditambahkan.</p>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- GAMBAR WEBSITE -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'images'">
          <div class="card">
            <div class="card-head">
              <div class="card-head-icon soft-blue"><Upload :size="18" /></div>
              <div>
                <h3>{{ imageForm.id ? 'Ubah Gambar' : 'Upload Gambar Baru' }}</h3>
                <p>Atur foto & banner di berbagai halaman website.</p>
              </div>
              <button v-if="imageForm.id" class="btn btn-ghost btn-sm head-action" @click="resetImageForm">Batal Edit</button>
            </div>
            <form class="form-grid" @submit.prevent="saveImage">
              <div class="form-group">
                <label>Section Website <em>*</em></label>
                <select v-model="imageForm.section" required>
                  <option value="">Pilih Section</option>
                  <option value="homepage">Homepage / Hero</option>
                  <option value="about">Tentang Sekolah</option>
                  <option value="facilities">Fasilitas</option>
                  <option value="homepage_slider">Slider Banner</option>
                  <option value="ppdb">Halaman PPDB</option>
                  <option value="contact">Kontak & Lokasi</option>
                </select>
              </div>
              <div class="form-group">
                <label>Key Identifier <em>*</em></label>
                <input v-model="imageForm.key" required placeholder="hero_banner, about_image…" />
              </div>
              <div class="form-group">
                <label>Judul Gambar <em>*</em></label>
                <input v-model="imageForm.title" required placeholder="Judul gambar / banner" />
              </div>
              <div class="form-group">
                <label>Alt Text (SEO)</label>
                <input v-model="imageForm.alt_text" placeholder="Deskripsi singkat gambar" />
              </div>
              <div class="form-group">
                <label>Pilih File <em v-if="!imageForm.id">*</em></label>
                <input type="file" accept="image/*" :required="!imageForm.id" @change="imageForm.file = $event.target.files[0]" />
              </div>
              <div class="form-group">
                <label>Atau URL Gambar</label>
                <input v-model="imageForm.image_url" placeholder="https://…" />
              </div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="imageForm.id" /><Upload :size="15" v-else />
                  {{ imageForm.id ? 'Simpan Perubahan' : 'Upload Gambar' }}
                </button>
              </div>
            </form>
          </div>

          <div class="panel-header standalone">
            <div>
              <h2>Galeri Gambar</h2>
              <p class="panel-desc">{{ filteredImages.length }} gambar tersimpan</p>
            </div>
            <div class="panel-controls">
              <select v-model="selectedSectionFilter" class="select-input">
                <option value="">Semua Section</option>
                <option value="homepage">Homepage</option>
                <option value="about">Tentang Sekolah</option>
                <option value="facilities">Fasilitas</option>
                <option value="homepage_slider">Slider</option>
                <option value="ppdb">PPDB</option>
                <option value="contact">Kontak</option>
              </select>
            </div>
          </div>
          <div class="image-grid">
            <article v-for="item in filteredImages" :key="item.id" class="image-card">
              <div class="image-box"><img :src="item.image_url" :alt="item.alt_text || item.title" /></div>
              <div class="image-info">
                <strong>{{ item.title }}</strong>
                <div class="image-tags">
                  <span class="badge-soft accent">{{ item.section }}</span>
                  <code>{{ item.key }}</code>
                </div>
              </div>
              <div class="image-actions">
                <button class="btn btn-outline btn-xs" @click="editImage(item)"><Edit2 :size="13" /> Edit</button>
                <button class="btn btn-danger-soft btn-xs" @click="removeImage(item.id)"><Trash2 :size="13" /></button>
              </div>
            </article>
          </div>
          <div v-if="!filteredImages.length" class="empty-state card">
            <Inbox :size="36" />
            <p>Tidak ada gambar pada section ini.</p>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- KATEGORI -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'categories'">
          <div class="card compact">
            <div class="card-head">
              <div class="card-head-icon soft-amber"><Tag :size="18" /></div>
              <div>
                <h3>{{ categoryForm.id ? 'Ubah Kategori' : 'Tambah Kategori Baru' }}</h3>
                <p>Untuk mengelompokkan berita, prestasi, galeri & produk.</p>
              </div>
            </div>
            <form class="inline-form" @submit.prevent="saveCategory">
              <div class="form-group grow">
                <label>Nama Kategori <em>*</em></label>
                <input v-model="categoryForm.name" required placeholder="Contoh: Prestasi Nasional" />
              </div>
              <div class="form-group">
                <label>Tipe <em>*</em></label>
                <select v-model="categoryForm.type" required>
                  <option value="news">Berita</option>
                  <option value="achievements">Prestasi</option>
                  <option value="galleries">Galeri</option>
                  <option value="products">Produk TEFA</option>
                  <option value="general">Umum</option>
                </select>
              </div>
              <div class="form-group btn-col">
                <label>&nbsp;</label>
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="categoryForm.id" /><Plus :size="15" v-else />
                  {{ categoryForm.id ? 'Simpan' : 'Tambah' }}
                </button>
              </div>
            </form>
          </div>

          <div class="card">
            <div class="panel-header">
              <div>
                <h2>Daftar Kategori</h2>
                <p class="panel-desc">{{ categories.length }} kategori aktif</p>
              </div>
            </div>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Nama Kategori</th>
                    <th>Slug</th>
                    <th>Tipe</th>
                    <th class="col-actions">Aksi</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="cat in categories" :key="cat.id">
                    <td><strong>{{ cat.name }}</strong></td>
                    <td><code>{{ cat.slug }}</code></td>
                    <td><span class="badge-soft">{{ cat.type }}</span></td>
                    <td class="actions">
                      <button class="btn btn-outline btn-xs" @click="editCategory(cat)"><Edit2 :size="13" /> Edit</button>
                      <button class="btn btn-danger-soft btn-xs" @click="removeCategory(cat.id)"><Trash2 :size="13" /></button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!categories.length" class="empty-state">
                <Inbox :size="36" />
                <p>Belum ada kategori.</p>
              </div>
            </div>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- PENGGUNA -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'users'">
          <div class="card">
            <div class="card-head">
              <div class="card-head-icon soft-violet"><Users :size="18" /></div>
              <div>
                <h3>{{ userForm.id ? 'Ubah Akun Pengguna' : 'Tambah Pengguna Baru' }}</h3>
                <p>{{ userForm.id ? `Sedang mengubah: ${userForm.name}` : 'Kelola siapa saja yang boleh akses panel ini.' }}</p>
              </div>
              <button v-if="userForm.id" class="btn btn-ghost btn-sm head-action" @click="resetUser">Batal Edit</button>
            </div>
            <form class="form-grid" @submit.prevent="saveUser">
              <div class="form-group">
                <label>Nama Lengkap <em>*</em></label>
                <input v-model="userForm.name" required placeholder="Nama staf / admin" />
              </div>
              <div class="form-group">
                <label>Email <em>*</em></label>
                <input v-model="userForm.email" required type="email" placeholder="admin@smknuruljadid.sch.id" />
              </div>
              <div class="form-group">
                <label>Password <em v-if="!userForm.id">*</em></label>
                <input v-model="userForm.password" type="password" :required="!userForm.id" :placeholder="userForm.id ? 'Kosongkan jika tidak diganti' : 'Minimal 6 karakter'" />
              </div>
              <div class="form-group">
                <label>No. Telepon</label>
                <input v-model="userForm.phone" placeholder="08xxxxxxxxxx" />
              </div>
              <div class="form-group">
                <label>Role Akses <em>*</em></label>
                <select v-model="userForm.role" required>
                  <option value="admin_sekolah">Admin Sekolah</option>
                  <option value="superadmin">Superadmin</option>
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
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="userForm.id" /><Plus :size="15" v-else />
                  {{ userForm.id ? 'Simpan Perubahan' : 'Buat Pengguna' }}
                </button>
              </div>
            </form>
          </div>

          <div class="card">
            <div class="panel-header">
              <div>
                <h2>Daftar Pengguna</h2>
                <p class="panel-desc">{{ usersList.length }} akun terdaftar</p>
              </div>
            </div>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Nama</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Telepon</th>
                    <th>Status</th>
                    <th class="col-actions">Aksi</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="u in usersList" :key="u.id">
                    <td><strong>{{ u.name }}</strong></td>
                    <td>{{ u.email }}</td>
                    <td><span class="badge-soft violet">{{ u.roles && u.roles.length ? u.roles.map(r => r.name).join(', ') : 'admin_sekolah' }}</span></td>
                    <td>{{ u.phone || '—' }}</td>
                    <td><span :class="['status-pill', u.is_active !== false ? 'status-approved' : 'status-rejected']">{{ u.is_active !== false ? 'Aktif' : 'Nonaktif' }}</span></td>
                    <td class="actions">
                      <button class="btn btn-outline btn-xs" @click="editUser(u)"><Edit2 :size="13" /> Edit</button>
                      <button class="btn btn-danger-soft btn-xs" @click="removeUser(u.id)"><Trash2 :size="13" /></button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!usersList.length" class="empty-state">
                <Inbox :size="36" />
                <p>Belum ada pengguna.</p>
              </div>
            </div>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- PROFIL SEKOLAH -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'profile'">
          <form class="card" @submit.prevent="saveProfile">
            <div class="card-head">
              <div class="card-head-icon soft-green"><Settings :size="18" /></div>
              <div>
                <h3>Identitas Sekolah</h3>
                <p>Informasi yang tampil di seluruh halaman website.</p>
              </div>
            </div>
            <div class="form-grid">
              <div class="form-group">
                <label>Nama Sekolah <em>*</em></label>
                <input v-model="profileForm.school_name" required />
              </div>
              <div class="form-group"><label>NSM</label><input v-model="profileForm.nsm" /></div>
              <div class="form-group"><label>NPSN</label><input v-model="profileForm.npsn" /></div>
              <div class="form-group"><label>NPWP</label><input v-model="profileForm.npwp" /></div>
              <div class="form-group full"><label>Judul Profil</label><input v-model="profileForm.profile_title_line1" placeholder="Tradisi Pesantren, Inovasi Masa Depan" /></div>
              <div class="form-group full"><label>Deskripsi Profil</label><textarea v-model="profileForm.profile_description" rows="4"></textarea></div>
              <div class="form-group"><label>Email Sekolah</label><input v-model="profileForm.email" type="email" /></div>
              <div class="form-group"><label>Telepon</label><input v-model="profileForm.phone" /></div>
              <div class="form-group"><label>Website</label><input v-model="profileForm.website" /></div>
              <div class="form-group"><label>Tahun Berdiri</label><input v-model.number="profileForm.founded_year" type="number" /></div>
              <div class="form-group"><label>Tahun Beroperasi</label><input v-model.number="profileForm.operating_year" type="number" /></div>
              <div class="form-group"><label>Akreditasi</label><input v-model="profileForm.accreditation" placeholder="B (90)" /></div>
              <div class="form-group"><label>Yayasan</label><input v-model="profileForm.foundation_name" /></div>
              <div class="form-group full"><label>Alamat Sekolah</label><textarea v-model="profileForm.address" rows="2"></textarea></div>
              <div class="form-group"><label>Desa</label><input v-model="profileForm.village" /></div>
              <div class="form-group"><label>Kecamatan</label><input v-model="profileForm.district" /></div>
              <div class="form-group full"><label>Kota / Provinsi</label><input v-model="profileForm.city" /></div>
              <div class="form-group"><label>Visi Sekolah</label><textarea v-model="profileForm.vision" rows="4"></textarea></div>
              <div class="form-group"><label>Misi Sekolah</label><textarea v-model="profileForm.mission" rows="4"></textarea></div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit"><Save :size="15" /> Simpan Profil</button>
              </div>
            </div>
          </form>

          <form class="card" @submit.prevent="saveProfile">
            <div class="card-head">
              <div class="card-head-icon soft-blue"><FileText :size="18" /></div>
              <div>
                <h3>Sambutan Kepala Sekolah</h3>
                <p>Teks dan foto yang tampil pada bagian sambutan.</p>
              </div>
            </div>
            <div class="form-grid">
              <div class="form-group"><label>Nama Kepala Sekolah</label><input v-model="profileForm.headmaster_name" placeholder="Nama beserta gelar" /></div>
              <div class="form-group">
                <label>Foto Kepala Sekolah</label>
                <input type="file" accept="image/*" @change="headmasterPhoto.file = $event.target.files[0]" />
                <small class="hint">Klik "Simpan & Upload Foto" setelah memilih file.</small>
              </div>
              <div class="form-group full"><label>Teks Sambutan</label><textarea v-model="profileForm.headmaster_message_body" rows="6"></textarea></div>
              <div class="form-group full"><label>Teks Pemberitahuan Utama</label><textarea v-model="profileForm.headmaster_message_statement" rows="2"></textarea></div>
              <div class="form-group full"><label>Kata Penutup</label><textarea v-model="profileForm.headmaster_message_closing" rows="2"></textarea></div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit"><Save :size="15" /> Simpan Sambutan</button>
                <button class="btn btn-outline" type="button" @click="saveHeadmasterPhoto"><Upload :size="15" /> Simpan & Upload Foto</button>
              </div>
            </div>
          </form>
        </section>

        <!-- ============================================= -->
        <!-- DROPDOWN PROFIL (sebelumnya tidak ada UI-nya) -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'profile-menu'">
          <div class="card">
            <div class="card-head">
              <div class="card-head-icon soft-blue"><List :size="18" /></div>
              <div>
                <h3>{{ profileMenuForm.id ? 'Ubah Menu Dropdown' : 'Tambah Menu Dropdown' }}</h3>
                <p>Item yang muncul di menu "Profil" pada navbar website.</p>
              </div>
              <button v-if="profileMenuForm.id" class="btn btn-ghost btn-sm head-action" @click="resetProfileMenu">Batal Edit</button>
            </div>
            <form class="form-grid" @submit.prevent="saveProfileMenu">
              <div class="form-group">
                <label>Label Menu <em>*</em></label>
                <input v-model="profileMenuForm.label" required placeholder="Contoh: Sejarah Sekolah" />
              </div>
              <div class="form-group">
                <label>Path URL</label>
                <input v-model="profileMenuForm.path" placeholder="/profil" />
              </div>
              <div class="form-group">
                <label>Hash / Anchor</label>
                <input v-model="profileMenuForm.hash" placeholder="#sejarah (opsional)" />
              </div>
              <div class="form-group">
                <label>Ikon (huruf)</label>
                <input v-model="profileMenuForm.icon" maxlength="1" placeholder="S" />
              </div>
              <div class="form-group">
                <label>Urutan Tampil</label>
                <input v-model.number="profileMenuForm.position" type="number" min="1" />
              </div>
              <div class="form-group">
                <label>Status</label>
                <select v-model="profileMenuForm.is_active">
                  <option :value="true">Aktif</option>
                  <option :value="false">Nonaktif</option>
                </select>
              </div>
              <div class="form-group full">
                <label>Deskripsi Singkat</label>
                <textarea v-model="profileMenuForm.description" rows="2"></textarea>
              </div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit">
                  <Save :size="15" v-if="profileMenuForm.id" /><Plus :size="15" v-else />
                  {{ profileMenuForm.id ? 'Simpan Perubahan' : 'Tambah Menu' }}
                </button>
              </div>
            </form>
          </div>

          <div class="card">
            <div class="panel-header">
              <div>
                <h2>Daftar Menu Dropdown</h2>
                <p class="panel-desc">{{ profileMenuItems.length }} item terdaftar</p>
              </div>
            </div>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Label</th>
                    <th>Path</th>
                    <th>Urutan</th>
                    <th>Status</th>
                    <th class="col-actions">Aksi</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="item in profileMenuItems" :key="item.id">
                    <td><strong>{{ item.label }}</strong><small>{{ item.description }}</small></td>
                    <td><code>{{ item.path }}{{ item.hash }}</code></td>
                    <td>{{ item.position }}</td>
                    <td><span :class="['status-pill', item.is_active ? 'status-approved' : 'status-rejected']">{{ item.is_active ? 'Aktif' : 'Nonaktif' }}</span></td>
                    <td class="actions">
                      <button class="btn btn-outline btn-xs" @click="editProfileMenu(item)"><Edit2 :size="13" /> Edit</button>
                      <button class="btn btn-danger-soft btn-xs" @click="removeProfileMenu(item.id)"><Trash2 :size="13" /></button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div v-if="!profileMenuItems.length" class="empty-state">
                <Inbox :size="36" />
                <p>Belum ada item dropdown profil.</p>
              </div>
            </div>
          </div>
        </section>

        <!-- ============================================= -->
        <!-- DETAIL HALAMAN PROFIL -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'profile-page'">
          <form class="card" @submit.prevent="saveProfilePage">
            <div class="card-head">
              <div class="card-head-icon soft-blue"><FileText :size="18" /></div>
              <div>
                <h3>Halaman Profil Sekolah</h3>
                <p>Konten khusus untuk halaman profil yang berdiri sendiri.</p>
              </div>
            </div>
            <div class="form-grid">
              <div class="form-group full"><label>Judul Halaman</label><input v-model="profilePageForm.profile_page_title" placeholder="Profil SMK Nurul Jadid" /></div>
              <div class="form-group full"><label>Deskripsi Lengkap</label><textarea v-model="profilePageForm.profile_page_content" rows="8"></textarea></div>
              <div class="form-group full">
                <label>Gambar Profil Sekolah</label>
                <input type="file" accept="image/*" @change="profilePageImage.file = $event.target.files[0]" />
              </div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit"><Save :size="15" /> Simpan Detail</button>
                <button class="btn btn-outline" type="button" @click="saveProfilePageImage"><Upload :size="15" /> Upload Gambar</button>
              </div>
            </div>
          </form>
        </section>

        <!-- ============================================= -->
        <!-- DETAIL VISI MISI -->
        <!-- ============================================= -->
        <section v-else-if="activeTab === 'vision-mission-page'">
          <form class="card" @submit.prevent="saveVisionMissionPage">
            <div class="card-head">
              <div class="card-head-icon soft-green"><Building2 :size="18" /></div>
              <div>
                <h3>Halaman Visi & Misi</h3>
                <p>Konten khusus untuk halaman visi & misi sekolah.</p>
              </div>
            </div>
            <div class="form-grid">
              <div class="form-group full"><label>Pembuka Halaman</label><textarea v-model="visionMissionForm.vision_page_intro" rows="3"></textarea></div>
              <div class="form-group full"><label>Visi Lengkap</label><textarea v-model="visionMissionForm.vision_page_content" rows="6"></textarea></div>
              <div class="form-group full">
                <label>Misi Lengkap</label>
                <textarea v-model="visionMissionForm.mission_page_content" rows="8" placeholder="Gunakan baris baru untuk setiap poin misi"></textarea>
              </div>
              <div class="form-group">
                <label>Gambar Visi</label>
                <input type="file" accept="image/*" @change="visionMissionImages.vision.file = $event.target.files[0]" />
              </div>
              <div class="form-group">
                <label>Gambar Misi</label>
                <input type="file" accept="image/*" @change="visionMissionImages.mission.file = $event.target.files[0]" />
              </div>
              <div class="form-footer full">
                <button class="btn btn-primary" type="submit"><Save :size="15" /> Simpan Visi & Misi</button>
                <button class="btn btn-outline" type="button" @click="saveVisionMissionImages"><Upload :size="15" /> Upload Kedua Gambar</button>
              </div>
            </div>
          </form>
        </section>

        <!-- ============================================= -->
        <!-- KONTEN WEBSITE TAMBAHAN -->
        <!-- ============================================= -->
        <section v-else-if="isContentTab" class="content-studio-panel">
          <AdminContent :initial-type="contentType" embedded />
        </section>

      </main>
    </div>

    <!-- ============================================= -->
    <!-- MODAL: DETAIL PPDB -->
    <!-- ============================================= -->
    <div v-if="selectedApp" class="modal-overlay" @click.self="selectedApp = null">
      <div class="modal">
        <div class="modal-head">
          <div>
            <span class="modal-eyebrow">Detail Pendaftaran</span>
            <h3>{{ selectedApp.nama || selectedApp.name }}</h3>
          </div>
          <button class="modal-close" @click="selectedApp = null">&times;</button>
        </div>
        <div class="modal-body">
          <div class="detail-grid">
            <div><span>No. Pendaftaran</span><strong>{{ selectedApp.no_pendaftaran || '—' }}</strong></div>
            <div><span>NISN</span><strong>{{ selectedApp.nisn || '—' }}</strong></div>
            <div><span>Jurusan</span><span class="badge-soft">{{ selectedApp.program || '—' }}</span></div>
            <div><span>Jalur</span><strong>{{ selectedApp.jalur_pendaftaran || 'Reguler' }}</strong></div>
            <div><span>Email</span><strong>{{ selectedApp.email || '—' }}</strong></div>
            <div><span>Telepon / WA</span><strong>{{ selectedApp.phone || '—' }}</strong></div>
            <div><span>Asal Sekolah</span><strong>{{ selectedApp.asal_sekolah || '—' }}</strong></div>
            <div><span>Status</span><span :class="['status-pill', getStatusClass(selectedApp.status)]">{{ selectedApp.status_label || selectedApp.status }}</span></div>
            <div class="full"><span>Alamat</span><strong>{{ selectedApp.alamat || '—' }}</strong></div>
            <div class="full docs-box">
              <span>Dokumen Pendaftaran</span>
              <div class="docs-links">
                <a
                  v-for="document in applicationDocuments"
                  :key="document.key"
                  v-if="selectedApp[`${document.key}_url`] || selectedApp[`${document.key}_path`]"
                  :href="selectedApp[`${document.key}_url`] || ('/storage/' + selectedApp[`${document.key}_path`])"
                  target="_blank" rel="noopener"
                  class="btn btn-outline btn-xs"
                ><FileText :size="13" /> {{ document.label }}</a>
                <a
                  v-if="selectedApp.berkas_url || selectedApp.berkas_path"
                  :href="selectedApp.berkas_url || ('/storage/' + selectedApp.berkas_path)"
                  target="_blank" rel="noopener"
                  class="btn btn-outline btn-xs"
                ><FileText :size="13" /> Berkas Lama</a>
                <span v-if="!hasApplicationDocuments" class="hint">Belum ada dokumen.</span>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-success" @click="changeStatus(selectedApp, 'Disetujui'); selectedApp = null;"><CheckCircle2 :size="15" /> Setujui</button>
          <button class="btn btn-warn" @click="changeStatus(selectedApp, 'Ditolak'); selectedApp = null;"><XCircle :size="15" /> Tolak</button>
          <button class="btn btn-outline" @click="selectedApp = null">Tutup</button>
        </div>
      </div>
    </div>

    <!-- ============================================= -->
    <!-- MODAL: FASILITAS & SILABUS JURUSAN -->
    <!-- ============================================= -->
    <div v-if="selectedMajorForFacility" class="modal-overlay" @click.self="selectedMajorForFacility = null">
      <div class="modal">
        <div class="modal-head">
          <div>
            <span class="modal-eyebrow">Fasilitas Jurusan</span>
            <h3>{{ selectedMajorForFacility.name }} <span class="modal-code">{{ selectedMajorForFacility.code }}</span></h3>
          </div>
          <button class="modal-close" @click="selectedMajorForFacility = null">&times;</button>
        </div>
        <div class="modal-body">
          <form class="inline-form no-margin" @submit.prevent="saveFacility">
            <div class="form-group grow"><label>Nama Fasilitas</label><input v-model="facilityForm.name" required placeholder="Contoh: Lab Komputer iMac" /></div>
            <div class="form-group grow"><label>Deskripsi</label><input v-model="facilityForm.description" placeholder="Deskripsi singkat" /></div>
            <div class="form-group btn-col"><label>&nbsp;</label><button class="btn btn-primary" type="submit"><Plus :size="14" /> Tambah</button></div>
          </form>

          <div class="modal-section">
            <h4>Daftar Fasilitas</h4>
            <div v-if="majorFacilities.length" class="stack-list">
              <div v-for="fac in majorFacilities" :key="fac.id" class="stack-item">
                <div><strong>{{ fac.name }}</strong><p>{{ fac.description || 'Tanpa deskripsi' }}</p></div>
                <button class="btn btn-danger-soft btn-xs" @click="removeFacility(fac.id)"><Trash2 :size="13" /></button>
              </div>
            </div>
            <p v-else class="hint empty-inline">Belum ada fasilitas.</p>
          </div>

          <div class="modal-section">
            <h4>{{ curriculumForm.id ? 'Ubah Silabus' : 'Tambah Silabus' }}</h4>
            <form class="stack-form" @submit.prevent="saveCurriculum">
              <div class="row-2">
                <div class="form-group"><label>Tahap / Kelas <em>*</em></label><input v-model="curriculumForm.class_name" required placeholder="Kelas 10: Dasar Keahlian" /></div>
                <div class="form-group"><label>Warna</label>
                  <select v-model="curriculumForm.color">
                    <option value="navy">Navy</option><option value="teal">Teal</option><option value="gold">Gold</option>
                  </select>
                </div>
              </div>
              <div class="row-2">
                <div class="form-group"><label>Urutan</label><input v-model.number="curriculumForm.sort_order" type="number" min="0" /></div>
                <div class="form-group"><label>Tag (pisah koma)</label><input v-model="curriculumForm.tags_text" placeholder="K3, Praktik, PKL" /></div>
              </div>
              <div class="form-group"><label>Deskripsi <em>*</em></label><textarea v-model="curriculumForm.description" required rows="2"></textarea></div>
              <div class="form-actions">
                <button class="btn btn-primary btn-sm" type="submit"><Save :size="14" /> {{ curriculumForm.id ? 'Simpan' : 'Tambah' }}</button>
                <button v-if="curriculumForm.id" class="btn btn-ghost btn-sm" type="button" @click="resetCurriculum">Batal</button>
              </div>
            </form>
            <div v-if="majorCurricula.length" class="stack-list">
              <div v-for="curriculum in majorCurricula" :key="curriculum.id" class="stack-item">
                <div>
                  <strong>{{ curriculum.class_name }}</strong>
                  <p>{{ curriculum.description }}</p>
                  <small class="hint">{{ (curriculum.tags || []).join(', ') || 'Tanpa tag' }}</small>
                </div>
                <div class="actions">
                  <button class="btn btn-outline btn-xs" @click="editCurriculum(curriculum)"><Edit2 :size="13" /></button>
                  <button class="btn btn-danger-soft btn-xs" @click="removeCurriculum(curriculum.id)"><Trash2 :size="13" /></button>
                </div>
              </div>
            </div>
            <p v-else class="hint empty-inline">Belum ada silabus.</p>
          </div>
        </div>
        <div class="modal-foot">
          <button class="btn btn-outline" @click="selectedMajorForFacility = null">Tutup</button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import {
  LayoutDashboard, Globe, LogOut, Menu, X, Search, Inbox,
  ClipboardList, GraduationCap, Newspaper, School, Image as ImageIcon,
  Trophy, Camera, Briefcase, ShoppingBag,
  Tag, Users, Settings, RotateCw, Plus, Save, Send, Upload, Edit2,
  Trash2, Building2, FileText, CheckCircle2, XCircle, Clock, List, Sun, Moon
} from 'lucide-vue-next';
import AdminContent from './AdminContent.vue';
import {
  createNews, createMajor, createSiteImage, createStudent, createCategory, createUser,
  deleteNews, deleteMajor, deleteSiteImage, deleteStudent, deleteRegistration, deleteCategory, deleteUser,
  getMajors, getMajorDetail, getNews, getRegistrations, getSiteImages, getSchoolProfile,
  getProfileMenuItems, getStudents, getCategories, getUsers,
  updateNews, uploadNewsImage, updateMajor, uploadMajorImage, updateRegistrationStatus,
  updateSchoolProfile, createProfileMenuItem, updateProfileMenuItem, deleteProfileMenuItem,
  updateStudent, updateSiteImage, uploadSiteImage, updateCategory, updateUser,
  getPpdbSchedule, updatePpdbSchedule,
  addMajorFacility, deleteMajorFacility,
  addMajorCurriculum, updateMajorCurriculum, deleteMajorCurriculum,
  getRegistrationDetail,
  getAdminContent,
} from '../../../api/endpoints';

const router = useRouter();
const route = useRoute();
const activeTab = ref(route.query.tab || 'applications');
const message = ref('');
const messageType = ref('success');
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

const todayDate = computed(() =>
  new Date().toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })
);

// Data state
const applications = ref([]);
const students = ref([]);
const news = ref([]);
const majors = ref([]);
const images = ref([]);
const categories = ref([]);
const usersList = ref([]);
const profileMenuItems = ref([]);
const contentCounts = reactive({
  achievements: 0,
  galleries: 0,
  industry_partners: 0,
  job_vacancies: 0,
  products: 0,
});

// Modals
const selectedApp = ref(null);
const applicationDocuments = [
  { key: 'kk', label: 'Kartu Keluarga' },
  { key: 'ktp_ayah', label: 'KTP Ayah' },
  { key: 'ktp_ibu', label: 'KTP Ibu' },
  { key: 'akta_kelahiran', label: 'Akta Kelahiran' },
  { key: 'ijazah_menengah', label: 'Ijazah' },
  { key: 'dokumen_lain', label: 'Dokumen Lain' },
];
const selectedMajorForFacility = ref(null);
const majorFacilities = ref([]);
const facilityForm = reactive({ name: '', description: '' });
const majorCurricula = ref([]);
const curriculumForm = reactive({ id: null, class_name: '', color: 'navy', description: '', tags_text: '', sort_order: 0 });

// Filter state
const appFilter = reactive({ search: '', status: '' });
const studentSearch = ref('');
const studentMajorFilter = ref(null);
const selectedSectionFilter = ref('');

// Forms
const newsForm = reactive({ id: null, title: '', category: '', excerpt: '', content: '', published_at: '', image: null });
const majorForm = reactive({ id: null, code: '', name: '', capacity: null, description: '', vision: '', mission: '', image: null, image_url: '', is_active: true });
const imageForm = reactive({ id: null, key: '', title: '', section: '', alt_text: '', image_url: '', file: null });
const studentForm = reactive({ id: null, nisn: '', nis: '', name: '', email: '', phone: '', class: '', gender: '', major_id: null, address: '' });
const profileForm = reactive({
  school_name: '', nsm: '', npsn: '', npwp: '',
  profile_title_line1: '', profile_description: '',
  email: '', phone: '', website: '',
  headmaster_name: '', headmaster_message: '',
  headmaster_message_body: '', headmaster_message_statement: '', headmaster_message_closing: '',
  founded_year: null, operating_year: null, accreditation: '', foundation_name: '',
  address: '', village: '', district: '', city: '', vision: '', mission: ''
});
const profilePageForm = reactive({ profile_page_title: '', profile_page_content: '' });
const visionMissionForm = reactive({ vision_page_intro: '', vision_page_content: '', mission_page_content: '' });
const profilePageImage = reactive({ file: null });
const headmasterPhoto = reactive({ file: null });
const visionMissionImages = reactive({ vision: { file: null }, mission: { file: null } });
const categoryForm = reactive({ id: null, name: '', type: 'news' });
const userForm = reactive({ id: null, name: '', email: '', password: '', phone: '', role: 'admin_sekolah', is_active: true });
const ppdbSchedule = reactive({ registration_start: '', registration_end: '' });
const profileMenuForm = reactive({ id: null, label: '', description: '', path: '/profil', hash: '', icon: 'S', position: 1, is_active: true });

// ===== Navigasi sidebar =====
const navGroups = computed(() => [
  {
    label: 'Menu Utama',
    items: [
      { id: 'applications', label: 'Pendaftaran PPDB', icon: ClipboardList, count: applications.value.length },
      { id: 'students', label: 'Data Siswa', icon: GraduationCap, count: students.value.length },
    ],
  },
  {
    label: 'Konten Website',
    items: [
      { id: 'news', label: 'Berita & Kegiatan', icon: Newspaper, count: news.value.length },
      { id: 'majors', label: 'Jurusan', icon: School, count: majors.value.length },
      { id: 'images', label: 'Gambar Website', icon: ImageIcon, count: images.value.length },
      { id: 'categories', label: 'Kategori', icon: Tag, count: categories.value.length },
            { id: 'content-achievements', label: 'Prestasi Siswa', icon: Trophy, count: contentCounts.achievements },
            { id: 'content-galleries', label: 'Galeri Foto', icon: Camera, count: contentCounts.galleries },
            { id: 'content-industry_partners', label: 'Mitra Industri', icon: Building2, count: contentCounts.industry_partners },
            { id: 'content-job_vacancies', label: 'Lowongan Kerja', icon: Briefcase, count: contentCounts.job_vacancies },
            { id: 'content-products', label: 'Produk TEFA', icon: ShoppingBag, count: contentCounts.products },
    ],
  },
  {
    label: 'Pengaturan',
    items: [
      { id: 'users', label: 'Pengguna & Admin', icon: Users, count: usersList.value.length },
      { id: 'profile', label: 'Profil Sekolah', icon: Settings },
      { id: 'profile-menu', label: 'Dropdown Profil', icon: List, count: profileMenuItems.value.length },
      { id: 'profile-page', label: 'Detail Profil', icon: FileText },
      { id: 'vision-mission-page', label: 'Detail Visi & Misi', icon: Building2 },
    ],
  },
]);

const pageTitles = {
  applications: 'Pendaftaran PPDB',
  students: 'Data Siswa',
  news: 'Berita & Kegiatan',
  majors: 'Jurusan & Fasilitas',
  images: 'Gambar Website',
  categories: 'Kategori Konten',
  'content-achievements': 'Prestasi Siswa',
  'content-galleries': 'Galeri Foto',
  'content-industry_partners': 'Mitra Industri',
  'content-job_vacancies': 'Lowongan Kerja',
  'content-products': 'Produk TEFA',
  users: 'Pengguna & Admin',
  profile: 'Profil Sekolah',
  'profile-menu': 'Dropdown Profil',
  'profile-page': 'Detail Halaman Profil',
  'vision-mission-page': 'Detail Visi & Misi',
};

const pageTitle = computed(() => pageTitles[activeTab.value] || 'Dashboard');
const isContentTab = computed(() => activeTab.value.startsWith('content-'));
const contentType = computed(() => activeTab.value.replace(/^content-/, ''));

function goTo(id) {
  activeTab.value = id;
  sidebarOpen.value = false;
  window.scrollTo({ top: 0 });
}

// ===== Statistik PPDB =====
const appStats = computed(() => ({
  total: applications.value.length,
  pending: applications.value.filter(a => a.status === 'pending' || a.status === 'Menunggu').length,
  diterima: applications.value.filter(a => a.status === 'diterima' || a.status === 'Disetujui').length,
  ditolak: applications.value.filter(a => a.status === 'ditolak' || a.status === 'Ditolak').length,
}));

// Filtered lists
const filteredApplications = computed(() => {
  return applications.value.filter(item => {
    const matchSearch = !appFilter.search ||
      (item.nama && item.nama.toLowerCase().includes(appFilter.search.toLowerCase())) ||
      (item.name && item.name.toLowerCase().includes(appFilter.search.toLowerCase())) ||
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

// Helpers
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
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
}

function toIsoString(value) {
  return value ? new Date(value).toISOString() : null;
}

function splitHeadmasterMessage(value) {
  const text = (value || '').replace(/\*\*/g, '').replace(/\r\n?/g, '\n').trim();
  const defaultStatement = 'SMK Nurul Jadid Pusat Keunggulan, Mencetak Wirausaha, Menghadirkan Industri di Sekolah.';
  if (!text) return { body: '', statement: defaultStatement, closing: '' };
  const statementPattern = /SMK Nurul Jadid Pusat Keunggulan, Mencetak Wirausaha, Menghadirkan Industri di Sekolah\.?/i;
  const statementMatch = text.match(statementPattern);
  if (statementMatch) {
    const statement = statementMatch[0];
    return {
      body: text.slice(0, statementMatch.index).trim(),
      statement,
      closing: text.slice(statementMatch.index + statement.length).trim(),
    };
  }
  return { body: text, statement: defaultStatement, closing: '' };
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

async function loadContentCounts() {
  await Promise.all(Object.keys(contentCounts).map(async (type) => {
    try {
      const response = await getAdminContent(type);
      const data = response.data?.data || response.data || [];
      contentCounts[type] = Array.isArray(data) ? data.length : (data.data?.length || 0);
    } catch (error) {
      contentCounts[type] = 0;
    }
  }));
}

async function loadUsers() {
  try {
    const response = await getUsers();
    usersList.value = response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadProfileMenuItems() {
  try {
    const response = await getProfileMenuItems(true);
    profileMenuItems.value = response.data?.data || [];
  } catch (error) { errorMessage(error); }
}

async function loadProfile() {
  try {
    const response = await getSchoolProfile();
    const profile = response.data?.data || {};
    const messageParts = splitHeadmasterMessage(profile.headmaster_message);
    Object.assign(profileForm, {
      ...profile,
      headmaster_message_body: messageParts.body,
      headmaster_message_statement: messageParts.statement,
      headmaster_message_closing: messageParts.closing,
    });
    Object.assign(profilePageForm, profile);
    Object.assign(visionMissionForm, profile);
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
    notify(`Pendaftaran ${item.nama || item.name} berhasil diperbarui.`);
  } catch (error) { errorMessage(error); }
}

async function removeApplication(id) {
  if (!window.confirm('Yakin ingin menghapus data pendaftaran ini?')) return;
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
  window.scrollTo({ top: 0, behavior: 'smooth' });
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
  Object.assign(newsForm, { id: null, title: '', category: '', excerpt: '', content: '', published_at: '', image: null });
}

function editNews(item) {
  Object.assign(newsForm, {
    id: item.id,
    title: item.title || '',
    category: item.category || '',
    excerpt: item.excerpt || '',
    content: item.content || '',
    published_at: toDateTimeLocal(item.published_at),
    image: null,
  });
  window.scrollTo({ top: 0, behavior: 'smooth' });
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
    if (newsForm.published_at) data.append('published_at', new Date(newsForm.published_at).toISOString());

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
// JURUSAN ACTIONS
// =============================================
function resetMajor() {
  Object.assign(majorForm, { id: null, code: '', name: '', capacity: null, description: '', vision: '', mission: '', image: null, image_url: '', is_active: true });
}

function isMajorActive(item) {
  return item.is_active === true || item.is_active === 1 || item.is_active === '1';
}

function onMajorImageSelected(event) {
  const file = event.target.files?.[0];
  if (!file) { majorForm.image = null; return; }
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
  window.scrollTo({ top: 0, behavior: 'smooth' });
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
  if (!window.confirm('Hapus jurusan ini? Data siswa terkait mungkin terdampak.')) return;
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
  resetCurriculum();
  try {
    const res = await getMajorDetail(major.id);
    majorFacilities.value = res.data?.data?.facilities || [];
    majorCurricula.value = res.data?.data?.curricula || [];
  } catch (e) {
    majorFacilities.value = [];
    majorCurricula.value = [];
  }
}

async function saveFacility() {
  if (!selectedMajorForFacility.value) return;
  try {
    await addMajorFacility(selectedMajorForFacility.value.id, {
      name: facilityForm.name,
      description: facilityForm.description,
    });
    notify('Fasilitas berhasil ditambahkan.');
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

function resetCurriculum() {
  Object.assign(curriculumForm, { id: null, class_name: '', color: 'navy', description: '', tags_text: '', sort_order: 0 });
}

function editCurriculum(item) {
  Object.assign(curriculumForm, {
    id: item.id,
    class_name: item.class_name || '',
    color: item.color || 'navy',
    description: item.description || '',
    tags_text: Array.isArray(item.tags) ? item.tags.join(', ') : '',
    sort_order: item.sort_order || 0,
  });
}

function curriculumPayload() {
  return {
    class_name: curriculumForm.class_name,
    color: curriculumForm.color,
    description: curriculumForm.description,
    tags: curriculumForm.tags_text.split(',').map((tag) => tag.trim()).filter(Boolean),
    sort_order: Number(curriculumForm.sort_order) || 0,
  };
}

async function saveCurriculum() {
  if (!selectedMajorForFacility.value) return;
  try {
    const majorId = selectedMajorForFacility.value.id;
    if (curriculumForm.id) {
      await updateMajorCurriculum(majorId, curriculumForm.id, curriculumPayload());
      notify('Silabus berhasil diperbarui.');
    } else {
      await addMajorCurriculum(majorId, curriculumPayload());
      notify('Silabus berhasil ditambahkan.');
    }
    const res = await getMajorDetail(majorId);
    majorCurricula.value = res.data?.data?.curricula || [];
    resetCurriculum();
  } catch (error) { errorMessage(error); }
}

async function removeCurriculum(curriculumId) {
  if (!window.confirm('Hapus silabus ini?')) return;
  try {
    await deleteMajorCurriculum(selectedMajorForFacility.value.id, curriculumId);
    majorCurricula.value = majorCurricula.value.filter((item) => item.id !== curriculumId);
    if (curriculumForm.id === curriculumId) resetCurriculum();
    notify('Silabus berhasil dihapus.');
  } catch (error) { errorMessage(error); }
}

// =============================================
// GAMBAR ACTIONS
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
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

async function saveImage() {
  try {
    if (imageForm.id) {
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
  window.scrollTo({ top: 0, behavior: 'smooth' });
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
  window.scrollTo({ top: 0, behavior: 'smooth' });
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
// PROFIL ACTIONS
// =============================================
async function saveProfile() {
  try {
    const payload = {
      ...profileForm,
      headmaster_message: [
        profileForm.headmaster_message_body,
        profileForm.headmaster_message_statement,
        profileForm.headmaster_message_closing,
      ].filter(Boolean).join('\n'),
    };
    delete payload.headmaster_message_body;
    delete payload.headmaster_message_statement;
    delete payload.headmaster_message_closing;

    await updateSchoolProfile(payload);
    notify('Profil sekolah berhasil diperbarui.');
  } catch (error) { errorMessage(error); }
}

function resetProfileMenu() {
  Object.assign(profileMenuForm, { id: null, label: '', description: '', path: '/profil', hash: '', icon: 'S', position: profileMenuItems.value.length + 1, is_active: true });
}

function editProfileMenu(item) {
  Object.assign(profileMenuForm, { ...item, hash: item.hash || '', icon: item.icon || 'S' });
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

async function saveProfileMenu() {
  try {
    const payload = { ...profileMenuForm };
    delete payload.id;
    if (profileMenuForm.id) {
      await updateProfileMenuItem(profileMenuForm.id, payload);
      notify('Menu dropdown profil berhasil diperbarui.');
    } else {
      await createProfileMenuItem(payload);
      notify('Menu dropdown profil berhasil ditambahkan.');
    }
    resetProfileMenu();
    await loadProfileMenuItems();
  } catch (error) { errorMessage(error); }
}

async function removeProfileMenu(id) {
  if (!window.confirm('Hapus item dropdown profil ini?')) return;
  try {
    await deleteProfileMenuItem(id);
    notify('Item dropdown profil berhasil dihapus.');
    await loadProfileMenuItems();
  } catch (error) { errorMessage(error); }
}

async function saveProfilePage() {
  try {
    await updateSchoolProfile({ ...profilePageForm });
    notify('Detail halaman profil berhasil diperbarui.');
  } catch (error) { errorMessage(error); }
}

async function saveVisionMissionPage() {
  try {
    await updateSchoolProfile({ ...visionMissionForm });
    notify('Detail halaman visi & misi berhasil diperbarui.');
  } catch (error) { errorMessage(error); }
}

async function saveHeadmasterPhoto() {
  await saveManagedPageImage(
    headmasterPhoto,
    'headmaster_photo',
    'Foto kepala sekolah',
    'about',
    'Foto kepala sekolah SMK Nurul Jadid'
  );
}

async function saveManagedPageImage(imageFormData, key, title, section, altText) {
  if (!imageFormData.file) {
    notify(`Pilih file ${title.toLowerCase()} terlebih dahulu.`, 'error');
    return;
  }

  const existingImage = images.value.find((image) => image.key === key);
  try {
    if (existingImage) {
      const data = new FormData();
      data.append('image', imageFormData.file);
      await uploadSiteImage(existingImage.id, data);
    } else {
      const data = new FormData();
      data.append('key', key);
      data.append('title', title);
      data.append('section', section);
      data.append('alt_text', altText);
      data.append('image', imageFormData.file);
      await createSiteImage(data);
    }

    imageFormData.file = null;
    notify(`${title} berhasil diupload.`);
    await loadImages();
  } catch (error) { errorMessage(error); }
}

async function saveProfilePageImage() {
  await saveManagedPageImage(
    profilePageImage,
    'school_profile_image',
    'Gambar profil sekolah',
    'about',
    'Gambar profil SMK Nurul Jadid'
  );
}

async function saveVisionMissionImages() {
  await saveManagedPageImage(visionMissionImages.vision, 'vision_image', 'Gambar visi sekolah', 'about', 'Gambar visi sekolah');
  await saveManagedPageImage(visionMissionImages.mission, 'mission_image', 'Gambar misi sekolah', 'about', 'Gambar misi sekolah');
}

function logout() {
  localStorage.removeItem('auth_token');
  sessionStorage.removeItem('auth_token');
  router.push('/login');
}

onMounted(() => {
  applyTheme();
  Promise.all([
    loadApplications(),
    loadPpdbSchedule(),
    loadStudents(),
    loadNews(),
    loadMajors(),
    loadImages(),
    loadCategories(),
    loadContentCounts(),
    loadUsers(),
    loadProfileMenuItems(),
    loadProfile(),
  ]);
});
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

/* ===== Design tokens ===== */
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
.stat-card,
.news-card,
.major-card,
.image-card,
.modal,
.modal-head,
.modal-foot,
.stack-item,
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
  padding: 14px 12px;
}

.nav-label {
  margin: 16px 10px 6px;
  color: #5d6b84;
  font-size: 10.5px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1.1px;
}
.nav-label:first-child { margin-top: 0; }

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
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
  padding: 1px 7px;
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

.topbar-left { display: flex; align-items: center; gap: 14px; min-width: 0; }
.topbar-left > div { min-width: 0; }

.hamburger {
  display: none;
  background: transparent;
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 7px;
  color: var(--text-2);
  cursor: pointer;
}

.topbar-title {
  margin: 0;
  font-size: 17px;
  font-weight: 700;
  letter-spacing: -0.015em;
  color: var(--text);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.topbar-date { margin: 0; color: var(--text-3); font-size: 12px; }

.topbar-actions { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }

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
  max-width: 1160px;
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
  font-weight: 500;
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
  padding: 0 2px;
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

.btn-success { background: var(--green); color: #fff; }
.btn-success:hover { background: var(--green); }

.btn-warn { background: var(--amber); color: #fff; }
.btn-warn:hover { background: var(--amber); }

.btn-danger-soft { background: var(--red-soft); color: var(--red); }
.btn-danger-soft:hover { background: var(--red-soft); }

/* ================= CARDS & PANELS ================= */
.card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  box-shadow: var(--shadow-card);
  margin-bottom: 22px;
  overflow: hidden;
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

.head-action { margin-left: auto; }

.panel-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 14px;
  flex-wrap: wrap;
  padding: 18px 22px;
  border-bottom: 1px solid var(--border);
}

.panel-header.standalone { padding: 0 2px 14px; border-bottom: 0; margin-top: 26px; }

.panel-header h2 { margin: 0; font-size: 16px; font-weight: 700; letter-spacing: -0.01em; }
.panel-desc { margin: 3px 0 0; color: var(--text-3); font-size: 12.5px; }

.panel-controls {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

/* ================= STATS ================= */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 22px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 14px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 18px;
  box-shadow: var(--shadow-card);
}

.stat-icon {
  width: 42px;
  height: 42px;
  border-radius: 10px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
}

.stat-icon.blue { background: var(--accent-soft); color: var(--accent); }
.stat-icon.amber { background: var(--amber-soft); color: var(--amber); }
.stat-icon.green { background: var(--green-soft); color: var(--green); }
.stat-icon.red { background: var(--red-soft); color: var(--red); }

.stat-value {
  display: block;
  font-size: 22px;
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.1;
}

.stat-label { color: var(--text-3); font-size: 12px; font-weight: 500; }

/* ================= FORMS ================= */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px 18px;
  padding: 20px 22px;
}

.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group.full, .form-footer.full { grid-column: 1 / -1; }
.form-group.grow { flex: 1; min-width: 180px; }

.form-group label {
  display: inline-flex;
  align-items: baseline;
  gap: 3px;
  font-size: 12.5px;
  font-weight: 600;
  color: var(--text-2);
}
.form-group > span {
  font-size: 12.5px;
  font-weight: 600;
  color: var(--text-2);
}
.form-group label em { color: var(--red); font-style: normal; }

.hint { color: var(--text-3); font-size: 12px; }
.char-count { text-align: right; }
.empty-inline { padding: 8px 0; }

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
  margin: 4px -22px -20px;
  border-top: 1px solid var(--border);
  background: var(--surface-subtle);
}

.form-actions { display: flex; gap: 8px; flex-wrap: wrap; }

/* inline form (kategori, fasilitas) */
.inline-form {
  display: flex;
  align-items: flex-end;
  gap: 12px;
  flex-wrap: wrap;
  padding: 20px 22px;
}
.inline-form.no-margin { padding: 0 0 4px; }
.inline-form .btn-col { min-width: 120px; }

/* schedule */
.schedule-card { padding: 0; }
.schedule-fields {
  display: grid;
  grid-template-columns: 1fr 1fr auto;
  gap: 14px;
  align-items: end;
  padding: 20px 22px;
}

/* search box */
.search-box {
  position: relative;
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 200px;
  max-width: 320px;
}

.search-icon {
  position: absolute;
  left: 11px;
  color: var(--text-3);
  pointer-events: none;
}

.search-box input { padding-left: 34px; }

.select-input {
  width: auto;
  min-width: 150px;
  height: 38px;
  padding: 0 30px 0 12px;
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%238a94a5' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'%3e%3cpath d='m6 9 6 6 6-6'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 10px center;
}

/* ================= TABLE ================= */
.table-wrap { overflow-x: auto; }

table { width: 100%; border-collapse: collapse; }

th, td {
  padding: 12px 22px;
  text-align: left;
  font-size: 13.5px;
  vertical-align: top;
}

th {
  background: var(--surface-muted);
  border-bottom: 1px solid var(--border);
  color: var(--text-3);
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  white-space: nowrap;
}

td {
  border-bottom: 1px solid var(--border-subtle);
  color: var(--text-2);
}
tbody tr:last-child td { border-bottom: 0; }
tbody tr:hover td { background: var(--surface-hover); }

td strong { color: var(--text); font-weight: 600; }
td small {
  display: block;
  color: var(--text-3);
  font-size: 12px;
  margin-top: 2px;
}

td code {
  background: var(--surface-soft);
  color: var(--text-2);
  padding: 2px 7px;
  border-radius: 5px;
  font-size: 12px;
}

.col-actions { width: 1%; }
.actions { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; white-space: nowrap; }

/* ================= BADGES ================= */
.status-pill {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  border-radius: 99px;
  padding: 3px 10px;
  font-size: 12px;
  font-weight: 600;
  white-space: nowrap;
}

.status-pill::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: currentColor;
}

.status-pending { background: var(--amber-soft); color: var(--amber-strong); }
.status-verified { background: var(--accent-soft); color: var(--accent); }
.status-approved { background: var(--green-soft); color: var(--green-strong); }
.status-rejected { background: var(--red-soft); color: var(--red-strong); }

.badge-soft {
  display: inline-block;
  background: var(--surface-soft);
  color: var(--text-2);
  border-radius: 6px;
  padding: 3px 9px;
  font-size: 12px;
  font-weight: 600;
}
.badge-soft.accent { background: var(--accent-soft); color: var(--accent); }
.badge-soft.violet { background: var(--violet-soft); color: var(--violet); }

/* ================= NEWS GRID ================= */
.news-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;
}

.news-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: var(--shadow-card);
  transition: box-shadow 0.15s ease, transform 0.15s ease;
}
.news-card:hover { box-shadow: var(--shadow-float); transform: translateY(-2px); }

.news-thumb { position: relative; height: 155px; background: var(--surface-soft); }
.news-thumb img { width: 100%; height: 100%; object-fit: cover; }
.news-thumb-empty { height: 100%; display: grid; place-items: center; color: var(--empty-thumb); }

.publish-flag {
  position: absolute;
  top: 10px;
  right: 10px;
  border-radius: 99px;
  padding: 3px 10px;
  font-size: 11px;
  font-weight: 700;
  color: #fff;
}
.publish-flag.on { background: var(--green); }
.publish-flag.off { background: #6b7688; }

.news-body { padding: 15px 17px; display: flex; flex-direction: column; flex: 1; }
.news-cat {
  font-size: 11px;
  font-weight: 700;
  color: var(--accent);
  text-transform: uppercase;
  letter-spacing: 0.7px;
}
.news-body h3 {
  margin: 6px 0;
  font-size: 14.5px;
  font-weight: 700;
  letter-spacing: -0.01em;
  line-height: 1.4;
}
.news-body > p { font-size: 13px; color: var(--text-3); margin: 0 0 14px; flex: 1; }

.news-foot {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
  border-top: 1px solid var(--border-subtle);
  padding-top: 11px;
}
.news-foot small { color: var(--text-3); }

/* ================= MAJOR CARDS ================= */
.major-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
  gap: 16px;
}

.major-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 18px 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  box-shadow: var(--shadow-card);
}

.major-top { display: flex; justify-content: space-between; align-items: center; }

.major-code {
  background: var(--accent);
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  padding: 3px 9px;
  border-radius: 6px;
  text-transform: uppercase;
  letter-spacing: 0.6px;
}

.major-card h3 { margin: 0; font-size: 16px; font-weight: 700; letter-spacing: -0.01em; }

.major-img { border-radius: 8px; overflow: hidden; border: 1px solid var(--border); }
.major-img img { width: 100%; height: 125px; object-fit: cover; display: block; }

.major-desc { font-size: 13px; color: var(--text-3); margin: 0; flex: 1; }

.major-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12.5px;
  color: var(--text-2);
  padding-top: 11px;
  border-top: 1px solid var(--border-subtle);
}

.major-actions { display: flex; gap: 6px; flex-wrap: wrap; }

/* ================= IMAGE GRID ================= */
.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 16px;
}

.image-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: var(--shadow-card);
}

.image-box { height: 145px; background: var(--surface-soft); }
.image-box img { width: 100%; height: 100%; object-fit: cover; }

.image-info { padding: 13px 15px; display: flex; flex-direction: column; gap: 7px; flex: 1; }
.image-info strong { font-size: 13.5px; }
.image-tags { display: flex; align-items: center; gap: 7px; flex-wrap: wrap; }
.image-tags code { font-size: 11.5px; color: var(--text-3); }

.image-actions {
  padding: 10px 15px;
  border-top: 1px solid var(--border-subtle);
  display: flex;
  justify-content: flex-end;
  gap: 6px;
}

/* ================= EMPTY STATE ================= */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 48px 20px;
  color: var(--text-3);
  text-align: center;
}
.empty-state p { margin: 0; font-size: 13.5px; }

/* ================= MODAL ================= */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(16, 25, 43, 0.55);
  backdrop-filter: blur(3px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  z-index: 600;
}

.modal {
  background: var(--surface);
  border-radius: 14px;
  width: 100%;
  max-width: 620px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: var(--shadow-float);
}

.modal-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 24px;
  border-bottom: 1px solid var(--border);
  position: sticky;
  top: 0;
  background: var(--surface);
  z-index: 2;
}

.modal-eyebrow {
  display: block;
  color: var(--accent);
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 2px;
}

.modal-head h3 { margin: 0; font-size: 17px; font-weight: 700; letter-spacing: -0.01em; }
.modal-code {
  font-size: 12px;
  background: var(--surface-soft);
  color: var(--text-2);
  padding: 2px 8px;
  border-radius: 5px;
  vertical-align: middle;
}

.modal-close {
  background: transparent;
  border: 0;
  font-size: 26px;
  color: var(--text-3);
  cursor: pointer;
  line-height: 1;
}
.modal-close:hover { color: var(--text); }

.modal-body { padding: 20px 24px; }

.modal-section { margin-top: 22px; }
.modal-section h4 {
  margin: 0 0 10px;
  font-size: 13.5px;
  font-weight: 700;
  color: var(--text);
}

.modal-foot {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  flex-wrap: wrap;
  padding: 15px 24px;
  border-top: 1px solid var(--border);
  background: var(--surface-subtle);
  position: sticky;
  bottom: 0;
}

/* detail grid dalam modal */
.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
}

.detail-grid > div {
  padding: 11px 0;
  border-bottom: 1px solid var(--border-subtle);
  font-size: 13.5px;
}
.detail-grid .full { grid-column: 1 / -1; border-bottom: 0; }

.detail-grid span {
  display: block;
  color: var(--text-3);
  font-size: 11.5px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.6px;
  margin-bottom: 3px;
}

.docs-box {
  background: var(--surface-muted);
  border: 1px dashed var(--border-strong);
  border-radius: 10px;
  padding: 14px 16px;
  margin-top: 6px;
}
.docs-links { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 9px; }

/* stack list dalam modal */
.stack-list { display: grid; gap: 8px; margin-top: 10px; }

.stack-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  border: 1px solid var(--border);
  border-radius: 10px;
  padding: 11px 14px;
  background: var(--surface-subtle);
}
.stack-item strong { font-size: 13.5px; }
.stack-item p { margin: 2px 0 0; font-size: 12.5px; color: var(--text-3); }

.stack-form { display: flex; flex-direction: column; gap: 12px; margin-bottom: 14px; }
.row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }

/* ================= TRANSISI & RESPONSIVE ================= */
@media (max-width: 1024px) {
  .sidebar {
    transform: translateX(-100%);
    transition: transform 0.22s ease;
  }
  .sidebar.open { transform: translateX(0); }
  .sidebar-close { display: block; }
  .main-area { margin-left: 0; }
  .hamburger { display: grid; place-items: center; }
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .topbar { padding: 12px 16px; }
  .topbar-actions .btn-danger-soft span { display: none; }
  .topbar-actions .btn-danger-soft { padding: 8px; }
  .content { padding: 18px 16px 56px; }
  .form-grid { grid-template-columns: 1fr; }
  .row-2 { grid-template-columns: 1fr; }
  .schedule-fields { grid-template-columns: 1fr; }
  .stats-grid { grid-template-columns: 1fr 1fr; gap: 10px; }
  .stat-card { padding: 14px; flex-direction: column; align-items: flex-start; gap: 8px; }
  .detail-grid { grid-template-columns: 1fr; }
  th, td { padding: 11px 14px; }
  .panel-header { flex-direction: column; align-items: stretch; }
  .search-box { max-width: none; }
  .select-input { flex: 1; }
  .modal-foot .btn { flex: 1; justify-content: center; }
}
</style>