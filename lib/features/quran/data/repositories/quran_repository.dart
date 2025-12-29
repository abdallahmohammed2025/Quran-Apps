import 'package:quran_azkar_app/core/database/database_interface.dart';
import 'package:quran_azkar_app/shared/models/quran_models.dart';

abstract class QuranRepository {
  Future<List<QuranText>> getSurah(int surahNumber);
  Future<QuranText?> getAyah(int surahNumber, int ayahNumber);
  Future<List<QuranText>> getAyahsByPage(int pageNumber);
  Future<List<QuranText>> getAyahsByJuz(int juzNumber);
  Future<List<Surah>> getAllSurahs();
  Future<void> insertQuranText(QuranText ayah);
  Future<void> insertQuranTexts(List<QuranText> ayahs);
}

class QuranRepositoryImpl implements QuranRepository {
  final DatabaseInterface _database;

  QuranRepositoryImpl(this._database);

  @override
  Future<List<QuranText>> getSurah(int surahNumber) async {
    final maps = await _database.query(
      'quran_text',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'ayah_number ASC',
    );
    return maps.map((map) => QuranText.fromMap(map)).toList();
  }

  @override
  Future<QuranText?> getAyah(int surahNumber, int ayahNumber) async {
    final maps = await _database.query(
      'quran_text',
      where: 'surah_number = ? AND ayah_number = ?',
      whereArgs: [surahNumber, ayahNumber],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return QuranText.fromMap(maps.first);
  }

  @override
  Future<List<QuranText>> getAyahsByPage(int pageNumber) async {
    final maps = await _database.query(
      'quran_text',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'surah_number ASC, ayah_number ASC',
    );
    return maps.map((map) => QuranText.fromMap(map)).toList();
  }

  @override
  Future<List<QuranText>> getAyahsByJuz(int juzNumber) async {
    final maps = await _database.query(
      'quran_text',
      where: 'juz_number = ?',
      whereArgs: [juzNumber],
      orderBy: 'surah_number ASC, ayah_number ASC',
    );
    return maps.map((map) => QuranText.fromMap(map)).toList();
  }

  @override
  Future<List<Surah>> getAllSurahs() async {
    // This would typically come from a separate surahs table
    // For now, we'll query distinct surahs from quran_text
    final maps = await _database.rawQuery('''
      SELECT DISTINCT 
        surah_number,
        COUNT(*) as ayah_count
      FROM quran_text
      GROUP BY surah_number
      ORDER BY surah_number ASC
    ''');
    
    // This is a simplified version - in production, you'd have a surahs table
    // with names, transliterations, etc.
    return maps.map((map) {
      return Surah(
        number: map['surah_number'] as int,
        nameArabic: _getSurahNameArabic(map['surah_number'] as int),
        nameTransliterated: _getSurahNameTransliterated(map['surah_number'] as int),
        nameEnglish: _getSurahNameEnglish(map['surah_number'] as int),
        ayahCount: map['ayah_count'] as int,
      );
    }).toList();
  }

  @override
  Future<void> insertQuranText(QuranText ayah) async {
    await _database.insert(
      'quran_text',
      ayah.toMap(),
      conflictAlgorithm: 'replace',
    );
  }

  @override
  Future<void> insertQuranTexts(List<QuranText> ayahs) async {
    final values = ayahs.map((ayah) => ayah.toMap()).toList();
    await _database.batchInsert(
      'quran_text',
      values,
      conflictAlgorithm: 'replace',
    );
  }

  // Helper methods for surah names (simplified - should come from database)
  String _getSurahNameArabic(int surahNumber) {
    // This should be loaded from database or assets
    const names = {
      1: 'الفاتحة',
      2: 'البقرة',
      3: 'آل عمران',
      // ... add all 114 surahs
    };
    return names[surahNumber] ?? 'Surah $surahNumber';
  }

  String _getSurahNameTransliterated(int surahNumber) {
    const names = {
      1: 'Al-Fatiha',
      2: 'Al-Baqarah',
      3: 'Ali Imran',
      // ... add all 114 surahs
    };
    return names[surahNumber] ?? 'Surah $surahNumber';
  }

  String _getSurahNameEnglish(int surahNumber) {
    const names = {
      1: 'The Opening',
      2: 'The Cow',
      3: 'Family of Imran',
      // ... add all 114 surahs
    };
    return names[surahNumber] ?? 'Surah $surahNumber';
  }
}

