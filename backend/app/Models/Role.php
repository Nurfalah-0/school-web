<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'description',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [];

    /**
     * Get the permissions for the role.
     */
    public function permissions()
    {
        return $this->belongsToMany(\App\Models\Permission::class, 'role_permissions');
    }

    /**
     * Get the users for the role.
     */
    public function users()
    {
        return $this->belongsToMany(\App\Models\User::class, 'user_roles');
    }

    /**
     * Assign permission to role.
     */
    public function assignPermission($permission)
    {
        if (is_string($permission)) {
            $permission = Permission::where('slug', $permission)->first();
        }

        if ($permission) {
            return $this->permissions()->syncWithoutDetaching([$permission->id]);
        }

        return false;
    }

    /**
     * Revoke permission from role.
     */
    public function revokePermission($permission)
    {
        if (is_string($permission)) {
            $permission = Permission::where('slug', $permission)->first();
        }

        if ($permission) {
            return $this->permissions()->detach($permission->id);
        }

        return false;
    }

    /**
     * Check if role has permission.
     */
    public function hasPermission($permission)
    {
        if (is_string($permission)) {
            return $this->permissions->contains('slug', $permission);
        }

        return $this->permissions->contains($permission);
    }
}
