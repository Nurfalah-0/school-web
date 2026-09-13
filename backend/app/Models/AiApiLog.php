<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AiApiLog extends Model
{
    protected $fillable = [
        'api_provider', 'endpoint', 'request_data', 'response_data', 'status_code',
        'response_time', 'tokens_used', 'cost', 'user_id', 'ip_address', 'error_message',
    ];

    protected function casts(): array
    {
        return [
            'request_data' => 'array',
            'response_data' => 'array',
            'response_time' => 'float',
            'tokens_used' => 'integer',
            'cost' => 'float',
        ];
    }
}