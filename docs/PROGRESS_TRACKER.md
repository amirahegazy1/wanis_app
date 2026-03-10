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
| 2     | Data Models & Base Services| Three OOP models (`ParentUser`, `ChildProfile`, `ContentItem`) in `lib/models/`. Two services (`AuthService`, `FirestoreService`) in `lib/services/`. Added `signInWithEmail`/`signUpWithEmail` to `AuthService`. |
| 3     | Onboarding / Auth UI       | 10 screen files in `lib/features/onboarding/presentation/screens/` (Splash, Login, Sign Up, Forgot Password, OTP, New Password, Password Reset Success, Account Creation Success, Add Child, shared widgets). All use **Readex Pro** font via `google_fonts`. |
| —     | Customise `main.dart`      | Replaced default counter template with `WanisApp`. Readex Pro set as app-wide default font. Starting screen: `OnboardingSplashScreen`.       |
| —     | Declare Assets             | `assets/images/` declared in `pubspec.yaml`.                                                                                                 |
| —     | Stub Screens               | Created placeholder `AppEntryScreen`, `ParentShellScreen`, and `parent_providers.dart` so onboarding navigation compiles.                     |

---

## In Progress

| Phase | Description                               | Notes                                                                                                                                                                            |
|-------|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| —     | Wire Firebase Initialisation              | Need to add `Firebase.initializeApp()` in `main.dart` using `DefaultFirebaseOptions`.                                                                                            |

---

## To-Do

| Phase | Description                            | Notes                                                                                                  |
|-------|----------------------------------------|--------------------------------------------------------------------------------------------------------|
| 4     | Core Layer & Theme Setup               | Implement shared utilities, app theme, routing, and dependency injection scaffold.                      |
| 5     | Emotion Detection Module               | Integrate `.tflite` model, camera feed, and on-device inference pipeline.                               |
| 6     | Emotion Router & Strategy Pattern      | Implement `EmotionRouter`, concrete strategies, and emotion-to-content mapping.                         |
| 7     | Child Interface                        | Build calming exercises, interactive stories, and soothing music screens.                               |
| 8     | Emotion Reports & Analytics            | Parent dashboard charts, session history, and trend visualisation.                                      |
| 9     | Testing & QA                           | Unit tests, widget tests, integration tests, and accessibility audit.                                   |
| 10    | Polish & Release Prep                  | Performance profiling, final UI polish, store listing assets, and release builds.                       |
