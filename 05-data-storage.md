# Data & Storage Requirements

## Local Storage Architecture

### Database (SQLite)

**Primary Database**
- **Purpose**: Store structured data with relationships
- **Technology**: SQLite (platform-native)
- **Encryption**: Optional (SQLCipher or platform encryption)

**Tables**:
1. `quran_text` - Core Quran text
2. `translations` - Translation texts
3. `tafsir` - Tafsir texts (optional)
4. `azkar_items` - Azkar items
5. `azkar_categories` - Azkar categories
6. `reciters` - Reciter metadata
7. `bookmarks` - User bookmarks
8. `bookmark_folders` - Bookmark folders
9. `notes` - User notes
10. `highlights` - User highlights
11. `reminders` - Notification reminders
12. `user_preferences` - App settings
13. `last_read` - Last reading position
14. `download_manifests` - Download tracking
15. `azkar_progress` - Azkar session progress
16. `sync_metadata` - Cloud sync state (if enabled)

### File Storage

**Audio Files**
- **Location**: App documents directory / audio cache
- **Format**: MP3, M4A, or OGG
- **Organization**: By reciter ID / surah number
- **Management**: 
  - Automatic cleanup of unused files
  - Storage quota management
  - Background download support

**Content Packs**
- **Location**: App documents directory / packs
- **Format**: Compressed (ZIP, TAR.GZ) or custom format
- **Structure**:
  - Version manifest
  - Checksums
  - Content files (JSON, SQLite, etc.)
- **Management**:
  - Version tracking
  - Update mechanism
  - Rollback capability

**Cache Files**
- **Location**: Platform cache directory
- **Purpose**: Temporary files, images, etc.
- **Management**: Automatic cleanup by OS or manual cleanup

## Data Models

### Identifiers

**Ayah ID**
- **Format**: Stable identifier
- **Structure**: `{surahNumber}-{ayahNumber}` or UUID
- **Requirement**: Must remain stable across content updates
- **Example**: "2-255" (Surah 2, Ayah 255)

**User Content IDs**
- **Format**: UUID v4
- **Purpose**: Bookmarks, notes, highlights
- **Requirement**: Globally unique, stable after creation
- **Example**: "550e8400-e29b-41d4-a716-446655440000"

**Content Pack IDs**
- **Format**: Semantic version + pack type
- **Structure**: `{type}-{version}`
- **Example**: "quran-text-1.2.3", "translation-en-sahih-2.1.0"

### Database Schema (Core Tables)

**quran_text**
```sql
CREATE TABLE quran_text (
    ayah_id TEXT PRIMARY KEY,
    surah_number INTEGER NOT NULL,
    ayah_number INTEGER NOT NULL,
    text TEXT NOT NULL,
    page_number INTEGER,
    juz_number INTEGER,
    hizb_number INTEGER,
    rub_number INTEGER,
    ruku_number INTEGER,
    sajdah_marker INTEGER DEFAULT 0,
    bismillah INTEGER DEFAULT 0,
    meccan INTEGER DEFAULT 0,
    created_at INTEGER,
    updated_at INTEGER
);

CREATE INDEX idx_quran_surah_ayah ON quran_text(surah_number, ayah_number);
CREATE INDEX idx_quran_page ON quran_text(page_number);
CREATE INDEX idx_quran_juz ON quran_text(juz_number);
CREATE INDEX idx_quran_hizb ON quran_text(hizb_number);
```

**translations**
```sql
CREATE TABLE translations (
    translation_id TEXT PRIMARY KEY,
    language_code TEXT NOT NULL,
    translator_name TEXT NOT NULL,
    translator_id TEXT NOT NULL,
    version TEXT NOT NULL,
    ayah_id TEXT NOT NULL,
    text TEXT NOT NULL,
    copyright TEXT,
    source_url TEXT,
    created_at INTEGER,
    updated_at INTEGER,
    FOREIGN KEY (ayah_id) REFERENCES quran_text(ayah_id)
);

CREATE INDEX idx_translations_ayah ON translations(ayah_id);
CREATE INDEX idx_translations_translator ON translations(translator_id);
```

