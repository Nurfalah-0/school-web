import client from './client';

export const API_ENDPOINTS = {
  auth: {
    login: '/auth/login',
    register: '/auth/register',
    forgotPassword: '/auth/forgot-password',
    logout: '/auth/logout',
    profile: '/auth/profile',
  },
  school: {
    profile: '/school/profile',
  },
  dashboard: {
    stats: '/dashboard/stats',
    activity: '/dashboard/activity',
  },
  students: {
    list: '/students',
    detail: '/students/:id',
  },
  majors: {
    list: '/majors',
    detail: '/majors/:id',
  },
  news: {
    list: '/news',
    detail: '/news/:id',
  },
};

// Auth endpoints
export const loginUser = (credentials) => client.post('/auth/login', credentials);
export const adminLogin = loginUser;
export const registerUser = (data) => client.post('/auth/register', data);
export const adminForgotPassword = (data) => client.post('/auth/forgot-password', data);
export const logoutUser = () => client.post('/auth/logout');
export const getUserProfile = () => client.get('/auth/profile');

// School endpoints
export const getSchoolProfile = () => client.get('/school/profile');

// Dashboard endpoints
export const getDashboardStats = () => client.get('/dashboard/stats');
export const getRecentActivity = () => client.get('/dashboard/activity');

// Student endpoints
export const getStudents = (page = 1, perPage = 15) => client.get('/students', { params: { page, per_page: perPage } });
export const getStudentDetail = (id) => client.get(`/students/${id}`);
export const createStudent = (data) => client.post('/admin/students', data);
export const updateStudent = (id, data) => client.put(`/admin/students/${id}`, data);
export const deleteStudent = (id) => client.delete(`/admin/students/${id}`);

// Major endpoints
export const getMajors = () => client.get('/majors');
export const getMajorDetail = (id) => client.get(`/majors/${id}`);

// PPDB endpoints
export const getPpdbSchedule = () => client.get('/ppdb/schedule');
export const updatePpdbSchedule = (data) => client.put('/ppdb/schedule', data);
export const applyPpdb = (data) => {
  if (data instanceof FormData) {
    return client.post('/ppdb/apply', data, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  }
  return client.post('/ppdb/apply', data);
};
export const checkPpdbStatus = (identifier) => client.get(`/ppdb/status/${identifier}`);
export const getPpdbStatistics = () => client.get('/ppdb/statistics');
export const getRegistrations = (params = {}) => client.get('/ppdb/applications', { params });
export const updateRegistrationStatus = (id, status) => {
  const endpoint = status === 'Disetujui' || status === 'diterima' ? 'approve' : 'reject';
  return client.post(`/ppdb/applications/${id}/${endpoint}`);
};
export const deleteRegistration = (id) => client.delete(`/ppdb/applications/${id}`);
export const getRegistrationDetail = (id) => client.get(`/ppdb/applications/${id}`);

// News endpoints
export const getNews = (page = 1, perPage = 10) => client.get('/news', { params: { page, per_page: perPage } });
export const getNewsDetail = (id) => client.get(`/news/${id}`);
export const createNews = (data) => client.post('/admin/news', data);
export const updateNews = (id, data) => client.post(`/admin/news/${id}?_method=PUT`, data);
export const deleteNews = (id) => client.delete(`/admin/news/${id}`);
export const publishNews = (id) => client.post(`/admin/news/${id}/publish`);
export const unpublishNews = (id) => client.post(`/admin/news/${id}/unpublish`);

// Major management endpoints
export const createMajor = (data) => client.post('/admin/majors', data);
export const updateMajor = (id, data) => client.put(`/admin/majors/${id}`, data);
export const deleteMajor = (id) => client.delete(`/admin/majors/${id}`);

// Categories endpoints
export const getCategories = (type = '') => client.get(`/categories${type ? '?type=' + type : ''}`);
export const createCategory = (data) => client.post('/admin/categories', data);
export const updateCategory = (id, data) => client.put(`/admin/categories/${id}`, data);
export const deleteCategory = (id) => client.delete(`/admin/categories/${id}`);
// Site image management endpoints
export const getSiteImages = () => client.get('/site-images');
export const createSiteImage = (data) => client.post('/admin/site-images', data, {
  headers: { 'Content-Type': 'multipart/form-data' },
});
export const updateSiteImage = (id, data) => client.put(`/admin/site-images/${id}`, data);
export const uploadSiteImage = (id, data) => client.post(`/admin/site-images/${id}/upload`, data, {
  headers: { 'Content-Type': 'multipart/form-data' },
});
export const deleteSiteImage = (id) => client.delete(`/admin/site-images/${id}`);
export const updateSchoolProfile = (data) => client.put('/admin/school/profile', data);
export const getAdminContent = (type) => client.get(`/admin/content/${type}`);
export const getPublicContent = (type) => client.get(`/content/${type}`);
export const createAdminContent = (type, data) => client.post(`/admin/content/${type}`, data);
export const updateAdminContent = (type, id, data) => {
  data.append('_method', 'PUT');
  return client.post(`/admin/content/${type}/${id}`, data);
};
export const deleteAdminContent = (type, id) => client.delete(`/admin/content/${type}/${id}`);

// Major facilities management
export const addMajorFacility = (majorId, data) => client.post(`/admin/majors/${majorId}/facilities`, data);
export const deleteMajorFacility = (majorId, facilityId) => client.delete(`/admin/majors/${majorId}/facilities/${facilityId}`);

// User management endpoints
export const getUsers = (params = {}) => client.get('/admin/users', { params });
export const getUserDetail = (id) => client.get(`/admin/users/${id}`);
export const createUser = (data) => client.post('/admin/users', data);
export const updateUser = (id, data) => client.put(`/admin/users/${id}`, data);
export const deleteUser = (id) => client.delete(`/admin/users/${id}`);

