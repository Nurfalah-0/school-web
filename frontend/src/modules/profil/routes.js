import ProfilSekolahPage from './views/ProfilSekolahPage.vue';

export default [
  {
    path: '/profil',
    name: 'ProfilSekolah',
    component: ProfilSekolahPage,
  },
  {
    path: '/profil/sekolah',
    name: 'ProfilSekolahDetail',
    component: ProfilSekolahPage,
  },
  {
    path: '/profil/visi-misi',
    name: 'VisiMisiSekolah',
    component: () => import('./views/VisiMisiSekolahPage.vue'),
  },
];
