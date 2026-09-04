<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SiteImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class SiteImageController extends Controller
{
    /**
     * Get all site images
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        try {
            $query = SiteImage::query();

            // Filter by section if provided
            if ($request->has('section')) {
                $query->where('section', $request->section);
            }

            // Filter by active status
            if ($request->has('is_active')) {
                $query->where('is_active', $request->is_active);
            }

            // Order by position
            $images = $query->orderBy('section')
                           ->orderBy('position')
                           ->get();

            return response()->json([
                'success' => true,
                'message' => 'Site images retrieved successfully',
                'data' => [
                    'images' => $images->map(function ($image) {
                        return [
                            'id' => $image->id,
                            'key' => $image->key,
                            'title' => $image->title,
                            'description' => $image->description,
                            'image_url' => $image->full_url,
                            'alt_text' => $image->alt_text,
                            'section' => $image->section,
                            'section_name' => $image->section_name,
                            'position' => $image->position,
                            'is_active' => $image->is_active,
                            'dimensions' => $image->dimensions,
                            'file_size' => $image->formatted_size,
                            'mime_type' => $image->mime_type,
                            'created_at' => $image->created_at?->format('Y-m-d H:i:s'),
                            'updated_at' => $image->updated_at?->format('Y-m-d H:i:s'),
                        ];
                    }),
                    'total' => $images->count(),
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve site images',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get images by section
     *
     * @param string $section
     * @return \Illuminate\Http\JsonResponse
     */
    public function getBySection($section)
    {
        try {
            $images = SiteImage::bySection($section)
                             ->active()
                             ->ordered()
                             ->get();

            return response()->json([
                'success' => true,
                'message' => "Images for section '{$section}' retrieved successfully",
                'data' => [
                    'section' => $section,
                    'section_name' => SiteImage::SECTIONS[$section] ?? $section,
                    'images' => $images->map(function ($image) {
                        return [
                            'id' => $image->id,
                            'key' => $image->key,
                            'title' => $image->title,
                            'description' => $image->description,
                            'image_url' => $image->full_url,
                            'alt_text' => $image->alt_text,
                            'position' => $image->position,
                            'dimensions' => $image->dimensions,
                            'created_at' => $image->created_at?->format('Y-m-d H:i:s'),
                        ];
                    }),
                    'total' => $images->count(),
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve images by section',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get single image by key
     *
     * @param string $key
     * @return \Illuminate\Http\JsonResponse
     */
    public function getByKey($key)
    {
        try {
            $image = SiteImage::byKey($key)
                            ->active()
                            ->first();

            if (!$image) {
                return response()->json([
                    'success' => false,
                    'message' => "Image with key '{$key}' not found"
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Image retrieved successfully',
                'data' => [
                    'image' => [
                        'id' => $image->id,
                        'key' => $image->key,
                        'title' => $image->title,
                        'description' => $image->description,
                        'image_url' => $image->full_url,
                        'alt_text' => $image->alt_text,
                        'section' => $image->section,
                        'section_name' => $image->section_name,
                        'position' => $image->position,
                        'dimensions' => $image->dimensions,
                        'file_size' => $image->formatted_size,
                        'created_at' => $image->created_at?->format('Y-m-d H:i:s'),
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve image',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Upload new site image (admin only)
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        try {
            // Validation
            $validator = Validator::make($request->all(), [
                'key' => 'required|string|max:100|unique:site_images,key',
                'title' => 'required|string|max:255',
                'description' => 'nullable|string',
                'section' => 'required|string|max:50',
                'image' => 'required|image|mimes:jpeg,jpg,png,gif,webp|max:5120', // 5MB max
                'alt_text' => 'nullable|string|max:255',
                'position' => 'nullable|integer|min:1',
                'is_active' => 'nullable|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Validate section
            if (!array_key_exists($request->section, SiteImage::SECTIONS)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid section provided',
                    'valid_sections' => SiteImage::SECTIONS
                ], 422);
            }

            // Security check for malicious content
            $file = $request->file('image');
            $mimeType = $file->getMimeType();

            // Additional security: Check file content
            $allowedMimes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
            if (!in_array($mimeType, $allowedMimes)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid image type'
                ], 422);
            }

            // Generate secure filename
            $extension = $file->getClientOriginalExtension();
            $filename = time() . '_' . Str::random(16) . '.' . $extension;
            $path = 'site-images/' . $request->section . '/' . $filename;

            // Upload to storage/app/public
            $storedPath = $file->storeAs('site-images/' . $request->section, $filename, 'public');

            // Get image dimensions and file size
            $imageInfo = getimagesize($file->getRealPath());
            $width = $imageInfo[0] ?? null;
            $height = $imageInfo[1] ?? null;

            // Create database record
            $image = SiteImage::create([
                'key' => $request->key,
                'title' => $request->title,
                'description' => $request->description,
                'image_path' => $storedPath,
                'image_url' => Storage::url($storedPath),
                'alt_text' => $request->alt_text ?? $request->title,
                'section' => $request->section,
                'position' => $request->position ?? 1,
                'is_active' => $request->is_active ?? true,
                'width' => $width,
                'height' => $height,
                'file_size' => $file->getSize(),
                'mime_type' => $mimeType,
                'created_by' => auth()->id(),
                'updated_by' => auth()->id(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Site image uploaded successfully',
                'data' => [
                    'image' => $image->getMetadata()
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to upload site image',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update site image metadata (admin only)
     *
     * @param \Illuminate\Http\Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        try {
            $image = SiteImage::find($id);

            if (!$image) {
                return response()->json([
                    'success' => false,
                    'message' => 'Site image not found'
                ], 404);
            }

            // Validation
            $validator = Validator::make($request->all(), [
                'key' => 'sometimes|string|max:100|unique:site_images,key,' . $id,
                'title' => 'sometimes|string|max:255',
                'description' => 'nullable|string',
                'section' => 'sometimes|string|max:50',
                'alt_text' => 'nullable|string|max:255',
                'position' => 'nullable|integer|min:1',
                'is_active' => 'nullable|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Validate section if provided
            if ($request->has('section') && !array_key_exists($request->section, SiteImage::SECTIONS)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid section provided',
                    'valid_sections' => SiteImage::SECTIONS
                ], 422);
            }

            // Update image
            $image->update([
                'key' => $request->key ?? $image->key,
                'title' => $request->title ?? $image->title,
                'description' => $request->description ?? $image->description,
                'alt_text' => $request->alt_text ?? $image->alt_text,
                'section' => $request->section ?? $image->section,
                'position' => $request->position ?? $image->position,
                'is_active' => $request->is_active ?? $image->is_active,
                'updated_by' => auth()->id(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Site image updated successfully',
                'data' => [
                    'image' => $image->getMetadata()
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update site image',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Replace image file (admin only)
     *
     * @param \Illuminate\Http\Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function uploadImage(Request $request, $id)
    {
        try {
            $image = SiteImage::find($id);

            if (!$image) {
                return response()->json([
                    'success' => false,
                    'message' => 'Site image not found'
                ], 404);
            }

            // Validation
            $validator = Validator::make($request->all(), [
                'image' => 'required|image|mimes:jpeg,jpg,png,gif,webp|max:5120', // 5MB max
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            $file = $request->file('image');
            $mimeType = $file->getMimeType();

            // Security check
            $allowedMimes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
            if (!in_array($mimeType, $allowedMimes)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid image type'
                ], 422);
            }

            // Delete old image file
            if ($image->image_path && Storage::disk('public')->exists($image->image_path)) {
                Storage::disk('public')->delete($image->image_path);
            }

            // Generate secure filename
            $extension = $file->getClientOriginalExtension();
            $filename = time() . '_' . Str::random(16) . '.' . $extension;

            // Upload new image
            $storedPath = $file->storeAs('site-images/' . $image->section, $filename, 'public');

            // Get new image dimensions
            $imageInfo = getimagesize($file->getRealPath());
            $width = $imageInfo[0] ?? null;
            $height = $imageInfo[1] ?? null;

            // Update database
            $image->update([
                'image_path' => $storedPath,
                'image_url' => Storage::url($storedPath),
                'width' => $width,
                'height' => $height,
                'file_size' => $file->getSize(),
                'mime_type' => $mimeType,
                'updated_by' => auth()->id(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Image file replaced successfully',
                'data' => [
                    'image' => $image->getMetadata()
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to replace image file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete site image (admin only)
     *
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        try {
            $image = SiteImage::find($id);

            if (!$image) {
                return response()->json([
                    'success' => false,
                    'message' => 'Site image not found'
                ], 404);
            }

            // Store image key for response
            $imageKey = $image->key;

            // Delete file from storage (auto-triggered by model deleting event)
            $image->delete();

            return response()->json([
                'success' => true,
                'message' => "Site image '{$imageKey}' deleted successfully"
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete site image',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get available sections
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getSections()
    {
        try {
            return response()->json([
                'success' => true,
                'message' => 'Available sections retrieved successfully',
                'data' => [
                    'sections' => collect(SiteImage::SECTIONS)->map(function ($name, $key) {
                        return [
                            'key' => $key,
                            'name' => $name,
                            'image_count' => SiteImage::where('section', $key)->count(),
                        ];
                    })->values()
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve sections',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Bulk update positions
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function updatePositions(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'positions' => 'required|array',
                'positions.*.id' => 'required|integer|exists:site_images,id',
                'positions.*.position' => 'required|integer|min:1',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            foreach ($request->positions as $item) {
                SiteImage::where('id', $item['id'])->update([
                    'position' => $item['position'],
                    'updated_by' => auth()->id(),
                ]);
            }

            return response()->json([
                'success' => true,
                'message' => 'Positions updated successfully'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update positions',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get statistics
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getStatistics()
    {
        try {
            $totalImages = SiteImage::count();
            $activeImages = SiteImage::where('is_active', true)->count();
            $totalSize = SiteImage::sum('file_size');

            $bySection = SiteImage::selectRaw('section, COUNT(*) as count')
                                ->groupBy('section')
                                ->get()
                                ->mapWithKeys(function ($item) {
                                    return [
                                        $item->section => [
                                            'name' => SiteImage::SECTIONS[$item->section] ?? $item->section,
                                            'count' => $item->count
                                        ]
                                    ];
                                });

            return response()->json([
                'success' => true,
                'message' => 'Statistics retrieved successfully',
                'data' => [
                    'total_images' => $totalImages,
                    'active_images' => $activeImages,
                    'inactive_images' => $totalImages - $activeImages,
                    'total_size' => $totalSize,
                    'total_size_formatted' => $this->formatBytes($totalSize),
                    'by_section' => $bySection,
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve statistics',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Format bytes to human readable
     *
     * @param int $bytes
     * @return string
     */
    private function formatBytes($bytes)
    {
        if ($bytes == 0) return '0 B';

        $units = ['B', 'KB', 'MB', 'GB'];
        $i = 0;

        while ($bytes > 1024 && $i < count($units) - 1) {
            $bytes /= 1024;
            $i++;
        }

        return round($bytes, 2) . ' ' . $units[$i];
    }
}
