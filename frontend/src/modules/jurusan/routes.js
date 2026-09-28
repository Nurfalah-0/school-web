export default [
  {
    path: '/jurusan',
    name: 'SemuaJurusan',
    component: () => import('./views/SemuaJurusan.vue')
  },
  {
    path: '/jurusan/:slug',
    name: 'DetailJurusan',
    component: () => import('./views/DetailJurusan.vue')
  }
];
