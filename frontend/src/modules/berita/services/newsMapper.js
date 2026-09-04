const API_BASE = (import.meta.env.VITE_API_URL || 'http://localhost:8000/api').replace(/\/api\/?$/, '');

export function imageUrl(path) {
    if (!path) return '';
    
    // If already a full URL (http/https), return as-is
    if (/^https?:\/\//i.test(path)) return path;
    
    // If it's a relative path, prepend API base + storage
    return `${API_BASE}/storage/${String(path).replace(/^\/+/, '')}`;
}

export function displayCategory(category) {
    if (!category) return 'Umum';
    return String(category)
        .trim()
        .toLowerCase()
        .replace(/\b\w/g, letter => letter.toUpperCase());
}

export function mapNews(article) {
    const content = article.content || '';
    const excerpt = article.excerpt || content;
    const date = article.published_at || article.created_at;
    const category = displayCategory(article.category);

    return {
        id: article.id,
        slug: article.slug,
        status: article.published ? 'UTAMA' : null,
        kategori: category,
        kategoriRaw: article.category || '',
        judul: article.title,
        tanggal: date,
        tanggalDisplay: date ? new Date(date).toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' }) : '-',
        penulis: article.author_name || 'Admin SMK',
        waktuBaca: `${Math.max(1, Math.ceil(content.trim().split(/\s+/).filter(Boolean).length / 200))} Menit Baca`,
        gambarUtama: imageUrl(article.image_url || article.featured_image),
        konten: content ? [{ tipe: 'paragraf', teks: content }] : [],
        kutipan: excerpt,
        tags: article.tags || [],
        excerpt,
    };
}
