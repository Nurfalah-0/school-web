<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\SchoolController;
use App\Http\Controllers\Api\StudentController;
use App\Http\Controllers\Api\MajorController;
use App\Http\Controllers\Api\NewsController;
use App\Http\Controllers\Api\FileUploadController;
use App\Http\Controllers\Api\ChatbotController;
use App\Http\Controllers\Api\SecurityController;
use App\Http\Controllers\Api\SiteImageController;
use App\Http\Controllers\Api\ContentController;
use App\Http\Controllers\Api\PpdbController;
use App\Http\Controllers\Api\CategoryController;

// =============================================
//  AUTH — Publik
// =============================================
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);
    Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('/reset-password',  [AuthController::class, 'resetPassword']);
});

// =============================================
//  DATA PUBLIK SEKOLAH
// =============================================
Route::get('/school/profile', [SchoolController::class, 'getProfile']);
Route::get('/majors',         [MajorController::class, 'index']);
Route::get('/majors/{id}',    [MajorController::class, 'show']);

// Berita publik
Route::get('/news',      [NewsController::class, 'index']);
Route::get('/news/{id}', [NewsController::class, 'show']);

// Gambar website (publik)
Route::prefix('site-images')->group(function () {
    Route::get('/',                [SiteImageController::class, 'index']);
    Route::get('/section/{section}', [SiteImageController::class, 'getBySection']);
    Route::get('/key/{key}',       [SiteImageController::class, 'getByKey']);
    Route::get('/sections',        [SiteImageController::class, 'getSections']);
});

// Konten website publik (prestasi, galeri, mitra, dll)
Route::get('/content/{type}', [ContentController::class, 'index']);

// Kategori dinamis
Route::get('/categories', [CategoryController::class, 'index']);

// =============================================
//  PPDB — Publik (tidak perlu login)
// =============================================
Route::prefix('ppdb')->group(function () {
    // Kirim formulir pendaftaran
    Route::post('/apply', [PpdbController::class, 'apply']);
    // Cek status pendaftaran by nomor pendaftaran atau NISN
    Route::get('/status/{identifier}', [PpdbController::class, 'checkStatus']);
});

