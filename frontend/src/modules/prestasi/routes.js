import Prestasi from './views/Prestasi.vue';
import DetailPrestasi from './views/DetailPrestasi.vue';

export default [
  {
    path: '/prestasi',
    name: 'Prestasi',
    component: Prestasi
  },
  {
    path: '/prestasi/:slug',
    name: 'DetailPrestasi',
    component: DetailPrestasi
  }
];
