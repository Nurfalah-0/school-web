<?php

namespace App\Helpers;

use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Str;
use Carbon\Carbon;
use App\Models\User;
use App\Models\LoginAttempt;

class SecurityHelper
{
    /**
     * Generate secure random token
     */
    public static function generateSecureToken($length = 64)
    {
        return Str::random($length);
    }

    /**
     * Generate API key with prefix
     */
    public static function generateApiKey($prefix = 'sk_')
    {
        return $prefix . Str::random(40);
    }

    /**
     * Hash password dengan salt (alternatif jika butuh custom hashing)
     */
    public static function hashPassword($password, $salt = null)
    {
        if ($salt === null) {
            $salt = Str::random(32);
        }

        $iterations = 10000;
        $hash = hash_pbkdf2('sha256', $password, $salt, $iterations, 32);

        return [
            'hash' => $hash,
            'salt' => $salt,
            'iterations' => $iterations,
        ];
    }

    /**
     * Verify password dengan custom hashing
     */
    public static function verifyPassword($password, $hash, $salt, $iterations = 10000)
    {
        $computedHash = hash_pbkdf2('sha256', $password, $salt, $iterations, 32);
        return hash_equals($hash, $computedHash);
    }

    /**
     * Encrypt data sensitif
     */
    public static function encryptData($data)
    {
        if (!is_string($data)) {
            $data = json_encode($data);
        }

        return Crypt::encrypt($data);
    }

    /**
     * Decrypt data sensitif
     */
    public static function decryptData($encryptedData)
    {
        try {
            $decrypted = Crypt::decrypt($encryptedData);
            return json_decode($decrypted, true) ?? $decrypted;
        } catch (\Exception $e) {
            return null;
        }
    }

    /**
     * Generate 2FA secret
     */
    public static function generateTwoFactorSecret()
    {
        return Str::random(32);
    }

    /**
     * Generate backup codes untuk 2FA
     */
    public static function generateBackupCodes($count = 10)
    {
        $codes = [];
        for ($i = 0; $i < $count; $i++) {
            $codes[] = Str::upper(Str::random(8));
        }
        return $codes;
    }

    /**
     * Check rate limiting untuk login attempts
     */
    public static function checkLoginRateLimit($email, $ip, $maxAttempts = 5, $lockoutMinutes = 15)
    {
        $recentAttempts = LoginAttempt::where('email', $email)
            ->orWhere('ip_address', $ip)
            ->where('created_at', '>=', Carbon::now()->subMinutes($lockoutMinutes))
            ->where('successful', false)
            ->count();

        return [
            'blocked' => $recentAttempts >= $maxAttempts,
            'attempts' => $recentAttempts,
            'remaining' => max(0, $maxAttempts - $recentAttempts),
        ];
    }

    /**
     * Log login attempt
     */
    public static function logLoginAttempt($email, $ip, $userAgent, $successful, $failureReason = null)
    {
        LoginAttempt::create([
            'email' => $email,
            'ip_address' => $ip,
            'user_agent' => $userAgent,
            'successful' => $successful,
            'failure_reason' => $failureReason,
        ]);
    }

    /**
     * Validate password strength
     */
    public static function validatePasswordStrength($password)
    {
        $errors = [];

        if (strlen($password) < 8) {
            $errors[] = 'Password minimal 8 karakter';
        }

        if (!preg_match('/[A-Z]/', $password)) {
            $errors[] = 'Password harus mengandung huruf besar';
        }

        if (!preg_match('/[a-z]/', $password)) {
            $errors[] = 'Password harus mengandung huruf kecil';
        }

        if (!preg_match('/[0-9]/', $password)) {
            $errors[] = 'Password harus mengandung angka';
        }

        if (!preg_match('/[^A-Za-z0-9]/', $password)) {
            $errors[] = 'Password harus mengandung karakter khusus';
        }

        // Check common passwords
        $commonPasswords = ['password', '123456', 'password123', 'admin123', 'qwerty'];
        if (in_array(strtolower($password), $commonPasswords)) {
            $errors[] = 'Password terlalu umum';
        }

        return [
            'valid' => empty($errors),
            'errors' => $errors,
            'strength' => self::calculatePasswordStrength($password),
        ];
    }