// =============================================
//  PROTECTED ROUTES (butuh token Sanctum)
// =============================================
Route::middleware('auth:sanctum')->group(function () {

    // ── Auth ──────────────────────────────────
    Route::prefix('auth')->group(function () {
        Route::post('/logout',        [AuthController::class, 'logout']);
        Route::get('/profile',        [AuthController::class, 'profile']);
        Route::put('/profile',        [AuthController::class, 'updateProfile']);
        Route::post('/refresh-token', [AuthController::class, 'refreshToken']);
        Route::get('/check-token',    [AuthController::class, 'checkToken']);
    });

    // ── Dashboard ─────────────────────────────
    Route::middleware(['permission:dashboard.view'])->prefix('dashboard')->group(function () {
        Route::get('/stats',    [SchoolController::class, 'getDashboardStats']);
        Route::get('/activity', [SchoolController::class, 'getRecentActivity']);
    });

    // ── Profil Sekolah (admin) ────────────────
    Route::middleware(['permission:school_profile.manage'])->prefix('admin/school')->group(function () {
        Route::put('/profile',      [SchoolController::class, 'updateProfile']);
        Route::post('/profile/logo', [SchoolController::class, 'uploadLogo']);
    });

    // ── Siswa — view ─────────────────────────
    Route::middleware(['permission:students.view'])->prefix('students')->group(function () {
        Route::get('/',       [StudentController::class, 'index']);
        Route::get('/{id}',   [StudentController::class, 'show']);
    });

    // ── Siswa — manage ───────────────────────
    Route::middleware(['permission:students.manage'])->prefix('admin/students')->group(function () {
        Route::post('/',               [StudentController::class, 'store']);
        Route::put('/{id}',            [StudentController::class, 'update']);
        Route::delete('/{id}',         [StudentController::class, 'destroy']);
        Route::get('/export',          [StudentController::class, 'export']);
        Route::post('/import',         [StudentController::class, 'import']);
    });

    // ── Jurusan — manage ─────────────────────
    Route::middleware(['permission:majors.manage'])->prefix('admin/majors')->group(function () {
        Route::post('/',                                  [MajorController::class, 'store']);
        Route::put('/{id}',                               [MajorController::class, 'update']);
        Route::delete('/{id}',                            [MajorController::class, 'destroy']);
        Route::post('/{id}/facilities',                   [MajorController::class, 'addFacility']);
        Route::delete('/{majorId}/facilities/{facilityId}', [MajorController::class, 'removeFacility']);
    });

    // ── Berita — manage ──────────────────────
    Route::middleware(['permission:news.manage'])->prefix('admin/news')->group(function () {
        Route::post('/',               [NewsController::class, 'store']);
        Route::put('/{id}',            [NewsController::class, 'update']);
        Route::delete('/{id}',         [NewsController::class, 'destroy']);
        Route::post('/{id}/publish',   [NewsController::class, 'publish']);
        Route::post('/{id}/unpublish', [NewsController::class, 'unpublish']);
    });

    // ── PPDB — admin ─────────────────────────
    Route::middleware(['role:superadmin,admin_sekolah,ppdb'])->prefix('ppdb')->group(function () {
        Route::get('/applications',              [PpdbController::class, 'index']);
        Route::get('/applications/{id}',         [PpdbController::class, 'show']);
        Route::post('/applications/{id}/approve',[PpdbController::class, 'approve']);
        Route::post('/applications/{id}/reject', [PpdbController::class, 'reject']);
        Route::delete('/applications/{id}',      [PpdbController::class, 'destroy']);
        Route::get('/statistics',                [PpdbController::class, 'statistics']);
    });

    // ── File Upload ───────────────────────────
    Route::prefix('files')->group(function () {
        Route::post('/upload',          [FileUploadController::class, 'upload']);
        Route::post('/upload-multiple', [FileUploadController::class, 'uploadMultiple']);
        Route::get('/list',             [FileUploadController::class, 'listFiles']);
        Route::get('/download/{path}',  [FileUploadController::class, 'downloadFile'])->where('path', '.*');
        Route::delete('/delete/{path}', [FileUploadController::class, 'deleteFile'])->where('path', '.*');

        Route::middleware(['role:superadmin,admin_sekolah'])->group(function () {
            Route::post('/cleanup', [FileUploadController::class, 'cleanupTemporaryFiles']);
        });
    });

    // ── Chatbot ───────────────────────────────
    Route::prefix('chatbot')->group(function () {
        Route::post('/start',                    [ChatbotController::class, 'startConversation']);
        Route::post('/{sessionId}/message',      [ChatbotController::class, 'sendMessage']);
        Route::get('/{sessionId}/history',       [ChatbotController::class, 'getConversationHistory']);
        Route::post('/{sessionId}/end',          [ChatbotController::class, 'endConversation']);
        Route::get('/kb/search',                 [ChatbotController::class, 'searchKnowledgeBase']);

        Route::middleware(['role:superadmin,admin_sekolah'])->group(function () {
            Route::get('/statistics', [ChatbotController::class, 'getStatistics']);
        });
    });

    // ── Security Monitoring ───────────────────
    Route::middleware(['role:superadmin,admin_sekolah'])->prefix('security')->group(function () {
        Route::get('/stats',                     [SecurityController::class, 'getSecurityStats']);
        Route::get('/alerts',                    [SecurityController::class, 'getAlerts']);
        Route::get('/alerts/{id}',               [SecurityController::class, 'getAlertDetails']);
        Route::post('/alerts/{id}/resolve',      [SecurityController::class, 'resolveAlert']);
        Route::get('/suspicious-activity',       [SecurityController::class, 'getSuspiciousActivityReport']);
        Route::get('/config',                    [SecurityController::class, 'getSecurityConfig']);
        Route::put('/config',                    [SecurityController::class, 'updateSecurityConfig']);
    });

    // ── Gambar Website (admin) ────────────────
    Route::middleware(['role:superadmin,admin_sekolah'])->prefix('admin/site-images')->group(function () {
        Route::post('/',              [SiteImageController::class, 'store']);
        Route::put('/{id}',           [SiteImageController::class, 'update']);
        Route::post('/{id}/upload',   [SiteImageController::class, 'uploadImage']);
        Route::delete('/{id}',        [SiteImageController::class, 'destroy']);
        Route::post('/positions',     [SiteImageController::class, 'updatePositions']);
        Route::get('/statistics',     [SiteImageController::class, 'getStatistics']);
    });

    // ── Konten Admin (prestasi, galeri, mitra, lowongan, produk TEFA) ──
    Route::middleware(['role:superadmin,admin_sekolah'])->prefix('admin/content')->group(function () {
        Route::get('/{type}',          [ContentController::class, 'index']);
        Route::post('/{type}',         [ContentController::class, 'store']);
        Route::put('/{type}/{id}',     [ContentController::class, 'update']);
        Route::delete('/{type}/{id}',  [ContentController::class, 'destroy']);
    });

    // ── Kategori Management (admin) ───────────
    Route::middleware(['role:superadmin,admin_sekolah'])->prefix('admin/categories')->group(function () {
        Route::post('/',              [CategoryController::class, 'store']);
        Route::put('/{category}',     [CategoryController::class, 'update']);
        Route::delete('/{category}',  [CategoryController::class, 'destroy']);
    });

    // ── User Management (superadmin) ─────────
    Route::middleware(['role:superadmin,admin_sekolah'])->prefix('admin')->group(function () {
        Route::get('/users',         [AuthController::class, 'getAllUsers']);
        Route::get('/users/{id}',    [AuthController::class, 'getUserById']);
        Route::post('/users',        [AuthController::class, 'createUser']);
        Route::put('/users/{id}',    [AuthController::class, 'updateUser']);
        Route::delete('/users/{id}', [AuthController::class, 'deleteUser']);
    });

    // ── TU Sekolah ────────────────────────────
    Route::middleware(['role:tu_sekolah'])->prefix('tu')->group(function () {
        Route::get('/documents',              [StudentController::class, 'getDocuments']);
        Route::post('/documents/verify/{id}', [StudentController::class, 'verifyDocument']);
    });

    // ── BKK ───────────────────────────────────
    Route::middleware(['role:bkk'])->prefix('bkk')->group(function () {
        Route::get('/job-vacancies',                  [StudentController::class, 'getJobVacancies']);
        Route::post('/job-vacancies/{id}/publish',    [StudentController::class, 'publishJobVacancy']);
    });
});
