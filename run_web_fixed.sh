#!/bin/bash

# Run Flutter web app with workarounds for Chrome debugging issues

PORT=${1:-8080}

echo "🚀 Starting Quran & Azkar App on port $PORT (Release Mode)"
echo "=========================================================="
echo ""

# Kill any existing Flutter processes
pkill -f "flutter run" 2>/dev/null || true

# Try release mode first (avoids debug connection issues)
echo "Attempting release mode (no debug connection)..."
flutter run -d chrome --web-port=$PORT --release

# If that fails, try with HTML renderer
if [ $? -ne 0 ]; then
  echo ""
  echo "Release mode failed, trying HTML renderer..."
  flutter run -d chrome --web-port=$PORT --web-renderer html
fi

