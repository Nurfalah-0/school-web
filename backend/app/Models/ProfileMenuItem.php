<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProfileMenuItem extends Model
{
    protected $fillable = [
        'label',
        'description',
        'path',
        'hash',
        'icon',
        'position',
        'is_active',
        'created_by',
        'updated_by',
    ];

    protected function casts(): array
    {
        return [
            'position' => 'integer',
            'is_active' => 'boolean',
        ];
    }
}
