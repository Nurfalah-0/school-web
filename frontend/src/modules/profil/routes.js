import ProfilSekolahPage from './views/ProfilSekolahPage.vue';

export default [
  {
    path: '/profil',
    name: 'ProfilSekolah',
    component: () => import('./views/ProfilSekolahPage.vue'),
  },
  {
    path: '/profil/guru-staf',
    name: 'ProfilGuruStaf',
    component: GuruStafPage,
  },
  {
    path: '/profil/guru-staf/:id',
    name: 'ProfilGuruStafDetail',
    component: GuruStafDetailPage,
  },
  {
    path: '/profil/sekolah',
    redirect: { path: '/profil', hash: '#profil-sekolah' },
  },
  {
    path: '/profil/visi-misi',
    redirect: to => ({ path: '/profil', hash: '#visi-misi' }),
  },
];
