<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('majors', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name', 150);
            $table->string('code', 20);
            $table->string('slug', 120)->unique();
            $table->text('description')->nullable();
            $table->text('vision')->nullable();
            $table->text('mission')->nullable();
            $table->text('facilities')->nullable();
            $table->string('head_of_major')->nullable();
            $table->string('image')->nullable();
            $table->integer('student_count')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Insert default majors for SMK
        $majors = [
            [
                'name' => 'Teknik Kendaraan Ringan Otomotif',
                'code' => 'TKRO',
                'slug' => 'teknik-kendaraan-ringan-otomotif',
                'description' => 'Program keahlian yang mempelajari tentang perawatan dan perbaikan kendaraan ringan.',
                'student_count' => 120,
                'is_active' => true,
            ],
            [
                'name' => 'Rekayasa Perangkat Lunak',
                'code' => 'RPL',
                'slug' => 'rekayasa-perangkat-lunak',
                'description' => 'Program keahlian yang mempelajari tentang pengembangan perangkat lunak dan aplikasi.',
                'student_count' => 150,
                'is_active' => true,
            ],
            [
                'name' => 'Teknik Bisnis Sepeda Motor',
                'code' => 'TBSM',
                'slug' => 'teknik-bisnis-sepeda-motor',
                'description' => 'Program keahlian yang mempelajari tentang perawatan, perbaikan, dan bisnis sepeda motor.',
                'student_count' => 100,
                'is_active' => true,
            ],
            [
                'name' => 'Akuntansi dan Keuangan Lembaga',
                'code' => 'AKL',
                'slug' => 'akuntansi-dan-keuangan-lembaga',
                'description' => 'Program keahlian yang mempelajari tentang akuntansi dan pengelolaan keuangan.',
                'student_count' => 80,
                'is_active' => true,
            ],
        ];

        DB::table('majors')->insert($majors);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('majors');
    }
};
