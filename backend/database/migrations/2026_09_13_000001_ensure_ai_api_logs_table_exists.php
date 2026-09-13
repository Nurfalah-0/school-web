<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('ai_api_logs')) {
            return;
        }

        Schema::create('ai_api_logs', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('api_provider', 50);
            $table->string('endpoint', 100);
            $table->json('request_data')->nullable();
            $table->json('response_data')->nullable();
            $table->integer('status_code');
            $table->float('response_time');
            $table->integer('tokens_used')->nullable();
            $table->float('cost')->nullable();
            $table->unsignedBigInteger('user_id')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->string('error_message')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('set null');
            $table->index('api_provider');
            $table->index('endpoint');
            $table->index('user_id');
            $table->index('created_at');
            $table->index('status_code');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ai_api_logs');
    }
};
