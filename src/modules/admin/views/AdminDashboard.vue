<template>
  <div class="dashboard-layout">
    <!-- Sidebar -->
    <aside class="sidebar" :class="{ 'sidebar--open': sidebarOpen }">
      <div class="sidebar-inner">
        <div class="sidebar-brand">
          <router-link to="/" class="sidebar-logo">
            <img :src="logo" alt="Logo SMK" class="sidebar-logo-img" />
            <div>
              <span class="sidebar-brand-name">SMK Nurul Jadid</span>
              <span class="sidebar-brand-subtitle">Admin Portal</span>
            </div>
          </router-link>
        </div>

        <button class="sidebar-new-entry" @click="handleNewEntry">
          + Content Studio
        </button>

        <nav class="sidebar-nav">
          <router-link to="/admin/dashboard" class="sidebar-item sidebar-item--active">
            <LayoutGrid :size="20" color="#1e3a8a" />
            <span>Dashboard</span>
          </router-link>
          <router-link to="/admin/content" class="sidebar-item">
            <Newspaper :size="20" color="#4b5563" />
            <span>Content Studio</span>
          </router-link>
          <router-link to="/admin/manage" class="sidebar-item">
            <Users :size="20" color="#4b5563" />
            <span>Kelola Admin</span>
          </router-link>
          <router-link to="/jurusan" class="sidebar-item">
            <GraduationCap :size="20" color="#4b5563" />
            <span>Jurusan</span>
          </router-link>
          <router-link to="/galeri" class="sidebar-item">
            <Image :size="20" color="#4b5563" />
            <span>Galeri</span>
          </router-link>
          <router-link to="/ppdb" class="sidebar-item">
            <UserPlus :size="20" color="#4b5563" />
            <span>PPDB Portal</span>
          </router-link>

          <div class="sidebar-spacer"></div>

          <router-link to="/" class="sidebar-item">
            <Globe :size="20" color="#4b5563" />
            <span>Lihat Website ↗</span>
          </router-link>
        </nav>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="main-wrapper">
      <!-- Header -->
      <header class="dashboard-header">
        <div class="header-inner">
          <button class="header-menu-btn" @click="sidebarOpen = !sidebarOpen" aria-label="Toggle menu">
            <Menu :size="24" color="#1e293b" />
          </button>

          <div class="header-search">
            <Search :size="18" color="#9ca3af" />
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search pendaftar..."
              class="header-search-input"
              @input="handleSearch"
            />
          </div>

          <div class="header-user">
            <button @click="fetchData" class="header-notif-btn" :disabled="isLoading" title="Refresh Data">
              <RefreshCw :size="18" :class="{ 'spin-anim': isLoading }" color="#4b5563" />
            </button>
            <div class="header-divider"></div>
            <div class="header-user-info">
              <img :src="userAvatar" alt="Avatar" class="header-avatar" />
              <div class="header-user-text">
                <span class="header-user-name">{{ user.name || 'Administrator' }}</span>
                <span class="header-user-role">{{ user.email || 'Admin SMK' }}</span>
              </div>
            </div>
            <button @click="handleLogout" class="header-logout-btn" title="Logout">
              <LogOut :size="18" color="#ef4444" />
            </button>
          </div>
        </div>
      </header>

      <!-- Content Body -->
      <main class="dashboard-body">
        <div class="dashboard-container">
          <!-- Welcome Section -->
          <div class="welcome-section">
            <div class="welcome-text">
              <h1 class="welcome-title">Selamat Datang, Admin!</h1>
              <p class="welcome-subtitle">Kelola pendaftaran PPDB siswa, kemitraan industri, dan konten sekolah SMK Nurul Jadid.</p>
            </div>
            <div class="date-badge">
              <Calendar :size="16" color="#1e3a8a" />
              <span>{{ currentDate }}</span>
            </div>
          </div>

          <!-- Statistics Cards -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon-circle stat-icon-circle--blue">
                <Users :size="24" color="#1e3a8a" />
              </div>
              <div class="stat-content">
                <div class="stat-header">
                  <span class="stat-label">Total Pendaftar PPDB</span>
                  <span class="stat-badge stat-badge--green">{{ registrations.length }} Total</span>
                </div>
                <div class="stat-value">{{ registrations.length || animatedStats.newApplications }}</div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon-circle stat-icon-circle--orange">
                <Loader2 :size="24" color="#9a3412" />
              </div>
              <div class="stat-content">
                <span class="stat-label">Menunggu Verifikasi</span>
                <div class="stat-value">{{ pendingCount }}</div>
                <span class="stat-subtext">Perlu Tindakan</span>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon-circle stat-icon-circle--green">
                <CheckCircle :size="24" color="#065f46" />
              </div>
              <div class="stat-content">
                <div class="stat-header">
                  <span class="stat-label">Pendaftar Disetujui</span>
                  <span class="stat-badge stat-badge--green">Lolos</span>
                </div>
                <div class="stat-value">{{ approvedCount }}</div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon-circle stat-icon-circle--blue">
                <Building2 :size="24" color="#1e3a8a" />
              </div>
              <div class="stat-content">
                <span class="stat-label">Mitra Industri</span>
                <div class="stat-value">{{ industryCount }} Mitra</div>
              </div>
            </div>
          </div>

          <!-- Pendaftaran PPDB Table -->
          <div class="section-card">
            <div class="section-header">
              <div>
                <h2 class="section-title">Data Pendaftaran PPDB Masuk</h2>
                <p class="section-subtitle" style="margin: 0; color: #64748b; font-size: 0.875rem;">Verifikasi dan perbarui status pendaftaran calon siswa baru.</p>
              </div>
              <div class="table-filters" style="display: flex; gap: 8px;">
                <select v-model="filterStatus" class="filter-select" style="padding: 6px 12px; border: 1px solid #cbd5e1; border-radius: 6px; background: white; font-size: 0.875rem;">
                  <option value="">Semua Status</option>
                  <option value="Menunggu">Menunggu</option>
                  <option value="Disetujui">Disetujui</option>
                  <option value="Ditolak">Ditolak</option>
                </select>
              </div>
            </div>

            <div v-if="errorMessage" class="error-banner" style="margin: 1rem 0; padding: 0.75rem 1rem; background: #fee2e2; color: #991b1b; border-radius: 8px;">
              {{ errorMessage }}
            </div>

            <div class="table-responsive">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Tanggal</th>
                    <th>Nama Siswa</th>
                    <th>NISN</th>
                    <th>Program Jurusan</th>
                    <th>Status</th>
                    <th>Aksi Verifikasi</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-if="filteredRegistrations.length === 0">
                    <td colspan="6" class="empty-state" style="text-align: center; padding: 2rem; color: #64748b;">
                      Belum ada data pendaftar yang sesuai.
                    </td>
                  </tr>
                  <tr v-for="item in filteredRegistrations" :key="item.id">
                    <td class="text-sm text-gray">{{ formatDisplayDate(item.created_at || item.createdAt) }}</td>
                    <td>
                      <div class="student-info">
                        <strong>{{ item.nama || item.name }}</strong>
                        <span class="text-sm text-gray" style="display: block; font-size: 0.8rem; color: #64748b;">{{ item.email || '-' }}</span>
                      </div>
                    </td>
                    <td class="font-mono text-sm">{{ item.nisn || '-' }}</td>
                    <td>
                      <span class="program-tag" style="padding: 4px 8px; background: #e0e7ff; color: #3730a3; border-radius: 6px; font-size: 0.8rem; font-weight: 600;">
                        {{ item.program || item.major || '-' }}
                      </span>
                    </td>
                    <td>
                      <span
                        class="status-badge"
                        :class="statusBadgeClass(item.status)"
                        style="padding: 4px 10px; border-radius: 9999px; font-size: 0.75rem; font-weight: 700;"
                      >
                        {{ displayStatusLabel(item.status) }}
                      </span>
                    </td>
                    <td>
                      <div class="action-buttons" style="display: flex; gap: 6px;">
                        <button
                          @click="changeStatus(item.id, 'Disetujui')"
                          class="act-btn btn-approve"
                          :disabled="isStatusApproved(item.status)"
                          style="padding: 4px 10px; background: #16a34a; color: white; border: none; border-radius: 6px; font-size: 0.8rem; cursor: pointer;"
                        >
                          Setujui
                        </button>
                        <button
                          @click="changeStatus(item.id, 'Ditolak')"
                          class="act-btn btn-reject"
                          :disabled="isStatusRejected(item.status)"
                          style="padding: 4px 10px; background: #dc2626; color: white; border: none; border-radius: 6px; font-size: 0.8rem; cursor: pointer;"
                        >
                          Tolak
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Quick Actions & Upcoming Events -->
          <div class="bottom-grid">
            <!-- Quick Actions -->
            <div class="section-card">
              <h2 class="section-title">Quick Actions</h2>
              <div class="quick-actions">
                <button class="quick-action-btn" @click="handleQuickAction('add-news')">
                  <div class="quick-action-icon quick-action-icon--blue">
                    <FilePlus :size="20" color="#1e3a8a" />
                  </div>
                  <span>Content Studio</span>
                </button>
                <button class="quick-action-btn" @click="handleQuickAction('manage-admin')">
                  <div class="quick-action-icon quick-action-icon--purple">
                    <Users :size="20" color="#6b21a8" />
                  </div>
                  <span>Kelola Admin</span>
                </button>
                <button class="quick-action-btn" @click="handleQuickAction('export-ppdb')">
                  <div class="quick-action-icon quick-action-icon--blue">
                    <Download :size="20" color="#1e3a8a" />
                  </div>
                  <span>Export PPDB Data</span>
                </button>
              </div>
            </div>

            <!-- Upcoming Events -->
            <div class="section-card events-card">
              <h2 class="section-title section-title--white">Upcoming Events</h2>
              <div class="events-list">
                <div v-for="event in upcomingEvents" :key="event.id" class="event-item">
                  <div class="event-date-box">
                    <span class="event-month">{{ event.month }}</span>
                    <span class="event-day">{{ event.day }}</span>
                  </div>
                  <div class="event-info">
                    <h3 class="event-title">{{ event.title }}</h3>
                    <p class="event-desc">{{ event.description }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import logo from '../../../assets/logo.webp';
import { getRegistrations, updateRegistrationStatus, getDashboardStats } from '../../../api/endpoints';
import {
  LayoutGrid,
  GraduationCap,
  Newspaper,
  Image,
  UserPlus,
  Settings,
  Search,
  Bell,
  Calendar,
  LogOut,
  Menu,
  Users,
  UserCheck,
  FileText,
  FilePlus,
  Download,
  Pencil,
  Settings as GearIcon,
  CheckCircle,
  Clock,
  RefreshCw,
  AlertTriangle,
  Loader2,
  Building2,
  Globe
} from 'lucide-vue-next';

const router = useRouter();

const sidebarOpen = ref(false);
const searchQuery = ref('');
const filterProgram = ref('');
const filterStatus = ref('');
const user = ref({ name: 'Administrator', email: 'admin@smknuruljadid.edu' });
const registrations = ref([]);
const industryCount = ref(0);
const isLoading = ref(false);
const errorMessage = ref('');

const stats = ref({
  totalStudents: 1240,
  activePrograms: 5,
  newApplications: 42,
  publishedNews: 128
});

const animatedStats = ref({
  totalStudents: 0,
  activePrograms: 0,
  newApplications: 0,
  publishedNews: 0
});

const recentActivities = ref([
  {
    id: 1,
    icon: Pencil,
    iconBg: 'blue',
    action: 'News Update',
    target: 'Prestasi Siswa 2024',
    date: '2 hrs ago',
    status: 'Published',
    statusType: 'success',
    statusIcon: CheckCircle,
    statusIconColor: '#15803d'
  },
  {
    id: 2,
    icon: GearIcon,
    iconBg: 'green',
    action: 'Program Edit',
    target: 'Teknik Komputer',
    date: '5 hrs ago',
    status: 'Updated',
    statusType: 'info',
    statusIcon: CheckCircle,
    statusIconColor: '#1d4ed8'
  },
  {
    id: 3,
    icon: UserPlus,
    iconBg: 'orange',
    action: 'New Admission',
    target: 'Batch 2025',
    date: 'Yesterday',
    status: 'Pending',
    statusType: 'warning',
    statusIcon: Clock,
    statusIconColor: '#7c3aed'
  }
]);

const upcomingEvents = ref([
  {
    id: 1,
    month: 'OCT',
    day: '15',
    title: 'Mid-Term Exams',
    description: 'All vocational programs'
  },
  {
    id: 2,
    month: 'OCT',
    day: '22',
    title: 'Industry Visit',
    description: 'Software Engineering'
  }
]);

const userAvatar = 'https://images.unsplash.com/photo-1497215842964-222b430dc094?w=100&h=100&fit=crop&crop=face';

const currentDate = computed(() => {
  return new Date().toLocaleDateString('id-ID', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });
});

