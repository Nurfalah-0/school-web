<?php

namespace Tests\Feature;

use App\Models\PklBkkApplication;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class PklBkkApplicationTest extends TestCase
{
    use RefreshDatabase;

    public function test_public_application_and_cv_are_saved(): void
    {
        Storage::fake('local');

        $response = $this->post('/api/bkk/applications', [
            'name' => 'Siswa Contoh',
            'email' => 'siswa@example.com',
            'nisn' => '0012345678',
            'program' => 'PPLG',
            'cv' => UploadedFile::fake()->create('cv.pdf', 100, 'application/pdf'),
        ]);

        $response->assertCreated()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.status', 'submitted');

        $application = PklBkkApplication::firstOrFail();
        $this->assertSame('cv.pdf', $application->cv_original_name);
        Storage::disk('local')->assertExists($application->cv_path);
    }

    public function test_application_requires_valid_contact_and_program_fields(): void
    {
        $this->postJson('/api/bkk/applications', [])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['name', 'email', 'nisn', 'program']);
    }
}