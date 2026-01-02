import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/core/utils/quran_api_loader.dart';
import 'package:quran_azkar_app/features/quran/data/repositories/quran_repository.dart';
import 'package:quran_azkar_app/features/quran/presentation/pages/reading_view_page.dart';
import 'package:quran_azkar_app/shared/models/quran_models.dart';

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final database = await AppDatabase.instance;
  final repository = QuranRepositoryImpl(database);
  return repository.getAllSurahs();
});

class SurahListPage extends ConsumerWidget {
  const SurahListPage({super.key});

  static Future<void> _downloadFullQuran(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Download Full Quran'),
        content: const Text(
          'This will download all 114 surahs (~6,236 ayahs). '
          'This may take 2-3 minutes and requires an internet connection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _showDownloadProgress(context);
              
              try {
                await QuranApiLoader.loadFullQuran();
                ref.invalidate(surahListProvider);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Full Quran downloaded successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context); // Close progress dialog
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Close progress dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Download failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  static void _showDownloadProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Downloading full Quran...\nThis may take 2-3 minutes'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        actions: [
          // Show download button if we don't have full Quran
          surahsAsync.when(
            data: (surahs) => surahs.length < 114
                ? IconButton(
                    icon: const Icon(Icons.download),
                    tooltip: 'Download Full Quran',
                    onPressed: () => _downloadFullQuran(context, ref),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search
            },
          ),
        ],
      ),
      body: surahsAsync.when(
        data: (surahs) {
          if (surahs.isEmpty) {
            return const Center(
              child: Text('No surahs found. Please load content.'),
            );
          }
          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return _SurahListItem(
                surah: surah,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReadingViewPage(surahNumber: surah.number),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(surahListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahListItem extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahListItem({
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          '${surah.number}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Row(
        children: [
          Text(
            surah.nameArabic,
            style: const TextStyle(
              fontSize: 20,
              // fontFamily: 'Amiri', // Uncomment when font is added
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(width: 8),
          Text(
            surah.nameTransliterated,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      subtitle: Text(
        '${surah.nameEnglish} • ${surah.ayahCount} ayahs • ${surah.meccan ? "Meccan" : "Medinan"}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

