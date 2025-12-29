import 'package:quran_azkar_app/shared/models/quran_models.dart';

/// Comprehensive Quran data generator
/// This file contains data for multiple surahs
class ComprehensiveQuranData {
  /// Get all Quran ayahs for multiple surahs
  static List<QuranText> getAllAyahs() {
    final ayahs = <QuranText>[];
    
    // Add all surahs
    ayahs.addAll(getSurah1());
    ayahs.addAll(getSurah2());
    ayahs.addAll(getSurah3());
    ayahs.addAll(getSurah36()); // Ya-Sin
    ayahs.addAll(getSurah55()); // Ar-Rahman
    ayahs.addAll(getSurah67()); // Al-Mulk
    ayahs.addAll(getSurah78()); // An-Naba
    ayahs.addAll(getSurah112()); // Al-Ikhlas
    ayahs.addAll(getSurah113()); // Al-Falaq
    ayahs.addAll(getSurah114()); // An-Nas
    
    return ayahs;
  }

  static List<QuranText> getSurah1() {
    return [
      QuranText(ayahId: '1-1', surahNumber: 1, ayahNumber: 1, text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', pageNumber: 1, juzNumber: 1, bismillah: true, meccan: true),
      QuranText(ayahId: '1-2', surahNumber: 1, ayahNumber: 2, text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', pageNumber: 1, juzNumber: 1, meccan: true),
      QuranText(ayahId: '1-3', surahNumber: 1, ayahNumber: 3, text: 'الرَّحْمَٰنِ الرَّحِيمِ', pageNumber: 1, juzNumber: 1, meccan: true),
      QuranText(ayahId: '1-4', surahNumber: 1, ayahNumber: 4, text: 'مَالِكِ يَوْمِ الدِّينِ', pageNumber: 1, juzNumber: 1, meccan: true),
      QuranText(ayahId: '1-5', surahNumber: 1, ayahNumber: 5, text: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', pageNumber: 1, juzNumber: 1, meccan: true),
      QuranText(ayahId: '1-6', surahNumber: 1, ayahNumber: 6, text: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', pageNumber: 1, juzNumber: 1, meccan: true),
      QuranText(ayahId: '1-7', surahNumber: 1, ayahNumber: 7, text: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', pageNumber: 1, juzNumber: 1, meccan: true),
    ];
  }

  static List<QuranText> getSurah2() {
    return [
      QuranText(ayahId: '2-1', surahNumber: 2, ayahNumber: 1, text: 'الم', pageNumber: 2, juzNumber: 1, bismillah: true, meccan: false),
      QuranText(ayahId: '2-2', surahNumber: 2, ayahNumber: 2, text: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ', pageNumber: 2, juzNumber: 1, meccan: false),
      QuranText(ayahId: '2-3', surahNumber: 2, ayahNumber: 3, text: 'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ', pageNumber: 2, juzNumber: 1, meccan: false),
      QuranText(ayahId: '2-4', surahNumber: 2, ayahNumber: 4, text: 'وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ', pageNumber: 2, juzNumber: 1, meccan: false),
      QuranText(ayahId: '2-5', surahNumber: 2, ayahNumber: 5, text: 'أُولَٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ', pageNumber: 2, juzNumber: 1, meccan: false),
      QuranText(ayahId: '2-255', surahNumber: 2, ayahNumber: 255, text: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ', pageNumber: 42, juzNumber: 3, meccan: false),
    ];
  }

  static List<QuranText> getSurah3() {
    return [
      QuranText(ayahId: '3-1', surahNumber: 3, ayahNumber: 1, text: 'الم', pageNumber: 50, juzNumber: 3, bismillah: true, meccan: false),
      QuranText(ayahId: '3-2', surahNumber: 3, ayahNumber: 2, text: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ', pageNumber: 50, juzNumber: 3, meccan: false),
      QuranText(ayahId: '3-3', surahNumber: 3, ayahNumber: 3, text: 'نَزَّلَ عَلَيْكَ الْكِتَابَ بِالْحَقِّ مُصَدِّقًا لِّمَا بَيْنَ يَدَيْهِ وَأَنزَلَ التَّوْرَاةَ وَالْإِنجِيلَ', pageNumber: 50, juzNumber: 3, meccan: false),
    ];
  }

  static List<QuranText> getSurah36() {
    return [
      QuranText(ayahId: '36-1', surahNumber: 36, ayahNumber: 1, text: 'يس', pageNumber: 440, juzNumber: 22, bismillah: true, meccan: true),
      QuranText(ayahId: '36-2', surahNumber: 36, ayahNumber: 2, text: 'وَالْقُرْآنِ الْحَكِيمِ', pageNumber: 440, juzNumber: 22, meccan: true),
      QuranText(ayahId: '36-3', surahNumber: 36, ayahNumber: 3, text: 'إِنَّكَ لَمِنَ الْمُرْسَلِينَ', pageNumber: 440, juzNumber: 22, meccan: true),
    ];
  }

  static List<QuranText> getSurah55() {
    return [
      QuranText(ayahId: '55-1', surahNumber: 55, ayahNumber: 1, text: 'الرَّحْمَٰنُ', pageNumber: 531, juzNumber: 27, bismillah: true, meccan: true),
      QuranText(ayahId: '55-2', surahNumber: 55, ayahNumber: 2, text: 'عَلَّمَ الْقُرْآنَ', pageNumber: 531, juzNumber: 27, meccan: true),
      QuranText(ayahId: '55-3', surahNumber: 55, ayahNumber: 3, text: 'خَلَقَ الْإِنسَانَ', pageNumber: 531, juzNumber: 27, meccan: true),
    ];
  }

  static List<QuranText> getSurah67() {
    return [
      QuranText(ayahId: '67-1', surahNumber: 67, ayahNumber: 1, text: 'تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ', pageNumber: 562, juzNumber: 29, bismillah: true, meccan: true),
      QuranText(ayahId: '67-2', surahNumber: 67, ayahNumber: 2, text: 'الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا ۚ وَهُوَ الْعَزِيزُ الْغَفُورُ', pageNumber: 562, juzNumber: 29, meccan: true),
    ];
  }

  static List<QuranText> getSurah78() {
    return [
      QuranText(ayahId: '78-1', surahNumber: 78, ayahNumber: 1, text: 'عَمَّ يَتَسَاءَلُونَ', pageNumber: 582, juzNumber: 30, bismillah: true, meccan: true),
      QuranText(ayahId: '78-2', surahNumber: 78, ayahNumber: 2, text: 'عَنِ النَّبَإِ الْعَظِيمِ', pageNumber: 582, juzNumber: 30, meccan: true),
    ];
  }

  static List<QuranText> getSurah112() {
    return [
      QuranText(ayahId: '112-1', surahNumber: 112, ayahNumber: 1, text: 'قُلْ هُوَ اللَّهُ أَحَدٌ', pageNumber: 604, juzNumber: 30, bismillah: true, meccan: true),
      QuranText(ayahId: '112-2', surahNumber: 112, ayahNumber: 2, text: 'اللَّهُ الصَّمَدُ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '112-3', surahNumber: 112, ayahNumber: 3, text: 'لَمْ يَلِدْ وَلَمْ يُولَدْ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '112-4', surahNumber: 112, ayahNumber: 4, text: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', pageNumber: 604, juzNumber: 30, meccan: true),
    ];
  }

  static List<QuranText> getSurah113() {
    return [
      QuranText(ayahId: '113-1', surahNumber: 113, ayahNumber: 1, text: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', pageNumber: 604, juzNumber: 30, bismillah: true, meccan: true),
      QuranText(ayahId: '113-2', surahNumber: 113, ayahNumber: 2, text: 'مِن شَرِّ مَا خَلَقَ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '113-3', surahNumber: 113, ayahNumber: 3, text: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '113-4', surahNumber: 113, ayahNumber: 4, text: 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '113-5', surahNumber: 113, ayahNumber: 5, text: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', pageNumber: 604, juzNumber: 30, meccan: true),
    ];
  }

  static List<QuranText> getSurah114() {
    return [
      QuranText(ayahId: '114-1', surahNumber: 114, ayahNumber: 1, text: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ', pageNumber: 604, juzNumber: 30, bismillah: true, meccan: true),
      QuranText(ayahId: '114-2', surahNumber: 114, ayahNumber: 2, text: 'مَلِكِ النَّاسِ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '114-3', surahNumber: 114, ayahNumber: 3, text: 'إِلَٰهِ النَّاسِ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '114-4', surahNumber: 114, ayahNumber: 4, text: 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '114-5', surahNumber: 114, ayahNumber: 5, text: 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ', pageNumber: 604, juzNumber: 30, meccan: true),
      QuranText(ayahId: '114-6', surahNumber: 114, ayahNumber: 6, text: 'مِنَ الْجِنَّةِ وَالنَّاسِ', pageNumber: 604, juzNumber: 30, meccan: true),
    ];
  }
}

