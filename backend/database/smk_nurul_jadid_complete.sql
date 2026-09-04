-- =====================================================
-- Database untuk SMK Nurul Jadid
-- Version: 1.0.0
-- Created: 2026-08-24
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Create Database
CREATE DATABASE IF NOT EXISTS `db_smknuruljadid` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `db_smknuruljadid`;

-- =====================================================
-- 1. AUTHENTICATION & AUTHORIZATION TABLES
-- =====================================================

-- Roles Table
CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Default Roles
INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 'Super Administrator - Full access', NOW(), NOW()),
(2, 'admin_sekolah', 'Admin Sekolah - School management', NOW(), NOW()),
(3, 'tu_sekolah', 'Tata Usaha Sekolah - Administration', NOW(), NOW()),
(4, 'guru', 'Guru - Teacher', NOW(), NOW()),
(5, 'siswa', 'Siswa - Student', NOW(), NOW()),
(6, 'ppdb', 'Admin PPDB - PPDB management', NOW(), NOW()),
(7, 'bkk', 'Admin BKK - Career center', NOW(), NOW());

-- Permissions Table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Default Permissions
INSERT INTO `permissions` (`name`, `slug`, `description`, `module`, `created_at`, `updated_at`) VALUES
('View Dashboard', 'dashboard.view', 'Can view dashboard', 'dashboard', NOW(), NOW()),
('Manage Users', 'users.manage', 'Can create, edit, delete users', 'users', NOW(), NOW()),
('View Users', 'users.view', 'Can view user list', 'users', NOW(), NOW()),
('Manage Roles', 'roles.manage', 'Can manage roles and permissions', 'roles', NOW(), NOW()),
('Manage School Profile', 'school_profile.manage', 'Can manage school profile', 'school', NOW(), NOW()),
('Manage Students', 'students.manage', 'Can manage student data', 'students', NOW(), NOW()),
('View Students', 'students.view', 'Can view student list', 'students', NOW(), NOW()),
('Manage Majors', 'majors.manage', 'Can manage majors', 'academic', NOW(), NOW()),
('View Majors', 'majors.view', 'Can view majors', 'academic', NOW(), NOW()),
('Manage News', 'news.manage', 'Can create, edit, delete news', 'content', NOW(), NOW()),
('View News', 'news.view', 'Can view news list', 'content', NOW(), NOW()),
('Manage PPDB', 'ppdb.manage', 'Can manage PPDB applications', 'ppdb', NOW(), NOW()),
('View PPDB', 'ppdb.view', 'Can view PPDB applications', 'ppdb', NOW(), NOW()),
('Manage PKL', 'pkl.manage', 'Can manage PKL programs', 'pkl', NOW(), NOW()),
('View PKL', 'pkl.view', 'Can view PKL programs', 'pkl', NOW(), NOW()),
('Manage Job Vacancies', 'jobs.manage', 'Can manage job vacancies', 'bkk', NOW(), NOW()),
('View Job Vacancies', 'jobs.view', 'Can view job vacancies', 'bkk', NOW(), NOW()),
('Manage TEFA Store', 'tefa_store.manage', 'Can manage TEFA store products', 'tefa', NOW(), NOW()),
('View TEFA Store', 'tefa_store.view', 'Can view TEFA store products', 'tefa', NOW(), NOW()),
('Manage Settings', 'settings.manage', 'Can manage system settings', 'settings', NOW(), NOW()),
('View Reports', 'reports.view', 'Can view reports', 'reports', NOW(), NOW()),
('Export Reports', 'reports.export', 'Can export reports', 'reports', NOW(), NOW());

-- Role Permissions Junction Table
CREATE TABLE `role_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `role_permissions_permission_id_foreign` (`permission_id`),
  CONSTRAINT `role_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users Table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Default Users
INSERT INTO `users` (`name`, `email`, `password`, `phone`, `is_active`, `last_login_at`, `last_password_change`, `created_at`, `updated_at`) VALUES
('Super Administrator', 'superadmin@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567890', 1, NOW(), NOW(), NOW(), NOW()),
('Admin Sekolah', 'admin@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567891', 1, NOW(), NOW(), NOW(), NOW()),
('Tata Usaha Sekolah', 'tu@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567892', 1, NOW(), NOW(), NOW(), NOW()),
('Guru Contoh', 'guru@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567893', 1, NOW(), NOW(), NOW(), NOW()),
('Admin PPDB', 'ppdb@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567894', 1, NOW(), NOW(), NOW(), NOW()),
('Admin BKK', 'bkk@smknuruljadid.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567895', 1, NOW(), NOW(), NOW(), NOW()),
('Ahmad Santoso', 'ahmad@student.smknj.sch.id', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '081234567896', 1, NOW(), NOW(), NOW(), NOW());

