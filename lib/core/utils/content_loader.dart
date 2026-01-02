import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/features/quran/data/repositories/quran_repository.dart';
import 'package:quran_azkar_app/shared/models/quran_models.dart';
import 'package:quran_azkar_app/shared/models/azkar_models.dart';
import 'package:quran_azkar_app/core/utils/comprehensive_quran_data.dart';
import 'package:quran_azkar_app/core/utils/quran_api_loader.dart';

/// Content loader for Quran and Azkar data
/// Loads from JSON files in assets/data/
class ContentLoader {
  static Future<void> loadAllContent() async {
    await loadQuranContent();
    await loadAzkarContent();
  }

  /// Load Quran content from JSON or API
  static Future<void> loadQuranContent() async {
    try {
      // First, check if we already have full content
      final database = await AppDatabase.instance;
      final repository = QuranRepositoryImpl(database);
      final existing = await repository.getAllSurahs();
      
      // If we have 100+ surahs, assume we have full content
      if (existing.length >= 100) {
        debugPrint('Full Quran already loaded (${existing.length} surahs)');
        return;
      }
      
      // Try loading from JSON file first
      try {
        final jsonString = await rootBundle.loadString('assets/data/quran_text.json');
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final ayahs = (jsonData['ayahs'] as List)
            .map((item) => QuranText.fromJson(item as Map<String, dynamic>))
            .toList();

        await repository.insertQuranTexts(ayahs);
        debugPrint('Loaded Quran from JSON (${ayahs.length} ayahs)');
        return;
      } catch (e) {
        debugPrint('Quran JSON not found: $e');
      }
      
      // If JSON not found and we don't have full content, try API
      // Changed threshold to 114 to always try to complete the Quran if we have less than 114 surahs
      if (existing.isEmpty || existing.length < 114) {
        debugPrint('Attempting to load full Quran from API (current: ${existing.length} surahs, need 114)...');
        try {
          await _loadFullQuranFromAPI(repository);
          return;
        } catch (e) {
          debugPrint('API load failed: $e');
          // Continue to fallback sample data if we don't have any data
          if (existing.isEmpty) {
            debugPrint('No existing data, loading sample data');
          } else {
            debugPrint('Keeping existing ${existing.length} surahs, API load failed');
            return; // Keep existing data, don't load sample
          }
        }
      }
      
      // Fallback to sample data
      debugPrint('Loading sample Quran data');
      await _loadSampleQuranData();
    } catch (e) {
      debugPrint('Error loading Quran content: $e');
      // Last resort: load sample data
      await _loadSampleQuranData();
    }
  }
  
  /// Load full Quran from API
  static Future<void> _loadFullQuranFromAPI(QuranRepository repository) async {
    await QuranApiLoader.loadFullQuran();
  }

  /// Load Azkar content from JSON
  static Future<void> loadAzkarContent() async {
    try {
      // Load categories
      final categoriesJson = await rootBundle.loadString('assets/data/azkar_categories.json');
      final categoriesData = jsonDecode(categoriesJson) as List;
      
      // Load items
      final itemsJson = await rootBundle.loadString('assets/data/azkar_items.json');
      final itemsData = jsonDecode(itemsJson) as List;

      final database = await AppDatabase.instance;
      
      // Insert categories
      for (final catData in categoriesData) {
        final category = AzkarCategory.fromJson(catData as Map<String, dynamic>);
        await database.insert('azkar_categories', category.toMap());
      }

      // Insert items
      for (final itemData in itemsData) {
        final item = AzkarItem.fromJson(itemData as Map<String, dynamic>);
        await database.insert('azkar_items', item.toMap());
      }
    } catch (e) {
      // If files don't exist, load sample data
      debugPrint('Azkar JSON not found, loading sample data: $e');
      await _loadSampleAzkarData();
    }
  }

  /// Fallback: Load sample Quran data (if JSON not available)
  static Future<void> _loadSampleQuranData() async {
    final database = await AppDatabase.instance;
    final repository = QuranRepositoryImpl(database);
    
    // Check if data already exists
    final existing = await repository.getAllSurahs();
    if (existing.isNotEmpty) return;

    // Load comprehensive sample data
    await _loadComprehensiveQuranSamples(repository);
  }

  /// Fallback: Load sample Azkar data
  static Future<void> _loadSampleAzkarData() async {
    final database = await AppDatabase.instance;
    
    // Check if data exists
    final existing = await database.query('azkar_categories');
    if (existing.isNotEmpty) return;

    await _loadComprehensiveAzkarSamples(database);
  }

