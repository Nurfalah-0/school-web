<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PpdbRegistration;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class PpdbController extends Controller
{
    /**
     * [PUBLIC] Submit formulir pendaftaran PPDB dari halaman publik
     * POST /api/ppdb/apply
     */
    public function apply(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama'              => 'required|string|max:255',
                'nisn'              => 'nullable|string|max:20',
                'email'             => 'nullable|email|max:191',
                'phone'             => 'nullable|string|max:30',
                'program'           => 'required|string|max:100',
                'alamat'            => 'nullable|string',
                'tanggal_lahir'     => 'nullable|date',
                'tempat_lahir'      => 'nullable|string|max:100',
                'asal_sekolah'      => 'nullable|string|max:200',
                'jalur_pendaftaran' => 'nullable|in:reguler,prestasi,bidikmisi',
                'berkas'            => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:2048',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors(),
                    'message' => 'Data pendaftaran tidak valid.',
                ], 422);
            }

            $data = $validator->validated();

            // Generate nomor pendaftaran unik
            $data['no_pendaftaran']    = PpdbRegistration::generateNoPendaftaran();
            $data['status']            = 'pending';
            $data['jalur_pendaftaran'] = $data['jalur_pendaftaran'] ?? 'reguler';

            // Upload berkas jika ada
            if ($request->hasFile('berkas')) {
                $path             = $request->file('berkas')->store('ppdb-berkas', 'public');
                $data['berkas_path'] = $path;
                $data['berkas_url']  = Storage::url($path);
            }

            $registration = PpdbRegistration::create($data);

            return response()->json([
                'success'         => true,
                'message'         => 'Pendaftaran berhasil dikirim! Nomor pendaftaran Anda adalah ' . $registration->no_pendaftaran,
                'no_pendaftaran'  => $registration->no_pendaftaran,
                'data'            => $registration,
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [PUBLIC] Cek status pendaftaran berdasarkan nomor pendaftaran atau NISN
     * GET /api/ppdb/status/{identifier}
     */
    public function checkStatus(string $identifier)
    {
        try {
            $registration = PpdbRegistration::where('no_pendaftaran', $identifier)
                ->orWhere('nisn', $identifier)
                ->first();

            if (!$registration) {
                return response()->json([
                    'success' => false,
                    'message' => 'Nomor pendaftaran atau NISN tidak ditemukan.',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data'    => [
                    'no_pendaftaran'  => $registration->no_pendaftaran,
                    'nama'            => $registration->nama,
                    'program'         => $registration->program,
                    'status'          => $registration->status,
                    'status_label'    => $registration->status_label,
                    'catatan_admin'   => $registration->catatan_admin,
                    'tanggal_daftar'  => $registration->created_at?->format('d M Y'),
                    'verified_at'     => $registration->verified_at?->format('d M Y'),
                ],
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Daftar semua pendaftaran PPDB dengan filter & pagination
     * GET /api/ppdb/applications
     */
    public function index(Request $request)
    {
        try {
            $query = PpdbRegistration::latest();

            // Filter by status
            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            // Filter by program/jurusan
            if ($request->filled('program')) {
                $query->where('program', 'like', '%' . $request->program . '%');
            }

            // Search by nama, nisn, no_pendaftaran
            if ($request->filled('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('nama', 'like', "%{$search}%")
                      ->orWhere('nisn', 'like', "%{$search}%")
                      ->orWhere('no_pendaftaran', 'like', "%{$search}%")
                      ->orWhere('email', 'like', "%{$search}%");
                });
            }

            $registrations = $query->paginate($request->per_page ?? 15);

            // Tambahkan label status untuk setiap item
            $registrations->getCollection()->transform(function ($item) {
                $item->status_label = $item->status_label;
                return $item;
            });

            return response()->json([
                'success' => true,
                'data'    => $registrations,
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Detail satu pendaftaran
     * GET /api/ppdb/applications/{id}
     */
    public function show($id)
    {
        try {
            $registration = PpdbRegistration::find($id);

            if (!$registration) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data pendaftaran tidak ditemukan.',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data'    => $registration,
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Setujui/terima pendaftaran
     * POST /api/ppdb/applications/{id}/approve
     */
    public function approve(Request $request, $id)
    {
        try {
            $registration = PpdbRegistration::find($id);

            if (!$registration) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data pendaftaran tidak ditemukan.',
                ], 404);
            }

            $catatan = $request->input('catatan', null);

            $registration->update([
                'status'        => 'diterima',
                'catatan_admin' => $catatan,
                'verified_by'   => Auth::id(),
                'verified_at'   => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => "Pendaftaran atas nama {$registration->nama} telah DITERIMA.",
                'data'    => $registration->fresh(),
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Tolak pendaftaran
     * POST /api/ppdb/applications/{id}/reject
     */
    public function reject(Request $request, $id)
    {
        try {
            $registration = PpdbRegistration::find($id);

            if (!$registration) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data pendaftaran tidak ditemukan.',
                ], 404);
            }

            $catatan = $request->input('catatan', null);

            $registration->update([
                'status'        => 'ditolak',
                'catatan_admin' => $catatan,
                'verified_by'   => Auth::id(),
                'verified_at'   => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => "Pendaftaran atas nama {$registration->nama} telah DITOLAK.",
                'data'    => $registration->fresh(),
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Statistik pendaftaran PPDB
     * GET /api/ppdb/statistics
     */
    public function statistics()
    {
        try {
            $total      = PpdbRegistration::count();
            $pending    = PpdbRegistration::where('status', 'pending')->count();
            $verifikasi = PpdbRegistration::where('status', 'verifikasi')->count();
            $diterima   = PpdbRegistration::where('status', 'diterima')->count();
            $ditolak    = PpdbRegistration::where('status', 'ditolak')->count();

            // Breakdown per program/jurusan
            $perProgram = PpdbRegistration::selectRaw('program, count(*) as total')
                ->groupBy('program')
                ->orderByDesc('total')
                ->get();

            return response()->json([
                'success' => true,
                'data'    => [
                    'total'      => $total,
                    'pending'    => $pending,
                    'verifikasi' => $verifikasi,
                    'diterima'   => $diterima,
                    'ditolak'    => $ditolak,
                    'per_program' => $perProgram,
                ],
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Hapus data pendaftaran PPDB
     * DELETE /api/ppdb/applications/{id}
     */
    public function destroy($id)
    {
        try {
            $registration = PpdbRegistration::find($id);

            if (!$registration) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data pendaftaran tidak ditemukan.',
                ], 404);
            }

            if ($registration->berkas_path && Storage::disk('public')->exists($registration->berkas_path)) {
                Storage::disk('public')->delete($registration->berkas_path);
            }

            $registration->delete();

            return response()->json([
                'success' => true,
                'message' => 'Data pendaftaran berhasil dihapus.',
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus pendaftaran: ' . $e->getMessage(),
            ], 500);
        }
    }
}
