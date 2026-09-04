import client from '../../api/client';
import { API_ENDPOINTS } from '../../api/endpoints';

export const getNews = () => client.get(API_ENDPOINTS.portal.news);
export const getAbout = () => client.get(API_ENDPOINTS.portal.about);
