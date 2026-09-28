<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('staff_profiles', function (Blueprint $table) {
            $table->string('current_position')->nullable();
            $table->text('expertise')->nullable();
            $table->json('education')->nullable();
            $table->json('additional_roles')->nullable();
            $table->json('professional_experience')->nullable();
            $table->json('publications')->nullable();
            $table->json('awards')->nullable();
            $table->text('motto')->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('staff_profiles', function (Blueprint $table) {
            $table->dropColumn([
                'current_position',
                'expertise',
                'education',
                'additional_roles',
                'professional_experience',
                'publications',
                'awards',
                'motto',
            ]);
        });
    }
};
