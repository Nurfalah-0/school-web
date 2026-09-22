import AdminLogin from '../admin/views/AdminLogin.vue';
import AdminForgotPassword from './views/AdminForgotPassword.vue';

export default [
  {
    path: '/admin/login',
    redirect: '/login'
  },
  {
    path: '/admin/forgot-password',
    name: 'AdminForgotPassword',
    component: AdminForgotPassword,
    meta: { blankLayout: true, requiresGuest: true }
  },
  {
    path: '/admin',
    redirect: '/admin/manage',
    meta: { hideNavbar: true, blankLayout: true },
  },
  {
    path: '/admin/manage',
    name: 'AdminManagement',
    component: () => import('./views/AdminManagement.vue'),
    meta: { hideNavbar: true },
  },
  {
    path: '/admin/content',
    redirect: { path: '/admin/manage', query: { tab: 'content-achievements' } },
    meta: { hideNavbar: true },
  },
];
