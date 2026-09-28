<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pkl_bkk_applications', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email', 191);
            $table->string('nisn', 20);
            $table->string('program', 100);
            $table->string('cv_path')->nullable();
            $table->string('cv_original_name')->nullable();
            $table->string('status', 30)->default('submitted');
            $table->timestamps();

            $table->index('nisn');
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pkl_bkk_applications');
    }
};