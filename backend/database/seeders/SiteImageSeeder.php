<?php

namespace Database\Seeders;

use App\Models\SiteImage;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SiteImageSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Delete existing images
        SiteImage::query()->delete();

        $images = [
            [
                'key' => 'hero_banner',
                'title' => 'Banner Utama Homepage',
                'description' => 'Banner besar di halaman utama',
                'image_path' => 'site-images/hero-banner.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&q=80',
                'alt_text' => 'SMK Nurul Jadid Hero Banner',
                'section' => 'homepage',
                'position' => 1,
                'is_active' => true,
            ],
            [
                'key' => 'hero_banner_mobile',
                'title' => 'Banner Utama Mobile',
                'description' => 'Banner untuk tampilan mobile',
                'image_path' => 'site-images/hero-banner-mobile.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600&q=80',
                'alt_text' => 'SMK Mobile Banner',
                'section' => 'homepage',
                'position' => 2,
                'is_active' => true,
            ],
            [
                'key' => 'about_image',
                'title' => 'Gambar Tentang Sekolah',
                'description' => 'Gambar untuk section About Us',
                'image_path' => 'site-images/about-school.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=800&q=80',
                'alt_text' => 'Tentang SMK Nurul Jadid',
                'section' => 'about',
                'position' => 1,
                'is_active' => true,
            ],
            [
                'key' => 'headmaster_photo',
                'title' => 'Foto Kepala Sekolah',
                'description' => 'Foto resmi kepala sekolah',
                'image_path' => 'site-images/headmaster.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
                'alt_text' => 'Kepala Sekolah SMK',
                'section' => 'about',
                'position' => 2,
                'is_active' => true,
            ],
            [
                'key' => 'facility_lab_komputer',
                'title' => 'Lab Komputer',
                'description' => 'Foto laboratorium komputer',
                'image_path' => 'site-images/facilities/lab-komputer.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80',
                'alt_text' => 'Lab Komputer',
                'section' => 'facilities',
                'position' => 1,
                'is_active' => true,
            ],
            [
                'key' => 'facility_lab_otomotif',
                'title' => 'Lab Otomotif',
                'description' => 'Foto laboratorium otomotif',
                'image_path' => 'site-images/facilities/lab-otomotif.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=800&q=80',
                'alt_text' => 'Lab Otomotif',
                'section' => 'facilities',
                'position' => 2,
                'is_active' => true,
            ],
            [
                'key' => 'facility_perpustakaan',
                'title' => 'Perpustakaan',
                'description' => 'Foto perpustakaan sekolah',
                'image_path' => 'site-images/facilities/perpustakaan.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1507842217122-3f45c7f39214?w=800&q=80',
                'alt_text' => 'Perpustakaan SMK',
                'section' => 'facilities',
                'position' => 3,
                'is_active' => true,
            ],
            [
                'key' => 'slider_1',
                'title' => 'Slider Homepage 1',
                'description' => 'Gambar slider pertama',
                'image_path' => 'site-images/sliders/slider-1.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=1920&q=80',
                'alt_text' => 'Kegiatan Siswa 1',
                'section' => 'homepage_slider',
                'position' => 1,
                'is_active' => true,
            ],
            [
                'key' => 'slider_2',
                'title' => 'Slider Homepage 2',
                'description' => 'Gambar slider kedua',
                'image_path' => 'site-images/sliders/slider-2.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1537995882-c42d960eaf6c?w=1920&q=80',
                'alt_text' => 'Kegiatan Siswa 2',
                'section' => 'homepage_slider',
                'position' => 2,
                'is_active' => true,
            ],
            [
                'key' => 'slider_3',
                'title' => 'Slider Homepage 3',
                'description' => 'Gambar slider ketiga',
                'image_path' => 'site-images/sliders/slider-3.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&q=80',
                'alt_text' => 'Kegiatan Siswa 3',
                'section' => 'homepage_slider',
                'position' => 3,
                'is_active' => true,
            ],
            [
                'key' => 'ppdb_banner',
                'title' => 'Banner PPDB',
                'description' => 'Banner untuk halaman PPDB',
                'image_path' => 'site-images/ppdb-banner.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=1920&q=80',
                'alt_text' => 'PPDB Banner',
                'section' => 'ppdb',
                'position' => 1,
                'is_active' => true,
            ],
            [
                'key' => 'contact_map',
                'title' => 'Peta Lokasi Sekolah',
                'description' => 'Gambar peta atau foto lokasi',
                'image_path' => 'site-images/contact-map.jpg',
                'image_url' => 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80',
                'alt_text' => 'Lokasi SMK',
                'section' => 'contact',
                'position' => 1,
                'is_active' => true,
            ],
        ];

        foreach ($images as $image) {
            SiteImage::create($image);
        }

        echo "✅ Site images seeded successfully! (" . count($images) . " images)";
    }
}
