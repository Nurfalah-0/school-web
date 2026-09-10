<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PpdbSetting extends Model
{
    protected $table = 'ppdb_settings';

    protected $fillable = [
        'registration_start',
        'registration_end',
    ];

    protected $casts = [
        'registration_start' => 'datetime',
        'registration_end' => 'datetime',
    ];

    public static function current(): self
    {
        return static::firstOrCreate(['id' => 1]);
    }

    public function isOpen(): bool
    {
        $now = now();

        return (!$this->registration_start || $now->greaterThanOrEqualTo($this->registration_start))
            && (!$this->registration_end || $now->lessThanOrEqualTo($this->registration_end));
    }
}
