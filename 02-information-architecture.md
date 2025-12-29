# Information Architecture

## Main Navigation (Tab Structure)

### Recommended Tab Layout

1. **Home** - Resume reading, daily verse/zekr, quick actions
2. **Quran** - Browse, read, search
3. **Azkar** - Categories, counters, reminders
4. **Audio** - Reciters, downloads, playlists
5. **Settings** - Appearance, content, backups, privacy

### Alternative Navigation Patterns

- **Bottom Navigation** (recommended for mobile): 5 tabs as above
- **Drawer Navigation** (alternative): Hamburger menu with sections
- **Hybrid**: Bottom tabs for primary, drawer for secondary

## Content Entities (Core Data Models)

### QuranText

**Purpose**: Core Quran text with metadata

**Fields**:
```
- ayahId: String (unique identifier)
- surahNumber: Int (1-114)
- ayahNumber: Int (within surah)
- text: String (Arabic text with diacritics)
- pageNumber: Int (mushaf page)
- juzNumber: Int (1-30)
- hizbNumber: Int (1-60)
- rubNumber: Int (1-240)
- rukuNumber: Int (optional)
- sajdahMarker: Boolean (prostration marker)
- bismillah: Boolean (starts with bismillah)
- meccan: Boolean (Meccan vs Medinan)
```

**Indexes Required**:
- Primary: (surahNumber, ayahNumber)
- Page lookup: pageNumber
- Juz lookup: juzNumber
- Hizb lookup: hizbNumber

### Translation

**Purpose**: Translations of Quran text

**Fields**:
```
- translationId: String (unique)
- languageCode: String (ISO 639-1, e.g., "en", "ar", "ur")
- translatorName: String
- translatorId: String
- version: String
- ayahId: String (foreign key to QuranText)
- text: String (translated text)
- copyright: String (optional)
- sourceUrl: String (optional)
```

**Relationships**:
- Many translations per ayah
- User can select multiple translations to display

### Tafsir (Optional)

**Purpose**: Commentary/explanation of verses

**Fields**:
```
- tafsirId: String
- sourceName: String (e.g., "Ibn Kathir", "Al-Jalalayn")
- sourceId: String
- languageCode: String
- ayahId: String
- text: String (tafsir text)
- version: String
```

### Reciter

**Purpose**: Audio recitation metadata

**Fields**:
```
- reciterId: String
- name: String (Arabic + transliteration)
- nameTransliterated: String
- style: String (e.g., "Hafs", "Warsh")
- language: String (optional, for translations)
- bitrateOptions: Array<Int> (e.g., [64, 128, 192])
- defaultBitrate: Int
- audioUrlPattern: String (template with {surah}, {ayah} placeholders)
- thumbnailUrl: String (optional)
- description: String (optional)
- isDefault: Boolean
```

### AzkarItem

**Purpose**: Individual azkar/dua item

**Fields**:
```
- azkarId: String
- categoryId: String (foreign key)
- arabicText: String
- transliteration: String (optional)
- translation: String (optional)
- source: String (e.g., "Sahih Bukhari", "Sahih Muslim")
- reference: String (e.g., "Book 1, Hadith 234")
- repeatCount: Int (default count, e.g., 3, 7, 33, 100)
- virtues: String (optional, benefits of reciting)
- timeTags: Array<String> (e.g., ["morning", "evening", "sleep", "after-prayer"])
- order: Int (display order within category)
- isFavorite: Boolean (user preference)
```

### AzkarCategory

**Purpose**: Grouping of azkar items

**Fields**:
```
- categoryId: String
- name: String (Arabic + transliteration)
- nameTransliterated: String
- description: String (optional)
- icon: String (optional, icon identifier)
- color: String (optional, theme color)
- timeTags: Array<String> (default time tags for category)
- order: Int (display order)
```

### Reminder

**Purpose**: Notification schedule for azkar

**Fields**:
```
- reminderId: String
- userId: String (if multi-user support)
- categoryId: String (optional, for category-based reminders)
- azkarId: String (optional, for specific item)
- type: String ("morning", "evening", "prayer-based", "custom", "periodic")
- time: String (HH:mm format)
- timeWindow: Int (minutes, e.g., 30 for "between 6:00-6:30")
- daysOfWeek: Array<Int> (0=Sunday, 1=Monday, etc., empty = daily)
- enabled: Boolean
- notificationContent: String ("generic" | "snippet")
- snoozeRules: Object (maxSnoozes: Int, snoozeInterval: Int)
- timezone: String (IANA timezone)
- lastTriggered: DateTime (optional)
```

