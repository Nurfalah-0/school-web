<template>
  <div class="dashboard-layout">
    <!-- Top Header -->
    <header class="dashboard-header">
      <div class="header-inner">
        <div class="brand-area">
          <router-link to="/" class="brand-logo">SMK Admin</router-link>
        </div>
        <div class="user-area">
          <span class="user-badge">Admin SMK</span>
          <span class="user-name">{{ user.name || 'Administrator' }}</span>
          <router-link to="/" class="nav-btn text-btn">Lihat Portal ↗</router-link>
          <button @click="handleLogout" class="nav-btn logout-btn">Keluar</button>
        </div>
      </div>
    </header>

    <!-- Main Content Body -->
    <main class="dashboard-body">
      <div class="dashboard-container">
        <!-- Title & Action Header -->
        <div class="page-title-bar">
          <div>
            <h2>Dashboard Kelola Pendaftaran PKL</h2>
            <p>Verifikasi data pendaftaran siswa dan pengelolaan status kemitraan.</p>
          </div>
          <button @click="fetchData" class="refresh-btn" :disabled="isLoading">
            🔄 {{ isLoading ? 'Memuat...' : 'Refresh Data' }}
          </button>
        </div>
        <div v-if="errorMessage" class="dashboard-alert">
          ⚠️ {{ errorMessage }}
        </div>

        <!-- Metrics & Stats Cards -->
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon bg-blue">📋</div>
            <div class="stat-info">
              <span class="stat-label">Total Pendaftar</span>
              <strong class="stat-val">{{ registrations.length }}</strong>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon bg-amber">⌛</div>
            <div class="stat-info">
              <span class="stat-label">Menunggu Verifikasi</span>
              <strong class="stat-val">{{ pendingCount }}</strong>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon bg-green">✅</div>
            <div class="stat-info">
              <span class="stat-label">Disetujui</span>
              <strong class="stat-val">{{ approvedCount }}</strong>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon bg-purple">🏢</div>
            <div class="stat-info">
              <span class="stat-label">Mitra Industri</span>
              <strong class="stat-val">12 Mitra</strong>
            </div>
          </div>
        </div>

        <!-- Table Filters & Search -->
        <div class="table-card">
          <div class="table-toolbar">
            <div class="search-box">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Cari berdasarkan nama, email, atau NISN..."
              />
            </div>
            <div class="filter-box">
              <select v-model="filterProgram">
                <option value="">Semua Jurusan</option>
                <option value="Teknologi Informatika">Teknologi Informatika</option>
                <option value="Teknik Otomotif">Teknik Otomotif</option>
                <option value="Bisnis dan Manajemen">Bisnis dan Manajemen</option>
              </select>
              <select v-model="filterStatus">
                <option value="">Semua Status</option>
                <option value="Menunggu">Menunggu</option>
                <option value="Disetujui">Disetujui</option>
                <option value="Ditolak">Ditolak</option>
              </select>
            </div>
          </div>

          <!-- Data Table -->
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
                  <td colspan="6" class="empty-state">
                    Belum ada data pendaftar yang sesuai.
                  </td>
                </tr>
                <tr v-for="item in filteredRegistrations" :key="item.id">
                  <td class="text-sm text-gray">{{ item.createdAt }}</td>
                  <td>
                    <div class="student-info">
                      <strong>{{ item.name }}</strong>
                      <span class="text-sm text-gray">{{ item.email }}</span>
                    </div>
                  </td>
                  <td class="font-mono text-sm">{{ item.nisn }}</td>
                  <td>
                    <span class="program-tag">{{ item.program }}</span>
                  </td>
                  <td>
                    <span
                      class="status-badge"
                      :class="{
                        'badge-approved': item.status === 'Disetujui',
                        'badge-pending': item.status === 'Menunggu',
                        'badge-rejected': item.status === 'Ditolak'
                      }"
                    >
                      {{ item.status }}
                    </span>
                  </td>
                  <td>
                    <div class="action-buttons">
                      <button
                        @click="changeStatus(item.id, 'Disetujui')"
                        class="act-btn btn-approve"
                        :disabled="item.status === 'Disetujui'"
                      >
                        Setujui
                      </button>
                      <button
                        @click="changeStatus(item.id, 'Ditolak')"
                        class="act-btn btn-reject"
                        :disabled="item.status === 'Ditolak'"
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
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { getRegistrations, updateRegistrationStatus } from '../../../api/endpoints';

const router = useRouter();

const user = ref({ name: 'Administrator' });
const registrations = ref([]);
const isLoading = ref(false);
const errorMessage = ref('');
const searchQuery = ref('');
const filterProgram = ref('');
const filterStatus = ref('');

const pendingCount = computed(() => registrations.value.filter(r => r.status === 'Menunggu').length);
const approvedCount = computed(() => registrations.value.filter(r => r.status === 'Disetujui').length);

const filteredRegistrations = computed(() => {
  return registrations.value.filter(item => {
    const matchSearch =
      !searchQuery.value ||
      item.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      item.email.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      item.nisn.includes(searchQuery.value);

    const matchProgram = !filterProgram.value || item.program === filterProgram.value;
    const matchStatus = !filterStatus.value || item.status === filterStatus.value;

    return matchSearch && matchProgram && matchStatus;
  });
});

