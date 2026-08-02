import client from '../../api/client';
import { API_ENDPOINTS } from '../../api/endpoints';

export const login = payload => client.post(API_ENDPOINTS.auth.login, payload);
export const forgotPassword = payload => client.post(API_ENDPOINTS.auth.forgotPassword, payload);
