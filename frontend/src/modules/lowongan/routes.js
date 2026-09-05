import Lowongan from './views/Lowongan.vue';
import DetailLowongan from './views/DetailLowongan.vue';

export default [
  {
    path: '/lowongan',
    name: 'Lowongan',
    component: Lowongan
  },
  {
    path: '/lowongan/:slug',
    name: 'DetailLowongan',
    component: DetailLowongan
  }
];
