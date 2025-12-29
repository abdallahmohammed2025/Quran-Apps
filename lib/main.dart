import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quran_azkar_app/core/di/di_setup.dart';
import 'package:quran_azkar_app/core/theme/app_theme.dart';
import 'package:quran_azkar_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:quran_azkar_app/features/home/presentation/pages/home_page.dart';
import 'package:quran_azkar_app/core/utils/preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (optional)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase not configured, continue without it
    debugPrint('Firebase initialization skipped: $e');
  }
  
  // Initialize dependencies
  await setupDependencies();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    const ProviderScope(
      child: QuranAzkarApp(),
    ),
  );
}

class QuranAzkarApp extends ConsumerWidget {
  const QuranAzkarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isOnboardingCompleteAsync = ref.watch(onboardingCompleteProvider);
    
    return MaterialApp(
      title: 'Quran & Azkar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: const Locale('en'), // TODO: Get from preferences
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: isOnboardingCompleteAsync.when(
        data: (isComplete) => isComplete
            ? const HomePage()
            : const OnboardingPage(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => const OnboardingPage(),
      ),
    );
  }
}

// Providers
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await PreferencesHelper.instance;
  return prefs.getBool('onboarding_complete') ?? false;
});

