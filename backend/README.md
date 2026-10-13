# ⚡ Mirage Backend — Laravel 12 API & Filament Admin

The core commerce backend for the **Mirage** AR and AI Furniture platform, powering catalog management, product inventory, customer accounts, orders, and 3D GLB model assets.

---

## 🛠️ Tech Stack & Dependencies

* **Framework:** Laravel 12 (PHP 8.2+)
* **Admin Panel:** Filament 4
* **Authentication:** Laravel Sanctum
* **API Documentation:** Scribe (OpenAPI / Interactive Swagger)
* **Database:** MySQL / SQLite
* **Asset Storage:** Public storage symlink for high-resolution images & GLB 3D models

---

## 🚀 Setup & Installation

### 1. Install Dependencies
```bash
composer install
npm install
```

### 2. Configure Environment
```bash
cp .env.example .env
php artisan key:generate
```
Edit your `.env` to configure your database connection:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mirage_db
DB_USERNAME=root
DB_PASSWORD=
```

### 3. Run Migrations & Seeders
```bash
php artisan migrate --seed
```

### 4. Link Public Storage
Required for serving 3D model files (`.glb`) and product images to Flutter and Unity:
```bash
php artisan storage:link
```

### 5. Launch the Server
```bash
# Using Artisan serve
php artisan serve

# Or launch concurrently with queue and vite
composer run dev
```

The API will be accessible at: `http://localhost:8000`

---

## 🖥️ Filament Admin Panel

Access the dashboard at `http://localhost:8000/admin`.

Key Admin Features:
* **Product Catalog**: Manage furniture items, SKUs, pricing, categories, and dimensions (width, height, depth).
* **3D AR Model Management**: Upload and preview `.glb` / `.gltf` assets streamed directly to client devices.
* **Media Reordering**: Drag-and-drop gallery images for product cards.
* **Order Tracking**: Monitor checkout statuses, shipping information, and customer details.

---

## 📚 API Endpoints & Scribe Documentation

Generate and view interactive API documentation:
```bash
php artisan scribe:generate
```
Once generated, visit: `http://localhost:8000/docs`

### Key Endpoints:
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/login` | Authenticate customer & return Sanctum Bearer Token |
| `POST` | `/api/register` | Register new account |
| `GET` | `/api/products` | Retrieve furniture catalog (with search, filter, categories) |
| `GET` | `/api/products/{id}` | Retrieve product details, dimensions, and 3D GLB model URL |
| `GET` | `/api/categories` | Retrieve hierarchical category tree |
| `POST` | `/api/orders` | Place customer order |
| `GET` | `/api/orders/history` | Retrieve authenticated customer's order history |
