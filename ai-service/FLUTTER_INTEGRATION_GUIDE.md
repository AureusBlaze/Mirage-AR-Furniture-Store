# Furniture Recommendation API - Flutter Integration Guide

## Base URL
```
http://YOUR_SERVER_IP:8001
```

## Endpoints

### POST /analyze
Upload a room image and get AI analysis with furniture recommendations.

**Request:**
- Content-Type: `multipart/form-data`
- Parameter: `file` (image file)

**Response:**
```json
{
  "status": "success",
  "room_analysis": {
    "style": "modern minimalist interior with clean lines...",
    "color_palette": "neutral room with white beige gray...",
    "lighting": "bright naturally lit room...",
    "space": "large spacious open room..."
  },
  "dominant_colors": {
    "colors": [
      {"rgb": [245, 235, 220], "hex": "#F5EBDC", "name": "beige", "category": "neutral", "percentage": 35.2},
      {"rgb": [180, 170, 160], "hex": "#B4AAA0", "name": "taupe", "category": "neutral", "percentage": 22.1},
      {"rgb": [70, 80, 90], "hex": "#46505A", "name": "charcoal", "category": "neutral", "percentage": 15.3}
    ],
    "temperature": "neutral",
    "warm_score": 10.5,
    "cool_score": 8.2,
    "neutral_score": 81.3,
    "saturation": "desaturated",
    "brightness_level": "bright"
  },
  "lighting_analysis": {
    "brightness_value": 156.4,
    "brightness_level": "bright",
    "contrast_value": 42.3,
    "contrast_level": "medium contrast",
    "exposure": "well-exposed"
  },
  "composition": {
    "aspect_ratio": 1.78,
    "orientation": "horizontal emphasis",
    "complexity": "moderate",
    "symmetry_score": 0.72,
    "is_symmetrical": false
  },
  "room_type": [
    {"label": "a living room with sofa and coffee table...", "confidence": 0.8923}
  ],
  "materials": [
    {"label": "wooden room with natural wood grain...", "confidence": 0.7561},
    {"label": "fabric room with soft textiles...", "confidence": 0.4523}
  ],
  "mood": [
    {"label": "calm peaceful relaxing serene room...", "confidence": 0.8234}
  ],
  "furniture_present": [
    {"label": "room with sofa or couch seating...", "confidence": 0.9123},
    {"label": "room with coffee table or side table...", "confidence": 0.6543}
  ],
  "recommended_furniture": [
    {
      "id": "sofa-001",
      "name": "Modern Grey Sofa",
      "type": "sofa",
      "style": "modern minimalist",
      "colors": ["grey", "white"],
      "size": "large",
      "price": 899,
      "model_url": "/models/sofa-001.glb",
      "thumbnail": "/thumbs/sofa-001.jpg",
      "dimensions": {"width": 2.2, "height": 0.9, "depth": 0.95},
      "tags": ["modern", "minimalist", "neutral", "large space"],
      "match_score": 72.3,
      "score_breakdown": {
        "style": 22.5,
        "color_blend": 28.1,
        "mood": 8.2,
        "material": 5.4,
        "lighting": 4.1,
        "space": 2.5,
        "neutral_bonus": 1.5
      }
    }
  ]
}
```

### GET /furniture
Get all furniture items (catalog).

### GET /furniture/{id}
Get specific furniture item by ID.

---

## Furniture Data Structure - All Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `id` | string | Unique identifier | "sofa-001" |
| `name` | string | Display name | "Modern Grey Sofa" |
| `type` | string | Category | "sofa", "chair", "table", "lamp", "shelf", "rug", "decor" |
| `style` | string | Design style | "modern minimalist", "scandinavian", "industrial" |
| `colors` | array | Color names | ["grey", "white"] |
| `size` | string | Size category | "small", "medium", "large" |
| `price` | number | Price in USD | 899 |
| `model_url` | string | **Path to 3D GLB model** | "/models/sofa-001.glb" |
| `thumbnail` | string | Preview image path | "/thumbs/sofa-001.jpg" |
| `dimensions` | object | Size in meters | {"width": 2.2, "height": 0.9, "depth": 0.95} |
| `tags` | array | **Searchable tags** | ["modern", "minimalist", "neutral", "large space"] |
| `match_score` | number | AI match score (0-100) | 72.3 |
| `score_breakdown` | object | Score factors | See below |

---

## How to Extract Tags for Flutter

