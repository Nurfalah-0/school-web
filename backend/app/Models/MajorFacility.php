<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class MajorFacility extends Model
{
    use HasFactory;

    protected $table = 'major_facilities';

    protected $fillable = [
        'major_id',
        'name',
        'description',
        'image',
    ];

    /**
     * Relasi: jurusan yang memiliki fasilitas ini
     */
    public function major()
    {
        return $this->belongsTo(Major::class, 'major_id');
    }
}
