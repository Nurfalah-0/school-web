-- =====================================================
-- Database untuk SMK Nurul Jadid
-- Version: 2.0.0 - WITH ALL CONTROLLERS
-- Created: 2026-08-24
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Drop existing database if exists
DROP DATABASE IF EXISTS `db_smknuruljadid`;

-- Create Database
CREATE DATABASE IF NOT EXISTS `db_smknuruljadid` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `db_smknuruljadid`;

-- =====================================================
-- 1. ROLES TABLE
-- =====================================================

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 'Super Administrator - Full access', NOW(), NOW()),
(2, 'admin_sekolah', 'Admin Sekolah - School management', NOW(), NOW()),
(3, 'tu_sekolah', 'Tata Usaha Sekolah - Administration', NOW(), NOW()),
(4, 'guru', 'Guru - Teacher', NOW(), NOW()),
(5, 'siswa', 'Siswa - Student', NOW(), NOW()),
(6, 'ppdb', 'Admin PPDB - PPDB management', NOW(), NOW()),
(7, 'bkk', 'Admin BKK - Career center', NOW(), NOW());

-- =====================================================
-- 2. PERMISSIONS TABLE
-- =====================================================

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `module` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `permissions` (`id`, `name`, `slug`, `description`, `module`, `created_at`, `updated_at`) VALUES
(1, 'View Dashboard', 'dashboard.view', 'Can view dashboard', 'dashboard', NOW(), NOW()),
(2, 'Manage Users', 'users.manage', 'Can create, edit, delete users', 'users', NOW(), NOW()),
(3, 'View Users', 'users.view', 'Can view user list', 'users', NOW(), NOW()),
(4, 'Manage Roles', 'roles.manage', 'Can manage roles and permissions', 'roles', NOW(), NOW()),
(5, 'Manage School Profile', 'school_profile.manage', 'Can manage school profile', 'school', NOW(), NOW()),
(6, 'Manage Students', 'students.manage', 'Can manage student data', 'students', NOW(), NOW()),
(7, 'View Students', 'students.view', 'Can view student list', 'students', NOW(), NOW()),
(8, 'Manage Majors', 'majors.manage', 'Can manage majors', 'academic', NOW(), NOW()),
(9, 'View Majors', 'majors.view', 'Can view majors', 'academic', NOW(), NOW()),
(10, 'Manage News', 'news.manage', 'Can create, edit, delete news', 'content', NOW(), NOW()),
(11, 'View News', 'news.view', 'Can view news list', 'content', NOW(), NOW()),
(12, 'Manage PPDB', 'ppdb.manage', 'Can manage PPDB applications', 'ppdb', NOW(), NOW()),
(13, 'View PPDB', 'ppdb.view', 'Can view PPDB applications', 'ppdb', NOW(), NOW()),
(14, 'Manage PKL', 'pkl.manage', 'Can manage PKL programs', 'pkl', NOW(), NOW()),
(15, 'View PKL', 'pkl.view', 'Can view PKL programs', 'pkl', NOW(), NOW()),
(16, 'Manage Job Vacancies', 'jobs.manage', 'Can manage job vacancies', 'bkk', NOW(), NOW()),
(17, 'View Job Vacancies', 'jobs.view', 'Can view job vacancies', 'bkk', NOW(), NOW()),
(18, 'Manage TEFA Store', 'tefa_store.manage', 'Can manage TEFA store products', 'tefa', NOW(), NOW()),
(19, 'View TEFA Store', 'tefa_store.view', 'Can view TEFA store products', 'tefa', NOW(), NOW()),
(20, 'Manage Settings', 'settings.manage', 'Can manage system settings', 'settings', NOW(), NOW()),
(21, 'View Reports', 'reports.view', 'Can view reports', 'reports', NOW(), NOW());

-- =====================================================
-- 3. ROLE PERMISSIONS
-- =====================================================

CREATE TABLE `role_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `role_permissions_permission_id_foreign` (`permission_id`),
  CONSTRAINT `role_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 12), (1, 13), (1, 14), (1, 15), (1, 16), (1, 17), (1, 18), (1, 19), (1, 20), (1, 21),
