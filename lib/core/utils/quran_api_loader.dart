import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/features/quran/data/repositories/quran_repository.dart';
import 'package:quran_azkar_app/shared/models/quran_models.dart';

/// Loads full Quran data from API
/// Uses Al-Quran Cloud API (free, reliable)
class QuranApiLoader {
  static const String apiBaseUrl = 'https://api.alquran.cloud/v1';
  
  /// Load full Quran from API
  /// This fetches all 114 surahs with all ~6,236 ayahs
  /// Uses Al-Quran Cloud API which is free and reliable
  static Future<void> loadFullQuran() async {
    try {
      final database = await AppDatabase.instance;
      final repository = QuranRepositoryImpl(database);
      
      // Check if we already have full content
      final existing = await repository.getAllSurahs();
      if (existing.length >= 100) {
        debugPrint('Full Quran already loaded (${existing.length} surahs)');
        return;
      }
      
      // Use the API method which is more reliable
      await loadFullQuranFromAPI();
    } catch (e, stackTrace) {
      debugPrint('Error loading full Quran: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
  
  /// Load from Al-Quran Cloud API
  /// This is the main method that fetches all surahs one by one
  static Future<void> loadFullQuranFromAPI() async {
    try {
      final database = await AppDatabase.instance;
      final repository = QuranRepositoryImpl(database);
      
      debugPrint('Fetching full Quran from API (this may take a few minutes)...');
      final allAyahs = <QuranText>[];
      
      // Fetch all 114 surahs
      for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
        debugPrint('Fetching surah $surahNumber/114...');
        
        try {
          final url = Uri.parse('$apiBaseUrl/surah/$surahNumber');
          final response = await http.get(url);
          
          if (response.statusCode != 200) {
            debugPrint('Failed to fetch surah $surahNumber: ${response.statusCode}');
            continue;
          }
          
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final surahData = data['data'] as Map<String, dynamic>;
          final ayahsData = surahData['ayahs'] as List;
          final surahInfo = surahData['surah'] as Map<String, dynamic>?;
          final isMeccan = surahInfo?['revelationType'] == 'meccan';
          
          for (var ayahData in ayahsData) {
            final ayah = ayahData as Map<String, dynamic>;
            final ayahNumber = ayah['numberInSurah'] as int;
            final text = ayah['text'] as String;
            final juz = ayah['juz'] as int?;
            final page = ayah['page'] as int?;
            
            allAyahs.add(QuranText(
              ayahId: '$surahNumber-$ayahNumber',
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
              text: text,
              pageNumber: page,
              juzNumber: juz,
              bismillah: ayahNumber == 1,
              meccan: isMeccan,
            ));
          }
          
          // Small delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 300));
        } catch (e) {
          debugPrint('Error fetching surah $surahNumber: $e');
          // Continue with next surah
        }
      }
      
      if (allAyahs.isNotEmpty) {
        debugPrint('Inserting ${allAyahs.length} ayahs into database...');
        await repository.insertQuranTexts(allAyahs);
        debugPrint('✅ Full Quran loaded successfully!');
      }
    } catch (e) {
      debugPrint('Error loading full Quran from API: $e');
      rethrow;
    }
  }
  
  /// Check if we have full Quran content
  static Future<bool> hasFullQuran() async {
    try {
      final database = await AppDatabase.instance;
      final repository = QuranRepositoryImpl(database);
      final surahs = await repository.getAllSurahs();
      return surahs.length >= 100; // Assume 100+ surahs means we have full content
    } catch (e) {
      return false;
    }
  }
}
