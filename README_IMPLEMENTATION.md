# Quran + Azkar App - Implementation Guide

## Getting Started

### Prerequisites

1. **Flutter SDK**: Install Flutter 3.0+ from [flutter.dev](https://flutter.dev)
2. **Dart SDK**: Comes with Flutter
3. **Android Studio / VS Code**: With Flutter plugins
4. **Xcode** (for iOS): macOS only
5. **Android SDK**: For Android development

### Installation

```bash
# Clone the repository
cd Quran-Apps

# Install dependencies
flutter pub get

# Generate code (freezed, json_serializable, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── database/          # SQLite database setup
│   ├── network/           # HTTP client, API services
│   ├── di/                # Dependency injection
│   ├── utils/             # Utilities, extensions
│   ├── constants/        # App constants
│   └── theme/            # App themes, colors
├── features/
│   ├── quran/            # Quran reading feature
│   │   ├── data/         # Data sources, repositories
│   │   ├── domain/       # Business logic, models
│   │   └── presentation/ # UI, screens, widgets
│   ├── azkar/            # Azkar feature
│   ├── audio/            # Audio playback
│   ├── settings/         # Settings screen
│   ├── home/             # Home screen
│   └── onboarding/       # Onboarding flow
├── shared/
│   ├── models/           # Shared data models
│   ├── widgets/         # Reusable widgets
│   └── l10n/            # Localization files
└── main.dart            # App entry point
```

## Architecture

The app follows **Clean Architecture** with three layers:

1. **Presentation Layer**: UI, State Management (Riverpod)
2. **Domain Layer**: Business Logic, Use Cases, Domain Models
3. **Data Layer**: Repositories, Data Sources (Local/Remote)

### State Management

Using **Riverpod** for state management:
- Providers for dependency injection
- State providers for UI state
- Future/Stream providers for async data

### Database

Using **SQLite** (sqflite) for local storage:
- Quran text, translations, azkar
- User data (bookmarks, notes, highlights)
- Settings, preferences

### Offline-First

- All core features work offline
- Local-first data access
- Sync when online (optional)

## Development Workflow

### Running the App

```bash
# Development
flutter run

# iOS
flutter run -d ios

# Android
flutter run -d android

# Specific device
flutter devices
flutter run -d <device-id>
```

### Code Generation

```bash
# Watch mode (auto-generate on save)
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/quran/domain/usecases/get_surah_test.dart

# Integration tests
flutter test integration_test/
```

### Building

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Features Implementation Status

- [x] Project Setup
- [ ] Core Infrastructure
- [ ] Database Setup
- [ ] Onboarding
- [ ] Home Screen
- [ ] Quran Browsing
- [ ] Quran Reading
- [ ] Search
- [ ] Bookmarks/Notes/Highlights
- [ ] Audio Playback
- [ ] Azkar Library
- [ ] Reminders
- [ ] Settings
- [ ] Cloud Sync
- [ ] Analytics

## Content Data

The app requires content packs:
- Quran text (Arabic)
- Translations (multiple languages)
- Azkar library
- Audio files (optional)

Content packs should be placed in `assets/data/` or downloaded on first run.

## Contributing

1. Create a feature branch
2. Implement feature following architecture
3. Write tests
4. Update documentation
5. Submit PR

## License

[Your License Here]

