export default [
  { path: '/support', name: 'Support', component: () => import('./views/StaticPage.vue') },
  { path: '/portal-guide', name: 'PortalGuide', component: () => import('./views/StaticPage.vue') },
  { path: '/admin/contact', name: 'AdminContact', component: () => import('./views/StaticPage.vue') },
  { path: '/privacy', name: 'Privacy', component: () => import('./views/StaticPage.vue') },
  { path: '/terms', name: 'Terms', component: () => import('./views/StaticPage.vue') },
  { path: '/security', name: 'Security', component: () => import('./views/StaticPage.vue') }
];
