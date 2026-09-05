<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SiteImage extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'key',
        'title',
        'description',
        'image_path',
        'image_url',
        'alt_text',
        'section',
        'position',
        'is_active',
        'width',
        'height',
        'file_size',
        'mime_type',
        'created_by',
        'updated_by',
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
            'is_active' => 'boolean',
            'position' => 'integer',
            'width' => 'integer',
            'height' => 'integer',
            'file_size' => 'integer',
        ];
    }

    /**
     * Available sections for site images
     */
    public const SECTIONS = [
        'homepage' => 'Homepage',
        'homepage_slider' => 'Homepage Slider',
        'about' => 'About Section',
        'facilities' => 'Facilities',
        'ppdb' => 'PPDB Section',
        'contact' => 'Contact Section',
        'news' => 'News Section',
        'gallery' => 'Gallery',
        'tefa' => 'TEFA Store',
        'testimonials' => 'Testimonials',
        'partners' => 'Partners/Sponsors',
    ];

    /**
     * Get the user who created the image.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the user who last updated the image.
     */
    public function updater()
    {
        return $this->belongsTo(User::class, 'updated_by');
    }

    /**
     * Scope a query to only include active images.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope a query to filter by section.
     */
    public function scopeBySection($query, $section)
    {
        return $query->where('section', $section);
    }

    /**
     * Scope a query to filter by key.
     */
    public function scopeByKey($query, $key)
    {
        return $query->where('key', $key);
    }

    /**
     * Scope a query to order by position.
     */
    public function scopeOrdered($query)
    {
        return $query->orderBy('position', 'asc');
    }

    /**
     * Get formatted file size.
     */
    public function getFormattedSizeAttribute()
    {
        if (!$this->file_size) {
            return 'Unknown';
        }

        $bytes = $this->file_size;
        $units = ['B', 'KB', 'MB', 'GB'];

        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }

        return round($bytes, 2) . ' ' . $units[$i];
    }

    /**
     * Get image dimensions string.
     */
    public function getDimensionsAttribute()
    {
        if (!$this->width || !$this->height) {
            return 'Unknown';
        }

        return $this->width . ' x ' . $this->height . ' px';
    }

    /**
     * Get section display name.
     */
    public function getSectionNameAttribute()
    {
        return self::SECTIONS[$this->section] ?? $this->section;
    }

    /**
     * Check if image is for slider.
     */
    public function getIsSliderAttribute()
    {
        return $this->section === 'homepage_slider';
    }

    /**
     * Get full URL with fallback.
     */
    public function getFullUrlAttribute()
    {
        return $this->image_url ?? asset('storage/' . $this->image_path);
    }

    /**
     * Get thumbnail URL (for admin panel).
     */
    public function getThumbnailUrlAttribute()
    {
        // Jika ada thumbnail generator, return thumbnail URL
        // Untuk saat ini, return image URL asli
        return $this->full_url;
    }

    /**
     * Check if image file exists.
     */
    public function fileExists()
    {
        return \Storage::disk('public')->exists($this->image_path);
    }

    /**
     * Delete image file from storage.
     */
    public function deleteFile()
    {
        if ($this->image_path && \Storage::disk('public')->exists($this->image_path)) {
            return \Storage::disk('public')->delete($this->image_path);
        }

        return false;
    }

    /**
     * Get image metadata.
     */
    public function getMetadata()
    {
        return [
            'id' => $this->id,
            'key' => $this->key,
            'title' => $this->title,
            'description' => $this->description,
            'image_url' => $this->full_url,
            'alt_text' => $this->alt_text,
            'section' => $this->section,
            'section_name' => $this->section_name,
            'position' => $this->position,
            'dimensions' => $this->dimensions,
            'file_size' => $this->formatted_size,
            'mime_type' => $this->mime_type,
            'is_active' => $this->is_active,
            'created_at' => $this->created_at?->toDateTimeString(),
            'updated_at' => $this->updated_at?->toDateTimeString(),
        ];
    }

    /**
     * Boot the model.
     */
    protected static function boot()
    {
        parent::boot();

        // Automatically delete file when model is deleted
        static::deleting(function ($image) {
            $image->deleteFile();
        });
    }
}
