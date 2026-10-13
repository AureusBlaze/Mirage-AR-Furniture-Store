# 🛋️ Mirage: AI-Powered Augmented Reality Smart Furniture Store

<p align="center">
  <strong>An Intelligent Spatial Commerce Ecosystem Combining Unity XR, Flutter, Laravel 12, and Multimodal CLIP AI.</strong>
</p>

<p align="center">
  <a href="#-system-architecture"><img src="https://img.shields.io/badge/Architecture-Clean%20Microservices-blue.svg?style=for-the-badge" alt="Architecture"></a>
  <a href="#-frontend-flutter-mobile-app"><img src="https://img.shields.io/badge/Flutter-3.8+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="#-unity-ar-engine"><img src="https://img.shields.io/badge/Unity%20XR-6000.0+-000000?style=for-the-badge&logo=unity&logoColor=white" alt="Unity"></a>
  <a href="#-backend-laravel-12--filament"><img src="https://img.shields.io/badge/Laravel%2012-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" alt="Laravel"></a>
  <a href="#-ai-microservice-fastapi--clip"><img src="https://img.shields.io/badge/FastAPI-PyTorch%20%7C%20CLIP-009688?style=for-the-badge&logo=fastapi&logoColor=white" alt="FastAPI"></a>
  <a href="docs/Mirage_Project_Documentation.pdf"><img src="https://img.shields.io/badge/Thesis-PDF%20Documentation-red.svg?style=for-the-badge&logo=adobeacrobatreader&logoColor=white" alt="Documentation"></a>
</p>

---

## 📌 Executive Summary

