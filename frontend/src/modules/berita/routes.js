export default [
  {
    path: '/berita',
    name: 'SemuaBerita',
    component: () => import('./views/SemuaBerita.vue')
  },
  {
    path: '/berita/:slug',
    name: 'DetailBerita',
    component: () => import('./views/DetailBerita.vue')
  }
]
