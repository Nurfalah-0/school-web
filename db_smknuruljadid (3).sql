-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 28 Sep 2026 pada 08.11
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_smknuruljadid`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `achievements`
--

CREATE TABLE `achievements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `level` varchar(100) DEFAULT NULL,
  `organizer` varchar(200) DEFAULT NULL,
  `year` smallint(5) UNSIGNED DEFAULT NULL,
  `achieved_at` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `rank` varchar(50) DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_published` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `achievements`
--

INSERT INTO `achievements` (`id`, `title`, `slug`, `category`, `level`, `organizer`, `year`, `achieved_at`, `description`, `image`, `rank`, `is_featured`, `is_published`, `created_at`, `updated_at`) VALUES
(1, 'Juara 1 Regional Coding Championship', 'juara-1-regional-coding-championship', 'Akademik', 'Regional', 'Dinas Pendidikan', 2025, NULL, 'Tim Cyber SMK meraih juara pertama dalam kompetisi pengembangan perangkat lunak.', 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=1200&q=80', 'Juara 1', 1, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(2, 'Medali Emas Kejuaraan Robotik Nasional', 'medali-emas-kejuaraan-robotik-nasional', 'Akademik', 'Nasional', 'Kementerian Pendidikan', 2025, NULL, 'Tim robotik sekolah meraih medali emas pada kejuaraan robotik nasional.', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=1200&q=80', 'Medali Emas', 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(3, 'Penghargaan Sosial Pengabdian Masyarakat', 'penghargaan-sosial-pengabdian-masyarakat', 'Sosial', 'Kabupaten', 'Dinas Pendidikan', 2024, NULL, 'Program pengabdian masyarakat sekolah mendapatkan penghargaan terbaik.', 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=1200&q=80', 'Terbaik', 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(4, 'Juara 1 Turnamen Basket O2SN', 'juara-1-turnamen-basket-o2sn', 'Olahraga', 'Kabupaten', 'O2SN', 2024, '2026-09-16', 'Tim basket sekolah menjadi juara turnamen tingkat kabupaten.', 'content/achievements/jLT2ujUbQr9UzMcWulftTnOOegbeJBHd5B6XtxwW.jpg', 'Juara 1', 0, 1, '2026-09-05 06:59:30', '2026-09-16 07:58:51'),
(5, 'Festival Seni Budaya PETAK', 'festival-seni-budaya-petak', 'Seni Budaya', 'Provinsi', 'PETAK Jawa Timur', 2024, NULL, 'Sanggar seni sekolah meraih juara utama festival budaya tingkat provinsi.', 'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=1200&q=80', 'Juara Utama', 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(8, 'Juara hadrah Ala smk', 'juara-hadrah-ala-smk', 'Provinsi', NULL, NULL, NULL, NULL, 'hahahhahah jubek sarah', 'content/achievements/7034bYL5pnMSq4pWWItGvhSziPCIq3FK368Vv2nT.png', NULL, 0, 1, '2026-09-05 07:16:50', '2026-09-05 07:16:50'),
(9, 'Juara 1 lomba kiroah ', 'juara-1-lomba-kiroah', 'propensi', NULL, NULL, NULL, NULL, 'Juara 1 lomba qiroah atau Musabaqah Tilawatil Quran (MTQ) adalah peserta yang menampilkan bacaan ayat suci Al-Qur\'an dengan standar penilaian tertinggi dari dewan hakim', 'content/achievements/2vRUcwkvF27zr1iXWSUSQ06hVn4XkcO4qepTpnoF.webp', NULL, 0, 1, '2026-09-09 18:23:15', '2026-09-11 19:56:41');

-- --------------------------------------------------------

--
-- Struktur dari tabel `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
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
  `browser` varchar(255) DEFAULT NULL,
  `platform` varchar(255) DEFAULT NULL,
  `device` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `log_name`, `description`, `subject_type`, `subject_id`, `event`, `causer_id`, `causer_type`, `properties`, `ip_address`, `user_agent`, `browser`, `platform`, `device`, `created_at`, `updated_at`) VALUES
