# How to Load Full Quran Content

## Current Status

The app currently has **sample data** (~10 surahs with partial ayahs). To load the **full Quran** (all 114 surahs with ~6,236 ayahs), follow one of these methods:

## Method 1: Automatic CDN Load (Recommended)

The app will automatically attempt to load the full Quran from a CDN when it starts (if sample data is detected).

**How it works:**
1. App checks if full Quran exists
2. If not, automatically fetches from CDN
3. Saves to local database
4. Works offline after first load

**No action needed** - it happens automatically on first launch!

## Method 2: Manual Trigger

If you want to manually trigger the load, you can add a button in settings:

```dart
ElevatedButton(
  onPressed: () async {
    await QuranApiLoader.loadFullQuran();
  },
  child: Text('Download Full Quran'),
)
```

## Method 3: Use JSON File

1. Download full Quran JSON from:
   - https://raw.githubusercontent.com/risan/quran-json/main/data/quran.json
   - Or use Al-Quran Cloud API

2. Save to `assets/data/quran_text.json`

3. Format should match:
```json
{
  "ayahs": [
    {
      "ayah_id": "1-1",
      "surah_number": 1,
      "ayah_number": 1,
      "text": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "page_number": 1,
      "juz_number": 1,
      "bismillah": 1,
      "meccan": 1
    }
  ]
}
```

## Method 4: Use API Script

Run the provided script to fetch and format:

```bash
dart scripts/fetch_quran_data.dart
```

This will create `assets/data/quran_text.json` with full content.

## Sources

- **Quran JSON CDN**: https://raw.githubusercontent.com/risan/quran-json/main/data/quran.json
- **Al-Quran Cloud API**: https://api.alquran.cloud/v1/
- **Tanzil Project**: https://tanzil.net/

## Notes

- First load may take 1-2 minutes (downloading ~6,236 ayahs)
- Content is cached locally after first load
- Works offline after initial download
- Network connection required only for first load

## Troubleshooting

If automatic load fails:
1. Check internet connection
2. Try manual trigger
3. Use JSON file method instead
4. Check console for error messages

