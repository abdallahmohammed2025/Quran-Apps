# Troubleshooting Guide

## WebSocket Connection Error

If you see:
```
WebSocketException: Connection to 'http://localhost:...' was not upgraded to websocket
Failed to establish connection with the application instance in Chrome.
```

**This is NOT a compilation error!** The app might still be running in your browser.

### Solutions:

#### Option 1: Check if App is Already Running
- Look for Chrome window that opened automatically
- Check the URL - it should show the app running
- The app might work fine even with this error

#### Option 2: Run with Different Renderer
```bash
# Try HTML renderer (more compatible)
flutter run -d chrome --web-renderer html

# Or CanvasKit renderer
flutter run -d chrome --web-renderer canvaskit
```

#### Option 3: Run in Release Mode (No Debug Connection)
```bash
flutter run -d chrome --release
```
This skips the debug connection entirely.

#### Option 4: Build and Serve Manually
```bash
# Build the app
flutter build web

# Serve it manually (if you have a local server)
# Or just open build/web/index.html in browser
```

#### Option 5: Use Different Browser
```bash
# Try Edge
flutter run -d edge

# Or Firefox (if available)
flutter run -d firefox
```

#### Option 6: Disable Debug Service
```bash
# Run without debug service
flutter run -d chrome --no-web-resources-cdn
```

## Common Issues

### Port Already in Use
```bash
# Kill existing Flutter processes
pkill -f "flutter run"

# Or specify different port
flutter run -d chrome --web-port=8080
```

### Chrome Not Found
```bash
# Make sure Chrome is installed
# Or specify Chrome path
flutter config --chrome-executable="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
```

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d chrome
```

## Quick Fixes

1. **Restart Chrome** - Close all Chrome windows and try again
2. **Clear Flutter cache** - `flutter clean`
3. **Update Flutter** - `flutter upgrade`
4. **Check firewall** - WebSocket might be blocked

## Verify App is Running

Even with WebSocket errors, check:
1. Did Chrome open automatically?
2. Is there a URL showing in terminal?
3. Can you see the app UI in the browser?

If yes, the app IS running - the error is just about debug tools.