  /// Load comprehensive Quran samples (multiple surahs)
  static Future<void> _loadComprehensiveQuranSamples(QuranRepository repository) async {
    // Import comprehensive data
    final ayahs = ComprehensiveQuranData.getAllAyahs();
    
    await repository.insertQuranTexts(ayahs);
  }

  /// Load comprehensive Azkar samples
  static Future<void> _loadComprehensiveAzkarSamples(dynamic database) async {
    // Categories
    final categories = _getAzkarCategories();
    for (final category in categories) {
      await database.insert('azkar_categories', category.toMap());
    }

    // Items
    final items = _getAzkarItems();
    for (final item in items) {
      await database.insert('azkar_items', item.toMap());
    }
  }

  static List<AzkarCategory> _getAzkarCategories() {
    return [
      AzkarCategory(
        categoryId: 'morning',
        name: 'أذكار الصباح',
        nameTransliterated: 'Morning Azkar',
        description: 'Morning remembrances and supplications',
        icon: 'sun',
        color: '#FFA500',
        timeTags: ['morning'],
        displayOrder: 1,
      ),
      AzkarCategory(
        categoryId: 'evening',
        name: 'أذكار المساء',
        nameTransliterated: 'Evening Azkar',
        description: 'Evening remembrances and supplications',
        icon: 'moon',
        color: '#4A90E2',
        timeTags: ['evening'],
        displayOrder: 2,
      ),
      AzkarCategory(
        categoryId: 'after-prayer',
        name: 'أذكار بعد الصلاة',
        nameTransliterated: 'After Prayer',
        description: 'Remembrances after each prayer',
        icon: 'prayer',
        color: '#2E7D32',
        timeTags: ['after-prayer'],
        displayOrder: 3,
      ),
      AzkarCategory(
        categoryId: 'sleep',
        name: 'أذكار النوم',
        nameTransliterated: 'Before Sleep',
        description: 'Remembrances before sleeping',
        icon: 'bed',
        color: '#7B68EE',
        timeTags: ['sleep'],
        displayOrder: 4,
      ),
      AzkarCategory(
        categoryId: 'wake-up',
        name: 'أذكار الاستيقاظ',
        nameTransliterated: 'Upon Waking',
        description: 'Remembrances upon waking up',
        icon: 'alarm',
        color: '#FF6B6B',
        timeTags: ['wake-up'],
        displayOrder: 5,
      ),
      AzkarCategory(
        categoryId: 'protection',
        name: 'أذكار الحماية',
        nameTransliterated: 'Protection',
        description: 'Supplications for protection',
        icon: 'shield',
        color: '#E74C3C',
        timeTags: ['protection'],
        displayOrder: 6,
      ),
      AzkarCategory(
        categoryId: 'gratitude',
        name: 'أذكار الشكر',
        nameTransliterated: 'Gratitude',
        description: 'Remembrances of gratitude',
        icon: 'heart',
        color: '#27AE60',
        timeTags: ['gratitude'],
        displayOrder: 7,
      ),
      AzkarCategory(
        categoryId: 'general',
        name: 'أذكار عامة',
        nameTransliterated: 'General Duas',
        description: 'General supplications and remembrances',
        icon: 'book',
        color: '#9B59B6',
        timeTags: [],
        displayOrder: 8,
      ),
    ];
  }

