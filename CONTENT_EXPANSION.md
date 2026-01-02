# Content Expansion Guide

## Current Status

### Quran Content
Currently, the app only includes **sample surahs** (about 10 surahs with partial ayahs):
- Al-Fatiha (1) - Complete
- Al-Baqarah (2) - Partial (first few ayahs)
- Ali Imran (3) - Partial
- Ya-Sin (36) - Partial
- Ar-Rahman (55) - Partial
- Al-Mulk (67) - Partial
- An-Naba (78) - Partial
- Al-Ikhlas (112) - Complete
- Al-Falaq (113) - Complete
- An-Nas (114) - Complete

### Azkar Content
Currently includes **8 categories** with **~20 items**:
- Morning Azkar (3 items)
- Evening Azkar (3 items)
- After Prayer (5 items)
- Before Sleep (3 items)
- Upon Waking (1 item)
- Protection (2 items)
- Gratitude (1 item)
- General (2 items)

## To Add Full Content

### Option 1: JSON Files (Recommended)
Create JSON files in `assets/data/`:
- `quran_text.json` - All 114 surahs with all ~6,236 ayahs
- `azkar_categories.json` - All categories
- `azkar_items.json` - All azkar items

### Option 2: Content Pack
Download content packs from a trusted source and load them via the content management system.

### Option 3: API Integration
Integrate with a Quran API (like Al-Quran Cloud API, Tanzil API, etc.) to fetch content.

## Sources for Full Content

### Quran Text
- **Tanzil Project**: https://tanzil.net/ - Provides verified Quran text
- **Al-Quran Cloud API**: https://alquran.cloud/api - REST API for Quran content
- **Quran.com API**: https://api.quran.com/ - Comprehensive Quran API

### Azkar
- Islamic texts and Hadith collections
- Verified Azkar collections from authentic sources

## Implementation Notes

The app is designed to work with:
1. **Sample data** (current) - for testing and development
2. **Full JSON files** - load from assets
3. **Content packs** - downloadable packs with full content
4. **API integration** - fetch on-demand or cache

## Next Steps

1. Obtain full Quran text from a trusted source
2. Format as JSON matching the `QuranText` model
3. Place in `assets/data/quran_text.json`
4. Add comprehensive Azkar items
5. Update content loader to prioritize JSON files

The app will automatically load from JSON files if they exist, otherwise fall back to sample data.

