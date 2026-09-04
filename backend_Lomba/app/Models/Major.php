<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Major extends Model
{
    protected $table = 'majors';

    protected $fillable = [
        'name',
        'code',
        'slug',
        'description',
        'vision',
        'mission',
        'facilities',
        'head_of_major',
        'image',
        'student_count',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
            'student_count' => 'integer',
        ];
    }

    public function students()
    {
        return $this->hasMany(Student::class, 'major_id');
    }
}
