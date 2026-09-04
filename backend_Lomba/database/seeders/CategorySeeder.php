<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Category;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            // Prestasi
            ['name' => 'Akademik', 'type' => 'prestasi'],
            ['name' => 'Non-Akademik', 'type' => 'prestasi'],

            // TEFA Store
            ['name' => 'PERCETAKAN', 'type' => 'tefa'],
            ['name' => 'PRODUK KREATIF', 'type' => 'tefa'],
            ['name' => 'DESIGN GRAFIS', 'type' => 'tefa'],
            ['name' => 'MULTIMEDIA', 'type' => 'tefa'],

            // Galeri
            ['name' => 'Kegiatan', 'type' => 'galeri'],
            ['name' => 'Fasilitas', 'type' => 'galeri'],
            ['name' => 'Prestasi', 'type' => 'galeri'],
            ['name' => 'Ekstrakurikuler', 'type' => 'galeri'],

            // News
            ['name' => 'Prestasi', 'type' => 'news'],
            ['name' => 'Pengumuman', 'type' => 'news'],
            ['name' => 'Kegiatan', 'type' => 'news'],
            
            // Lowongan
            ['name' => 'IT & Software', 'type' => 'lowongan'],
            ['name' => 'Design', 'type' => 'lowongan'],
            ['name' => 'Administrasi', 'type' => 'lowongan'],
            ['name' => 'Manufaktur', 'type' => 'lowongan'],
        ];

        foreach ($categories as $cat) {
            Category::firstOrCreate(
                ['type' => $cat['type'], 'name' => $cat['name']],
                ['slug' => Str::slug($cat['name']), 'is_active' => true]
            );
        }
    }
}
