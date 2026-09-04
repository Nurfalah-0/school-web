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
    redirect: '/admin/dashboard',
    meta: { hideNavbar: true },
  },
  {
    path: '/admin/dashboard',
    name: 'AdminDashboard',
    component: () => import('./views/AdminDashboard.vue'),
    meta: { hideNavbar: true },
  },
  {
    path: '/admin/manage',
    name: 'AdminManagement',
    component: () => import('./views/AdminManagement.vue'),
    meta: { hideNavbar: true },
  },
  {
    path: '/admin/content',
    name: 'AdminContent',
    component: () => import('./views/AdminContent.vue'),
    meta: { hideNavbar: true },
  },
];
