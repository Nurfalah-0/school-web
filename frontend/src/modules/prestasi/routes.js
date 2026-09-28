export default [
  {
    path: '/prestasi',
    name: 'Prestasi',
    component: () => import('./views/Prestasi.vue')
  },
  {
    path: '/prestasi/:slug',
    name: 'DetailPrestasi',
    component: () => import('./views/DetailPrestasi.vue')
  }
];
