import { createRouter, createWebHistory } from 'vue-router';
import authRoutes from '../modules/auth/routes';
import portalRoutes from '../modules/portal/routes';
import adminRoutes from '../modules/admin/routes';
import pklBkkRoutes from '../modules/pkl-bkk/routes';
import ppdbRoutes from '../modules/ppdb/routes';
import tefaStoreRoutes from '../modules/tefa-store/routes';
import jurusanRoutes from '../modules/jurusan/routes';
import beritaRoutes from '../modules/berita/routes';
import prestasiRoutes from '../modules/prestasi/routes';
import lowonganRoutes from '../modules/lowongan/routes';
import galeriRoutes from '../modules/galeri/routes';
import staticRoutes from '../modules/static/routes';

const routes = [
  ...portalRoutes,
  ...authRoutes,
  ...adminRoutes,
  ...pklBkkRoutes,
  ...ppdbRoutes,
  ...tefaStoreRoutes,
  ...jurusanRoutes,
  ...beritaRoutes,
  ...prestasiRoutes,
  ...lowonganRoutes,
  ...galeriRoutes,
  ...staticRoutes,
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    return savedPosition || { top: 0 }
  },
});

function isAdminRoute(to) {
  return to.path.startsWith('/admin') || to.path === '/login'
}

function isAdminLoginRoute(to) {
  return to.path === '/admin/login' || to.path === '/admin/forgot-password' || to.path === '/login'
}

function getAdminToken() {
  return localStorage.getItem('admin_token') || sessionStorage.getItem('admin_token')
}

router.beforeEach((to, from, next) => {
  if (isAdminRoute(to)) {
    const token = getAdminToken()
    if (!token && !isAdminLoginRoute(to)) {
      next('/login')
      return
    }
    if (token && isAdminLoginRoute(to)) {
      next('/admin/dashboard')
      return
    }
  }
  next()
});

export default router;
