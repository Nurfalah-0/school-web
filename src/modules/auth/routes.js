import AdminLogin from '../admin/views/AdminLogin.vue';

export default [
  {
    path: '/login',
    name: 'Login',
    component: AdminLogin,
    meta: { blankLayout: true, requiresGuest: true }
  },
];
