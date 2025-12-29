# How to Run the App

## ✅ Yes, it works on iOS, Android, AND Web!

This is a **Flutter** app, which means:
- ✅ **Single codebase** for all platforms
- ✅ **iOS** (iPhone/iPad)
- ✅ **Android** (phones/tablets)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)

## 📋 Prerequisites

### 1. Install Flutter SDK

**For macOS (you're on macOS):**

```bash
# Option 1: Using Homebrew (easiest)
brew install --cask flutter

# Option 2: Manual installation
# 1. Download Flutter SDK from: https://flutter.dev/docs/get-started/install/macos
# 2. Extract to a location (e.g., ~/development/flutter)
# 3. Add to PATH:
export PATH="$PATH:$HOME/development/flutter/bin"
```

**Verify installation:**
```bash
flutter --version
flutter doctor
```

### 2. Enable Web Support

```bash
flutter config --enable-web
```

### 3. Install IDE (Choose one)

**Option A: Android Studio (Recommended)**
- Download from: https://developer.android.com/studio
- Install Flutter and Dart plugins
- Install Android SDK (API 26+)

**Option B: VS Code**
- Download from: https://code.visualstudio.com/
- Install Flutter extension
- Install Dart extension

### 4. Platform-Specific Setup

#### For iOS Development (macOS only):
```bash
# Install Xcode from App Store
# Install CocoaPods
sudo gem install cocoapods

# Accept Xcode license
sudo xcodebuild -license accept
```

#### For Android Development:
- Install Android Studio
- Install Android SDK (comes with Android Studio)
- Set up Android emulator OR connect physical device

#### For Web Development:
- No additional setup needed!
- Just need a modern browser (Chrome, Firefox, Safari, Edge)

## 🚀 Running the App

### Step 1: Navigate to Project
```bash
cd /Users/amohammed/Documents/GitHub/Quran-Apps
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Check Available Devices
```bash
flutter devices
```

You should see something like:
```
3 connected devices:

Chrome (web) • chrome • web-javascript • Google Chrome 120.0.0.0
iPhone 15 Pro (mobile) • 12345678-1234-1234-1234-123456789012 • ios • com.apple.CoreSimulator.SimRuntime.iOS-17-0
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 13 (API 33)
```

### Step 4: Run the App

**Option A: Run on Web (Easiest!)**
```bash
flutter run -d chrome
```

**Option B: Run on iOS**
```bash
flutter run -d ios
```

**Option C: Run on Android**
```bash
flutter run -d android
```

**Option D: Run on Default Device**
```bash
flutter run
```

**Option E: Run in Release Mode (faster)**
```bash
flutter run --release
```

## 🌐 Web-Specific Instructions

### Running on Web

```bash
# Run in Chrome (default)
flutter run -d chrome

# Run in specific browser
flutter run -d chrome
flutter run -d edge
flutter run -d firefox

# Run in release mode (better performance)
flutter run -d chrome --release
```

### Building for Web

```bash
# Build for web
flutter build web

# Output: build/web/
# Deploy this folder to any web server
```

### Accessing Web Version

Once running, you'll see:
```
Flutter run key commands.
r Hot reload.
R Hot restart.
q Quit.
💪 Running with sound null safety
🌍  Serving at http://localhost:xxxxx
```

Open the URL in your browser!

## 📱 Running on Physical Devices

### iOS (iPhone/iPad)

1. **Connect device via USB**
2. **Trust computer** on device
3. **Enable Developer Mode** (Settings > Privacy & Security > Developer Mode)
4. **Run:**
   ```bash
   flutter run -d ios
   ```

### Android (Phone/Tablet)

1. **Enable Developer Options** on device:
   - Settings > About Phone > Tap "Build Number" 7 times
2. **Enable USB Debugging:**
   - Settings > Developer Options > USB Debugging
3. **Connect device via USB**
4. **Accept USB debugging** prompt on device
5. **Run:**
   ```bash
   flutter run -d android
   ```

## 🎯 Quick Start (After Flutter is Installed)

```bash
# 1. Go to project directory
cd /Users/amohammed/Documents/GitHub/Quran-Apps

# 2. Enable web support
flutter config --enable-web

# 3. Get dependencies
flutter pub get

# 4. Run on web (easiest - no device needed!)
flutter run -d chrome
```

The app will:
- Open in your browser automatically
- Show onboarding on first launch
- Load sample Quran data
- Display surah list
- Allow reading of sample surahs

## 🔧 Troubleshooting

### "Flutter command not found"
- Add Flutter to your PATH
- Restart terminal
- Run `flutter doctor` to verify

### "Web support not enabled"
```bash
flutter config --enable-web
flutter doctor
```

### "No devices found"

**For Web:**
- Just run `flutter run -d chrome` (Chrome will open automatically)

**For iOS:**
```bash
# Open Simulator
open -a Simulator

# Or list simulators
xcrun simctl list devices
```

**For Android:**
```bash
# Start emulator from Android Studio
# Or list emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator-id>
```

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### iOS Build Issues
```bash
# Install CocoaPods dependencies
cd ios
pod install
cd ..
flutter run
```

### Android Build Issues
```bash
# Check Android SDK
flutter doctor --android-licenses

# Accept all licenses
sdkmanager --licenses
```

### Web Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build web
```

## 📊 Check Setup Status

Run this to see what's configured:
```bash
flutter doctor -v
```

You should see:
- ✅ Flutter (Channel stable, version)
- ✅ Chrome (for web)
- ✅ Android toolchain (if Android setup)
- ✅ Xcode (if iOS setup)
- ✅ Android Studio / VS Code

## 🎨 Development Tips

### Hot Reload
While app is running:
- Press `r` in terminal = Hot reload (fast refresh)
- Press `R` in terminal = Hot restart (full restart)
- Press `q` = Quit

### Debug Mode
- Default mode includes debugging tools
- Slower but has hot reload
- Use for development

### Release Mode
- Faster performance
- No debugging tools
- Use for testing final app
```bash
flutter run --release
```

## 📦 Building for Distribution

### Web
```bash
flutter build web --release
# Output: build/web/
# Deploy to any web server
```

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (requires macOS + Xcode)
```bash
flutter build ios --release
# Then open Xcode to archive and upload
```

## ✅ Verification Checklist

Before running, make sure:
- [ ] Flutter is installed (`flutter --version`)
- [ ] Web support enabled (`flutter config --enable-web`)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Device/emulator is running OR browser available (`flutter devices`)
- [ ] For iOS: Xcode installed and configured
- [ ] For Android: Android Studio installed and SDK configured

## 🆘 Still Having Issues?

1. **Check Flutter setup:**
   ```bash
   flutter doctor -v
   ```

2. **Verify project:**
   ```bash
   cd /Users/amohammed/Documents/GitHub/Quran-Apps
   ls -la
   ```

3. **Check dependencies:**
   ```bash
   flutter pub get
   ```

4. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📚 Resources

- **Flutter Installation:** https://flutter.dev/docs/get-started/install
- **Flutter Web:** https://flutter.dev/docs/get-started/web
- **Flutter Docs:** https://flutter.dev/docs
- **Troubleshooting:** https://flutter.dev/docs/get-started/install/macos#troubleshooting

---

**Once Flutter is installed, you can run the app on iOS, Android, AND Web with a single command!** 🚀
