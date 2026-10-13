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

Mirage implements a decoupled, three-tier microservice architecture engineered to reconcile heavy computer vision inference and real-time 3D spatial computing with consumer mobile hardware:

1. **Presentation & Spatial Client**: Flutter 3.8+ cross-platform mobile app embedding a native Unity 6000 XR runtime via `flutter_embed_unity`.
2. **Commerce Core & Orchestration API**: Laravel 12 RESTful API with Filament 4 admin panel, Sanctum authentication, and MySQL relational persistence.
3. **Multimodal Machine Learning Microservice**: Python FastAPI ASGI server running OpenAI CLIP visual transformers, K-Means chromatic clustering, and FAISS vector indexing.

```mermaid
flowchart TB
    %% ─────────────────────────────────────────────────────────────
    %% STYLING DEFINITIONS
    %% ─────────────────────────────────────────────────────────────
    classDef clientStyle fill:#0f172a,stroke:#38bdf8,stroke-width:2px,color:#f8fafc;
    classDef unityStyle fill:#18181b,stroke:#a855f7,stroke-width:2px,color:#f8fafc;
    classDef backendStyle fill:#1e1b4b,stroke:#818cf8,stroke-width:2px,color:#f8fafc;
    classDef aiStyle fill:#064e3b,stroke:#34d399,stroke-width:2px,color:#f8fafc;
    classDef storageStyle fill:#451a03,stroke:#fbbf24,stroke-width:2px,color:#f8fafc;

    %% ─────────────────────────────────────────────────────────────
    %% TIER 1: CLIENT
    %% ─────────────────────────────────────────────────────────────
    subgraph TIER1["📱 TIER 1: HYBRID MOBILE CLIENT (Android / iOS)"]
        subgraph FLUTTER["Flutter 3.8 Application Layer"]
            UI["Modern UI / UX<br>(Provider & GoRouter)"]:::clientStyle
            CameraModule["Camera Controller<br>(1080p Snapshot Capture)"]:::clientStyle
            DioClient["Network Client<br>(Dio / HTTPS)"]:::clientStyle
        end

        subgraph BRIDGE["Native Platform Bridge"]
            JNI["flutter_embed_unity<br>(JNI / MethodChannel)"]:::unityStyle
        end

        subgraph UNITY["Embedded Unity 6000 XR Viewport"]
            GLBManager["GLBManager.cs<br>(Runtime Bridge Singleton)"]:::unityStyle
            ARLoader["ARGLBLoader.cs<br>(glTFast Runtime Spawner)"]:::unityStyle
            ARFoundation["AR Foundation Subsystems<br>(ARPlane & ARRaycast Managers)"]:::unityStyle
            ARCoreKit["Hardware AR HAL<br>(ARCore / ARKit)"]:::unityStyle
        end
    end

    %% ─────────────────────────────────────────────────────────────
    %% TIER 2: COMMERCE BACKEND
    %% ─────────────────────────────────────────────────────────────
    subgraph TIER2["⚡ TIER 2: COMMERCE CORE & ORCHESTRATION (Laravel 12 - Port 8000)"]
        Gateway["HTTP Routing & Gateway<br>(Sanctum Auth Middleware)"]:::backendStyle
        Controllers["Resource Controllers<br>(Product, Category, Order APIs)"]:::backendStyle
        Filament["Filament 4 Admin Dashboard<br>(Catalog, SKUs, 3D Assets)"]:::backendStyle
        Scribe["Scribe OpenAPI Engine<br>(Interactive Documentation)"]:::backendStyle
        MySQL[("MySQL Relational DB<br>Products, Users, Orders")]:::backendStyle
    end

    %% ─────────────────────────────────────────────────────────────
    %% TIER 3: AI MICROSERVICE
    %% ─────────────────────────────────────────────────────────────
    subgraph TIER3["🧠 TIER 3: MULTIMODAL AI STYLIST (FastAPI - Port 8001)"]
        FastAPI["FastAPI Uvicorn ASGI Server<br>(/analyze Endpoint)"]:::aiStyle
        Preprocess["Image Preprocessing<br>(PIL, OpenCV Resize)"]:::aiStyle
        KMeans["K-Means Clustering Engine<br>(5-Color Palette & Temperature)"]:::aiStyle
        Lighting["Photometric Evaluator<br>(Luminance & RMS Contrast)"]:::aiStyle
        CLIP["OpenAI CLIP ViT Encoder<br>(512D Normalized Embedding)"]:::aiStyle
        FAISS["FAISS Vector Index<br>(Pre-indexed Catalog Embeddings)"]:::aiStyle
        Ranking["Composite Scoring Engine<br>(S = 0.65·Style + 0.35·Color)"]:::aiStyle
    end

    %% ─────────────────────────────────────────────────────────────
    %% ASSET STORAGE
    %% ─────────────────────────────────────────────────────────────
    subgraph CLOUD["☁️ ASSET STORAGE & CDN"]
        AssetStorage["Public Storage / CDN<br>(Optimized .glb 3D Models & PBR Maps)"]:::storageStyle
    end

    %% ─────────────────────────────────────────────────────────────
    %% DATA INTERCONNECTIONS
    %% ─────────────────────────────────────────────────────────────
    CameraModule -->|"1. Multipart JPEG Upload"| FastAPI
    FastAPI --> Preprocess
    Preprocess --> KMeans
    Preprocess --> Lighting
    Preprocess --> CLIP
    CLIP -->|"512D Query Vector"| FAISS
    FAISS -->|"Candidate Matches"| Ranking
    KMeans -->|"Palette Vector"| Ranking
    Lighting -->|"Ambient Context"| Ranking
    Ranking -->|"2. Ranked SKUs & Color Analytics JSON"| UI

    UI <-->|"3. Browse, Authenticate, Checkout (REST API)"| Gateway
    Gateway <--> Controllers
    Controllers <--> MySQL
    Filament <--> MySQL
    Filament -->|"Uploads 3D Models"| AssetStorage

    UI -->|"4. Model URL & Placement Command"| JNI
    JNI --> GLBManager
    GLBManager --> ARLoader
    ARLoader <--> ARFoundation
    ARFoundation <--> ARCoreKit
    ARLoader ==>|"5. Asynchronous .glb Binary Stream"| AssetStorage
```

