<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('news')) {
            Schema::create('news', function (Blueprint $table) {
                $table->bigIncrements('id');
                $table->string('title');
                $table->string('slug')->unique();
                $table->text('content');
                $table->text('excerpt')->nullable();
                $table->string('category', 100)->nullable();
                $table->string('featured_image')->nullable();
                $table->unsignedBigInteger('author_id')->nullable();
                $table->boolean('published')->default(false);
                $table->timestamp('published_at')->nullable();
                $table->timestamps();

                $table->index(['published', 'published_at']);
                $table->index('category');
            });

            // Seed berita contoh
            DB::table('news')->insert([
                [
                    'title'        => 'SMK Nurul Jadid Raih Juara Nasional LKS 2024',
                    'slug'         => 'smk-nurul-jadid-raih-juara-nasional-lks-2024',
                    'content'      => 'SMK Nurul Jadid berhasil meraih juara pertama dalam Lomba Kompetensi Siswa (LKS) tingkat nasional tahun 2024 pada bidang Rekayasa Perangkat Lunak.',
                    'excerpt'      => 'SMK Nurul Jadid berhasil meraih juara pertama dalam LKS tingkat nasional 2024.',
                    'category'     => 'Prestasi',
                    'published'    => true,
                    'published_at' => now(),
                    'created_at'   => now(),
                    'updated_at'   => now(),
                ],
                [
                    'title'        => 'Penerimaan Peserta Didik Baru (PPDB) Tahun Ajaran 2025/2026',
                    'slug'         => 'ppdb-tahun-ajaran-2025-2026',
                    'content'      => 'SMK Nurul Jadid membuka pendaftaran peserta didik baru untuk tahun ajaran 2025/2026. Pendaftaran dibuka mulai 1 Januari 2025.',
                    'excerpt'      => 'Pendaftaran PPDB tahun ajaran 2025/2026 dibuka mulai Januari 2025.',
                    'category'     => 'Pengumuman',
                    'published'    => true,
                    'published_at' => now(),
                    'created_at'   => now(),
                    'updated_at'   => now(),
                ],
                [
                    'title'        => 'Kunjungan Industri Siswa RPL ke Perusahaan IT Terkemuka',
                    'slug'         => 'kunjungan-industri-siswa-rpl',
                    'content'      => 'Siswa jurusan Rekayasa Perangkat Lunak mengadakan kunjungan industri ke beberapa perusahaan IT terkemuka di Surabaya untuk menambah wawasan dunia kerja.',
                    'excerpt'      => 'Siswa RPL melakukan kunjungan industri ke perusahaan IT di Surabaya.',
                    'category'     => 'Kegiatan',
                    'published'    => true,
                    'published_at' => now(),
                    'created_at'   => now(),
                    'updated_at'   => now(),
                ],
            ]);
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('news');
    }
};
