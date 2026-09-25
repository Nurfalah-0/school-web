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
import profilRoutes from '../modules/profil/routes';

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
  ...profilRoutes,
  ...staticRoutes,
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (to.name === 'Home' && !from.name) {
      return { top: 0, behavior: 'auto' }
    }

    if (savedPosition) {
      return savedPosition
    }

    if (to.hash) {
      return {
        el: to.hash,
        top: 90,
        behavior: 'smooth',
      }
    }

    return { top: 0, behavior: 'smooth' }
  },
});

function isAdminRoute(to) {
  return to.path.startsWith('/admin') || to.path === '/login'
}

function isProtectedRoute(to) {
  return to.matched.some(record => record.meta.requiresAuth)
}

function isAdminLoginRoute(to) {
  return to.path === '/admin/login' || to.path === '/admin/forgot-password' || to.path === '/login'
}

function getAdminToken() {
  return localStorage.getItem('auth_token') || sessionStorage.getItem('auth_token')
}

router.beforeEach((to, from, next) => {
  const token = getAdminToken()

  if (isProtectedRoute(to) && !token) {
    next('/login')
    return
  }

  if (isAdminRoute(to)) {
    if (!token && !isAdminLoginRoute(to)) {
      next('/login')
      return
    }
    if (token && isAdminLoginRoute(to)) {
      next('/admin/manage')
      return
    }
  }
  next()
});

export default router;
