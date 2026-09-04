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
        Schema::create('roles', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name', 50)->unique();
            $table->string('description', 255)->nullable();
            $table->timestamps();
        });

        // Insert default roles
        DB::table('roles')->insert([
            ['name' => 'superadmin', 'description' => 'Super Administrator - Full access'],
            ['name' => 'admin_sekolah', 'description' => 'Admin Sekolah - School management'],
            ['name' => 'tu_sekolah', 'description' => 'Tata Usaha Sekolah - Administration'],
            ['name' => 'guru', 'description' => 'Guru - Teacher'],
            ['name' => 'siswa', 'description' => 'Siswa - Student'],
            ['name' => 'ppdb', 'description' => 'Admin PPDB - PPDB management'],
            ['name' => 'bkk', 'description' => 'Admin BKK - Career center'],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('roles');
    }
};
