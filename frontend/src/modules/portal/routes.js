import HomeView from './views/HomeView.vue';
import ContactView from './views/ContactView.vue';

export default [
  {
    path: '/',
    name: 'Home',
    component: HomeView,
  },
  {
    path: '/contact',
    name: 'Contact',
    component: ContactView,
  },
];
