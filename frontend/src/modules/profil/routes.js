export default [
  {
    path: '/profil',
    name: 'ProfilSekolah',
    component: () => import('./views/ProfilSekolahPage.vue'),
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
