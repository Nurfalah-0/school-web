#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: '$1' belum terpasang."
    exit 1
  fi
}

require_command node
require_command npm
require_command php
require_command composer

echo "[1/5] Menginstal dependency root..."
npm ci

echo "[2/5] Menginstal dependency frontend..."
npm --prefix frontend ci

echo "[3/5] Menyiapkan dependency backend Laravel..."
composer install --working-dir=backend --no-interaction --prefer-dist

echo "[4/5] Menyiapkan file environment Laravel..."
if [[ ! -f backend/.env ]]; then
  cp backend/.env.example backend/.env
  echo "backend/.env dibuat dari backend/.env.example"
else
  echo "backend/.env sudah ada, tidak diubah"
fi

if ! grep -q '^APP_KEY=base64:' backend/.env; then
  php backend/artisan key:generate --force
else
  echo "APP_KEY sudah tersedia, tidak diubah"
fi

php backend/artisan config:clear
php backend/artisan storage:link

echo "[5/5] Setup selesai."
echo
echo "Catatan: pastikan DB_PASSWORD di backend/.env sesuai MySQL lokal."
echo "Jalankan proyek dengan: npm run dev"
