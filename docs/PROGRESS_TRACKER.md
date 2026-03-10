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
| —     | Wire Firebase Initialisation| Added `Firebase.initializeApp()` in `main.dart` using `DefaultFirebaseOptions`.                                                            |
| 3.1   | Home & Stories UI          | Implemented 14 Figma screens/components (`home_screen`, `stories_list`, player, interactive question, and `AnswerFeedbackDialog` overlay).|
| —     | Post-Login Nav & Google Fix| `AppEntryScreen` now routes to `HomeScreen`. Google/Apple Sign-In no longer navigates on cancellation (`null` result check). |
| —     | Flow & Navigation Fixes    | Fixed Sign Up flow to route through Add Child → Account Success → Home. Wired Home screen hero card to `StoriesListScreen`.|
| 3.2   | Games Screens Implementation| - Extract Figma designs for 11 screens (reduced to 4 implemented logic games per plan).<br>- Implement GamesMenuScreen and navigation from Home.<br>- Implement Game Screens (Sorting, Matching, Memory, Emotion Camera).<br>- Implement Win/Retry dialogs. |
| 3.3   | Relaxation Corner Screens   | - Added Figma designs for `RelaxationCornerScreen` and nested activities.<br>- Implemented `BreathingExerciseScreen`, `FidgetGamingScreen`, `NaturalSoundsScreen`, and success dialog.<br>- Routed from Home screen. |
| 3.4   | Coloring Screens Implementation| - Extracted Figma designs for Coloring Menu, Canvas, and Success dialog.<br>- Built the navigation flow starting from the Home screen ("تلوين" button).<br>- Used existing Readex Pro app theme for typography. |
---

## In Progress
(None currently)

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
