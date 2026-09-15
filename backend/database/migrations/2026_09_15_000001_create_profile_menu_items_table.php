<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('profile_menu_items', function (Blueprint $table) {
            $table->id();
            $table->string('label', 120);
            $table->string('description', 255)->nullable();
            $table->string('path', 255)->default('/profil');
            $table->string('hash', 120)->nullable();
            $table->string('icon', 40)->default('school');
            $table->unsignedInteger('position')->default(1);
            $table->boolean('is_active')->default(true);
            $table->foreignId('created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('updated_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });

        DB::table('profile_menu_items')->insert([
            ['label' => 'SMK Nurul Jadid', 'description' => 'Identitas dan perjalanan sekolah', 'path' => '/profil', 'hash' => 'profil-sekolah', 'icon' => 'S', 'position' => 1, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['label' => 'Visi & Misi Sekolah', 'description' => 'Arah dan nilai pendidikan', 'path' => '/profil', 'hash' => 'visi-misi', 'icon' => 'V', 'position' => 2, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['label' => 'Kepala Sekolah', 'description' => 'Sambutan dan kepemimpinan', 'path' => '/profil', 'hash' => 'kepala-sekolah', 'icon' => 'K', 'position' => 3, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('profile_menu_items');
    }
};
