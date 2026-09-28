export default [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../admin/views/AdminLogin.vue'),
    meta: { blankLayout: true, requiresGuest: true }
  },
];
