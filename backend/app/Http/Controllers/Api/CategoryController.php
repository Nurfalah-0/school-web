<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class CategoryController extends Controller
{
    public function index(Request $request)
    {
        $query = Category::query();
        
        if ($request->has('type')) {
            $query->where('type', $request->type);
        }
        
        if ($request->has('is_active')) {
            $query->where('is_active', filter_var($request->is_active, FILTER_VALIDATE_BOOLEAN));
        }

        return response()->json($query->orderBy('name')->get());
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|string|max:50',
            'is_active' => 'boolean',
        ]);

        $slug = Str::slug($request->name);
        
        // Ensure unique slug per type
        $count = Category::where('type', $request->type)->where('slug', 'LIKE', "{$slug}%")->count();
        if ($count > 0) {
            $slug = $slug . '-' . ($count + 1);
        }

        $category = Category::create([
            'name' => $request->name,
            'slug' => $slug,
            'type' => $request->type,
            'is_active' => $request->has('is_active') ? $request->is_active : true,
        ]);

        return response()->json($category, 201);
    }

    public function update(Request $request, Category $category)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|string|max:50',
            'is_active' => 'boolean',
        ]);

        $data = $request->only(['name', 'type', 'is_active']);
        
        if ($request->name !== $category->name) {
            $slug = Str::slug($request->name);
            $count = Category::where('type', $request->type)
                            ->where('id', '!=', $category->id)
                            ->where('slug', 'LIKE', "{$slug}%")
                            ->count();
            if ($count > 0) {
                $slug = $slug . '-' . ($count + 1);
            }
            $data['slug'] = $slug;
        }

        $category->update($data);

        return response()->json($category);
    }

    public function destroy(Category $category)
    {
        $category->delete();
        return response()->json(null, 204);
    }
}
