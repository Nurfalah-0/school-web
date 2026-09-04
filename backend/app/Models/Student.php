<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Student extends Model
{
    use SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nisn',
        'nis',
        'name',
        'major_id',
        'gender',
        'birth_place',
        'birth_date',
        'phone',
        'email',
        'address',
        'status',
        'class',
        'school_year',
        'father_name',
        'father_phone',
        'mother_name',
        'mother_phone',
        'guardian_name',
        'guardian_phone',
        'medical_history',
        'special_needs',
        'photo',
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
            'birth_date' => 'date',
            'medical_history' => 'array',
            'special_needs' => 'array',
        ];
    }

    /**
     * Get the major that the student belongs to.
     */
    public function major()
    {
        return $this->belongsTo(\App\Models\Major::class);
    }

    /**
     * Get student's academic records.
     */
    public function academicRecords()
    {
        return $this->hasMany(\App\Models\AcademicRecord::class);
    }

    /**
     * Get student's attendance records.
     */
    public function attendances()
    {
        return $this->hasMany(\App\Models\Attendance::class);
    }

    /**
     * Get student's PPDB application if any.
     */
    public function ppdbApplication()
    {
        return $this->hasOne(\App\Models\PpdbApplication::class);
    }

    /**
     * Get student's PKL registration if any.
     */
    public function pklRegistration()
    {
        return $this->hasOne(\App\Models\PklRegistration::class);
    }

    /**
     * Scope a query to only include active students.
     */
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    /**
     * Scope a query to filter by major.
     */
    public function scopeByMajor($query, $majorId)
    {
        return $query->where('major_id', $majorId);
    }

    /**
     * Scope a query to filter by class.
     */
    public function scopeByClass($query, $class)
    {
        return $query->where('class', $class);
    }

    /**
     * Scope a query to filter by school year.
     */
    public function scopeBySchoolYear($query, $schoolYear)
    {
        return $query->where('school_year', $schoolYear);
    }

    /**
     * Get student age.
     */
    public function getAgeAttribute()
    {
        if (!$this->birth_date) {
            return null;
        }

        return now()->diffInYears($this->birth_date);
    }

    /**
     * Get student's full address.
     */
    public function getFullAddressAttribute()
    {
        $parts = array_filter([$this->address, $this->birth_place]);
        return implode(', ', $parts);
    }

    /**
     * Get student's contact information.
     */
    public function getContactInfoAttribute()
    {
        return [
            'phone' => $this->phone,
            'email' => $this->email,
            'father_phone' => $this->father_phone,
            'mother_phone' => $this->mother_phone,
            'guardian_phone' => $this->guardian_phone,
        ];
    }

    /**
     * Check if student has special needs.
     */
    public function hasSpecialNeeds()
    {
        return !empty($this->special_needs);
    }

    /**
     * Check if student has medical history.
     */
    public function hasMedicalHistory()
    {
        return !empty($this->medical_history);
    }

    /**
     * Get student's photo URL.
     */
    public function getPhotoUrlAttribute()
    {
        if (!$this->photo) {
            return null;
        }

        return asset('storage/' . $this->photo);
    }

    /**
     * Get student's current academic year.
     */
    public function getCurrentAcademicYearAttribute()
    {
        if (!$this->school_year) {
            return null;
        }

        $years = explode('/', $this->school_year);
        return count($years) === 2 ? (int)$years[0] : null;
    }

    /**
     * Update student status.
     */
    public function updateStatus($status)
    {
        $validStatuses = ['active', 'inactive', 'alumni', 'dropout', 'transfer'];

        if (!in_array($status, $validStatuses)) {
            throw new \InvalidArgumentException('Status tidak valid');
        }

        $this->status = $status;
        $this->save();

        return $this;
    }
}
