<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use App\Helpers\SecurityHelper;
use Carbon\Carbon;

class FileUploadController extends Controller
{
    /**
     * Allowed file types untuk keamanan
     */
    private $allowedMimeTypes = [
        // Images
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/gif' => 'gif',
        'image/webp' => 'webp',
        'image/svg+xml' => 'svg',

        // Documents
        'application/pdf' => 'pdf',
        'application/msword' => 'doc',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'docx',
        'application/vnd.ms-excel' => 'xls',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'xlsx',
        'application/vnd.ms-powerpoint' => 'ppt',
        'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'pptx',

        // Archives
        'application/zip' => 'zip',
        'application/x-rar-compressed' => 'rar',
        'application/x-7z-compressed' => '7z',

        // Text
        'text/plain' => 'txt',
        'text/csv' => 'csv',
        'text/rtf' => 'rtf',
    ];

    /**
     * Max file sizes (dalam bytes)
     */
    private $maxSizes = [
        'image' => 5242880, // 5MB
        'document' => 10485760, // 10MB
        'archive' => 52428800, // 50MB
        'default' => 5242880, // 5MB
    ];

    /**
     * Upload single file
     */
    public function upload(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'file' => 'required|file',
            'type' => 'required|in:student_document,profile_photo,product_image,news_image,ppdb_document,pkl_document',
            'description' => 'sometimes|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $file = $request->file('file');
            $type = $request->type;
            $user = $request->user();

            // Validasi keamanan file
            $securityCheck = SecurityHelper::validateFileUpload($file, array_keys($this->allowedMimeTypes));

            if (!$securityCheck['valid']) {
                SecurityHelper::logSecurityEvent(
                    'file_upload_rejected',
                    'File upload rejected due to security issues: ' . implode(', ', $securityCheck['errors']),
                    $user->id
                );

                return response()->json([
                    'message' => 'File tidak aman untuk diupload',
                    'errors' => $securityCheck['errors']
                ], 422);
            }

            // Tentukan folder berdasarkan type
            $folder = $this->getFolderByType($type);

            // Generate secure filename
            $originalName = $file->getClientOriginalName();
            $secureFilename = SecurityHelper::generateSecureFilename($originalName);

            // Path final untuk storage
            $path = $file->storeAs($folder, $secureFilename, 'public');

            // Get file info
            $fileInfo = [
                'original_name' => $originalName,
                'secure_name' => $secureFilename,
                'mime_type' => $file->getMimeType(),
                'size' => $file->getSize(),
                'extension' => $file->getClientOriginalExtension(),
                'path' => $path,
                'url' => Storage::url($path),
                'type' => $type,
                'uploaded_by' => $user->id,
                'uploaded_at' => Carbon::now()->toDateTimeString(),
                'description' => $request->description,
            ];

            // Log aktivitas
            SecurityHelper::logSecurityEvent(
                'file_upload_success',
                'File berhasil diupload: ' . $originalName,
                $user->id
            );

            return response()->json([
                'message' => 'File berhasil diupload',
                'file' => $fileInfo,
            ], 201);

        } catch (\Exception $e) {
            Log::error('File upload error: ' . $e->getMessage(), [
                'user_id' => $user->id ?? null,
                'file_type' => $type ?? null,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengupload file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Upload multiple files
     */
    public function uploadMultiple(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'files' => 'required|array|min:1|max:10',
            'files.*' => 'file',
            'type' => 'required|in:student_document,profile_photo,product_image,news_image,ppdb_document,pkl_document',
            'description' => 'sometimes|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $files = $request->file('files');
            $type = $request->type;
            $user = $request->user();
            $folder = $this->getFolderByType($type);

            $uploadedFiles = [];
            $failedFiles = [];

            foreach ($files as $file) {
                try {
                    // Validasi keamanan file
                    $securityCheck = SecurityHelper::validateFileUpload($file, array_keys($this->allowedMimeTypes));

                    if (!$securityCheck['valid']) {
                        $failedFiles[] = [
                            'name' => $file->getClientOriginalName(),
                            'error' => implode(', ', $securityCheck['errors']),
                        ];
                        continue;
                    }

                    // Generate secure filename
                    $originalName = $file->getClientOriginalName();
                    $secureFilename = SecurityHelper::generateSecureFilename($originalName);

                    // Upload file
                    $path = $file->storeAs($folder, $secureFilename, 'public');

                    $uploadedFiles[] = [
                        'original_name' => $originalName,
                        'secure_name' => $secureFilename,
                        'mime_type' => $file->getMimeType(),
                        'size' => $file->getSize(),
                        'extension' => $file->getClientOriginalExtension(),
                        'path' => $path,
                        'url' => Storage::url($path),
                        'type' => $type,
                        'uploaded_by' => $user->id,
                        'uploaded_at' => Carbon::now()->toDateTimeString(),
                        'description' => $request->description,
                    ];

                } catch (\Exception $e) {
                    $failedFiles[] = [
                        'name' => $file->getClientOriginalName(),
                        'error' => $e->getMessage(),
                    ];
                }
            }

            // Log aktivitas
            if (!empty($uploadedFiles)) {
                SecurityHelper::logSecurityEvent(
                    'multiple_files_upload',
                    count($uploadedFiles) . ' file berhasil diupload',
                    $user->id
                );
            }

            return response()->json([
                'message' => 'Upload multiple file selesai',
                'uploaded' => $uploadedFiles,
                'failed' => $failedFiles,
                'success_count' => count($uploadedFiles),
                'failed_count' => count($failedFiles),
            ], 201);

        } catch (\Exception $e) {
            Log::error('Multiple file upload error: ' . $e->getMessage(), [
                'user_id' => $user->id ?? null,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengupload multiple file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get file info
     */
    public function getFileInfo($id)
    {
        try {
            // Implementasi bisa menggunakan database table untuk menyimpan metadata file
            // Untuk demo, return not implemented
            return response()->json([
                'message' => 'Fitur get file info belum diimplementasi',
            ], 501);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil info file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete file
     */
    public function deleteFile(Request $request, $path)
    {
        try {
            $user = $request->user();

            // Decode URL encoded path
            $decodedPath = urldecode($path);

            // Check if file exists
            if (!Storage::disk('public')->exists($decodedPath)) {
                return response()->json(['message' => 'File tidak ditemukan'], 404);
            }

            // Check permission untuk delete (bisa ditambahkan logic berdasarkan ownership)
            // Untuk sekarang, allow semua user yang terautentikasi

            // Delete file
            $deleted = Storage::disk('public')->delete($decodedPath);

            if (!$deleted) {
                return response()->json(['message' => 'Gagal menghapus file'], 500);
            }

            // Log aktivitas
            SecurityHelper::logSecurityEvent(
                'file_deleted',
                'File berhasil dihapus: ' . $decodedPath,
                $user->id
            );

            return response()->json([
                'message' => 'File berhasil dihapus',
                'path' => $decodedPath,
                'deleted_by' => $user->id,
                'deleted_at' => Carbon::now()->toDateTimeString(),
            ], 200);

        } catch (\Exception $e) {
            Log::error('File delete error: ' . $e->getMessage(), [
                'user_id' => $user->id ?? null,
                'path' => $path,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat menghapus file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * List files by type
     */
    public function listFiles(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'type' => 'required|in:student_document,profile_photo,product_image,news_image,ppdb_document,pkl_document',
                'page' => 'sometimes|integer|min:1',
                'per_page' => 'sometimes|integer|min:1|max:100',
            ]);

            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 422);
            }

            $type = $request->type;
            $folder = $this->getFolderByType($type);
            $page = $request->page ?? 1;
            $perPage = $request->per_page ?? 20;

            // Get files from storage
            $files = Storage::disk('public')->files($folder);

            // Paginate results
            $total = count($files);
            $offset = ($page - 1) * $perPage;
            $paginatedFiles = array_slice($files, $offset, $perPage);

            // Format file info
            $formattedFiles = [];
            foreach ($paginatedFiles as $file) {
                $size = Storage::disk('public')->size($file);
                $lastModified = Storage::disk('public')->lastModified($file);

                $formattedFiles[] = [
                    'name' => basename($file),
                    'path' => $file,
                    'url' => Storage::url($file),
                    'size' => $this->formatBytes($size),
                    'size_bytes' => $size,
                    'last_modified' => Carbon::createFromTimestamp($lastModified)->toDateTimeString(),
                    'type' => $type,
                ];
            }

            return response()->json([
                'files' => $formattedFiles,
                'pagination' => [
                    'total' => $total,
                    'page' => $page,
                    'per_page' => $perPage,
                    'total_pages' => ceil($total / $perPage),
                    'has_next' => $offset + $perPage < $total,
                    'has_prev' => $page > 1,
                ],
            ], 200);

        } catch (\Exception $e) {
            Log::error('List files error: ' . $e->getMessage(), [
                'type' => $request->type ?? null,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil daftar file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Download file
     */
    public function downloadFile($path)
    {
        try {
            // Decode URL encoded path
            $decodedPath = urldecode($path);

            // Check if file exists
            if (!Storage::disk('public')->exists($decodedPath)) {
                return response()->json(['message' => 'File tidak ditemukan'], 404);
            }

            // Get file info
            $mimeType = Storage::disk('public')->mimeType($decodedPath);
            $originalName = basename($decodedPath);

            // Log download (optional)
            SecurityHelper::logSecurityEvent(
                'file_downloaded',
                'File didownload: ' . $decodedPath,
                auth()->id() ?? null
            );

            // Return download response
            return Storage::disk('public')->download($decodedPath, $originalName, [
                'Content-Type' => $mimeType,
                'Content-Disposition' => 'attachment; filename="' . $originalName . '"',
            ]);

        } catch (\Exception $e) {
            Log::error('File download error: ' . $e->getMessage(), [
                'path' => $path,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mendownload file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get folder by type
     */
    private function getFolderByType($type)
    {
        $folders = [
            'student_document' => 'student-documents',
            'profile_photo' => 'profile-photos',
            'product_image' => 'product-images',
            'news_image' => 'news-images',
            'ppdb_document' => 'ppdb-documents',
            'pkl_document' => 'pkl-documents',
        ];

        return $folders[$type] ?? 'uploads';
    }

    /**
     * Format bytes to human readable
     */
    private function formatBytes($bytes, $precision = 2)
    {
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        $bytes = max($bytes, 0);
        $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
        $pow = min($pow, count($units) - 1);
        $bytes /= pow(1024, $pow);

        return round($bytes, $precision) . ' ' . $units[$pow];
    }

    /**
     * Clean up temporary files (cron job)
     */
    public function cleanupTemporaryFiles(Request $request)
    {
        try {
            // Hanya superadmin yang bisa menjalankan cleanup
            if (!$request->user()->hasRole('superadmin')) {
                return response()->json(['message' => 'Hanya superadmin yang dapat menjalankan cleanup'], 403);
            }

            $validator = Validator::make($request->all(), [
                'older_than_days' => 'required|integer|min:1|max:365',
                'dry_run' => 'sometimes|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 422);
            }

            $olderThanDays = $request->older_than_days;
            $dryRun = $request->dry_run ?? true;
            $cutoffDate = Carbon::now()->subDays($olderThanDays);

            $folders = [
                'temp',
                'tmp',
                'temporary',
            ];

            $deletedFiles = [];
            $totalSize = 0;

            foreach ($folders as $folder) {
                if (Storage::disk('public')->exists($folder)) {
                    $files = Storage::disk('public')->files($folder, true);

                    foreach ($files as $file) {
                        $lastModified = Carbon::createFromTimestamp(
                            Storage::disk('public')->lastModified($file)
                        );

                        if ($lastModified->lt($cutoffDate)) {
                            $fileSize = Storage::disk('public')->size($file);

                            if (!$dryRun) {
                                Storage::disk('public')->delete($file);
                            }

                            $deletedFiles[] = [
                                'path' => $file,
                                'size' => $this->formatBytes($fileSize),
                                'size_bytes' => $fileSize,
                                'last_modified' => $lastModified->toDateTimeString(),
                                'deleted' => !$dryRun,
                            ];

                            $totalSize += $fileSize;
                        }
                    }
                }
            }

            return response()->json([
                'message' => 'Cleanup temporary files completed',
                'dry_run' => $dryRun,
                'total_files' => count($deletedFiles),
                'total_size' => $this->formatBytes($totalSize),
                'cutoff_date' => $cutoffDate->toDateTimeString(),
                'files' => $deletedFiles,
            ], 200);

        } catch (\Exception $e) {
            Log::error('Cleanup files error: ' . $e->getMessage(), [
                'user_id' => $request->user()->id ?? null,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat melakukan cleanup',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
