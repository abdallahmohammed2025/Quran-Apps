import 'package:quran_azkar_app/core/utils/quran_api_loader.dart';

/// Utility to force load full Quran
/// Call this from settings or manually to ensure all 114 surahs are loaded
Future<void> forceLoadFullQuran() async {
  try {
    print('Starting full Quran download...');
    await QuranApiLoader.loadFullQuran();
    print('Full Quran download completed!');
  } catch (e) {
    print('Error downloading full Quran: $e');
    rethrow;
  }
}

