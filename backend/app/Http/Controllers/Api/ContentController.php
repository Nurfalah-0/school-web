<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ContentController extends Controller
{
    private const TABLES = [
        'achievements' => ['title', 'slug', 'category', 'level', 'organizer', 'year', 'achieved_at', 'description', 'image', 'rank', 'is_featured', 'is_published'],
        'galleries' => ['title', 'slug', 'category', 'description', 'image', 'alt_text', 'sort_order', 'is_featured', 'is_published'],
        'industry_partners' => ['company_name', 'slug', 'industry_type', 'address', 'city', 'phone', 'email', 'website', 'logo', 'description', 'is_active'],
        'job_vacancies' => ['title', 'slug', 'category', 'description', 'requirements', 'location', 'employment_type', 'salary_min', 'salary_max', 'deadline', 'is_remote', 'status'],
        'products' => ['name', 'slug', 'sku', 'category', 'short_description', 'description', 'base_price', 'compare_price', 'stock', 'image', 'options', 'status', 'featured'],
    ];

    public function index(string $type)
    {
        $table = $this->table($type);
        $query = DB::table($table)->latest('id');
        if (!request()->user()) {
            if (in_array($table, ['achievements', 'galleries'], true)) {
                $query->where('is_published', true);
            } elseif ($table === 'industry_partners') {
                $query->where('is_active', true);
            } else {
                $query->where('status', 'published');
            }
        }
        return response()->json(['success' => true, 'data' => $query->get()]);
    }

    public function store(Request $request, string $type)
    {
        $table = $this->table($type);
        $data = $this->validatedData($request, $type);
        $data['slug'] = $data['slug'] ?? Str::slug($data['title'] ?? $data['name'] ?? $data['company_name']);
        if ($table === 'products' && empty($data['sku'])) {
            do {
                $data['sku'] = 'SKU-' . Str::upper(Str::random(10));
            } while (DB::table($table)->where('sku', $data['sku'])->exists());
        }
        $data['created_at'] = now();
        $data['updated_at'] = now();
        $id = DB::table($table)->insertGetId($data);
        return response()->json(['success' => true, 'message' => 'Content created successfully', 'id' => $id], 201);
    }

    public function update(Request $request, string $type, int $id)
    {
        $table = $this->table($type);
        if (!DB::table($table)->where('id', $id)->exists()) {
            return response()->json(['success' => false, 'message' => 'Content not found'], 404);
        }
        $data = $this->validatedData($request, $type, false);
        $data['updated_at'] = now();
        DB::table($table)->where('id', $id)->update($data);
        return response()->json(['success' => true, 'message' => 'Content updated successfully']);
    }

    public function destroy(string $type, int $id)
    {
        $table = $this->table($type);
        if (!DB::table($table)->where('id', $id)->exists()) {
            return response()->json(['success' => false, 'message' => 'Content not found'], 404);
        }
        DB::table($table)->where('id', $id)->delete();
        return response()->json(['success' => true, 'message' => 'Content deleted successfully']);
    }

    private function table(string $type): string
    {
        $aliases = [
            'partners' => 'industry_partners',
            'partner' => 'industry_partners',
            'student_achievements' => 'achievements',
            'prestasi' => 'achievements',
            'tefa_products' => 'products',
            'tefa-products' => 'products',
            'product' => 'products',
            'vacancies' => 'job_vacancies',
            'jobs' => 'job_vacancies',
        ];
        $resolved = $aliases[$type] ?? $type;
        abort_unless(array_key_exists($resolved, self::TABLES), 404, 'Unknown content type');
        return $resolved;
    }

    private function validatedData(Request $request, string $type, bool $creating = true): array
    {
        $resolved = $this->table($type);
        $rules = [];
        $required = match ($resolved) {
            'industry_partners' => 'company_name',
            'products' => 'name',
            default => 'title',
        };
        foreach (self::TABLES[$resolved] as $field) {
            $rules[$field] = $field === $required && $creating ? 'required|string|max:255' : 'sometimes';
        }
        $rules['slug'] = 'sometimes|string|max:220';
        $rules['image'] = 'sometimes|image|max:5120';
        $rules['logo'] = 'sometimes|image|max:5120';
        $rules['price'] = 'sometimes';
        $rules['short_description'] = 'sometimes|string';
        $rules['options'] = 'sometimes|nullable|json';
        $rules['achieved_at'] = 'sometimes|nullable|date';

        $data = $request->validate($rules);

        if ($resolved === 'products' && isset($data['price']) && !isset($data['base_price'])) {
            $data['base_price'] = (float) $data['price'];
        }

        if ($resolved === 'products' && isset($data['options']) && is_string($data['options'])) {
            $options = json_decode($data['options'], true);
            $data['options'] = json_last_error() === JSON_ERROR_NONE ? json_encode($options) : null;
        }

        foreach (['image', 'logo'] as $fileField) {
            if ($request->hasFile($fileField)) {
                $data[$fileField] = $request->file($fileField)->store("content/{$resolved}", 'public');
            }
        }
        return array_intersect_key($data, array_flip(self::TABLES[$resolved]));
    }
}
