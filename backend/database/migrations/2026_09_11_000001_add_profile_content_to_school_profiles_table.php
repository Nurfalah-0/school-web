<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('school_profiles', function (Blueprint $table) {
            $table->string('profile_title_line1')->nullable()->after('school_name');
            $table->string('profile_title_line2')->nullable()->after('profile_title_line1');
            $table->text('profile_description')->nullable()->after('profile_title_line2');
        });
    }

    public function down(): void
    {
        Schema::table('school_profiles', function (Blueprint $table) {
            $table->dropColumn([
                'profile_title_line1',
                'profile_title_line2',
                'profile_description',
            ]);
        });
    }
};
