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
        Schema::create('students', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('nisn', 20)->unique()->nullable();
            $table->string('nis', 20)->unique()->nullable();
            $table->string('name');
            $table->unsignedBigInteger('major_id')->nullable();
            $table->string('gender', 20)->nullable();
            $table->string('birth_place', 100)->nullable();
            $table->date('birth_date')->nullable();
            $table->string('phone', 30)->nullable();
            $table->string('email', 191)->nullable();
            $table->text('address')->nullable();
            $table->string('status', 30)->default('active');
            $table->string('class')->nullable();
            $table->string('school_year', 9)->nullable();
            $table->string('father_name')->nullable();
            $table->string('father_phone', 30)->nullable();
            $table->string('mother_name')->nullable();
            $table->string('mother_phone', 30)->nullable();
            $table->string('guardian_name')->nullable();
            $table->string('guardian_phone', 30)->nullable();
            $table->text('medical_history')->nullable();
            $table->text('special_needs')->nullable();
            $table->string('photo')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->foreign('major_id')->references('id')->on('majors')->onDelete('set null');
            $table->index(['major_id', 'status']);
            $table->index(['school_year', 'class']);
            $table->index('status');
        });

        // Insert sample students
        $students = [
            [
                'nisn' => '1234567890',
                'nis' => '20240001',
                'name' => 'Ahmad Santoso',
                'major_id' => 2, // RPL
                'gender' => 'Laki-laki',
                'birth_place' => 'Probolinggo',
                'birth_date' => '2008-05-15',
                'phone' => '081234567890',
                'email' => 'ahmad@student.smknj.sch.id',
                'address' => 'Jl. Merdeka No. 123, Probolinggo',
                'status' => 'active',
                'class' => 'XII RPL 1',
                'school_year' => '2024/2025',
                'father_name' => 'Budi Santoso',
                'father_phone' => '081234567891',
                'mother_name' => 'Siti Rahayu',
                'mother_phone' => '081234567892',
            ],
            [
                'nisn' => '1234567891',
                'nis' => '20240002',
                'name' => 'Sari Dewi',
                'major_id' => 4, // AKL
                'gender' => 'Perempuan',
                'birth_place' => 'Probolinggo',
                'birth_date' => '2008-08-20',
                'phone' => '081234567893',
                'email' => 'sari@student.smknj.sch.id',
                'address' => 'Jl. Pendidikan No. 45, Probolinggo',
                'status' => 'active',
                'class' => 'XII AKL 1',
                'school_year' => '2024/2025',
                'father_name' => 'Joko Widodo',
                'father_phone' => '081234567894',
                'mother_name' => 'Ani Yulianti',
                'mother_phone' => '081234567895',
            ],
            [
                'nisn' => '1234567892',
                'nis' => '20240003',
                'name' => 'Rizki Pratama',
                'major_id' => 1, // TKRO
                'gender' => 'Laki-laki',
                'birth_place' => 'Probolinggo',
                'birth_date' => '2008-03-10',
                'phone' => '081234567896',
                'email' => 'rizki@student.smknj.sch.id',
                'address' => 'Jl. Industri No. 67, Probolinggo',
                'status' => 'active',
                'class' => 'XII TKRO 1',
                'school_year' => '2024/2025',
                'father_name' => 'Agus Supriyadi',
                'father_phone' => '081234567897',
                'mother_name' => 'Maya Indah',
                'mother_phone' => '081234567898',
            ],
        ];

        DB::table('students')->insert($students);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('students');
    }
};
