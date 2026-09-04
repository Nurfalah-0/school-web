<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('achievements')) {
            Schema::create('achievements', function (Blueprint $table) {
                $table->id();
                $table->string('title');
                $table->string('slug')->unique();
                $table->string('category', 100)->nullable();
                $table->string('level', 100)->nullable();
                $table->string('organizer', 200)->nullable();
                $table->unsignedSmallInteger('year')->nullable();
                $table->text('description')->nullable();
                $table->string('image')->nullable();
                $table->string('rank', 50)->nullable();
                $table->boolean('is_featured')->default(false);
                $table->boolean('is_published')->default(true);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('galleries')) {
            Schema::create('galleries', function (Blueprint $table) {
                $table->id();
                $table->string('title');
                $table->string('slug')->unique();
                $table->string('category', 100)->nullable();
                $table->text('description')->nullable();
                $table->string('image');
                $table->string('alt_text')->nullable();
                $table->unsignedInteger('sort_order')->default(0);
                $table->boolean('is_featured')->default(false);
                $table->boolean('is_published')->default(true);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('industry_partners')) {
            Schema::create('industry_partners', function (Blueprint $table) {
                $table->id();
                $table->string('company_name', 200);
                $table->string('slug', 220)->unique();
                $table->string('industry_type', 100)->nullable();
                $table->text('address')->nullable();
                $table->string('city', 100)->nullable();
                $table->string('phone', 30)->nullable();
                $table->string('email')->nullable();
                $table->string('website')->nullable();
                $table->string('logo')->nullable();
                $table->text('description')->nullable();
                $table->boolean('is_active')->default(true);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('job_vacancies')) {
            Schema::create('job_vacancies', function (Blueprint $table) {
                $table->id();
                $table->foreignId('industry_partner_id')->nullable();
                $table->string('title', 200);
                $table->string('slug', 220)->unique();
                $table->string('category', 100)->nullable();
                $table->text('description');
                $table->text('requirements')->nullable();
                $table->string('location', 150)->nullable();
                $table->string('employment_type', 50)->default('full-time');
                $table->decimal('salary_min', 15, 2)->nullable();
                $table->decimal('salary_max', 15, 2)->nullable();
                $table->date('deadline')->nullable();
                $table->boolean('is_remote')->default(false);
                $table->string('status', 30)->default('draft');
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('products')) {
            Schema::create('products', function (Blueprint $table) {
                $table->id();
                $table->string('name', 200);
                $table->string('slug', 220)->unique();
                $table->string('sku', 80)->unique();
                $table->string('category', 100)->nullable();
                $table->text('short_description')->nullable();
                $table->longText('description')->nullable();
                $table->decimal('base_price', 15, 2)->nullable();
                $table->decimal('compare_price', 15, 2)->nullable();
                $table->unsignedInteger('stock')->default(0);
                $table->string('image')->nullable();
                $table->string('status', 30)->default('draft');
                $table->boolean('featured')->default(false);
                $table->timestamps();
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('products');
        Schema::dropIfExists('job_vacancies');
        Schema::dropIfExists('industry_partners');
        Schema::dropIfExists('galleries');
        Schema::dropIfExists('achievements');
    }
};
