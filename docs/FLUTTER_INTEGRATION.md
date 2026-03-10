# Integrating the FER Model into a Flutter App for Children's Emotion Analysis

This guide explains how to integrate the **Facial Emotion Recognition (FER)** TFLite model into the Wanis Flutter application to analyze children's emotions in real time using the device camera.

---

## Table of Contents

1. [Model Overview](#model-overview)
2. [Project Architecture](#project-architecture)
3. [Prerequisites](#prerequisites)
4. [Step 1 — Assets Setup](#step-1--assets-setup)
5. [Step 2 — Dependencies](#step-2--dependencies)
6. [Step 3 — Android Configuration](#step-3--android-configuration)
7. [Step 4 — EmotionService](#step-4--emotionservice)
8. [Step 5 — TherapeuticStoryService](#step-5--therapeuticstoryservice)
9. [Step 6 — Camera Screen](#step-6--camera-screen)
10. [Step 7 — Story Screen](#step-7--story-screen)
11. [Performance Tips](#performance-tips)
12. [Future: Google AI Story Generation](#future-google-ai-story-generation)
13. [References](#references)

---

## Model Overview

| Property       | Value                                          |
| -------------- | ---------------------------------------------- |
| **File**       | `assets/ai/model.tflite`                       |
| **Labels**     | `assets/ai/labels.txt`                         |
| **Size**       | 692 KB                                         |
| **Input**      | `float32 [1, 48, 48, 1]` — grayscale image normalized to `[0, 1]` |
| **Output**     | `float32 [1, 8]` — raw logits (requires softmax) |
| **Classes**    | 8 emotions (see table below)                   |
| **Accuracy**   | 87.66% on FER-Plus dataset                     |
| **Parameters** | ~170K                                          |

### Emotion Classes

| Index | Emotion   | Arabic    | Emoji |
| ----- | --------- | --------- | ----- |
| 0     | Neutral   | طبيعي     | 😐    |
| 1     | Happiness | سعيد      | 😄    |
| 2     | Surprise  | متفاجئ    | 😲    |
| 3     | Sadness   | حزين      | 😢    |
| 4     | Anger     | غضبان     | 😡    |
| 5     | Disgust   | مشمئز     | 🤢    |
| 6     | Fear      | خايف      | 😨    |
| 7     | Contempt  | مستهزئ    | 😏    |

> The model outputs **logits** (not probabilities). You must apply **softmax** after inference.

---

## Project Architecture

```
wanis_app/
├── assets/ai/
│   ├── model.tflite              ← FER TFLite model (692 KB)
│   └── labels.txt                ← 8 emotion labels
├── lib/features/games/
│   ├── services/
│   │   ├── emotion_service.dart         ← Model loading, face detection & inference
│   │   └── therapeutic_story_service.dart  ← Story generation (local + abstract interface)
│   └── presentation/screens/
│       ├── emotion_recognition_camera_screen.dart  ← Live camera + emotion display
│       └── wanis_story_writing_screen.dart          ← Therapeutic story UI
```

---

## Prerequisites

- Flutter SDK ≥ 3.10
- Dart SDK ≥ 3.0
- Android: `minSdkVersion 26`
- iOS: Deployment target ≥ 12.0
- A **physical device** with a camera (emulators lack camera support)

---

## Step 1 — Assets Setup

The model and labels files are already placed in `assets/ai/` and registered in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/ai/
```

---

## Step 2 — Dependencies

All dependencies are already in `pubspec.yaml`:

```yaml
dependencies:
  camera: ^0.12.0
  image: ^4.3.0
  tflite_flutter: ^0.12.1
  google_ml_kit: ^0.21.0
```

---

## Step 3 — Android Configuration

In `android/app/build.gradle.kts`, the following is added to prevent compression of `.tflite` files:

```kotlin
android {
    aaptOptions {
        noCompress += "tflite"
    }
}
```

---

## Step 4 — EmotionService

**File**: `lib/features/games/services/emotion_service.dart`

This service handles the entire inference pipeline:

1. **Initialization**: Loads the TFLite interpreter via `Interpreter.fromAsset()` and configures ML Kit `FaceDetector`.
2. **Frame Processing**: Accepts a `CameraImage` and:
   - Converts to ML Kit `InputImage` for face detection (handles both YUV420 and BGRA8888 formats).
   - Converts to `image` package `Image` for face cropping.
   - Crops the detected face region.
   - Resizes to 48×48 grayscale and normalizes to `[0, 1]`.
   - Runs TFLite inference.
   - Applies softmax to convert logits to probabilities.
3. **Result**: Returns an `EmotionResult` with the label, confidence, and all probabilities.

Key design decisions:
- **Busy flag** prevents concurrent inference calls.
- **Throttling** is handled by the caller (camera screen uses 500ms intervals).
- **Error handling** silently catches per-frame errors to avoid crashing the stream.

---

## Step 5 — TherapeuticStoryService

**File**: `lib/features/games/services/therapeutic_story_service.dart`

Uses an **abstract `StoryGenerator` interface** to allow future swapping with Google AI:

```dart
abstract class StoryGenerator {
  Future<TherapeuticStory> generateStory(String emotion);
}
```

The current `LocalTherapeuticStoryService` implementation provides predefined Arabic therapeutic stories for each of the 8 emotions. Each story includes:
- **Title** with emoji
- **Story body** in colloquial Arabic
- **Moral lesson** for the child
- Multiple stories per emotion for variety

---

## Step 6 — Camera Screen

**File**: `lib/features/games/presentation/screens/emotion_recognition_camera_screen.dart`

- Initializes the front camera and starts an image stream.
- Feeds frames to `EmotionService` at 500ms intervals.
- Displays detected emotion in an animated chip with confidence %.
- The face guide oval border changes color based on the detected emotion.
- Handles lifecycle (pause/resume) and permission errors gracefully.

---

## Step 7 — Story Screen

**File**: `lib/features/games/presentation/screens/wanis_story_writing_screen.dart`

- Receives the `detectedEmotion` parameter from the camera screen.
- Shows a loading animation while the story is being "generated".
- Displays the story with a gradient title card, body text, and moral lesson.
- Offers "قصة تانية" (Another Story) and "رجوع للكاميرا" (Back to Camera) buttons.

---

## Performance Tips

- The model is very lightweight (~170K parameters, 692 KB) and runs efficiently on mobile devices.
- Inference is throttled to every 500ms to balance responsiveness and CPU usage.
- YUV→RGB conversion is the most CPU-intensive step; consider using isolates for very low-end devices.
- The busy flag prevents queue buildup in the inference pipeline.

---

## Future: Google AI Story Generation

To integrate Google Generative AI for dynamic story generation:

1. Create a new class that implements `StoryGenerator`:

```dart
class GoogleAIStoryService implements StoryGenerator {
  @override
  Future<TherapeuticStory> generateStory(String emotion) async {
    // Call Google Generative AI API with a prompt like:
    // "Write a short therapeutic Arabic story for a child with autism
    //  who is feeling [emotion]. Include a moral lesson."
    // Parse the response into a TherapeuticStory object.
  }
}
```

2. Swap `LocalTherapeuticStoryService` with `GoogleAIStoryService` in the story screen.

---

## References

- FER-Plus Model: Original custom-trained model (87.66% accuracy)
- [tflite_flutter](https://pub.dev/packages/tflite_flutter) — TFLite Flutter plugin
- [google_ml_kit](https://pub.dev/packages/google_ml_kit) — ML Kit for face detection
- [camera](https://pub.dev/packages/camera) — Camera plugin
- [image](https://pub.dev/packages/image) — Image manipulation