const isStatusPending = (status) => status === 'Menunggu' || status === 'pending' || status === 'verifikasi';
const isStatusApproved = (status) => status === 'Disetujui' || status === 'diterima' || status === 'approved';
const isStatusRejected = (status) => status === 'Ditolak' || status === 'ditolak' || status === 'rejected';

const displayStatusLabel = (status) => {
  if (isStatusApproved(status)) return 'Disetujui';
  if (isStatusRejected(status)) return 'Ditolak';
  return 'Menunggu';
};

const statusBadgeClass = (status) => {
  if (isStatusApproved(status)) return 'badge-approved';
  if (isStatusRejected(status)) return 'badge-rejected';
  return 'badge-pending';
};

const formatDisplayDate = (dateStr) => {
  if (!dateStr) return '-';
  try {
    const d = new Date(dateStr);
    return isNaN(d.getTime()) ? dateStr : d.toLocaleDateString('id-ID', { day: '2-digit', month: 'short', year: 'numeric' });
  } catch {
    return dateStr;
  }
};

const pendingCount = computed(() => registrations.value.filter(r => isStatusPending(r.status)).length);
const approvedCount = computed(() => registrations.value.filter(r => isStatusApproved(r.status)).length);

const filteredRegistrations = computed(() => {
  return registrations.value.filter(item => {
    const name = (item.nama || item.name || '').toLowerCase();
    const email = (item.email || '').toLowerCase();
    const nisn = (item.nisn || '');
    const q = searchQuery.value.toLowerCase();

    const matchSearch = !searchQuery.value || name.includes(q) || email.includes(q) || nisn.includes(q);
    const matchProgram = !filterProgram.value || item.program === filterProgram.value;
    const matchStatus = !filterStatus.value || displayStatusLabel(item.status) === filterStatus.value;

    return matchSearch && matchProgram && matchStatus;
  });
});

