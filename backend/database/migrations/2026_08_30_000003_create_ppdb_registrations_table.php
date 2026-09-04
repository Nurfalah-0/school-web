<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('ppdb_registrations')) {
            Schema::create('ppdb_registrations', function (Blueprint $table) {
                $table->bigIncrements('id');
                // Nomor pendaftaran otomatis, format: PPDB-YYYY-XXXXXX
                $table->string('no_pendaftaran', 30)->unique();
                $table->string('nama');
                $table->string('nisn', 20)->nullable();
                $table->string('email')->nullable();
                $table->string('phone', 30)->nullable();
                $table->string('program', 100); // Jurusan pilihan
                $table->text('alamat')->nullable();
                $table->date('tanggal_lahir')->nullable();
                $table->string('tempat_lahir', 100)->nullable();
                $table->string('asal_sekolah', 200)->nullable();
                $table->string('berkas_path')->nullable(); // Path file upload
                $table->string('berkas_url')->nullable();  // URL file yang diupload
                // Status: pending | verifikasi | diterima | ditolak
                $table->string('status', 30)->default('pending');
                $table->text('catatan_admin')->nullable(); // Catatan dari admin saat approve/reject
                $table->unsignedBigInteger('verified_by')->nullable(); // ID admin yang verifikasi
                $table->timestamp('verified_at')->nullable();
                $table->string('jalur_pendaftaran', 50)->default('reguler'); // reguler | prestasi | bidikmisi
                $table->timestamps();

                $table->index('status');
                $table->index('no_pendaftaran');
                $table->index('nisn');
                $table->index('created_at');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('ppdb_registrations');
    }
};
