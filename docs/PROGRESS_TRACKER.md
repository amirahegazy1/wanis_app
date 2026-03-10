# Wanis — Progress Tracker

> Last updated: 2026-03-10

---

## Done

| Phase | Description                | Notes                                                                                                                                        |
|-------|----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| 0     | Documentation Setup        | Created `docs/PROJECT_REQUIREMENTS.md`, `ARCHITECTURE.md`, and this tracker.                                                                 |
| 1     | Dependencies & Firebase    | Added core dependencies in `pubspec.yaml` (Firebase, auth providers, camera, AI, BLoC, audio). Firebase project `wanis-1` connected. `firebase_options.dart` and `firebase.json` generated. |
| —     | App Rename & Branding      | App renamed to **Wanis** / **ونيس**. Logos updated in `assets/images/`. Launcher icons configured via `flutter_launcher_icons`.              |
| —     | Android SDK Version Fix    | `minSdk` raised from 24 → **26** in `android/app/build.gradle.kts` to satisfy `google_mlkit_genai_prompt`.                                  |

---

## In Progress

| Phase | Description                               | Notes                                                                                                                                                                            |
|-------|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2     | Data Models & Base Services               | Three OOP models created (`ParentUser`, `ChildProfile`, `ContentItem`) in `lib/models/`. Two services created (`AuthService`, `FirestoreService`) in `lib/services/`.            |
| 3     | Onboarding / Auth UI                      | Nine onboarding screens implemented in `lib/features/onboarding/presentation/screens/` (Login, Sign Up, Forgot Password, OTP, New Password, Success screens, Add Child, shared widgets). |

---

## To-Do

| Phase | Description                            | Notes                                                                                                  |
|-------|----------------------------------------|--------------------------------------------------------------------------------------------------------|
| —     | Customise `main.dart`                  | Replace the default Flutter counter template with Wanis app entry point, theme, and routing.            |
| —     | Declare Assets in `pubspec.yaml`       | Add `assets:` section under `flutter:` to reference `assets/images/` and future model files.           |
| —     | Wire Firebase Initialisation           | Add `Firebase.initializeApp()` in `main.dart` using `DefaultFirebaseOptions`.                          |
| 4     | Core Layer & Theme Setup               | Implement shared utilities, app theme, routing, and dependency injection scaffold.                      |
| 5     | Emotion Detection Module               | Integrate `.tflite` model, camera feed, and on-device inference pipeline.                               |
| 6     | Emotion Router & Strategy Pattern      | Implement `EmotionRouter`, concrete strategies, and emotion-to-content mapping.                         |
| 7     | Child Interface                        | Build calming exercises, interactive stories, and soothing music screens.                               |
| 8     | Emotion Reports & Analytics            | Parent dashboard charts, session history, and trend visualisation.                                      |
| 9     | Testing & QA                           | Unit tests, widget tests, integration tests, and accessibility audit.                                   |
| 10    | Polish & Release Prep                  | Performance profiling, final UI polish, store listing assets, and release builds.                       |
