#!/bin/bash

# Quran + Azkar App - Quick Setup Script

echo "🚀 Quran + Azkar App Setup"
echo "=========================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo ""
    echo "Please install Flutter first:"
    echo "  Option 1: brew install --cask flutter"
    echo "  Option 2: Download from https://flutter.dev/docs/get-started/install/macos"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo "✅ Flutter is installed"
flutter --version
echo ""

# Enable web support
echo "🌐 Enabling web support..."
flutter config --enable-web
echo ""

# Check Flutter setup
echo "🔍 Checking Flutter setup..."
flutter doctor
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get
echo ""

# Generate code
echo "🔧 Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs
echo ""

# Check for devices
echo "📱 Checking for available devices..."
flutter devices
echo ""

echo "✅ Setup complete!"
echo ""
echo "To run the app:"
echo "  flutter run                    # Default device"
echo ""
echo "Platform options:"
echo "  flutter run -d chrome          # Web browser (easiest!)"
echo "  flutter run -d ios             # iOS Simulator"
echo "  flutter run -d android         # Android Emulator"
echo ""
echo "🌐 Web version is the easiest - no device needed!"
echo ""