**bookmarks**
```sql
CREATE TABLE bookmarks (
    bookmark_id TEXT PRIMARY KEY,
    user_id TEXT,
    ayah_id TEXT NOT NULL,
    surah_number INTEGER NOT NULL,
    ayah_number INTEGER NOT NULL,
    folder_id TEXT,
    label TEXT,
    color TEXT,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    synced_at INTEGER,
    FOREIGN KEY (ayah_id) REFERENCES quran_text(ayah_id)
);

CREATE INDEX idx_bookmarks_user ON bookmarks(user_id);
CREATE INDEX idx_bookmarks_folder ON bookmarks(folder_id);
CREATE INDEX idx_bookmarks_ayah ON bookmarks(ayah_id);
```

**notes**
```sql
CREATE TABLE notes (
    note_id TEXT PRIMARY KEY,
    user_id TEXT,
    ayah_id TEXT NOT NULL,
    surah_number INTEGER NOT NULL,
    ayah_number INTEGER NOT NULL,
    text TEXT NOT NULL,
    is_encrypted INTEGER DEFAULT 0,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    synced_at INTEGER,
    FOREIGN KEY (ayah_id) REFERENCES quran_text(ayah_id)
);

CREATE INDEX idx_notes_user ON notes(user_id);
CREATE INDEX idx_notes_ayah ON notes(ayah_id);
```

**highlights**
```sql
CREATE TABLE highlights (
    highlight_id TEXT PRIMARY KEY,
    user_id TEXT,
    ayah_id TEXT NOT NULL,
    surah_number INTEGER NOT NULL,
    ayah_number INTEGER NOT NULL,
    color TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    synced_at INTEGER,
    FOREIGN KEY (ayah_id) REFERENCES quran_text(ayah_id)
);

CREATE INDEX idx_highlights_user ON highlights(user_id);
CREATE INDEX idx_highlights_ayah ON highlights(ayah_id);
CREATE INDEX idx_highlights_color ON highlights(color);
```

**azkar_items**
```sql
CREATE TABLE azkar_items (
    azkar_id TEXT PRIMARY KEY,
    category_id TEXT NOT NULL,
    arabic_text TEXT NOT NULL,
    transliteration TEXT,
    translation TEXT,
    source TEXT,
    reference TEXT,
    repeat_count INTEGER DEFAULT 1,
    virtues TEXT,
    time_tags TEXT, -- JSON array
    display_order INTEGER,
    is_favorite INTEGER DEFAULT 0,
    created_at INTEGER,
    updated_at INTEGER,
    FOREIGN KEY (category_id) REFERENCES azkar_categories(category_id)
);

CREATE INDEX idx_azkar_category ON azkar_items(category_id);
CREATE INDEX idx_azkar_time_tags ON azkar_items(time_tags);
```

**reminders**
```sql
CREATE TABLE reminders (
    reminder_id TEXT PRIMARY KEY,
    user_id TEXT,
    category_id TEXT,
    azkar_id TEXT,
    type TEXT NOT NULL,
    time TEXT NOT NULL,
    time_window INTEGER,
    days_of_week TEXT, -- JSON array
    enabled INTEGER DEFAULT 1,
    notification_content TEXT,
    snooze_rules TEXT, -- JSON object
    timezone TEXT,
    last_triggered INTEGER,
    created_at INTEGER,
    updated_at INTEGER
);

CREATE INDEX idx_reminders_user ON reminders(user_id);
CREATE INDEX idx_reminders_enabled ON reminders(enabled);
```

**download_manifests**
```sql
CREATE TABLE download_manifests (
    download_id TEXT PRIMARY KEY,
    reciter_id TEXT NOT NULL,
    type TEXT NOT NULL,
    surah_numbers TEXT, -- JSON array
    juz_numbers TEXT, -- JSON array
    status TEXT NOT NULL,
    progress REAL DEFAULT 0.0,
    total_bytes INTEGER,
    downloaded_bytes INTEGER,
    error_message TEXT,
    created_at INTEGER NOT NULL,
    completed_at INTEGER
);

CREATE INDEX idx_downloads_reciter ON download_manifests(reciter_id);
CREATE INDEX idx_downloads_status ON download_manifests(status);
```

## Storage Requirements

### Content Pack Sizes (Estimated)

**Quran Text Pack**
- Arabic text only: ~2-5 MB
- With metadata: ~5-10 MB
- Compressed: ~1-3 MB

**Translation Pack (per language)**
- English (Sahih International): ~3-5 MB
- Compressed: ~1-2 MB
- Multiple translations: Multiply accordingly

**Azkar Pack**
- Full azkar library: ~1-2 MB
- Compressed: ~500 KB - 1 MB

