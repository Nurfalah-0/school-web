<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MajorCurriculum extends Model
{
    protected $table = 'major_curricula';

    protected $fillable = [
        'major_id',
        'class_name',
        'color',
        'description',
        'tags',
        'sort_order',
    ];

    protected function casts(): array
    {
        return [
            'tags' => 'array',
            'sort_order' => 'integer',
        ];
    }

    public function major()
    {
        return $this->belongsTo(Major::class, 'major_id');
    }
}