(1, 'security', 'Chatbot conversation started: 10261534-561a-48ed-86ba-6e9891247bc8', NULL, NULL, 'chatbot_conversation_started', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/start\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 02:59:35\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-14 19:59:35', '2026-09-14 19:59:35'),
(2, 'security', 'Chatbot message sent: Jurusan apa saja?', NULL, NULL, 'chatbot_message_sent', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/10261534-561a-48ed-86ba-6e9891247bc8\\\\\\/message\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 02:59:36\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-14 19:59:36', '2026-09-14 19:59:36'),
(3, 'security', 'Chatbot conversation started: c232363b-34df-44da-b0fc-00e7b80daf0b', NULL, NULL, 'chatbot_conversation_started', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/start\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 13:23:35\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-15 06:23:35', '2026-09-15 06:23:35'),
(4, 'security', 'Chatbot message sent: haii', NULL, NULL, 'chatbot_message_sent', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/c232363b-34df-44da-b0fc-00e7b80daf0b\\\\\\/message\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 13:23:36\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-15 06:23:36', '2026-09-15 06:23:36'),
(5, 'security', 'Chatbot message sent: kamu siapa', NULL, NULL, 'chatbot_message_sent', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/c232363b-34df-44da-b0fc-00e7b80daf0b\\\\\\/message\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 13:23:43\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-15 06:23:43', '2026-09-15 06:23:43'),
(6, 'security', 'Chatbot message sent: halooo kamu siapa', NULL, NULL, 'chatbot_message_sent', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/c232363b-34df-44da-b0fc-00e7b80daf0b\\\\\\/message\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 13:27:21\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-15 06:27:21', '2026-09-15 06:27:21'),
(7, 'security', 'Chatbot message sent: halooo', NULL, NULL, 'chatbot_message_sent', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/c232363b-34df-44da-b0fc-00e7b80daf0b\\\\\\/message\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 13:27:39\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-15 06:27:39', '2026-09-15 06:27:39'),
(8, 'security', 'Chatbot message sent: haloo', NULL, NULL, 'chatbot_message_sent', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/c232363b-34df-44da-b0fc-00e7b80daf0b\\\\\\/message\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-15 13:29:39\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-15 06:29:39', '2026-09-15 06:29:39'),
(9, 'security', 'Chatbot conversation started: fa81035e-e8e5-4542-81e4-5899355c3503', NULL, NULL, 'chatbot_conversation_started', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/start\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-23 01:18:56\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-22 18:18:56', '2026-09-22 18:18:56'),
(10, 'security', 'Chatbot message sent: Jurusan apa saja?', NULL, NULL, 'chatbot_message_sent', NULL, NULL, '\"{\\\"url\\\":\\\"http:\\\\\\/\\\\\\/localhost:8000\\\\\\/api\\\\\\/chatbot\\\\\\/fa81035e-e8e5-4542-81e4-5899355c3503\\\\\\/message\\\",\\\"method\\\":\\\"POST\\\",\\\"timestamp\\\":\\\"2026-09-23 01:18:57\\\"}\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', NULL, NULL, NULL, '2026-09-22 18:18:57', '2026-09-22 18:18:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `ai_api_logs`
--

CREATE TABLE `ai_api_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `api_provider` varchar(50) NOT NULL,
  `endpoint` varchar(100) NOT NULL,
  `request_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`request_data`)),
  `response_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`response_data`)),
  `status_code` int(11) NOT NULL,
  `response_time` double NOT NULL,
  `tokens_used` int(11) DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `ai_api_logs`
--

INSERT INTO `ai_api_logs` (`id`, `api_provider`, `endpoint`, `request_data`, `response_data`, `status_code`, `response_time`, `tokens_used`, `cost`, `user_id`, `ip_address`, `error_message`, `created_at`, `updated_at`) VALUES
(1, 'openai', 'chat/completion', '{\"message\":\"Jurusan apa saja?\"}', NULL, 500, 0.000058174133300781, 0, 0, NULL, '127.0.0.1', 'AI API key not configured', '2026-09-14 19:59:36', '2026-09-14 19:59:36'),
(2, 'openai', 'chat/completion', '{\"message\":\"haii\"}', NULL, 500, 0.000046014785766602, 0, 0, NULL, '127.0.0.1', 'AI API key not configured', '2026-09-15 06:23:36', '2026-09-15 06:23:36'),
(3, 'openai', 'chat/completion', '{\"message\":\"kamu siapa\"}', NULL, 500, 0.000046968460083008, 0, 0, NULL, '127.0.0.1', 'AI API key not configured', '2026-09-15 06:23:43', '2026-09-15 06:23:43'),
(4, 'openai', 'chat/completion', '{\"message\":\"halooo kamu siapa\"}', NULL, 500, 1.6906580924988, 0, 0, NULL, '127.0.0.1', 'AI API request failed: {\n    \"error\": {\n        \"message\": \"Incorrect API key provided: AQ.Ab8RN*****************************************1hMw. You can find your API key at https://platform.openai.com/account/api-keys.\",\n        \"type\": \"invalid_request_error\",\n        \"param\": null,\n        \"code\": \"invalid_api_key\"\n    }\n}\n', '2026-09-15 06:27:21', '2026-09-15 06:27:21'),
(5, 'openai', 'chat/completion', '{\"message\":\"halooo\"}', NULL, 500, 1.3727719783783, 0, 0, NULL, '127.0.0.1', 'AI API request failed: {\n    \"error\": {\n        \"message\": \"Incorrect API key provided: AQ.Ab8RN*****************************************1hMw. You can find your API key at https://platform.openai.com/account/api-keys.\",\n        \"type\": \"invalid_request_error\",\n        \"param\": null,\n        \"code\": \"invalid_api_key\"\n    }\n}\n', '2026-09-15 06:27:39', '2026-09-15 06:27:39'),
(6, 'openai', 'chat/completion', '{\"message\":\"haloo\"}', NULL, 500, 1.4426100254059, 0, 0, NULL, '127.0.0.1', 'AI API request failed: {\n    \"error\": {\n        \"message\": \"Incorrect API key provided: AQ.Ab8RN*****************************************1hMw. You can find your API key at https://platform.openai.com/account/api-keys.\",\n        \"type\": \"invalid_request_error\",\n        \"param\": null,\n        \"code\": \"invalid_api_key\"\n    }\n}\n', '2026-09-15 06:29:39', '2026-09-15 06:29:39'),
(7, 'openai', 'chat/completion', '{\"message\":\"Jurusan apa saja?\"}', NULL, 500, 0.11396408081055, 0, 0, NULL, '127.0.0.1', 'cURL error 6: Could not resolve host: api.openai.com (see https://curl.se/libcurl/c/libcurl-errors.html) for https://api.openai.com/v1/chat/completions', '2026-09-22 18:18:57', '2026-09-22 18:18:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `api_rate_limits`
--

CREATE TABLE `api_rate_limits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `api_key` varchar(64) DEFAULT NULL,
  `endpoint` varchar(255) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `request_count` int(11) NOT NULL DEFAULT 0,
  `window_start` datetime NOT NULL,
  `window_end` datetime NOT NULL,
  `is_blocked` tinyint(1) NOT NULL DEFAULT 0,
  `block_reason` varchar(255) DEFAULT NULL,
  `blocked_until` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('smk-nurul-jadid-cache-dashboard:stats', 'a:11:{s:14:\"total_students\";i:3;s:12:\"total_majors\";i:6;s:11:\"total_users\";i:7;s:10:\"total_news\";i:5;s:23:\"total_industry_partners\";i:3;s:18:\"total_achievements\";i:7;s:15:\"total_galleries\";i:5;s:14:\"total_products\";i:5;s:19:\"total_job_vacancies\";i:5;s:22:\"active_security_alerts\";i:0;s:4:\"ppdb\";a:4:{s:5:\"total\";i:1;s:7:\"pending\";i:0;s:8:\"diterima\";i:1;s:7:\"ditolak\";i:0;}}', 1789482599);

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `type`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Akademik', 'akademik', 'prestasi', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(2, 'Non-Akademik', 'non-akademik', 'prestasi', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(3, 'PERCETAKAN', 'percetakan', 'tefa', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(4, 'PRODUK KREATIF', 'produk-kreatif', 'tefa', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(5, 'DESIGN GRAFIS', 'design-grafis', 'tefa', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(6, 'MULTIMEDIA', 'multimedia', 'tefa', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(7, 'Kegiatan', 'kegiatan', 'galeri', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(8, 'Fasilitas', 'fasilitas', 'galeri', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(9, 'Prestasi', 'prestasi', 'galeri', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(10, 'Ekstrakurikuler', 'ekstrakurikuler', 'galeri', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(11, 'Prestasi', 'prestasi', 'news', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(12, 'Pengumuman', 'pengumuman', 'news', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(13, 'Kegiatan', 'kegiatan', 'news', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(14, 'IT & Software', 'it-software', 'lowongan', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(15, 'Design', 'design', 'lowongan', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(16, 'Administrasi', 'administrasi', 'lowongan', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12'),
(17, 'Manufaktur', 'manufaktur', 'lowongan', 1, '2026-08-30 08:34:12', '2026-08-30 08:34:12');

-- --------------------------------------------------------

--
-- Struktur dari tabel `chatbot_conversations`
--

CREATE TABLE `chatbot_conversations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `context` varchar(50) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `message_count` int(11) NOT NULL DEFAULT 0,
  `started_at` datetime NOT NULL,
  `last_activity_at` datetime NOT NULL,
  `ended_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `chatbot_conversations`
--

INSERT INTO `chatbot_conversations` (`id`, `session_id`, `user_id`, `ip_address`, `user_agent`, `context`, `metadata`, `message_count`, `started_at`, `last_activity_at`, `ended_at`, `is_active`, `created_at`, `updated_at`) VALUES
(1, '10261534-561a-48ed-86ba-6e9891247bc8', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'general', '{\"user_roles\":[],\"context_prompt\":\"Anda adalah chatbot resmi SMK Nurul Jadid. Jawab hanya pertanyaan tentang SMK Nurul Jadid, seperti profil sekolah, jurusan, PPDB atau SPMB, persyaratan, jadwal, biaya, kegiatan, fasilitas, dan kontak resmi. Gunakan hanya informasi dalam konteks atau knowledge base dan jangan mengarang detail. Jika informasi belum tersedia, arahkan pengguna ke WhatsApp resmi +6282335585491 atau email smknurja.paiton@gmail.com. Jika pertanyaan tidak berkaitan dengan SMK Nurul Jadid, jawab singkat: \\\"Maaf, saya hanya dapat membantu informasi tentang SMK Nurul Jadid.\\\" Jawab dalam bahasa Indonesia dengan ramah.\",\"start_timestamp\":\"2026-09-15 02:59:35\"}', 1, '2026-09-15 02:59:35', '2026-09-15 02:59:36', NULL, 1, '2026-09-14 19:59:35', '2026-09-14 19:59:36'),
(2, 'c232363b-34df-44da-b0fc-00e7b80daf0b', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'general', '{\"user_roles\":[],\"context_prompt\":\"Anda adalah chatbot resmi SMK Nurul Jadid. Jawab hanya pertanyaan tentang SMK Nurul Jadid, seperti profil sekolah, jurusan, PPDB atau SPMB, persyaratan, jadwal, biaya, kegiatan, fasilitas, dan kontak resmi. Gunakan hanya informasi dalam konteks atau knowledge base dan jangan mengarang detail. Jika informasi belum tersedia, arahkan pengguna ke WhatsApp resmi +6282335585491 atau email smknurja.paiton@gmail.com. Jika pertanyaan tidak berkaitan dengan SMK Nurul Jadid, jawab singkat: \\\"Maaf, saya hanya dapat membantu informasi tentang SMK Nurul Jadid.\\\" Jawab dalam bahasa Indonesia dengan ramah.\",\"start_timestamp\":\"2026-09-15 13:23:35\"}', 5, '2026-09-15 13:23:35', '2026-09-15 13:29:37', NULL, 1, '2026-09-15 06:23:35', '2026-09-15 06:29:39'),
(3, 'fa81035e-e8e5-4542-81e4-5899355c3503', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'general', '{\"user_roles\":[],\"context_prompt\":\"Anda adalah chatbot resmi SMK Nurul Jadid. Jawab hanya pertanyaan tentang SMK Nurul Jadid, seperti profil sekolah, jurusan, PPDB atau SPMB, persyaratan, jadwal, biaya, kegiatan, fasilitas, dan kontak resmi. Gunakan hanya informasi dalam konteks atau knowledge base dan jangan mengarang detail. Jika informasi belum tersedia, arahkan pengguna ke WhatsApp resmi +6282335585491 atau email smknurja.paiton@gmail.com. Jika pertanyaan tidak berkaitan dengan SMK Nurul Jadid, jawab singkat: \\\"Maaf, saya hanya dapat membantu informasi tentang SMK Nurul Jadid.\\\" Jawab dalam bahasa Indonesia dengan ramah.\",\"start_timestamp\":\"2026-09-23 01:18:56\"}', 1, '2026-09-23 01:18:56', '2026-09-23 01:18:57', NULL, 1, '2026-09-22 18:18:56', '2026-09-22 18:18:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `chatbot_knowledge_base`
--

CREATE TABLE `chatbot_knowledge_base` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category` varchar(100) NOT NULL,
  `question` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `keywords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`keywords`)),
  `source` varchar(255) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `usage_count` int(11) NOT NULL DEFAULT 0,
  `last_used_at` datetime DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `chatbot_messages`
--

CREATE TABLE `chatbot_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `conversation_id` bigint(20) UNSIGNED NOT NULL,
  `sender` enum('user','bot','system') NOT NULL,
  `message` text NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `ai_model` varchar(255) DEFAULT NULL,
  `tokens_used` int(11) DEFAULT NULL,
  `response_time` double DEFAULT NULL,
  `message_type` varchar(50) NOT NULL DEFAULT 'text',
  `is_flagged` tinyint(1) NOT NULL DEFAULT 0,
  `flag_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `chatbot_messages`
--

INSERT INTO `chatbot_messages` (`id`, `conversation_id`, `sender`, `message`, `metadata`, `ai_model`, `tokens_used`, `response_time`, `message_type`, `is_flagged`, `flag_reason`, `created_at`, `updated_at`) VALUES
(1, 1, 'user', 'Jurusan apa saja?', '{\"ip_address\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"timestamp\":\"2026-09-15 02:59:36\"}', NULL, NULL, NULL, 'text', 0, NULL, '2026-09-14 19:59:36', '2026-09-14 19:59:36'),
(2, 1, 'bot', 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.', '{\"ai_model\":\"fallback\",\"context_used\":\"general\",\"response_timestamp\":\"2026-09-15 02:59:36\"}', 'fallback', 0, 0.000058174133300781, 'text', 0, NULL, '2026-09-14 19:59:36', '2026-09-14 19:59:36'),
(3, 2, 'user', 'haii', '{\"ip_address\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"timestamp\":\"2026-09-15 13:23:36\"}', NULL, NULL, NULL, 'text', 0, NULL, '2026-09-15 06:23:36', '2026-09-15 06:23:36'),
(4, 2, 'bot', 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.', '{\"ai_model\":\"fallback\",\"context_used\":\"general\",\"response_timestamp\":\"2026-09-15 13:23:36\"}', 'fallback', 0, 0.000046014785766602, 'text', 0, NULL, '2026-09-15 06:23:36', '2026-09-15 06:23:36'),
(5, 2, 'user', 'kamu siapa', '{\"ip_address\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"timestamp\":\"2026-09-15 13:23:43\"}', NULL, NULL, NULL, 'text', 0, NULL, '2026-09-15 06:23:43', '2026-09-15 06:23:43'),
(6, 2, 'bot', 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.', '{\"ai_model\":\"fallback\",\"context_used\":\"general\",\"response_timestamp\":\"2026-09-15 13:23:43\"}', 'fallback', 0, 0.000046968460083008, 'text', 0, NULL, '2026-09-15 06:23:43', '2026-09-15 06:23:43'),
(7, 2, 'user', 'halooo kamu siapa', '{\"ip_address\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"timestamp\":\"2026-09-15 13:27:19\"}', NULL, NULL, NULL, 'text', 0, NULL, '2026-09-15 06:27:19', '2026-09-15 06:27:19'),
(8, 2, 'bot', 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.', '{\"ai_model\":\"fallback\",\"context_used\":\"general\",\"response_timestamp\":\"2026-09-15 13:27:21\"}', 'fallback', 0, 1.6906580924988, 'text', 0, NULL, '2026-09-15 06:27:21', '2026-09-15 06:27:21'),
(9, 2, 'user', 'halooo', '{\"ip_address\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"timestamp\":\"2026-09-15 13:27:37\"}', NULL, NULL, NULL, 'text', 0, NULL, '2026-09-15 06:27:37', '2026-09-15 06:27:37'),
(10, 2, 'bot', 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.', '{\"ai_model\":\"fallback\",\"context_used\":\"general\",\"response_timestamp\":\"2026-09-15 13:27:39\"}', 'fallback', 0, 1.3727719783783, 'text', 0, NULL, '2026-09-15 06:27:39', '2026-09-15 06:27:39'),
(11, 2, 'user', 'haloo', '{\"ip_address\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"timestamp\":\"2026-09-15 13:29:37\"}', NULL, NULL, NULL, 'text', 0, NULL, '2026-09-15 06:29:37', '2026-09-15 06:29:37'),
(12, 2, 'bot', 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.', '{\"ai_model\":\"fallback\",\"context_used\":\"general\",\"response_timestamp\":\"2026-09-15 13:29:39\"}', 'fallback', 0, 1.4426100254059, 'text', 0, NULL, '2026-09-15 06:29:39', '2026-09-15 06:29:39'),
(13, 3, 'user', 'Jurusan apa saja?', '{\"ip_address\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/153.0.0.0 Safari\\/537.36\",\"timestamp\":\"2026-09-23 01:18:57\"}', NULL, NULL, NULL, 'text', 0, NULL, '2026-09-22 18:18:57', '2026-09-22 18:18:57'),
(14, 3, 'bot', 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.', '{\"ai_model\":\"fallback\",\"context_used\":\"general\",\"response_timestamp\":\"2026-09-23 01:18:57\"}', 'fallback', 0, 0.11396408081055, 'text', 0, NULL, '2026-09-22 18:18:57', '2026-09-22 18:18:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `file_metadata`
--

CREATE TABLE `file_metadata` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `secure_name` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `mime_type` varchar(255) NOT NULL,
  `size` bigint(20) NOT NULL,
  `extension` varchar(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `uploaded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `owner_type` varchar(100) DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `hash` varchar(64) DEFAULT NULL,
  `is_encrypted` tinyint(1) NOT NULL DEFAULT 0,
  `encryption_key_id` varchar(255) DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `expires_at` datetime DEFAULT NULL,
  `download_count` int(11) NOT NULL DEFAULT 0,
  `last_downloaded_at` datetime DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `galleries`
--

CREATE TABLE `galleries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_published` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `galleries`
--

INSERT INTO `galleries` (`id`, `title`, `slug`, `category`, `description`, `image`, `alt_text`, `sort_order`, `is_featured`, `is_published`, `created_at`, `updated_at`) VALUES
(1, 'Ruang Kelas Digital Innovation Center', 'ruang-kelas-digital-innovation-center', 'Fasilitas', NULL, 'https://images.unsplash.com/photo-1497215842964-222b430dc094?w=1400&q=80', 'Ruang kelas digital', 0, 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(2, 'Perpustakaan Modern SMK Nurul Jadid', 'perpustakaan-modern-smk-nurul-jadid', 'Fasilitas', NULL, 'https://images.unsplash.com/photo-1507842217122-3f45c7f39214?w=1400&q=80', 'Perpustakaan sekolah', 0, 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(3, 'Kelas Industri Bersama Mitra', 'kelas-industri-bersama-mitra', 'Kegiatan Siswa', NULL, 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1400&q=80', 'Kelas industri', 0, 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(4, 'Workshop Soft Skills Bersama Alumni', 'workshop-soft-skills-bersama-alumni', 'Kegiatan Siswa', NULL, 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=1400&q=80', 'Workshop siswa', 0, 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(5, 'Lab Komputer Jaringan dan Server', 'lab-komputer-jaringan-dan-server', 'Lab Praktik', NULL, 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=1400&q=80', 'Laboratorium komputer', 0, 0, 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30');

-- --------------------------------------------------------

--
-- Struktur dari tabel `industry_partners`
--

CREATE TABLE `industry_partners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_name` varchar(200) NOT NULL,
  `slug` varchar(220) NOT NULL,
  `industry_type` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `industry_partners`
--

INSERT INTO `industry_partners` (`id`, `company_name`, `slug`, `industry_type`, `address`, `city`, `phone`, `email`, `website`, `logo`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'PT Teknologi Maju Bersama', 'pt-teknologi-maju-bersama', 'Teknologi Informasi', NULL, 'Surabaya', NULL, NULL, NULL, NULL, 'Mitra industri bidang pengembangan aplikasi dan teknologi digital.', 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(2, 'PT Sumber Rejeki', 'pt-sumber-rejeki', 'Akuntansi dan Keuangan', NULL, 'Probolinggo', NULL, NULL, NULL, NULL, 'Mitra industri untuk pembelajaran administrasi dan akuntansi.', 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(3, 'Creative Studio Jatim', 'creative-studio-jatim', 'Desain Kreatif', NULL, 'Malang', NULL, NULL, NULL, 'content/industry_partners/sjbg7tRwCKKX18djRNGhGRNsH8ryNIcHowIdrCuR.jpg', 'Mitra praktik kerja bidang desain grafis dan multimedia.', 1, '2026-09-05 06:59:30', '2026-09-14 19:58:03');

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

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
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_vacancies`
--

CREATE TABLE `job_vacancies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `industry_partner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `slug` varchar(220) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `description` text NOT NULL,
  `requirements` text DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `employment_type` varchar(50) NOT NULL DEFAULT 'full-time',
  `salary_min` decimal(15,2) DEFAULT NULL,
  `salary_max` decimal(15,2) DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `is_remote` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(30) NOT NULL DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `job_vacancies`
--

INSERT INTO `job_vacancies` (`id`, `industry_partner_id`, `title`, `slug`, `category`, `description`, `requirements`, `location`, `employment_type`, `salary_min`, `salary_max`, `deadline`, `is_remote`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Junior Web Developer', 'junior-web-developer', 'IT dan Software', 'Mengembangkan aplikasi web modern menggunakan Vue.js dan Node.js.', 'HTML, CSS, JavaScript, Vue.js, REST API, dan database SQL.', 'Surabaya', 'full-time', NULL, NULL, '2026-10-24', 0, 'published', '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(2, NULL, 'Staf Akuntansi', 'staf-akuntansi', 'Akuntansi dan Keuangan', 'Mengelola pembukuan, laporan keuangan, dan administrasi pajak.', 'Menguasai Microsoft Excel, teliti, dan komunikatif.', 'Probolinggo', 'full-time', NULL, NULL, '2026-11-15', 0, 'published', '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(3, NULL, 'Magang Desain Grafis', 'magang-desain-grafis', 'Desain Grafis', 'Program magang untuk siswa multimedia pada studio kreatif.', 'Menguasai Adobe Illustrator atau Photoshop dan memiliki portfolio.', 'Malang', 'internship', NULL, NULL, NULL, 0, 'published', '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(4, NULL, 'Teknisi Otomotif', 'teknisi-otomotif', 'Teknik Otomotif', 'Melakukan perawatan dan perbaikan kendaraan sesuai standar dealer.', 'Lulusan SMK otomotif, memahami mesin dan kelistrikan.', 'Surabaya', 'full-time', NULL, NULL, '2026-09-30', 0, 'published', '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(5, NULL, 'Kerja Bakar Hutan Semeru', 'magang', 'TNBTS', 'mau di tanami sawitt', NULL, NULL, 'full-time', NULL, NULL, NULL, 0, 'published', '2026-08-30 07:39:35', '2026-08-30 07:39:35');

-- --------------------------------------------------------

--
-- Struktur dari tabel `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(191) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `successful` tinyint(1) NOT NULL DEFAULT 0,
  `failure_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `majors`
--

CREATE TABLE `majors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `vision` text DEFAULT NULL,
  `mission` text DEFAULT NULL,
  `facilities` text DEFAULT NULL,
  `head_of_major` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `student_count` int(11) NOT NULL DEFAULT 0,
  `capacity` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `majors`
--

INSERT INTO `majors` (`id`, `name`, `code`, `slug`, `description`, `vision`, `mission`, `facilities`, `head_of_major`, `image`, `student_count`, `capacity`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Teknik Kendaraan Ringan Otomotif', 'TKRO', 'teknik-kendaraan-ringan-otomotif', 'Program keahlian yang mempelajari tentang perawatan dan perbaikan kendaraan ringan.', NULL, NULL, NULL, NULL, NULL, 120, 120, 1, NULL, NULL),
(2, 'Rekayasa Perangkat Lunak', 'RPL', 'rekayasa-perangkat-lunak', 'Program keahlian yang mempelajari tentang pengembangan perangkat lunak dan aplikasi.', 'anjaiii kannn', 'kamu sialaaaaaaa', NULL, NULL, NULL, 150, 150, 1, NULL, '2026-09-25 06:14:24'),
(3, 'Teknik Bisnis Sepeda Motor', 'TBSM', 'teknik-bisnis-sepeda-motor', 'Program keahlian yang mempelajari tentang perawatan, perbaikan, dan bisnis sepeda motor.', NULL, NULL, NULL, NULL, NULL, 100, 100, 1, NULL, NULL),
(4, 'Akuntansi dan Keuangan Lembaga', 'AKL', 'akuntansi-dan-keuangan-lembaga', 'Program keahlian yang mempelajari tentang akuntansi dan pengelolaan keuangan.', NULL, NULL, NULL, NULL, NULL, 80, 80, 1, NULL, NULL),
(5, 'Design Komunikasi Visual', 'DKV', 'design-komunikasi-visual', 'dekave elekkkkkkk', 'membuat vidio ', 'membuat foto', NULL, NULL, NULL, 21, 21, 1, '2026-09-06 06:23:17', '2026-09-06 06:23:17'),
(6, 'Teknik Komunikasi Jaringan', 'TKJ2', 'teknik-komunikasi-jaringan', ' adalah singkatan dari Teknik Komputer dan Jaringan, yaitu salah satu kompetensi keahlian atau jurusan di Sekolah Menengah Kejuruan (SMK) yang mempelajari cara merakit komputer, menginstal program, serta membangun dan mengelola jaringan komputer.', 'Mencetak tenaga profesional di bidang Teknik Komputer dan Jaringan yang berstandar nasional maupun internasional.', 'Menghasilkan lulusan yang memiliki kompetensi tinggi dan terampil dalam bidang perakitan komputer, perangkat lunak, dan jaringan komputer.', NULL, NULL, 'http://localhost:8000/storage/major-images/5nIwLANvjySK63kMoUkyylnmYXWP035FLKdbSGfj.webp', 40, 40, 1, '2026-09-11 19:34:04', '2026-09-11 19:34:05');

-- --------------------------------------------------------

--
-- Struktur dari tabel `major_curricula`
--

CREATE TABLE `major_curricula` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `major_id` bigint(20) UNSIGNED NOT NULL,
  `class_name` varchar(150) NOT NULL,
  `color` varchar(20) NOT NULL DEFAULT 'navy',
  `description` text NOT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `major_curricula`
--

INSERT INTO `major_curricula` (`id`, `major_id`, `class_name`, `color`, `description`, `tags`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 2, 'Kelas 10 : RPL', 'navy', 'Komponen Utama: Berisi Kompetensi Inti (KI), Kompetensi Dasar (KD) atau Alur Tujuan Pembelajaran (ATP), materi pokok, kegiatan pembelajaran, serta sistem penilaian.Mata Pelajaran Produktif Utama:Pemrograman Dasar: Memahami algoritma, logika pemrograman, dan sintaks bahasa pemrograman dasar (seperti C++ atau Python).Sistem Komputer & Jaringan Dasar: Mengenal arsitektur komputer, komponen hardware, sistem operasi, dan troubleshooting dasar.Pemrograman Website: Konsep dasar HTML, CSS, dan pembuatan halaman web statis/dinamis tingkat dasar.Basis Data: Pengenalan konsep dasar SQL, DDL, DML, serta pengoperasian tabel relasional.', '[\"K3\",\"pratik\",\"prakerin\"]', 0, '2026-09-25 06:17:43', '2026-09-25 06:17:43'),
(4, 2, 'kelas  : 11', 'teal', 'Komponen Utama: Berisi Kompetensi Inti (KI), Kompetensi Dasar (KD) atau Alur Tujuan Pembelajaran (ATP), materi pokok, kegiatan pembelajaran, serta sistem penilaian.Mata Pelajaran Produktif Utama:Pemrograman Dasar: Memahami algoritma, logika pemrograman, dan sintaks bahasa pemrograman dasar (seperti C++ atau Python).Sistem Komputer & Jaringan Dasar: Mengenal arsitektur komputer, komponen hardware, sistem operasi, dan troubleshooting dasar.Pemrograman Website: Konsep dasar HTML, CSS, dan pembuatan halaman web statis/dinamis tingkat dasar.Basis Data: Pengenalan konsep dasar SQL, DDL, DML, serta pengoperasian tabel relasional.', '[\"k3\"]', 2, '2026-09-25 06:26:03', '2026-09-25 06:26:03'),
(6, 2, 'kelas 12', 'gold', 'jaslkhfdshif', '[\"k4\"]', 3, '2026-09-25 06:29:21', '2026-09-25 06:29:21');

-- --------------------------------------------------------

--
-- Struktur dari tabel `major_facilities`
--

CREATE TABLE `major_facilities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `major_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_08_20_000001_create_roles_table', 1),
(5, '2026_08_20_000002_create_permissions_table', 1),
(6, '2026_08_20_000003_create_role_permissions_table', 1),
(7, '2026_08_20_000004_create_user_roles_table', 1),
(8, '2026_08_20_000005_create_school_profiles_table', 1),
(9, '2026_08_20_000006_create_majors_table', 1),
(10, '2026_08_20_000007_create_students_table', 1),
(11, '2026_08_20_000008_create_login_attempts_table', 1),
(12, '2026_08_20_000009_create_activity_logs_table', 1),
(13, '2026_08_20_000010_create_file_metadata_table', 1),
(14, '2026_08_20_000011_create_chatbot_conversations_table', 1),
(15, '2026_08_20_000012_create_security_monitoring_table', 1),
(16, '2026_08_20_024050_create_personal_access_tokens_table', 1),
(17, '2026_08_24_000001_create_content_management_tables', 1),
(18, '2026_08_30_000001_create_news_table', 1),
(19, '2026_08_30_000002_create_major_facilities_table', 1),
(20, '2026_08_30_000003_create_ppdb_registrations_table', 1),
(21, '2026_08_30_000004_alter_school_profiles_and_majors', 1),
(22, '2026_08_30_000005_create_site_images_table', 2),
(23, '2026_08_30_153155_create_categories_table', 3),
(24, '2026_09_06_000001_create_ppdb_settings_table', 4),
(25, '2026_09_06_000002_add_documents_to_ppdb_registrations_table', 5),
(26, '2026_09_10_000001_add_options_to_products_table', 6),
(27, '2026_09_11_000001_add_profile_content_to_school_profiles_table', 7),
(28, '2026_09_11_000002_add_school_identity_fields', 7),
(29, '2026_09_12_000001_create_major_curricula_table', 7),
(30, '2026_09_12_000002_add_content_dates', 8),
(31, '2026_09_12_000001_add_detailed_page_content_to_school_profiles_table', 9),
(32, '2026_09_13_000001_ensure_ai_api_logs_table_exists', 9),
(33, '2026_09_13_000002_expand_ai_api_log_error_message', 9),
(34, '2026_09_15_000001_create_profile_menu_items_table', 9),
(35, '2026_09_15_000002_add_profile_site_images', 10),
(36, '2026_09_27_000001_create_staff_profiles_table', 11),
(37, '2026_09_27_000002_add_staff_profile_details', 12);

-- --------------------------------------------------------

--
-- Struktur dari tabel `news`
--

CREATE TABLE `news` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `excerpt` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `featured_image` varchar(255) DEFAULT NULL,
  `author_id` bigint(20) UNSIGNED DEFAULT NULL,
  `published` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `news`
--

INSERT INTO `news` (`id`, `title`, `slug`, `content`, `excerpt`, `category`, `featured_image`, `author_id`, `published`, `published_at`, `created_at`, `updated_at`) VALUES
(1, 'SMK Nurul Jadid Raih Juara Nasional LKS 2024', 'smk-nurul-jadid-raih-juara-nasional-lks-2024', 'SMK Nurul Jadid berhasil meraih juara pertama dalam Lomba Kompetensi Siswa (LKS) tingkat nasional tahun 2024 pada bidang Rekayasa Perangkat Lunak.', 'SMK Nurul Jadid berhasil meraih juara pertama dalam LKS tingkat nasional 2024.', 'Prestasi', NULL, NULL, 1, '2026-08-30 07:36:56', '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(2, 'Penerimaan Peserta Didik Baru (PPDB) Tahun Ajaran 2025/2026', 'ppdb-tahun-ajaran-2025-2026', 'SMK Nurul Jadid membuka pendaftaran peserta didik baru untuk tahun ajaran 2025/2026. Pendaftaran dibuka mulai 1 Januari 2025.', 'Pendaftaran PPDB tahun ajaran 2025/2026 dibuka mulai Januari 2025.', 'Pengumuman', NULL, NULL, 1, '2026-08-30 07:36:56', '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(3, 'Kunjungan Industri Siswa RPL ke Perusahaan IT Terkemuka', 'kunjungan-industri-siswa-rpl', 'Siswa jurusan Rekayasa Perangkat Lunak mengadakan kunjungan industri ke beberapa perusahaan IT terkemuka di Surabaya untuk menambah wawasan dunia kerja.', 'Siswa RPL melakukan kunjungan industri ke perusahaan IT di Surabaya.', 'Kegiatan', NULL, NULL, 1, '2026-08-30 07:36:56', '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(4, 'Perebutan Kursi Kekuasaan Parlemen Mulai Memanas Menjelang Pemilu Sela', 'perebutan-kursi-kekuasaan-parlemen-mulai-memanas-menjelang-pemilu-sela', 'Sejumlah partai besar yang sebelumnya tergabung dalam koalisi pemerintah mulai menunjukkan tanda-tanda keretakan, dipicu oleh perebutan pengaruh dan posisi strategis di jajaran parlemen. Fenomena ini memperlihatkan betapa dinamis dan cairnya perebutan kekuasaan di tingkat elit politik saat ini.Menurut para analis politik, pergeseran ini terjadi karena masing-masing kubu ingin mengamankan basis suara terbesar sebelum regulasi baru disahkan. Strategi komunikasi publik dan lobi-lobi di balik layar kini gencar dilakukan oleh para pemimpin partai guna menarik simpati partai papan tengah yang memegang peran kunci sebagai penentu arah koalisi.Di sisi lain, masyarakat sipil mulai menyuarakan kekhawatiran mereka. Banyak pihak menilai bahwa fokus para politisi saat ini terlalu berpusat pada konsolidasi kekuasaan internal dan melupakan agenda-agenda kebijakan publik yang jauh lebih mendesak. Jika ketegangan politik ini terus berlanjut tanpa adanya kompromi yang sehat, stabilitas pemerintahan di paruh kedua tahun ini diprediksi akan menghadapi tantangan berat.', 'Dinamika politik semakin intensif seiring dengan bergesernya peta koalisi partai besar demi mengamankan kekuasaan mayoritas di parlemen.\r\n', 'kekuasaan', 'http://localhost:8000/storage/news-images/XkDEHyJ08YdOdzxvayZJ8gI1yfpmZRscDY05IA5w.jpg', 2, 1, '2026-08-30 10:06:49', '2026-08-30 10:06:49', '2026-09-11 20:15:55'),
(5, 'Jangan Boros Uang', 'jangan-boros-uang', 'Biarlah masa muda itu kita lelaui dengan kesulitan nanti bakal ada kesempatan yang emas\r\n', 'Muda menabung  , Tua jadi Orang have', 'Keuangan', 'http://localhost:8000/storage/news-images/P9i6xslj4DR7WtPdWJmq0SNS5qHiRYhNPkSknYFA.png', 2, 1, '2026-08-31 07:03:30', '2026-08-31 07:03:30', '2026-09-11 20:04:03');

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `module` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `slug`, `description`, `module`, `created_at`, `updated_at`) VALUES
(1, 'View Dashboard', 'dashboard.view', 'Can view dashboard', 'dashboard', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(2, 'Manage Users', 'users.manage', 'Can create, edit, delete users', 'users', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(3, 'View Users', 'users.view', 'Can view user list', 'users', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(4, 'Manage Roles', 'roles.manage', 'Can manage roles and permissions', 'roles', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(5, 'Manage School Profile', 'school_profile.manage', 'Can manage school profile', 'school', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(6, 'Manage Students', 'students.manage', 'Can manage student data', 'students', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(7, 'View Students', 'students.view', 'Can view student list', 'students', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(8, 'Manage Majors', 'majors.manage', 'Can manage majors', 'academic', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(9, 'View Majors', 'majors.view', 'Can view majors', 'academic', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(10, 'Manage News', 'news.manage', 'Can create, edit, delete news', 'content', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(11, 'View News', 'news.view', 'Can view news list', 'content', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(12, 'Manage PPDB', 'ppdb.manage', 'Can manage PPDB applications', 'ppdb', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(13, 'View PPDB', 'ppdb.view', 'Can view PPDB applications', 'ppdb', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(14, 'Manage PKL', 'pkl.manage', 'Can manage PKL programs', 'pkl', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(15, 'View PKL', 'pkl.view', 'Can view PKL programs', 'pkl', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(16, 'Manage Job Vacancies', 'jobs.manage', 'Can manage job vacancies', 'bkk', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(17, 'View Job Vacancies', 'jobs.view', 'Can view job vacancies', 'bkk', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(18, 'Manage TEFA Store', 'tefa_store.manage', 'Can manage TEFA store products', 'tefa', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(19, 'View TEFA Store', 'tefa_store.view', 'Can view TEFA store products', 'tefa', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(20, 'Manage Settings', 'settings.manage', 'Can manage system settings', 'settings', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(21, 'View Reports', 'reports.view', 'Can view reports', 'reports', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(22, 'Export Reports', 'reports.export', 'Can export reports', 'reports', '2026-09-05 06:59:27', '2026-09-05 06:59:27');

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 2, 'auth_token', '5940d68ed794daf44415b407ed8687abe7bd455a9166dd77f8402bab421fd439', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-06T14:37:45.794020Z\"}', '2026-09-04 06:30:54', NULL, '2026-08-30 07:37:45', '2026-09-04 06:30:54'),
(2, 'App\\Models\\User', 4, 'auth_token', '99d4ce5088686377bbc9c5f97ef43c8ba5d599fda00018aae85f34c658d2e981', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-11T14:05:04.988537Z\"}', '2026-09-04 07:05:25', NULL, '2026-09-04 07:05:05', '2026-09-04 07:05:25'),
(3, 'App\\Models\\User', 3, 'auth_token', 'b56d6fa9027d0baa5ea7c52c74d05cf8782840907b308b4bb3b3fcc94e13cfb5', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-11T14:06:22.436894Z\"}', '2026-09-04 07:08:41', NULL, '2026-09-04 07:06:22', '2026-09-04 07:08:41'),
(4, 'App\\Models\\User', 1, 'auth_token', '7f4cc67167a857af4ffee314f96b17d4d98f1b1bd621682fb798a56729074462', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-11T14:09:47.713089Z\"}', '2026-09-04 07:29:13', NULL, '2026-09-04 07:09:47', '2026-09-04 07:29:13'),
(5, 'App\\Models\\User', 1, 'auth_token', 'ada690477b557c282a447da577db0db449ea2939054b7b8418a5f315e6bbeead', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-11T15:14:32.125040Z\"}', '2026-09-04 09:13:31', NULL, '2026-09-04 08:14:32', '2026-09-04 09:13:31'),
(6, 'App\\Models\\User', 2, 'auth_token', '84aaae25a2cb8883bf49a661f75a6ee7b795c7f4e73e1ad1c053fcdd786f8026', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-12T14:11:38.515577Z\"}', '2026-09-05 07:23:52', NULL, '2026-09-05 07:11:38', '2026-09-05 07:23:52'),
(7, 'App\\Models\\User', 3, 'auth_token', 'd5988bd82cb16880cad87be20c2275ec400f08fa439bc9333d0c57ed162d442e', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-13T12:48:33.005235Z\"}', '2026-09-06 06:13:51', NULL, '2026-09-06 05:48:33', '2026-09-06 06:13:51'),
(8, 'App\\Models\\User', 1, 'auth_token', '420d73edf5534b8660a1ff83466ac033bc11935f7e9d626ae3cc8e392a6b9f70', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-13T13:20:28.239343Z\"}', '2026-09-06 06:36:12', NULL, '2026-09-06 06:20:28', '2026-09-06 06:36:12'),
(9, 'App\\Models\\User', 2, 'auth_token', '5c5a88dd2cb18d7e59d495f67ded49f3ba635714f23ecc4a357de4fe3d79bd3c', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-17T01:21:11.055329Z\"}', '2026-09-09 19:12:30', NULL, '2026-09-09 18:21:11', '2026-09-09 19:12:30'),
(10, 'App\\Models\\User', 2, 'auth_token', '0789d81c45aceab46cdf504a8aa7b08a1b782c99312143fe55999dda20482670', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-19T02:26:20.964307Z\"}', '2026-09-11 19:26:53', NULL, '2026-09-11 19:26:20', '2026-09-11 19:26:53'),
(11, 'App\\Models\\User', 2, 'auth_token', '6a68eea814d64ec8db036c8d7ec8cb91456be9c448327405eb754481ef965f6e', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-19T02:32:19.008700Z\"}', '2026-09-11 20:27:52', NULL, '2026-09-11 19:32:19', '2026-09-11 20:27:52'),
(12, 'App\\Models\\User', 2, 'auth_token', '8fae2f3fbbbfb7de088c68bc59b60837623f161f67df85faf4543b3e1dc49355', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-19T03:29:11.322659Z\"}', '2026-09-11 20:31:41', NULL, '2026-09-11 20:29:11', '2026-09-11 20:31:41'),
(13, 'App\\Models\\User', 2, 'auth_token', '9c0bec97175c64159be6d0a7798c9499f3d0a8403ad9f5215ff82cd70a6f152f', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T02:40:39.793267Z\"}', '2026-09-14 21:09:50', NULL, '2026-09-14 19:40:39', '2026-09-14 21:09:50'),
(14, 'App\\Models\\User', 1, 'auth_token', '56dc55a8e982bee45fd9bce0b027c6dbadf46e4e0f930cd0d58fc05c28d7fc23', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T13:44:24.776331Z\"}', '2026-09-15 07:20:50', NULL, '2026-09-15 06:44:24', '2026-09-15 07:20:50'),
(15, 'App\\Models\\User', 1, 'auth_token', '4e404946f14d48a3c7950950a22d65de8f357a8aef1a69deac75890df053802e', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T14:24:29.725443Z\"}', '2026-09-15 07:24:59', NULL, '2026-09-15 07:24:29', '2026-09-15 07:24:59'),
(16, 'App\\Models\\User', 2, 'auth_token', '57ff1a1484e842dfd6a5c6946032e43d379b2873900ede58ad9aa92747272661', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T14:25:01.526415Z\"}', NULL, NULL, '2026-09-15 07:25:01', '2026-09-15 07:25:01'),
(17, 'App\\Models\\User', 1, 'auth_token', '5da3f96ced5acc6c752054140a7fd858dc4aea5536ae9e4cf9f8bc58ae2a92a0', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T14:25:06.129282Z\"}', '2026-09-15 07:42:37', NULL, '2026-09-15 07:25:06', '2026-09-15 07:42:37'),
(18, 'App\\Models\\User', 1, 'auth_token', '6f85659e7af13c664eb3d5d50e385b84299ac7b34eabf06d2069fd883e742a71', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T14:49:30.356531Z\"}', '2026-09-15 07:49:40', NULL, '2026-09-15 07:49:30', '2026-09-15 07:49:40'),
(19, 'App\\Models\\User', 3, 'auth_token', '9b4aeea56c716472aabf47613165b874f345864c072cbc6a5c7c4f984cb53b0f', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T15:03:39.304313Z\"}', '2026-09-15 08:28:49', NULL, '2026-09-15 08:03:39', '2026-09-15 08:28:49'),
(20, 'App\\Models\\User', 2, 'auth_token', 'a673c27a56d0788d4693cd4fb3a4bc074e6c276a166f5970c0908a521f70ae8c', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T15:29:00.542443Z\"}', '2026-09-15 08:47:09', NULL, '2026-09-15 08:29:00', '2026-09-15 08:47:09'),
(21, 'App\\Models\\User', 2, 'auth_token', '667c58e857bc7e524b7b4def71be562abdd2745ab1c8e573ea2821224f1c339a', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-22T15:47:48.330728Z\"}', '2026-09-15 09:17:51', NULL, '2026-09-15 08:47:48', '2026-09-15 09:17:51'),
(22, 'App\\Models\\User', 2, 'auth_token', 'd5e0a6e722679eba22130d073ebaf5610ad273094915907829521f60f9d999b3', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\",\"expires_at\":\"2026-09-23T13:22:49.806182Z\"}', '2026-09-16 06:26:26', NULL, '2026-09-16 06:22:49', '2026-09-16 06:26:26'),
(23, 'App\\Models\\User', 6, 'auth_token', '940841736d6218239a0022f2e41ecc0123e2c48cef6040c299c6157d5e0207dc', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-23T13:28:35.642437Z\"}', '2026-09-16 06:28:39', NULL, '2026-09-16 06:28:35', '2026-09-16 06:28:39'),
(24, 'App\\Models\\User', 2, 'auth_token', 'cf1d7d37299e03c65ecb7ae833288bf936e86ff2d16e4186f58169ef746b2d73', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/152.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-09-23T13:51:06.241946Z\"}', '2026-09-16 07:58:52', NULL, '2026-09-16 06:51:06', '2026-09-16 07:58:52'),
(25, 'App\\Models\\User', 2, 'auth_token', '5ca199d8f0a8976cc910d74598fc23d0097a49aa4ea30c32097071a8027f934a', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"PostmanRuntime\\/7.53.0\",\"expires_at\":\"2026-09-30T02:35:14.999273Z\"}', NULL, NULL, '2026-09-22 19:35:15', '2026-09-22 19:35:15'),
(26, 'App\\Models\\User', 2, 'auth_token', '35b9396cfe4bb9a682c53066fbc531a9a250e6ffee8a337c0d912806bda50cc6', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/153.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-10-01T03:59:14.647523Z\"}', '2026-09-23 21:10:22', NULL, '2026-09-23 20:59:14', '2026-09-23 21:10:22'),
(27, 'App\\Models\\User', 2, 'auth_token', 'c5944d47d304bec19744f2f479aa27af66cdcf59297a9484a4fb97ecf74b33f0', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/153.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-10-02T13:06:18.710863Z\"}', '2026-09-25 07:40:05', NULL, '2026-09-25 06:06:18', '2026-09-25 07:40:05'),
(28, 'App\\Models\\User', 2, 'auth_token', 'c47f6563dce8963e6c6e271f63a9ac93ce692a2ffd8d7feb2aa193769393a0d6', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/153.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-10-04T14:11:56.410137Z\"}', '2026-09-27 07:38:23', NULL, '2026-09-27 07:11:56', '2026-09-27 07:38:23'),
(29, 'App\\Models\\User', 2, 'auth_token', 'bb6f5e502b466c02d2f0840d9fbc13724d80167a920bbfd8c0243bbcf7cde0cd', '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/153.0.0.0 Safari\\/537.36\",\"expires_at\":\"2026-10-05T01:53:40.569280Z\"}', '2026-09-27 22:52:48', NULL, '2026-09-27 18:53:40', '2026-09-27 22:52:48');

-- --------------------------------------------------------

--
-- Struktur dari tabel `ppdb_registrations`
--

CREATE TABLE `ppdb_registrations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `no_pendaftaran` varchar(30) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `nisn` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `program` varchar(100) NOT NULL,
  `alamat` text DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `tempat_lahir` varchar(100) DEFAULT NULL,
  `asal_sekolah` varchar(200) DEFAULT NULL,
  `berkas_path` varchar(255) DEFAULT NULL,
  `berkas_url` varchar(255) DEFAULT NULL,
  `kk_path` varchar(255) DEFAULT NULL,
  `kk_url` varchar(255) DEFAULT NULL,
  `ktp_ayah_path` varchar(255) DEFAULT NULL,
  `ktp_ayah_url` varchar(255) DEFAULT NULL,
  `ktp_ibu_path` varchar(255) DEFAULT NULL,
  `ktp_ibu_url` varchar(255) DEFAULT NULL,
  `akta_kelahiran_path` varchar(255) DEFAULT NULL,
  `akta_kelahiran_url` varchar(255) DEFAULT NULL,
  `ijazah_menengah_path` varchar(255) DEFAULT NULL,
  `ijazah_menengah_url` varchar(255) DEFAULT NULL,
  `dokumen_lain_path` varchar(255) DEFAULT NULL,
  `dokumen_lain_url` varchar(255) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'pending',
  `catatan_admin` text DEFAULT NULL,
  `verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `jalur_pendaftaran` varchar(50) NOT NULL DEFAULT 'reguler',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `ppdb_registrations`
--

INSERT INTO `ppdb_registrations` (`id`, `no_pendaftaran`, `nama`, `nisn`, `email`, `phone`, `program`, `alamat`, `tanggal_lahir`, `tempat_lahir`, `asal_sekolah`, `berkas_path`, `berkas_url`, `kk_path`, `kk_url`, `ktp_ayah_path`, `ktp_ayah_url`, `ktp_ibu_path`, `ktp_ibu_url`, `akta_kelahiran_path`, `akta_kelahiran_url`, `ijazah_menengah_path`, `ijazah_menengah_url`, `dokumen_lain_path`, `dokumen_lain_url`, `status`, `catatan_admin`, `verified_by`, `verified_at`, `jalur_pendaftaran`, `created_at`, `updated_at`) VALUES
(1, 'PPDB-2026-000001', 'Nauval Azidan', 'Azidan', 'nauvalazidan@gmail.com', '087687567453', 'Teknik Otomotif', 'lumjang', NULL, NULL, NULL, 'ppdb-berkas/ibYLtCK21l3l6xbkyIj5AtfnwwmMLCImMJZIgUT1.jpg', '/storage/ppdb-berkas/ibYLtCK21l3l6xbkyIj5AtfnwwmMLCImMJZIgUT1.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'diterima', NULL, 1, '2026-09-04 07:28:38', 'reguler', '2026-08-30 07:55:51', '2026-09-04 07:28:38'),
(2, 'PPDB-2026-000002', 'Nauval Azidan', 'Azidan', 'nauvalazidan@gmail.com', '09809243043', 'Akuntansi dan Keuangan Lembaga', 'lumajang', NULL, NULL, NULL, NULL, NULL, 'ppdb-berkas/bgINHPE9F4JDWRcXKeG6YdwxcUJ5FA3g7sBGQKG9.png', '/storage/ppdb-berkas/bgINHPE9F4JDWRcXKeG6YdwxcUJ5FA3g7sBGQKG9.png', 'ppdb-berkas/BpayRgbddRCwmbHkOXY0XRrAUpX8wXfqk3hfIIy9.png', '/storage/ppdb-berkas/BpayRgbddRCwmbHkOXY0XRrAUpX8wXfqk3hfIIy9.png', 'ppdb-berkas/I63t3hWZeGnbbhRCpGTtLpOavZgDiUI2KTBcfzLF.png', '/storage/ppdb-berkas/I63t3hWZeGnbbhRCpGTtLpOavZgDiUI2KTBcfzLF.png', 'ppdb-berkas/wMV5jlr1LnkYTPcigbhkbeAcAyL4vATNUTG5cd3F.png', '/storage/ppdb-berkas/wMV5jlr1LnkYTPcigbhkbeAcAyL4vATNUTG5cd3F.png', 'ppdb-berkas/JGkoIqYUhegQugCrxbbL5IPGg6VPn8wZbEvDI36m.png', '/storage/ppdb-berkas/JGkoIqYUhegQugCrxbbL5IPGg6VPn8wZbEvDI36m.png', 'ppdb-berkas/ZGtpo54PzOpiB1EfgcdI9geEb97anx9W8fptr81o.png', '/storage/ppdb-berkas/ZGtpo54PzOpiB1EfgcdI9geEb97anx9W8fptr81o.png', 'pending', NULL, NULL, NULL, 'reguler', '2026-09-23 07:36:37', '2026-09-23 07:36:37'),
(3, 'PPDB-2026-000003', 'Nauval Azidan', 'Azidan', 'nauvalazidan@gmail.com', '087345345345', 'Rekayasa Perangkat Lunak', 'lumajang jambekumbu', NULL, NULL, NULL, NULL, NULL, 'ppdb-berkas/vhVuISivpVYJBuSNEGVZAZr4DALQUBJyr7PegVIQ.png', '/storage/ppdb-berkas/vhVuISivpVYJBuSNEGVZAZr4DALQUBJyr7PegVIQ.png', 'ppdb-berkas/HbCaEBaYcGKfG4Su8ogJBs3o7mthPstwnbHVt9Ne.png', '/storage/ppdb-berkas/HbCaEBaYcGKfG4Su8ogJBs3o7mthPstwnbHVt9Ne.png', 'ppdb-berkas/R5W97lkVNG035tq1zbBLnhYP323lzXRR7GSusUQW.png', '/storage/ppdb-berkas/R5W97lkVNG035tq1zbBLnhYP323lzXRR7GSusUQW.png', 'ppdb-berkas/PNB7b405tyh9bYYL7Ku7VKWPfTDOzv8kw0d7SnsS.png', '/storage/ppdb-berkas/PNB7b405tyh9bYYL7Ku7VKWPfTDOzv8kw0d7SnsS.png', 'ppdb-berkas/2tSiTX4m42pUhywlrb9Oxk61gKANcTjUoTNBtn4K.png', '/storage/ppdb-berkas/2tSiTX4m42pUhywlrb9Oxk61gKANcTjUoTNBtn4K.png', 'ppdb-berkas/3CCGMqJMDT93wCzPP05vTVmSOxtp4JCIu3pGIWoA.png', '/storage/ppdb-berkas/3CCGMqJMDT93wCzPP05vTVmSOxtp4JCIu3pGIWoA.png', 'pending', NULL, NULL, NULL, 'reguler', '2026-09-23 07:47:16', '2026-09-23 07:47:16');

-- --------------------------------------------------------

--
-- Struktur dari tabel `ppdb_settings`
--

CREATE TABLE `ppdb_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `registration_start` datetime DEFAULT NULL,
  `registration_end` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `ppdb_settings`
--

INSERT INTO `ppdb_settings` (`id`, `registration_start`, `registration_end`, `created_at`, `updated_at`) VALUES
(1, '2026-09-15 02:26:00', '2026-09-30 02:26:00', '2026-09-06 06:56:31', '2026-09-14 19:41:15');

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(220) NOT NULL,
  `sku` varchar(80) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `short_description` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `base_price` decimal(15,2) DEFAULT NULL,
  `compare_price` decimal(15,2) DEFAULT NULL,
  `stock` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `status` varchar(30) NOT NULL DEFAULT 'draft',
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`id`, `name`, `slug`, `sku`, `category`, `short_description`, `description`, `base_price`, `compare_price`, `stock`, `image`, `options`, `status`, `featured`, `created_at`, `updated_at`) VALUES
(1, 'Seragam Almamater SMK', 'seragam-almamater-smk', 'SERAGAM-001', 'Pakaian', 'Seragam almamater resmi sekolah.', 'eeq', 175000.00, NULL, 50, NULL, NULL, 'published', 1, '2026-09-05 06:59:30', '2026-09-09 18:35:36'),
(2, 'Jaket Kampus SMK', 'jaket-kampus-smk', 'JAKET-001', 'Pakaian', 'Jaket kampus dengan identitas sekolah.', 'Jaket berkualitas untuk siswa dan alumni.', 250000.00, NULL, 25, NULL, NULL, 'published', 1, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(3, 'Tumbler Nurul Jadid', 'tumbler-nurul-jadid', 'TUMBLER-001', 'Aksesori', 'Tumbler stainless steel logo sekolah.', 'Tumbler praktis untuk kegiatan sekolah dan harian.', 85000.00, NULL, 40, NULL, NULL, 'published', 0, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(4, 'jasa kocok alpukat', 'anjai', 'SKU-ILQ8U0AIO2', 'software', NULL, 'Jasa kocok alpukat (atau franchise/kemitraan minuman alpukat kocok) adalah peluang usaha kuliner yang menawarkan menu utama berupa buah alpukat segar yang dihancurkan secara kasar (dikocok), kemudian dipadukan dengan berbagai topping seperti susu kental manis, cokelat, keju, es krim, atau boba.\r\n', 5000000.00, NULL, 25, 'content/products/o4npWsh88yGZzJx06JYnPE1Gw3wBdqtetj9hqJKA.png', NULL, 'published', 0, '2026-09-09 18:41:49', '2026-09-09 18:41:49'),
(5, 'laptop', 'laptop', 'SKU-TANVDIAA5A', 'teknologi', NULL, 'huhahahhahahha', 25000000.00, NULL, 2, 'content/products/kPkuMtIT5oBGMaBQ3JQt6uqxYmzGY2vVnBUSCDj9.jpg', '[{\"name\":\"warna\",\"values\":[\"merah\",\"biru\",\"hitam\"]},{\"name\":\"ukuran\",\"values\":[\"S\",\"M\",\"L\",\"XL\",\"XLL\"]}]', 'published', 0, '2026-09-09 19:12:23', '2026-09-09 19:12:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `profile_menu_items`
--

CREATE TABLE `profile_menu_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `label` varchar(120) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `path` varchar(255) NOT NULL DEFAULT '/profil',
  `hash` varchar(120) DEFAULT NULL,
  `icon` varchar(40) NOT NULL DEFAULT 'school',
  `position` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `profile_menu_items`
--

INSERT INTO `profile_menu_items` (`id`, `label`, `description`, `path`, `hash`, `icon`, `position`, `is_active`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'SMK Nurul Jadid', 'Identitas dan perjalanan sekolah', '/profil', 'profil-sekolah', 'S', 1, 1, NULL, NULL, '2026-09-14 19:30:26', '2026-09-14 19:30:26'),
(2, 'Visi & Misi Sekolah', 'Arah dan nilai pendidikan', '/profil', 'visi-misi', 'V', 2, 1, NULL, NULL, '2026-09-14 19:30:26', '2026-09-14 19:30:26'),
(3, 'Kepala Sekolah', 'Sambutan dan kepemimpinan', '/profil', 'kepala-sekolah', 'K', 3, 1, NULL, NULL, '2026-09-14 19:30:26', '2026-09-14 19:30:26');

-- --------------------------------------------------------

--
-- Struktur dari tabel `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 'Super Administrator - Full access', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(2, 'admin_sekolah', 'Admin Sekolah - School management', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(3, 'tu_sekolah', 'Tata Usaha Sekolah - Administration', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(4, 'guru', 'Guru - Teacher', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(5, 'siswa', 'Siswa - Student', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(6, 'ppdb', 'Admin PPDB - PPDB management', '2026-09-05 06:59:27', '2026-09-05 06:59:27'),
(7, 'bkk', 'Admin BKK - Career center', '2026-09-05 06:59:27', '2026-09-05 06:59:27');

-- --------------------------------------------------------

--
-- Struktur dari tabel `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(2, 1),
(2, 2),
(2, 3),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 21),
(2, 22),
(3, 1),
(3, 6),
(3, 7),
(3, 21),
(4, 1),
(4, 7),
(4, 21),
(5, 1),
(6, 1),
(6, 7),
(6, 12),
(6, 13),
(7, 1),
(7, 14),
(7, 15),
(7, 16),
(7, 17);

-- --------------------------------------------------------

--
-- Struktur dari tabel `school_profiles`
--

CREATE TABLE `school_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `school_name` varchar(200) NOT NULL,
  `profile_title_line1` varchar(255) DEFAULT NULL,
  `profile_title_line2` varchar(255) DEFAULT NULL,
  `profile_description` text DEFAULT NULL,
  `profile_page_title` varchar(255) DEFAULT NULL,
  `profile_page_content` text DEFAULT NULL,
  `vision_page_intro` text DEFAULT NULL,
  `vision_page_content` text DEFAULT NULL,
  `mission_page_content` text DEFAULT NULL,
  `npsn` varchar(20) DEFAULT NULL,
  `nsm` varchar(30) DEFAULT NULL,
  `npwp` varchar(30) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `village` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `vision` text DEFAULT NULL,
  `mission` text DEFAULT NULL,
  `history` text DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `logo_path` varchar(255) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `youtube` varchar(255) DEFAULT NULL,
  `twitter` varchar(255) DEFAULT NULL,
  `tiktok` varchar(255) DEFAULT NULL,
  `headmaster_name` varchar(255) DEFAULT NULL,
  `headmaster_photo` varchar(255) DEFAULT NULL,
  `headmaster_message` text DEFAULT NULL,
  `founded_year` smallint(5) UNSIGNED DEFAULT NULL,
  `operating_year` smallint(5) UNSIGNED DEFAULT NULL,
  `foundation_name` varchar(255) DEFAULT NULL,
  `accreditation` varchar(10) DEFAULT NULL,
  `student_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `teacher_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `school_profiles`
--

INSERT INTO `school_profiles` (`id`, `school_name`, `profile_title_line1`, `profile_title_line2`, `profile_description`, `profile_page_title`, `profile_page_content`, `vision_page_intro`, `vision_page_content`, `mission_page_content`, `npsn`, `nsm`, `npwp`, `address`, `village`, `district`, `city`, `phone`, `email`, `website`, `vision`, `mission`, `history`, `logo`, `logo_path`, `facebook`, `instagram`, `youtube`, `twitter`, `tiktok`, `headmaster_name`, `headmaster_photo`, `headmaster_message`, `founded_year`, `operating_year`, `foundation_name`, `accreditation`, `student_count`, `teacher_count`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'SMK Nurul Jadid (SMKNJ)', NULL, NULL, NULL, NULL, NULL, 'hay hayyyyyyyyyy', 'juancok koeee', 'matanee ikuuuu', '20553240', '322052022001', '01.915.650.4-625.005', 'PO BOX.1 Ponpes Nurul Jadid Paiton Probolinggo 67291', 'Karanganyar', 'Paiton', 'Probolinggo - Jawa Timur', '+62-822-6468-2385', 'smknurja.paiton@gmail.com', 'www.smknj.sch.id', 'Menjadi sekolah unggulan yang menghasilkan lulusan berkompeten, berakhlak mulia, dan mampu bersaing di era global.', '1. Menyelenggarakan pendidikan yang berkualitas. 2. Mengembangkan potensi siswa secara optimal. 3. Membangun karakter yang berakhlak mulia.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2005, 2008, 'Yayasan Nurul Jadid', 'B (90)', 0, 0, 1, '2026-08-30 07:36:53', '2026-09-23 21:10:22');

-- --------------------------------------------------------

--
-- Struktur dari tabel `security_alerts`
--

CREATE TABLE `security_alerts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `alert_type` varchar(50) NOT NULL,
  `severity` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `ip_address` varchar(45) NOT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `endpoint` varchar(255) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `request_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`request_data`)),
  `is_resolved` tinyint(1) NOT NULL DEFAULT 0,
  `resolution_notes` varchar(255) DEFAULT NULL,
  `resolved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `security_configurations`
--

CREATE TABLE `security_configurations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `config_key` varchar(100) NOT NULL,
  `config_value` text NOT NULL,
  `data_type` varchar(20) NOT NULL DEFAULT 'string',
  `category` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `security_configurations`
--

INSERT INTO `security_configurations` (`id`, `config_key`, `config_value`, `data_type`, `category`, `description`, `is_active`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'max_login_attempts', '5', 'integer', 'authentication', 'Maximum number of failed login attempts before account lock', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(2, 'account_lockout_minutes', '15', 'integer', 'authentication', 'Number of minutes to lock account after too many failed attempts', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(3, 'password_min_length', '8', 'integer', 'authentication', 'Minimum password length', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(4, 'password_expiry_days', '90', 'integer', 'authentication', 'Number of days before password expires', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(5, 'api_rate_limit_per_minute', '60', 'integer', 'rate_limiting', 'Maximum API requests per minute per IP', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(6, 'enable_two_factor_auth', 'false', 'boolean', 'authentication', 'Enable two-factor authentication for all users', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(7, 'session_timeout_minutes', '120', 'integer', 'authentication', 'Session timeout in minutes', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56'),
(8, 'enable_login_notifications', 'true', 'boolean', 'logging', 'Send email notifications for successful logins from new devices', 1, NULL, '2026-08-30 07:36:56', '2026-08-30 07:36:56');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('09m264R6lbuWL0tEfjETnA5Fffp04GHfeh3b7Uvd', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia0M5UnEyYW13YllLT3ZWbTNwZGdpZmg1cnNiSk0zTEttQ3VjMGg2YSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvc2l0ZS1pbWFnZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616587),
('e8sKwiyaQG4EEBV7VJ2HMc5b6oPIwzglOpslo7so', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicFF2cG45UFB5cjl3d0NTWDdGVlhrZ3Y5ZkFqQjBvTmFqeHh0b2t1OSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616472),
('FtTVDsNCnUVfmTFCcDbWYfXT14TQtOaPtMKo4EDR', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3hxQlhMU1AwcU9aZXgxaVhIcm9GWWNhc1pPZlJHNHBvNDlqZXlCRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvbWFqb3JzIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1788616447),
('IilMQFohJcdHxYu6RMU58j4fGoCfqcfNPxBlBFPx', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR2s5Y1BVRXc4YmVFZmU0YVljcGNjWEJZb29HZ3pwTEhsUDZtOUw5VCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvbmV3cz9wYWdlPTEmcGVyX3BhZ2U9NCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616586),
('ImrX68Qrdahmh1C4jK82Z70IMPGpNJbGCCirwa6X', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUWpaSVdFakpiSFlXOGRVZFJsengyWHpJcFRkc2ZDanhFV1RRNUlPaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvY29udGVudC9nYWxsZXJpZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788617027),
('JsMeJJm2K9btnj3A5bldZgOm3bWd4cQMsadzPuoh', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiamJLdmxFRUE3TWhxZTZGSnROenJEU3BBajgyMVhjcnRwVUZNZzFFTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvc2l0ZS1pbWFnZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788617352),
('maD6dINox8HTL9Y5fvpSWAKzUBgD1ZZqVQ5vRMRJ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiMVBUUkRUY0tEOUhiOXpBY3MwOFgyNHdaTTJOOWhSNXJmNVV0aFpPaSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616482),
('mfDClghul8ZTTAXULoAd5NBe374NGigk5qrwgjIT', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidGE1SmQ5aEJxWGtRbkE5bDZtMDZMRjBFbk1hUzU2d2QxQjJBSUhMciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvbmV3cz9wYWdlPTEmcGVyX3BhZ2U9NCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616433),
('nECgJ7pL9qUWId5Xe5n75TYMEad2EDrKRPHXJAf5', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidUNXNmNqQnJPVzZOYVJ6RlgwczdvUG5tanlpOVdjUGVYRlJxMWtnWCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616477),
('nlXypSf82q2kayofB50f0VS532ZR0Lrcmd6ahktd', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQ1ZENUhFU3FLbGdraFpwTEYyV0xMbmpNbU5SaU0wWlJPSDJ3dTg0ZyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616596),
('piUcBlP0vKwVOO9LMbrsu04pcjzC3kuEtzowrrY1', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidlJ5OGhYMkd1c29YRHdudGJQNXFhRlBZa2Z1am9EM0YyTkVyMDVNcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvc2l0ZS1pbWFnZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616432),
('RPFcNoDGgGj9RVoqJ6pHCpifB5zmQg0wpHqSQ0C6', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiU281V1BnQ1c4MHpVTnZRb0tVYXJSeWE5aVJ6THVyMmIza0tVZkVtdyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616537),
('sx9Kl1ceCsFn9NqzC070EsAnfcfRrW7VsEhTxrnV', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVDlDZDF4eXo0ajFKa3hKTEFWd0hOem9CaDZVUmpYdzFRSjh5a0k3ZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvbWFqb3JzIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1788616444),
('v5m7A457lFVFL1ldPBDR9sMlEPsnZEYXGzUioxwJ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicnF1bGFVY3NkT3pEMlA4Rm0yYWs0bEdWVXQ4cDJhT1hob2U0UGxkYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvc2l0ZS1pbWFnZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616434),
('VL92ztVyjONyKzLWCWSRttXmReZkhvYznNepIap7', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUWZRRUsxcFpsOGRjNEplOTBzYUZRWncwS3BjNFJPZGdXSXd3dFpNbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvY29udGVudC9nYWxsZXJpZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616587),
('vPiwbZCwVDqOHZaKkfzBkWqRpVeuqLu1D9HaeyC3', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMkxiMTEzbFZVTjVPRDI2UWFTRGROeU9JUk1zaWI1MVdOdjd4NnhmZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvY29udGVudC9hY2hpZXZlbWVudHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616445),
('vPlkFwN55XXyB87IjGsowcptc9LVA4OfH4Ah7bKN', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic1ZvTldoWktldnJwczFqNWZXd0lJd3pOQmo3cE5XYW1BSVhpTXd5YiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvc2l0ZS1pbWFnZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616585),
('vtFWndz7hBjjwOy9iliTdPF31rpfiCkVGejO3jzb', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV0tVSGxCa3JvbDJYY3g3OUtaWVlibFJlcGJmNlhIdmo2YUNKUHZNWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvc2l0ZS1pbWFnZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788617028),
('Vxld1f6NQen5ImYkueBMKWscDo55tPlSj82ULGPn', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicVFqcmNLbTlQalhTMXIzck1mMGV2QWlIZjdWUUZRbFZRMlhSd0l5OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvbmV3cz9wYWdlPTEmcGVyX3BhZ2U9NCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788617026),
('whm7yJICJhrOLxfdLNA3wi4wWCt53XuPOX4xM2hC', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibm53TGhKMnJJZDY3TWQzNmtWU3JITXI2aHNBTkpDWG9UaU95dmQ4aSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvc2l0ZS1pbWFnZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788617026),
('WnFZVtp8HGi0WyBqDZB4Jw9QVcXQ8UG1zzjL9fRJ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiY1ltQjRNdnRuMUxhV2xKS2RtMjFlWUo1TkNtT3BDaThiT0NNVDJQRSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1788616466),
('wyusLYUPhm2nTRWqbNJWDSRBtDX0Uk7AsVziUJwi', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibEd3UXJVZUlpdjJ2emlYTEpqREZYQ3h3RFFKNjdxVUpaeThvMHhpNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvY29udGVudC9nYWxsZXJpZXMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616434),
('ZFdSynLeS0hiDHyFWnX9Y8PkJm56QoB1IQkDDJQW', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOFNEZzFHZG9VWUpLeWdNemE4d0dPZGJjdlVVWm5mQjhFZUo0Mm45QSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hcGkvY29udGVudC9hY2hpZXZlbWVudHMiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1788616451);

-- --------------------------------------------------------

--
-- Struktur dari tabel `site_images`
--

CREATE TABLE `site_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(255) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `section` varchar(50) NOT NULL,
  `position` int(11) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  `mime_type` varchar(255) DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `site_images`
--

INSERT INTO `site_images` (`id`, `key`, `title`, `description`, `image_path`, `image_url`, `alt_text`, `section`, `position`, `is_active`, `width`, `height`, `file_size`, `mime_type`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(26, 'hero_banner', 'Banner Utama Homepage', 'Banner besar di halaman utama', 'site-images/hero-banner.jpg', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&q=80', 'SMK Nurul Jadid Hero Banner', 'homepage', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(27, 'hero_banner_mobile', 'Banner Utama Mobile', 'Banner untuk tampilan mobile', 'site-images/hero-banner-mobile.jpg', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600&q=80', 'SMK Mobile Banner', 'homepage', 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(28, 'about_image', 'Gambar Tentang Sekolah', 'Gambar untuk section About Us', 'site-images/about-school.jpg', 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=800&q=80', 'Tentang SMK Nurul Jadid', 'about', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(29, 'headmaster_photo', 'Foto Kepala Sekolah', 'Foto resmi kepala sekolah', 'site-images/about/1790347205_8gKD2Plgy99yqSIg.webp', '/storage/site-images/about/1790347205_8gKD2Plgy99yqSIg.webp', 'Kepala Sekolah SMK', 'about', 2, 1, 1438, 1386, 131610, 'image/webp', NULL, 2, '2026-09-05 06:59:30', '2026-09-25 07:40:05'),
(30, 'facility_lab_komputer', 'Lab Komputer', 'Foto laboratorium komputer', 'site-images/facilities/lab-komputer.jpg', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80', 'Lab Komputer', 'facilities', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(31, 'facility_lab_otomotif', 'Lab Otomotif', 'Foto laboratorium otomotif', 'site-images/facilities/lab-otomotif.jpg', 'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=800&q=80', 'Lab Otomotif', 'facilities', 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(32, 'facility_perpustakaan', 'Perpustakaan', 'Foto perpustakaan sekolah', 'site-images/facilities/perpustakaan.jpg', 'https://images.unsplash.com/photo-1507842217122-3f45c7f39214?w=800&q=80', 'Perpustakaan SMK', 'facilities', 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(33, 'slider_1', 'Slider Homepage 1', 'Gambar slider pertama', 'site-images/sliders/slider-1.jpg', 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=1920&q=80', 'Kegiatan Siswa 1', 'homepage_slider', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30'),
(34, 'slider_2', 'Slider Homepage 2', 'Gambar slider kedua', 'site-images/sliders/slider-2.jpg', 'https://images.unsplash.com/photo-1537995882-c42d960eaf6c?w=1920&q=80', 'Kegiatan Siswa 2', 'homepage_slider', 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:31', '2026-09-05 06:59:31'),
(35, 'slider_3', 'Slider Homepage 3', 'Gambar slider ketiga', 'site-images/sliders/slider-3.jpg', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&q=80', 'Kegiatan Siswa 3', 'homepage_slider', 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:31', '2026-09-05 06:59:31'),
(36, 'ppdb_banner', 'Banner PPDB', 'Banner untuk halaman PPDB', 'site-images/ppdb-banner.jpg', 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=1920&q=80', 'PPDB Banner', 'ppdb', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:31', '2026-09-05 06:59:31'),
(37, 'contact_map', 'Peta Lokasi Sekolah', 'Gambar peta atau foto lokasi', 'site-images/contact-map.jpg', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80', 'Lokasi SMK', 'contact', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-05 06:59:31', '2026-09-05 06:59:31'),
(38, 'vision_image', 'Gambar Visi Sekolah', 'Gambar untuk bagian visi sekolah', 'site-images/profile/vision.jpg', 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=1000&q=80', 'Visi SMK Nurul Jadid', 'profile', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-14 21:21:17', '2026-09-14 21:21:17'),
(39, 'mission_image', 'Gambar Misi Sekolah', 'Gambar untuk bagian misi sekolah', 'site-images/profile/mission.jpg', 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=1000&q=80', 'Misi SMK Nurul Jadid', 'profile', 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-14 21:21:17', '2026-09-14 21:21:17');

-- --------------------------------------------------------

--
-- Struktur dari tabel `staff_profiles`
--

CREATE TABLE `staff_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `staff_role` varchar(150) NOT NULL,
  `staff_group` varchar(40) NOT NULL,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `current_position` varchar(255) DEFAULT NULL,
  `expertise` text DEFAULT NULL,
  `education` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`education`)),
  `additional_roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional_roles`)),
  `professional_experience` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`professional_experience`)),
  `publications` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`publications`)),
  `awards` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`awards`)),
  `motto` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `staff_profiles`
--

INSERT INTO `staff_profiles` (`id`, `name`, `slug`, `staff_role`, `staff_group`, `sort_order`, `description`, `image`, `status`, `created_at`, `updated_at`, `current_position`, `expertise`, `education`, `additional_roles`, `professional_experience`, `publications`, `awards`, `motto`) VALUES
(1, 'Rahmat hidayatullah ', 'rahmat-hidayatullah', 'Waka Kurikulum', 'leadership', 1, 'Rahmat Hidayatullah adalah seorang pendidik profesional yang berdedikasi tinggi di SMK Nurul Jadid. Sebagai Wakil Kepala Sekolah Bidang Kurikulum, beliau bertanggung jawab penuh atas pengembangan dan implementasi kurikulum merdeka berbasis industri di sekolah. Selain aktif mengajar mata pelajaran produktif Rekayasa Perangkat Lunak (RPL), beliau juga rutin membagikan ilmunya sebagai instruktur nasional dan asesor kompetensi. Dengan latar belakang magister teknologi pendidikan, Rahmat selalu berinovasi dalam mengintegrasikan teknologi terbaru ke dalam ruang kelas demi mencetak lulusan SMK yang siap kerja dan berdaya saing global.', 'content/staff_profiles/J6x1lLYhugG1KXAHMEwCtsXxgmc5d0R4rnXk1MdV.jpg', 'published', '2026-09-27 07:38:22', '2026-09-27 22:52:47', 'Guru Tetap di SMK Nurul Jadid', 'Rekayasa Perangkat Lunak, Pemrograman Web, Basis Data', '[\"S1 - Teknik Informatika, Universitas Dian Nuswantoro (2012–2016)S2 - Magister Teknologi Pendidikan, Universitas Negeri Malang (2018–2020)\"]', '[\"Wali Kelas X RPL 1\",\"Pembina Ekstrakurikuler Coding Club\"]', '[\"Instruktur Nasional Program SMK Pusat Keunggulan (2024)\",\"Asesor Kompetensi Keahlian (LSP-P1 SMK Nurul Jadid)\",\"Anggota Ikatan Guru Indonesia (IGI) Wilayah Jawa Timur\"]', '[\"Buku: Langkah Praktis Menjadi Web Developer Pemula (Erlangga, 2023)\",\"Modul: Pembelajaran Basis Data Berbasis Proyek untuk SMK (2024)\",\"Jurnal: Penerapan Metode Blended Learning untuk Meningkatkan Kemampuan Coding Siswa SMK (2022)\"]', '[\"Juara 1 Guru Berprestasi Tingkat Kabupaten (2023)\",\"Penerima Penghargaan Satyalancana Karya Satya X Tahun\"]', '\"Mengajar bukan sekadar mentransfer ilmu, tetapi menyalakan api rasa ingin tahu siswa untuk terus belajar sepanjang hayat.\"'),
(2, 'Ahmad Fauzi, M.Pd.', 'headmaster-ahmad-fauzi-mpd', 'Kepala Sekolah', 'headmaster', 1, 'Memimpin pengembangan pendidikan dan budaya sekolah yang berkarakter, kolaboratif, serta berorientasi pada kesiapan masa depan peserta didik.', 'https://randomuser.me/api/portraits/men/32.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Kepala Sekolah di SMK Nurul Jadid', 'Manajemen pendidikan dan pengembangan sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(3, 'Budi Santoso, M.Pd.', 'leadership-budi-santoso-mpd', 'Wakil Kepala Sekolah Bidang Kurikulum', 'leadership', 1, 'Wakil Kepala Sekolah Bidang Kurikulum yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Wakil Kepala Sekolah Bidang Kurikulum di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(4, 'Siti Aminah, S.Pd.', 'leadership-siti-aminah-spd', 'Wakil Kepala Sekolah Bidang Kesiswaan', 'leadership', 2, 'Wakil Kepala Sekolah Bidang Kesiswaan yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Wakil Kepala Sekolah Bidang Kesiswaan di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(5, 'Rizky Pratama, M.Pd.', 'leadership-rizky-pratama-mpd', 'Wakil Kepala Sekolah Bidang Sarana Prasarana', 'leadership', 3, 'Wakil Kepala Sekolah Bidang Sarana Prasarana yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Wakil Kepala Sekolah Bidang Sarana Prasarana di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(6, 'Dewi Lestari, S.Pd.', 'leadership-dewi-lestari-spd', 'Wakil Kepala Sekolah Bidang Humas', 'leadership', 4, 'Wakil Kepala Sekolah Bidang Humas yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Wakil Kepala Sekolah Bidang Humas di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(7, 'Agus Setiawan, S.Kom.', 'leadership-agus-setiawan-skom', 'Kepala Program Keahlian RPL', 'leadership', 5, 'Kepala Program Keahlian RPL yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Kepala Program Keahlian RPL di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(8, 'Nur Aini, M.Pd.', 'leadership-nur-aini-mpd', 'Kepala Program Keahlian TKRO', 'leadership', 6, 'Kepala Program Keahlian TKRO yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Kepala Program Keahlian TKRO di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(9, 'Hendra Wijaya, S.Pd.', 'leadership-hendra-wijaya-spd', 'Kepala Program Keahlian TBSM', 'leadership', 7, 'Kepala Program Keahlian TBSM yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Kepala Program Keahlian TBSM di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(10, 'Lina Marlina, S.Pd.', 'leadership-lina-marlina-spd', 'Kepala Program Keahlian AKL', 'leadership', 8, 'Kepala Program Keahlian AKL yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/2.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Kepala Program Keahlian AKL di SMK Nurul Jadid', 'Manajemen sekolah dan pengembangan program pendidikan', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(11, 'Fajar Hidayat, S.Kom.', 'productive-fajar-hidayat-skom', 'Guru Produktif Rekayasa Perangkat Lunak', 'productive', 1, 'Guru Produktif Rekayasa Perangkat Lunak yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Rekayasa Perangkat Lunak di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(12, 'Intan Permata, S.Ds.', 'productive-intan-permata-sds', 'Guru Produktif Desain Komunikasi Visual', 'productive', 2, 'Guru Produktif Desain Komunikasi Visual yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Desain Komunikasi Visual di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(13, 'Dimas Saputra, S.T.', 'productive-dimas-saputra-st', 'Guru Produktif Teknik Kendaraan Ringan', 'productive', 3, 'Guru Produktif Teknik Kendaraan Ringan yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Teknik Kendaraan Ringan di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(14, 'Rina Kurniawati, S.E.', 'productive-rina-kurniawati-se', 'Guru Produktif Akuntansi', 'productive', 4, 'Guru Produktif Akuntansi yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Akuntansi di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(15, 'Yoga Prabowo, S.T.', 'productive-yoga-prabowo-st', 'Guru Produktif Teknik Sepeda Motor', 'productive', 5, 'Guru Produktif Teknik Sepeda Motor yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Teknik Sepeda Motor di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(16, 'Maya Anggraini, S.Kom.', 'productive-maya-anggraini-skom', 'Guru Produktif Pemrograman Web', 'productive', 6, 'Guru Produktif Pemrograman Web yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Pemrograman Web di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(17, 'Andi Firmansyah, S.Pd.', 'productive-andi-firmansyah-spd', 'Guru Produktif Jaringan Komputer', 'productive', 7, 'Guru Produktif Jaringan Komputer yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Jaringan Komputer di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(18, 'Putri Rahmawati, S.Ds.', 'productive-putri-rahmawati-sds', 'Guru Produktif Multimedia', 'productive', 8, 'Guru Produktif Multimedia yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/10.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Produktif Multimedia di SMK Nurul Jadid', 'Pembelajaran praktik, proyek kejuruan, dan kemitraan industri', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(19, 'Sri Wahyuni, S.Pd.', 'class-subject-sri-wahyuni-spd', 'Guru Matematika dan Wali Kelas X', 'class_subject', 1, 'Guru Matematika dan Wali Kelas X yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Matematika dan Wali Kelas X di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(20, 'Muhammad Irfan, S.Pd.', 'class-subject-muhammad-irfan-spd', 'Guru Bahasa Indonesia dan Wali Kelas XI', 'class_subject', 2, 'Guru Bahasa Indonesia dan Wali Kelas XI yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Bahasa Indonesia dan Wali Kelas XI di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(21, 'Yuliana Putri, S.Pd.', 'class-subject-yuliana-putri-spd', 'Guru Bahasa Inggris dan Wali Kelas XII', 'class_subject', 3, 'Guru Bahasa Inggris dan Wali Kelas XII yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Bahasa Inggris dan Wali Kelas XII di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(22, 'Rudi Hartono, S.Pd.', 'class-subject-rudi-hartono-spd', 'Guru Pendidikan Pancasila', 'class_subject', 4, 'Guru Pendidikan Pancasila yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Pendidikan Pancasila di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(23, 'Nadia Safitri, S.Pd.', 'class-subject-nadia-safitri-spd', 'Guru Sejarah Indonesia', 'class_subject', 5, 'Guru Sejarah Indonesia yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Sejarah Indonesia di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(24, 'Eko Purnomo, S.Pd.', 'class-subject-eko-purnomo-spd', 'Guru Pendidikan Jasmani', 'class_subject', 6, 'Guru Pendidikan Jasmani yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Pendidikan Jasmani di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(25, 'Laila Fitriani, S.Pd.', 'class-subject-laila-fitriani-spd', 'Guru Pendidikan Agama Islam', 'class_subject', 7, 'Guru Pendidikan Agama Islam yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Pendidikan Agama Islam di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(26, 'Deni Kurniawan, S.Pd.', 'class-subject-deni-kurniawan-spd', 'Guru Projek Kreatif dan Kewirausahaan', 'class_subject', 8, 'Guru Projek Kreatif dan Kewirausahaan yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/18.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Guru Projek Kreatif dan Kewirausahaan di SMK Nurul Jadid', 'Pembelajaran mata pelajaran umum dan pendampingan wali kelas', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(27, 'Hasan Basri', 'staff-hasan-basri', 'Kepala Tata Usaha', 'staff', 1, 'Kepala Tata Usaha yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Kepala Tata Usaha di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(28, 'Rina Oktaviani', 'staff-rina-oktaviani', 'Staf Administrasi Akademik', 'staff', 2, 'Staf Administrasi Akademik yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Staf Administrasi Akademik di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(29, 'Mulyono', 'staff-mulyono', 'Teknisi Laboratorium Komputer', 'staff', 3, 'Teknisi Laboratorium Komputer yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Teknisi Laboratorium Komputer di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(30, 'Fitri Handayani', 'staff-fitri-handayani', 'Pustakawan', 'staff', 4, 'Pustakawan yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Pustakawan di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(31, 'Imam Syafii', 'staff-imam-syafii', 'Teknisi Bengkel Otomotif', 'staff', 5, 'Teknisi Bengkel Otomotif yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Teknisi Bengkel Otomotif di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(32, 'Ratna Sari', 'staff-ratna-sari', 'Staf Keuangan', 'staff', 6, 'Staf Keuangan yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Staf Keuangan di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(33, 'Slamet Riyadi', 'staff-slamet-riyadi', 'Petugas Layanan Sekolah', 'staff', 7, 'Petugas Layanan Sekolah yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/men/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Petugas Layanan Sekolah di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.'),
(34, 'Novi Wulandari', 'staff-novi-wulandari', 'Pengelola Sarana Prasarana', 'staff', 8, 'Pengelola Sarana Prasarana yang mendampingi kegiatan belajar dan pengembangan kompetensi peserta didik di SMK Nurul Jadid.', 'https://randomuser.me/api/portraits/women/26.jpg', 'published', '2026-09-27 22:23:12', '2026-09-27 22:23:12', 'Pengelola Sarana Prasarana di SMK Nurul Jadid', 'Layanan administrasi, operasional, dan fasilitas sekolah', '[\"Pendidikan sesuai bidang keahlian\",\"Pengembangan kompetensi profesional berkelanjutan\"]', '[\"Pendampingan kegiatan dan pengembangan peserta didik\"]', '[\"Pengalaman mengajar dan berkolaborasi di lingkungan pendidikan\"]', '[]', '[]', 'Terus belajar, bertumbuh, dan memberi manfaat.');

-- --------------------------------------------------------

--
-- Struktur dari tabel `students`
--

CREATE TABLE `students` (
  `id` bigint(20) UNSIGNED NOT NULL,
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
  `class` varchar(255) DEFAULT NULL,
  `school_year` varchar(9) DEFAULT NULL,
  `father_name` varchar(255) DEFAULT NULL,
  `father_phone` varchar(30) DEFAULT NULL,
  `mother_name` varchar(255) DEFAULT NULL,
  `mother_phone` varchar(30) DEFAULT NULL,
  `guardian_name` varchar(255) DEFAULT NULL,
  `guardian_phone` varchar(30) DEFAULT NULL,
  `medical_history` text DEFAULT NULL,
  `special_needs` text DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `students`
--

INSERT INTO `students` (`id`, `nisn`, `nis`, `name`, `major_id`, `gender`, `birth_place`, `birth_date`, `phone`, `email`, `address`, `status`, `class`, `school_year`, `father_name`, `father_phone`, `mother_name`, `mother_phone`, `guardian_name`, `guardian_phone`, `medical_history`, `special_needs`, `photo`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '1234567890', '20240001', 'saya', 2, 'Laki-laki', 'Probolinggo', '2008-05-15', '081234567890', 'ahmad@student.smknj.sch.id', 'Jl. Merdeka No. 123, Probolinggo', 'active', 'XII RPL 1', '2024/2025', 'Budi Santoso', '081234567891', 'Siti Rahayu', '081234567892', NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-02 07:05:33', NULL),
(2, '1234567891', '20240002', 'Sari Dewi', 4, 'Perempuan', 'Probolinggo', '2008-08-20', '081234567893', 'sari@student.smknj.sch.id', 'Jl. Pendidikan No. 45, Probolinggo', 'active', 'XII AKL 1', '2024/2025', 'Joko Widodo', '081234567894', 'Ani Yulianti', '081234567895', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, '1234567892', '20240003', 'Rizki Pratama', 1, 'Laki-laki', 'Probolinggo', '2008-03-10', '081234567896', 'rizki@student.smknj.sch.id', 'Jl. Industri No. 67, Probolinggo', 'active', 'XII TKRO 1', '2024/2025', 'Agus Supriyadi', '081234567897', 'Maya Indah', '081234567898', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `profile_photo` varchar(255) DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `login_attempts` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `two_factor_secret` text DEFAULT NULL,
  `two_factor_backup_codes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`two_factor_backup_codes`)),
  `last_password_change` timestamp NULL DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `phone`, `profile_photo`, `last_login_at`, `login_attempts`, `is_active`, `two_factor_enabled`, `two_factor_secret`, `two_factor_backup_codes`, `last_password_change`, `must_change_password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Super Administrator', 'superadmin@smknuruljadid.sch.id', NULL, '$2y$12$eMmg1xNAY0O6SXhhIh0ZM.RYyoOWYQW1s7VLgbTP3s9RbHl./Xf1O', '081234567890', NULL, '2026-09-15 07:49:30', 5, 0, 0, NULL, NULL, '2026-09-05 06:59:28', 0, NULL, '2026-09-05 06:59:28', '2026-09-15 08:28:53'),
(2, 'Admin Sekolah', 'admin@smknuruljadid.sch.id', NULL, '$2y$12$8jOi7HLDPMvyVLW8CJHQz.N1ML0qAicNvdjXKbfvyWZ8.S.6B0z5C', '081234567891', NULL, '2026-09-27 18:53:40', 0, 1, 0, NULL, NULL, '2026-09-05 06:59:28', 0, NULL, '2026-09-05 06:59:28', '2026-09-27 18:53:40'),
(3, 'Tata Usaha Sekolah', 'tu@smknuruljadid.sch.id', NULL, '$2y$12$lHps8.uurXRNYOkLMN.Js.NcP2gI9n0bGeVvTVvQIJXkr3mVzbMXa', '081234567892', NULL, '2026-09-15 08:03:39', 0, 1, 0, NULL, NULL, '2026-09-05 06:59:29', 0, NULL, '2026-09-05 06:59:29', '2026-09-15 08:03:39'),
(4, 'Guru Contoh', 'guru@smknuruljadid.sch.id', NULL, '$2y$12$ue.qgg0T5bOsYiGuOk6oTuxOdW92xTA57YtqE2GvyYTagBWjVbml.', '081234567893', NULL, '2026-09-05 06:59:29', 0, 1, 0, NULL, NULL, '2026-09-05 06:59:29', 0, NULL, '2026-09-05 06:59:29', '2026-09-05 06:59:29'),
(5, 'Admin PPDB', 'ppdb@smknuruljadid.sch.id', NULL, '$2y$12$YCYZk8.Zxnf4Ub.6/rkJ5ulJgH6uJKbXu0iKRNfFkZd4JojSnaJv.', '081234567894', NULL, '2026-09-05 06:59:29', 0, 1, 0, NULL, NULL, '2026-09-05 06:59:29', 0, NULL, '2026-09-05 06:59:29', '2026-09-05 06:59:29'),
(6, 'Admin BKK', 'bkk@smknuruljadid.sch.id', NULL, '$2y$12$XHW.tKTQZwGxvhDGzGhmHuGQhU5RtrAiS3B4i4z38u.5pqjFE83qW', '081234567895', NULL, '2026-09-16 06:28:35', 0, 1, 0, NULL, NULL, '2026-09-05 06:59:30', 0, NULL, '2026-09-05 06:59:30', '2026-09-16 06:28:35'),
(7, 'Ahmad Santoso', 'ahmad@student.smknj.sch.id', NULL, '$2y$12$qHTwcf1JMLSaavpsVQKSIObaPxXL0Y4DYXUpiMjfvoUyQG8QuEnjG', '081234567896', NULL, '2026-09-05 06:59:30', 0, 1, 0, NULL, NULL, '2026-09-05 06:59:30', 0, NULL, '2026-09-05 06:59:30', '2026-09-05 06:59:30');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, NULL),
(2, 2, NULL, NULL),
(3, 3, NULL, NULL),
(4, 4, NULL, NULL),
(5, 6, NULL, NULL),
(6, 7, NULL, NULL),
(7, 5, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `achievements_slug_unique` (`slug`);

--
-- Indeks untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity_logs_log_name_subject_type_subject_id_index` (`log_name`,`subject_type`,`subject_id`),
  ADD KEY `activity_logs_causer_type_causer_id_index` (`causer_type`,`causer_id`),
  ADD KEY `activity_logs_created_at_index` (`created_at`),
  ADD KEY `activity_logs_event_index` (`event`);

--
-- Indeks untuk tabel `ai_api_logs`
--
ALTER TABLE `ai_api_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ai_api_logs_api_provider_index` (`api_provider`),
  ADD KEY `ai_api_logs_endpoint_index` (`endpoint`),
  ADD KEY `ai_api_logs_user_id_index` (`user_id`),
  ADD KEY `ai_api_logs_created_at_index` (`created_at`),
  ADD KEY `ai_api_logs_status_code_index` (`status_code`);

--
-- Indeks untuk tabel `api_rate_limits`
--
ALTER TABLE `api_rate_limits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `api_rate_limits_api_key_index` (`api_key`),
  ADD KEY `api_rate_limits_ip_address_index` (`ip_address`),
  ADD KEY `api_rate_limits_endpoint_index` (`endpoint`),
  ADD KEY `api_rate_limits_window_start_index` (`window_start`),
  ADD KEY `api_rate_limits_window_end_index` (`window_end`),
  ADD KEY `api_rate_limits_is_blocked_index` (`is_blocked`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_type_unique` (`slug`,`type`);

--
-- Indeks untuk tabel `chatbot_conversations`
--
ALTER TABLE `chatbot_conversations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chatbot_conversations_session_id_unique` (`session_id`),
  ADD KEY `chatbot_conversations_session_id_index` (`session_id`),
  ADD KEY `chatbot_conversations_user_id_index` (`user_id`),
  ADD KEY `chatbot_conversations_context_index` (`context`),
  ADD KEY `chatbot_conversations_is_active_index` (`is_active`),
  ADD KEY `chatbot_conversations_last_activity_at_index` (`last_activity_at`);

--
-- Indeks untuk tabel `chatbot_knowledge_base`
--
ALTER TABLE `chatbot_knowledge_base`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chatbot_knowledge_base_created_by_foreign` (`created_by`),
  ADD KEY `chatbot_knowledge_base_updated_by_foreign` (`updated_by`),
  ADD KEY `chatbot_knowledge_base_category_index` (`category`),
  ADD KEY `chatbot_knowledge_base_question_index` (`question`),
  ADD KEY `chatbot_knowledge_base_is_active_index` (`is_active`),
  ADD KEY `chatbot_knowledge_base_priority_index` (`priority`);
ALTER TABLE `chatbot_knowledge_base` ADD FULLTEXT KEY `chatbot_knowledge_base_question_answer_fulltext` (`question`,`answer`);

--
-- Indeks untuk tabel `chatbot_messages`
--
ALTER TABLE `chatbot_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chatbot_messages_conversation_id_index` (`conversation_id`),
  ADD KEY `chatbot_messages_sender_index` (`sender`),
  ADD KEY `chatbot_messages_created_at_index` (`created_at`),
  ADD KEY `chatbot_messages_is_flagged_index` (`is_flagged`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `file_metadata`
--
ALTER TABLE `file_metadata`
  ADD PRIMARY KEY (`id`),
  ADD KEY `file_metadata_uploaded_by_foreign` (`uploaded_by`),
  ADD KEY `file_metadata_type_index` (`type`),
  ADD KEY `file_metadata_secure_name_index` (`secure_name`),
  ADD KEY `file_metadata_owner_type_index` (`owner_type`),
  ADD KEY `file_metadata_owner_type_owner_id_index` (`owner_type`,`owner_id`),
  ADD KEY `file_metadata_is_public_index` (`is_public`),
  ADD KEY `file_metadata_expires_at_index` (`expires_at`),
  ADD KEY `file_metadata_created_at_index` (`created_at`);

--
-- Indeks untuk tabel `galleries`
--
ALTER TABLE `galleries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `galleries_slug_unique` (`slug`);

--
-- Indeks untuk tabel `industry_partners`
--
ALTER TABLE `industry_partners`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `industry_partners_slug_unique` (`slug`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `job_vacancies`
--
ALTER TABLE `job_vacancies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `job_vacancies_slug_unique` (`slug`);

--
-- Indeks untuk tabel `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `login_attempts_email_index` (`email`),
  ADD KEY `login_attempts_ip_address_index` (`ip_address`),
  ADD KEY `login_attempts_created_at_index` (`created_at`),
  ADD KEY `login_attempts_email_created_at_index` (`email`,`created_at`);

--
-- Indeks untuk tabel `majors`
--
ALTER TABLE `majors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `majors_slug_unique` (`slug`);

--
-- Indeks untuk tabel `major_curricula`
--
ALTER TABLE `major_curricula`
  ADD PRIMARY KEY (`id`),
  ADD KEY `major_curricula_major_id_sort_order_index` (`major_id`,`sort_order`);

--
-- Indeks untuk tabel `major_facilities`
--
ALTER TABLE `major_facilities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `major_facilities_major_id_index` (`major_id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `news_slug_unique` (`slug`),
  ADD KEY `news_published_published_at_index` (`published`,`published_at`),
  ADD KEY `news_category_index` (`category`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_slug_unique` (`slug`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indeks untuk tabel `ppdb_registrations`
--
ALTER TABLE `ppdb_registrations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ppdb_registrations_no_pendaftaran_unique` (`no_pendaftaran`),
  ADD KEY `ppdb_registrations_status_index` (`status`),
  ADD KEY `ppdb_registrations_no_pendaftaran_index` (`no_pendaftaran`),
  ADD KEY `ppdb_registrations_nisn_index` (`nisn`),
  ADD KEY `ppdb_registrations_created_at_index` (`created_at`);

--
-- Indeks untuk tabel `ppdb_settings`
--
ALTER TABLE `ppdb_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_slug_unique` (`slug`),
  ADD UNIQUE KEY `products_sku_unique` (`sku`);

--
-- Indeks untuk tabel `profile_menu_items`
--
ALTER TABLE `profile_menu_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `profile_menu_items_created_by_foreign` (`created_by`),
  ADD KEY `profile_menu_items_updated_by_foreign` (`updated_by`);

--
-- Indeks untuk tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`);

--
-- Indeks untuk tabel `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `role_permissions_permission_id_foreign` (`permission_id`);

--
-- Indeks untuk tabel `school_profiles`
--
ALTER TABLE `school_profiles`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `security_alerts`
--
ALTER TABLE `security_alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `security_alerts_user_id_foreign` (`user_id`),
  ADD KEY `security_alerts_resolved_by_foreign` (`resolved_by`),
  ADD KEY `security_alerts_alert_type_index` (`alert_type`),
  ADD KEY `security_alerts_severity_index` (`severity`),
  ADD KEY `security_alerts_ip_address_index` (`ip_address`),
  ADD KEY `security_alerts_is_resolved_index` (`is_resolved`),
  ADD KEY `security_alerts_created_at_index` (`created_at`);

--
-- Indeks untuk tabel `security_configurations`
--
ALTER TABLE `security_configurations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `security_configurations_config_key_unique` (`config_key`),
  ADD KEY `security_configurations_updated_by_foreign` (`updated_by`),
  ADD KEY `security_configurations_config_key_index` (`config_key`),
  ADD KEY `security_configurations_category_index` (`category`),
  ADD KEY `security_configurations_is_active_index` (`is_active`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `site_images`
--
ALTER TABLE `site_images`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_images_key_unique` (`key`),
  ADD KEY `site_images_created_by_foreign` (`created_by`),
  ADD KEY `site_images_updated_by_foreign` (`updated_by`);

--
-- Indeks untuk tabel `staff_profiles`
--
ALTER TABLE `staff_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `staff_profiles_staff_group_sort_order_status_index` (`staff_group`,`sort_order`,`status`);

--
-- Indeks untuk tabel `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `students_nisn_unique` (`nisn`),
  ADD UNIQUE KEY `students_nis_unique` (`nis`),
  ADD KEY `students_major_id_status_index` (`major_id`,`status`),
  ADD KEY `students_school_year_class_index` (`school_year`,`class`),
  ADD KEY `students_status_index` (`status`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indeks untuk tabel `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `user_roles_role_id_foreign` (`role_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `achievements`
--
ALTER TABLE `achievements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `ai_api_logs`
--
ALTER TABLE `ai_api_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `api_rate_limits`
--
ALTER TABLE `api_rate_limits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `chatbot_conversations`
--
ALTER TABLE `chatbot_conversations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `chatbot_knowledge_base`
--
ALTER TABLE `chatbot_knowledge_base`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `chatbot_messages`
--
ALTER TABLE `chatbot_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `file_metadata`
--
ALTER TABLE `file_metadata`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `galleries`
--
ALTER TABLE `galleries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `industry_partners`
--
ALTER TABLE `industry_partners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `job_vacancies`
--
ALTER TABLE `job_vacancies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `majors`
--
ALTER TABLE `majors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `major_curricula`
--
ALTER TABLE `major_curricula`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `major_facilities`
--
ALTER TABLE `major_facilities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT untuk tabel `news`
--
ALTER TABLE `news`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT untuk tabel `ppdb_registrations`
--
ALTER TABLE `ppdb_registrations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `ppdb_settings`
--
ALTER TABLE `ppdb_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `profile_menu_items`
--
ALTER TABLE `profile_menu_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `school_profiles`
--
ALTER TABLE `school_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `security_alerts`
--
ALTER TABLE `security_alerts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `security_configurations`
--
ALTER TABLE `security_configurations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `site_images`
--
ALTER TABLE `site_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT untuk tabel `staff_profiles`
--
ALTER TABLE `staff_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT untuk tabel `students`
--
ALTER TABLE `students`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `ai_api_logs`
--
ALTER TABLE `ai_api_logs`
  ADD CONSTRAINT `ai_api_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `chatbot_conversations`
--
ALTER TABLE `chatbot_conversations`
  ADD CONSTRAINT `chatbot_conversations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `chatbot_knowledge_base`
--
ALTER TABLE `chatbot_knowledge_base`
  ADD CONSTRAINT `chatbot_knowledge_base_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `chatbot_knowledge_base_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `chatbot_messages`
--
ALTER TABLE `chatbot_messages`
  ADD CONSTRAINT `chatbot_messages_conversation_id_foreign` FOREIGN KEY (`conversation_id`) REFERENCES `chatbot_conversations` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `file_metadata`
--
ALTER TABLE `file_metadata`
  ADD CONSTRAINT `file_metadata_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `major_curricula`
--
ALTER TABLE `major_curricula`
  ADD CONSTRAINT `major_curricula_major_id_foreign` FOREIGN KEY (`major_id`) REFERENCES `majors` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `major_facilities`
--
ALTER TABLE `major_facilities`
  ADD CONSTRAINT `major_facilities_major_id_foreign` FOREIGN KEY (`major_id`) REFERENCES `majors` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `profile_menu_items`
--
ALTER TABLE `profile_menu_items`
  ADD CONSTRAINT `profile_menu_items_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `profile_menu_items_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `security_alerts`
--
ALTER TABLE `security_alerts`
  ADD CONSTRAINT `security_alerts_resolved_by_foreign` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `security_alerts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `security_configurations`
--
ALTER TABLE `security_configurations`
  ADD CONSTRAINT `security_configurations_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `site_images`
--
ALTER TABLE `site_images`
  ADD CONSTRAINT `site_images_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `site_images_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_major_id_foreign` FOREIGN KEY (`major_id`) REFERENCES `majors` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