**Audio (per reciter, per surah)**
- 128 kbps MP3: ~1-3 MB per surah
- Full Quran: ~300-600 MB per reciter
- Multiple reciters: Multiply accordingly

### User Data Sizes

**Bookmarks**
- ~100 bytes per bookmark
- 1000 bookmarks: ~100 KB

**Notes**
- Variable (text length)
- Average: ~500 bytes per note
- 100 notes: ~50 KB

**Highlights**
- ~50 bytes per highlight
- 500 highlights: ~25 KB

**Total User Data**
- Typical user: < 1 MB
- Heavy user: < 5 MB

## Migration Requirements

### Schema Versioning

**Version Tracking**
- Store schema version in database
- Increment on each schema change
- Migration scripts for each version

**Migration Strategy**
- Forward-only migrations
- Test migrations on all supported versions
- Rollback plan (data backup)

### Migration Process

**On App Launch**
1. Check current schema version
2. Compare with target version
3. Run migrations in order
4. Update schema version
5. Verify migration success

**Migration Failure Handling**
- Detect migration failure
- Offer safe mode (rebuild indices)
- Backup user data before migration
- Recovery options

### Example Migration

**Version 1 → 2: Add translation support**
```sql
-- Migration script
BEGIN TRANSACTION;

-- Add new table
CREATE TABLE translations (...);

-- Add index
CREATE INDEX idx_translations_ayah ON translations(ayah_id);

-- Update schema version
UPDATE schema_version SET version = 2;

COMMIT;
```

**Version 2 → 3: Add cloud sync**
```sql
BEGIN TRANSACTION;

-- Add sync columns
ALTER TABLE bookmarks ADD COLUMN synced_at INTEGER;
ALTER TABLE notes ADD COLUMN synced_at INTEGER;
ALTER TABLE highlights ADD COLUMN synced_at INTEGER;

-- Add sync metadata table
CREATE TABLE sync_metadata (...);

-- Update schema version
UPDATE schema_version SET version = 3;

COMMIT;
```

## Data Integrity

### Validation

**Content Validation**
- Verify checksums on download
- Validate data structure
- Check referential integrity
- Validate data ranges

**User Data Validation**
- Validate ayah references
- Check data types
- Enforce constraints
- Sanitize input

### Backup & Recovery

**Automatic Backups**
- Platform backup integration (iCloud/Google Drive)
- Local backup option
- Export user data (JSON/PDF)

**Recovery**
- Restore from backup
- Import from export
- Manual recovery options

## Performance Optimization

### Indexing

**Required Indexes**
- Primary keys (automatic)
- Foreign keys
- Frequently queried columns
- Search columns

**Index Maintenance**
- Analyze query patterns
- Add indexes for slow queries
- Remove unused indexes
- Rebuild indexes periodically

### Query Optimization

**Efficient Queries**
- Use prepared statements
- Limit result sets
- Use pagination
- Avoid N+1 queries

**Caching**
- Cache frequently accessed data
- Invalidate cache appropriately
- Memory-efficient caching
- Disk caching for large data

### Storage Optimization

**Compression**
- Compress content packs
- Compress audio (appropriate bitrate)
- Compress database backups

**Cleanup**
- Remove unused downloads
- Clear old cache
- Compact database
- Remove orphaned data

## Security

### Encryption

**At-Rest Encryption**
- Encrypt sensitive user data (notes)
- Use platform keychain/keystore
- Encrypt database (optional, SQLCipher)

**Key Management**
- Store keys in keychain/keystore
- Never hardcode keys
- Rotate keys if compromised

### Access Control

**File Permissions**
- Restrict file access
- Use app sandbox
- Secure temporary files

**Database Access**
- Parameterized queries (prevent SQL injection)
- Validate all inputs
- Limit database permissions

## Cloud Sync Storage (If Enabled)

### Sync Data Structure

**Sync Payload**
- User content (bookmarks, notes, highlights)
- Metadata (timestamps, versions)
- Conflict markers

**Sync Storage**
- Cloud database (Firebase, AWS, etc.)
- Encrypted in transit and at rest
- User-specific partitions
- Efficient sync protocol

### Conflict Resolution Storage

**Conflict Markers**
- Store conflict information
- Resolution history
- Merge strategies

**Version Vectors**
- Track versions per item
- Detect conflicts
- Resolve automatically or manually

