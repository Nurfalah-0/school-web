<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Student;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class StudentController extends Controller
{
    /**
     * Normalisasi nilai gender: terima "Laki-laki"/"Perempuan" maupun "M"/"F"
     */
    private function normalizeGender(?string $gender): ?string
    {
        if (is_null($gender)) return null;
        $g = strtolower(trim($gender));
        if (in_array($g, ['m', 'laki-laki', 'laki', 'male', 'pria'], true)) return 'Laki-laki';
        if (in_array($g, ['f', 'perempuan', 'wanita', 'female'], true)) return 'Perempuan';
        return $gender; // kembalikan apa adanya jika tidak dikenali
    }

    public function index(Request $request)
    {
        try {
            $query = Student::with('major');

            if ($request->has('major_id')) {
                $query->where('major_id', $request->major_id);
            }

            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('name', 'like', "%$search%")
                      ->orWhere('nis', 'like', "%$search%")
                      ->orWhere('nisn', 'like', "%$search%")
                      ->orWhere('email', 'like', "%$search%");
                });
            }

            if ($request->has('status')) {
                $query->where('status', $request->status);
            }

            $students = $query->paginate($request->per_page ?? 15);

            return response()->json([
                'success' => true,
                'data'    => $students,
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function show($id)
    {
        try {
            $student = Student::with('major')->find($id);

            if (!$student) {
                return response()->json(['success' => false, 'message' => 'Siswa tidak ditemukan.'], 404);
            }

            return response()->json(['success' => true, 'data' => $student]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nis'          => 'nullable|string|unique:students,nis',
                'nisn'         => 'nullable|string|unique:students,nisn',
                'name'         => 'required|string|max:255',
                'email'        => 'nullable|email|unique:students,email',
                'phone'        => 'nullable|string|max:30',
                'major_id'     => 'required|exists:majors,id',
                'class'        => 'required|string|max:50',
                'gender'       => 'nullable|string',
                'birth_date'   => 'nullable|date',      // diutamakan
                'date_of_birth'=> 'nullable|date',      // alias dari frontend lama
                'birth_place'  => 'nullable|string|max:100',
                'address'      => 'nullable|string',
                // Mapping fleksibel: frontend bisa kirim parent_name atau father_name
                'father_name'  => 'nullable|string|max:255',
                'father_phone' => 'nullable|string|max:30',
                'mother_name'  => 'nullable|string|max:255',
                'mother_phone' => 'nullable|string|max:30',
                'parent_name'  => 'nullable|string|max:255',  // alias
                'parent_phone' => 'nullable|string|max:30',   // alias
                'school_year'  => 'nullable|string|max:9',
                'status'       => 'nullable|in:active,inactive,pending,approved,rejected',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors(),
                ], 422);
            }

            $data = $validator->validated();

            // Normalisasi gender
            $data['gender'] = $this->normalizeGender($data['gender'] ?? null);

            // Prioritas tanggal lahir
            if (empty($data['birth_date']) && !empty($data['date_of_birth'])) {
                $data['birth_date'] = $data['date_of_birth'];
            }
            unset($data['date_of_birth']);

            // Remap parent_name → father_name jika father_name kosong
            if (!empty($data['parent_name']) && empty($data['father_name'])) {
                $data['father_name']  = $data['parent_name'];
            }
            if (!empty($data['parent_phone']) && empty($data['father_phone'])) {
                $data['father_phone'] = $data['parent_phone'];
            }
            unset($data['parent_name'], $data['parent_phone']);

            $student = Student::create($data);

            return response()->json([
                'success' => true,
                'message' => 'Data siswa berhasil ditambahkan.',
                'data'    => $student->load('major'),
            ], 201);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            $student = Student::find($id);

            if (!$student) {
                return response()->json(['success' => false, 'message' => 'Siswa tidak ditemukan.'], 404);
            }

            $validator = Validator::make($request->all(), [
                'nis'          => 'sometimes|string|unique:students,nis,' . $id,
                'nisn'         => 'sometimes|string|unique:students,nisn,' . $id,
                'name'         => 'sometimes|string|max:255',
                'email'        => 'nullable|email|unique:students,email,' . $id,
                'phone'        => 'nullable|string|max:30',
                'major_id'     => 'sometimes|exists:majors,id',
                'class'        => 'sometimes|string|max:50',
                'gender'       => 'nullable|string',
                'birth_date'   => 'nullable|date',
                'date_of_birth'=> 'nullable|date',
                'birth_place'  => 'nullable|string|max:100',
                'address'      => 'nullable|string',
                'father_name'  => 'nullable|string|max:255',
                'father_phone' => 'nullable|string|max:30',
                'mother_name'  => 'nullable|string|max:255',
                'mother_phone' => 'nullable|string|max:30',
                'parent_name'  => 'nullable|string|max:255',
                'parent_phone' => 'nullable|string|max:30',
                'school_year'  => 'nullable|string|max:9',
                'status'       => 'nullable|in:active,inactive,pending,approved,rejected',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors(),
                ], 422);
            }

            $data = $validator->validated();

            if (isset($data['gender'])) {
                $data['gender'] = $this->normalizeGender($data['gender']);
            }

            if (empty($data['birth_date']) && !empty($data['date_of_birth'])) {
                $data['birth_date'] = $data['date_of_birth'];
            }
            unset($data['date_of_birth']);

            if (!empty($data['parent_name']) && empty($data['father_name'])) {
                $data['father_name'] = $data['parent_name'];
            }
            if (!empty($data['parent_phone']) && empty($data['father_phone'])) {
                $data['father_phone'] = $data['parent_phone'];
            }
            unset($data['parent_name'], $data['parent_phone']);

            $student->update($data);

            return response()->json([
                'success' => true,
                'message' => 'Data siswa berhasil diperbarui.',
                'data'    => $student->fresh()->load('major'),
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $student = Student::find($id);

            if (!$student) {
                return response()->json(['success' => false, 'message' => 'Siswa tidak ditemukan.'], 404);
            }

            $student->delete();

            return response()->json(['success' => true, 'message' => 'Data siswa berhasil dihapus.']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function export()
    {
        try {
            $students = Student::with('major')->get();

            $csv  = "NIS,NISN,Nama,Email,Telepon,Jurusan,Kelas,Gender,Tanggal Lahir,Alamat,Ayah,Ibu,Status\n";
            foreach ($students as $s) {
                $csv .= sprintf(
                    "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
                    $s->nis ?? '',
                    $s->nisn ?? '',
                    $s->name,
                    $s->email ?? '',
                    $s->phone ?? '',
                    $s->major->name ?? '',
                    $s->class ?? '',
                    $s->gender ?? '',
                    $s->birth_date ?? '',
                    str_replace(',', ';', $s->address ?? ''),
                    $s->father_name ?? '',
                    $s->mother_name ?? '',
                    $s->status ?? ''
                );
            }

            return response($csv)
                ->header('Content-Type', 'text/csv')
                ->header('Content-Disposition', 'attachment; filename="students_' . date('Ymd') . '.csv"');
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function import(Request $request)
    {
        try {
            $request->validate(['file' => 'required|file|mimes:csv,txt']);

            $file     = $request->file('file');
            $lines    = file($file->getRealPath());
            $imported = 0;
            $errors   = [];

            foreach (array_slice($lines, 1) as $line) {
                $d = str_getcsv(trim($line));
                if (count($d) < 6) continue;
                try {
                    Student::create([
                        'nis'        => $d[0] ?? null,
                        'nisn'       => $d[1] ?? null,
                        'name'       => $d[2],
                        'email'      => $d[3] ?? null,
                        'phone'      => $d[4] ?? null,
                        'major_id'   => $d[5],
                        'class'      => $d[6] ?? null,
                        'gender'     => $this->normalizeGender($d[7] ?? null),
                        'birth_date' => $d[8] ?? null,
                        'address'    => $d[9] ?? null,
                    ]);
                    $imported++;
                } catch (\Exception $e) {
                    $errors[] = "Baris: " . implode(',', $d) . " → " . $e->getMessage();
                }
            }

            return response()->json([
                'success'  => true,
                'message'  => "Berhasil mengimpor {$imported} siswa.",
                'imported' => $imported,
                'errors'   => $errors,
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    // ===== PPDB Applications (backward compat — sekarang delegasi ke ppdb_registrations) =====

    public function getPpdbApplications()
    {
        try {
            // Ambil dari tabel ppdb_registrations (sumber data yang benar)
            $applications = DB::table('ppdb_registrations')
                ->where('status', 'pending')
                ->orderByDesc('created_at')
                ->paginate(15);

            return response()->json(['success' => true, 'data' => $applications]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function approvePpdbApplication($id)
    {
        try {
            $row = DB::table('ppdb_registrations')->where('id', $id)->first();
            if (!$row) {
                // Fallback ke students table
                $student = Student::find($id);
                if (!$student) {
                    return response()->json(['success' => false, 'message' => 'Data tidak ditemukan.'], 404);
                }
                $student->update(['status' => 'approved']);
                return response()->json(['success' => true, 'message' => 'Siswa disetujui.']);
            }

            DB::table('ppdb_registrations')->where('id', $id)->update([
                'status'      => 'diterima',
                'verified_by' => Auth::id(),
                'verified_at' => now(),
                'updated_at'  => now(),
            ]);

            return response()->json(['success' => true, 'message' => 'Pendaftaran diterima.']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function rejectPpdbApplication($id)
    {
        try {
            $row = DB::table('ppdb_registrations')->where('id', $id)->first();
            if (!$row) {
                $student = Student::find($id);
                if (!$student) {
                    return response()->json(['success' => false, 'message' => 'Data tidak ditemukan.'], 404);
                }
                $student->update(['status' => 'rejected']);
                return response()->json(['success' => true, 'message' => 'Siswa ditolak.']);
            }

            DB::table('ppdb_registrations')->where('id', $id)->update([
                'status'      => 'ditolak',
                'verified_by' => Auth::id(),
                'verified_at' => now(),
                'updated_at'  => now(),
            ]);

            return response()->json(['success' => true, 'message' => 'Pendaftaran ditolak.']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getDocuments()
    {
        try {
            $documents = DB::table('file_metadata')
                ->where('uploader_id', Auth::id())
                ->get();

            return response()->json(['success' => true, 'data' => $documents]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function verifyDocument($id)
    {
        try {
            DB::table('file_metadata')
                ->where('id', $id)
                ->update(['verified' => true, 'verified_by' => Auth::id()]);

            return response()->json(['success' => true, 'message' => 'Dokumen diverifikasi.']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getJobVacancies()
    {
        try {
            $vacancies = DB::table('job_vacancies')->where('status', 'published')->get();
            return response()->json(['success' => true, 'data' => $vacancies]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function publishJobVacancy($id)
    {
        try {
            DB::table('job_vacancies')
                ->where('id', $id)
                ->update(['status' => 'published', 'updated_at' => now()]);

            return response()->json(['success' => true, 'message' => 'Lowongan dipublikasikan.']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }
}
