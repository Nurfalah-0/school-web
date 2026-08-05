import { createRouter, createWebHistory } from 'vue-router';
import authRoutes from '../modules/auth/routes';
import portalRoutes from '../modules/portal/routes';
import adminRoutes from '../modules/admin/routes';

const routes = [
  ...portalRoutes,
  ...authRoutes,
  ...adminRoutes,
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
