#!/bin/bash

echo "🚀 Memulai proses deployment..."

# 1. Tarik kode terbaru dari GitHub
echo "📥 Mengambil kode terbaru dari Git..."
git pull origin main

# 2. Rebuild dan nyalakan container Docker
echo "🐳 Memperbarui container Docker..."
docker compose up -d --build

# 3. Jalankan migrasi database di Laravel
echo "🗄️ Menjalankan migrasi database..."
docker exec lomba_backend php artisan migrate --force

# 4. Bersihkan cache Laravel
echo "🧹 Membersihkan cache aplikasi..."
docker exec lomba_backend php artisan config:clear
docker exec lomba_backend php artisan route:clear
docker exec lomba_backend php artisan cache:clear

echo "✅ Deployment selesai! Aplikasi siap digunakan."