### 1. Get 3D Model URL (for VR viewing)
```dart
String modelUrl = furnitureItem['model_url'];
// Returns: "/models/sofa-001.glb"
// Combine with your server base URL
String fullModelUrl = 'http://YOUR_IP:8001' + modelUrl;
```

### 2. Get Thumbnail Image
```dart
String thumbnail = furnitureItem['thumbnail'];
// Returns: "/thumbs/sofa-001.jpg"
```

### 3. Get Dimensions (for placement)
```dart
Map dims = furnitureItem['dimensions'];
double width = dims['width'];   // meters
double height = dims['height']; // meters
double depth = dims['depth'];   // meters
```

### 4. Get All Tags (for filtering/search)
```dart
List tags = furnitureItem['tags'];
// Example: ["modern", "minimalist", "neutral", "large space"]

// Filter by tag
if (tags.contains('modern')) { ... }

// Search tags
bool hasMinimalist = tags.any((t) => t.contains('minimalist'));
```

### 5. Get Match Score (for sorting)
```dart
double score = furnitureItem['match_score'];
// 0-100, higher is better match
```

### 6. Get Score Breakdown (for showing why matched)
```dart
Map breakdown = furnitureItem['score_breakdown'];
// {
//   "style": 22.5,
//   "color_blend": 28.1,
//   "mood": 8.2,
//   "material": 5.4,
//   "lighting": 4.1,
//   "space": 2.5,
//   "neutral_bonus": 1.5
// }
```

### 7. Filter by Type
```dart
List allFurniture = response['recommended_furniture'];
List sofas = allFurniture.where((f) => f['type'] == 'sofa').toList();
List chairs = allFurniture.where((f) => f['type'] == 'chair').toList();
```

---

## All Furniture Types
- `sofa` - Sofas and sectionals
- `chair` - Chairs and armchairs
- `table` - Coffee tables, dining tables
- `lamp` - Floor lamps, pendants, chandeliers
- `shelf` - Bookshelves, floating shelves
- `rug` - Rugs and carpets
- `decor` - Wall art, mirrors, sculptures

---

## All Style Values
- modern minimalist
- scandinavian
- classic traditional
- rustic farmhouse
- industrial
- bohemian
- mid-century modern
- contemporary luxury
- coastal beach
- art deco
- japanese zen
- mediterranean
- french country
- urban modern
- transitional

---

## All Tag Values (for filtering)
```
modern, minimalist, neutral, large space, luxury, cool, warm, traditional,
wooden, metal, glass, fabric, velvet, leather, natural, bright, airy, clean,
scandinavian, retro, cozy, rustic, farmhouse, eclectic, colorful, dramatic,
industrial, dark, urban, dramatic, art deco, gold, silver, elegant, refined,
rich, soft, comfortable, colorful, bold, vibrant, organic, earth, natural,
warm lighting, cool lighting, soft, clean, fresh, crisp, comfortable
```

---

## Color Temperature (from dominant_colors)
- `"temperature"`: "warm" | "cool" | "neutral"
- `"saturation"`: "desaturated" | "muted" | "moderate" | "saturated" | "vibrant"
- `"brightness_level"`: "very dark" | "dark" | "medium" | "bright" | "very bright"

Use these to filter furniture by room mood:
```dart
String temp = response['dominant_colors']['temperature']; // "neutral"
String brightness = response['dominant_colors']['brightness_level']; // "bright"
```

---

## Example: Full Flutter Integration

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class FurnitureService {
  static const String baseUrl = 'http://YOUR_IP:8001';
  
  Future<Map> analyzeRoom(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/analyze'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    
    var response = await request.send();
    var result = await http.Response.fromStream(response);
    return json.decode(result.body);
  }
  
  // Get 3D model URL
  String getModelUrl(Map furniture) {
    return baseUrl + furniture['model_url'];
  }
  
  // Get dimensions for VR placement
  Map getDimensions(Map furniture) {
    return furniture['dimensions'];
  }
  
  // Filter by type
  List filterByType(List furniture, String type) {
    return furniture.where((f) => f['type'] == type).toList();
  }
  
  // Filter by style tag
  List filterByTag(List furniture, String tag) {
    return furniture.where((f) => f['tags'].contains(tag)).toList();
  }
  
  // Sort by match score
  List sortByScore(List furniture) {
    furniture.sort((a, b) => b['match_score'].compareTo(a['match_score']));
    return furniture;
  }
}
```
