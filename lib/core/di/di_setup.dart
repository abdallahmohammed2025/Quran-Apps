import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/core/utils/sample_data_loader.dart';

Future<void> setupDependencies() async {
  // Initialize database
  final database = await AppDatabase.instance;
  // Database is now initialized and ready to use
  
  // Load sample data for testing (remove in production)
  await SampleDataLoader.loadSampleData();
  
  // Repositories and other dependencies will be set up as we implement features
}