function animateValue(key, end, duration = 1500) {
  const start = 0;
  const startTime = performance.now();
  
  function update(currentTime) {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const easeOut = 1 - Math.pow(1 - progress, 3);
    const current = Math.floor(start + (end - start) * easeOut);
    animatedStats.value[key] = current;
    if (progress < 1) {
      requestAnimationFrame(update);
    }
  }
  
  requestAnimationFrame(update);
}

let searchDebounce = null;
function handleSearch() {
  clearTimeout(searchDebounce);
  searchDebounce = setTimeout(() => {
    console.log('Search:', searchQuery.value);
  }, 300);
}

function handleNewEntry() {
  router.push('/admin/content');
}

function handleQuickAction(action) {
  if (action === 'add-news') router.push('/admin/content');
  else if (action === 'update-program') router.push('/admin/content');
  else if (action === 'manage-admin') router.push('/admin/manage');
  else if (action === 'export-ppdb') {
    window.alert('Data pendaftaran PPDB siap diekspor.');
  }
}

const changeStatus = async (id, newStatus) => {
  errorMessage.value = '';
  try {
    await updateRegistrationStatus(id, newStatus);
    const item = registrations.value.find(r => r.id === id || r.id == id);
    if (item) item.status = newStatus;
  } catch (error) {
    console.error('Gagal memperbarui status:', error);
    errorMessage.value = 'Gagal memperbarui status pendaftaran. Silakan coba lagi.';
  }
};

