# SMK Sekolah Web

Website sekolah menggunakan Vue.js untuk frontend dan Laravel untuk backend.

## Jalankan proyek
1. Buka terminal di folder hasil clone.
2. Pastikan Node.js, PHP, Composer, dan MySQL sudah terpasang.
3. Jalankan `bash setup.sh` untuk memasang semua dependency dan menyiapkan Laravel.
4. Pastikan `DB_PASSWORD` di `backend/.env` sesuai password MySQL lokal.
5. Jalankan `npm install`
6. Jalankan `npm run dev` untuk menjalankan frontend dan backend.

Frontend akan tersedia di `http://localhost:3000` dan backend Laravel di `http://localhost:8000`.

## Jalankan dengan Docker

1. Salin `.env.example` menjadi `.env` di root proyek.
2. Jalankan `docker compose up -d --build`.
3. Tunggu sampai service berstatus `healthy` atau `Up` dengan `docker compose ps`.

Aplikasi tersedia di `http://localhost`, backend API di `http://localhost:8000`, dan phpMyAdmin di `http://localhost:8081`. Redis digunakan untuk cache, session, dan queue; worker Laravel berjalan pada service `backend_worker`.

Untuk melihat log aplikasi:

```bash
docker compose logs -f backend backend_worker
```

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
