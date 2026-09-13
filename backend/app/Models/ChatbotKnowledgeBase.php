<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChatbotKnowledgeBase extends Model
{
    protected $table = 'chatbot_knowledge_base';

    protected $fillable = [
        'category', 'question', 'answer', 'keywords', 'source', 'priority',
        'is_active', 'usage_count', 'last_used_at', 'created_by', 'updated_by',
    ];

    protected function casts(): array
    {
        return [
            'keywords' => 'array',
            'is_active' => 'boolean',
            'last_used_at' => 'datetime',
        ];
    }
}