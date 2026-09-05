<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SecurityAlert extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'alert_type',
        'severity',
        'description',
        'details',
        'ip_address',
        'user_agent',
        'user_id',
        'endpoint',
        'method',
        'request_data',
        'is_resolved',
        'resolution_notes',
        'resolved_by',
        'resolved_at',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'request_data',
    ];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'details' => 'array',
            'request_data' => 'array',
            'is_resolved' => 'boolean',
            'resolved_at' => 'datetime',
        ];
    }

    /**
     * Alert types and severity levels
     */
    public const ALERT_TYPES = [
        'brute_force' => 'Brute Force Attack',
        'sql_injection' => 'SQL Injection Attempt',
        'xss' => 'Cross-Site Scripting (XSS) Attempt',
        'csrf' => 'CSRF Attack Attempt',
        'file_upload' => 'Malicious File Upload Attempt',
        'rate_limit' => 'Rate Limit Exceeded',
        'unauthorized_access' => 'Unauthorized Access Attempt',
        'suspicious_activity' => 'Suspicious Activity',
        'data_breach' => 'Potential Data Breach',
        'account_takeover' => 'Account Takeover Attempt',
    ];

    public const SEVERITY_LEVELS = [
        'low' => 'Low',
        'medium' => 'Medium',
        'high' => 'High',
        'critical' => 'Critical',
    ];

    /**
     * Get the user associated with the alert.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the admin who resolved the alert.
     */
    public function resolver()
    {
        return $this->belongsTo(User::class, 'resolved_by');
    }

    /**
     * Scope a query to only include unresolved alerts.
     */
    public function scopeUnresolved($query)
    {
        return $query->where('is_resolved', false);
    }

    /**
     * Scope a query to only include alerts by severity.
     */
    public function scopeBySeverity($query, $severity)
    {
        return $query->where('severity', $severity);
    }

    /**
     * Scope a query to only include alerts by type.
     */
    public function scopeByType($query, $type)
    {
        return $query->where('alert_type', $type);
    }

    /**
     * Scope a query to only include alerts from today.
     */
    public function scopeToday($query)
    {
        return $query->whereDate('created_at', today());
    }

    /**
     * Get alert type description.
     */
    public function getAlertTypeDescriptionAttribute()
    {
        return self::ALERT_TYPES[$this->alert_type] ?? $this->alert_type;
    }

    /**
     * Get severity description.
     */
    public function getSeverityDescriptionAttribute()
    {
        return self::SEVERITY_LEVELS[$this->severity] ?? $this->severity;
    }

    /**
     * Get severity color for UI.
     */
    public function getSeverityColorAttribute()
    {
        $colors = [
            'low' => 'info',
            'medium' => 'warning',
            'high' => 'danger',
            'critical' => 'dark',
        ];

        return $colors[$this->severity] ?? 'secondary';
    }

    /**
     * Check if alert is critical.
     */
    public function getIsCriticalAttribute()
    {
        return $this->severity === 'critical';
    }

    /**
     * Check if alert is high severity.
     */
    public function getIsHighAttribute()
    {
        return in_array($this->severity, ['high', 'critical']);
    }

    /**
     * Get formatted created time.
     */
    public function getCreatedTimeAttribute()
    {
        return $this->created_at->format('Y-m-d H:i:s');
    }

    /**
     * Get human readable time since alert was created.
     */
    public function getTimeSinceCreatedAttribute()
    {
        return $this->created_at->diffForHumans();
    }

    /**
     * Mark alert as resolved.
     */
    public function markAsResolved($notes = null, $resolverId = null)
    {
        $this->update([
            'is_resolved' => true,
            'resolution_notes' => $notes,
            'resolved_by' => $resolverId,
            'resolved_at' => now(),
        ]);
    }

    /**
     * Get user agent information.
     */
    public function getUserAgentInfoAttribute()
    {
        if (!$this->user_agent) {
            return null;
        }

        $info = [
            'browser' => 'Unknown',
            'platform' => 'Unknown',
            'device' => 'Desktop',
        ];

        if (strpos($this->user_agent, 'Chrome') !== false) {
            $info['browser'] = 'Chrome';
        } elseif (strpos($this->user_agent, 'Firefox') !== false) {
            $info['browser'] = 'Firefox';
        } elseif (strpos($this->user_agent, 'Safari') !== false) {
            $info['browser'] = 'Safari';
        } elseif (strpos($this->user_agent, 'Edge') !== false) {
            $info['browser'] = 'Edge';
        }

        if (strpos($this->user_agent, 'Windows') !== false) {
            $info['platform'] = 'Windows';
        } elseif (strpos($this->user_agent, 'Mac') !== false) {
            $info['platform'] = 'macOS';
        } elseif (strpos($this->user_agent, 'Linux') !== false) {
            $info['platform'] = 'Linux';
        } elseif (strpos($this->user_agent, 'Android') !== false) {
            $info['platform'] = 'Android';
        } elseif (strpos($this->user_agent, 'iPhone') !== false || strpos($this->user_agent, 'iPad') !== false) {
            $info['platform'] = 'iOS';
        }

        if (strpos($this->user_agent, 'Mobile') !== false || strpos($this->user_agent, 'Android') !== false || strpos($this->user_agent, 'iPhone') !== false) {
            $info['device'] = 'Mobile';
        } elseif (strpos($this->user_agent, 'Tablet') !== false || strpos($this->user_agent, 'iPad') !== false) {
            $info['device'] = 'Tablet';
        }

        return $info;
    }

    /**
     * Get alert summary for notification.
     */
    public function getSummaryAttribute()
    {
        return sprintf(
            '[%s] %s - IP: %s - Time: %s',
            strtoupper($this->severity),
            $this->alert_type_description,
            $this->ip_address,
            $this->created_time
        );
    }

    /**
     * Check if alert should trigger notification.
     */
    public function shouldNotify()
    {
        return in_array($this->severity, ['high', 'critical']) && !$this->is_resolved;
    }

    /**
     * Get related data for investigation.
     */
    public function getInvestigationDataAttribute()
    {
        return [
            'alert_id' => $this->id,
            'alert_type' => $this->alert_type,
            'severity' => $this->severity,
            'ip_address' => $this->ip_address,
            'user_id' => $this->user_id,
            'endpoint' => $this->endpoint,
            'method' => $this->method,
            'user_agent_info' => $this->user_agent_info,
            'created_at' => $this->created_time,
            'details' => $this->details,
        ];
    }
}
