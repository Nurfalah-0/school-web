<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class NewsController extends Controller
{
    public function index(Request $request)
    {
        try {
            $query = DB::table('news')->where('published', true);

            if ($request->has('search')) {
                $search = $request->input('search');
                $query->where(function ($q) use ($search) {
                    $q->where('title', 'like', '%' . $search . '%')
                        ->orWhere('content', 'like', '%' . $search . '%');
                });
            }

            $news = $query->orderBy('published_at', 'desc')
                ->paginate($request->per_page ?? 10);

            return response()->json([
                'success' => true,
                'data' => $news
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $article = DB::table('news')
                ->where('id', $id)
                ->orWhere('slug', $id)
                ->first();

            if (!$article) {
                return response()->json([
                    'success' => false,
                    'message' => 'News not found'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => $article
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required|string|max:255',
                'content' => 'required|string',
                'excerpt' => 'nullable|string|max:500',
                'featured_image' => 'nullable|image|max:5120',
                'category' => 'nullable|string|max:100',
                'author_id' => 'nullable|integer',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            $data = $validator->validated();
            $data['slug'] = Str::slug($request->title);
            $data['author_id'] = $request->author_id ?? Auth::id();
            $data['published'] = true;
            $data['published_at'] = now();
            $data['created_at'] = now();
            $data['updated_at'] = now();

            if ($request->hasFile('featured_image')) {
                $path = $request->file('featured_image')->store('news-images', 'public');
                $data['featured_image'] = url(Storage::url($path));
            }

            $id = DB::table('news')->insertGetId($data);

            return response()->json([
                'success' => true,
                'message' => 'News created successfully',
                'id' => $id
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            $article = DB::table('news')->where('id', $id)->first();

            if (!$article) {
                return response()->json([
                    'success' => false,
                    'message' => 'News not found'
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'title' => 'sometimes|string|max:255',
                'content' => 'sometimes|string',
                'excerpt' => 'nullable|string|max:500',
                'featured_image' => 'nullable|image|max:5120',
                'category' => 'nullable|string|max:100',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            $data = $validator->validated();
            $data['updated_at'] = now();

            if ($request->has('title')) {
                $data['slug'] = Str::slug($request->title);
            }

            if ($request->hasFile('featured_image')) {
                if ($article->featured_image) {
                    Storage::disk('public')->delete($article->featured_image);
                }
                $path = $request->file('featured_image')->store('news-images', 'public');
                $data['featured_image'] = url(Storage::url($path));
            }

            DB::table('news')->where('id', $id)->update($data);

            return response()->json([
                'success' => true,
                'message' => 'News updated successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function uploadImage(Request $request, $id)
    {
        try {
            $article = DB::table('news')->where('id', $id)->first();

            if (!$article) {
                return response()->json([
                    'success' => false,
                    'message' => 'News not found'
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'featured_image' => 'required|image|max:5120',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            if ($article->featured_image) {
                $oldPath = parse_url($article->featured_image, PHP_URL_PATH) ?: $article->featured_image;
                $oldPath = preg_replace('#^.*/storage/#', '', $oldPath);
                if ($oldPath && Storage::disk('public')->exists($oldPath)) {
                    Storage::disk('public')->delete($oldPath);
                }
            }

            $path = $request->file('featured_image')->store('news-images', 'public');
            $imageUrl = url(Storage::url($path));
            DB::table('news')->where('id', $id)->update([
                'featured_image' => $imageUrl,
                'updated_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'News image uploaded successfully',
                'data' => DB::table('news')->where('id', $id)->first(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $article = DB::table('news')->where('id', $id)->first();

            if (!$article) {
                return response()->json([
                    'success' => false,
                    'message' => 'News not found'
                ], 404);
            }

            if ($article->featured_image) {
                Storage::disk('public')->delete($article->featured_image);
            }

            DB::table('news')->where('id', $id)->delete();

            return response()->json([
                'success' => true,
                'message' => 'News deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function publish($id)
    {
        try {
            $article = DB::table('news')->where('id', $id)->first();

            if (!$article) {
                return response()->json([
                    'success' => false,
                    'message' => 'News not found'
                ], 404);
            }

            DB::table('news')->where('id', $id)->update([
                'published' => true,
                'published_at' => now(),
                'updated_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'News published successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function unpublish($id)
    {
        try {
            $article = DB::table('news')->where('id', $id)->first();

            if (!$article) {
                return response()->json([
                    'success' => false,
                    'message' => 'News not found'
                ], 404);
            }

            DB::table('news')->where('id', $id)->update([
                'published' => false,
                'updated_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'News unpublished successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
