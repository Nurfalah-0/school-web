import { createApp } from 'vue';
import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css';

export function registerPlugins(app) {
  app.use(ElementPlus);
}
