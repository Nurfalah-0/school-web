# SMK Sekolah Web

Website sekolah menggunakan Vue.js untuk frontend dan Laravel untuk backend.

## Jalankan proyek

1. Buka terminal di folder proyek.
2. Jalankan `npm install` untuk dependency root.
3. Jalankan `npm run install:frontend` untuk dependency Vue.
4. Pastikan Composer sudah terpasang, lalu jalankan `cd backend && composer install`.
5. Jalankan `php artisan key:generate` dari folder `backend`.
6. Gunakan database `db_smknuruljadid` yang sudah ada di phpMyAdmin.
7. Jalankan `cd .. && npm run dev` untuk menjalankan frontend dan backend.

Frontend akan tersedia di `http://localhost:5173` dan backend Laravel di `http://localhost:8000`.

## Database

Konfigurasi koneksi MySQL lokal berada di `backend/.env`:

- Database: `db_smknuruljadid`
- Host: `127.0.0.1`
- Port: `3306`
- Username: `root`
- Password: kosong secara default

Jika MySQL Anda memakai password atau port berbeda, ubah `DB_PASSWORD` atau `DB_PORT` di `backend/.env`. File SQL di `backend/database/` hanya perlu diimpor jika database belum memiliki tabel, dan `db_smknuruljadid_latest.sql` akan menghapus lalu membuat ulang database. Jangan menjalankan `migrate:fresh` pada database yang sudah berisi data.

## Struktur

- `frontend/` : aplikasi Vue dan konfigurasi Vite
- `backend/` : aplikasi Laravel API

## Login Admin

Super admin = username: superadmin@smknuruljadid.sch.id password: password123

Admin = username: admin@smknuruljadid
password: password123

TU = username: tu@smknuruljadid
password:password123

Guru = username: guru@smknuruljadid
password: password123