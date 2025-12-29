import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/features/quran/data/repositories/quran_repository.dart';
import 'package:quran_azkar_app/shared/models/quran_models.dart';

/// Utility class to load sample data for testing
/// In production, this would load from content packs
class SampleDataLoader {
  static Future<void> loadSampleData() async {
    final database = await AppDatabase.instance;
    final repository = QuranRepositoryImpl(database);
    
    // Check if data already exists
    final existingSurahs = await repository.getAllSurahs();
    if (existingSurahs.isNotEmpty) {
      return; // Data already loaded
    }
    
    // Load sample surahs (Al-Fatiha and Al-Baqarah as examples)
    await _loadSurah1(repository);
    await _loadSurah2(repository);
  }
  
  static Future<void> _loadSurah1(QuranRepository repository) async {
    // Al-Fatiha - 7 ayahs
    final ayahs = [
      QuranText(
        ayahId: '1-1',
        surahNumber: 1,
        ayahNumber: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        pageNumber: 1,
        juzNumber: 1,
        bismillah: true,
        meccan: true,
      ),
      QuranText(
        ayahId: '1-2',
        surahNumber: 1,
        ayahNumber: 2,
        text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        pageNumber: 1,
        juzNumber: 1,
        meccan: true,
      ),
      QuranText(
        ayahId: '1-3',
        surahNumber: 1,
        ayahNumber: 3,
        text: 'الرَّحْمَٰنِ الرَّحِيمِ',
        pageNumber: 1,
        juzNumber: 1,
        meccan: true,
      ),
      QuranText(
        ayahId: '1-4',
        surahNumber: 1,
        ayahNumber: 4,
        text: 'مَالِكِ يَوْمِ الدِّينِ',
        pageNumber: 1,
        juzNumber: 1,
        meccan: true,
      ),
      QuranText(
        ayahId: '1-5',
        surahNumber: 1,
        ayahNumber: 5,
        text: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        pageNumber: 1,
        juzNumber: 1,
        meccan: true,
      ),
      QuranText(
        ayahId: '1-6',
        surahNumber: 1,
        ayahNumber: 6,
        text: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        pageNumber: 1,
        juzNumber: 1,
        meccan: true,
      ),
      QuranText(
        ayahId: '1-7',
        surahNumber: 1,
        ayahNumber: 7,
        text: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        pageNumber: 1,
        juzNumber: 1,
        meccan: true,
      ),
    ];
    
    await repository.insertQuranTexts(ayahs);
  }
  
  static Future<void> _loadSurah2(QuranRepository repository) async {
    // Al-Baqarah - First few ayahs as sample
    final ayahs = [
      QuranText(
        ayahId: '2-1',
        surahNumber: 2,
        ayahNumber: 1,
        text: 'الم',
        pageNumber: 2,
        juzNumber: 1,
        bismillah: true,
        meccan: false,
      ),
      QuranText(
        ayahId: '2-2',
        surahNumber: 2,
        ayahNumber: 2,
        text: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
        pageNumber: 2,
        juzNumber: 1,
        meccan: false,
      ),
      QuranText(
        ayahId: '2-3',
        surahNumber: 2,
        ayahNumber: 3,
        text: 'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ',
        pageNumber: 2,
        juzNumber: 1,
        meccan: false,
      ),
      QuranText(
        ayahId: '2-4',
        surahNumber: 2,
        ayahNumber: 4,
        text: 'وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ',
        pageNumber: 2,
        juzNumber: 1,
        meccan: false,
      ),
      QuranText(
        ayahId: '2-5',
        surahNumber: 2,
        ayahNumber: 5,
        text: 'أُولَٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ',
        pageNumber: 2,
        juzNumber: 1,
        meccan: false,
      ),
    ];
    
    await repository.insertQuranTexts(ayahs);
  }
}

