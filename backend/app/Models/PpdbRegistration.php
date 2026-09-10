<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Str;

class PpdbRegistration extends Model
{
    use HasFactory;

    protected $table = 'ppdb_registrations';

    protected $fillable = [
        'no_pendaftaran',
        'nama',
        'nisn',
        'email',
        'phone',
        'program',
        'alamat',
        'tanggal_lahir',
        'tempat_lahir',
        'asal_sekolah',
        'berkas_path',
        'berkas_url',
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
        'status',
        'catatan_admin',
        'verified_by',
        'verified_at',
        'jalur_pendaftaran',
    ];

    protected $casts = [
        'tanggal_lahir' => 'date',
        'verified_at'   => 'datetime',
    ];

    /**
     * Generate nomor pendaftaran otomatis: PPDB-YYYY-XXXXXX
     */
    public static function generateNoPendaftaran(): string
    {
        $year   = date('Y');
        $prefix = "PPDB-{$year}-";
        $last   = static::where('no_pendaftaran', 'like', "{$prefix}%")
            ->orderByDesc('id')
            ->first();

        if ($last) {
            $lastNum = (int) Str::after($last->no_pendaftaran, $prefix);
            $newNum  = str_pad($lastNum + 1, 6, '0', STR_PAD_LEFT);
        } else {
            $newNum = '000001';
        }

        return $prefix . $newNum;
    }

    /**
     * Relasi: admin yang memverifikasi
     */
    public function verifier()
    {
        return $this->belongsTo(User::class, 'verified_by');
    }

    /**
     * Label status dalam Bahasa Indonesia
     */
    public function getStatusLabelAttribute(): string
    {
        return match ($this->status) {
            'pending'     => 'Menunggu',
            'verifikasi'  => 'Sedang Diverifikasi',
            'diterima'    => 'Diterima',
            'ditolak'     => 'Ditolak',
            default       => ucfirst($this->status),
        };
    }
}
