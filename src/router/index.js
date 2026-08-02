import { createRouter, createWebHistory } from 'vue-router';
import authRoutes from '../modules/auth/routes';
import portalRoutes from '../modules/portal/routes';
import dashboardRoutes from '../modules/dashboard/routes';

const routes = [
  ...portalRoutes,
  ...authRoutes,
  ...dashboardRoutes,
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
