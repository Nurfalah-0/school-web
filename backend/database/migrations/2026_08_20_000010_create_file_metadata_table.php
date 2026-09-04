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
        Schema::create('file_metadata', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('original_name');
            $table->string('secure_name');
            $table->string('path');
            $table->string('url');
            $table->string('mime_type');
            $table->bigInteger('size');
            $table->string('extension', 20);
            $table->string('type', 50); // student_document, profile_photo, product_image, etc.
            $table->string('description', 500)->nullable();
            $table->unsignedBigInteger('uploaded_by')->nullable();
            $table->unsignedBigInteger('owner_id')->nullable();
            $table->string('owner_type', 100)->nullable(); // App\Models\User, App\Models\Student, etc.
            $table->json('permissions')->nullable(); // JSON dengan role/user access
            $table->string('hash', 64)->nullable(); // File hash untuk integrity check
            $table->boolean('is_encrypted')->default(false);
            $table->string('encryption_key_id')->nullable();
            $table->boolean('is_public')->default(false);
            $table->datetime('expires_at')->nullable();
            $table->integer('download_count')->default(0);
            $table->datetime('last_downloaded_at')->nullable();
            $table->softDeletes();
            $table->timestamps();

            $table->foreign('uploaded_by')->references('id')->on('users')->onDelete('set null');
            $table->index('type');
            $table->index('secure_name');
            $table->index('owner_type');
            $table->index(['owner_type', 'owner_id']);
            $table->index('is_public');
            $table->index('expires_at');
            $table->index('created_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('file_metadata');
    }
};
