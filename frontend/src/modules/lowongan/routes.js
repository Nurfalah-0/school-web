export default [
  {
    path: '/lowongan',
    name: 'Lowongan',
    component: () => import('./views/Lowongan.vue')
  },
  {
    path: '/lowongan/:slug',
    name: 'DetailLowongan',
    component: () => import('./views/DetailLowongan.vue')
  }
];