(2, 1), (2, 5), (2, 6), (2, 7), (2, 8), (2, 9), (2, 10), (2, 11), (2, 12), (2, 13),
(3, 6), (3, 7),
(4, 7),
(5, 11),
(6, 12), (6, 13),
(7, 16), (7, 17);

-- =====================================================
-- 4. USERS TABLE
-- =====================================================

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `profile_photo` varchar(500) DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `login_attempts` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `two_factor_secret` varchar(255) DEFAULT NULL,
  `two_factor_backup_codes` text DEFAULT NULL,
  `last_password_change` timestamp NULL DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `is_active`, `last_login_at`, `last_password_change`, `created_at`, `updated_at`) VALUES
(1, 'Super Administrator', 'superadmin@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567890', 1, NOW(), NOW(), NOW(), NOW()),
(2, 'Admin Sekolah', 'admin@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567891', 1, NOW(), NOW(), NOW(), NOW()),
(3, 'Tata Usaha Sekolah', 'tu@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567892', 1, NOW(), NOW(), NOW(), NOW()),
(4, 'Guru Contoh', 'guru@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567893', 1, NOW(), NOW(), NOW(), NOW()),
(5, 'Admin PPDB', 'ppdb@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567894', 1, NOW(), NOW(), NOW(), NOW()),
(6, 'Admin BKK', 'bkk@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567895', 1, NOW(), NOW(), NOW(), NOW()),
(7, 'Ahmad Santoso', 'ahmad@student.smknj.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567896', 1, NOW(), NOW(), NOW(), NOW());

-- =====================================================
-- 5. USER ROLES
-- =====================================================

CREATE TABLE `user_roles` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  KEY `user_roles_role_id_foreign` (`role_id`),
  CONSTRAINT `user_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `user_roles` (`user_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 1, NOW(), NOW()),
(2, 2, NOW(), NOW()),
(3, 3, NOW(), NOW()),
(4, 4, NOW(), NOW()),
(5, 6, NOW(), NOW()),
(6, 7, NOW(), NOW()),
(7, 5, NOW(), NOW());

-- =====================================================
-- 6. PASSWORD RESET TOKENS
-- =====================================================

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 7. PERSONAL ACCESS TOKENS (SANCTUM)
-- =====================================================

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`, `tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 8. SCHOOL PROFILES
-- =====================================================

CREATE TABLE `school_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_name` varchar(200) NOT NULL,
  `npsn` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `vision` text DEFAULT NULL,
  `mission` text DEFAULT NULL,
  `history` text DEFAULT NULL,
  `logo` varchar(500) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `youtube` varchar(255) DEFAULT NULL,
  `twitter` varchar(255) DEFAULT NULL,
  `headmaster_name` varchar(255) DEFAULT NULL,
  `headmaster_photo` varchar(500) DEFAULT NULL,
  `headmaster_message` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `school_profiles` (`id`, `school_name`, `npsn`, `address`, `phone`, `email`, `website`, `vision`, `mission`, `headmaster_name`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'SMK Nurul Jadid', '20512345', 'Jl. Pendidikan No. 123, Kabupaten Probolinggo', '(0335) 123456', 'info@smknuruljadid.sch.id', 'https://smknuruljadid.sch.id', 'Menjadi sekolah unggulan yang menghasilkan lulusan berkompeten, berakhlak mulia, dan mampu bersaing di era global.', 'Menyelenggarakan pendidikan berkualitas, mengembangkan potensi siswa, membangun karakter mulia.', 'Dr. H. Bambang Sutopo, M.Pd', 1, NOW(), NOW());

-- =====================================================
-- 9. MAJORS
-- =====================================================

