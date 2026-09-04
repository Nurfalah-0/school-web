<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChatbotMessage extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'conversation_id',
        'sender',
        'message',
        'metadata',
        'ai_model',
        'tokens_used',
        'response_time',
        'message_type',
        'is_flagged',
        'flag_reason',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'metadata' => 'array',
            'tokens_used' => 'integer',
            'response_time' => 'float',
            'is_flagged' => 'boolean',
        ];
    }

    /**
     * Get the conversation that owns the message.
     */
    public function conversation()
    {
        return $this->belongsTo(ChatbotConversation::class);
    }

    /**
     * Scope a query to only include messages by sender.
     */
    public function scopeBySender($query, $sender)
    {
        return $query->where('sender', $sender);
    }

    /**
     * Scope a query to only include messages by AI model.
     */
    public function scopeByAiModel($query, $model)
    {
        return $query->where('ai_model', $model);
    }

    /**
     * Scope a query to only include flagged messages.
     */
    public function scopeFlagged($query)
    {
        return $query->where('is_flagged', true);
    }

    /**
     * Scope a query to only include messages from today.
     */
    public function scopeToday($query)
    {
        return $query->whereDate('created_at', today());
    }

    /**
     * Get message length.
     */
    public function getLengthAttribute()
    {
        return strlen($this->message);
    }

    /**
     * Get word count.
     */
    public function getWordCountAttribute()
    {
        return str_word_count($this->message);
    }

    /**
     * Check if message is from user.
     */
    public function getIsFromUserAttribute()
    {
        return $this->sender === 'user';
    }

    /**
     * Check if message is from bot.
     */
    public function getIsFromBotAttribute()
    {
        return $this->sender === 'bot';
    }

    /**
     * Check if message is from system.
     */
    public function getIsFromSystemAttribute()
    {
        return $this->sender === 'system';
    }

    /**
     * Get formatted response time.
     */
    public function getFormattedResponseTimeAttribute()
    {
        if (!$this->response_time) {
            return 'N/A';
        }

        if ($this->response_time < 1) {
            return round($this->response_time * 1000) . 'ms';
        }

        return round($this->response_time, 2) . 's';
    }

    /**
     * Flag the message.
     */
    public function flag($reason)
    {
        $this->update([
            'is_flagged' => true,
            'flag_reason' => $reason,
        ]);
    }

    /**
     * Unflag the message.
     */
    public function unflag()
    {
        $this->update([
            'is_flagged' => false,
            'flag_reason' => null,
        ]);
    }

    /**
     * Get truncated message for preview.
     */
    public function getPreviewAttribute($length = 100)
    {
        if (strlen($this->message) <= $length) {
            return $this->message;
        }

        return substr($this->message, 0, $length) . '...';
    }

    /**
     * Get message timestamp in human readable format.
     */
    public function getHumanTimeAttribute()
    {
        return $this->created_at->diffForHumans();
    }

    /**
     * Check if message contains specific keywords.
     */
    public function containsKeywords($keywords)
    {
        if (!is_array($keywords)) {
            $keywords = [$keywords];
        }

        foreach ($keywords as $keyword) {
            if (stripos($this->message, $keyword) !== false) {
                return true;
            }
        }

        return false;
    }

    /**
     * Get estimated cost for AI-generated message.
     */
    public function getEstimatedCostAttribute()
    {
        if (!$this->tokens_used || !$this->ai_model) {
            return 0;
        }

        // Harga per token berdasarkan model (contoh)
        $prices = [
            'gpt-4' => 0.00003, // $0.03 per 1K tokens
            'gpt-3.5-turbo' => 0.0000015,
            'claude-3-opus' => 0.000075,
            'claude-3-sonnet' => 0.000015,
            'claude-3-haiku' => 0.000001,
            'gemini-pro' => 0.0000005,
            'knowledge_base' => 0,
        ];

        $pricePerToken = $prices[$this->ai_model] ?? 0.000001;
        return $this->tokens_used * $pricePerToken;
    }
}
