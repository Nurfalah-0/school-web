<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('school_profiles', function (Blueprint $table) {
            $table->string('profile_page_title')->nullable()->after('profile_description');
            $table->text('profile_page_content')->nullable()->after('profile_page_title');
            $table->text('vision_page_intro')->nullable()->after('profile_page_content');
            $table->text('vision_page_content')->nullable()->after('vision_page_intro');
            $table->text('mission_page_content')->nullable()->after('vision_page_content');
        });
    }

    public function down(): void
    {
        Schema::table('school_profiles', function (Blueprint $table) {
            $table->dropColumn([
                'profile_page_title',
                'profile_page_content',
                'vision_page_intro',
                'vision_page_content',
                'mission_page_content',
            ]);
        });
    }
};
