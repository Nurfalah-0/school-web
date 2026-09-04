<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Role;
use App\Models\Permission;
use Carbon\Carbon;

class SchoolSystemSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Clear existing data
        DB::statement('SET FOREIGN_KEY_CHECKS=0');
        DB::table('user_roles')->truncate();
        DB::table('role_permissions')->truncate();
        DB::table('permissions')->truncate();
        DB::table('roles')->truncate();
        DB::table('users')->truncate();
        DB::statement('SET FOREIGN_KEY_CHECKS=1');

        // Create permissions
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

        foreach ($permissions as $permission) {
            Permission::create($permission);
        }

        // Create roles
        $roles = [
            ['name' => 'superadmin', 'description' => 'Super Administrator - Full access'],
            ['name' => 'admin_sekolah', 'description' => 'Admin Sekolah - School management'],
            ['name' => 'tu_sekolah', 'description' => 'Tata Usaha Sekolah - Administration'],
            ['name' => 'guru', 'description' => 'Guru - Teacher'],
            ['name' => 'siswa', 'description' => 'Siswa - Student'],
            ['name' => 'ppdb', 'description' => 'Admin PPDB - PPDB management'],
            ['name' => 'bkk', 'description' => 'Admin BKK - Career center'],
        ];

        foreach ($roles as $role) {
            Role::create($role);
        }

        // Assign permissions to roles
        $superadminRole = Role::where('name', 'superadmin')->first();
        $superadminRole->permissions()->sync(Permission::pluck('id')->toArray());

        $adminSekolahRole = Role::where('name', 'admin_sekolah')->first();
        $adminSekolahPermissions = Permission::whereIn('slug', [
            'dashboard.view',
            'users.view',
            'users.manage',
            'school_profile.manage',
            'students.manage',
            'students.view',
            'majors.manage',
            'majors.view',
            'news.manage',
            'news.view',
            'reports.view',
            'reports.export',
        ])->pluck('id')->toArray();
        $adminSekolahRole->permissions()->sync($adminSekolahPermissions);

        $tuSekolahRole = Role::where('name', 'tu_sekolah')->first();
        $tuSekolahPermissions = Permission::whereIn('slug', [
            'dashboard.view',
            'students.view',
            'students.manage',
            'reports.view',
        ])->pluck('id')->toArray();
        $tuSekolahRole->permissions()->sync($tuSekolahPermissions);

        $ppdbRole = Role::where('name', 'ppdb')->first();
        $ppdbPermissions = Permission::whereIn('slug', [
            'dashboard.view',
            'ppdb.manage',
            'ppdb.view',
            'students.view',
        ])->pluck('id')->toArray();
        $ppdbRole->permissions()->sync($ppdbPermissions);

        $bkkRole = Role::where('name', 'bkk')->first();
        $bkkPermissions = Permission::whereIn('slug', [
            'dashboard.view',
            'jobs.manage',
            'jobs.view',
            'pkl.manage',
            'pkl.view',
        ])->pluck('id')->toArray();
        $bkkRole->permissions()->sync($bkkPermissions);

        $guruRole = Role::where('name', 'guru')->first();
        $guruPermissions = Permission::whereIn('slug', [
            'dashboard.view',
            'students.view',
            'reports.view',
        ])->pluck('id')->toArray();
        $guruRole->permissions()->sync($guruPermissions);

        $siswaRole = Role::where('name', 'siswa')->first();
        $siswaPermissions = Permission::whereIn('slug', [
            'dashboard.view',
        ])->pluck('id')->toArray();
        $siswaRole->permissions()->sync($siswaPermissions);

        // Create default users
        $superadmin = User::create([
            'name' => 'Super Administrator',
            'email' => 'superadmin@smknuruljadid.sch.id',
            'password' => Hash::make('password123'),
            'phone' => '081234567890',
            'is_active' => true,
            'last_login_at' => Carbon::now(),
            'last_password_change' => Carbon::now(),
        ]);
        $superadmin->roles()->attach($superadminRole->id);

        $adminSekolah = User::create([
            'name' => 'Admin Sekolah',
            'email' => 'admin@smknuruljadid.sch.id',
            'password' => Hash::make('password123'),
            'phone' => '081234567891',
            'is_active' => true,
            'last_login_at' => Carbon::now(),
            'last_password_change' => Carbon::now(),
        ]);
        $adminSekolah->roles()->attach($adminSekolahRole->id);

        $tuSekolah = User::create([
            'name' => 'Tata Usaha Sekolah',
            'email' => 'tu@smknuruljadid.sch.id',
            'password' => Hash::make('password123'),
            'phone' => '081234567892',
            'is_active' => true,
            'last_login_at' => Carbon::now(),
            'last_password_change' => Carbon::now(),
        ]);
        $tuSekolah->roles()->attach($tuSekolahRole->id);

        $guru = User::create([
            'name' => 'Guru Contoh',
            'email' => 'guru@smknuruljadid.sch.id',
            'password' => Hash::make('password123'),
            'phone' => '081234567893',
            'is_active' => true,
            'last_login_at' => Carbon::now(),
            'last_password_change' => Carbon::now(),
        ]);
        $guru->roles()->attach($guruRole->id);

        $ppdbAdmin = User::create([
            'name' => 'Admin PPDB',
            'email' => 'ppdb@smknuruljadid.sch.id',
            'password' => Hash::make('password123'),
            'phone' => '081234567894',
            'is_active' => true,
            'last_login_at' => Carbon::now(),
            'last_password_change' => Carbon::now(),
        ]);
        $ppdbAdmin->roles()->attach($ppdbRole->id);

        $bkkAdmin = User::create([
            'name' => 'Admin BKK',
            'email' => 'bkk@smknuruljadid.sch.id',
            'password' => Hash::make('password123'),
            'phone' => '081234567895',
            'is_active' => true,
            'last_login_at' => Carbon::now(),
            'last_password_change' => Carbon::now(),
        ]);
        $bkkAdmin->roles()->attach($bkkRole->id);

        // Create sample student user
        $student = User::create([
            'name' => 'Ahmad Santoso',
            'email' => 'ahmad@student.smknj.sch.id',
            'password' => Hash::make('password123'),
            'phone' => '081234567896',
            'is_active' => true,
            'last_login_at' => Carbon::now(),
            'last_password_change' => Carbon::now(),
        ]);
        $student->roles()->attach($siswaRole->id);

        $this->command->info('School system data seeded successfully!');
        $this->command->info('Superadmin: superadmin@smknuruljadid.sch.id / password123');
        $this->command->info('Admin Sekolah: admin@smknuruljadid.sch.id / password123');
        $this->command->info('TU Sekolah: tu@smknuruljadid.sch.id / password123');
    }
}