### UserData

**Purpose**: User-generated content and preferences

**Fields**:
```
- userId: String (UUID)
- bookmarks: Array<Bookmark>
- lastRead: LastReadPosition
- notes: Array<Note>
- highlights: Array<Highlight>
- preferences: UserPreferences
- downloadIndexes: Array<DownloadManifest>
- azkarProgress: AzkarProgress
- syncMetadata: SyncMetadata (optional)
```

### Bookmark

**Fields**:
```
- bookmarkId: String (UUID)
- ayahId: String
- surahNumber: Int
- ayahNumber: Int
- folderId: String (optional)
- label: String (optional)
- color: String (optional)
- createdAt: DateTime
- updatedAt: DateTime
```

### BookmarkFolder

**Fields**:
```
- folderId: String (UUID)
- name: String
- color: String (optional)
- icon: String (optional)
- order: Int
- createdAt: DateTime
```

### Note

**Fields**:
```
- noteId: String (UUID)
- ayahId: String
- surahNumber: Int
- ayahNumber: Int
- text: String
- createdAt: DateTime
- updatedAt: DateTime
- isEncrypted: Boolean (optional)
```

### Highlight

**Fields**:
```
- highlightId: String (UUID)
- ayahId: String
- surahNumber: Int
- ayahNumber: Int
- color: String (hex color)
- createdAt: DateTime
```

### LastReadPosition

**Fields**:
```
- surahNumber: Int
- ayahNumber: Int
- pageNumber: Int (optional)
- timestamp: DateTime
- scrollPosition: Float (optional, normalized 0-1)
```

### UserPreferences

**Fields**:
```
- theme: String ("system", "light", "dark", "sepia")
- arabicFontSize: Float
- translationFontSize: Float
- lineSpacing: Float
- quranScriptType: String ("uthmani", "indopak")
- defaultTranslationIds: Array<String>
- defaultReciterId: String
- keepScreenOn: Boolean
- autoScrollWithAudio: Boolean
- showTransliteration: Boolean (azkar)
- showTranslation: Boolean (azkar)
- autoAdvanceAzkar: Boolean
- hapticFeedback: Boolean
- quietHoursStart: String (HH:mm)
- quietHoursEnd: String (HH:mm)
- language: String (app UI language)
```

### DownloadManifest

**Fields**:
```
- downloadId: String (UUID)
- reciterId: String
- type: String ("surah", "juz", "full")
- surahNumbers: Array<Int> (if type="surah")
- juzNumbers: Array<Int> (if type="juz")
- status: String ("pending", "downloading", "completed", "failed", "paused")
- progress: Float (0-1)
- totalBytes: Long
- downloadedBytes: Long
- createdAt: DateTime
- completedAt: DateTime (optional)
- errorMessage: String (optional)
```

### AzkarProgress

**Fields**:
```
- userId: String
- categoryId: String
- sessionDate: Date
- itemsCompleted: Int
- totalItems: Int
- timeSpent: Int (seconds)
- streakDays: Int (consecutive days)
- lastCompletedAt: DateTime
```

## Content Relationships

```
QuranText (1) ──< (many) Translation
QuranText (1) ──< (many) Tafsir
QuranText (1) ──< (many) Bookmark
QuranText (1) ──< (many) Note
QuranText (1) ──< (many) Highlight

AzkarCategory (1) ──< (many) AzkarItem
AzkarCategory (1) ──< (many) Reminder
AzkarItem (1) ──< (many) Reminder

Reciter (1) ──< (many) DownloadManifest
```

## Content Versioning

All content packs must include:
- **Version**: Semantic version (e.g., "1.2.3")
- **Checksum**: SHA-256 hash of pack contents
- **Signature**: Cryptographic signature (optional, for security)
- **Release Date**: ISO 8601 date
- **Change Log**: Brief description of changes

## Content Update Strategy

1. **Base Packs**: Shipped with app (or first-run download)
2. **Incremental Updates**: CDN-hosted, versioned packs
3. **Verification**: Checksum validation before applying
4. **Rollback**: Ability to pin to previous version

