<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PklBkkApplication;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules\File;

class PklBkkApplicationController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:191'],
            'nisn' => ['required', 'string', 'max:20'],
            'program' => ['required', 'string', 'max:100'],
            'cv' => ['nullable', File::types(['pdf', 'jpg', 'jpeg', 'png'])->max(5120)],
        ]);

        $cv = $validated['cv'] ?? null;
        unset($validated['cv']);
        $storedPath = null;

        try {
            $application = DB::transaction(function () use ($validated, $cv, &$storedPath) {
                $application = PklBkkApplication::create($validated + ['status' => 'submitted']);

                if ($cv) {
                    $storedPath = $cv->store('pkl-bkk-applications', 'local');
                    if (!$storedPath) {
                        throw new \RuntimeException('CV upload failed.');
                    }

                    $application->update([
                        'cv_path' => $storedPath,
                        'cv_original_name' => $cv->getClientOriginalName(),
                    ]);
                }

                return $application;
            });
        } catch (\Throwable $exception) {
            if ($storedPath) {
                Storage::disk('local')->delete($storedPath);
            }

            throw $exception;
        }

        return response()->json([
            'success' => true,
            'message' => 'Lamaran berhasil diterima.',
            'data' => [
                'id' => $application->id,
                'status' => $application->status,
            ],
        ], 201);
    }

    public function index(Request $request)
    {
        $validated = $request->validate([
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:100'],
        ]);

        $applications = PklBkkApplication::query()
            ->select(['id', 'name', 'email', 'nisn', 'program', 'cv_original_name', 'status', 'created_at'])
            ->latest()
            ->paginate($validated['per_page'] ?? 15);

        return response()->json(['success' => true, 'data' => $applications]);
    }

    public function downloadCv(PklBkkApplication $application)
    {
        abort_unless(
            $application->cv_path && Storage::disk('local')->exists($application->cv_path),
            404
        );

        return Storage::disk('local')->download($application->cv_path, $application->cv_original_name);
    }
}