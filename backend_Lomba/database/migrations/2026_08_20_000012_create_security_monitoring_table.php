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
        Schema::create('security_alerts', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('alert_type', 50); // brute_force, sql_injection, xss, etc.
            $table->string('severity', 20); // low, medium, high, critical
            $table->text('description');
            $table->json('details')->nullable();
            $table->string('ip_address', 45);
            $table->string('user_agent', 500)->nullable();
            $table->unsignedBigInteger('user_id')->nullable();
            $table->string('endpoint', 255)->nullable();
            $table->string('method', 10)->nullable();
            $table->json('request_data')->nullable();
            $table->boolean('is_resolved')->default(false);
            $table->string('resolution_notes')->nullable();
            $table->unsignedBigInteger('resolved_by')->nullable();
            $table->datetime('resolved_at')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('set null');
            $table->foreign('resolved_by')->references('id')->on('users')->onDelete('set null');
            $table->index('alert_type');
            $table->index('severity');
            $table->index('ip_address');
            $table->index('is_resolved');
            $table->index('created_at');
        });

        Schema::create('api_rate_limits', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('api_key', 64)->nullable();
            $table->string('endpoint', 255);
            $table->string('ip_address', 45);
            $table->integer('request_count')->default(0);
            $table->datetime('window_start');
            $table->datetime('window_end');
            $table->boolean('is_blocked')->default(false);
            $table->string('block_reason')->nullable();
            $table->datetime('blocked_until')->nullable();
            $table->timestamps();

            $table->index('api_key');
            $table->index('ip_address');
            $table->index('endpoint');
            $table->index('window_start');
            $table->index('window_end');
            $table->index('is_blocked');
        });

        Schema::create('security_configurations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('config_key', 100)->unique();
            $table->text('config_value');
            $table->string('data_type', 20)->default('string'); // string, integer, boolean, json
            $table->string('category', 50); // authentication, rate_limiting, logging, etc.
            $table->text('description')->nullable();
            $table->boolean('is_active')->default(true);
            $table->unsignedBigInteger('updated_by')->nullable();
            $table->timestamps();

            $table->foreign('updated_by')->references('id')->on('users')->onDelete('set null');
            $table->index('config_key');
            $table->index('category');
            $table->index('is_active');
        });

        // Insert default security configurations
        DB::table('security_configurations')->insert([
            [
                'config_key' => 'max_login_attempts',
                'config_value' => '5',
                'data_type' => 'integer',
                'category' => 'authentication',
                'description' => 'Maximum number of failed login attempts before account lock',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'config_key' => 'account_lockout_minutes',
                'config_value' => '15',
                'data_type' => 'integer',
                'category' => 'authentication',
                'description' => 'Number of minutes to lock account after too many failed attempts',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'config_key' => 'password_min_length',
                'config_value' => '8',
                'data_type' => 'integer',
                'category' => 'authentication',
                'description' => 'Minimum password length',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'config_key' => 'password_expiry_days',
                'config_value' => '90',
                'data_type' => 'integer',
                'category' => 'authentication',
                'description' => 'Number of days before password expires',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'config_key' => 'api_rate_limit_per_minute',
                'config_value' => '60',
                'data_type' => 'integer',
                'category' => 'rate_limiting',
                'description' => 'Maximum API requests per minute per IP',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'config_key' => 'enable_two_factor_auth',
                'config_value' => 'false',
                'data_type' => 'boolean',
                'category' => 'authentication',
                'description' => 'Enable two-factor authentication for all users',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'config_key' => 'session_timeout_minutes',
                'config_value' => '120',
                'data_type' => 'integer',
                'category' => 'authentication',
                'description' => 'Session timeout in minutes',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'config_key' => 'enable_login_notifications',
                'config_value' => 'true',
                'data_type' => 'boolean',
                'category' => 'logging',
                'description' => 'Send email notifications for successful logins from new devices',
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('security_configurations');
        Schema::dropIfExists('api_rate_limits');
        Schema::dropIfExists('security_alerts');
    }
};