  static List<AzkarItem> _getAzkarItems() {
    return [
      // Morning Azkar
      AzkarItem(
        azkarId: 'morning-1',
        categoryId: 'morning',
        arabicText: 'أَعُوذُ بِاللهِ مِنْ الشَّيْطَانِ الرَّجِيمِ',
        transliteration: 'A\'oodhu billaahi minash-shaytaanir-rajeem',
        translation: 'I seek refuge in Allah from Satan, the accursed',
        source: 'Quran',
        reference: 'Surah An-Nahl, Ayah 98',
        repeatCount: 1,
        displayOrder: 1,
      ),
      AzkarItem(
        azkarId: 'morning-2',
        categoryId: 'morning',
        arabicText: 'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
        transliteration: 'Allahumma bika asbahna wa bika amsayna, wa bika nahya, wa bika namootu, wa ilaykan-nushoor',
        translation: 'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the return',
        source: 'Sunan At-Tirmidhi',
        reference: 'Hadith 3391',
        repeatCount: 1,
        displayOrder: 2,
      ),
      AzkarItem(
        azkarId: 'morning-3',
        categoryId: 'morning',
        arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        transliteration: 'Subhanallahi wa bihamdihi',
        translation: 'Glory is to Allah and praise is to Him',
        source: 'Sahih Muslim',
        reference: 'Hadith 2691',
        repeatCount: 100,
        virtues: 'Whoever says this 100 times in the morning, his sins will be forgiven even if they are like the foam of the sea',
        displayOrder: 3,
      ),
      AzkarItem(
        azkarId: 'morning-4',
        categoryId: 'morning',
        arabicText: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration: 'La ilaha illallahu wahdahu la shareeka lah, lahul mulku wa lahul hamdu, wa huwa \'ala kulli shay\'in qadeer',
        translation: 'None has the right to be worshipped but Allah alone, Who has no partner. His is the dominion and His is the praise, and He is Able to do all things',
        source: 'Sahih Al-Bukhari',
        reference: 'Hadith 6403',
        repeatCount: 10,
        virtues: 'Whoever says this ten times in the morning, it is as if he freed four slaves from the children of Isma\'il',
        displayOrder: 4,
      ),
      
      // Evening Azkar
      AzkarItem(
        azkarId: 'evening-1',
        categoryId: 'evening',
        arabicText: 'أَعُوذُ بِاللهِ مِنْ الشَّيْطَانِ الرَّجِيمِ',
        transliteration: 'A\'oodhu billaahi minash-shaytaanir-rajeem',
        translation: 'I seek refuge in Allah from Satan, the accursed',
        source: 'Quran',
        reference: 'Surah An-Nahl, Ayah 98',
        repeatCount: 1,
        displayOrder: 1,
      ),
      AzkarItem(
        azkarId: 'evening-2',
        categoryId: 'evening',
        arabicText: 'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
        transliteration: 'Allahumma bika amsayna wa bika asbahna, wa bika nahya, wa bika namootu, wa ilaykal-maseer',
        translation: 'O Allah, by You we enter the evening and by You we enter the morning, by You we live and by You we die, and to You is the destination',
        source: 'Sunan At-Tirmidhi',
        reference: 'Hadith 3391',
        repeatCount: 1,
        displayOrder: 2,
      ),
      AzkarItem(
        azkarId: 'evening-3',
        categoryId: 'evening',
        arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        transliteration: 'Subhanallahi wa bihamdihi',
        translation: 'Glory is to Allah and praise is to Him',
        source: 'Sahih Muslim',
        reference: 'Hadith 2691',
        repeatCount: 100,
        virtues: 'Whoever says this 100 times in the evening, his sins will be forgiven even if they are like the foam of the sea',
        displayOrder: 3,
      ),
      
      // After Prayer
      AzkarItem(
        azkarId: 'prayer-1',
        categoryId: 'after-prayer',
        arabicText: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfirullah',
        translation: 'I seek forgiveness from Allah',
        source: 'Sunnah',
        reference: '',
        repeatCount: 3,
        displayOrder: 1,
      ),
      AzkarItem(
        azkarId: 'prayer-2',
        categoryId: 'after-prayer',
        arabicText: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        transliteration: 'Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram',
        translation: 'O Allah, You are Peace and from You comes peace. Blessed are You, O Owner of majesty and honor',
        source: 'Sahih Muslim',
        reference: 'Hadith 591',
        repeatCount: 1,
        displayOrder: 2,
      ),
      AzkarItem(
        azkarId: 'prayer-3',
        categoryId: 'after-prayer',
        arabicText: 'سُبْحَانَ اللَّهِ',
        transliteration: 'Subhanallah',
        translation: 'Glory is to Allah',
        source: 'Sunnah',
        reference: '',
        repeatCount: 33,
        displayOrder: 3,
      ),
      AzkarItem(
        azkarId: 'prayer-4',
        categoryId: 'after-prayer',
        arabicText: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdulillah',
        translation: 'Praise is to Allah',
        source: 'Sunnah',
        reference: '',
        repeatCount: 33,
        displayOrder: 4,
      ),
      AzkarItem(
        azkarId: 'prayer-5',
        categoryId: 'after-prayer',
        arabicText: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allahu Akbar',
        translation: 'Allah is the Greatest',
        source: 'Sunnah',
        reference: '',
        repeatCount: 33,
        displayOrder: 5,
      ),
      
      // Before Sleep
      AzkarItem(
        azkarId: 'sleep-1',
        categoryId: 'sleep',
        arabicText: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika allahumma amootu wa ahya',
        translation: 'In Your name, O Allah, I die and I live',
        source: 'Sahih Al-Bukhari',
        reference: 'Hadith 6324',
        repeatCount: 1,
        displayOrder: 1,
      ),
      AzkarItem(
        azkarId: 'sleep-2',
        categoryId: 'sleep',
        arabicText: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
        transliteration: 'Allahumma qini \'adhabaka yawma tab\'athu \'ibadak',
        translation: 'O Allah, protect me from Your punishment on the day You resurrect Your servants',
        source: 'Sunan At-Tirmidhi',
        reference: 'Hadith 3398',
        repeatCount: 3,
        displayOrder: 2,
      ),
      AzkarItem(
        azkarId: 'sleep-3',
        categoryId: 'sleep',
        arabicText: 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَنَبِيِّكَ الَّذِي أَرْسَلْتَ',
        transliteration: 'Allahumma aslamtu nafsi ilayk, wa fawwadtu amri ilayk, wa wajjahtu wajhi ilayk, wa alja\'tu zahri ilayk, raghbatan wa rahbatan ilayk, la malja\'a wa la manja minka illa ilayk, amantu bikitabik alladhi anzalt, wa nabiyyik alladhi arsalt',
        translation: 'O Allah, I have submitted myself to You, and I have entrusted my affairs to You, and I have turned my face to You, and I have relied on You, out of desire and fear of You. There is no refuge and no escape from You except to You. I believe in Your Book which You have revealed, and in Your Prophet whom You have sent',
        source: 'Sahih Al-Bukhari',
        reference: 'Hadith 6318',
        repeatCount: 1,
        displayOrder: 3,
      ),
      
      // Upon Waking
      AzkarItem(
        azkarId: 'wake-1',
        categoryId: 'wake-up',
        arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        transliteration: 'Alhamdulillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushoor',
        translation: 'Praise is to Allah who gives us life after He has caused us to die and to Him is the return',
        source: 'Sahih Al-Bukhari',
        reference: 'Hadith 6312',
        repeatCount: 1,
        displayOrder: 1,
      ),
      
      // Protection
      AzkarItem(
        azkarId: 'protection-1',
        categoryId: 'protection',
        arabicText: 'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ ۖ عَلَيْهِ تَوَكَّلْتُ ۖ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
        transliteration: 'Hasbiyallahu la ilaha illa huwa, \'alayhi tawakkaltu, wa huwa rabbul-\'arshil-\'azheem',
        translation: 'Allah is sufficient for me. None has the right to be worshipped but He, in Him I put my trust and He is the Lord of the Mighty Throne',
        source: 'Quran',
        reference: 'Surah At-Tawbah, Ayah 129',
        repeatCount: 7,
        virtues: 'Whoever says this seven times in the morning and evening, Allah will suffice him against whatever worries him',
        displayOrder: 1,
      ),
      AzkarItem(
        azkarId: 'protection-2',
        categoryId: 'protection',
        arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        transliteration: 'A\'oodhu bikalimatillahit-tammati min sharri ma khalaq',
        translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created',
        source: 'Sahih Muslim',
        reference: 'Hadith 2708',
        repeatCount: 3,
        displayOrder: 2,
      ),
      
      // Gratitude
      AzkarItem(
        azkarId: 'gratitude-1',
        categoryId: 'gratitude',
        arabicText: 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ',
        transliteration: 'Allahumma ma asbaha bi min ni\'matin aw bi ahadin min khalqik, faminka wahdaka la shareeka lak, falakal-hamdu wa lakash-shukr',
        translation: 'O Allah, whatever blessing has been received by me or anyone of Your creation in the morning, it is from You alone, You have no partner. So praise and thanks are to You',
        source: 'Sunan Abi Dawud',
        reference: 'Hadith 5074',
        repeatCount: 1,
        displayOrder: 1,
      ),
      
      // General
      AzkarItem(
        azkarId: 'general-1',
        categoryId: 'general',
        arabicText: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
        transliteration: 'Subhanallahi wal-hamdulillahi wa la ilaha illallahu wallahu akbar',
        translation: 'Glory is to Allah, and praise is to Allah, and there is none worthy of worship except Allah, and Allah is the Greatest',
        source: 'Sunnah',
        reference: '',
        repeatCount: 33,
        displayOrder: 1,
      ),
      AzkarItem(
        azkarId: 'general-2',
        categoryId: 'general',
        arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration: 'La hawla wa la quwwata illa billah',
        translation: 'There is no power and no strength except with Allah',
        source: 'Sahih Al-Bukhari',
        reference: 'Hadith 7385',
        repeatCount: 100,
        virtues: 'Whoever says this 100 times in a day, it is better for him than freeing ten slaves',
        displayOrder: 2,
      ),
    ];
  }
}