    /**
     * Calculate password strength score (0-100)
     */
    private static function calculatePasswordStrength($password)
    {
        $score = 0;
        $length = strlen($password);

        // Length score
        if ($length >= 8) $score += 10;
        if ($length >= 12) $score += 10;
        if ($length >= 16) $score += 10;

        // Character variety score
        if (preg_match('/[A-Z]/', $password)) $score += 15;
        if (preg_match('/[a-z]/', $password)) $score += 15;
        if (preg_match('/[0-9]/', $password)) $score += 15;
        if (preg_match('/[^A-Za-z0-9]/', $password)) $score += 15;

        // Entropy calculation
        $charset = 0;
        if (preg_match('/[a-z]/', $password)) $charset += 26;
        if (preg_match('/[A-Z]/', $password)) $charset += 26;
        if (preg_match('/[0-9]/', $password)) $charset += 10;
        if (preg_match('/[^A-Za-z0-9]/', $password)) $charset += 32;

        if ($charset > 0) {
            $entropy = log(pow($charset, $length), 2);
            $score += min(20, $entropy / 2); // Normalize entropy score
        }

        return min(100, $score);
    }

    /**
     * Generate CSRF token untuk API
     */
    public static function generateCsrfToken()
    {
        $token = Str::random(40);
        session(['_csrf_token' => $token]);
        return $token;
    }

    /**
     * Validate CSRF token
     */
    public static function validateCsrfToken($token)
    {
        $sessionToken = session('_csrf_token');
        return hash_equals($sessionToken, $token);
    }

    /**
     * Sanitize input untuk mencegah XSS
     */
    public static function sanitizeInput($input)
    {
        if (is_array($input)) {
            return array_map([self::class, 'sanitizeInput'], $input);
        }

        if (is_string($input)) {
            // Remove HTML tags
            $input = strip_tags($input);

            // Escape special characters
            $input = htmlspecialchars($input, ENT_QUOTES, 'UTF-8');

            // Remove control characters
            $input = preg_replace('/[\x00-\x1F\x7F]/', '', $input);
        }

        return $input;
    }

    /**
     * Validate file upload untuk keamanan
     */
    public static function validateFileUpload($file, $allowedTypes = [], $maxSize = 5242880) // 5MB default
    {
        $errors = [];

        // Check file size
        if ($file->getSize() > $maxSize) {
            $errors[] = 'Ukuran file terlalu besar. Maksimal ' . ($maxSize / 1048576) . 'MB';
        }

        // Check file type
        $mimeType = $file->getMimeType();
        $extension = $file->getClientOriginalExtension();

        if (!empty($allowedTypes) && !in_array($mimeType, $allowedTypes)) {
            $errors[] = 'Tipe file tidak diizinkan. Hanya ' . implode(', ', $allowedTypes);
        }

        // Check for dangerous extensions
        $dangerousExtensions = ['php', 'exe', 'js', 'jar', 'py', 'sh', 'bat', 'cmd'];
        if (in_array(strtolower($extension), $dangerousExtensions)) {
            $errors[] = 'Ekstensi file tidak diizinkan untuk keamanan';
        }

        // Check file content untuk shell scripts
        $content = file_get_contents($file->getPathname());
        if (preg_match('/<\?php|<\?=|eval\(|base64_decode|system\(|exec\(|passthru\(|shell_exec\(/', $content)) {
            $errors[] = 'File mengandung kode berbahaya';
        }

        return [
            'valid' => empty($errors),
            'errors' => $errors,
        ];
    }

    /**
     * Generate secure filename untuk upload
     */
    public static function generateSecureFilename($originalName, $prefix = 'file_')
    {
        $extension = pathinfo($originalName, PATHINFO_EXTENSION);
        $name = pathinfo($originalName, PATHINFO_FILENAME);

        // Sanitize filename
        $name = preg_replace('/[^a-zA-Z0-9_-]/', '_', $name);
        $name = substr($name, 0, 100);

        // Add timestamp and random string
        $timestamp = Carbon::now()->format('Ymd_His');
        $random = Str::random(8);

        return $prefix . $name . '_' . $timestamp . '_' . $random . '.' . $extension;
    }