const handleLogout = () => {
  localStorage.removeItem('auth_token');
  sessionStorage.removeItem('auth_token');
  localStorage.removeItem('admin_token');
  localStorage.removeItem('admin_email');
  localStorage.removeItem('admin_remember_email');
  sessionStorage.removeItem('admin_token');
  sessionStorage.removeItem('admin_email');
  router.push('/login');
};

const fetchData = async () => {
  isLoading.value = true;
  errorMessage.value = '';
  try {
    const [regRes, statsRes] = await Promise.allSettled([
      getRegistrations(),
      getDashboardStats()
    ]);

    if (regRes.status === 'fulfilled') {
      const res = regRes.value;
      if (Array.isArray(res.data)) {
        registrations.value = res.data;
      } else if (Array.isArray(res.data?.data?.data)) {
        registrations.value = res.data.data.data;
      } else if (Array.isArray(res.data?.data)) {
        registrations.value = res.data.data;
      } else {
        registrations.value = [];
      }
    }

    if (statsRes.status === 'fulfilled') {
      const statsData = statsRes.value?.data?.data;
      if (statsData) {
        industryCount.value = statsData.total_industry_partners ?? statsData.industry_partners ?? 0;
        if (statsData.total_students) stats.value.totalStudents = statsData.total_students;
        if (statsData.total_majors) stats.value.activePrograms = statsData.total_majors;
        if (statsData.total_registrations) stats.value.newApplications = statsData.total_registrations;
        if (statsData.total_news) stats.value.publishedNews = statsData.total_news;
      }
    }
  } catch (error) {
    console.error('Gagal mengambil data pendaftaran:', error);
    errorMessage.value = 'Gagal memuat data pendaftaran. Silakan coba lagi nanti.';
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  const token = localStorage.getItem('auth_token') || sessionStorage.getItem('auth_token') || localStorage.getItem('admin_token');
  if (!token) {
    router.push('/login');
    return;
  }

  const storedEmail = localStorage.getItem('admin_email') || sessionStorage.getItem('admin_email');
  if (storedEmail) {
    user.value = { name: 'Administrator', email: storedEmail };
  }

  fetchData();
  
  animateValue('totalStudents', stats.value.totalStudents);
  animateValue('activePrograms', stats.value.activePrograms);
  animateValue('newApplications', stats.value.newApplications);
  animateValue('publishedNews', stats.value.publishedNews);
});
</script>

