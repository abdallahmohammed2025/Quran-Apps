/// Metadata for all 114 surahs including Meccan/Medinan classification
class SurahMetadata {
  /// Medinan surahs (revealed in Medina after Hijrah)
  /// These are the surahs revealed after the Prophet's migration to Medina
  static const Set<int> medinanSurahs = {
    2, 3, 4, 5, 8, 9, 22, 24, 33, 47, 48, 49, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 98, 99, 110,
  };

  /// Meccan surahs (revealed in Mecca before Hijrah)
  /// All other surahs not in medinanSurahs are Meccan
  static bool isMeccan(int surahNumber) {
    return !medinanSurahs.contains(surahNumber);
  }

  static bool isMedinan(int surahNumber) {
    return medinanSurahs.contains(surahNumber);
  }
}
