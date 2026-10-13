# 📱 Mirage Frontend — Flutter AR Mobile Client

The client-side mobile application for the **Mirage** spatial commerce platform, engineered in **Flutter (Dart 3)** with an embedded **Unity XR** rendering engine.

---

## 🛠️ Tech Stack & Key Packages

* **Framework:** Flutter (Dart ^3.8.1)
* **State Management & DI:** `provider: ^6.1.2`, `get_it: ^8.0.3`
* **Routing:** `go_router: ^14.8.1`
* **Network & Serialization:** `dio: ^5.7.0`, `json_annotation: ^4.9.0`
* **Secure Storage:** `flutter_secure_storage: ^9.2.4`, `shared_preferences: ^2.3.4`
* **Camera & Media:** `camera: ^0.11.0+2`, `image_picker: ^1.1.2`
* **Unity Embedding:** `flutter_embed_unity: ^1.5.0`, `flutter_embed_unity_6000_0_android: ^1.2.3`

---

## 📱 Application Screens & Workflow

1. **Authentication:** Sign In, Registration, and Session Persistence.
2. **Catalog & Search:** Animated catalog browser with category filters (Living Room, Bedroom, Office, etc.) and search.
3. **Product Detail Screen:** High-res gallery, dimensions specification, stock status, and direct "View in AR" trigger.
4. **Room AI Camera:** In-app camera allowing customers to take a snapshot of their room for instant interior style and color harmony analysis.
5. **AR Spatial Viewport:** Native embedded Unity viewport (`ProductArScreen`) rendering true-to-scale 3D models with surface detection and gesture manipulation.
6. **Cart & Order History:** Persistent cart, checkout flow, and historical order tracking.

---

## ⚙️ Configuration & Environment

Set your host machine's IP address in your service configuration so the physical mobile device can communicate with the backend and AI microservice on your local network:

```dart
// Laravel Commerce Backend
const String kBackendBaseUrl = "http://<YOUR_LOCAL_IP>:8000/api";

// Python FastAPI AI Service
const String kAiServiceBaseUrl = "http://<YOUR_LOCAL_IP>:8001";
```

---

## 🚀 Running the App

### 1. Get Dependencies
```bash
flutter pub get
```

### 2. Verify Devices
Connect your Android device with USB Debugging enabled (ensure ARCore is supported on the target device):
```bash
flutter devices
```

### 3. Launch Application
```bash
flutter run
```

### 4. Build Release APK
```bash
flutter build apk --release
```

---

## 🔄 Unity XR Integration Notes

The Flutter app loads Unity AR via `flutter_embed_unity`. 

* The Unity project in `unity-ar/` must be exported using the menu:  
  `Flutter Embed` ➔ `Export project to flutter app (Android)`.
* This outputs the compiled `unityLibrary` AAR module into `android/unityLibrary/`.
* When a user taps **"View in AR"**, the Flutter screen initiates the Unity activity, passes the target 3D model's `.glb` URL, and embeds the interactive 3D camera view inside Flutter's widget tree.
