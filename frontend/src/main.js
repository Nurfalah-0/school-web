import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import router from './router';
import './assets/styles/main.scss';

if ('scrollRestoration' in window.history) {
  window.history.scrollRestoration = 'manual';
}

const app = createApp(App);
app.use(createPinia());
app.use(router);
app.mount('#app');
