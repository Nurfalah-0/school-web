const API_BASE = (import.meta.env.VITE_API_URL || 'http://localhost:8000/api').replace(/\/api\/?$/, '');

export function publicImage(path) {
    if (!path) return 'https://placehold.co/1200x700/e2e8f0/475569?text=SMK+Nurul+Jadid';
    return /^https?:\/\//i.test(path) ? path : `${API_BASE}/storage/${String(path).replace(/^\/+/, '')}`;
}

export function mapAchievement(item) {
    return { ...item, slug: item.slug, featured: item.is_featured, status: item.is_featured ? 'Terbaru' : null, kategori: (item.category || 'lainnya').toLowerCase(), kategoriLabel: item.category || 'Lainnya', kategoriBadgeColor: 'blue', judul: item.title, deskripsiSingkat: item.description || '', deskripsiLengkap: item.description || '', nama: item.organizer || 'SMK Nurul Jadid', tahun: item.year, gambar: publicImage(item.image), galeri: [] };
}

export function mapGallery(item) {
    return { ...item, id: String(item.id), kategori: (item.category || 'lainnya').toLowerCase().replace(/\s+/g, '-'), judul: item.title, gambar: publicImage(item.image), gambarFull: publicImage(item.image), tanggal: item.created_at, aspectRatio: 'wide', featured: item.is_featured };
}

export function mapVacancy(item) {
    return { ...item, slug: item.slug, status: item.status === 'published' ? 'Baru' : null, kategori: (item.category || 'lainnya').toLowerCase().replace(/\s+/g, '-'), kategoriLabel: item.category || 'Lainnya', posisi: item.title, perusahaan: item.company_name || 'Mitra Industri', lokasi: item.location || '-', tipePekerjaan: item.employment_type, tipePekerjaanLabel: item.employment_type, deadline: item.deadline, deadlineLabel: item.deadline || 'Terbuka Terus', icon: 'Briefcase', deskripsiSingkat: item.description || '', deskripsiLengkap: item.description || '', kualifikasi: item.requirements ? item.requirements.split('\n') : [], benefit: [], ctaLabel: 'Lamar Sekarang' };
}

export function mapProduct(item) {
    return { ...item, id: item.id, nama: item.name, kategori: item.category || 'Lainnya', rating: Number(item.rating || 0), ulasan: Number(item.review_count || 0), harga: Number(item.base_price || 0), gambar: publicImage(item.image), deskripsi: item.description || item.short_description || '' };
}
