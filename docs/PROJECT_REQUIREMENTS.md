# Wanis -- Project Requirements

## 1. Overview

**Wanis** is a cross-platform mobile application built with **Flutter** (Android & iOS). Its mission is to support **autistic children** in understanding, identifying, and managing their emotions through a combination of on-device AI emotion detection and guided therapeutic content.

The app provides two distinct user experiences:

- A **Parent Dashboard** for monitoring and managing a child's emotional journey.
- A **Child Interface** that responds dynamically to detected emotions with calming exercises, interactive stories, and soothing music.

---

## 2. Core Features

### 2.1 Local AI Emotion Detection

Wanis performs real-time facial emotion recognition entirely on-device using a TensorFlow Lite (`.tflite`) model. No images or video frames leave the device, preserving the child's privacy.

| # | Emotion Class |
|---|---------------|
| 1 | Neutral       |
| 2 | Happiness     |
| 3 | Surprise      |
| 4 | Sadness       |
| 5 | Anger         |
| 6 | Disgust       |
| 7 | Fear          |
| 8 | Contempt      |

**Key characteristics:**

- **8-class classification** covering the primary emotional spectrum.
- **On-device inference** -- no network calls required for detection.
- **Camera integration** -- live feed processed frame-by-frame for continuous detection.
- **Confidence thresholds** -- only emotions above a configurable confidence level trigger content changes.

> **Implementation note:** The `ClassEmotion` enum in `lib/models/content_item.dart` currently defines 7 values (`happy`, `sad`, `angry`, `fearful`, `surprised`, `neutral`, `disgusted`). The 8th class — *Contempt* — should be added once the TFLite model output labels are confirmed.

### 2.2 Dual User Flows

#### A) Parent Dashboard

The parent-facing side of the app provides oversight and management capabilities.

| Capability              | Description                                                                                  |
|-------------------------|----------------------------------------------------------------------------------------------|
| **Authentication**      | Secure sign-up / sign-in via Firebase Auth (email/password, with potential social providers). |
| **Child Profile**       | Create and manage one or more child profiles (name, age, avatar, preferences).               |
| **Emotion Reports**     | View historical emotion data -- charts, trends, and session summaries.                       |
| **Content Preferences** | Optionally configure which calming strategies or content categories are enabled.              |
| **Settings**            | Account management, notification preferences, and app configuration.                         |

#### B) Child Interface

The child-facing side prioritises accessibility, simplicity, and emotional responsiveness.

| Feature                  | Description                                                                                                     |
|--------------------------|-----------------------------------------------------------------------------------------------------------------|
| **Responsive UI**        | Large, colourful elements with minimal text; designed for ease of use by children on the autism spectrum.        |
| **Calming Exercises**    | Guided breathing animations, grounding techniques, and sensory-focused activities triggered by negative emotions.|
| **Interactive Stories**  | Short, emotion-themed stories that help children name and normalise their feelings.                              |
| **Soothing Music**       | Ambient audio tracks and sound effects that adapt to the detected emotional state.                               |
| **Emotion-Driven Flow**  | The entire interface dynamically adjusts based on the AI model's output (colours, content, audio).               |

### 2.3 Backend -- Firebase

| Service              | Purpose                                                                                 |
|----------------------|-----------------------------------------------------------------------------------------|
| **Firebase Auth**    | User authentication and session management for parent accounts.                         |
| **Cloud Firestore**  | Storage of child profiles, emotion session logs, and **emotion-tagged content** metadata.|

Content stored in Firestore is tagged with one or more of the 8 emotion classes, enabling the app to query and serve the right calming exercise, story, or music track in response to a detected emotion.

---

## 3. Target Platforms

| Platform | Minimum Version |
|----------|-----------------|
| Android  | API 26 (8.0)    |
| iOS      | 12.0            |

---

## 4. Non-Functional Requirements

- **Privacy-first**: All emotion detection happens on-device. No facial images are stored or transmitted.
- **Offline capability**: Emotion detection and locally-cached content must function without an internet connection.
- **Accessibility**: The child interface must follow accessibility best practices -- high contrast, large touch targets, minimal cognitive load.
- **Performance**: TFLite inference must maintain a responsive frame rate without draining the battery excessively.

---

## 5. Glossary

| Term             | Definition                                                                                   |
|------------------|----------------------------------------------------------------------------------------------|
| Emotion Router   | The component that maps a detected emotion to a concrete response strategy (see ARCHITECTURE.md). |
| Emotion Session  | A continuous period during which the camera is active and emotions are being detected.        |
| Content Tag      | A Firestore field linking a piece of content (story, exercise, music) to one or more emotions.|
| TFLite Model     | The TensorFlow Lite model file (`.tflite`) used for on-device emotion classification.        |
