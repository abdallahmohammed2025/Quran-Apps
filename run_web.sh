#!/bin/bash

# Run Flutter web app on fixed port 8080

PORT=${1:-8080}

echo "🚀 Starting Quran & Azkar App on port $PORT"
echo "=========================================="
echo ""

# Kill any existing Flutter processes
pkill -f "flutter run" 2>/dev/null || true

# Run on fixed port
flutter run -d chrome --web-port=$PORT --web-renderer html

