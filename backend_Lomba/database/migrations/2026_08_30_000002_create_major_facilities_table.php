<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('major_facilities')) {
            Schema::create('major_facilities', function (Blueprint $table) {
                $table->bigIncrements('id');
                $table->unsignedBigInteger('major_id');
                $table->string('name');
                $table->text('description')->nullable();
                $table->string('image')->nullable();
                $table->timestamps();

                $table->foreign('major_id')
                      ->references('id')
                      ->on('majors')
                      ->onDelete('cascade');
                $table->index('major_id');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('major_facilities');
    }
};
