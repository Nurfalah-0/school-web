<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use App\Models\SecurityAlert;
use App\Models\User;
use App\Models\LoginAttempt;
use App\Models\ActivityLog;
use App\Helpers\SecurityHelper;
use Carbon\Carbon;

class SecurityController extends Controller
{
    /**
     * Get security dashboard statistics
     */
    public function getSecurityStats(Request $request)
    {
        try {
            $user = $request->user();

            // Hanya superadmin dan admin sekolah yang bisa melihat security stats
            if (!$user->hasAnyRole(['superadmin', 'admin_sekolah'])) {
                return response()->json(['message' => 'Anda tidak memiliki izin untuk melihat statistik keamanan'], 403);
            }

            $timeRange = $request->time_range ?? '7d'; // 1d, 7d, 30d
            $startDate = Carbon::now()->subDays((int)$timeRange);

            $stats = [
                'alerts' => [
                    'total' => SecurityAlert::count(),
                    'unresolved' => SecurityAlert::where('is_resolved', false)->count(),
                    'today' => SecurityAlert::whereDate('created_at', Carbon::today())->count(),
                    'by_severity' => SecurityAlert::selectRaw('severity, count(*) as count')
                        ->where('created_at', '>=', $startDate)
                        ->groupBy('severity')
                        ->get(),
                    'by_type' => SecurityAlert::selectRaw('alert_type, count(*) as count')
                        ->where('created_at', '>=', $startDate)
                        ->groupBy('alert_type')
                        ->orderBy('count', 'desc')
                        ->limit(10)
                        ->get(),
                ],
                'login_attempts' => [
                    'total' => LoginAttempt::count(),
                    'failed_today' => LoginAttempt::whereDate('created_at', Carbon::today())
                        ->where('successful', false)
                        ->count(),
                    'failed_recent' => LoginAttempt::where('created_at', '>=', $startDate)
                        ->where('successful', false)
                        ->count(),
                    'top_ips_failed' => LoginAttempt::selectRaw('ip_address, count(*) as count')
                        ->where('created_at', '>=', $startDate)
                        ->where('successful', false)
                        ->groupBy('ip_address')
                        ->orderBy('count', 'desc')
                        ->limit(10)
                        ->get(),
                ],
                'users' => [
                    'total' => User::count(),
                    'active' => User::where('is_active', true)->count(),
                    'inactive' => User::where('is_active', false)->count(),
                    'locked' => User::where('login_attempts', '>=', 5)->count(),
                    'new_today' => User::whereDate('created_at', Carbon::today())->count(),
                ],
                'activity' => [
                    'total_logs' => ActivityLog::count(),
                    'logs_today' => ActivityLog::whereDate('created_at', Carbon::today())->count(),
                    'top_activities' => ActivityLog::selectRaw('event, count(*) as count')
                        ->where('created_at', '>=', $startDate)
                        ->groupBy('event')
                        ->orderBy('count', 'desc')
                        ->limit(10)
                        ->get(),
                ],
                'time_range' => $timeRange . ' days',
                'start_date' => $startDate->toDateString(),
                'end_date' => Carbon::now()->toDateString(),
            ];

            return response()->json($stats, 200);

        } catch (\Exception $e) {
            Log::error('Get security stats error: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil statistik keamanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get security alerts with filtering
     */
    public function getAlerts(Request $request)
    {
        try {
            $user = $request->user();

            // Hanya superadmin dan admin sekolah yang bisa melihat alerts
            if (!$user->hasAnyRole(['superadmin', 'admin_sekolah'])) {
                return response()->json(['message' => 'Anda tidak memiliki izin untuk melihat alert keamanan'], 403);
            }

            $validator = Validator::make($request->all(), [
                'severity' => 'sometimes|in:low,medium,high,critical',
                'type' => 'sometimes|string',
                'resolved' => 'sometimes|boolean',
                'start_date' => 'sometimes|date',
                'end_date' => 'sometimes|date',
                'page' => 'sometimes|integer|min:1',
                'per_page' => 'sometimes|integer|min:1|max:100',
            ]);

            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 422);
            }

            $query = SecurityAlert::query();

            // Apply filters
            if ($request->has('severity')) {
                $query->where('severity', $request->severity);
            }

            if ($request->has('type')) {
                $query->where('alert_type', $request->type);
            }

            if ($request->has('resolved')) {
                $query->where('is_resolved', $request->resolved);
            }

            if ($request->has('start_date')) {
                $query->whereDate('created_at', '>=', $request->start_date);
            }

            if ($request->has('end_date')) {
                $query->whereDate('created_at', '<=', $request->end_date);
            }

            $perPage = $request->per_page ?? 20;
            $alerts = $query->with(['user', 'resolver'])
                ->orderBy('created_at', 'desc')
                ->paginate($perPage);

            return response()->json([
                'alerts' => $alerts,
                'filters' => $request->all(),
                'total' => $alerts->total(),
                'unresolved_count' => SecurityAlert::where('is_resolved', false)->count(),
            ], 200);

        } catch (\Exception $e) {
            Log::error('Get security alerts error: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil alert keamanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get alert details
     */
    public function getAlertDetails($id)
    {
        try {
            $user = request()->user();

            // Hanya superadmin dan admin sekolah yang bisa melihat alert details
            if (!$user->hasAnyRole(['superadmin', 'admin_sekolah'])) {
                return response()->json(['message' => 'Anda tidak memiliki izin untuk melihat detail alert'], 403);
            }

            $alert = SecurityAlert::with(['user', 'resolver'])->find($id);

            if (!$alert) {
                return response()->json(['message' => 'Alert tidak ditemukan'], 404);
            }

            // Get related login attempts for this IP
            $relatedLogins = LoginAttempt::where('ip_address', $alert->ip_address)
                ->where('created_at', '>=', Carbon::now()->subDays(7))
                ->orderBy('created_at', 'desc')
                ->limit(20)
                ->get();

            // Get related activity logs for this IP/user
            $relatedActivities = ActivityLog::where('ip_address', $alert->ip_address)
                ->orWhere('causer_id', $alert->user_id)
                ->where('created_at', '>=', Carbon::now()->subDays(7))
                ->orderBy('created_at', 'desc')
                ->limit(20)
                ->get();

            return response()->json([
                'alert' => $alert,
                'related_data' => [
                    'login_attempts' => $relatedLogins,
                    'activity_logs' => $relatedActivities,
                    'ip_info' => $this->getIpInfo($alert->ip_address),
                    'user_agent_info' => $alert->user_agent_info,
                ],
            ], 200);

        } catch (\Exception $e) {
            Log::error('Get alert details error: ' . $e->getMessage(), [
                'alert_id' => $id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil detail alert',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Resolve security alert
     */
    public function resolveAlert(Request $request, $id)
    {
        try {
            $user = $request->user();

            // Hanya superadmin dan admin sekolah yang bisa resolve alerts
            if (!$user->hasAnyRole(['superadmin', 'admin_sekolah'])) {
                return response()->json(['message' => 'Anda tidak memiliki izin untuk resolve alert'], 403);
            }

            $validator = Validator::make($request->all(), [
                'resolution_notes' => 'required|string|min:10|max:500',
            ]);

            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 422);
            }

            $alert = SecurityAlert::find($id);

            if (!$alert) {
                return response()->json(['message' => 'Alert tidak ditemukan'], 404);
            }

            if ($alert->is_resolved) {
                return response()->json(['message' => 'Alert sudah diresolve sebelumnya'], 400);
            }

            $alert->markAsResolved($request->resolution_notes, $user->id);

            // Log aktivitas
            SecurityHelper::logSecurityEvent(
                'security_alert_resolved',
                'Security alert resolved: ' . $alert->alert_type . ' - ID: ' . $alert->id,
                $user->id
            );

            return response()->json([
                'message' => 'Alert berhasil diresolve',
                'alert' => $alert->fresh(),
            ], 200);

        } catch (\Exception $e) {
            Log::error('Resolve security alert error: ' . $e->getMessage(), [
                'alert_id' => $id,
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat resolve alert',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get suspicious activity report
     */
    public function getSuspiciousActivityReport(Request $request)
    {
        try {
            $user = $request->user();

            // Hanya superadmin yang bisa melihat suspicious activity report
            if (!$user->hasRole('superadmin')) {
                return response()->json(['message' => 'Hanya superadmin yang dapat melihat laporan aktivitas mencurigakan'], 403);
            }

            $timeRange = $request->time_range ?? '24h'; // 1h, 24h, 7d
            $hours = (int)str_replace(['h', 'd'], '', $timeRange);

            if (strpos($timeRange, 'd') !== false) {
                $hours = $hours * 24;
            }

            $startDate = Carbon::now()->subHours($hours);

            $report = [
                'time_range' => $timeRange,
                'start_time' => $startDate->toDateTimeString(),
                'end_time' => Carbon::now()->toDateTimeString(),
                'high_risk_ips' => $this->getHighRiskIps($startDate),
                'unusual_login_patterns' => $this->getUnusualLoginPatterns($startDate),
                'multiple_failed_logins' => $this->getMultipleFailedLogins($startDate),
                'suspicious_endpoints' => $this->getSuspiciousEndpoints($startDate),
                'data_export_attempts' => $this->getDataExportAttempts($startDate),
                'user_agent_analysis' => $this->getUserAgentAnalysis($startDate),
            ];

            return response()->json($report, 200);

        } catch (\Exception $e) {
            Log::error('Get suspicious activity report error: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil laporan aktivitas mencurigakan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get security configuration
     */
    public function getSecurityConfig(Request $request)
    {
        try {
            $user = $request->user();

            // Hanya superadmin yang bisa melihat security configuration
            if (!$user->hasRole('superadmin')) {
                return response()->json(['message' => 'Hanya superadmin yang dapat melihat konfigurasi keamanan'], 403);
            }

            $configs = \App\Models\SecurityConfiguration::all()
                ->groupBy('category')
                ->map(function ($items) {
                    return $items->mapWithKeys(function ($item) {
                        // Convert value based on data type
                        $value = $item->config_value;

                        switch ($item->data_type) {
                            case 'integer':
                                $value = (int)$value;
                                break;
                            case 'boolean':
                                $value = filter_var($value, FILTER_VALIDATE_BOOLEAN);
                                break;
                            case 'json':
                                $value = json_decode($value, true);
                                break;
                        }

                        return [$item->config_key => [
                            'value' => $value,
                            'description' => $item->description,
                            'data_type' => $item->data_type,
                            'is_active' => $item->is_active,
                            'updated_at' => $item->updated_at->toDateTimeString(),
                        ]];
                    });
                });

            return response()->json([
                'configurations' => $configs,
                'last_updated' => \App\Models\SecurityConfiguration::max('updated_at'),
            ], 200);

        } catch (\Exception $e) {
            Log::error('Get security config error: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil konfigurasi keamanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update security configuration
     */
    public function updateSecurityConfig(Request $request)
    {
        try {
            $user = $request->user();

            // Hanya superadmin yang bisa update security configuration
            if (!$user->hasRole('superadmin')) {
                return response()->json(['message' => 'Hanya superadmin yang dapat mengubah konfigurasi keamanan'], 403);
            }

            $validator = Validator::make($request->all(), [
                'config_key' => 'required|string',
                'config_value' => 'required',
            ]);

            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 422);
            }

            $config = \App\Models\SecurityConfiguration::where('config_key', $request->config_key)->first();

            if (!$config) {
                return response()->json(['message' => 'Konfigurasi tidak ditemukan'], 404);
            }

            // Validate value based on data type
            $value = $request->config_value;
            $errors = [];

            switch ($config->data_type) {
                case 'integer':
                    if (!is_numeric($value)) {
                        $errors[] = 'Value harus berupa angka';
                    }
                    break;
                case 'boolean':
                    if (!is_bool($value) && !in_array($value, ['true', 'false', '1', '0'])) {
                        $errors[] = 'Value harus berupa boolean (true/false)';
                    }
                    break;
                case 'json':
                    json_decode($value);
                    if (json_last_error() !== JSON_ERROR_NONE) {
                        $errors[] = 'Value harus berupa JSON yang valid';
                    }
                    break;
            }

            if (!empty($errors)) {
                return response()->json(['errors' => $errors], 422);
            }

            // Update configuration
            $config->update([
                'config_value' => is_string($value) ? $value : (string)$value,
                'updated_by' => $user->id,
            ]);

            // Log configuration change
            SecurityHelper::logSecurityEvent(
                'security_config_updated',
                'Security configuration updated: ' . $config->config_key . ' = ' . $value,
                $user->id
            );

            return response()->json([
                'message' => 'Konfigurasi berhasil diperbarui',
                'config' => $config->fresh(),
            ], 200);

        } catch (\Exception $e) {
            Log::error('Update security config error: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'config_key' => $request->config_key,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat memperbarui konfigurasi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Helper methods untuk suspicious activity report
     */

    private function getHighRiskIps($startDate)
    {
        return LoginAttempt::selectRaw('ip_address, count(*) as total_attempts, sum(case when successful = false then 1 else 0 end) as failed_attempts')
            ->where('created_at', '>=', $startDate)
            ->groupBy('ip_address')
            ->havingRaw('failed_attempts >= 10')
            ->orderBy('failed_attempts', 'desc')
            ->limit(20)
            ->get();
    }

    private function getUnusualLoginPatterns($startDate)
    {
        // Login attempts dari banyak negara/lokasi berbeda dalam waktu singkat
        return LoginAttempt::selectRaw('user_id, count(distinct ip_address) as distinct_ips, min(created_at) as first_attempt, max(created_at) as last_attempt')
            ->where('created_at', '>=', $startDate)
            ->whereNotNull('user_id')
            ->groupBy('user_id')
            ->havingRaw('distinct_ips > 3')
            ->orderBy('distinct_ips', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($item) {
                $item->time_diff_minutes = Carbon::parse($item->first_attempt)->diffInMinutes(Carbon::parse($item->last_attempt));
                return $item;
            });
    }

    private function getMultipleFailedLogins($startDate)
    {
        return LoginAttempt::selectRaw('email, count(*) as attempts')
            ->where('created_at', '>=', $startDate)
            ->where('successful', false)
            ->groupBy('email')
            ->havingRaw('attempts >= 5')
            ->orderBy('attempts', 'desc')
            ->limit(20)
            ->get();
    }

    private function getSuspiciousEndpoints($startDate)
    {
        // Endpoint yang biasanya tidak sering diakses
        $commonEndpoints = ['/api/auth/login', '/api/auth/register', '/api/school/profile'];

        return ActivityLog::selectRaw('endpoint, count(*) as access_count, count(distinct ip_address) as distinct_ips')
            ->where('created_at', '>=', $startDate)
            ->whereNotNull('endpoint')
            ->whereNotIn('endpoint', $commonEndpoints)
            ->groupBy('endpoint')
            ->havingRaw('access_count > 10')
            ->orderBy('access_count', 'desc')
            ->limit(10)
            ->get();
    }

    private function getDataExportAttempts($startDate)
    {
        return ActivityLog::where('created_at', '>=', $startDate)
            ->where(function($query) {
                $query->where('description', 'like', '%export%')
                      ->orWhere('description', 'like', '%download%')
                      ->orWhere('description', 'like', '%backup%');
            })
            ->orderBy('created_at', 'desc')
            ->limit(20)
            ->get();
    }

    private function getUserAgentAnalysis($startDate)
    {
        $analysis = ActivityLog::selectRaw('user_agent, count(*) as count')
            ->where('created_at', '>=', $startDate)
            ->whereNotNull('user_agent')
            ->groupBy('user_agent')
            ->orderBy('count', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($item) {
                $ua = $item->user_agent;
                $item->is_suspicious = $this->isSuspiciousUserAgent($ua);
                return $item;
            });

        return [
            'total_unique_agents' => ActivityLog::where('created_at', '>=', $startDate)->distinct('user_agent')->count('user_agent'),
            'top_agents' => $analysis,
            'suspicious_count' => $analysis->where('is_suspicious', true)->count(),
        ];
    }

    private function isSuspiciousUserAgent($userAgent)
    {
        $suspiciousPatterns = [
            'python', 'curl', 'wget', 'bot', 'crawler', 'spider',
            'scan', 'hack', 'exploit', 'sqlmap', 'nmap', 'nikto',
        ];

        foreach ($suspiciousPatterns as $pattern) {
            if (stripos($userAgent, $pattern) !== false) {
                return true;
            }
        }

        return false;
    }

    private function getIpInfo($ip)
    {
        // Ini adalah implementasi sederhana
        // Untuk produksi, bisa menggunakan service seperti ipinfo.io atau maxmind
        return [
            'ip' => $ip,
            'is_local' => filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) === false,
            'is_ipv4' => filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4) !== false,
            'is_ipv6' => filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6) !== false,
        ];
    }
}