<style scoped>
.dashboard-layout {
  display: flex;
  min-height: 100vh;
  background: #f9fafb;
  font-family: 'Inter', 'Plus Jakarta Sans', system-ui, sans-serif;
}

/* Sidebar */
.sidebar {
  width: 280px;
  background: #f3f4ff;
  padding: 24px;
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  height: 100vh;
  z-index: 40;
  transition: transform 0.3s ease;
}

.sidebar-inner {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.sidebar-brand {
  margin-bottom: 24px;
}

.sidebar-logo {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  text-decoration: none;
}

.sidebar-logo-img {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  object-fit: cover;
}

.sidebar-brand-name {
  display: block;
  font-weight: 700;
  font-size: 1rem;
  color: #1e3a8a;
}

.sidebar-brand-subtitle {
  display: block;
  font-size: 0.75rem;
  color: #6b7280;
}

.sidebar-new-entry {
  width: 100%;
  height: 50px;
  background: #1e3a8a;
  color: #ffffff;
  border: none;
  border-radius: 12px;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s ease;
  margin-bottom: 24px;
}

.sidebar-new-entry:hover {
  background: #16264d;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
}

.sidebar-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  text-decoration: none;
  font-size: 0.95rem;
  font-weight: 500;
  color: #4b5563;
  transition: all 0.2s ease;
}

.sidebar-item:hover {
  background: #e5e7eb;
}

.sidebar-item--active {
  background: #e0e7ff;
  color: #1e3a8a;
  font-weight: 700;
}

.sidebar-spacer {
  flex: 1;
}

/* Main Wrapper */
.main-wrapper {
  flex: 1;
  margin-left: 280px;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* Header */
.dashboard-header {
  background: #ffffff;
  border-bottom: 1px solid #e5e7eb;
  padding: 16px 32px;
  position: sticky;
  top: 0;
  z-index: 30;
}

.header-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}

.header-menu-btn {
  display: none;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
}

.header-search {
  flex: 1;
  max-width: 400px;
  position: relative;
}

.header-search-input {
  width: 100%;
  height: 45px;
  padding: 0 16px 0 44px;
  border-radius: 12px;
  border: 1px solid #d1d5db;
  background: #f8f7ff;
  font-size: 0.95rem;
  outline: none;
  transition: border-color 0.2s ease;
}

.header-search-input:focus {
  border-color: #3b82f6;
}

.header-search svg {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  pointer-events: none;
}

