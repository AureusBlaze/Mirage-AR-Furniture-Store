import json
import os
import colorsys
import math

class FurnitureMatcher:
    def __init__(self, furniture_dir="data/furniture"):
        self.furniture_dir = furniture_dir
        self.furniture_items = []
        self.furniture_color_map = {}
        self.style_compatibility = {}
        self.load_furniture()
        self._build_style_compatibility()

    def load_furniture(self):
        if not os.path.exists(self.furniture_dir):
            os.makedirs(self.furniture_dir, exist_ok=True)

        has_data = any(f.endswith(".json") for f in os.listdir(self.furniture_dir)) if os.path.exists(self.furniture_dir) else False

        if not has_data:
            self._create_sample_data()

        for filename in os.listdir(self.furniture_dir):
            if filename.endswith(".json"):
                filepath = os.path.join(self.furniture_dir, filename)
                with open(filepath, "r") as f:
                    data = json.load(f)
                    if isinstance(data, list):
                        self.furniture_items.extend(data)
                    else:
                        self.furniture_items.append(data)

        self._build_color_map()

    def _build_color_map(self):
        self.furniture_color_map = {
            "grey": (128, 128, 128), "gray": (128, 128, 128),
            "white": (245, 245, 245), "black": (30, 30, 30),
            "brown": (139, 90, 43), "wood": (160, 120, 80),
            "blue": (70, 130, 180), "navy": (0, 0, 128),
            "green": (80, 160, 80), "olive": (128, 128, 0),
            "emerald": (0, 150, 100), "sage": (128, 140, 100),
            "red": (200, 50, 50), "burgundy": (128, 0, 32),
            "orange": (255, 165, 0), "yellow": (255, 220, 50),
            "gold": (212, 175, 55), "beige": (245, 235, 210),
            "cream": (255, 253, 240), "natural": (210, 180, 140),
            "charcoal": (54, 69, 79), "silver": (192, 192, 192),
            "clear": (200, 220, 240), "metal": (170, 170, 175),
            "leather": (140, 100, 70), "mirror": (200, 210, 220),
            "teal": (0, 128, 128), "purple": (128, 0, 128),
            "pink": (255, 182, 193), "coral": (255, 127, 80),
            "terracotta": (204, 78, 92), "rust": (183, 65, 14),
            "ivory": (255, 255, 240), "tan": (210, 180, 140),
            "mahogany": (192, 64, 0), "walnut": (93, 56, 35),
            "oak": (200, 170, 110), "pine": (220, 200, 150),
            "copper": (184, 115, 51), "bronze": (205, 127, 50),
            "platinum": (229, 228, 226), "pearl": (234, 224, 200),
        }

    def _build_style_compatibility(self):
        self.style_compatibility = {
            "modern minimalist": {
                "modern minimalist": 1.0, "scandinavian": 0.85, "contemporary luxury": 0.75,
                "industrial": 0.65, "urban modern": 0.7, "japanese zen": 0.7,
                "mid-century modern": 0.6, "transitional": 0.55, "coastal beach": 0.4,
                "art deco": 0.35, "classic traditional": 0.25, "rustic farmhouse": 0.2,
                "bohemian": 0.2, "mediterranean": 0.25, "french country": 0.2
            },
            "scandinavian": {
                "scandinavian": 1.0, "modern minimalist": 0.85, "japanese zen": 0.8,
                "coastal beach": 0.7, "transitional": 0.65, "contemporary luxury": 0.6,
                "mid-century modern": 0.55, "rustic farmhouse": 0.5, "urban modern": 0.5,
                "french country": 0.45, "industrial": 0.35, "bohemian": 0.3,
                "art deco": 0.25, "classic traditional": 0.2, "mediterranean": 0.25
            },
            "classic traditional": {
                "classic traditional": 1.0, "french country": 0.85, "transitional": 0.8,
                "art deco": 0.7, "contemporary luxury": 0.65, "mediterranean": 0.6,
                "rustic farmhouse": 0.55, "mid-century modern": 0.4, "coastal beach": 0.35,
                "modern minimalist": 0.25, "scandinavian": 0.2, "industrial": 0.2,
                "bohemian": 0.25, "urban modern": 0.15, "japanese zen": 0.2
            },
            "rustic farmhouse": {
                "rustic farmhouse": 1.0, "french country": 0.8, "classic traditional": 0.65,
                "scandinavian": 0.55, "coastal beach": 0.55, "transitional": 0.6,
                "bohemian": 0.55, "mediterranean": 0.5, "mid-century modern": 0.4,
                "industrial": 0.35, "contemporary luxury": 0.3, "modern minimalist": 0.2,
                "urban modern": 0.2, "art deco": 0.2, "japanese zen": 0.25
            },
            "industrial": {
                "industrial": 1.0, "urban modern": 0.85, "modern minimalist": 0.65,
                "contemporary luxury": 0.55, "mid-century modern": 0.5, "art deco": 0.5,
                "rustic farmhouse": 0.35, "transitional": 0.4, "scandinavian": 0.35,
                "classic traditional": 0.2, "coastal beach": 0.2, "bohemian": 0.3,
                "mediterranean": 0.2, "french country": 0.15, "japanese zen": 0.2
            },
            "bohemian": {
                "bohemian": 1.0, "rustic farmhouse": 0.65, "coastal beach": 0.6,
                "mediterranean": 0.6, "french country": 0.55, "classic traditional": 0.35,
                "transitional": 0.45, "scandinavian": 0.3, "mid-century modern": 0.4,
                "industrial": 0.3, "contemporary luxury": 0.25, "modern minimalist": 0.2,
                "urban modern": 0.25, "art deco": 0.3, "japanese zen": 0.2
            },
            "mid-century modern": {
                "mid-century modern": 1.0, "modern minimalist": 0.6, "contemporary luxury": 0.6,
                "scandinavian": 0.55, "transitional": 0.6, "art deco": 0.55,
                "industrial": 0.5, "classic traditional": 0.4, "urban modern": 0.5,
                "rustic farmhouse": 0.4, "coastal beach": 0.35, "bohemian": 0.4,
                "mediterranean": 0.3, "french country": 0.3, "japanese zen": 0.35
            },
            "contemporary luxury": {
                "contemporary luxury": 1.0, "art deco": 0.8, "modern minimalist": 0.75,
                "classic traditional": 0.65, "transitional": 0.7, "mid-century modern": 0.6,
                "urban modern": 0.6, "industrial": 0.55, "scandinavian": 0.6,
                "coastal beach": 0.4, "mediterranean": 0.4, "rustic farmhouse": 0.3,
                "bohemian": 0.25, "french country": 0.35, "japanese zen": 0.35
            },
            "coastal beach": {
                "coastal beach": 1.0, "scandinavian": 0.7, "rustic farmhouse": 0.55,
                "bohemian": 0.6, "mediterranean": 0.6, "french country": 0.55,
                "transitional": 0.55, "modern minimalist": 0.4, "japanese zen": 0.45,
                "classic traditional": 0.35, "mid-century modern": 0.35, "contemporary luxury": 0.4,
                "industrial": 0.2, "urban modern": 0.25, "art deco": 0.25
            },
            "art deco": {
                "art deco": 1.0, "contemporary luxury": 0.8, "classic traditional": 0.7,
                "mid-century modern": 0.55, "transitional": 0.6, "industrial": 0.5,
                "urban modern": 0.45, "modern minimalist": 0.35, "mediterranean": 0.4,
                "scandinavian": 0.25, "rustic farmhouse": 0.2, "coastal beach": 0.25,
                "bohemian": 0.3, "french country": 0.35, "japanese zen": 0.2
            },
            "japanese zen": {
                "japanese zen": 1.0, "scandinavian": 0.8, "modern minimalist": 0.7,
                "coastal beach": 0.45, "transitional": 0.5, "contemporary luxury": 0.35,
                "mid-century modern": 0.35, "rustic farmhouse": 0.3, "urban modern": 0.35,
                "industrial": 0.2, "classic traditional": 0.2, "bohemian": 0.2,
                "mediterranean": 0.25, "french country": 0.2, "art deco": 0.2
            },
            "mediterranean": {
                "mediterranean": 1.0, "rustic farmhouse": 0.55, "classic traditional": 0.6,
                "bohemian": 0.6, "coastal beach": 0.6, "french country": 0.55,
                "transitional": 0.5, "contemporary luxury": 0.4, "mid-century modern": 0.3,
                "art deco": 0.4, "scandinavian": 0.25, "modern minimalist": 0.25,
                "industrial": 0.2, "urban modern": 0.2, "japanese zen": 0.25
            },
            "french country": {
                "french country": 1.0, "classic traditional": 0.85, "rustic farmhouse": 0.8,
                "bohemian": 0.55, "coastal beach": 0.55, "mediterranean": 0.55,
                "transitional": 0.65, "scandinavian": 0.45, "contemporary luxury": 0.35,
                "mid-century modern": 0.3, "art deco": 0.35, "modern minimalist": 0.2,
                "industrial": 0.15, "urban modern": 0.2, "japanese zen": 0.2
            },
            "urban modern": {
                "urban modern": 1.0, "industrial": 0.85, "modern minimalist": 0.7,
                "contemporary luxury": 0.6, "mid-century modern": 0.5, "art deco": 0.45,
                "transitional": 0.45, "scandinavian": 0.5, "classic traditional": 0.2,
                "rustic farmhouse": 0.2, "coastal beach": 0.25, "bohemian": 0.25,
                "mediterranean": 0.2, "french country": 0.2, "japanese zen": 0.35
            },
            "transitional": {
                "transitional": 1.0, "classic traditional": 0.8, "contemporary luxury": 0.7,
                "modern minimalist": 0.55, "scandinavian": 0.65, "mid-century modern": 0.6,
                "french country": 0.65, "rustic farmhouse": 0.6, "coastal beach": 0.55,
                "art deco": 0.6, "industrial": 0.4, "urban modern": 0.45,
                "bohemian": 0.45, "mediterranean": 0.5, "japanese zen": 0.5
            }
        }

    def _create_sample_data(self):
        sample = [
            {"id": "sofa-001", "name": "Modern Grey Sofa", "type": "sofa", "style": "modern minimalist", "colors": ["grey", "white"], "size": "large", "price": 899, "model_url": "/models/sofa-001.glb", "thumbnail": "/thumbs/sofa-001.jpg", "dimensions": {"width": 2.2, "height": 0.9, "depth": 0.95}, "tags": ["modern", "minimalist", "neutral", "large space"]},
            {"id": "sofa-002", "name": "Velvet Blue Sofa", "type": "sofa", "style": "contemporary luxury", "colors": ["blue", "navy"], "size": "large", "price": 1299, "model_url": "/models/sofa-002.glb", "thumbnail": "/thumbs/sofa-002.jpg", "dimensions": {"width": 2.4, "height": 0.85, "depth": 1.0}, "tags": ["luxury", "cool", "modern", "soft"]},
            {"id": "sofa-003", "name": "Classic Brown Leather Sofa", "type": "sofa", "style": "classic traditional", "colors": ["brown", "leather"], "size": "large", "price": 1499, "model_url": "/models/sofa-003.glb", "thumbnail": "/thumbs/sofa-003.jpg", "dimensions": {"width": 2.3, "height": 0.9, "depth": 0.95}, "tags": ["classic", "warm", "traditional", "leather"]},
            {"id": "sofa-004", "name": "Scandinavian White Sofa", "type": "sofa", "style": "scandinavian", "colors": ["white", "cream"], "size": "medium", "price": 799, "model_url": "/models/sofa-004.glb", "thumbnail": "/thumbs/sofa-004.jpg", "dimensions": {"width": 2.0, "height": 0.8, "depth": 0.9}, "tags": ["scandinavian", "bright", "minimalist", "clean"]},
            {"id": "sofa-005", "name": "Bohemian Pattern Sofa", "type": "sofa", "style": "bohemian", "colors": ["orange", "brown"], "size": "medium", "price": 999, "model_url": "/models/sofa-005.glb", "thumbnail": "/thumbs/sofa-005.jpg", "dimensions": {"width": 2.1, "height": 0.85, "depth": 0.92}, "tags": ["bohemian", "eclectic", "warm", "colorful"]},
            {"id": "sofa-006", "name": "Industrial Grey Sectional", "type": "sofa", "style": "industrial", "colors": ["grey", "charcoal"], "size": "large", "price": 1199, "model_url": "/models/sofa-006.glb", "thumbnail": "/thumbs/sofa-006.jpg", "dimensions": {"width": 2.8, "height": 0.85, "depth": 1.6}, "tags": ["industrial", "dark", "modern", "metal"]},
            {"id": "sofa-007", "name": "Mid-Century Green Sofa", "type": "sofa", "style": "mid-century modern", "colors": ["green", "olive"], "size": "medium", "price": 1099, "model_url": "/models/sofa-007.glb", "thumbnail": "/thumbs/sofa-007.jpg", "dimensions": {"width": 2.15, "height": 0.82, "depth": 0.88}, "tags": ["mid-century", "retro", "warm", "wood"]},
            {"id": "sofa-008", "name": "Coastal Beige Sofa", "type": "sofa", "style": "coastal beach", "colors": ["beige", "white"], "size": "large", "price": 949, "model_url": "/models/sofa-008.glb", "thumbnail": "/thumbs/sofa-008.jpg", "dimensions": {"width": 2.25, "height": 0.88, "depth": 0.93}, "tags": ["coastal", "bright", "airy", "natural"]},
            {"id": "sofa-009", "name": "Art Deco Black Sofa", "type": "sofa", "style": "art deco", "colors": ["black", "gold"], "size": "medium", "price": 1599, "model_url": "/models/sofa-009.glb", "thumbnail": "/thumbs/sofa-009.jpg", "dimensions": {"width": 2.1, "height": 0.87, "depth": 0.9}, "tags": ["art deco", "luxury", "dark", "dramatic"]},
            {"id": "sofa-010", "name": "Rustic Linen Sofa", "type": "sofa", "style": "rustic farmhouse", "colors": ["beige", "natural"], "size": "large", "price": 849, "model_url": "/models/sofa-010.glb", "thumbnail": "/thumbs/sofa-010.jpg", "dimensions": {"width": 2.3, "height": 0.9, "depth": 0.95}, "tags": ["rustic", "farmhouse", "warm", "cozy"]},
            {"id": "chair-001", "name": "Classic Wooden Chair", "type": "chair", "style": "classic traditional", "colors": ["brown", "wood"], "size": "small", "price": 299, "model_url": "/models/chair-001.glb", "thumbnail": "/thumbs/chair-001.jpg", "dimensions": {"width": 0.55, "height": 0.95, "depth": 0.55}, "tags": ["classic", "wooden", "traditional", "warm"]},
            {"id": "chair-002", "name": "Modern White Accent Chair", "type": "chair", "style": "modern minimalist", "colors": ["white", "grey"], "size": "small", "price": 399, "model_url": "/models/chair-002.glb", "thumbnail": "/thumbs/chair-002.jpg", "dimensions": {"width": 0.75, "height": 0.85, "depth": 0.8}, "tags": ["modern", "minimalist", "neutral", "clean"]},
            {"id": "chair-003", "name": "Velvet Emerald Armchair", "type": "chair", "style": "contemporary luxury", "colors": ["green", "emerald"], "size": "small", "price": 549, "model_url": "/models/chair-003.glb", "thumbnail": "/thumbs/chair-003.jpg", "dimensions": {"width": 0.8, "height": 0.9, "depth": 0.85}, "tags": ["luxury", "modern", "rich", "soft"]},
            {"id": "chair-004", "name": "Rattan Peacock Chair", "type": "chair", "style": "bohemian", "colors": ["brown", "natural"], "size": "medium", "price": 449, "model_url": "/models/chair-004.glb", "thumbnail": "/thumbs/chair-004.jpg", "dimensions": {"width": 0.85, "height": 1.5, "depth": 0.7}, "tags": ["bohemian", "eclectic", "natural", "warm"]},
            {"id": "chair-005", "name": "Industrial Metal Chair", "type": "chair", "style": "industrial", "colors": ["black", "metal"], "size": "small", "price": 249, "model_url": "/models/chair-005.glb", "thumbnail": "/thumbs/chair-005.jpg", "dimensions": {"width": 0.5, "height": 0.85, "depth": 0.5}, "tags": ["industrial", "metal", "dark", "modern"]},
            {"id": "chair-006", "name": "Scandinavian Oak Chair", "type": "chair", "style": "scandinavian", "colors": ["white", "wood"], "size": "small", "price": 329, "model_url": "/models/chair-006.glb", "thumbnail": "/thumbs/chair-006.jpg", "dimensions": {"width": 0.52, "height": 0.82, "depth": 0.52}, "tags": ["scandinavian", "minimalist", "bright", "natural"]},
            {"id": "chair-007", "name": "Mid-Century Walnut Chair", "type": "chair", "style": "mid-century modern", "colors": ["brown", "orange"], "size": "small", "price": 479, "model_url": "/models/chair-007.glb", "thumbnail": "/thumbs/chair-007.jpg", "dimensions": {"width": 0.65, "height": 0.88, "depth": 0.7}, "tags": ["mid-century", "retro", "warm", "wood"]},
            {"id": "chair-008", "name": "Coastal Wicker Chair", "type": "chair", "style": "coastal beach", "colors": ["white", "natural"], "size": "small", "price": 279, "model_url": "/models/chair-008.glb", "thumbnail": "/thumbs/chair-008.jpg", "dimensions": {"width": 0.7, "height": 0.9, "depth": 0.75}, "tags": ["coastal", "bright", "airy", "natural"]},
            {"id": "chair-009", "name": "Art Deco Gold Chair", "type": "chair", "style": "art deco", "colors": ["gold", "black"], "size": "small", "price": 599, "model_url": "/models/chair-009.glb", "thumbnail": "/thumbs/chair-009.jpg", "dimensions": {"width": 0.6, "height": 0.92, "depth": 0.6}, "tags": ["art deco", "luxury", "dramatic", "metal"]},
            {"id": "chair-010", "name": "Farmhouse Rocking Chair", "type": "chair", "style": "rustic farmhouse", "colors": ["white", "wood"], "size": "medium", "price": 349, "model_url": "/models/chair-010.glb", "thumbnail": "/thumbs/chair-010.jpg", "dimensions": {"width": 0.65, "height": 1.1, "depth": 0.9}, "tags": ["rustic", "farmhouse", "warm", "cozy"]},
            {"id": "table-001", "name": "Industrial Coffee Table", "type": "table", "style": "industrial", "colors": ["black", "metal"], "size": "medium", "price": 349, "model_url": "/models/table-001.glb", "thumbnail": "/thumbs/table-001.jpg", "dimensions": {"width": 1.2, "height": 0.45, "depth": 0.6}, "tags": ["industrial", "metal", "dark", "modern"]},
            {"id": "table-002", "name": "Glass Modern Table", "type": "table", "style": "modern minimalist", "colors": ["clear", "silver"], "size": "medium", "price": 499, "model_url": "/models/table-002.glb", "thumbnail": "/thumbs/table-002.jpg", "dimensions": {"width": 1.4, "height": 0.75, "depth": 0.8}, "tags": ["modern", "minimalist", "neutral", "clean"]},
            {"id": "table-003", "name": "Rustic Oak Dining Table", "type": "table", "style": "rustic farmhouse", "colors": ["brown", "wood"], "size": "large", "price": 899, "model_url": "/models/table-003.glb", "thumbnail": "/thumbs/table-003.jpg", "dimensions": {"width": 1.8, "height": 0.76, "depth": 0.9}, "tags": ["rustic", "farmhouse", "warm", "wood"]},
            {"id": "table-004", "name": "Marble Luxury Table", "type": "table", "style": "contemporary luxury", "colors": ["white", "grey"], "size": "medium", "price": 1199, "model_url": "/models/table-004.glb", "thumbnail": "/thumbs/table-004.jpg", "dimensions": {"width": 1.5, "height": 0.5, "depth": 0.75}, "tags": ["luxury", "modern", "clean", "rich"]},
            {"id": "table-005", "name": "Scandinavian Pine Table", "type": "table", "style": "scandinavian", "colors": ["white", "wood"], "size": "medium", "price": 399, "model_url": "/models/table-005.glb", "thumbnail": "/thumbs/table-005.jpg", "dimensions": {"width": 1.3, "height": 0.74, "depth": 0.75}, "tags": ["scandinavian", "minimalist", "bright", "natural"]},
            {"id": "table-006", "name": "Bohemian Mosaic Table", "type": "table", "style": "bohemian", "colors": ["blue", "brown"], "size": "small", "price": 299, "model_url": "/models/table-006.glb", "thumbnail": "/thumbs/table-006.jpg", "dimensions": {"width": 0.6, "height": 0.55, "depth": 0.6}, "tags": ["bohemian", "eclectic", "colorful", "warm"]},
            {"id": "table-007", "name": "Mid-Century Teak Table", "type": "table", "style": "mid-century modern", "colors": ["brown", "wood"], "size": "medium", "price": 649, "model_url": "/models/table-007.glb", "thumbnail": "/thumbs/table-007.jpg", "dimensions": {"width": 1.4, "height": 0.72, "depth": 0.8}, "tags": ["mid-century", "retro", "warm", "wood"]},
            {"id": "table-008", "name": "Coastal Driftwood Table", "type": "table", "style": "coastal beach", "colors": ["white", "natural"], "size": "small", "price": 349, "model_url": "/models/table-008.glb", "thumbnail": "/thumbs/table-008.jpg", "dimensions": {"width": 1.0, "height": 0.5, "depth": 0.5}, "tags": ["coastal", "bright", "airy", "natural"]},
            {"id": "table-009", "name": "Art Deco Lacquer Table", "type": "table", "style": "art deco", "colors": ["black", "gold"], "size": "medium", "price": 799, "model_url": "/models/table-009.glb", "thumbnail": "/thumbs/table-009.jpg", "dimensions": {"width": 1.2, "height": 0.48, "depth": 0.65}, "tags": ["art deco", "luxury", "dark", "dramatic"]},
            {"id": "table-010", "name": "Classic Mahogany Table", "type": "table", "style": "classic traditional", "colors": ["brown", "red"], "size": "large", "price": 1099, "model_url": "/models/table-010.glb", "thumbnail": "/thumbs/table-010.jpg", "dimensions": {"width": 1.6, "height": 0.76, "depth": 0.9}, "tags": ["classic", "traditional", "warm", "wood"]},
            {"id": "lamp-001", "name": "Scandinavian Floor Lamp", "type": "lamp", "style": "scandinavian", "colors": ["white", "wood"], "size": "small", "price": 129, "model_url": "/models/lamp-001.glb", "thumbnail": "/thumbs/lamp-001.jpg", "dimensions": {"width": 0.35, "height": 1.65, "depth": 0.35}, "tags": ["scandinavian", "minimalist", "bright", "warm lighting"]},
            {"id": "lamp-002", "name": "Industrial Pendant Light", "type": "lamp", "style": "industrial", "colors": ["black", "metal"], "size": "small", "price": 179, "model_url": "/models/lamp-002.glb", "thumbnail": "/thumbs/lamp-002.jpg", "dimensions": {"width": 0.4, "height": 0.5, "depth": 0.4}, "tags": ["industrial", "metal", "dark", "dramatic"]},
            {"id": "lamp-003", "name": "Crystal Chandelier", "type": "lamp", "style": "contemporary luxury", "colors": ["clear", "gold"], "size": "medium", "price": 899, "model_url": "/models/lamp-003.glb", "thumbnail": "/thumbs/lamp-003.jpg", "dimensions": {"width": 0.8, "height": 0.6, "depth": 0.8}, "tags": ["luxury", "dramatic", "bright", "rich"]},
            {"id": "lamp-004", "name": "Bohemian Rattan Lamp", "type": "lamp", "style": "bohemian", "colors": ["brown", "natural"], "size": "small", "price": 99, "model_url": "/models/lamp-004.glb", "thumbnail": "/thumbs/lamp-004.jpg", "dimensions": {"width": 0.3, "height": 0.45, "depth": 0.3}, "tags": ["bohemian", "eclectic", "warm", "natural"]},
            {"id": "lamp-005", "name": "Modern LED Desk Lamp", "type": "lamp", "style": "modern minimalist", "colors": ["white", "silver"], "size": "small", "price": 79, "model_url": "/models/lamp-005.glb", "thumbnail": "/thumbs/lamp-005.jpg", "dimensions": {"width": 0.2, "height": 0.45, "depth": 0.15}, "tags": ["modern", "minimalist", "clean", "cool lighting"]},
            {"id": "lamp-006", "name": "Farmhouse Lantern Lamp", "type": "lamp", "style": "rustic farmhouse", "colors": ["brown", "metal"], "size": "small", "price": 149, "model_url": "/models/lamp-006.glb", "thumbnail": "/thumbs/lamp-006.jpg", "dimensions": {"width": 0.25, "height": 0.55, "depth": 0.25}, "tags": ["rustic", "farmhouse", "warm", "cozy"]},
            {"id": "lamp-007", "name": "Mid-Century Arc Lamp", "type": "lamp", "style": "mid-century modern", "colors": ["gold", "white"], "size": "medium", "price": 249, "model_url": "/models/lamp-007.glb", "thumbnail": "/thumbs/lamp-007.jpg", "dimensions": {"width": 0.4, "height": 1.8, "depth": 0.6}, "tags": ["mid-century", "retro", "warm", "dramatic"]},
            {"id": "lamp-008", "name": "Coastal Rope Lamp", "type": "lamp", "style": "coastal beach", "colors": ["white", "natural"], "size": "small", "price": 119, "model_url": "/models/lamp-008.glb", "thumbnail": "/thumbs/lamp-008.jpg", "dimensions": {"width": 0.3, "height": 0.4, "depth": 0.3}, "tags": ["coastal", "bright", "airy", "natural"]},
            {"id": "lamp-009", "name": "Art Deco Sconce", "type": "lamp", "style": "art deco", "colors": ["gold", "black"], "size": "small", "price": 199, "model_url": "/models/lamp-009.glb", "thumbnail": "/thumbs/lamp-009.jpg", "dimensions": {"width": 0.2, "height": 0.35, "depth": 0.15}, "tags": ["art deco", "luxury", "dramatic", "warm lighting"]},
            {"id": "lamp-010", "name": "Classic Tiffany Lamp", "type": "lamp", "style": "classic traditional", "colors": ["green", "gold"], "size": "small", "price": 349, "model_url": "/models/lamp-010.glb", "thumbnail": "/thumbs/lamp-010.jpg", "dimensions": {"width": 0.35, "height": 0.6, "depth": 0.35}, "tags": ["classic", "traditional", "warm", "colorful"]},
            {"id": "shelf-001", "name": "Bohemian Bookshelf", "type": "shelf", "style": "bohemian", "colors": ["brown", "natural"], "size": "large", "price": 449, "model_url": "/models/shelf-001.glb", "thumbnail": "/thumbs/shelf-001.jpg", "dimensions": {"width": 1.2, "height": 1.8, "depth": 0.35}, "tags": ["bohemian", "eclectic", "warm", "colorful"]},
            {"id": "shelf-002", "name": "Industrial Pipe Shelf", "type": "shelf", "style": "industrial", "colors": ["black", "wood"], "size": "medium", "price": 299, "model_url": "/models/shelf-002.glb", "thumbnail": "/thumbs/shelf-002.jpg", "dimensions": {"width": 1.0, "height": 1.2, "depth": 0.3}, "tags": ["industrial", "metal", "dark", "modern"]},
            {"id": "shelf-003", "name": "Scandinavian Floating Shelf", "type": "shelf", "style": "scandinavian", "colors": ["white", "wood"], "size": "small", "price": 89, "model_url": "/models/shelf-003.glb", "thumbnail": "/thumbs/shelf-003.jpg", "dimensions": {"width": 0.8, "height": 0.05, "depth": 0.2}, "tags": ["scandinavian", "minimalist", "bright", "clean"]},
            {"id": "shelf-004", "name": "Modern Glass Shelf", "type": "shelf", "style": "modern minimalist", "colors": ["clear", "silver"], "size": "medium", "price": 199, "model_url": "/models/shelf-004.glb", "thumbnail": "/thumbs/shelf-004.jpg", "dimensions": {"width": 0.9, "height": 1.5, "depth": 0.3}, "tags": ["modern", "minimalist", "neutral", "clean"]},
            {"id": "shelf-005", "name": "Rustic Barnwood Shelf", "type": "shelf", "style": "rustic farmhouse", "colors": ["brown", "wood"], "size": "medium", "price": 249, "model_url": "/models/shelf-005.glb", "thumbnail": "/thumbs/shelf-005.jpg", "dimensions": {"width": 1.1, "height": 1.4, "depth": 0.35}, "tags": ["rustic", "farmhouse", "warm", "cozy"]},
            {"id": "shelf-006", "name": "Luxury Walnut Shelf", "type": "shelf", "style": "contemporary luxury", "colors": ["brown", "gold"], "size": "large", "price": 599, "model_url": "/models/shelf-006.glb", "thumbnail": "/thumbs/shelf-006.jpg", "dimensions": {"width": 1.4, "height": 2.0, "depth": 0.4}, "tags": ["luxury", "modern", "rich", "warm"]},
            {"id": "shelf-007", "name": "Mid-Century Etagere", "type": "shelf", "style": "mid-century modern", "colors": ["brown", "metal"], "size": "large", "price": 499, "model_url": "/models/shelf-007.glb", "thumbnail": "/thumbs/shelf-007.jpg", "dimensions": {"width": 1.0, "height": 1.75, "depth": 0.35}, "tags": ["mid-century", "retro", "warm", "metal"]},
            {"id": "shelf-008", "name": "Coastal Whitewash Shelf", "type": "shelf", "style": "coastal beach", "colors": ["white", "natural"], "size": "medium", "price": 179, "model_url": "/models/shelf-008.glb", "thumbnail": "/thumbs/shelf-008.jpg", "dimensions": {"width": 0.85, "height": 1.3, "depth": 0.3}, "tags": ["coastal", "bright", "airy", "natural"]},
            {"id": "shelf-009", "name": "Art Deco Mirrored Shelf", "type": "shelf", "style": "art deco", "colors": ["gold", "mirror"], "size": "medium", "price": 449, "model_url": "/models/shelf-009.glb", "thumbnail": "/thumbs/shelf-009.jpg", "dimensions": {"width": 1.0, "height": 1.6, "depth": 0.3}, "tags": ["art deco", "luxury", "dramatic", "rich"]},
            {"id": "shelf-010", "name": "Classic Mahogany Shelf", "type": "shelf", "style": "classic traditional", "colors": ["brown", "red"], "size": "large", "price": 549, "model_url": "/models/shelf-010.glb", "thumbnail": "/thumbs/shelf-010.jpg", "dimensions": {"width": 1.3, "height": 1.9, "depth": 0.4}, "tags": ["classic", "traditional", "warm", "wood"]},
            {"id": "rug-001", "name": "Persian Red Rug", "type": "rug", "style": "classic traditional", "colors": ["red", "gold"], "size": "large", "price": 799, "model_url": "/models/rug-001.glb", "thumbnail": "/thumbs/rug-001.jpg", "dimensions": {"width": 2.5, "height": 0.02, "depth": 3.5}, "tags": ["classic", "traditional", "warm", "rich"]},
            {"id": "rug-002", "name": "Moroccan Shag Rug", "type": "rug", "style": "bohemian", "colors": ["white", "cream"], "size": "medium", "price": 399, "model_url": "/models/rug-002.glb", "thumbnail": "/thumbs/rug-002.jpg", "dimensions": {"width": 2.0, "height": 0.05, "depth": 3.0}, "tags": ["bohemian", "eclectic", "soft", "neutral"]},
            {"id": "rug-003", "name": "Geometric Modern Rug", "type": "rug", "style": "modern minimalist", "colors": ["grey", "white"], "size": "medium", "price": 299, "model_url": "/models/rug-003.glb", "thumbnail": "/thumbs/rug-003.jpg", "dimensions": {"width": 2.0, "height": 0.02, "depth": 2.8}, "tags": ["modern", "minimalist", "neutral", "clean"]},
            {"id": "rug-004", "name": "Jute Natural Rug", "type": "rug", "style": "coastal beach", "colors": ["beige", "natural"], "size": "large", "price": 249, "model_url": "/models/rug-004.glb", "thumbnail": "/thumbs/rug-004.jpg", "dimensions": {"width": 2.4, "height": 0.03, "depth": 3.3}, "tags": ["coastal", "natural", "airy", "warm"]},
            {"id": "rug-005", "name": "Vintage Distressed Rug", "type": "rug", "style": "rustic farmhouse", "colors": ["blue", "beige"], "size": "large", "price": 549, "model_url": "/models/rug-005.glb", "thumbnail": "/thumbs/rug-005.jpg", "dimensions": {"width": 2.3, "height": 0.02, "depth": 3.2}, "tags": ["rustic", "farmhouse", "warm", "cozy"]},
            {"id": "decor-001", "name": "Abstract Canvas Art", "type": "decor", "style": "modern minimalist", "colors": ["black", "white"], "size": "medium", "price": 199, "model_url": "/models/decor-001.glb", "thumbnail": "/thumbs/decor-001.jpg", "dimensions": {"width": 1.0, "height": 0.8, "depth": 0.05}, "tags": ["modern", "minimalist", "neutral", "dramatic"]},
            {"id": "decor-002", "name": "Macrame Wall Hanging", "type": "decor", "style": "bohemian", "colors": ["white", "cream"], "size": "medium", "price": 89, "model_url": "/models/decor-002.glb", "thumbnail": "/thumbs/decor-002.jpg", "dimensions": {"width": 0.6, "height": 1.0, "depth": 0.05}, "tags": ["bohemian", "eclectic", "natural", "warm"]},
            {"id": "decor-003", "name": "Vintage Mirror", "type": "decor", "style": "classic traditional", "colors": ["gold", "brown"], "size": "medium", "price": 299, "model_url": "/models/decor-003.glb", "thumbnail": "/thumbs/decor-003.jpg", "dimensions": {"width": 0.8, "height": 1.2, "depth": 0.08}, "tags": ["classic", "traditional", "warm", "rich"]},
            {"id": "decor-004", "name": "Metal Wall Sculpture", "type": "decor", "style": "industrial", "colors": ["black", "metal"], "size": "medium", "price": 249, "model_url": "/models/decor-004.glb", "thumbnail": "/thumbs/decor-004.jpg", "dimensions": {"width": 0.9, "height": 0.7, "depth": 0.1}, "tags": ["industrial", "metal", "dark", "modern"]},
            {"id": "decor-005", "name": "Coastal Shell Frame", "type": "decor", "style": "coastal beach", "colors": ["white", "natural"], "size": "small", "price": 59, "model_url": "/models/decor-005.glb", "thumbnail": "/thumbs/decor-005.jpg", "dimensions": {"width": 0.4, "height": 0.5, "depth": 0.05}, "tags": ["coastal", "bright", "airy", "natural"]}
        ]

        filepath = os.path.join(self.furniture_dir, "furniture_catalog.json")
        with open(filepath, "w") as f:
            json.dump(sample, f, indent=2)

    def hex_to_rgb(self, hex_color):
        hex_color = hex_color.lstrip('#')
        return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

    def rgb_to_hsv(self, r, g, b):
        return colorsys.rgb_to_hsv(r/255.0, g/255.0, b/255.0)

    def color_distance(self, rgb1, rgb2):
        return math.sqrt(sum((a-b)**2 for a, b in zip(rgb1, rgb2)))

    def get_color_harmony_score(self, room_rgb, furniture_rgb):
        r_h, r_s, r_v = self.rgb_to_hsv(*room_rgb)
        f_h, f_s, f_v = self.rgb_to_hsv(*furniture_rgb)

        r_h_deg = r_h * 360
        f_h_deg = f_h * 360

        diff = abs(r_h_deg - f_h_deg)
        if diff > 180:
            diff = 360 - diff

        if diff < 15:
            return 1.0
        elif diff < 40:
            return 0.85
        elif diff < 70:
            return 0.65
        elif diff < 100:
            return 0.45
        elif diff < 140:
            return 0.35
        elif diff < 170:
            return 0.5
        return 0.25

    def calculate_color_blend_score(self, room_colors_data, furniture_colors):
        if not room_colors_data or not furniture_colors:
            return 0

        room_colors = room_colors_data.get("colors", []) if isinstance(room_colors_data, dict) else room_colors_data
        if not room_colors:
            return 0

        total_score = 0
        total_weight = 0

        for rc in room_colors[:5]:
            if "hex" in rc:
                room_rgb = self.hex_to_rgb(rc["hex"])
                room_weight = rc.get("percentage", 10) / 100
            elif "rgb" in rc:
                room_rgb = tuple(rc["rgb"])
                room_weight = rc.get("percentage", 10) / 100
            else:
                continue

            best_match_score = 0
            for fc in furniture_colors:
                fc_lower = fc.lower()
                if fc_lower in self.furniture_color_map:
                    furn_rgb = self.furniture_color_map[fc_lower]
                else:
                    continue

                dist = self.color_distance(room_rgb, furn_rgb)
                max_dist = 441.67
                dist_score = max(0, 1 - (dist / max_dist))

                harmony = self.get_color_harmony_score(room_rgb, furn_rgb)

                match_score = (dist_score * 0.5 + harmony * 0.5)
                best_match_score = max(best_match_score, match_score)

            total_score += best_match_score * room_weight
            total_weight += room_weight

        if total_weight == 0:
            return 0

        return (total_score / total_weight) * 100

    def calculate_style_score(self, room_style_results, item_style, item_tags):
        style_lower = item_style.lower()
        tags_lower = [t.lower() for t in item_tags]

        best_score = 0
        for i, style_match in enumerate(room_style_results[:3]):
            label = style_match.get("label", "").lower()
            confidence = style_match.get("confidence", 0)

            style_words = set(style_lower.split())
            label_words = set(label.split())

            overlap = style_words & label_words
            overlap_ratio = len(overlap) / max(len(style_words), len(label_words))

            if overlap_ratio > 0.5:
                weight = max(0.5, 1 - (i * 0.15))
                score = 30 * weight * min(confidence * 3, 1) * overlap_ratio
                best_score = max(best_score, score)
            elif overlap_ratio > 0.2:
                weight = max(0.3, 1 - (i * 0.15))
                score = 15 * weight * min(confidence * 3, 1) * overlap_ratio
                best_score = max(best_score, score)

        compat_scores = []
        for style_match in room_style_results[:3]:
            label = style_match.get("label", "").lower()
            confidence = style_match.get("confidence", 0)

            for known_style, compat_map in self.style_compatibility.items():
                if known_style in label:
                    item_compat = compat_map.get(style_lower, 0.3)
                    compat_scores.append(item_compat * confidence * 20)

        if compat_scores:
            best_compat = max(compat_scores)
            best_score = max(best_score, best_compat)

        return min(best_score, 30)

    def calculate_mood_score(self, room_mood_results, item_tags):
        score = 0
        tags_lower = [t.lower() for t in item_tags]

        mood_tag_map = {
            "calm": ["minimalist", "scandinavian", "neutral", "clean", "serene", "zen", "simple"],
            "cozy": ["warm", "rustic", "farmhouse", "soft", "comfortable", "snug", "homely", "cozy"],
            "elegant": ["luxury", "modern", "contemporary", "refined", "rich", "sophisticated", "elegant"],
            "energetic": ["colorful", "bohemian", "vibrant", "bold", "dynamic", "lively"],
            "dramatic": ["dark", "art deco", "bold", "intense", "striking", "dramatic", "metal"],
            "natural": ["wood", "rattan", "wicker", "organic", "earth", "natural", "bamboo"],
            "romantic": ["soft", "warm", "velvet", "gold", "elegant", "romantic", "intimate"],
            "fresh": ["white", "bright", "clean", "minimalist", "airy", "crisp", "fresh"]
        }

        for mood_match in room_mood_results[:3]:
            label = mood_match.get("label", "").lower()
            confidence = mood_match.get("confidence", 0)

            for mood_key, mood_tags in mood_tag_map.items():
                if mood_key in label:
                    for mt in mood_tags:
                        if mt in tags_lower:
                            weight = max(0.5, 1 - (room_mood_results.index(mood_match) * 0.2))
                            score += 15 * weight * confidence * 3
                            break

        return min(score, 20)

    def calculate_material_score(self, room_material_results, item_tags):
        score = 0
        tags_lower = [t.lower() for t in item_tags]

        material_tag_map = {
            "wooden": ["wood", "wooden", "oak", "walnut", "pine", "natural", "mahogany", "teak"],
            "metal": ["metal", "steel", "iron", "chrome", "industrial", "metal"],
            "glass": ["glass", "clear", "transparent", "modern"],
            "fabric": ["fabric", "soft", "textile", "upholstered", "velvet", "linen"],
            "stone": ["stone", "marble", "granite", "luxury"],
            "leather": ["leather", "classic", "traditional", "rich"],
            "ceramic": ["ceramic", "tile", "pottery", "coastal"],
            "concrete": ["concrete", "industrial", "urban", "modern"],
            "velvet": ["velvet", "soft", "luxury", "plush"],
            "rattan": ["rattan", "wicker", "natural", "bohemian", "coastal", "bamboo"]
        }

        for mat_match in room_material_results[:3]:
            label = mat_match.get("label", "").lower()
            confidence = mat_match.get("confidence", 0)

            for mat_key, mat_tags in material_tag_map.items():
                if mat_key in label:
                    for mt in mat_tags:
                        if mt in tags_lower:
                            weight = max(0.5, 1 - (room_material_results.index(mat_match) * 0.2))
                            score += 10 * weight * confidence * 3
                            break

        return min(score, 15)

    def calculate_lighting_score(self, room_lighting_results, room_colors_data, item_tags):
        score = 0
        tags_lower = [t.lower() for t in item_tags]

        brightness = room_colors_data.get("brightness_level", "medium") if isinstance(room_colors_data, dict) else "medium"
        color_temp = room_colors_data.get("temperature", "neutral") if isinstance(room_colors_data, dict) else "neutral"

        if brightness in ["very dark", "dark"]:
            if any(t in tags_lower for t in ["warm", "cozy", "soft", "snug"]):
                score += 10
            if any(t in tags_lower for t in ["bright", "light", "airy", "clean"]):
                score -= 5
        elif brightness in ["bright", "very bright"]:
            if any(t in tags_lower for t in ["bright", "clean", "minimalist", "airy", "crisp"]):
                score += 10
            if any(t in tags_lower for t in ["dark", "moody", "cozy"]):
                score -= 3

        if color_temp == "warm":
            if any(t in tags_lower for t in ["warm", "wood", "brown", "natural", "rustic"]):
                score += 8
            if any(t in tags_lower for t in ["cool", "metal", "chrome"]):
                score -= 2
        elif color_temp == "cool":
            if any(t in tags_lower for t in ["cool", "metal", "modern", "blue", "clean"]):
                score += 8
            if any(t in tags_lower for t in ["warm", "rustic", "farmhouse"]):
                score -= 2

        for light_match in room_lighting_results[:2]:
            label = light_match.get("label", "").lower()
            if "warm" in label and any(t in tags_lower for t in ["warm", "cozy"]):
                score += 5
            if "bright" in label and any(t in tags_lower for t in ["bright", "minimalist"]):
                score += 5
            if "dramatic" in label and any(t in tags_lower for t in ["dramatic", "luxury"]):
                score += 5

        return max(0, min(score, 15))

    def calculate_space_score(self, room_space_results, item_size):
        if not room_space_results:
            return 5

        space_label = room_space_results[0].get("label", "").lower()

        if "small" in space_label or "compact" in space_label or "narrow" in space_label or "cramped" in space_label:
            if item_size == "small":
                return 12
            elif item_size == "medium":
                return 6
            else:
                return -5
        elif "large" in space_label or "spacious" in space_label or "open" in space_label or "loft" in space_label or "panoramic" in space_label:
            if item_size == "large":
                return 12
            elif item_size == "medium":
                return 8
            else:
                return 4
        elif "minimalist" in space_label or "empty" in space_label:
            if item_size == "medium":
                return 10
            elif item_size == "small":
                return 6
            else:
                return 8
        else:
            if item_size == "medium":
                return 10
            elif item_size == "small":
                return 7
            else:
                return 8

    def calculate_neutral_bonus(self, item_colors, room_colors_data):
        neutral = {"grey", "gray", "white", "beige", "cream", "natural", "wood", "silver", "black", "ivory", "clear", "metal", "mirror"}
        count = sum(1 for c in item_colors if c.lower() in neutral)

        room_temp = room_colors_data.get("temperature", "neutral") if isinstance(room_colors_data, dict) else "neutral"
        room_sat = room_colors_data.get("saturation", "moderate") if isinstance(room_colors_data, dict) else "moderate"

        bonus = 0
        if count >= 2:
            bonus = 8
        elif count >= 1:
            bonus = 4

        if room_sat in ["vibrant", "saturated"] and count >= 1:
            bonus += 3

        if room_temp == "neutral" and count >= 1:
            bonus += 2

        return min(bonus, 12)

    def match(self, analysis_results, top_k=20):
        if not self.furniture_items:
            return {"error": "No furniture data available"}

        style = analysis_results.get("style", [])
        color_palette = analysis_results.get("color_palette", [])
        lighting = analysis_results.get("lighting", [])
        space = analysis_results.get("space", [])
        mood = analysis_results.get("mood", [])
        materials = analysis_results.get("materials", [])
        dominant_colors = analysis_results.get("dominant_colors", {})

        scored_items = []
        for item in self.furniture_items:
            item_style = item.get("style", "")
            item_tags = item.get("tags", [])
            item_colors = item.get("colors", [])
            item_size = item.get("size", "medium")

            style_score = self.calculate_style_score(style, item_style, item_tags)
            color_score = self.calculate_color_blend_score(dominant_colors, item_colors)
            mood_score = self.calculate_mood_score(mood, item_tags)
            material_score = self.calculate_material_score(materials, item_tags)
            lighting_score = self.calculate_lighting_score(lighting, dominant_colors, item_tags)
            space_score = self.calculate_space_score(space, item_size)
            neutral_bonus = self.calculate_neutral_bonus(item_colors, dominant_colors)

            total_score = (
                style_score * 0.25 +
                color_score * 0.30 +
                mood_score * 0.15 +
                material_score * 0.10 +
                lighting_score * 0.08 +
                space_score * 0.07 +
                neutral_bonus * 0.05
            )

            scored_items.append({
                "item": item,
                "score": round(total_score, 1),
                "breakdown": {
                    "style": round(style_score, 1),
                    "color_blend": round(color_score, 1),
                    "mood": round(mood_score, 1),
                    "material": round(material_score, 1),
                    "lighting": round(lighting_score, 1),
                    "space": round(space_score, 1),
                    "neutral_bonus": round(neutral_bonus, 1)
                }
            })

        scored_items.sort(key=lambda x: x["score"], reverse=True)

        style_label = style[0].get("label", "") if style else ""
        palette_label = color_palette[0].get("label", "") if color_palette else ""
        lighting_label = lighting[0].get("label", "") if lighting else ""
        space_label = space[0].get("label", "") if space else ""

        return {
            "status": "success",
            "room_analysis": {
                "style": style_label,
                "color_palette": palette_label,
                "lighting": lighting_label,
                "space": space_label
            },
            "recommended_furniture": [
                {**entry["item"], "match_score": entry["score"], "score_breakdown": entry["breakdown"]}
                for entry in scored_items[:top_k]
            ],
            "all_furniture": [
                {**entry["item"], "match_score": entry["score"]}
                for entry in scored_items
            ]
        }
