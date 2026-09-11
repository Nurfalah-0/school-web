<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('products') && !Schema::hasColumn('products', 'options')) {
            Schema::table('products', function (Blueprint $table) {
                $table->json('options')->nullable()->after('image');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('products') && Schema::hasColumn('products', 'options')) {
            Schema::table('products', function (Blueprint $table) {
                $table->dropColumn('options');
            });
        }
    }
};