CREATE TABLE `majors` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `vision` text DEFAULT NULL,
  `mission` text DEFAULT NULL,
  `facilities` text DEFAULT NULL,
  `head_of_major` varchar(255) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `student_count` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `majors_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `majors` (`id`, `name`, `code`, `slug`, `description`, `student_count`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Teknik Kendaraan Ringan Otomotif', 'TKRO', 'teknik-kendaraan-ringan-otomotif', 'Program keahlian yang mempelajari tentang perawatan dan perbaikan kendaraan ringan.', 120, 1, NOW(), NOW()),
(2, 'Rekayasa Perangkat Lunak', 'RPL', 'rekayasa-perangkat-lunak', 'Program keahlian yang mempelajari tentang pengembangan perangkat lunak dan aplikasi.', 150, 1, NOW(), NOW()),
(3, 'Teknik Bisnis Sepeda Motor', 'TBSM', 'teknik-bisnis-sepeda-motor', 'Program keahlian yang mempelajari tentang perawatan, perbaikan, dan bisnis sepeda motor.', 100, 1, NOW(), NOW()),
(4, 'Akuntansi dan Keuangan Lembaga', 'AKL', 'akuntansi-dan-keuangan-lembaga', 'Program keahlian yang mempelajari tentang akuntansi dan pengelolaan keuangan.', 80, 1, NOW(), NOW());

-- =====================================================
-- 10. STUDENTS
-- =====================================================

CREATE TABLE `students` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nisn` varchar(20) DEFAULT NULL,
  `nis` varchar(20) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `major_id` bigint(20) UNSIGNED DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `birth_place` varchar(100) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'active',
  `class` varchar(50) DEFAULT NULL,
  `school_year` varchar(9) DEFAULT NULL,
  `father_name` varchar(255) DEFAULT NULL,
  `father_phone` varchar(30) DEFAULT NULL,
  `mother_name` varchar(255) DEFAULT NULL,
  `mother_phone` varchar(30) DEFAULT NULL,
  `guardian_name` varchar(255) DEFAULT NULL,
  `guardian_phone` varchar(30) DEFAULT NULL,
  `medical_history` text DEFAULT NULL,
  `special_needs` text DEFAULT NULL,
  `photo` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `students_nisn_unique` (`nisn`),
  UNIQUE KEY `students_nis_unique` (`nis`),
  KEY `students_major_id_foreign` (`major_id`),
  KEY `students_major_id_status_index` (`major_id`, `status`),
  KEY `students_status_index` (`status`),
  CONSTRAINT `students_major_id_foreign` FOREIGN KEY (`major_id`) REFERENCES `majors` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `students` (`id`, `nisn`, `nis`, `name`, `major_id`, `gender`, `birth_place`, `birth_date`, `phone`, `email`, `address`, `status`, `class`, `school_year`, `father_name`, `father_phone`, `mother_name`, `mother_phone`, `created_at`, `updated_at`) VALUES
(1, '1234567890', '20240001', 'Ahmad Santoso', 2, 'Laki-laki', 'Probolinggo', '2008-05-15', '081234567890', 'ahmad@student.smknj.sch.id', 'Jl. Merdeka No. 123, Probolinggo', 'active', 'XII RPL 1', '2024/2025', 'Budi Santoso', '081234567891', 'Siti Rahayu', '081234567892', NOW(), NOW()),
(2, '1234567891', '20240002', 'Sari Dewi', 4, 'Perempuan', 'Probolinggo', '2008-08-20', '081234567893', 'sari@student.smknj.sch.id', 'Jl. Pendidikan No. 45, Probolinggo', 'active', 'XII AKL 1', '2024/2025', 'Joko Widodo', '081234567894', 'Ani Yulianti', '081234567895', NOW(), NOW()),
(3, '1234567892', '20240003', 'Rizki Pratama', 1, 'Laki-laki', 'Probolinggo', '2008-03-10', '081234567896', 'rizki@student.smknj.sch.id', 'Jl. Industri No. 67, Probolinggo', 'active', 'XII TKRO 1', '2024/2025', 'Agus Supriyadi', '081234567897', 'Maya Indah', '081234567898', NOW(), NOW());

-- =====================================================
-- 11. NEWS TABLE
-- =====================================================

