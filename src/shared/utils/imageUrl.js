const API_BASE = (import.meta.env.VITE_API_URL || 'http://localhost:8000/api').replace(/\/api\/?$/, '');

/**
 * Resolves an image path to a complete, valid URL:
 * - Handles empty / null with a placeholder fallback
 * - Preserves external HTTP / HTTPS URLs (e.g. Unsplash)
 * - Automatically fixes legacy URLs with http://localhost/storage/ (missing port 8000)
 * - Prepends `${API_BASE}/storage/` to relative paths (e.g. news-images/..., content/...)
 * - Strips redundant leading /storage/ prefixes
 *
 * @param {string|null|undefined} path - The raw image path or URL
 * @param {string} [fallback] - Fallback placeholder URL
 * @returns {string} Fully resolved image URL
 */
export function resolveImageUrl(path, fallback = 'https://placehold.co/400x250?text=No+Image') {
  if (!path) return fallback;
  const str = String(path).trim();
  if (!str) return fallback;

  // If already a full URL
  if (/^https?:\/\//i.test(str)) {
    // If backend generated http://localhost/storage without port 8000, patch it
    if (/^http:\/\/localhost(?::80)?\/storage\//i.test(str)) {
      return str.replace(/^http:\/\/localhost(?::80)?\/storage\//i, `${API_BASE}/storage/`);
    }
    return str;
  }

  // Strip leading /storage/ or storage/ or /
  const cleanPath = str.replace(/^\/?storage\//i, '').replace(/^\/+/, '');
  return `${API_BASE}/storage/${cleanPath}`;
}