    /**
     * Check if IP address is allowed (basic IP whitelisting)
     */
    public static function isIpAllowed($ip, $allowedIps = [])
    {
        if (empty($allowedIps)) {
            return true;
        }

        foreach ($allowedIps as $allowedIp) {
            if (self::ipMatchesRange($ip, $allowedIp)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Check if IP matches CIDR range
     */
    private static function ipMatchesRange($ip, $range)
    {
        if (strpos($range, '/') === false) {
            return $ip === $range;
        }

        list($subnet, $bits) = explode('/', $range);
        $ip = ip2long($ip);
        $subnet = ip2long($subnet);
        $mask = -1 << (32 - $bits);

        return ($ip & $mask) == ($subnet & $mask);
    }

    /**
     * Get user agent information
     */
    public static function parseUserAgent($userAgent)
    {
        $result = [
            'browser' => 'Unknown',
            'platform' => 'Unknown',
            'device' => 'Desktop',
        ];

        // Browser detection
        if (preg_match('/MSIE|Trident/i', $userAgent)) {
            $result['browser'] = 'Internet Explorer';
        } elseif (preg_match('/Firefox/i', $userAgent)) {
            $result['browser'] = 'Firefox';
        } elseif (preg_match('/Chrome/i', $userAgent)) {
            $result['browser'] = 'Chrome';
        } elseif (preg_match('/Safari/i', $userAgent)) {
            $result['browser'] = 'Safari';
        } elseif (preg_match('/Opera|OPR/i', $userAgent)) {
            $result['browser'] = 'Opera';
        } elseif (preg_match('/Edge/i', $userAgent)) {
            $result['browser'] = 'Edge';
        }

        // Platform detection
        if (preg_match('/Windows/i', $userAgent)) {
            $result['platform'] = 'Windows';
        } elseif (preg_match('/Macintosh|Mac OS X/i', $userAgent)) {
            $result['platform'] = 'macOS';
        } elseif (preg_match('/Linux/i', $userAgent)) {
            $result['platform'] = 'Linux';
        } elseif (preg_match('/Android/i', $userAgent)) {
            $result['platform'] = 'Android';
        } elseif (preg_match('/iPhone|iPad|iPod/i', $userAgent)) {
            $result['platform'] = 'iOS';
        }

        // Device detection
        if (preg_match('/Mobile|Android|iPhone|iPad|iPod/i', $userAgent)) {
            $result['device'] = 'Mobile';
        } elseif (preg_match('/Tablet/i', $userAgent)) {
            $result['device'] = 'Tablet';
        }

        return $result;
    }

    /**
     * Generate security headers untuk response
     */
    public static function getSecurityHeaders()
    {
        return [
            'X-Content-Type-Options' => 'nosniff',
            'X-Frame-Options' => 'DENY',
            'X-XSS-Protection' => '1; mode=block',
            'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
            'Content-Security-Policy' => "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';",
            'Referrer-Policy' => 'strict-origin-when-cross-origin',
            'Permissions-Policy' => 'camera=(), microphone=(), geolocation=()',
        ];
    }

    /**
     * Log security event untuk audit
     */
    public static function logSecurityEvent($event, $description, $userId = null, $ip = null, $userAgent = null)
    {
        \App\Models\ActivityLog::create([
            'log_name' => 'security',
            'description' => $description,
            'event' => $event,
            'causer_id' => $userId,
            'causer_type' => $userId ? User::class : null,
            'ip_address' => $ip ?? request()->ip(),
            'user_agent' => $userAgent ?? request()->userAgent(),
            'properties' => json_encode([
                'url' => request()->fullUrl(),
                'method' => request()->method(),
                'timestamp' => Carbon::now()->toDateTimeString(),
            ]),
        ]);
    }
}