-- User Roles Junction Table
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

-- Assign Roles to Users
INSERT INTO `user_roles` (`user_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 1, NOW(), NOW()), -- superadmin
(2, 2, NOW(), NOW()), -- admin_sekolah
(3, 3, NOW(), NOW()), -- tu_sekolah
(4, 4, NOW(), NOW()), -- guru
(5, 6, NOW(), NOW()), -- ppdb
(6, 7, NOW(), NOW()), -- bkk
(7, 5, NOW(), NOW()); -- siswa

-- Password Reset Tokens
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Personal Access Tokens (Laravel Sanctum)
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
-- 2. SCHOOL MANAGEMENT TABLES
-- =====================================================

-- School Profiles Table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Default School Profile
INSERT INTO `school_profiles` (`school_name`, `npsn`, `address`, `phone`, `email`, `website`, `vision`, `mission`, `is_active`, `created_at`, `updated_at`) VALUES
('SMK Nurul Jadid', '20512345', 'Jl. Pendidikan No. 123, Kabupaten Probolinggo', '(0335) 123456', 'info@smknuruljadid.sch.id', 'https://smknuruljadid.sch.id',
'Menjadi sekolah unggulan yang menghasilkan lulusan berkompeten, berakhlak mulia, dan mampu bersaing di era global.',
'1. Menyelenggarakan pendidikan yang berkualitas.\n2. Mengembangkan potensi siswa secara optimal.\n3. Membangun karakter yang berakhlak mulia.',
1, NOW(), NOW());

-- Majors Table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Default Majors
INSERT INTO `majors` (`name`, `code`, `slug`, `description`, `student_count`, `is_active`, `created_at`, `updated_at`) VALUES
('Teknik Kendaraan Ringan Otomotif', 'TKRO', 'teknik-kendaraan-ringan-otomotif', 'Program keahlian yang mempelajari tentang perawatan dan perbaikan kendaraan ringan.', 120, 1, NOW(), NOW()),
('Rekayasa Perangkat Lunak', 'RPL', 'rekayasa-perangkat-lunak', 'Program keahlian yang mempelajari tentang pengembangan perangkat lunak dan aplikasi.', 150, 1, NOW(), NOW()),
('Teknik Bisnis Sepeda Motor', 'TBSM', 'teknik-bisnis-sepeda-motor', 'Program keahlian yang mempelajari tentang perawatan, perbaikan, dan bisnis sepeda motor.', 100, 1, NOW(), NOW()),
('Akuntansi dan Keuangan Lembaga', 'AKL', 'akuntansi-dan-keuangan-lembaga', 'Program keahlian yang mempelajari tentang akuntansi dan pengelolaan keuangan.', 80, 1, NOW(), NOW());

-- Students Table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Sample Students
INSERT INTO `students` (`nisn`, `nis`, `name`, `major_id`, `gender`, `birth_place`, `birth_date`, `phone`, `email`, `address`, `status`, `class`, `school_year`, `father_name`, `father_phone`, `mother_name`, `mother_phone`, `created_at`, `updated_at`) VALUES
('1234567890', '20240001', 'Ahmad Santoso', 2, 'Laki-laki', 'Probolinggo', '2008-05-15', '081234567890', 'ahmad@student.smknj.sch.id', 'Jl. Merdeka No. 123, Probolinggo', 'active', 'XII RPL 1', '2024/2025', 'Budi Santoso', '081234567891', 'Siti Rahayu', '081234567892', NOW(), NOW()),
('1234567891', '20240002', 'Sari Dewi', 4, 'Perempuan', 'Probolinggo', '2008-08-20', '081234567893', 'sari@student.smknj.sch.id', 'Jl. Pendidikan No. 45, Probolinggo', 'active', 'XII AKL 1', '2024/2025', 'Joko Widodo', '081234567894', 'Ani Yulianti', '081234567895', NOW(), NOW()),
('1234567892', '20240003', 'Rizki Pratama', 1, 'Laki-laki', 'Probolinggo', '2008-03-10', '081234567896', 'rizki@student.smknj.sch.id', 'Jl. Industri No. 67, Probolinggo', 'active', 'XII TKRO 1', '2024/2025', 'Agus Supriyadi', '081234567897', 'Maya Indah', '081234567898', NOW(), NOW());

-- =====================================================
-- 3. DYNAMIC IMAGES TABLE (Gambar yang bisa diubah)
-- =====================================================

CREATE TABLE `site_images` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL COMMENT 'Unique identifier untuk gambar (e.g., hero_banner, about_image)',
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(500) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `section` varchar(50) NOT NULL COMMENT 'Section website (e.g., homepage, about, gallery)',
  `position` int(11) DEFAULT 1 COMMENT 'Urutan tampilan',
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
  KEY `site_images_section_index` (`section`),
  KEY `site_images_created_by_foreign` (`created_by`),
  KEY `site_images_updated_by_foreign` (`updated_by`),
  CONSTRAINT `site_images_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `site_images_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Default Site Images (placeholder - akan diisi oleh admin)
INSERT INTO `site_images` (`key`, `title`, `description`, `image_path`, `section`, `position`, `is_active`, `created_at`, `updated_at`) VALUES
('hero_banner', 'Banner Utama Homepage', 'Banner besar di halaman utama', 'site-images/hero-banner.jpg', 'homepage', 1, 1, NOW(), NOW()),
('hero_banner_mobile', 'Banner Utama Mobile', 'Banner untuk tampilan mobile', 'site-images/hero-banner-mobile.jpg', 'homepage', 2, 1, NOW(), NOW()),
('about_image', 'Gambar Tentang Sekolah', 'Gambar untuk section About Us', 'site-images/about-school.jpg', 'about', 1, 1, NOW(), NOW()),
('headmaster_photo', 'Foto Kepala Sekolah', 'Foto resmi kepala sekolah', 'site-images/headmaster.jpg', 'about', 2, 1, NOW(), NOW()),
('facility_lab_komputer', 'Lab Komputer', 'Foto laboratorium komputer', 'site-images/facilities/lab-komputer.jpg', 'facilities', 1, 1, NOW(), NOW()),
('facility_lab_otomotif', 'Lab Otomotif', 'Foto laboratorium otomotif', 'site-images/facilities/lab-otomotif.jpg', 'facilities', 2, 1, NOW(), NOW()),
('facility_perpustakaan', 'Perpustakaan', 'Foto perpustakaan sekolah', 'site-images/facilities/perpustakaan.jpg', 'facilities', 3, 1, NOW(), NOW()),
('slider_1', 'Slider Homepage 1', 'Gambar slider pertama', 'site-images/sliders/slider-1.jpg', 'homepage_slider', 1, 1, NOW(), NOW()),
('slider_2', 'Slider Homepage 2', 'Gambar slider kedua', 'site-images/sliders/slider-2.jpg', 'homepage_slider', 2, 1, NOW(), NOW()),
('slider_3', 'Slider Homepage 3', 'Gambar slider ketiga', 'site-images/sliders/slider-3.jpg', 'homepage_slider', 3, 1, NOW(), NOW()),
('ppdb_banner', 'Banner PPDB', 'Banner untuk halaman PPDB', 'site-images/ppdb-banner.jpg', 'ppdb', 1, 1, NOW(), NOW()),
('contact_map', 'Peta Lokasi Sekolah', 'Gambar peta atau foto lokasi', 'site-images/contact-map.jpg', 'contact', 1, 1, NOW(), NOW());

-- =====================================================
-- 4. FILE MANAGEMENT TABLE
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
  `type` varchar(50) NOT NULL COMMENT 'student_document, profile_photo, product_image, etc.',
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
  KEY `file_metadata_uploaded_by_foreign` (`uploaded_by`),
  KEY `file_metadata_type_index` (`type`),
  KEY `file_metadata_owner_type_index` (`owner_type`),
  KEY `file_metadata_is_public_index` (`is_public`),
  CONSTRAINT `file_metadata_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 5. SECURITY MONITORING TABLES
-- =====================================================

-- Login Attempts Table
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

-- Activity Logs Table
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
  KEY `activity_logs_log_name_subject_type_subject_id_index` (`log_name`, `subject_type`, `subject_id`),
  KEY `activity_logs_causer_type_causer_id_index` (`causer_type`, `causer_id`),
  KEY `activity_logs_created_at_index` (`created_at`),
  KEY `activity_logs_event_index` (`event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Security Alerts Table
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
  `is_resolved` tinyint(1) NOT NULL DEFAULT 0,
  `resolution_notes` varchar(500) DEFAULT NULL,
  `resolved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `security_alerts_user_id_foreign` (`user_id`),
  KEY `security_alerts_resolved_by_foreign` (`resolved_by`),
  KEY `security_alerts_alert_type_index` (`alert_type`),
  KEY `security_alerts_severity_index` (`severity`),
  KEY `security_alerts_ip_address_index` (`ip_address`),
  KEY `security_alerts_is_resolved_index` (`is_resolved`),
  CONSTRAINT `security_alerts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `security_alerts_resolved_by_foreign` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- API Rate Limits Table
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
  KEY `api_rate_limits_api_key_index` (`api_key`),
  KEY `api_rate_limits_ip_address_index` (`ip_address`),
  KEY `api_rate_limits_endpoint_index` (`endpoint`),
  KEY `api_rate_limits_is_blocked_index` (`is_blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Security Configurations Table
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
  KEY `security_configurations_updated_by_foreign` (`updated_by`),
  KEY `security_configurations_category_index` (`category`),
  KEY `security_configurations_is_active_index` (`is_active`),
  CONSTRAINT `security_configurations_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Default Security Configurations
INSERT INTO `security_configurations` (`config_key`, `config_value`, `data_type`, `category`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
('max_login_attempts', '5', 'integer', 'authentication', 'Maximum number of failed login attempts before account lock', 1, NOW(), NOW()),
('account_lockout_minutes', '15', 'integer', 'authentication', 'Number of minutes to lock account after too many failed attempts', 1, NOW(), NOW()),
('password_min_length', '8', 'integer', 'authentication', 'Minimum password length', 1, NOW(), NOW()),
('password_expiry_days', '90', 'integer', 'authentication', 'Number of days before password expires', 1, NOW(), NOW()),
('api_rate_limit_per_minute', '60', 'integer', 'rate_limiting', 'Maximum API requests per minute per IP', 1, NOW(), NOW()),
('enable_two_factor_auth', 'false', 'boolean', 'authentication', 'Enable two-factor authentication for all users', 1, NOW(), NOW()),
('session_timeout_minutes', '120', 'integer', 'authentication', 'Session timeout in minutes', 1, NOW(), NOW()),
('enable_login_notifications', 'true', 'boolean', 'logging', 'Send email notifications for successful logins from new devices', 1, NOW(), NOW());

-- =====================================================
-- 6. CHATBOT & AI TABLES
-- =====================================================

-- Chatbot Conversations Table
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
  KEY `chatbot_conversations_user_id_foreign` (`user_id`),
  KEY `chatbot_conversations_context_index` (`context`),
  KEY `chatbot_conversations_is_active_index` (`is_active`),
  CONSTRAINT `chatbot_conversations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chatbot Messages Table
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
  KEY `chatbot_messages_sender_index` (`sender`),
  KEY `chatbot_messages_created_at_index` (`created_at`),
  KEY `chatbot_messages_is_flagged_index` (`is_flagged`),
  CONSTRAINT `chatbot_messages_conversation_id_foreign` FOREIGN KEY (`conversation_id`) REFERENCES `chatbot_conversations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chatbot Knowledge Base Table
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
  KEY `chatbot_knowledge_base_created_by_foreign` (`created_by`),
  KEY `chatbot_knowledge_base_updated_by_foreign` (`updated_by`),
  KEY `chatbot_knowledge_base_category_index` (`category`),
  KEY `chatbot_knowledge_base_is_active_index` (`is_active`),
  KEY `chatbot_knowledge_base_priority_index` (`priority`),
  FULLTEXT KEY `chatbot_knowledge_base_question_answer_fulltext` (`question`, `answer`),
  CONSTRAINT `chatbot_knowledge_base_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `chatbot_knowledge_base_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AI API Logs Table
CREATE TABLE `ai_api_logs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `api_provider` varchar(50) NOT NULL,
  `endpoint` varchar(100) NOT NULL,
  `request_data` json DEFAULT NULL,
  `response_data` json DEFAULT NULL,
  `status_code` int(11) NOT NULL,
  `response_time` float NOT NULL,
  `tokens_used` int(11) DEFAULT NULL,
  `cost` float DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `error_message` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ai_api_logs_user_id_foreign` (`user_id`),
  KEY `ai_api_logs_api_provider_index` (`api_provider`),
  KEY `ai_api_logs_endpoint_index` (`endpoint`),
  KEY `ai_api_logs_created_at_index` (`created_at`),
  KEY `ai_api_logs_status_code_index` (`status_code`),
  CONSTRAINT `ai_api_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 7. SESSIONS TABLE
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
-- 8. CACHE TABLE
-- =====================================================

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 9. JOBS TABLE (for Queue)
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

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- AUTO INCREMENT RESET
-- =====================================================

ALTER TABLE `roles` AUTO_INCREMENT = 8;
ALTER TABLE `permissions` AUTO_INCREMENT = 23;
ALTER TABLE `users` AUTO_INCREMENT = 8;
ALTER TABLE `school_profiles` AUTO_INCREMENT = 2;
ALTER TABLE `majors` AUTO_INCREMENT = 5;
ALTER TABLE `students` AUTO_INCREMENT = 4;
ALTER TABLE `site_images` AUTO_INCREMENT = 13;

COMMIT;

-- =====================================================
-- END OF SQL FILE
-- =====================================================

-- Catatan:
-- 1. Password default untuk semua user: password123
-- 2. Hash password: $2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi
-- 3. Ganti semua password setelah deployment!
-- 4. Table site_images untuk gambar dinamis yang bisa diubah dari admin
-- 5. Gambar statis (logo di code, icon, dll) tidak perlu di database
