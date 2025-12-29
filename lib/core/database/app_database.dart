import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_azkar_app/core/database/database_platform.dart';
import 'package:quran_azkar_app/core/database/database_interface.dart';
import 'package:quran_azkar_app/core/database/web_database.dart';
import 'package:quran_azkar_app/core/database/mobile_database_adapter.dart';

class AppDatabase {
  static const String _databaseName = 'quran_azkar.db';
  static const int _databaseVersion = 1;
  
  static Database? _database;
  static DatabaseInterface? _webDatabase;
  
  /// Get database instance (works on both mobile and web)
  static Future<DatabaseInterface> get instance async {
    if (PlatformInfo.isWeb) {
      if (_webDatabase == null) {
        _webDatabase = WebDatabase();
        await _webDatabase!.initialize();
        await _initializeWebDatabase(_webDatabase!);
      }
      return _webDatabase!;
    } else {
      // Mobile: return SQLite database wrapped in adapter
      if (_database == null) {
        _database = await _initDatabase();
      }
      return MobileDatabaseAdapter(_database!);
    }
  }
  
  /// Get raw SQLite database (mobile only)
  static Future<Database> get sqliteInstance async {
    if (PlatformInfo.isWeb) {
      throw UnsupportedError('SQLite not available on web. Use instance instead.');
    }
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  static Future<void> _initializeWebDatabase(DatabaseInterface db) async {
    // Create tables on web database
    await _onCreateWeb(db);
  }
  
  static Future<void> _onCreateWeb(DatabaseInterface db) async {
    // Create all tables using the interface
    await db.execute('''
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
      )
    ''');
    
    // Create other tables...
    // (Same as _onCreate but using db.execute)
    await _createAllTablesWeb(db);
  }
  
  static Future<void> _createAllTablesWeb(DatabaseInterface db) async {
    // Translations
    await db.execute('''
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
        updated_at INTEGER
      )
    ''');
    
    // Bookmarks
    await db.execute('''
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
        synced_at INTEGER
      )
    ''');
    
    // Bookmark folders
    await db.execute('''
      CREATE TABLE bookmark_folders (
        folder_id TEXT PRIMARY KEY,
        user_id TEXT,
        name TEXT NOT NULL,
        color TEXT,
        icon TEXT,
        display_order INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        synced_at INTEGER
      )
    ''');
    
    // Notes
    await db.execute('''
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
        synced_at INTEGER
      )
    ''');
    
    // Highlights
    await db.execute('''
      CREATE TABLE highlights (
        highlight_id TEXT PRIMARY KEY,
        user_id TEXT,
        ayah_id TEXT NOT NULL,
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        color TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        synced_at INTEGER
      )
    ''');
    
    // Azkar categories
    await db.execute('''
      CREATE TABLE azkar_categories (
        category_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        name_transliterated TEXT,
        description TEXT,
        icon TEXT,
        color TEXT,
        time_tags TEXT,
        display_order INTEGER,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
    
    // Azkar items
    await db.execute('''
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
        time_tags TEXT,
        display_order INTEGER,
        is_favorite INTEGER DEFAULT 0,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
    
    // Reminders
    await db.execute('''
      CREATE TABLE reminders (
        reminder_id TEXT PRIMARY KEY,
        user_id TEXT,
        category_id TEXT,
        azkar_id TEXT,
        type TEXT NOT NULL,
        time TEXT NOT NULL,
        time_window INTEGER,
        days_of_week TEXT,
        enabled INTEGER DEFAULT 1,
        notification_content TEXT,
        snooze_rules TEXT,
        timezone TEXT,
        last_triggered INTEGER,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
    
    // Reciters
    await db.execute('''
      CREATE TABLE reciters (
        reciter_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        name_transliterated TEXT,
        style TEXT,
        language TEXT,
        bitrate_options TEXT,
        default_bitrate INTEGER,
        audio_url_pattern TEXT,
        thumbnail_url TEXT,
        description TEXT,
        is_default INTEGER DEFAULT 0,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
    
    // Download manifests
    await db.execute('''
      CREATE TABLE download_manifests (
        download_id TEXT PRIMARY KEY,
        reciter_id TEXT NOT NULL,
        type TEXT NOT NULL,
        surah_numbers TEXT,
        juz_numbers TEXT,
        status TEXT NOT NULL,
        progress REAL DEFAULT 0.0,
        total_bytes INTEGER,
        downloaded_bytes INTEGER,
        error_message TEXT,
        created_at INTEGER NOT NULL,
        completed_at INTEGER
      )
    ''');
    
    // Azkar progress
    await db.execute('''
      CREATE TABLE azkar_progress (
        progress_id TEXT PRIMARY KEY,
        user_id TEXT,
        category_id TEXT NOT NULL,
        session_date TEXT NOT NULL,
        items_completed INTEGER DEFAULT 0,
        total_items INTEGER,
        time_spent INTEGER,
        streak_days INTEGER DEFAULT 0,
        last_completed_at INTEGER,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
  }
  
  static Future<void> _onCreate(Database db, int version) async {
    // Quran text table
    await db.execute('''
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
      )
    ''');
    
    // Indexes for quran_text
    await db.execute('CREATE INDEX idx_quran_surah_ayah ON quran_text(surah_number, ayah_number)');
    await db.execute('CREATE INDEX idx_quran_page ON quran_text(page_number)');
    await db.execute('CREATE INDEX idx_quran_juz ON quran_text(juz_number)');
    await db.execute('CREATE INDEX idx_quran_hizb ON quran_text(hizb_number)');
    
    // Translations table
    await db.execute('''
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
      )
    ''');
    
    await db.execute('CREATE INDEX idx_translations_ayah ON translations(ayah_id)');
    await db.execute('CREATE INDEX idx_translations_translator ON translations(translator_id)');
    
    // Bookmarks table
    await db.execute('''
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
      )
    ''');
    
    await db.execute('CREATE INDEX idx_bookmarks_user ON bookmarks(user_id)');
    await db.execute('CREATE INDEX idx_bookmarks_folder ON bookmarks(folder_id)');
    await db.execute('CREATE INDEX idx_bookmarks_ayah ON bookmarks(ayah_id)');
    
    // Bookmark folders table
    await db.execute('''
      CREATE TABLE bookmark_folders (
        folder_id TEXT PRIMARY KEY,
        user_id TEXT,
        name TEXT NOT NULL,
        color TEXT,
        icon TEXT,
        display_order INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        synced_at INTEGER
      )
    ''');
    
    // Notes table
    await db.execute('''
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
      )
    ''');
    
    await db.execute('CREATE INDEX idx_notes_user ON notes(user_id)');
    await db.execute('CREATE INDEX idx_notes_ayah ON notes(ayah_id)');
    
    // Highlights table
    await db.execute('''
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
      )
    ''');
    
    await db.execute('CREATE INDEX idx_highlights_user ON highlights(user_id)');
    await db.execute('CREATE INDEX idx_highlights_ayah ON highlights(ayah_id)');
    await db.execute('CREATE INDEX idx_highlights_color ON highlights(color)');
    
    // Azkar categories table
    await db.execute('''
      CREATE TABLE azkar_categories (
        category_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        name_transliterated TEXT,
        description TEXT,
        icon TEXT,
        color TEXT,
        time_tags TEXT,
        display_order INTEGER,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
    
    // Azkar items table
    await db.execute('''
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
        time_tags TEXT,
        display_order INTEGER,
        is_favorite INTEGER DEFAULT 0,
        created_at INTEGER,
        updated_at INTEGER,
        FOREIGN KEY (category_id) REFERENCES azkar_categories(category_id)
      )
    ''');
    
    await db.execute('CREATE INDEX idx_azkar_category ON azkar_items(category_id)');
    
    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        reminder_id TEXT PRIMARY KEY,
        user_id TEXT,
        category_id TEXT,
        azkar_id TEXT,
        type TEXT NOT NULL,
        time TEXT NOT NULL,
        time_window INTEGER,
        days_of_week TEXT,
        enabled INTEGER DEFAULT 1,
        notification_content TEXT,
        snooze_rules TEXT,
        timezone TEXT,
        last_triggered INTEGER,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
    
    await db.execute('CREATE INDEX idx_reminders_user ON reminders(user_id)');
    await db.execute('CREATE INDEX idx_reminders_enabled ON reminders(enabled)');
    
    // Reciters table
    await db.execute('''
      CREATE TABLE reciters (
        reciter_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        name_transliterated TEXT,
        style TEXT,
        language TEXT,
        bitrate_options TEXT,
        default_bitrate INTEGER,
        audio_url_pattern TEXT,
        thumbnail_url TEXT,
        description TEXT,
        is_default INTEGER DEFAULT 0,
        created_at INTEGER,
        updated_at INTEGER
      )
    ''');
    
    // Download manifests table
    await db.execute('''
      CREATE TABLE download_manifests (
        download_id TEXT PRIMARY KEY,
        reciter_id TEXT NOT NULL,
        type TEXT NOT NULL,
        surah_numbers TEXT,
        juz_numbers TEXT,
        status TEXT NOT NULL,
        progress REAL DEFAULT 0.0,
        total_bytes INTEGER,
        downloaded_bytes INTEGER,
        error_message TEXT,
        created_at INTEGER NOT NULL,
        completed_at INTEGER,
        FOREIGN KEY (reciter_id) REFERENCES reciters(reciter_id)
      )
    ''');
    
    await db.execute('CREATE INDEX idx_downloads_reciter ON download_manifests(reciter_id)');
    await db.execute('CREATE INDEX idx_downloads_status ON download_manifests(status)');
    
    // Azkar progress table
    await db.execute('''
      CREATE TABLE azkar_progress (
        progress_id TEXT PRIMARY KEY,
        user_id TEXT,
        category_id TEXT NOT NULL,
        session_date TEXT NOT NULL,
        items_completed INTEGER DEFAULT 0,
        total_items INTEGER,
        time_spent INTEGER,
        streak_days INTEGER DEFAULT 0,
        last_completed_at INTEGER,
        created_at INTEGER,
        updated_at INTEGER,
        FOREIGN KEY (category_id) REFERENCES azkar_categories(category_id)
      )
    ''');
    
    await db.execute('CREATE INDEX idx_azkar_progress_user ON azkar_progress(user_id)');
    await db.execute('CREATE INDEX idx_azkar_progress_category ON azkar_progress(category_id)');
    await db.execute('CREATE INDEX idx_azkar_progress_date ON azkar_progress(session_date)');
  }
  
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE ...');
    // }
  }
  
  static Future<void> close() async {
    if (PlatformInfo.isWeb) {
      if (_webDatabase != null) {
        await _webDatabase!.close();
        _webDatabase = null;
      }
    } else {
      final db = _database;
      if (db != null) {
        await db.close();
        _database = null;
      }
    }
  }
}