### 🔄 End-to-End Operational Sequence

```mermaid
sequenceDiagram
    autonumber
    actor Customer as 👤 Customer
    participant Flutter as 📱 Flutter Client
    participant Unity as 🥽 Embedded Unity XR
    participant FastAPI as 🧠 FastAPI AI (:8001)
    participant Laravel as ⚡ Laravel API (:8000)
    participant Storage as ☁️ Cloud 3D Storage

    %% Stage 1: Room Scan & AI Recommendation
    Note over Customer, FastAPI: Stage 1: In-Situ Room Analysis & Aesthetic Recommendation
    Customer->>Flutter: Takes room photograph via in-app camera
    Flutter->>FastAPI: POST /analyze (Standardized 1080p Image)
    FastAPI->>FastAPI: K-Means extracts 5 dominant colors & temperature
    FastAPI->>FastAPI: CLIP ViT generates 512D aesthetic embedding
    FastAPI->>FastAPI: FAISS cosine search matches catalog vectors
    FastAPI-->>Flutter: 200 OK (Ranked SKUs, color harmony, lighting context)
    Flutter-->>Customer: Renders interactive recommendations

    %% Stage 2: Embedded AR Visualization
    Note over Customer, Storage: Stage 2: True-to-Scale AR Spatial Projection
    Customer->>Flutter: Selects item & taps "View in AR"
    Flutter->>Unity: Passes GLB URL & dimensions via JNI (flutter_embed_unity)
    Unity->>Unity: AR Foundation starts ARCore/ARKit session
    Unity->>Unity: RANSAC plane estimation detects floor/wall surfaces
    Unity->>Storage: Streams .glb asset asynchronously (glTFast)
    Storage-->>Unity: 200 OK (Mesh geometry & PBR materials)
    Unity->>Unity: Spawns 3D model anchored at 1:1 metric scale
    Customer->>Unity: Manipulates model (Translate, Rotate, Scale)

    %% Stage 3: Checkout & Order Fulfillment
    Note over Customer, Laravel: Stage 3: E-Commerce Transaction & Fulfillment
    Customer->>Flutter: Adds furniture item to cart & initiates checkout
    Flutter->>Laravel: POST /api/orders (Sanctum Bearer Token)
    Laravel->>Laravel: Validates stock, stores transaction in MySQL
    Laravel-->>Flutter: 201 Created (Order confirmation & invoice)
    Flutter-->>Customer: Displays order receipt & delivery tracking
```

### 🧠 Subsystem Deep-Dive: AI Recommendation Pipeline

```mermaid
flowchart LR
    A["📸 1080p Room Snapshot"] --> B["Downsample 256x256<br>& RGB Matrix Extraction"]
    A --> C["Resize 224x224<br>& Normalize Tensor"]
    
    subgraph Chromatic["Color & Photometric Analysis"]
        B --> D["K-Means Clustering k=5<br>Centroids & Pixel Proportions"]
        D --> E["CIE Lab Color Distance<br>& Warm/Cool Temperature"]
        B --> F["Luminance & RMS Contrast<br>Exposure Classification"]
    end
    
    subgraph VisionAI["Deep Multimodal Semantics"]
        C --> G["OpenAI CLIP ViT Vision Transformer"]
        G --> H["512D Normalized Hypersphere Vector v_room"]
    end
    
    subgraph Retrieval["Vector Indexing & Scoring"]
        H --> I["FAISS Cosine Similarity Search<br>Against Furniture Catalog"]
        E --> J["Chromatic Harmony Weighting"]
        I --> K["Composite Scoring Engine<br>S = 0.65·Style + 0.35·Color"]
        J --> K
        F --> K
    end
    
    K --> L["🎯 Scored & Filtered Furniture Recommendations"]
```

### 🥽 Subsystem Deep-Dive: Unity AR Spatial Calibration Pipeline

```mermaid
flowchart LR
    A["📱 Monocular Camera<br>& IMU Sensors"] --> B["Feature Point Gradient Tracking<br>(ARCore / ARKit HAL)"]
    B --> C["Coplanar Surface Estimation<br>(RANSAC Algorithm)"]
    C --> D["Horizontal Floors & Vertical Walls Detection<br>(ARPlaneManager)"]
    D --> E["Screen-Space Touch Raycast<br>(ARRaycastManager)"]
    E --> F["Sub-Centimeter 3D World Anchor"]
    F --> G["Asynchronous Cloud .glb Download<br>(glTFast Runtime Loader)"]
    G --> H["PBR Shaders & Spherical Harmonics Lighting"]
    H --> I["🛋️ True-to-Scale 1:1 Metric Placement<br>& Real-Time Gesture Manipulation"]
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
├── docs/                     # Academic documentation & thesis
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
