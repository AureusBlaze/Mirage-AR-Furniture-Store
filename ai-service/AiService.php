<?php

namespace App\Services;

use App\Models\Product;
use App\Models\Tag;
use Illuminate\Support\Collection;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AiService
{
    protected string $apiBaseUrl;
    protected int $timeout;

    public function __construct()
    {
        $this->apiBaseUrl = config('ai.api_url', 'http://192.168.8.155:8001');
        $this->timeout = config('ai.timeout', 60);
    }

    /**
     * Analyse a room image and return an array of furniture tag strings.
     *
     * @return string[]
     */
    public function analyzeRoomImage(UploadedFile $image): array
    {
        $result = $this->callLocalAI($image->getRealPath());

        if (empty($result)) {
            return [];
        }

        return $this->extractTags($result);
    }

    /**
     * Full room analysis with colors, style, and furniture recommendations.
     *
     * @return array
     */
    public function analyzeRoomImageFull(UploadedFile $image): array
    {
        $result = $this->callLocalAI($image->getRealPath());

        if (empty($result)) {
            return [
                'tags' => [],
                'analysis' => [],
                'dominant_colors' => [],
                'recommended_furniture' => [],
            ];
        }

        return [
            'tags' => $this->extractTags($result),
            'analysis' => $result['room_analysis'] ?? [],
            'dominant_colors' => $result['dominant_colors'] ?? [],
            'lighting_analysis' => $result['lighting_analysis'] ?? [],
            'composition' => $result['composition'] ?? [],
            'recommended_furniture' => $result['recommended_furniture'] ?? [],
        ];
    }

    /**
     * Given an array of tag strings, return matching active products.
     */
    public function getSuggestedProducts(array $tags): Collection
    {
        if (empty($tags)) {
            return collect();
        }

        return Product::with(['vendor', 'category', 'tags', 'media', 'arModel'])
            ->active()
            ->where(function ($query) use ($tags) {
                $query->whereHas('tags', fn($q) => $q->whereIn('name', $tags))
                    ->orWhere(function ($q) use ($tags) {
                        foreach ($tags as $tag) {
                            $q->orWhere('name', 'like', "%{$tag}%")
                                ->orWhere('material', 'like', "%{$tag}%")
                                ->orWhere('description', 'like', "%{$tag}%");
                        }
                    });
            })
            ->limit(20)
            ->get();
    }

    /**
     * Auto-tag a product using its images via Local AI.
     *
     * @return string[]
     */
    public function autoTagProduct(Product $product): array
    {
        $product->load('media');

        $firstMedia = $product->media->first();
        if (!$firstMedia) {
            return [];
        }

        try {
            $imageContent = file_get_contents($firstMedia->url);
            if ($imageContent === false) {
                return [];
            }

            $tempPath = tempnam(sys_get_temp_dir(), 'product_') . '.jpg';
            file_put_contents($tempPath, $imageContent);

            $result = $this->callLocalAI($tempPath);

            @unlink($tempPath);

            if (empty($result)) {
                return [];
            }

            $tags = $this->extractTags($result);

            if (empty($tags)) {
                return [];
            }

            $tagModels = collect($tags)->map(function ($tagName) {
                return Tag::firstOrCreate(
                    ['name' => $tagName],
                    ['slug' => \Illuminate\Support\Str::slug($tagName)]
                );
            });
            $product->tags()->sync($tagModels->pluck('id'));

            return $tags;

        } catch (\Exception $e) {
            Log::warning("AiService: Failed to auto-tag product", [
                'product_id' => $product->id,
                'error' => $e->getMessage(),
            ]);
            return [];
        }
    }

    /**
     * Call the local AI API to analyze an image.
     *
     * @return array|null
     */
    protected function callLocalAI(string $imagePath): ?array
    {
        try {
            $response = Http::timeout($this->timeout)
                ->attach(
                    'file',
                    file_get_contents($imagePath),
                    basename($imagePath)
                )
                ->post("{$this->apiBaseUrl}/analyze");

            if ($response->failed()) {
                Log::error('Local AI API request failed', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            $data = $response->json();

            if (($data['status'] ?? '') !== 'success') {
                Log::error('Local AI returned error', ['response' => $data]);
                return null;
            }

            return $data;

        } catch (\Exception $e) {
            Log::error('Local AI API connection failed', [
                'error' => $e->getMessage(),
                'url' => $this->apiBaseUrl,
            ]);
            return null;
        }
    }

    /**
     * Extract tags from the AI analysis result.
     *
     * @return string[]
     */
    protected function extractTags(array $result): array
    {
        $tags = [];

        // Style tag
        $style = $result['room_analysis']['style'] ?? '';
        if ($style) {
            $styleWords = explode(' ', str_replace('room', '', trim($style)));
            foreach ($styleWords as $word) {
                $word = trim($word);
                if (strlen($word) > 2) {
                    $tags[] = ucfirst($word);
                }
            }
        }

        // Color tags
        foreach (($result['dominant_colors'] ?? []) as $color) {
            $name = $color['name'] ?? '';
            if ($name && !in_array($name, ['unknown'])) {
                $tags[] = ucfirst($name);
            }
        }

        // Lighting tag
        $lighting = $result['room_analysis']['lighting'] ?? '';
        if ($lighting) {
            $lightWords = explode(' ', str_replace('room', '', trim($lighting)));
            foreach ($lightWords as $word) {
                $word = trim($word);
                if (strlen($word) > 2) {
                    $tags[] = ucfirst($word);
                }
            }
        }

        // Furniture type tags from recommendations
        foreach (($result['recommended_furniture'] ?? []) as $item) {
            $type = $item['type'] ?? '';
            if ($type) {
                $tags[] = ucfirst($type);
            }

            $style = $item['style'] ?? '';
            if ($style) {
                $tags[] = ucfirst($style);
            }
        }

        return array_unique($tags);
    }

    /**
     * Get furniture from local AI catalog.
     *
     * @return array
     */
    public function getFurnitureCatalog(): array
    {
        try {
            $response = Http::timeout($this->timeout)
                ->get("{$this->apiBaseUrl}/furniture");

            if ($response->failed()) {
                return [];
            }

            return $response->json();

        } catch (\Exception $e) {
            Log::error('Failed to fetch furniture catalog', [
                'error' => $e->getMessage(),
            ]);
            return [];
        }
    }

    /**
     * Get single furniture item by ID.
     *
     * @return array|null
     */
    public function getFurnitureById(string $id): ?array
    {
        try {
            $response = Http::timeout($this->timeout)
                ->get("{$this->apiBaseUrl}/furniture/{$id}");

            if ($response->failed()) {
                return null;
            }

            return $response->json();

        } catch (\Exception $e) {
            Log::error('Failed to fetch furniture item', [
                'id' => $id,
                'error' => $e->getMessage(),
            ]);
            return null;
        }
    }
}
