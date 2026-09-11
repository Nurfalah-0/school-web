<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PpdbRegistration;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SchoolController extends Controller
{
    public function getProfile()
    {
        try {
            $profile = DB::table('school_profiles')->first();

            if (!$profile) {
                return response()->json([
                    'success' => false,
                    'message' => 'School profile not found',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data'    => $profile,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function updateProfile(Request $request)
    {
        try {
            $validated = $request->validate([
                'school_name'       => 'sometimes|string|max:255',
                'nsm'               => 'sometimes|nullable|string|max:30',
                'npsn'              => 'sometimes|nullable|string|max:20',
                'npwp'              => 'sometimes|nullable|string|max:30',
                'profile_title_line1' => 'sometimes|nullable|string|max:255',
                'profile_title_line2' => 'sometimes|nullable|string|max:255',
                'profile_description' => 'sometimes|nullable|string',
                'address'           => 'sometimes|nullable|string',
                'village'           => 'sometimes|nullable|string|max:100',
                'district'          => 'sometimes|nullable|string|max:100',
                'city'              => 'sometimes|nullable|string|max:100',
                'phone'             => 'sometimes|nullable|string',
                'email'             => 'sometimes|nullable|email',
                'website'           => 'sometimes|nullable|string',
                'operating_year'    => 'sometimes|nullable|integer|min:1900|max:2100',
                'headmaster_name'   => 'sometimes|nullable|string|max:255',
                'headmaster_message'=> 'sometimes|nullable|string',
                'founded_year'      => 'sometimes|nullable|integer|min:1900|max:2100',
                'accreditation'     => 'sometimes|nullable|string|max:10',
                'foundation_name'   => 'sometimes|nullable|string|max:255',
                'vision'            => 'sometimes|nullable|string',
                'mission'           => 'sometimes|nullable|string',
                'facebook'          => 'sometimes|string|nullable',
                'instagram'         => 'sometimes|string|nullable',
                'youtube'           => 'sometimes|string|nullable',
                'twitter'           => 'sometimes|string|nullable',
                'tiktok'            => 'sometimes|string|nullable',
            ]);

            $validated['updated_at'] = now();

            DB::table('school_profiles')
                ->limit(1)
                ->update($validated);

            $profile = DB::table('school_profiles')->first();

            return response()->json([
                'success' => true,
                'message' => 'Profil sekolah berhasil diperbarui.',
                'data'    => $profile,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function uploadLogo(Request $request)
    {
        try {
            $request->validate([
                'logo' => 'required|image|mimes:jpeg,jpg,png,gif,webp|max:2048',
            ]);

            $file = $request->file('logo');
            $path = $file->store('school-logos', 'public');

            DB::table('school_profiles')
                ->limit(1)
                ->update([
                    'logo_path'  => $path,
                    'updated_at' => now(),
                ]);

            return response()->json([
                'success'  => true,
                'message'  => 'Logo berhasil diupload.',
                'logo_url' => \Storage::url($path),
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Statistik dashboard admin — semua data dari database, tidak ada yang hardcoded
     */
    public function getDashboardStats()
    {
        try {
            $totalStudents      = DB::table('students')->count();
            $totalMajors        = DB::table('majors')->where('is_active', true)->count();
            $totalUsers         = DB::table('users')->count();
            $totalNews          = DB::table('news')->where('published', true)->count();
            $totalIndustry      = DB::table('industry_partners')->where('is_active', true)->count();
            $totalAchievements  = DB::table('achievements')->where('is_published', true)->count();
            $totalGalleries     = DB::table('galleries')->where('is_published', true)->count();
            $totalProducts      = DB::table('products')->where('status', 'published')->count();
            $totalJobVacancies  = DB::table('job_vacancies')->where('status', 'published')->count();

            // PPDB stats
            $ppdbTotal    = DB::table('ppdb_registrations')->count();
            $ppdbPending  = DB::table('ppdb_registrations')->where('status', 'pending')->count();
            $ppdbDiterima = DB::table('ppdb_registrations')->where('status', 'diterima')->count();
            $ppdbDitolak  = DB::table('ppdb_registrations')->where('status', 'ditolak')->count();

            // Security alerts — nama tabel yang benar: security_monitoring
            $activeAlerts = 0;
            try {
                $activeAlerts = DB::table('security_monitoring')
                    ->where('resolved', false)
                    ->count();
            } catch (\Exception $ignored) {
                // Tabel belum ada atau kolom berbeda
            }

            return response()->json([
                'success' => true,
                'data'    => [
                    'total_students'       => $totalStudents,
                    'total_majors'         => $totalMajors,
                    'total_users'          => $totalUsers,
                    'total_news'           => $totalNews,
                    'total_industry_partners' => $totalIndustry,
                    'total_achievements'   => $totalAchievements,
                    'total_galleries'      => $totalGalleries,
                    'total_products'       => $totalProducts,
                    'total_job_vacancies'  => $totalJobVacancies,
                    'active_security_alerts' => $activeAlerts,
                    'ppdb' => [
                        'total'    => $ppdbTotal,
                        'pending'  => $ppdbPending,
                        'diterima' => $ppdbDiterima,
                        'ditolak'  => $ppdbDitolak,
                    ],
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function getRecentActivity()
    {
        try {
            $activities = DB::table('activity_logs')
                ->orderBy('created_at', 'desc')
                ->limit(20)
                ->get();

            return response()->json([
                'success' => true,
                'data'    => $activities,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}
