import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/core/utils/content_loader.dart';

Future<void> setupDependencies() async {
  // Initialize database
  final database = await AppDatabase.instance;
  // Database is now initialized and ready to use
  
  // Load comprehensive content (Quran + Azkar)
  await ContentLoader.loadAllContent();
  
  // Repositories and other dependencies will be set up as we implement features
}

