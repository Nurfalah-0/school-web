export default {
  mounted(el, binding) {
    const userRole = window.localStorage.getItem('userRole');
    const allowed = binding.value;
    if (!allowed.includes(userRole)) {
      el.style.display = 'none';
    }
  },
};
