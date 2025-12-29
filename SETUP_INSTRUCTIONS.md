# Setup Instructions

## Prerequisites

1. **Install Flutter SDK** (3.0+)
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Add Flutter to your PATH
   - Verify installation: `flutter doctor`

2. **Install IDE**
   - Android Studio (recommended) or VS Code
   - Install Flutter and Dart plugins

3. **For iOS Development** (macOS only)
   - Install Xcode from App Store
   - Install CocoaPods: `sudo gem install cocoapods`

4. **For Android Development**
   - Install Android Studio
   - Install Android SDK (API 26+)
   - Set up Android emulator or connect physical device

## Project Setup

1. **Navigate to project directory**
   ```bash
   cd Quran-Apps
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (for freezed, json_serializable, etc.)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # List available devices
   flutter devices
   
   # Run on specific device
   flutter run -d <device-id>
   
   # Or just run (will use default device)
   flutter run
   ```

## Project Structure

```
lib/
├── core/                    # Core infrastructure
│   ├── database/          # SQLite database
│   ├── di/                 # Dependency injection
│   ├── theme/              # App themes
│   └── utils/              # Utilities
├── features/               # Feature modules
│   ├── quran/             # Quran reading
│   ├── azkar/             # Azkar library
│   ├── audio/             # Audio playback
│   ├── home/              # Home screen
│   ├── onboarding/         # Onboarding flow
│   └── settings/           # Settings
├── shared/                 # Shared code
│   ├── models/            # Data models
│   └── widgets/           # Reusable widgets
└── main.dart              # App entry point
```

## Current Implementation Status

### ✅ Completed
- Project structure
- Database schema
- Theme system
- Onboarding flow
- Home screen
- Quran browsing (surah list)
- Quran reading view (basic)
- Sample data loader

### 🚧 In Progress
- Repository implementations
- Translation display
- Bookmarks/Notes/Highlights
- Azkar features
- Audio playback

### 📋 Next Steps
1. Add more sample data (all 114 surahs)
2. Implement translation loading
3. Add bookmark/note/highlight functionality
4. Implement Azkar features
5. Add audio playback
6. Add search functionality

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/quran/domain/usecases/get_surah_test.dart

# Run with coverage
flutter test --coverage
```

## Building for Release

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build iOS app
flutter build ios --release

# Open in Xcode for further configuration
open ios/Runner.xcworkspace
```

## Troubleshooting

### Common Issues

1. **"command not found: flutter"**
   - Add Flutter to your PATH
   - Restart terminal

2. **"No devices found"**
   - Start Android emulator or connect device
   - Run `flutter devices` to verify

3. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Run `flutter pub run build_runner build --delete-conflicting-outputs`

4. **Database errors**
   - Delete app and reinstall (clears database)
   - Or uninstall and reinstall

## Development Tips

1. **Hot Reload**: Press `r` in terminal while app is running
2. **Hot Restart**: Press `R` in terminal
3. **Widget Inspector**: Use Flutter DevTools
4. **Debugging**: Use breakpoints in IDE

## Next Development Steps

1. **Add Content Data**
   - Create content pack loader
   - Load full Quran text
   - Load translations
   - Load Azkar data

2. **Implement Features**
   - Complete Quran reading features
   - Implement Azkar with counters
   - Add audio playback
   - Add search functionality

3. **Polish**
   - Improve UI/UX
   - Add animations
   - Implement accessibility
   - Add localization

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Riverpod Documentation](https://riverpod.dev)
- [SQLite (sqflite) Documentation](https://pub.dev/packages/sqflite)

