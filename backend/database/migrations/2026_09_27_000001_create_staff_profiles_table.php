<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('staff_profiles', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->nullable();
            $table->string('staff_role', 150);
            $table->string('staff_group', 40);
            $table->unsignedInteger('sort_order')->default(0);
            $table->text('description')->nullable();
            $table->string('image')->nullable();
            $table->string('status', 30)->default('published');
            $table->timestamps();
            $table->index(['staff_group', 'sort_order', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('staff_profiles');
    }
};