Online furniture e-commerce suffers from elevated return rates and customer hesitation caused by **spatial uncertainty** (will it physically fit?) and **aesthetic discord** (will it match the room's lighting, palette, and style?). 

**Mirage** bridges this divide by delivering an end-to-end, commercial-grade spatial e-commerce ecosystem. The system pairs **true-to-scale 1:1 Augmented Reality visualization** with an **in-situ Multimodal AI interior stylist**. Customers can capture a snapshot of their living space, receive real-time aesthetic and color-harmonic furniture recommendations via OpenAI CLIP and K-Means clustering, and immediately project photorealistic 3D furniture into their physical environment using phone-based AR before purchasing.

---

## ✨ Key System Features

- 📐 **True-to-Scale 1:1 AR Placement**: Built with **Unity XR** and **AR Foundation** (ARCore & ARKit). Implements surface tracking across both horizontal planes (floors, tables) and vertical planes (walls) with metric dimension scaling.
- 🔄 **Embedded Unity Viewport**: The Unity AR rendering engine is embedded directly inside the **Flutter** mobile application using `flutter_embed_unity`, creating zero-friction transitions between shopping catalog and spatial preview.
- 🎨 **Multimodal AI Interior Stylist**: A **FastAPI + PyTorch** microservice leveraging **OpenAI CLIP (ViT-B/32 / ViT-L/14)** and **FAISS** vector similarity search. Ingests static room snapshots to evaluate:
  - Dominant color palettes, temperature, warmth, and saturation via K-Means clustering.
  - Lighting levels, exposure, and scene contrast.
  - Room typology, structural composition, and architectural material classification.
  - Semantic catalog matching for harmonious furniture pairing in **< 2.0 seconds**.
- ☁️ **Dynamic 3D Asset Streaming**: 3D models (`.glb` / `.gltf`) stream on-demand from cloud storage into the AR scene via an asynchronous pipeline (`ARGLBLoader.cs`), preventing client APK bloat.
- 🛒 **Full-Featured Commerce Backend**: Engineered on **Laravel 12** with **Filament 4**, featuring an administrative control center for 3D model management, inventory tracking, order fulfillment, category hierarchies, and token-based **Sanctum** authentication.
- 📖 **Interactive OpenAPI Documentation**: Auto-generated API documentation and interactive test harnesses powered by **Scribe**.

---

## 🏗️ System Architecture

Mirage operates across four specialized modules coordinated over RESTful APIs and cross-platform native bridges:

```mermaid
graph TD
    subgraph Client["📱 Mobile Client (Flutter & Embedded Unity)"]
        UI["Flutter UI<br>(Provider & GoRouter)"]
        Camera["Camera Module<br>(Room Capture)"]
        UnityAR["Embedded Unity XR<br>(AR Foundation Engine)"]
    end

    subgraph BackendAPI["⚡ Commerce Core (Laravel 12 API)"]
        L_Auth["Sanctum Auth"]
        L_Catalog["Catalog & Inventory"]
        L_Filament["Filament 4 Admin Panel"]
        DB[("MySQL Database")]
        Storage["Asset Storage<br>(GLB 3D Models & Images)"]
    end

    subgraph AIService["🧠 AI Stylist Microservice (Python FastAPI)"]
        FastAPI["FastAPI Inference Server"]
        CLIP["OpenAI CLIP Model<br>(Multimodal Embeddings)"]
        KMeans["K-Means Clustering<br>(Palette Extraction)"]
        FAISS["FAISS Index<br>(Vector Similarity Search)"]
    end

    Camera -->|"Uploads Room Image"| FastAPI
    FastAPI -->|"Evaluates Palette & Lighting"| KMeans
    FastAPI -->|"Computes Semantic Similarity"| CLIP
    CLIP -->|"Vector Nearest Neighbors"| FAISS
    FastAPI -->|"Returns Scored Recommendations"| UI

    UI -->|"Browse & Checkout"| BackendAPI
    L_Catalog <--> DB
    L_Filament <--> Storage

    UI -->|"Transfers GLB URL to Engine"| UnityAR
    UnityAR -->|"Streams 3D Assets"| Storage
```

### AI Recommendation Pipeline
```mermaid
flowchart LR
    A["📸 Room Snapshot"] --> B["Color & Lighting Analysis<br>(K-Means & Luminance)"]
    A --> C["Vision Encoding<br>(OpenAI CLIP ViT)"]
    C --> D["Vector Nearest Neighbors<br>(FAISS Similarity Search)"]
    B --> E["Aesthetic & Palette Harmonization"]
    D --> E
    E --> F["🎯 Ranked Furniture Recommendations"]
```

### AR Surface Detection & Scale Pipeline
```mermaid
flowchart LR
    A["📱 AR Camera Stream"] --> B["Surface Feature Point Tracking<br>(AR Foundation)"]
    B --> C["Horizontal & Vertical Plane Estimation<br>(Floors & Walls)"]
    C --> D["1:1 Metric Calibration Anchor"]
    D --> E["Cloud GLB Streaming & Spawning<br>(glTFast / Async Loader)"]
    E --> F["🥽 Real-Time Gesture Manipulation<br>(Rotate, Translate, Inspect)"]
```

---

## 📊 Technical Benchmarks & Evaluation

Empirically validated and documented in the official graduation thesis:

| Metric | Result | Target Benchmark | Status |
| :--- | :--- | :--- | :---: |
| **AR Rendering Frame Rate** | **34.8 – 36.2 FPS** | ≥ 30 FPS on mid-range devices | Passed |
| **Spatial Scale Accuracy** | **1:1 Metric Calibration** | Deviation < 3% of physical ground truth | Passed |
| **AI Inference Latency** | **1.74 seconds** (end-to-end) | ≤ 3.0 seconds per room analysis | Passed |
| **Plane Detection Speed** | **1.2 – 2.4 seconds** | Fast initial anchor acquisition | Passed |
| **3D GLB Download & Spawning** | **< 3.1 seconds** (avg 5MB model) | Asynchronous non-blocking runtime | Passed |

---

## 📂 Repository Structure

```
Mirage-AR-Furniture-Store/
├── frontend/                 # Flutter mobile client (Dart 3, Provider, GetIt, Dio)
│   ├── lib/                  # Screens, ViewModels, Services, Models
│   ├── android/              # Native Android host with embedded Unity library
│   ├── ios/                  # Native iOS host configuration
│   └── pubspec.yaml          # Flutter dependencies
│
├── backend/                  # Laravel 12 REST API & Filament 4 Admin Panel
│   ├── app/                  # Controllers, Models, Filament Resources
│   ├── database/             # Migrations, Factories, Seeders
│   ├── routes/api.php        # Secured API endpoints
│   └── composer.json         # PHP dependencies
│
├── ai-service/               # FastAPI Computer Vision & Style Recommendation Engine
│   ├── backend/              # main.py, analyzer.py, matcher.py
│   ├── data/                 # Furniture catalog metadata & embeddings
│   ├── requirements.txt      # PyTorch, CLIP, FAISS, FastAPI dependencies
│   └── FLUTTER_INTEGRATION_GUIDE.md
│
├── unity-ar/                 # Unity 6000 XR / AR Foundation Project
│   ├── Assets/Scripts/       # ARGLBLoader.cs, GLBManager.cs
│   ├── Assets/FlutterEmbed/  # Bridge scripts exporting Unity into Flutter
│   └── ProjectSettings/      # ARCore / ARKit XR plugin management
│
├── docs/                     # Architectural diagrams, schematics, and thesis PDF
│   ├── assets/               # Curated figures and app screenshots
│   └── Mirage_Project_Documentation.pdf
│
└── README.md                 # Flagship project documentation
```

---

## 🚀 Quickstart & Setup Guide

### 1. Prerequisites
- **Git**, **PHP 8.2+**, **Composer**, **Node.js 18+**
- **Python 3.10+** (with CUDA recommended if using GPU)
- **Flutter SDK 3.8+** & **Android Studio** (Android SDK 34+)
- **Unity 6000.0+ (Unity 6)** with Android Build Support & OpenJDK installed

---

### 2. Backend Setup (Laravel 12 API)
```bash
cd backend

# Install dependencies
composer install
npm install

# Environment configuration
cp .env.example .env
php artisan key:generate

# Database migration & seed initial catalog
php artisan migrate --seed

# Create storage symlink for uploaded 3D models and photos
php artisan storage:link

# Launch local development server
php artisan serve
```
* **API Server:** `http://localhost:8000`
* **Filament Admin Panel:** `http://localhost:8000/admin`
* **API Documentation:** `http://localhost:8000/docs` (generated via `php artisan scribe:generate`)

---

### 3. AI Service Setup (FastAPI & CLIP)
```bash
cd ai-service

# Create virtual environment
python -m venv venv
# Windows:
.\venv\Scripts\activate
# Linux/macOS:
source venv/bin/activate

# Install PyTorch and ML dependencies
pip install -r requirements.txt

# Start recommendation server
uvicorn backend.main:app --host 0.0.0.0 --port 8001 --reload
```
* **Interactive Swagger UI:** `http://localhost:8001/docs`
* **Health Check:** `http://localhost:8001/`

---

### 4. Mobile Client Setup (Flutter)
```bash
cd frontend

# Fetch packages
flutter pub get

# Ensure device or emulator is connected
flutter devices

# Run on Android
flutter run
```

---

### 5. Unity AR Engine (Export to Flutter)
1. Open the project in **Unity 6000.0+**: Open `unity-ar/`.
2. In the Unity top menu bar, click:  
   `Flutter Embed` ➔ `Export project to flutter app (Android)`.
3. When prompted, select the export destination:  
   `<repo-root>/frontend/android/unityLibrary`.
4. Unity will build the native `unityLibrary` AAR module and update Gradle scripts automatically.

---

## 👥 Authors & Academic Credits

Developed as the Senior Capstone Project at the **Faculty of Computer Science and Information Technology**, **International University of Technology Twintech (IUTT)**, Class of 2026.

* **Omar Sami Niyazi Al-Maqtari** ([@AureusBlaze](https://github.com/AureusBlaze)) – *Lead Developer & System Architect*
* **Mohammed Al-Ali**
* **Mohammed Qaid**
* **Abdulrahman Al-Hamadi**
* **Furas Raoof**

**Supervised by:**
* **Dr. Amin Mohamed Ahsan Shayea**

---

## 📄 License & Attribution

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.  
3D assets and furniture designs are provided for academic and non-commercial research demonstration.
