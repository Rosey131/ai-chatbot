# ROSEY AI — Full Android Phone & APK Guide

This guide explains how ROSEY AI has been prepared to work on Android phones and how to build and install the APK.

---

## 1. What Has Been Converted

### 📱 100% Mobile Responsive Touch UI
- **Mobile Viewport & Safe Areas:** Full compatibility with Android punch-hole cameras, notches, and navigation gesture bars (`viewport-fit=cover`, `env(safe-area-inset-top)`).
- **Touch Navigation & Drawer:** Bottom mobile navigation bar (Task, Changes, Settings, Projects) and slide-out mobile drawer for project/session switching.
- **Touch Controls:** Touch-friendly action buttons (Send, Stop, Approve, Settings) with responsive input sizing.

### 🧠 Standalone Mobile Core Engine (`MobileCoreBridge`)
- **Direct Cloud AI Streaming:** Connects directly from your phone to Google Gemini, crax-gpt, Groq, OpenRouter, OpenAI, or remote Ollama (LAN/tunnel).
- **Mobile Storage:** Stores your projects, sessions, API keys, and task history right on your device using encrypted LocalStorage and IndexedDB.
- **Full Verification & Checkpoints:** Simulates full ALTREX V4 task execution, planning, code synthesis, syntax checking, and AI review verdicts directly on your phone.

### 📦 Native Android Project
- Location: `ALTREX-CODE-source/apps/desktop/android/`
- Standard Android Studio / Gradle project with:
  - `AndroidManifest.xml` (Full internet, network state, and storage permissions)
  - `MainActivity.java` (High-performance modern WebViewAssetLoader for fast, secure local asset loading)
  - Native launcher icons (`ic_launcher.png`) configured across all screen densities (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`)

---

## 2. How to Get & Install the APK on Your Phone

### Option A — Build with Android Studio (Visual & Simple)
1. Install [Android Studio](https://developer.android.com/studio) on your PC (if not already installed).
2. Open Android Studio, click **Open**, and select:
   ```text
   ALTREX-CODE-source\apps\desktop\android
   ```
3. Wait for Gradle sync to complete.
4. Click **Build** in the top menu -> **Build Bundle(s) / APK(s)** -> **Build APK(s)**.
5. Android Studio will notify you: *"APK(s) generated successfully"*. Click **locate** to find `app-debug.apk`.
6. Transfer `app-debug.apk` to your phone (via USB cable, Google Drive, WhatsApp, or Telegram) and tap to install!

---

### Option B — Automated Cloud Build with GitHub Actions (Zero Local Setup)
1. Push this repository to your GitHub account:
   ```bash
   git add .
   git commit -m "Convert ALTREX CODE for Android phone"
   git push origin main
   ```
2. Go to your repository on GitHub and click the **Actions** tab.
3. The **Build Android APK** workflow will run automatically.
4. Once finished, click on the workflow run and download the **ROSEY-AI-Android-APK** artifact.
5. Extract the downloaded ZIP to get your `app-debug.apk`!

---

### Option C — Command Line Build on Windows
Run the included automated build script in PowerShell or double-click `build-apk.bat`:
```powershell
.\build-apk.ps1
```
This script will build the web assets, sync them to the Android project, and run Gradle to output `ROSEY-AI.apk`.

---

### Option D — Instant Phone Testing via Local WiFi (No APK Installation Needed)
You can test the full mobile app on your Android phone right now over your home/office WiFi:
1. Start the mobile development server:
   ```powershell
   cd ALTREX-CODE-source\apps\desktop
   pnpm run dev:web
   ```
2. Find your PC's local IP address (e.g. `192.168.1.5` by running `ipconfig` in PowerShell).
3. On your phone's browser (Chrome, Samsung Internet, or Brave), open:
   ```text
   http://<YOUR-PC-IP>:4173
   ```
4. In Chrome on your phone, tap the **three dots menu (⋮)** -> **"Add to Home screen"** or **"Install app"**.
5. ROSEY AI will install as a native full-screen app on your phone with an app icon!
