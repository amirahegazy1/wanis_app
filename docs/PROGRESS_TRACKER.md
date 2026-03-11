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
| 3.5   | Daily Emotion Tracking Screens | - Extracted Figma designs for Emotion tracking screens (Node 285:378).<br>- Implemented `DailyEmotionTrackingScreen` and `DailyEmotionSuccessDialog`.<br>- Built navigation flow from Home screen ("مشاعر" button).<br>- Used Readex Pro app theme for typography. |
| 3.6   | Achievements Screen Implementation | - Extracted Figma designs for Achievements Screen (Node 285:379).<br>- Implemented `AchievementsScreen` with total stars and badges (Story Hero, Creative Artist, King of Calmness, Explorer).<br>- Connected "إنجازاتي" button in Home Screen bottom navigation.<br>- Kept Readex Pro app theme for typography. |
| 3.7   | Profile & Parent Dashboard     | - Extracted Figma designs for Profile Screens (285:380) and Dashboard (285:381).<br>- Implementing Profile screen, Edit Profile screen, Parent Gate dialog, and Parent Dashboard.<br>- Connecting Profile to Home screen bottom navigation.<br>- Kept Readex Pro app theme for typography. |
| 5     | Emotion Detection Module         | - Integrated TFLite model (`assets/ai/model.tflite`) using `tflite_flutter ^0.12.1`.<br>- Built `EmotionService` with ML Kit face detection, YUV/BGRA image conversion, 48×48 grayscale preprocessing, inference, and softmax.<br>- Rewrote `EmotionRecognitionCameraScreen` with live front-camera stream and real-time emotion display.<br>- Created `TherapeuticStoryService` with abstract `StoryGenerator` interface (ready for future Google AI swap) and predefined Arabic stories for all 8 emotions.<br>- Updated `WanisStoryWritingScreen` with animated story display, moral lesson card, and re-generation button.<br>- Configured `aaptOptions { noCompress "tflite" }` in Android `build.gradle.kts`. |
| —     | Onboarding V2 Polish             | Fixed RTL alignment in `OnboardingInput` (password visibility toggle position swapped to suffix), corrected terms checkbox order, integrated full `OnboardingSocialButton` for Google sign-up, fixed back button orientation, and removed redundant Stacks/padding across 5 screens. |
---

## In Progress
(None currently)

---

## To-Do

| Phase | Description                            | Notes                                                                                                  |
|-------|----------------------------------------|--------------------------------------------------------------------------------------------------------|
| 4     | Core Layer & Theme Setup               | Implement shared utilities, app theme, routing, and dependency injection scaffold.                      |
| 6     | Emotion Router & Strategy Pattern      | Implement `EmotionRouter`, concrete strategies, and emotion-to-content mapping.                         |
| 7     | Child Interface                        | Build calming exercises, interactive stories, and soothing music screens.                               |
| 8     | Emotion Reports & Analytics            | Parent dashboard charts, session history, and trend visualisation.                                      |
| 9     | Testing & QA                           | Unit tests, widget tests, integration tests, and accessibility audit.                                   |
| 10    | Polish & Release Prep                  | Performance profiling, final UI polish, store listing assets, and release builds.                       |
