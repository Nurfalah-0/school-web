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
        Schema::create('chatbot_conversations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('session_id', 100)->unique();
            $table->unsignedBigInteger('user_id')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->string('user_agent', 500)->nullable();
            $table->string('context', 50)->nullable(); // general, ppdb, academic, etc.
            $table->json('metadata')->nullable();
            $table->integer('message_count')->default(0);
            $table->datetime('started_at');
            $table->datetime('last_activity_at');
            $table->datetime('ended_at')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('set null');
            $table->index('session_id');
            $table->index('user_id');
            $table->index('context');
            $table->index('is_active');
            $table->index('last_activity_at');
        });

        Schema::create('chatbot_messages', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('conversation_id');
            $table->enum('sender', ['user', 'bot', 'system']);
            $table->text('message');
            $table->json('metadata')->nullable();
            $table->string('ai_model')->nullable();
            $table->integer('tokens_used')->nullable();
            $table->float('response_time')->nullable();
            $table->string('message_type', 50)->default('text'); // text, image, file, etc.
            $table->boolean('is_flagged')->default(false);
            $table->string('flag_reason')->nullable();
            $table->timestamps();

            $table->foreign('conversation_id')->references('id')->on('chatbot_conversations')->onDelete('cascade');
            $table->index('conversation_id');
            $table->index('sender');
            $table->index('created_at');
            $table->index('is_flagged');
        });

        Schema::create('chatbot_knowledge_base', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('category', 100);
            $table->string('question');
            $table->text('answer');
            $table->json('keywords')->nullable();
            $table->string('source')->nullable();
            $table->integer('priority')->default(1);
            $table->boolean('is_active')->default(true);
            $table->integer('usage_count')->default(0);
            $table->datetime('last_used_at')->nullable();
            $table->unsignedBigInteger('created_by')->nullable();
            $table->unsignedBigInteger('updated_by')->nullable();
            $table->timestamps();

            $table->foreign('created_by')->references('id')->on('users')->onDelete('set null');
            $table->foreign('updated_by')->references('id')->on('users')->onDelete('set null');
            $table->index('category');
            $table->index('question');
            $table->index('is_active');
            $table->index('priority');
            $table->fulltext(['question', 'answer']);
        });

        Schema::create('ai_api_logs', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('api_provider', 50); // openai, anthropic, google, etc.
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

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ai_api_logs');
        Schema::dropIfExists('chatbot_knowledge_base');
        Schema::dropIfExists('chatbot_messages');
        Schema::dropIfExists('chatbot_conversations');
    }
};
