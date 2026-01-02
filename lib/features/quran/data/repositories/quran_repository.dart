import 'package:quran_azkar_app/core/database/database_interface.dart';
import 'package:quran_azkar_app/features/quran/data/surah_metadata.dart';
import 'package:quran_azkar_app/features/quran/data/surah_names.dart';
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
    // Query all ayahs and group by surah_number in Dart
    // This works on both SQLite and Web database
    final maps = await _database.query(
      'quran_text',
      columns: ['surah_number'],
      orderBy: 'surah_number ASC',
    );
    
    // Count ayahs per surah
    final surahCounts = <int, int>{};
    for (final map in maps) {
      final surahNumber = (map['surah_number'] as num?)?.toInt();
      if (surahNumber != null) {
        surahCounts[surahNumber] = (surahCounts[surahNumber] ?? 0) + 1;
      }
    }
    
    // Build Surah list
    return surahCounts.entries.map((entry) {
      final surahNumber = entry.key;
      final ayahCount = entry.value;
      
      return Surah(
        number: surahNumber,
        nameArabic: SurahNames.getArabic(surahNumber),
        nameTransliterated: SurahNames.getTransliterated(surahNumber),
        nameEnglish: SurahNames.getEnglish(surahNumber),
        ayahCount: ayahCount,
        meccan: SurahMetadata.isMeccan(surahNumber),
      );
    }).toList()..sort((a, b) => a.number.compareTo(b.number));
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

}

