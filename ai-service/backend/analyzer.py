import clip
import torch
from PIL import Image
import numpy as np
import os
from sklearn.cluster import MiniBatchKMeans

class ImageAnalyzer:
    def __init__(self):
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        model_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "models", "ViT-L-14.pt")
        self.model, self.preprocess = clip.load(model_path, device=self.device)
        self._init_descriptors()

    def _init_descriptors(self):
        self.room_type_descriptors = [
            "a living room with sofa and coffee table and seating area",
            "a bedroom with bed and nightstands and wardrobe",
            "a dining room with dining table and dining chairs",
            "a kitchen with cabinets and countertops and appliances",
            "a home office with desk and office chair and computer",
            "a bathroom with bathtub and vanity and mirror",
            "a hallway or entryway with console table",
            "a children's room or nursery with toys and small furniture",
            "a study room with bookshelves and reading chair",
            "an outdoor patio or terrace with outdoor furniture"
        ]

        self.style_descriptors = [
            "modern minimalist interior with clean lines simple furniture neutral colors and open space",
            "classic traditional interior with ornate details rich dark wood traditional furniture and elegant decor",
            "rustic farmhouse interior with natural wood vintage furniture exposed beams and country charm",
            "industrial loft interior with exposed brick metal pipes raw concrete and warehouse aesthetic",
            "bohemian eclectic interior with colorful patterns layered textiles plants and global decor",
            "scandinavian interior with light wood white walls minimal furniture and cozy hygge feeling",
            "mid-century modern interior with retro furniture tapered legs warm wood tones and geometric shapes",
            "contemporary luxury interior with marble gold accents high-end materials and sophisticated design",
            "coastal beach house interior with blue white colors natural fibers driftwood and ocean vibes",
            "art deco interior with geometric patterns gold chrome accents bold colors and glamorous style",
            "japanese zen interior with minimal furniture natural materials shoji screens and peaceful atmosphere",
            "mediterranean interior with terracotta warm colors arched doorways and rustic tiles",
            "french country interior with floral patterns distressed furniture soft pastels and romantic feel",
            "urban modern interior with concrete glass steel and city apartment aesthetic",
            "transitional interior blending traditional elegance with contemporary clean lines"
        ]

        self.color_palette_descriptors = [
            "warm room with red orange yellow amber golden and earth tones",
            "cool room with blue green teal purple and icy tones",
            "neutral room with white beige cream ivory gray and taupe tones",
            "dark moody room with black charcoal navy deep burgundy and rich dark colors",
            "bright airy room with white light gray pastel colors and lots of natural light",
            "earth tone room with brown terracotta olive green tan and organic colors",
            "monochromatic room with varying shades of a single color",
            "bold colorful room with vibrant saturated contrasting colors",
            "muted soft room with dusty rose sage green lavender and subdued colors",
            "natural room with wood tones forest green stone colors and organic palette"
        ]

        self.lighting_descriptors = [
            "bright naturally lit room with large windows sunlight and airy feeling",
            "dimly lit cozy room with warm ambient lighting and intimate atmosphere",
            "dramatically lit room with spotlights strong shadows and theatrical lighting",
            "soft diffused lighting room with gentle even glow and no harsh shadows",
            "warm golden hour lighting in the room with sunset tones",
            "cool blue daylight lighting in the room with overcast sky feeling",
            "evenly lit room with uniform artificial overhead lighting",
            "moody atmospheric room with low light candles and table lamps",
            "bright white lighting in the room with cool LED or fluorescent lights",
            "romantic warm dim lighting with multiple small light sources"
        ]

        self.space_descriptors = [
            "small compact cozy room with limited floor space",
            "medium sized comfortable room with balanced proportions",
            "large spacious open room with high ceilings and lots of space",
            "open plan room flowing into other areas without walls",
            "narrow long corridor-like room with limited width",
            "square proportional balanced room with equal dimensions",
            "loft room with exposed ceiling beams and vertical open space",
            "cramped cluttered room with many items and little empty space",
            "minimalist room with lots of negative empty space",
            "wide panoramic room with expansive horizontal space"
        ]

        self.material_descriptors = [
            "wooden room with natural wood grain furniture hardwood floors and timber elements",
            "metal room with steel iron chrome surfaces and industrial metal furniture",
            "glass room with transparent glass tables windows and reflective surfaces",
            "fabric room with soft textiles upholstered furniture curtains and woven elements",
            "stone room with marble granite natural stone surfaces and stone flooring",
            "leather room with leather furniture leather accents and rich leather textures",
            "ceramic room with ceramic tiles pottery elements and glazed surfaces",
            "concrete room with raw industrial concrete surfaces and cement floors",
            "velvet room with plush soft velvet furniture and luxurious fabric textures",
            "rattan and wicker room with woven natural materials and bamboo elements"
        ]

        self.mood_descriptors = [
            "calm peaceful relaxing serene tranquil room with soothing atmosphere",
            "energetic vibrant dynamic lively room with exciting atmosphere",
            "cozy warm comfortable inviting homely room with snug feeling",
            "elegant sophisticated refined luxurious room with upscale atmosphere",
            "playful fun whimsical cheerful colorful room with joyful feeling",
            "serious formal professional corporate room with business atmosphere",
            "romantic intimate warm sensual room with passionate atmosphere",
            "fresh clean crisp modern room with hygienic pure feeling",
            "dramatic bold intense striking room with powerful visual impact",
            "natural organic earthy grounded room with connection to nature"
        ]

        self.furniture_present_descriptors = [
            "room with sofa or couch seating furniture",
            "room with armchair or accent chair",
            "room with coffee table or side table",
            "room with dining table and dining chairs",
            "room with bed and bedding",
            "room with bookshelf or wall shelving",
            "room with desk or workspace furniture",
            "room with TV stand or entertainment center",
            "room with rug or carpet on the floor",
            "room with indoor plants or greenery",
            "room with curtains or window treatments",
            "room with floor lamps or ceiling lights",
            "room with artwork pictures or wall decor",
            "room with wall mirror or decorative mirror",
            "room with cabinet or storage furniture"
        ]

    def encode_descriptors(self, descriptors):
        tokens = clip.tokenize(descriptors, truncate=True).to(self.device)
        with torch.no_grad():
            features = self.model.encode_text(tokens)
        return features / features.norm(dim=-1, keepdim=True)

    def analyze_with_clip(self, image_features, descriptors, top_k=3):
        text_features = self.encode_descriptors(descriptors)
        similarity = (100.0 * image_features @ text_features.T).softmax(dim=-1)
        values, indices = similarity[0].topk(top_k)

        matches = []
        for i in range(top_k):
            matches.append({
                "label": descriptors[indices[i]],
                "confidence": round(float(values[i]), 4)
            })
        return matches

    def get_image_features(self, image_path):
        pil_image = Image.open(image_path).convert("RGB")
        image_tensor = self.preprocess(pil_image).unsqueeze(0).to(self.device)
        with torch.no_grad():
            features = self.model.encode_image(image_tensor)
            features = features / features.norm(dim=-1, keepdim=True)
        return features

    def extract_dominant_colors(self, image_path, n_colors=10):
        img = Image.open(image_path).convert("RGB")
        img_resized = img.resize((300, 300))
        pixels = np.array(img_resized).reshape(-1, 3).astype(float)

        brightness = np.mean(pixels, axis=1)
        mask = (brightness > 25) & (brightness < 235)
        filtered_pixels = pixels[mask]

        if len(filtered_pixels) < 200:
            filtered_pixels = pixels

        kmeans = MiniBatchKMeans(n_clusters=n_colors, random_state=42, n_init=5, batch_size=1000)
        kmeans.fit(filtered_pixels)

        colors = kmeans.cluster_centers_.astype(int)
        labels, counts = np.unique(kmeans.labels_, return_counts=True)
        percentages = (counts / counts.sum() * 100).round(1)

        sorted_indices = np.argsort(-percentages)
        colors = colors[sorted_indices]
        percentages = percentages[sorted_indices]

        dominant_colors = []
        for i in range(n_colors):
            r, g, b = int(colors[i][0]), int(colors[i][1]), int(colors[i][2])
            hex_color = f"#{r:02x}{g:02x}{b:02x}"
            color_name = self.get_precise_color_name(r, g, b)
            color_category = self.get_color_category(r, g, b)

            dominant_colors.append({
                "rgb": [r, g, b],
                "hex": hex_color,
                "name": color_name,
                "category": color_category,
                "percentage": float(percentages[i])
            })

        warm_score = 0
        cool_score = 0
        neutral_score = 0
        for color in dominant_colors:
            pct = color["percentage"]
            if color["category"] in ["warm"]:
                warm_score += pct
            elif color["category"] in ["cool"]:
                cool_score += pct
            else:
                neutral_score += pct

        if warm_score > cool_score + 20:
            color_temperature = "warm"
        elif cool_score > warm_score + 20:
            color_temperature = "cool"
        else:
            color_temperature = "neutral"

        return {
            "colors": dominant_colors,
            "temperature": color_temperature,
            "warm_score": round(float(warm_score), 1),
            "cool_score": round(float(cool_score), 1),
            "neutral_score": round(float(neutral_score), 1),
            "saturation": self.calculate_saturation(dominant_colors),
            "brightness_level": self.calculate_brightness_level(dominant_colors)
        }

    def get_precise_color_name(self, r, g, b):
        h, s, v = self.rgb_to_hsv(r, g, b)

        if s < 12:
            if v < 25:
                return "black"
            if v < 55:
                return "charcoal"
            if v < 95:
                return "dark grey"
            if v < 140:
                return "grey"
            if v < 185:
                return "light grey"
            if v < 225:
                return "off-white"
            return "white"

        if h < 10 or h >= 350:
            if v < 90:
                return "dark red"
            if s < 90:
                return "muted red"
            return "red"
        if 10 <= h < 22:
            if v < 90:
                return "burnt orange"
            return "orange"
        if 22 <= h < 42:
            if s < 90:
                return "golden"
            return "yellow"
        if 42 <= h < 65:
            if v < 80:
                return "olive"
            return "lime green"
        if 65 <= h < 95:
            if s < 80:
                return "sage"
            return "green"
        if 95 <= h < 135:
            if s < 80:
                return "teal green"
            return "emerald"
        if 135 <= h < 165:
            return "teal"
        if 165 <= h < 195:
            if v < 80:
                return "navy"
            return "cyan"
        if 195 <= h < 225:
            if v < 90:
                return "navy"
            return "blue"
        if 225 <= h < 255:
            return "indigo"
        if 255 <= h < 285:
            if s < 90:
                return "mauve"
            return "purple"
        if 285 <= h < 315:
            return "magenta"
        if 315 <= h < 350:
            if s < 90:
                return "dusty rose"
            return "pink"

        return "unknown"

    def get_color_category(self, r, g, b):
        h, s, v = self.rgb_to_hsv(r, g, b)

        if s < 15:
            return "neutral"
        if h < 45 or h >= 340:
            return "warm"
        if 45 <= h < 60:
            return "warm"
        if 60 <= h < 155:
            return "cool"
        if 155 <= h < 255:
            return "cool"
        if 255 <= h < 340:
            return "cool"
        return "neutral"

    def rgb_to_hsv(self, r, g, b):
        r, g, b = r / 255.0, g / 255.0, b / 255.0
        mx = max(r, g, b)
        mn = min(r, g, b)
        diff = mx - mn

        if diff == 0:
            h = 0
        elif mx == r:
            h = (60 * ((g - b) / diff) + 360) % 360
        elif mx == g:
            h = (60 * ((b - r) / diff) + 120) % 360
        else:
            h = (60 * ((r - g) / diff) + 240) % 360

        s = 0 if mx == 0 else (diff / mx) * 100
        v = mx * 100

        return h, s, v

    def calculate_saturation(self, colors):
        total_sat = 0
        total_weight = 0
        for color in colors:
            r, g, b = color["rgb"]
            _, s, _ = self.rgb_to_hsv(r, g, b)
            total_sat += s * color["percentage"]
            total_weight += color["percentage"]

        avg_sat = total_sat / total_weight if total_weight > 0 else 0

        if avg_sat < 15:
            return "desaturated"
        if avg_sat < 35:
            return "muted"
        if avg_sat < 60:
            return "moderate"
        if avg_sat < 80:
            return "saturated"
        return "vibrant"

    def calculate_brightness_level(self, colors):
        total_bright = 0
        total_weight = 0
        for color in colors:
            r, g, b = color["rgb"]
            _, _, v = self.rgb_to_hsv(r, g, b)
            total_bright += v * color["percentage"]
            total_weight += color["percentage"]

        avg_bright = total_bright / total_weight if total_weight > 0 else 50

        if avg_bright < 20:
            return "very dark"
        if avg_bright < 40:
            return "dark"
        if avg_bright < 60:
            return "medium"
        if avg_bright < 80:
            return "bright"
        return "very bright"

    def analyze_lighting(self, image_path):
        img = Image.open(image_path).convert("L")
        pixels = np.array(img).flatten()

        brightness = float(np.mean(pixels))
        contrast = float(np.std(pixels))

        if brightness < 50:
            brightness_level = "very dark"
        elif brightness < 85:
            brightness_level = "dark"
        elif brightness < 135:
            brightness_level = "medium"
        elif brightness < 185:
            brightness_level = "bright"
        else:
            brightness_level = "very bright"

        if contrast < 25:
            contrast_level = "low contrast"
        elif contrast < 50:
            contrast_level = "medium contrast"
        elif contrast < 75:
            contrast_level = "high contrast"
        else:
            contrast_level = "very high contrast"

        exposure = "well-exposed"
        if brightness < 70:
            exposure = "underexposed"
        elif brightness > 200:
            exposure = "overexposed"

        return {
            "brightness_value": round(brightness, 1),
            "brightness_level": brightness_level,
            "contrast_value": round(contrast, 1),
            "contrast_level": contrast_level,
            "exposure": exposure
        }

    def analyze_composition(self, image_path):
        img = Image.open(image_path).convert("RGB")
        w, h = img.size
        aspect_ratio = round(float(w / h), 2)

        pixels = np.array(img)
        mid_h, mid_w = h // 2, w // 2
        gray = np.mean(pixels, axis=2)

        h_edges = float(np.abs(np.diff(gray, axis=1)).sum())
        v_edges = float(np.abs(np.diff(gray, axis=0)).sum())

        if h_edges > v_edges * 1.3:
            orientation = "horizontal emphasis"
        elif v_edges > h_edges * 1.3:
            orientation = "vertical emphasis"
        else:
            orientation = "balanced"

        edges_total = h_edges + v_edges
        edge_density = float(edges_total / (w * h))

        if edge_density < 8:
            complexity = "simple"
        elif edge_density < 18:
            complexity = "moderate"
        elif edge_density < 30:
            complexity = "complex"
        else:
            complexity = "very complex"

        left_half = gray[:, :mid_w]
        right_half = np.fliplr(gray[:, mid_w:mid_w*2])
        if left_half.shape == right_half.shape:
            symmetry_score = float(1 - np.mean(np.abs(left_half - right_half)) / 255)
        else:
            symmetry_score = 0.5

        return {
            "aspect_ratio": float(aspect_ratio),
            "orientation": orientation,
            "complexity": complexity,
            "symmetry_score": round(symmetry_score, 2),
            "is_symmetrical": bool(symmetry_score > 0.85)
        }

    def analyze(self, image_path):
        full_features = self.get_image_features(image_path)

        results = {}

        results["room_type"] = self.analyze_with_clip(full_features, self.room_type_descriptors, 3)
        results["style"] = self.analyze_with_clip(full_features, self.style_descriptors, 5)
        results["color_palette"] = self.analyze_with_clip(full_features, self.color_palette_descriptors, 3)
        results["lighting"] = self.analyze_with_clip(full_features, self.lighting_descriptors, 3)
        results["space"] = self.analyze_with_clip(full_features, self.space_descriptors, 3)
        results["materials"] = self.analyze_with_clip(full_features, self.material_descriptors, 5)
        results["mood"] = self.analyze_with_clip(full_features, self.mood_descriptors, 3)
        results["furniture_present"] = self.analyze_with_clip(full_features, self.furniture_present_descriptors, 10)

        results["dominant_colors"] = self.extract_dominant_colors(image_path)
        results["lighting_analysis"] = self.analyze_lighting(image_path)
        results["composition"] = self.analyze_composition(image_path)

        results["summary"] = {
            "room_type": results["room_type"][0]["label"] if results["room_type"] else "unknown",
            "primary_style": results["style"][0]["label"] if results["style"] else "unknown",
            "color_temperature": results["dominant_colors"]["temperature"],
            "saturation": results["dominant_colors"]["saturation"],
            "brightness": results["lighting_analysis"]["brightness_level"],
            "mood": results["mood"][0]["label"] if results["mood"] else "unknown"
        }

        return results
