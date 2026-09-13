<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ActivityLog extends Model
{
    protected $fillable = [
        'log_name',
        'description',
        'subject_type',
        'subject_id',
        'event',
        'causer_id',
        'causer_type',
        'properties',
        'ip_address',
        'user_agent',
        'browser',
        'platform',
        'device',
    ];

    protected $casts = [
        'properties' => 'array',
    ];
}