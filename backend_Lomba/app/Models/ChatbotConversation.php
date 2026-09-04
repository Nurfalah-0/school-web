<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChatbotConversation extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'session_id',
        'user_id',
        'ip_address',
        'user_agent',
        'context',
        'metadata',
        'message_count',
        'started_at',
        'last_activity_at',
        'ended_at',
        'is_active',
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
            'started_at' => 'datetime',
            'last_activity_at' => 'datetime',
            'ended_at' => 'datetime',
            'is_active' => 'boolean',
            'message_count' => 'integer',
        ];
    }

    /**
     * Get the user that owns the conversation.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the messages for the conversation.
     */
    public function messages()
    {
        return $this->hasMany(ChatbotMessage::class);
    }

    /**
     * Get the last message in the conversation.
     */
    public function lastMessage()
    {
        return $this->hasOne(ChatbotMessage::class)->latest();
    }

    /**
     * Scope a query to only include active conversations.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope a query to only include conversations by user.
     */
    public function scopeByUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    /**
     * Scope a query to only include conversations by context.
     */
    public function scopeByContext($query, $context)
    {
        return $query->where('context', $context);
    }

    /**
     * Scope a query to only include conversations older than specified minutes.
     */
    public function scopeOlderThan($query, $minutes)
    {
        return $query->where('last_activity_at', '<', now()->subMinutes($minutes));
    }

    /**
     * Check if conversation is expired.
     */
    public function isExpired($timeoutMinutes = 30)
    {
        return $this->last_activity_at->diffInMinutes(now()) > $timeoutMinutes;
    }

    /**
     * Get conversation duration in minutes.
     */
    public function getDurationAttribute()
    {
        if (!$this->ended_at) {
            return $this->started_at->diffInMinutes(now());
        }

        return $this->started_at->diffInMinutes($this->ended_at);
    }

    /**
     * Get conversation duration in human readable format.
     */
    public function getHumanDurationAttribute()
    {
        $minutes = $this->duration;

        if ($minutes < 60) {
            return $minutes . ' menit';
        }

        $hours = floor($minutes / 60);
        $remainingMinutes = $minutes % 60;

        if ($remainingMinutes > 0) {
            return $hours . ' jam ' . $remainingMinutes . ' menit';
        }

        return $hours . ' jam';
    }

    /**
     * End the conversation.
     */
    public function end($reason = 'user_request')
    {
        $this->update([
            'is_active' => false,
            'ended_at' => now(),
            'metadata' => array_merge($this->metadata ?? [], [
                'end_reason' => $reason,
                'end_timestamp' => now()->toDateTimeString(),
            ]),
        ]);
    }

    /**
     * Get user agent information.
     */
    public function getUserAgentInfoAttribute()
    {
        $ua = $this->user_agent;

        if (!$ua) {
            return null;
        }

        $info = [
            'browser' => 'Unknown',
            'platform' => 'Unknown',
            'device' => 'Desktop',
        ];

        // Simple detection (bisa diperbaiki dengan package seperti jenssegers/agent)
        if (strpos($ua, 'Chrome') !== false) {
            $info['browser'] = 'Chrome';
        } elseif (strpos($ua, 'Firefox') !== false) {
            $info['browser'] = 'Firefox';
        } elseif (strpos($ua, 'Safari') !== false) {
            $info['browser'] = 'Safari';
        } elseif (strpos($ua, 'Edge') !== false) {
            $info['browser'] = 'Edge';
        }

        if (strpos($ua, 'Windows') !== false) {
            $info['platform'] = 'Windows';
        } elseif (strpos($ua, 'Mac') !== false) {
            $info['platform'] = 'macOS';
        } elseif (strpos($ua, 'Linux') !== false) {
            $info['platform'] = 'Linux';
        } elseif (strpos($ua, 'Android') !== false) {
            $info['platform'] = 'Android';
        } elseif (strpos($ua, 'iPhone') !== false || strpos($ua, 'iPad') !== false) {
            $info['platform'] = 'iOS';
        }

        if (strpos($ua, 'Mobile') !== false || strpos($ua, 'Android') !== false || strpos($ua, 'iPhone') !== false) {
            $info['device'] = 'Mobile';
        } elseif (strpos($ua, 'Tablet') !== false || strpos($ua, 'iPad') !== false) {
            $info['device'] = 'Tablet';
        }

        return $info;
    }
}
