# Quick Start - Web Version

## 🌐 Run in Browser (Easiest Way!)

### Step 1: Enable Web Support
```bash
flutter config --enable-web
```

### Step 2: Install Dependencies
```bash
cd /Users/amohammed/Documents/GitHub/Quran-Apps
flutter pub get
```

### Step 3: Run in Browser
```bash
flutter run -d chrome
```

That's it! The app will open in your browser automatically! 🎉

## 📦 What's Different on Web?

### ✅ Works Great
- Quran reading
- Azkar library
- Bookmarks, notes, highlights
- Settings
- Search
- Themes

### ⚠️ Limitations
- Notifications: Browser notifications (limited)
- Background audio: May pause when tab inactive
- Offline: Uses browser storage (limited)

## 🚀 Build for Web Deployment

```bash
# Build
flutter build web

# Output in: build/web/
# Deploy this folder to any web server
```

## 📱 Access on Any Device

Once deployed, users can:
- Open in any browser
- Install as PWA (Progressive Web App)
- Use on phone, tablet, or computer
- No app store needed!

---

**Your app now works everywhere: iOS, Android, AND Web!** 🌐📱