CREATE TABLE `news` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `excerpt` text DEFAULT NULL,
  `featured_image` varchar(500) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `author_id` bigint(20) UNSIGNED DEFAULT NULL,
  `published` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` timestamp NULL DEFAULT NULL,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `news_slug_unique` (`slug`),
  KEY `news_published_index` (`published`),
  KEY `news_category_index` (`category`),
  KEY `news_author_id_foreign` (`author_id`),
  CONSTRAINT `news_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `news` (`id`, `title`, `slug`, `content`, `excerpt`, `category`, `author_id`, `published`, `published_at`, `created_at`, `updated_at`) VALUES
(1, 'Pengumuman PPDB 2025', 'pengumuman-ppdb-2025', 'Informasi lengkap tentang Penerimaan Peserta Didik Baru tahun 2025 sudah dibuka.', 'PPDB 2025 telah dibuka dengan kuota untuk semua jurusan.', 'pengumuman', 2, 1, NOW(), NOW(), NOW()),
(2, 'Prestasi Siswa di Tingkat Nasional', 'prestasi-siswa-di-tingkat-nasional', 'Siswa kami berhasil meraih juara 1 dalam kompetisi teknologi nasional.', 'Tim siswa RPL meraih juara 1 kompetisi teknologi.', 'prestasi', 2, 1, NOW(), NOW(), NOW()),
(3, 'Program Magang Industri 2025', 'program-magang-industri-2025', 'Program magang tahun 2025 akan dilaksanakan dengan melibatkan berbagai industri terkemuka.', 'Daftar industri mitra magang sudah diumumkan.', 'akademik', 2, 1, NOW(), NOW(), NOW());

-- =====================================================
-- 12. SITE IMAGES (Gambar dinamis)
-- =====================================================

