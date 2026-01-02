import 'dart:convert';
import 'dart:io';

/// Script to fetch full Quran data from API and format it for the app
/// Run with: dart scripts/fetch_quran_data.dart

Future<void> main() async {
  print('Fetching full Quran data...');
  
  try {
    // Using Al-Quran Cloud API (free, no auth required)
    final client = HttpClient();
    
    // Fetch all surahs metadata
    final surahsRequest = await client.getUrl(
      Uri.parse('https://api.alquran.cloud/v1/meta'),
    );
    final surahsResponse = await surahsRequest.close();
    final surahsBody = await surahsResponse.transform(utf8.decoder).join();
    final surahsData = jsonDecode(surahsBody) as Map<String, dynamic>;
    
    print('Fetched surah metadata');
    
    // Fetch all ayahs for all surahs
    final allAyahs = <Map<String, dynamic>>[];
    
    final surahs = surahsData['data']['surahs']['references'] as List;
    print('Found ${surahs.length} surahs');
    
    for (var i = 0; i < surahs.length; i++) {
      final surah = surahs[i] as Map<String, dynamic>;
      final surahNumber = surah['number'] as int;
      
      print('Fetching surah $surahNumber...');
      
      // Fetch surah with Arabic text
      final ayahsRequest = await client.getUrl(
        Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber'),
      );
      final ayahsResponse = await ayahsRequest.close();
      final ayahsBody = await ayahsResponse.transform(utf8.decoder).join();
      final ayahsData = jsonDecode(ayahsBody) as Map<String, dynamic>;
      
      final ayahs = ayahsData['data']['ayahs'] as List;
      
      for (var ayahData in ayahs) {
        final ayah = ayahData as Map<String, dynamic>;
        final ayahNumber = ayah['numberInSurah'] as int;
        final text = ayah['text'] as String;
        final juz = ayah['juz'] as int?;
        final page = ayah['page'] as int?;
        
        // Determine if Meccan (surah number <= 114, but most early ones are Meccan)
        final isMeccan = surahNumber <= 96; // Roughly, most Meccan surahs are 1-96
        
        allAyahs.add({
          'ayah_id': '$surahNumber-$ayahNumber',
          'surah_number': surahNumber,
          'ayah_number': ayahNumber,
          'text': text,
          'page_number': page,
          'juz_number': juz,
          'hizb_number': null,
          'rub_number': null,
          'ruku_number': null,
          'sajdah_marker': 0,
          'bismillah': ayahNumber == 1 ? 1 : 0,
          'meccan': isMeccan ? 1 : 0,
        });
      }
      
      // Small delay to avoid rate limiting
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    // Save to JSON file
    final output = {
      'ayahs': allAyahs,
      'metadata': {
        'total_ayahs': allAyahs.length,
        'total_surahs': surahs.length,
        'fetched_at': DateTime.now().toIso8601String(),
        'source': 'Al-Quran Cloud API',
      }
    };
    
    final jsonFile = File('assets/data/quran_text.json');
    await jsonFile.create(recursive: true);
    await jsonFile.writeAsString(
      JsonEncoder.withIndent('  ').convert(output),
    );
    
    print('\n✅ Successfully fetched ${allAyahs.length} ayahs from ${surahs.length} surahs');
    print('📄 Saved to: ${jsonFile.path}');
    print('\n⚠️  Note: This uses approximate Meccan/Medinan classification.');
    print('   For accurate classification, you may need to update manually.');
    
  } catch (e, stack) {
    print('Error fetching Quran data: $e');
    print('Stack trace: $stack');
    exit(1);
  }
}

