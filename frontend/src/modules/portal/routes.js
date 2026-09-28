import HomeView from './views/HomeView.vue';

export default [
  {
    path: '/',
    name: 'Home',
    component: HomeView,
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import('./views/ContactView.vue'),
  },
];
