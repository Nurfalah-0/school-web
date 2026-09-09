<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MajorFacility;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class MajorController extends Controller
{
    public function index()
    {
        try {
            $majors = DB::table('majors')
                ->where('is_active', true)
                ->get();

            return response()->json([
                'success' => true,
                'data'    => $majors,
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function show($id)
    {
        try {
            $major = DB::table('majors')->where('id', $id)->first();

            if (!$major) {
                return response()->json(['success' => false, 'message' => 'Jurusan tidak ditemukan.'], 404);
            }

            $students  = DB::table('students')->where('major_id', $id)->count();
            $facilities = DB::table('major_facilities')->where('major_id', $id)->get();

            return response()->json([
                'success' => true,
                'data'    => [
                    'major'         => $major,
                    'student_count' => $students,
                    'facilities'    => $facilities,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            if ($request->has('is_active')) {
                $activeValue = $request->input('is_active');
                if (in_array($activeValue, [true, 1, '1', 'true'], true)) {
                    $request->merge(['is_active' => true]);
                } elseif (in_array($activeValue, [false, 0, '0', 'false'], true)) {
                    $request->merge(['is_active' => false]);
                }
            }

            $validator = Validator::make($request->all(), [
                'code'        => 'required|string|max:20|unique:majors,code',
                'name'        => 'required|string|max:150',
                'description' => 'nullable|string',
                'capacity'    => 'nullable|integer|min:0',
                'vision'      => 'nullable|string',
                'mission'     => 'nullable|string',
                'image'       => 'nullable|image|max:5120',
                'image_url'   => 'nullable|url',
                'is_active'   => 'nullable|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors(),
                ], 422);
            }

            $data = $validator->validated();
            if ($request->hasFile('image')) {
                $path = $request->file('image')->store('major-images', 'public');
                $data['image'] = url('storage/' . ltrim($path, '/'));
            } elseif ($request->filled('image_url')) {
                $data['image'] = $request->image_url;
            }

            $data['slug']          = Str::slug($data['name']);
            $data['student_count'] = $data['capacity'] ?? 0;
            $data['created_at']    = now();
            $data['updated_at']    = now();

            unset($data['image_url']);

            $id = DB::table('majors')->insertGetId($data);

            return response()->json([
                'success' => true,
                'message' => 'Jurusan berhasil ditambahkan.',
                'id'      => $id,
                'data'    => DB::table('majors')->where('id', $id)->first(),
            ], 201);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            if ($request->has('is_active')) {
                $activeValue = $request->input('is_active');
                if (in_array($activeValue, [true, 1, '1', 'true'], true)) {
                    $request->merge(['is_active' => true]);
                } elseif (in_array($activeValue, [false, 0, '0', 'false'], true)) {
                    $request->merge(['is_active' => false]);
                }
            }

            $major = DB::table('majors')->where('id', $id)->first();

            if (!$major) {
                return response()->json(['success' => false, 'message' => 'Jurusan tidak ditemukan.'], 404);
            }

            $validator = Validator::make($request->all(), [
                'code'        => 'sometimes|string|max:20|unique:majors,code,' . $id,
                'name'        => 'sometimes|string|max:150',
                'description' => 'nullable|string',
                'capacity'    => 'nullable|integer|min:0',
                'vision'      => 'nullable|string',
                'mission'     => 'nullable|string',
                'image'       => 'nullable|image|max:5120',
                'image_url'   => 'nullable|url',
                'is_active'   => 'nullable|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors(),
                ], 422);
            }

            $data = $validator->validated();

            if ($request->hasFile('image')) {
                if (!empty($major->image) && str_contains($major->image, '/storage/')) {
                    $oldFile = str_replace('/storage/', '', parse_url($major->image, PHP_URL_PATH));
                    if ($oldFile && Storage::disk('public')->exists($oldFile)) {
                        Storage::disk('public')->delete($oldFile);
                    }
                }

                $path = $request->file('image')->store('major-images', 'public');
                $data['image'] = url(Storage::url($path));
            } elseif ($request->filled('image_url')) {
                $data['image'] = $request->image_url;
            }

            if (isset($data['name'])) {
                $data['slug'] = Str::slug($data['name']);
            }
            if (isset($data['capacity'])) {
                $data['student_count'] = $data['capacity'];
            }

            $data['updated_at'] = now();
            unset($data['image_url']);

            DB::table('majors')->where('id', $id)->update($data);

            return response()->json([
                'success' => true,
                'message' => 'Jurusan berhasil diperbarui.',
                'data'    => DB::table('majors')->where('id', $id)->first(),
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function uploadImage(Request $request, $id)
    {
        try {
            $major = DB::table('majors')->where('id', $id)->first();

            if (!$major) {
                return response()->json(['success' => false, 'message' => 'Jurusan tidak ditemukan.'], 404);
            }

            $validator = Validator::make($request->all(), [
                'image' => 'required|image|max:5120',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors(),
                ], 422);
            }

            if (!empty($major->image) && str_contains($major->image, '/storage/')) {
                $oldFile = str_replace('/storage/', '', parse_url($major->image, PHP_URL_PATH));
                if ($oldFile && Storage::disk('public')->exists($oldFile)) {
                    Storage::disk('public')->delete($oldFile);
                }
            }

            $path = $request->file('image')->store('major-images', 'public');
            $imageUrl = url(Storage::url($path));
            DB::table('majors')->where('id', $id)->update([
                'image' => $imageUrl,
                'updated_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Gambar jurusan berhasil diunggah.',
                'data' => DB::table('majors')->where('id', $id)->first(),
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $major = DB::table('majors')->where('id', $id)->first();

            if (!$major) {
                return response()->json(['success' => false, 'message' => 'Jurusan tidak ditemukan.'], 404);
            }

            DB::table('majors')->where('id', $id)->delete();

            return response()->json(['success' => true, 'message' => 'Jurusan berhasil dihapus.']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function addFacility($id, Request $request)
    {
        try {
            $major = DB::table('majors')->where('id', $id)->first();
            if (!$major) {
                return response()->json(['success' => false, 'message' => 'Jurusan tidak ditemukan.'], 404);
            }

            $validator = Validator::make($request->all(), [
                'name'        => 'required|string|max:255',
                'description' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors(),
                ], 422);
            }

            $facility = MajorFacility::create([
                'major_id'    => $id,
                'name'        => $request->name,
                'description' => $request->description,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Fasilitas berhasil ditambahkan.',
                'data'    => $facility,
            ], 201);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function removeFacility($majorId, $facilityId)
    {
        try {
            $deleted = MajorFacility::where('id', $facilityId)
                ->where('major_id', $majorId)
                ->delete();

            if (!$deleted) {
                return response()->json(['success' => false, 'message' => 'Fasilitas tidak ditemukan.'], 404);
            }

            return response()->json(['success' => true, 'message' => 'Fasilitas berhasil dihapus.']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }
}
