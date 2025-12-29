import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        actions: [
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

