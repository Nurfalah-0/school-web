<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('major_curricula')) {
            Schema::create('major_curricula', function (Blueprint $table) {
                $table->bigIncrements('id');
                $table->unsignedBigInteger('major_id');
                $table->string('class_name', 150);
                $table->string('color', 20)->default('navy');
                $table->text('description');
                $table->json('tags')->nullable();
                $table->unsignedInteger('sort_order')->default(0);
                $table->timestamps();

                $table->foreign('major_id')
                    ->references('id')
                    ->on('majors')
                    ->onDelete('cascade');
                $table->index(['major_id', 'sort_order']);
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('major_curricula');
    }
};
