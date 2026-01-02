# How to Load Full Quran Content

## Quick Answer

The app will **automatically attempt** to load the full Quran on first launch if you have less than 10 surahs. However, since this requires network access and takes 2-3 minutes, you may prefer to trigger it manually.

## Method 1: Automatic (On App Start)

The app automatically tries to load full Quran if:
- You have < 10 surahs (sample data detected)
- Network connection is available
- This happens in the background during app initialization

**Note**: This may slow down first launch. Consider Method 2 for better UX.

## Method 2: Manual Download (Recommended)

Add a "Download Full Quran" button in Settings. I've created `QuranSettingsPage` for this purpose.

To use it:
1. Add navigation to the settings page
2. User can tap "Download Full Quran" button
3. Shows progress and status

## Method 3: Programmatic Trigger

You can trigger the download programmatically:

```dart
import 'package:quran_azkar_app/core/utils/quran_api_loader.dart';

// Check if full Quran exists
final hasFull = await QuranApiLoader.hasFullQuran();

if (!hasFull) {
  // Download full Quran
  await QuranApiLoader.loadFullQuran();
}
```

## What Gets Downloaded

- **All 114 surahs**
- **~6,236 ayahs (verses)**
- **Arabic text**
- **Page numbers**
- **Juz numbers**
- **Meccan/Medinan classification**

## Performance

- **Download time**: 2-3 minutes (fetches 114 surahs sequentially)
- **Database size**: ~5-10 MB after download
- **Offline**: Works completely offline after download
- **Cached**: Content is stored locally, no re-download needed

## API Source

Uses **Al-Quran Cloud API** (https://api.alquran.cloud/):
- Free, no API key required
- Reliable and fast
- Verified Quranic text

## Troubleshooting

If download fails:
1. Check internet connection
2. Check console for error messages
3. Try again - API may have temporary issues
4. Wait a few minutes and retry

## Alternative: Use JSON File

If API fails, you can download a JSON file manually:

1. Download from: https://api.alquran.cloud/v1/quran/quran-uthmani
2. Format it to match our data structure
3. Save as `assets/data/quran_text.json`
4. App will automatically load from file

## Next Steps

The code is ready! The app will automatically try to load full Quran on first launch (if you have sample data). For production, consider:

1. Adding a download button in Settings (already created)
2. Showing download progress
3. Caching mechanism
4. Offline-first approach

