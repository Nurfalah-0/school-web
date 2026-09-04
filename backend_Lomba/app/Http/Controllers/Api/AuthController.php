<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;
use Carbon\Carbon;
use Illuminate\Auth\Events\Registered;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Support\Facades\Password;

class AuthController extends Controller
{
    /**
     * Register a new user
     */
    public function register(Request $request)
    {
        // Rate limiting untuk registrasi
        if (RateLimiter::tooManyAttempts('register:' . $request->ip(), 5)) {
            return response()->json([
                'message' => 'Terlalu banyak permintaan registrasi. Silakan coba lagi dalam beberapa menit.',
                'retry_after' => RateLimiter::availableIn('register:' . $request->ip())
            ], 429);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'phone' => 'required|string|max:20',
        ]);

        if ($validator->fails()) {
            RateLimiter::hit('register:' . $request->ip(), 300); // 5 menit
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'phone' => $request->phone,
                'is_active' => true,
                'last_password_change' => Carbon::now(),
                'must_change_password' => false,
            ]);

            // Assign role default (siswa)
            $user->roles()->attach(5); // ID role 'siswa'

            event(new Registered($user));

            // Generate Sanctum token
            $token = $user->createToken('auth_token')->plainTextToken;

            RateLimiter::clear('register:' . $request->ip());

            return response()->json([
                'message' => 'Registrasi berhasil',
                'user' => $user,
                'access_token' => $token,
                'token_type' => 'Bearer',
            ], 201);
        } catch (\Exception $e) {
            RateLimiter::hit('register:' . $request->ip(), 300);
            return response()->json([
                'message' => 'Terjadi kesalahan pada server',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Login user
     */
    public function login(Request $request)
    {
        // Rate limiting untuk login
        $key = 'login:' . $request->ip();
        if (RateLimiter::tooManyAttempts($key, 5)) {
            return response()->json([
                'message' => 'Terlalu banyak percobaan login. Silakan coba lagi dalam ' . RateLimiter::availableIn($key) . ' detik.',
                'retry_after' => RateLimiter::availableIn($key)
            ], 429);
        }

        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            RateLimiter::hit($key);
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            // Cek jika user ada
            $user = User::where('email', $request->email)->first();

            if (!$user) {
                RateLimiter::hit($key);
                return response()->json(['message' => 'Email atau password salah'], 401);
            }

            // Cek jika akun aktif
            if (!$user->is_active) {
                RateLimiter::hit($key);
                return response()->json(['message' => 'Akun tidak aktif. Silakan hubungi administrator.'], 403);
            }

            // Cek jika password harus diganti
            $passwordMustChange = $user->must_change_password;

            // Cek login attempts
            if ($user->login_attempts >= 5) {
                $user->is_active = false;
                $user->save();
                RateLimiter::hit($key);
                return response()->json(['message' => 'Akun dinonaktifkan karena terlalu banyak percobaan login gagal. Silakan hubungi administrator.'], 403);
            }

            // Cek credentials
            if (!Auth::attempt($request->only('email', 'password'))) {
                $user->increment('login_attempts');
                RateLimiter::hit($key);
                return response()->json(['message' => 'Email atau password salah'], 401);
            }

            // Reset login attempts dan update last login
            $user->login_attempts = 0;
            $user->last_login_at = Carbon::now();
            $user->save();

            // Generate Sanctum token dengan IP dan user agent untuk security
            $token = $user->createToken('auth_token', [
                'ip' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'expires_at' => Carbon::now()->addDays(7)
            ])->plainTextToken;

            // Get user roles and permissions
            $roles = $user->roles()->pluck('name');
            $permissions = $user->permissions->pluck('slug')->unique();

            RateLimiter::clear($key);

            return response()->json([
                'message' => 'Login berhasil',
                'user' => $user,
                'roles' => $roles,
                'permissions' => $permissions,
                'password_must_change' => $passwordMustChange,
                'access_token' => $token,
                'token_type' => 'Bearer',
                'expires_in' => 604800, // 7 hari dalam detik
            ], 200);
        } catch (\Exception $e) {
            RateLimiter::hit($key);
            return response()->json([
                'message' => 'Terjadi kesalahan pada server',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Logout user (revoke token)
     */
    public function logout(Request $request)
    {
        try {
            $request->user()->currentAccessToken()->delete();

            return response()->json(['message' => 'Logout berhasil'], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat logout',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get authenticated user profile
     */
    public function profile(Request $request)
    {
        try {
            $user = $request->user();
            $roles = $user->roles()->pluck('name');
            $permissions = $user->permissions->pluck('slug')->unique();

            return response()->json([
                'user' => $user,
                'roles' => $roles,
                'permissions' => $permissions,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil profil',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update user profile
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|max:255|unique:users,email,' . $user->id,
            'phone' => 'sometimes|string|max:20',
            'current_password' => 'required_with:password',
            'password' => 'sometimes|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $data = $request->only('name', 'email', 'phone');

            // Update password jika diberikan
            if ($request->has('password')) {
                if (!Hash::check($request->current_password, $user->password)) {
                    return response()->json(['message' => 'Password saat ini tidak valid'], 422);
                }

                $data['password'] = Hash::make($request->password);
                $data['last_password_change'] = Carbon::now();
                $data['must_change_password'] = false;

                // Revoke semua token kecuali yang sedang digunakan
                $user->tokens()->where('id', '!=', $request->user()->currentAccessToken()->id)->delete();
            }

            // Update profile photo jika ada
            if ($request->hasFile('profile_photo')) {
                $path = $request->file('profile_photo')->store('profile-photos', 'public');
                $data['profile_photo'] = $path;
            }

            $user->update($data);

            return response()->json([
                'message' => 'Profil berhasil diperbarui',
                'user' => $user->fresh(),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat memperbarui profil',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Request password reset
     */
    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $status = Password::sendResetLink(
                $request->only('email')
            );

            return $status === Password::RESET_LINK_SENT
                ? response()->json(['message' => 'Link reset password telah dikirim ke email Anda'], 200)
                : response()->json(['message' => 'Email tidak ditemukan'], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengirim link reset password',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reset password
     */
    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'token' => 'required',
            'email' => 'required|email',
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $status = Password::reset(
                $request->only('email', 'password', 'password_confirmation', 'token'),
                function ($user, $password) {
                    $user->forceFill([
                        'password' => Hash::make($password),
                        'last_password_change' => Carbon::now(),
                        'must_change_password' => false,
                        'login_attempts' => 0,
                    ])->save();

                    $user->tokens()->delete();

                    event(new PasswordReset($user));
                }
            );

            return $status === Password::PASSWORD_RESET
                ? response()->json(['message' => 'Password berhasil direset'], 200)
                : response()->json(['message' => 'Token reset password tidak valid'], 400);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat reset password',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Refresh token
     */
    public function refreshToken(Request $request)
    {
        try {
            $user = $request->user();

            // Revoke token lama
            $request->user()->currentAccessToken()->delete();

            // Buat token baru
            $token = $user->createToken('auth_token', [
                'ip' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'expires_at' => Carbon::now()->addDays(7)
            ])->plainTextToken;

            return response()->json([
                'message' => 'Token berhasil diperbarui',
                'access_token' => $token,
                'token_type' => 'Bearer',
                'expires_in' => 604800,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat memperbarui token',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Check token validity
     */
    public function checkToken(Request $request)
    {
        try {
            $user = $request->user();
            $token = $request->user()->currentAccessToken();

            $isValid = $token && !$token->expires_at->isPast();

            return response()->json([
                'valid' => $isValid,
                'user' => $user,
                'expires_at' => $token->expires_at,
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['valid' => false], 401);
        }
    }

    /**
     * [ADMIN] Get all users with roles
     */
    public function getAllUsers(Request $request)
    {
        try {
            $query = User::with('roles');

            if ($request->filled('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%")
                      ->orWhere('email', 'like', "%{$search}%")
                      ->orWhere('phone', 'like', "%{$search}%");
                });
            }

            $users = $query->latest()->get();

            return response()->json([
                'success' => true,
                'data'    => $users,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data user: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Get single user by ID
     */
    public function getUserById($id)
    {
        try {
            $user = User::with('roles')->find($id);

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan.',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data'    => $user,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Create new user
     */
    public function createUser(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string|max:255',
            'email'    => 'required|string|email|max:255|unique:users,email',
            'password' => 'required|string|min:6',
            'phone'    => 'nullable|string|max:20',
            'role'     => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors(),
                'message' => 'Validasi gagal',
            ], 422);
        }

        try {
            $user = User::create([
                'name'      => $request->name,
                'email'     => $request->email,
                'password'  => Hash::make($request->password),
                'phone'     => $request->phone,
                'is_active' => true,
            ]);

            if ($request->filled('role')) {
                $role = Role::where('name', $request->role)->first();
                if ($role) {
                    $user->roles()->sync([$role->id]);
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'User berhasil dibuat.',
                'data'    => $user->load('roles'),
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat user: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Update user
     */
    public function updateUser(Request $request, $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan.',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'name'      => 'sometimes|string|max:255',
            'email'     => 'sometimes|string|email|max:255|unique:users,email,' . $id,
            'password'  => 'nullable|string|min:6',
            'phone'     => 'nullable|string|max:20',
            'role'      => 'nullable|string',
            'is_active' => 'nullable|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors(),
                'message' => 'Validasi gagal',
            ], 422);
        }

        try {
            $data = $request->only(['name', 'email', 'phone', 'is_active']);
            if ($request->filled('password')) {
                $data['password'] = Hash::make($request->password);
            }

            $user->update($data);

            if ($request->has('role')) {
                $role = Role::where('name', $request->role)->first();
                if ($role) {
                    $user->roles()->sync([$role->id]);
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'User berhasil diperbarui.',
                'data'    => $user->load('roles'),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui user: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * [ADMIN] Delete user
     */
    public function deleteUser($id)
    {
        try {
            $user = User::find($id);
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan.',
                ], 404);
            }

            // Cegah menghapus user sendiri jika sedang login
            if (Auth::id() == $id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tidak dapat menghapus akun Anda sendiri yang sedang aktif.',
                ], 400);
            }

            $user->roles()->detach();
            $user->tokens()->delete();
            $user->delete();

            return response()->json([
                'success' => true,
                'message' => 'User berhasil dihapus.',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus user: ' . $e->getMessage(),
            ], 500);
        }
    }
}
