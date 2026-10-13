# 🥽 Mirage Unity AR — Augmented Reality Engine

The immersive spatial computing engine for the **Mirage** platform, built on **Unity 6000.0 (Unity 6)** and **AR Foundation** (supporting ARCore on Android and ARKit on iOS).

---

## 🛠️ Requirements & Setup

* **Unity Version:** Unity 6000.0+ (Unity 6 LTS)
* **Target Platforms:** Android (API Level 24+ with ARCore), iOS 14+ (ARKit)
* **Key Packages:**
  * `com.unity.xr.arfoundation`
  * `com.unity.xr.arcore`
  * `com.unity.xr.arkit`
  * `com.unity.xr.interaction.toolkit`
  * `glTFast` / runtime GLB loader

---

## 🎯 Architecture & Key Scripts

The AR subsystem lives under `Assets/Scripts/` and `Assets/FlutterEmbed/`:

### 1. `ARGLBLoader.cs`
* **Surface Detection:** Manages `ARPlaneManager` and `ARRaycastManager` to detect both **horizontal planes** (floors, countertops) and **vertical planes** (walls).
* **Metric Accuracy:** Calibrates 1:1 metric scale so digital 3D furniture renders with physical-world dimensions.
* **Asynchronous Streaming:** Downloads `.glb` assets on-demand from the cloud and instantiates them with mesh colliders and shadow receivers.
* **Gesture Manipulation:** Enables intuitive user gestures to translate, rotate, and reposition placed furniture items across detected surfaces.

### 2. `GLBManager.cs`
* A persistent singleton that bridges the Flutter application context with the Unity runtime.
* Receives target `.glb` URLs, model names, and dimension metadata transmitted across the platform bridge.

### 3. `FlutterEmbed/`
* Contains Unity Editor automation utilities (`ProjectExporter.cs`, `ProjectExportChecker.cs`).
* Pre-checks Android build settings (ensuring IL2CPP, ARMv7 + ARM64 target architectures, Activity entry point).
* Packages the entire Unity AR scene into a native Android library (`unityLibrary`) that Flutter includes seamlessly.

---

## 📦 How to Export to the Flutter Mobile App

1. Launch **Unity Hub** and open the `unity-ar/` project directory with **Unity 6000.0+**.
2. Open `File -> Build Settings`:
   * Set Platform to **Android**.
   * Click **Switch Platform** if not already selected.
3. In the Unity menu bar, select:  
   **`Flutter Embed` ➔ `Export project to flutter app (Android)`**
4. A file picker dialog will appear:
   * Navigate to: `<repo-root>/frontend/android/unityLibrary`
   * Confirm the selection.
5. Unity will compile and export the project assets directly into Flutter's Android project structure.
6. Open your terminal in `frontend/` and execute `flutter run`.
