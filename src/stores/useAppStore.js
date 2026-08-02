import { defineStore } from 'pinia';

export const useAppStore = defineStore('app', {
  state: () => ({
    loading: false,
    theme: 'light',
    alert: null,
  }),
  actions: {
    setLoading(value) {
      this.loading = value;
    },
    setAlert(alert) {
      this.alert = alert;
    },
  },
});
