import DetailBerita from './views/DetailBerita.vue'
import SemuaBerita from './views/SemuaBerita.vue'

export default [
  {
    path: '/berita',
    name: 'SemuaBerita',
    component: SemuaBerita
  },
  {
    path: '/berita/:slug',
    name: 'DetailBerita',
    component: DetailBerita
  }
]
