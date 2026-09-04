<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class FileMetadata extends Model
{
    use SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'original_name',
        'secure_name',
        'path',
        'url',
        'mime_type',
        'size',
        'extension',
        'type',
        'description',
        'uploaded_by',
        'owner_id',
        'owner_type',
        'permissions',
        'hash',
        'is_encrypted',
        'encryption_key_id',
        'is_public',
        'expires_at',
        'download_count',
        'last_downloaded_at',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'encryption_key_id',
    ];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'size' => 'integer',
            'permissions' => 'array',
            'is_encrypted' => 'boolean',
            'is_public' => 'boolean',
            'expires_at' => 'datetime',
            'last_downloaded_at' => 'datetime',
            'download_count' => 'integer',
        ];
    }

    /**
     * Get the user who uploaded the file.
     */
    public function uploader()
    {
        return $this->belongsTo(User::class, 'uploaded_by');
    }

    /**
     * Get the owner of the file.
     */
    public function owner()
    {
        return $this->morphTo();
    }

    /**
     * Check if file is expired.
     */
    public function isExpired()
    {
        if (!$this->expires_at) {
            return false;
        }

        return now()->greaterThan($this->expires_at);
    }

    /**
     * Check if file is accessible by user.
     */
    public function isAccessibleBy($user)
    {
        // Jika file public
        if ($this->is_public) {
            return true;
        }

        // Jika user adalah pemilik file
        if ($this->owner_type === User::class && $this->owner_id === $user->id) {
            return true;
        }

        // Jika user adalah superadmin
        if ($user->hasRole('superadmin')) {
            return true;
        }

        // Check permissions dari field permissions
        if ($this->permissions) {
            // Check role permissions
            if (isset($this->permissions['roles'])) {
                foreach ($this->permissions['roles'] as $role) {
                    if ($user->hasRole($role)) {
                        return true;
                    }
                }
            }

            // Check user permissions
            if (isset($this->permissions['users'])) {
                if (in_array($user->id, $this->permissions['users'])) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * Increment download count.
     */
    public function incrementDownload()
    {
        $this->download_count++;
        $this->last_downloaded_at = now();
        $this->save();
    }

    /**
     * Get human readable file size.
     */
    public function getHumanSizeAttribute()
    {
        $bytes = $this->size;
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];

        if ($bytes == 0) return '0 B';

        $i = floor(log($bytes, 1024));
        return round($bytes / pow(1024, $i), 2) . ' ' . $units[$i];
    }

    /**
     * Get file type category.
     */
    public function getCategoryAttribute()
    {
        $mime = $this->mime_type;

        if (str_starts_with($mime, 'image/')) {
            return 'image';
        } elseif (str_starts_with($mime, 'video/')) {
            return 'video';
        } elseif (str_starts_with($mime, 'audio/')) {
            return 'audio';
        } elseif (str_starts_with($mime, 'application/pdf')) {
            return 'pdf';
        } elseif (str_starts_with($mime, 'application/msword') ||
                 str_starts_with($mime, 'application/vnd.openxmlformats')) {
            return 'document';
        } elseif (str_starts_with($mime, 'application/vnd.ms-excel') ||
                 str_starts_with($mime, 'application/vnd.openxmlformats')) {
            return 'spreadsheet';
        } elseif (str_starts_with($mime, 'text/')) {
            return 'text';
        } elseif (str_starts_with($mime, 'application/zip') ||
                 str_starts_with($mime, 'application/x-rar') ||
                 str_starts_with($mime, 'application/x-7z')) {
            return 'archive';
        } else {
            return 'other';
        }
    }

    /**
     * Check if file is an image.
     */
    public function getIsImageAttribute()
    {
        return str_starts_with($this->mime_type, 'image/');
    }

    /**
     * Check if file is a document.
     */
    public function getIsDocumentAttribute()
    {
        return in_array($this->category, ['pdf', 'document', 'spreadsheet', 'text']);
    }

    /**
     * Get file icon based on type.
     */
    public function getIconAttribute()
    {
        $icons = [
            'image' => 'image',
            'video' => 'video',
            'audio' => 'music',
            'pdf' => 'file-pdf',
            'document' => 'file-text',
            'spreadsheet' => 'file-spreadsheet',
            'text' => 'file-text',
            'archive' => 'archive',
            'other' => 'file',
        ];

        return $icons[$this->category] ?? 'file';
    }

    /**
     * Scope a query to only include public files.
     */
    public function scopePublic($query)
    {
        return $query->where('is_public', true);
    }

    /**
     * Scope a query to only include files accessible by user.
     */
    public function scopeAccessibleBy($query, $user)
    {
        if ($user->hasRole('superadmin')) {
            return $query;
        }

        return $query->where(function($q) use ($user) {
            $q->where('is_public', true)
              ->orWhere(function($q2) use ($user) {
                  $q2->where('owner_type', User::class)
                     ->where('owner_id', $user->id);
              })
              ->orWhereJsonContains('permissions->users', $user->id)
              ->orWhere(function($q3) use ($user) {
                  $roles = $user->roles->pluck('name')->toArray();
                  $q3->whereJsonContains('permissions->roles', $roles);
              });
        });
    }

    /**
     * Scope a query to only include files by type.
     */
    public function scopeByType($query, $type)
    {
        return $query->where('type', $type);
    }

    /**
     * Scope a query to only include files owned by specific model.
     */
    public function scopeOwnedBy($query, $model)
    {
        return $query->where('owner_type', get_class($model))
                    ->where('owner_id', $model->id);
    }

    /**
     * Scope a query to only include non-expired files.
     */
    public function scopeNotExpired($query)
    {
        return $query->where(function($q) {
            $q->whereNull('expires_at')
              ->orWhere('expires_at', '>', now());
        });
    }
}
