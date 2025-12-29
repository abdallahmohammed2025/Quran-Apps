import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static SharedPreferences? _prefs;
  
  static Future<SharedPreferences> get instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
  
  // Theme
  static Future<void> setTheme(String theme) async {
    final prefs = await instance;
    await prefs.setString('theme', theme);
  }
  
  static Future<String?> getTheme() async {
    final prefs = await instance;
    return prefs.getString('theme');
  }
  
  // Language
  static Future<void> setLanguage(String language) async {
    final prefs = await instance;
    await prefs.setString('language', language);
  }
  
  static Future<String?> getLanguage() async {
    final prefs = await instance;
    return prefs.getString('language');
  }
  
  // Onboarding
  static Future<void> setOnboardingComplete(bool complete) async {
    final prefs = await instance;
    await prefs.setBool('onboarding_complete', complete);
  }
  
  static Future<bool> getOnboardingComplete() async {
    final prefs = await instance;
    return prefs.getBool('onboarding_complete') ?? false;
  }
  
  // Font sizes
  static Future<void> setArabicFontSize(double size) async {
    final prefs = await instance;
    await prefs.setDouble('arabic_font_size', size);
  }
  
  static Future<double> getArabicFontSize() async {
    final prefs = await instance;
    return prefs.getDouble('arabic_font_size') ?? 24.0;
  }
  
  static Future<void> setTranslationFontSize(double size) async {
    final prefs = await instance;
    await prefs.setDouble('translation_font_size', size);
  }
  
  static Future<double> getTranslationFontSize() async {
    final prefs = await instance;
    return prefs.getDouble('translation_font_size') ?? 16.0;
  }
  
  // Last read position
  static Future<void> setLastReadSurah(int surahNumber) async {
    final prefs = await instance;
    await prefs.setInt('last_read_surah', surahNumber);
  }
  
  static Future<int?> getLastReadSurah() async {
    final prefs = await instance;
    return prefs.getInt('last_read_surah');
  }
  
  static Future<void> setLastReadAyah(int ayahNumber) async {
    final prefs = await instance;
    await prefs.setInt('last_read_ayah', ayahNumber);
  }
  
  static Future<int?> getLastReadAyah() async {
    final prefs = await instance;
    return prefs.getInt('last_read_ayah');
  }
  
  // Default translation
  static Future<void> setDefaultTranslation(String translatorId) async {
    final prefs = await instance;
    await prefs.setString('default_translation', translatorId);
  }
  
  static Future<String?> getDefaultTranslation() async {
    final prefs = await instance;
    return prefs.getString('default_translation');
  }
  
  // Default reciter
  static Future<void> setDefaultReciter(String reciterId) async {
    final prefs = await instance;
    await prefs.setString('default_reciter', reciterId);
  }
  
  static Future<String?> getDefaultReciter() async {
    final prefs = await instance;
    return prefs.getString('default_reciter');
  }
  
  // Analytics
  static Future<void> setAnalyticsEnabled(bool enabled) async {
    final prefs = await instance;
    await prefs.setBool('analytics_enabled', enabled);
  }
  
  static Future<bool> getAnalyticsEnabled() async {
    final prefs = await instance;
    return prefs.getBool('analytics_enabled') ?? true;
  }
}

