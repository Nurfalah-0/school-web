<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('ppdb_registrations', function (Blueprint $table) {
            $table->string('kk_path')->nullable()->after('berkas_url');
            $table->string('kk_url')->nullable()->after('kk_path');
            $table->string('ktp_ayah_path')->nullable()->after('kk_url');
            $table->string('ktp_ayah_url')->nullable()->after('ktp_ayah_path');
            $table->string('ktp_ibu_path')->nullable()->after('ktp_ayah_url');
            $table->string('ktp_ibu_url')->nullable()->after('ktp_ibu_path');
            $table->string('akta_kelahiran_path')->nullable()->after('ktp_ibu_url');
            $table->string('akta_kelahiran_url')->nullable()->after('akta_kelahiran_path');
            $table->string('ijazah_menengah_path')->nullable()->after('akta_kelahiran_url');
            $table->string('ijazah_menengah_url')->nullable()->after('ijazah_menengah_path');
            $table->string('dokumen_lain_path')->nullable()->after('ijazah_menengah_url');
            $table->string('dokumen_lain_url')->nullable()->after('dokumen_lain_path');
        });
    }

    public function down(): void
    {
        Schema::table('ppdb_registrations', function (Blueprint $table) {
            $table->dropColumn([
                'kk_path',
                'kk_url',
                'ktp_ayah_path',
                'ktp_ayah_url',
                'ktp_ibu_path',
                'ktp_ibu_url',
                'akta_kelahiran_path',
                'akta_kelahiran_url',
                'ijazah_menengah_path',
                'ijazah_menengah_url',
                'dokumen_lain_path',
                'dokumen_lain_url',
            ]);
        });
    }
};
