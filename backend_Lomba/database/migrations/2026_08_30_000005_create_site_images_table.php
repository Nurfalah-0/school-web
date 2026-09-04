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
        Schema::create('site_images', function (Blueprint $table) {
            $table->id();
            $table->string('key', 100)->unique();
            $table->string('title', 255);
            $table->text('description')->nullable();
            $table->string('image_path');
            $table->string('image_url');
            $table->string('alt_text', 255)->nullable();
            $table->string('section', 50);
            $table->integer('position')->default(1);
            $table->boolean('is_active')->default(true);
            $table->integer('width')->nullable();
            $table->integer('height')->nullable();
            $table->integer('file_size')->nullable();
            $table->string('mime_type')->nullable();
            $table->foreignId('created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('updated_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('site_images');
    }
};
