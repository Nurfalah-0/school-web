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
        Schema::create('school_profiles', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('school_name', 200);
            $table->string('npsn', 20)->nullable();
            $table->string('address')->nullable();
            $table->string('phone', 30)->nullable();
            $table->string('email', 191)->nullable();
            $table->string('website')->nullable();
            $table->text('vision')->nullable();
            $table->text('mission')->nullable();
            $table->text('history')->nullable();
            $table->string('logo')->nullable();
            $table->string('facebook')->nullable();
            $table->string('instagram')->nullable();
            $table->string('youtube')->nullable();
            $table->string('twitter')->nullable();
            $table->string('headmaster_name')->nullable();
            $table->string('headmaster_photo')->nullable();
            $table->text('headmaster_message')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Insert default school profile
        DB::table('school_profiles')->insert([
            [
                'school_name' => 'SMK Nurul Jadid',
                'npsn' => '20512345',
                'address' => 'Jl. Pendidikan No. 123, Kabupaten Probolinggo',
                'phone' => '(0335) 123456',
                'email' => 'info@smknuruljadid.sch.id',
                'website' => 'https://smknuruljadid.sch.id',
                'vision' => 'Menjadi sekolah unggulan yang menghasilkan lulusan berkompeten, berakhlak mulia, dan mampu bersaing di era global.',
                'mission' => '1. Menyelenggarakan pendidikan yang berkualitas. 2. Mengembangkan potensi siswa secara optimal. 3. Membangun karakter yang berakhlak mulia.',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ]
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('school_profiles');
    }
};
