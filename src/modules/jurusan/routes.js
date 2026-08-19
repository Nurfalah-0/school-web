import DetailJurusan from './views/DetailJurusan.vue';
import SemuaJurusan from './views/SemuaJurusan.vue';

export default [
  {
    path: '/jurusan',
    name: 'SemuaJurusan',
    component: SemuaJurusan
  },
  {
    path: '/jurusan/:slug',
    name: 'DetailJurusan',
    component: DetailJurusan
  }
];
