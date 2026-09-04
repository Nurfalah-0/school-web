<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Tambah kolom yang dibutuhkan frontend ke school_profiles
        Schema::table('school_profiles', function (Blueprint $table) {
            if (!Schema::hasColumn('school_profiles', 'founded_year')) {
                $table->unsignedSmallInteger('founded_year')->nullable()->after('headmaster_message');
            }
            if (!Schema::hasColumn('school_profiles', 'logo_path')) {
                $table->string('logo_path')->nullable()->after('logo');
            }
            if (!Schema::hasColumn('school_profiles', 'accreditation')) {
                $table->string('accreditation', 10)->nullable()->after('founded_year');
            }
            if (!Schema::hasColumn('school_profiles', 'student_count')) {
                $table->unsignedInteger('student_count')->default(0)->after('accreditation');
            }
            if (!Schema::hasColumn('school_profiles', 'teacher_count')) {
                $table->unsignedInteger('teacher_count')->default(0)->after('student_count');
            }
            if (!Schema::hasColumn('school_profiles', 'tiktok')) {
                $table->string('tiktok')->nullable()->after('twitter');
            }
        });

        // Tambah kolom capacity ke majors (frontend kirim capacity, bukan student_count)
        if (!Schema::hasColumn('majors', 'capacity')) {
            Schema::table('majors', function (Blueprint $table) {
                $table->unsignedInteger('capacity')->default(0)->after('student_count');
            });
        }

        // Sinkronisasi capacity dari student_count untuk data yang sudah ada
        DB::table('majors')->get()->each(function ($major) {
            DB::table('majors')->where('id', $major->id)->update([
                'capacity' => $major->student_count ?? 0,
            ]);
        });
    }

    public function down(): void
    {
        Schema::table('school_profiles', function (Blueprint $table) {
            $table->dropColumn([
                'founded_year', 'logo_path', 'accreditation',
                'student_count', 'teacher_count', 'tiktok',
            ]);
        });
        Schema::table('majors', function (Blueprint $table) {
            $table->dropColumn('capacity');
        });
    }
};
