<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ContentDemoSeeder extends Seeder
{
    public function run(): void
    {
        $now = now();

        $achievements = [
            ['title' => 'Juara 1 Regional Coding Championship', 'category' => 'Akademik', 'level' => 'Regional', 'organizer' => 'Dinas Pendidikan', 'year' => 2025, 'description' => 'Tim Cyber SMK meraih juara pertama dalam kompetisi pengembangan perangkat lunak.', 'image' => 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=1200&q=80', 'rank' => 'Juara 1', 'is_featured' => true],
            ['title' => 'Medali Emas Kejuaraan Robotik Nasional', 'category' => 'Akademik', 'level' => 'Nasional', 'organizer' => 'Kementerian Pendidikan', 'year' => 2025, 'description' => 'Tim robotik sekolah meraih medali emas pada kejuaraan robotik nasional.', 'image' => 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=1200&q=80', 'rank' => 'Medali Emas', 'is_featured' => false],
            ['title' => 'Penghargaan Sosial Pengabdian Masyarakat', 'category' => 'Sosial', 'level' => 'Kabupaten', 'organizer' => 'Dinas Pendidikan', 'year' => 2024, 'description' => 'Program pengabdian masyarakat sekolah mendapatkan penghargaan terbaik.', 'image' => 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=1200&q=80', 'rank' => 'Terbaik', 'is_featured' => false],
            ['title' => 'Juara 1 Turnamen Basket O2SN', 'category' => 'Olahraga', 'level' => 'Kabupaten', 'organizer' => 'O2SN', 'year' => 2024, 'description' => 'Tim basket sekolah menjadi juara turnamen tingkat kabupaten.', 'image' => null, 'rank' => 'Juara 1', 'is_featured' => false],
            ['title' => 'Festival Seni Budaya PETAK', 'category' => 'Seni Budaya', 'level' => 'Provinsi', 'organizer' => 'PETAK Jawa Timur', 'year' => 2024, 'description' => 'Sanggar seni sekolah meraih juara utama festival budaya tingkat provinsi.', 'image' => 'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=1200&q=80', 'rank' => 'Juara Utama', 'is_featured' => false],
        ];
        foreach ($achievements as $item) {
            $this->upsert('achievements', $item['title'], $item + ['slug' => Str::slug($item['title']), 'is_published' => true, 'created_at' => $now, 'updated_at' => $now]);
        }

        $galleries = [
            ['title' => 'Ruang Kelas Digital Innovation Center', 'category' => 'Fasilitas', 'image' => 'https://images.unsplash.com/photo-1497215842964-222b430dc094?w=1400&q=80', 'alt_text' => 'Ruang kelas digital'],
            ['title' => 'Perpustakaan Modern SMK Nurul Jadid', 'category' => 'Fasilitas', 'image' => 'https://images.unsplash.com/photo-1507842217122-3f45c7f39214?w=1400&q=80', 'alt_text' => 'Perpustakaan sekolah'],
            ['title' => 'Kelas Industri Bersama Mitra', 'category' => 'Kegiatan Siswa', 'image' => 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1400&q=80', 'alt_text' => 'Kelas industri'],
            ['title' => 'Workshop Soft Skills Bersama Alumni', 'category' => 'Kegiatan Siswa', 'image' => 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=1400&q=80', 'alt_text' => 'Workshop siswa'],
            ['title' => 'Lab Komputer Jaringan dan Server', 'category' => 'Lab Praktik', 'image' => 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=1400&q=80', 'alt_text' => 'Laboratorium komputer'],
        ];
        foreach ($galleries as $item) {
            $this->upsert('galleries', $item['title'], $item + ['slug' => Str::slug($item['title']), 'is_featured' => false, 'is_published' => true, 'sort_order' => 0, 'created_at' => $now, 'updated_at' => $now]);
        }

        $partners = [
            ['company_name' => 'PT Teknologi Maju Bersama', 'industry_type' => 'Teknologi Informasi', 'city' => 'Surabaya', 'description' => 'Mitra industri bidang pengembangan aplikasi dan teknologi digital.', 'is_active' => true],
            ['company_name' => 'PT Sumber Rejeki', 'industry_type' => 'Akuntansi dan Keuangan', 'city' => 'Probolinggo', 'description' => 'Mitra industri untuk pembelajaran administrasi dan akuntansi.', 'is_active' => true],
            ['company_name' => 'Creative Studio Jatim', 'industry_type' => 'Desain Kreatif', 'city' => 'Malang', 'description' => 'Mitra praktik kerja bidang desain grafis dan multimedia.', 'is_active' => true],
        ];
        foreach ($partners as $item) {
            $this->upsert('industry_partners', $item['company_name'], $item + ['slug' => Str::slug($item['company_name']), 'created_at' => $now, 'updated_at' => $now]);
        }

        $jobs = [
            ['title' => 'Junior Web Developer', 'category' => 'IT dan Software', 'description' => 'Mengembangkan aplikasi web modern menggunakan Vue.js dan Node.js.', 'requirements' => 'HTML, CSS, JavaScript, Vue.js, REST API, dan database SQL.', 'location' => 'Surabaya', 'employment_type' => 'full-time', 'deadline' => '2026-10-24', 'status' => 'published'],
            ['title' => 'Staf Akuntansi', 'category' => 'Akuntansi dan Keuangan', 'description' => 'Mengelola pembukuan, laporan keuangan, dan administrasi pajak.', 'requirements' => 'Menguasai Microsoft Excel, teliti, dan komunikatif.', 'location' => 'Probolinggo', 'employment_type' => 'full-time', 'deadline' => '2026-11-15', 'status' => 'published'],
            ['title' => 'Magang Desain Grafis', 'category' => 'Desain Grafis', 'description' => 'Program magang untuk siswa multimedia pada studio kreatif.', 'requirements' => 'Menguasai Adobe Illustrator atau Photoshop dan memiliki portfolio.', 'location' => 'Malang', 'employment_type' => 'internship', 'deadline' => null, 'status' => 'published'],
            ['title' => 'Teknisi Otomotif', 'category' => 'Teknik Otomotif', 'description' => 'Melakukan perawatan dan perbaikan kendaraan sesuai standar dealer.', 'requirements' => 'Lulusan SMK otomotif, memahami mesin dan kelistrikan.', 'location' => 'Surabaya', 'employment_type' => 'full-time', 'deadline' => '2026-09-30', 'status' => 'published'],
        ];
        foreach ($jobs as $item) {
            $this->upsert('job_vacancies', $item['title'], $item + ['slug' => Str::slug($item['title']), 'created_at' => $now, 'updated_at' => $now]);
        }

        $products = [
            ['name' => 'Seragam Almamater SMK', 'sku' => 'SERAGAM-001', 'category' => 'Pakaian', 'short_description' => 'Seragam almamater resmi sekolah.', 'description' => 'Seragam almamater resmi dengan bahan nyaman untuk kegiatan sekolah.', 'base_price' => 175000, 'stock' => 50, 'status' => 'published', 'featured' => true],
            ['name' => 'Jaket Kampus SMK', 'sku' => 'JAKET-001', 'category' => 'Pakaian', 'short_description' => 'Jaket kampus dengan identitas sekolah.', 'description' => 'Jaket berkualitas untuk siswa dan alumni.', 'base_price' => 250000, 'stock' => 25, 'status' => 'published', 'featured' => true],
            ['name' => 'Tumbler Nurul Jadid', 'sku' => 'TUMBLER-001', 'category' => 'Aksesori', 'short_description' => 'Tumbler stainless steel logo sekolah.', 'description' => 'Tumbler praktis untuk kegiatan sekolah dan harian.', 'base_price' => 85000, 'stock' => 40, 'status' => 'published', 'featured' => false],
        ];
        foreach ($products as $item) {
            $this->upsert('products', $item['name'], $item + ['slug' => Str::slug($item['name']), 'created_at' => $now, 'updated_at' => $now]);
        }
    }

    private function upsert(string $table, string $name, array $data): void
    {
        $key = match ($table) {
            'industry_partners' => 'company_name',
            'products' => 'name',
            default => 'title',
        };
        DB::table($table)->updateOrInsert([$key => $name], $data);
    }
}