const fetchData = async () => {
  isLoading.value = true;
  errorMessage.value = '';
  try {
    const res = await getRegistrations();
    if (Array.isArray(res.data)) {
      registrations.value = res.data;
    } else if (Array.isArray(res.data?.data)) {
      registrations.value = res.data.data;
    } else {
      registrations.value = [];
    }
  } catch (error) {
    console.error('Gagal mengambil data pendaftaran:', error);
    errorMessage.value = 'Gagal memuat data pendaftaran. Silakan coba lagi nanti.';
  } finally {
    isLoading.value = false;
  }
};

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
  localStorage.removeItem('user_info');
  router.push('/login');
};

onMounted(() => {
  const token = localStorage.getItem('auth_token');
  if (!token) {
    router.push('/login');
    return;
  }

  const storedUser = localStorage.getItem('user_info');
  if (storedUser) {
    try {
      user.value = JSON.parse(storedUser);
    } catch (e) {
      // fallback
    }
  }
  fetchData();
});
</script>

<style scoped>
.dashboard-layout {
  min-height: 100vh;
  background: #f1f5f9;
  color: #1e293b;
  font-family: inherit;
}

.dashboard-header {
  background: #0f172a;
  color: #ffffff;
  padding: 1rem 2rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.header-inner {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.brand-logo {
  color: #ffffff;
  font-size: 1.25rem;
  font-weight: 700;
  text-decoration: none;
}

.user-area {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.user-badge {
  background: #3b82f6;
  color: #ffffff;
  font-size: 0.75rem;
  padding: 0.2rem 0.6rem;
  border-radius: 999px;
  font-weight: 600;
}

.user-name {
  font-size: 0.9rem;
  font-weight: 500;
}

.nav-btn {
  padding: 0.4rem 0.8rem;
  border-radius: 6px;
  font-size: 0.85rem;
  text-decoration: none;
  font-weight: 500;
  cursor: pointer;
  border: none;
  transition: background-color 0.2s;
}

.text-btn {
  color: #cbd5e1;
}

.text-btn:hover {
  color: #ffffff;
}

.logout-btn {
  background: #ef4444;
  color: #ffffff;
}

.logout-btn:hover {
  background: #dc2626;
}

.dashboard-body {
  padding: 2rem;
}

.dashboard-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.page-title-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-title-bar h2 {
  font-size: 1.5rem;
  font-weight: 700;
  margin: 0 0 0.25rem 0;
  color: #0f172a;
}

.page-title-bar p {
  color: #64748b;
  font-size: 0.9rem;
  margin: 0;
}

.dashboard-alert {
  margin: 1rem 0;
  padding: 1rem;
  background: #fef3f3;
  border: 1px solid #fca5a5;
  color: #991b1b;
  border-radius: 12px;
}

.refresh-btn {
  background: #ffffff;
  border: 1px solid #cbd5e1;
  padding: 0.6rem 1.2rem;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  color: #334155;
  transition: all 0.2s;
}

.refresh-btn:hover {
  background: #f8fafc;
  border-color: #94a3b8;
}

/* Stats Cards */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.25rem;
}

.stat-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.25rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
}

.bg-blue { background: #dbeafe; }
.bg-amber { background: #fef3c7; }
.bg-green { background: #dcfce7; }
.bg-purple { background: #f3e8ff; }

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-label {
  font-size: 0.825rem;
  color: #64748b;
  font-weight: 500;
}

.stat-val {
  font-size: 1.35rem;
  font-weight: 700;
  color: #0f172a;
}

/* Table Toolbar */
.table-card {
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.table-toolbar {
  padding: 1.25rem;
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  justify-content: space-between;
  border-bottom: 1px solid #e2e8f0;
}

.search-box input {
  padding: 0.6rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  width: 300px;
  font-size: 0.9rem;
}

.filter-box {
  display: flex;
  gap: 0.75rem;
}

.filter-box select {
  padding: 0.6rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  font-size: 0.9rem;
  background: #ffffff;
}

/* Table */
.table-responsive {
  width: 100%;
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
}

.data-table th {
  background: #f8fafc;
  padding: 0.85rem 1.25rem;
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  color: #475569;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #e2e8f0;
}

.data-table td {
  padding: 1rem 1.25rem;
  border-bottom: 1px solid #f1f5f9;
  font-size: 0.9rem;
}

.student-info {
  display: flex;
  flex-direction: column;
}

.text-gray {
  color: #64748b;
}

.text-sm {
  font-size: 0.825rem;
}

.font-mono {
  font-family: monospace;
}

.program-tag {
  background: #f1f5f9;
  color: #334155;
  padding: 0.25rem 0.6rem;
  border-radius: 6px;
  font-size: 0.825rem;
  font-weight: 500;
}

.status-badge {
  padding: 0.25rem 0.65rem;
  border-radius: 999px;
  font-size: 0.8rem;
  font-weight: 600;
}

.badge-approved {
  background: #dcfce7;
  color: #15803d;
}

.badge-pending {
  background: #fef3c7;
  color: #b45309;
}

.badge-rejected {
  background: #fee2e2;
  color: #b91c1c;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
}

.act-btn {
  padding: 0.35rem 0.75rem;
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: opacity 0.2s;
}

.btn-approve {
  background: #22c55e;
  color: #ffffff;
}

.btn-approve:hover:not(:disabled) {
  background: #16a34a;
}

.btn-reject {
  background: #f43f5e;
  color: #ffffff;
}

.btn-reject:hover:not(:disabled) {
  background: #e11d48;
}

.act-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.empty-state {
  text-align: center;
  padding: 3rem !important;
  color: #94a3b8;
}
</style>
