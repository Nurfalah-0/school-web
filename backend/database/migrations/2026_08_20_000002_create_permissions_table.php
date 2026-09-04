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
        Schema::create('permissions', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name', 100);
            $table->string('slug', 120)->unique();
            $table->text('description')->nullable();
            $table->string('module', 50)->nullable();
            $table->timestamps();
        });

        // Insert default permissions
        $permissions = [
            // Dashboard permissions
            ['name' => 'View Dashboard', 'slug' => 'dashboard.view', 'description' => 'Can view dashboard', 'module' => 'dashboard'],

            // User management permissions
            ['name' => 'Manage Users', 'slug' => 'users.manage', 'description' => 'Can create, edit, delete users', 'module' => 'users'],
            ['name' => 'View Users', 'slug' => 'users.view', 'description' => 'Can view user list', 'module' => 'users'],

            // Role management permissions
            ['name' => 'Manage Roles', 'slug' => 'roles.manage', 'description' => 'Can manage roles and permissions', 'module' => 'roles'],

            // School profile permissions
            ['name' => 'Manage School Profile', 'slug' => 'school_profile.manage', 'description' => 'Can manage school profile', 'module' => 'school'],

            // Student management permissions
            ['name' => 'Manage Students', 'slug' => 'students.manage', 'description' => 'Can manage student data', 'module' => 'students'],
            ['name' => 'View Students', 'slug' => 'students.view', 'description' => 'Can view student list', 'module' => 'students'],

            // Major management permissions
            ['name' => 'Manage Majors', 'slug' => 'majors.manage', 'description' => 'Can manage majors', 'module' => 'academic'],
            ['name' => 'View Majors', 'slug' => 'majors.view', 'description' => 'Can view majors', 'module' => 'academic'],

            // News management permissions
            ['name' => 'Manage News', 'slug' => 'news.manage', 'description' => 'Can create, edit, delete news', 'module' => 'content'],
            ['name' => 'View News', 'slug' => 'news.view', 'description' => 'Can view news list', 'module' => 'content'],

            // PPDB permissions
            ['name' => 'Manage PPDB', 'slug' => 'ppdb.manage', 'description' => 'Can manage PPDB applications', 'module' => 'ppdb'],
            ['name' => 'View PPDB', 'slug' => 'ppdb.view', 'description' => 'Can view PPDB applications', 'module' => 'ppdb'],

            // PKL permissions
            ['name' => 'Manage PKL', 'slug' => 'pkl.manage', 'description' => 'Can manage PKL programs', 'module' => 'pkl'],
            ['name' => 'View PKL', 'slug' => 'pkl.view', 'description' => 'Can view PKL programs', 'module' => 'pkl'],

            // BKK permissions
            ['name' => 'Manage Job Vacancies', 'slug' => 'jobs.manage', 'description' => 'Can manage job vacancies', 'module' => 'bkk'],
            ['name' => 'View Job Vacancies', 'slug' => 'jobs.view', 'description' => 'Can view job vacancies', 'module' => 'bkk'],

            // TEFA Store permissions
            ['name' => 'Manage TEFA Store', 'slug' => 'tefa_store.manage', 'description' => 'Can manage TEFA store products', 'module' => 'tefa'],
            ['name' => 'View TEFA Store', 'slug' => 'tefa_store.view', 'description' => 'Can view TEFA store products', 'module' => 'tefa'],

            // Settings permissions
            ['name' => 'Manage Settings', 'slug' => 'settings.manage', 'description' => 'Can manage system settings', 'module' => 'settings'],

            // Report permissions
            ['name' => 'View Reports', 'slug' => 'reports.view', 'description' => 'Can view reports', 'module' => 'reports'],
            ['name' => 'Export Reports', 'slug' => 'reports.export', 'description' => 'Can export reports', 'module' => 'reports'],
        ];

        DB::table('permissions')->insert($permissions);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('permissions');
    }
};
