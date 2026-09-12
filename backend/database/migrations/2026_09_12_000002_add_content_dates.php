<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('achievements') && !Schema::hasColumn('achievements', 'achieved_at')) {
            Schema::table('achievements', function (Blueprint $table) {
                $table->date('achieved_at')->nullable()->after('year');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('achievements') && Schema::hasColumn('achievements', 'achieved_at')) {
            Schema::table('achievements', function (Blueprint $table) {
                $table->dropColumn('achieved_at');
            });
        }
    }
};
