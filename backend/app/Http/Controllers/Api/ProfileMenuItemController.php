<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ProfileMenuItem;
use Illuminate\Http\Request;

class ProfileMenuItemController extends Controller
{
    public function index(Request $request)
    {
        $query = ProfileMenuItem::query()->orderBy('position')->orderBy('id');
        if (!$request->boolean('include_inactive') || !auth()->check()) {
            $query->where('is_active', true);
        }

        return response()->json(['success' => true, 'data' => $query->get()]);
    }

    public function store(Request $request)
    {
        $validated = $this->validateItem($request);
        $validated['created_by'] = auth()->id();
        $validated['updated_by'] = auth()->id();
        $item = ProfileMenuItem::create($validated);

        return response()->json(['success' => true, 'message' => 'Menu profil berhasil ditambahkan.', 'data' => $item], 201);
    }

    public function update(Request $request, ProfileMenuItem $profileMenuItem)
    {
        $profileMenuItem->update(array_merge($this->validateItem($request), ['updated_by' => auth()->id()]));

        return response()->json(['success' => true, 'message' => 'Menu profil berhasil diperbarui.', 'data' => $profileMenuItem->fresh()]);
    }

    public function destroy(ProfileMenuItem $profileMenuItem)
    {
        $profileMenuItem->delete();

        return response()->json(['success' => true, 'message' => 'Menu profil berhasil dihapus.']);
    }

    private function validateItem(Request $request): array
    {
        return $request->validate([
            'label' => 'required|string|max:120',
            'description' => 'nullable|string|max:255',
            'path' => 'required|string|max:255',
            'hash' => 'nullable|string|max:120',
            'icon' => 'nullable|string|max:40',
            'position' => 'nullable|integer|min:1',
            'is_active' => 'sometimes|boolean',
        ]);
    }
}
