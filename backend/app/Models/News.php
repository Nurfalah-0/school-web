<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class News extends Model
{
    use HasFactory;

    protected $table = 'news';

    protected $fillable = [
        'title',
        'slug',
        'content',
        'excerpt',
        'category',
        'featured_image',
        'author_id',
        'published',
        'published_at',
    ];

    protected $casts = [
        'published'    => 'boolean',
        'published_at' => 'datetime',
    ];

    /**
     * Scope: hanya berita yang sudah diterbitkan
     */
    public function scopePublished($query)
    {
        return $query->where('published', true)
                     ->whereNotNull('published_at');
    }

    /**
     * Relasi: penulis berita (user)
     */
    public function author()
    {
        return $this->belongsTo(User::class, 'author_id');
    }
}
