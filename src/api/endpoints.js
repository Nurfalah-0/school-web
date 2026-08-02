import client from './client';

export const API_ENDPOINTS = {
  auth: {
    login: '/login',
  },
  portal: {
    register: '/register',
    info: '/info',
  },
  dashboard: {
    registrations: '/registrations',
  },
};

export const registerApplicant = (data) => client.post('/register', data);
export const loginUser = (credentials) => client.post('/login', credentials);
export const getRegistrations = () => client.get('/registrations');
export const updateRegistrationStatus = (id, status) => client.patch(`/registrations/${id}`, { status });
export const getSchoolInfo = () => client.get('/info');
