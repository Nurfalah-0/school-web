<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('school_profiles', function (Blueprint $table) {
            $table->unsignedSmallInteger('operating_year')->nullable()->after('founded_year');
            $table->string('nsm', 30)->nullable()->after('npsn');
            $table->string('npwp', 30)->nullable()->after('nsm');
            $table->string('foundation_name', 255)->nullable()->after('operating_year');
            $table->string('village', 100)->nullable()->after('address');
            $table->string('district', 100)->nullable()->after('village');
            $table->string('city', 100)->nullable()->after('district');
        });

        DB::table('school_profiles')->limit(1)->update([
            'school_name' => 'SMK Nurul Jadid (SMKNJ)',
            'founded_year' => 2005,
            'operating_year' => 2008,
            'nsm' => '322052022001',
            'npsn' => '20553240',
            'npwp' => '01.915.650.4-625.005',
            'accreditation' => 'B (90)',
            'foundation_name' => 'Yayasan Nurul Jadid',
            'phone' => '+62-822-6468-2385',
            'email' => 'smknurja.paiton@gmail.com',
            'website' => 'www.smknj.sch.id',
            'address' => 'PO BOX.1 Ponpes Nurul Jadid Paiton Probolinggo 67291',
            'village' => 'Karanganyar',
            'district' => 'Paiton',
            'city' => 'Probolinggo - Jawa Timur',
            'updated_at' => now(),
        ]);
    }

    public function down(): void
    {
        Schema::table('school_profiles', function (Blueprint $table) {
            $table->dropColumn([
                'operating_year',
                'nsm',
                'npwp',
                'foundation_name',
                'village',
                'district',
                'city',
            ]);
        });
    }
};
