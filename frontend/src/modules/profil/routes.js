import ProfilSekolahPage from './views/ProfilSekolahPage.vue';

export default [
  {
    path: '/profil',
    name: 'ProfilSekolah',
    component: ProfilSekolahPage,
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
