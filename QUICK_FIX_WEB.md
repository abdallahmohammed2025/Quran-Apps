# Quick Fix: Web App Not Loading

## Problem
`http://localhost:8080/` is not loading

## Solutions

### Solution 1: Kill Existing Processes and Restart
```bash
# Kill processes on port 8080
lsof -ti:8080 | xargs kill -9

# Start app
flutter run -d chrome --web-port=8080 --web-renderer html
```

### Solution 2: Use Different Port
```bash
# Use port 3000 instead
flutter run -d chrome --web-port=3000 --web-renderer html
```
Then open: `http://localhost:3000`

### Solution 3: Build and Serve Manually
```bash
# Build the app
flutter build web

# Serve with Python
cd build/web
python3 -m http.server 8080
```

### Solution 4: Use Release Mode (More Stable)
```bash
flutter run -d chrome --web-port=8080 --release
```

### Solution 5: Check Chrome
- Close all Chrome windows
- Try again
- Or use a different browser: `flutter run -d edge --web-port=8080`

## Common Issues

### Port Already in Use
```bash
# Find what's using port 8080
lsof -i:8080

# Kill it
kill -9 <PID>
```

### Chrome Not Opening
- Check if Chrome is installed
- Try manual: Open Chrome and go to `http://localhost:8080`
- Check terminal for the actual URL (might be different port)

### App Crashes on Load
- Check terminal for errors
- Try release mode: `flutter run -d chrome --release`
- Check browser console (F12)

## Verify It's Running

1. **Check terminal** - Should see:
   ```
   🌍  Serving at http://localhost:8080
   ```

2. **Check browser** - Chrome should open automatically

3. **Manual check** - Open `http://localhost:8080` in browser

## Still Not Working?

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome --web-port=8080
   ```

2. **Check Flutter doctor:**
   ```bash
   flutter doctor
   ```

3. **Check web support:**
   ```bash
   flutter config --enable-web
   flutter doctor
   ```

