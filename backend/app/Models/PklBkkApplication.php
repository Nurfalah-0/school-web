<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PklBkkApplication extends Model
{
    protected $fillable = [
        'name',
        'email',
        'nisn',
        'program',
        'cv_path',
        'cv_original_name',
        'status',
    ];
}