CREATE TABLE `site_images` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(500) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `section` varchar(50) NOT NULL,
  `position` int(11) DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `site_images_key_unique` (`key`),
  KEY `site_images_section_index` (`section`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `site_images` (`id`, `key`, `title`, `description`, `image_path`, `image_url`, `alt_text`, `section`, `position`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'hero_banner', 'Banner Utama Homepage', 'Banner besar di halaman utama', 'site-images/hero-banner.jpg', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&q=80', 'SMK Nurul Jadid Hero Banner', 'homepage', 1, 1, NOW(), NOW()),
(2, 'hero_banner_mobile', 'Banner Utama Mobile', 'Banner untuk tampilan mobile', 'site-images/hero-banner-mobile.jpg', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600&q=80', 'SMK Mobile Banner', 'homepage', 2, 1, NOW(), NOW()),
(3, 'about_image', 'Gambar Tentang Sekolah', 'Gambar untuk section About Us', 'site-images/about-school.jpg', 'https://images.unsplash.com/photo-1427504494785-cdcb6f5d9c90?w=800&q=80', 'Tentang SMK Nurul Jadid', 'about', 1, 1, NOW(), NOW()),
(4, 'headmaster_photo', 'Foto Kepala Sekolah', 'Foto resmi kepala sekolah', 'site-images/headmaster.jpg', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80', 'Kepala Sekolah SMK', 'about', 2, 1, NOW(), NOW()),
(5, 'facility_lab_komputer', 'Lab Komputer', 'Foto laboratorium komputer', 'site-images/facilities/lab-komputer.jpg', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80', 'Lab Komputer', 'facilities', 1, 1, NOW(), NOW()),
(6, 'facility_lab_otomotif', 'Lab Otomotif', 'Foto laboratorium otomotif', 'site-images/facilities/lab-otomotif.jpg', 'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=800&q=80', 'Lab Otomotif', 'facilities', 2, 1, NOW(), NOW()),
(7, 'facility_perpustakaan', 'Perpustakaan', 'Foto perpustakaan sekolah', 'site-images/facilities/perpustakaan.jpg', 'https://images.unsplash.com/photo-150784272343-583f20270319?w=800&q=80', 'Perpustakaan SMK', 'facilities', 3, 1, NOW(), NOW()),
(8, 'slider_1', 'Slider Homepage 1', 'Gambar slider pertama', 'site-images/sliders/slider-1.jpg', 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=1920&q=80', 'Kegiatan Siswa 1', 'homepage_slider', 1, 1, NOW(), NOW()),
(9, 'slider_2', 'Slider Homepage 2', 'Gambar slider kedua', 'site-images/sliders/slider-2.jpg', 'https://images.unsplash.com/photo-1537995882-c42d960eaf6c?w=1920&q=80', 'Kegiatan Siswa 2', 'homepage_slider', 2, 1, NOW(), NOW()),
(10, 'slider_3', 'Slider Homepage 3', 'Gambar slider ketiga', 'site-images/sliders/slider-3.jpg', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&q=80', 'Kegiatan Siswa 3', 'homepage_slider', 3, 1, NOW(), NOW()),
(11, 'ppdb_banner', 'Banner PPDB', 'Banner untuk halaman PPDB', 'site-images/ppdb-banner.jpg', 'https://images.unsplash.com/photo-1427504494785-cdcb6f5d9c90?w=1920&q=80', 'PPDB Banner', 'ppdb', 1, 1, NOW(), NOW()),
(12, 'contact_map', 'Peta Lokasi Sekolah', 'Gambar peta atau foto lokasi', 'site-images/contact-map.jpg', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80', 'Lokasi SMK', 'contact', 1, 1, NOW(), NOW());

-- =====================================================
-- 13. FILE METADATA
-- =====================================================

CREATE TABLE `file_metadata` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `original_name` varchar(255) NOT NULL,
  `secure_name` varchar(255) NOT NULL,
  `path` varchar(500) NOT NULL,
  `url` varchar(500) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `size` bigint(20) NOT NULL,
  `extension` varchar(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `uploaded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `owner_type` varchar(100) DEFAULT NULL,
  `permissions` json DEFAULT NULL,
  `hash` varchar(64) DEFAULT NULL,
  `is_encrypted` tinyint(1) NOT NULL DEFAULT 0,
  `encryption_key_id` varchar(255) DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `expires_at` timestamp NULL DEFAULT NULL,
  `download_count` int(11) NOT NULL DEFAULT 0,
  `last_downloaded_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `file_metadata_type_index` (`type`),
  KEY `file_metadata_is_public_index` (`is_public`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 14. LOGIN ATTEMPTS
-- =====================================================

CREATE TABLE `login_attempts` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(191) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `successful` tinyint(1) NOT NULL DEFAULT 0,
  `failure_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `login_attempts_email_index` (`email`),
  KEY `login_attempts_ip_address_index` (`ip_address`),
  KEY `login_attempts_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 15. ACTIVITY LOGS
-- =====================================================

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `log_name` varchar(100) DEFAULT NULL,
  `description` text NOT NULL,
  `subject_type` varchar(255) DEFAULT NULL,
  `subject_id` bigint(20) UNSIGNED DEFAULT NULL,
  `event` varchar(50) DEFAULT NULL,
  `causer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `causer_type` varchar(255) DEFAULT NULL,
  `properties` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `browser` varchar(100) DEFAULT NULL,
  `platform` varchar(100) DEFAULT NULL,
  `device` varchar(100) DEFAULT NULL,
  `endpoint` varchar(255) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_logs_created_at_index` (`created_at`),
  KEY `activity_logs_event_index` (`event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 16. SECURITY ALERTS
-- =====================================================

CREATE TABLE `security_alerts` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `alert_type` varchar(50) NOT NULL,
  `severity` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `details` json DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `endpoint` varchar(255) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `request_data` json DEFAULT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT 0,
  `resolution_notes` varchar(500) DEFAULT NULL,
  `resolved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `security_alerts_alert_type_index` (`alert_type`),
  KEY `security_alerts_severity_index` (`severity`),
  KEY `security_alerts_resolved_index` (`resolved`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 17. API RATE LIMITS
-- =====================================================

CREATE TABLE `api_rate_limits` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `api_key` varchar(64) DEFAULT NULL,
  `endpoint` varchar(255) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `request_count` int(11) NOT NULL DEFAULT 0,
  `window_start` timestamp NOT NULL,
  `window_end` timestamp NOT NULL,
  `is_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `block_reason` varchar(500) DEFAULT NULL,
  `blocked_until` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `api_rate_limits_ip_address_index` (`ip_address`),
  KEY `api_rate_limits_is_blocked_index` (`is_blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 18. SECURITY CONFIGURATIONS
-- =====================================================

CREATE TABLE `security_configurations` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) NOT NULL,
  `config_value` text NOT NULL,
  `data_type` varchar(20) NOT NULL DEFAULT 'string',
  `category` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `security_configurations_config_key_unique` (`config_key`),
  KEY `security_configurations_category_index` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `security_configurations` (`id`, `config_key`, `config_value`, `data_type`, `category`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'max_login_attempts', '5', 'integer', 'authentication', 'Maximum number of failed login attempts', 1, NOW(), NOW()),
(2, 'account_lockout_minutes', '15', 'integer', 'authentication', 'Account lockout duration in minutes', 1, NOW(), NOW()),
(3, 'password_min_length', '8', 'integer', 'authentication', 'Minimum password length', 1, NOW(), NOW()),
(4, 'password_expiry_days', '90', 'integer', 'authentication', 'Password expiry in days', 1, NOW(), NOW()),
(5, 'api_rate_limit_per_minute', '60', 'integer', 'rate_limiting', 'Max API requests per minute', 1, NOW(), NOW()),
(6, 'enable_two_factor_auth', 'false', 'boolean', 'authentication', 'Enable two-factor authentication', 1, NOW(), NOW()),
(7, 'session_timeout_minutes', '120', 'integer', 'authentication', 'Session timeout in minutes', 1, NOW(), NOW()),
(8, 'enable_login_notifications', 'true', 'boolean', 'logging', 'Send login notifications', 1, NOW(), NOW());

-- =====================================================
-- 19. CHATBOT CONVERSATIONS
-- =====================================================

CREATE TABLE `chatbot_conversations` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `context` varchar(50) DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `message_count` int(11) NOT NULL DEFAULT 0,
  `started_at` timestamp NOT NULL,
  `last_activity_at` timestamp NOT NULL,
  `ended_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chatbot_conversations_session_id_unique` (`session_id`),
  KEY `chatbot_conversations_is_active_index` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 20. CHATBOT MESSAGES
-- =====================================================

CREATE TABLE `chatbot_messages` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint(20) UNSIGNED NOT NULL,
  `sender` enum('user','bot','system') NOT NULL,
  `message` text NOT NULL,
  `metadata` json DEFAULT NULL,
  `ai_model` varchar(255) DEFAULT NULL,
  `tokens_used` int(11) DEFAULT NULL,
  `response_time` float DEFAULT NULL,
  `message_type` varchar(50) NOT NULL DEFAULT 'text',
  `is_flagged` tinyint(1) NOT NULL DEFAULT 0,
  `flag_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `chatbot_messages_conversation_id_foreign` (`conversation_id`),
  CONSTRAINT `chatbot_messages_conversation_id_foreign` FOREIGN KEY (`conversation_id`) REFERENCES `chatbot_conversations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 21. CHATBOT KNOWLEDGE BASE
-- =====================================================

CREATE TABLE `chatbot_knowledge_base` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  `question` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `keywords` json DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `usage_count` int(11) NOT NULL DEFAULT 0,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `chatbot_knowledge_base_category_index` (`category`),
  KEY `chatbot_knowledge_base_is_active_index` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 22. CACHE TABLE
-- =====================================================

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 23. CACHE LOCKS TABLE
-- =====================================================

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 24. JOBS TABLE
-- =====================================================

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 25. JOB BATCHES TABLE
-- =====================================================

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(10) UNSIGNED DEFAULT NULL,
  `created_at` int(10) UNSIGNED NOT NULL,
  `finished_at` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 26. SESSIONS TABLE
-- =====================================================

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- COMMIT TRANSACTION
-- =====================================================

COMMIT;