.header-user {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-notif-btn {
  position: relative;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
}

.notif-badge {
  position: absolute;
  top: 2px;
  right: 2px;
  width: 8px;
  height: 8px;
  background: #ef4444;
  border-radius: 50%;
}

.header-divider {
  width: 1px;
  height: 24px;
  background: #d1d5db;
}

.header-user-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-avatar {
  width: 45px;
  height: 45px;
  border-radius: 50%;
  object-fit: cover;
}

.header-user-text {
  display: flex;
  flex-direction: column;
}

.header-user-name {
  font-weight: 700;
  font-size: 0.9rem;
  color: #1e293b;
}

.header-user-role {
  font-size: 0.75rem;
  color: #6b7280;
}

.header-logout-btn {
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
}

/* Body */
.dashboard-body {
  flex: 1;
  padding: 32px;
}

.dashboard-container {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* Welcome */
.welcome-section {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.welcome-title {
  font-size: 42px;
  font-weight: 700;
  color: #1e3a8a;
  margin: 0 0 8px;
}

.welcome-subtitle {
  font-size: 16px;
  color: #6b7280;
  margin: 0;
}

.date-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: #eef2ff;
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 500;
  color: #1e3a8a;
  white-space: nowrap;
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 24px;
}

.stat-card {
  background: #ffffff;
  border-radius: 20px;
  padding: 24px;
  height: 180px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  transition: box-shadow 0.3s ease, transform 0.3s ease;
  display: flex;
  align-items: flex-start;
  gap: 16px;
}

.stat-card:hover {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.stat-icon-circle {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.stat-icon-circle--blue {
  background: #e0e7ff;
}

.stat-icon-circle--green {
  background: #d1fae5;
}

.stat-icon-circle--orange {
  background: #ffedd5;
}

.stat-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
}

.stat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.stat-label {
  font-size: 14px;
  color: #6b7280;
  font-weight: 500;
}

.stat-badge {
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 700;
}

.stat-badge--green {
  background: #dcfce7;
  color: #15803d;
}

.stat-badge--orange {
  background: #f59e0b;
  color: #ffffff;
}

.stat-value {
  font-size: 36px;
  font-weight: 700;
  color: #1e3a8a;
  line-height: 1.2;
}

.stat-subtext {
  font-size: 12px;
  color: #6b7280;
}

/* Section Card */
.section-card {
  background: #ffffff;
  border-radius: 20px;
  padding: 32px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.section-title {
  font-size: 24px;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
}

.section-title--white {
  color: #ffffff;
}

.section-link {
  font-size: 14px;
  color: #3b82f6;
  background: none;
  border: none;
  cursor: pointer;
  font-weight: 500;
}

/* Table */
.table-responsive {
  width: 100%;
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th {
  text-align: left;
  padding: 12px 16px;
  font-size: 14px;
  font-weight: 600;
  color: #6b7280;
  border-bottom: 1px solid #e5e7eb;
}

.data-table td {
  padding: 16px;
  border-bottom: 1px solid #f3f4f6;
  font-size: 14px;
  color: #1e293b;
}

.activity-icon {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
  vertical-align: middle;
}

.activity-icon--blue {
  background: #dbeafe;
}

.activity-icon--green {
  background: #d1fae5;
}

.activity-icon--orange {
  background: #ffedd5;
}

.activity-action {
  font-weight: 500;
}

.activity-target {
  color: #6b7280;
  font-style: italic;
}

.activity-date {
  color: #9ca3af;
  font-size: 13px;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 12px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
}

.status-badge--success {
  background: #dcfce7;
  color: #15803d;
}

.status-badge--info {
  background: #dbeafe;
  color: #1d4ed8;
}

.status-badge--warning {
  background: #f3e8ff;
  color: #7c3aed;
}

/* Bottom Grid */
.bottom-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

.quick-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 16px;
}

.quick-action-btn {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #ffffff;
  cursor: pointer;
  font-size: 0.95rem;
  font-weight: 500;
  color: #1e293b;
  transition: background 0.2s ease;
}

.quick-action-btn:hover {
  background: #f9fafb;
}

.quick-action-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.quick-action-icon--blue {
  background: #e0e7ff;
}

.quick-action-icon--purple {
  background: #f3e8ff;
}

/* Events */
.events-card {
  background: #1e3a8a;
  color: #ffffff;
}

.events-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-top: 20px;
}

.event-item {
  display: flex;
  gap: 16px;
  align-items: flex-start;
}

.event-date-box {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 8px 12px;
  text-align: center;
  min-width: 60px;
}

.event-month {
  display: block;
  font-size: 12px;
  font-weight: 600;
  opacity: 0.8;
}

.event-day {
  display: block;
  font-size: 24px;
  font-weight: 700;
}

.event-title {
  font-size: 1rem;
  font-weight: 700;
  margin: 0 0 4px;
}

.event-desc {
  font-size: 0.875rem;
  opacity: 0.8;
  margin: 0;
}

/* Responsive */
@media (max-width: 1279px) {
  .stats-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 1023px) {
  .sidebar {
    transform: translateX(-100%);
  }

  .sidebar--open {
    transform: translateX(0);
  }

  .main-wrapper {
    margin-left: 0;
  }

  .header-menu-btn {
    display: block;
  }

  .bottom-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 639px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }

  .welcome-section {
    flex-direction: column;
    gap: 16px;
  }

  .welcome-title {
    font-size: 28px;
  }

  .dashboard-header {
    padding: 12px 16px;
  }

  .header-search {
    max-width: none;
  }

  .dashboard-body {
    padding: 16px;
  }
}
</style>
