<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'phone',
        'profile_photo',
        'last_login_at',
        'login_attempts',
        'is_active',
        'two_factor_enabled',
        'two_factor_secret',
        'two_factor_backup_codes',
        'last_password_change',
        'must_change_password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_secret',
        'two_factor_backup_codes',
    ];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'last_login_at' => 'datetime',
            'last_password_change' => 'datetime',
            'password' => 'hashed',
            'is_active' => 'boolean',
            'two_factor_enabled' => 'boolean',
            'must_change_password' => 'boolean',
            'two_factor_backup_codes' => 'array',
            'login_attempts' => 'integer',
        ];
    }

    /**
     * Get the roles for the user.
     */
    public function roles()
    {
        return $this->belongsToMany(\App\Models\Role::class, 'user_roles');
    }

    /**
     * Check if user has a specific role.
     */
    public function hasRole($role)
    {
        if (is_string($role)) {
            return $this->roles->contains('name', $role);
        }

        return !!$role->intersect($this->roles)->count();
    }

    /**
     * Check if user has any of the given roles.
     */
    public function hasAnyRole($roles)
    {
        if (is_array($roles)) {
            foreach ($roles as $role) {
                if ($this->hasRole($role)) {
                    return true;
                }
            }
        } else {
            if ($this->hasRole($roles)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Check if user has permission via role.
     */
    public function hasPermission($permission)
    {
        foreach ($this->roles as $role) {
            foreach ($role->permissions as $perm) {
                if ($perm->slug === $permission) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Get user's permissions.
     */
    public function getPermissionsAttribute()
    {
        $permissions = collect();
        foreach ($this->roles as $role) {
            $permissions = $permissions->merge($role->permissions);
        }
        return $permissions->unique('id');
    }
}
