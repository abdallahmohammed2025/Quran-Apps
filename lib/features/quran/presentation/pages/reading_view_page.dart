import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/features/quran/data/repositories/quran_repository.dart';
import 'package:quran_azkar_app/shared/models/quran_models.dart';

final surahAyahsProvider = FutureProvider.family<List<QuranText>, int>((ref, surahNumber) async {
  final database = await AppDatabase.instance;
  final repository = QuranRepositoryImpl(database);
  return repository.getSurah(surahNumber);
});

class ReadingViewPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final int? initialAyahNumber;

  const ReadingViewPage({
    super.key,
    required this.surahNumber,
    this.initialAyahNumber,
  });

  @override
  ConsumerState<ReadingViewPage> createState() => _ReadingViewPageState();
}

class _ReadingViewPageState extends ConsumerState<ReadingViewPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ayahsAsync = ref.watch(surahAyahsProvider(widget.surahNumber));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Show bookmarks
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show menu
            },
          ),
        ],
      ),
      body: ayahsAsync.when(
        data: (ayahs) {
          if (ayahs.isEmpty) {
            return const Center(
              child: Text('No content available. Please load content.'),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: ayahs.length,
            itemBuilder: (context, index) {
              final ayah = ayahs[index];
              return _AyahWidget(ayah: ayah);
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
                onPressed: () => ref.invalidate(surahAyahsProvider(widget.surahNumber)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AyahWidget extends StatelessWidget {
  final QuranText ayah;

  const _AyahWidget({required this.ayah});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showAyahActions(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Ayah number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${ayah.surahNumber}:${ayah.ayahNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (ayah.sajdahMarker)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Sajdah',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Arabic text
              Text(
                ayah.text,
                style: const TextStyle(
                  fontSize: 24,
                  // fontFamily: 'Amiri', // Uncomment when font is added
                  height: 2.0,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              // Translation (placeholder - will be loaded from translations table)
              Text(
                'Translation will appear here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAyahActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('Bookmark'),
              onTap: () {
                Navigator.pop(context);
                // Add bookmark
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Add Note'),
              onTap: () {
                Navigator.pop(context);
                // Add note
              },
            ),
            ListTile(
              leading: const Icon(Icons.highlight),
              title: const Text('Highlight'),
              onTap: () {
                Navigator.pop(context);
                // Add highlight
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Arabic'),
              onTap: () {
                Navigator.pop(context);
                // Copy text
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Share
              },
            ),
            ListTile(
              leading: const Icon(Icons.headphones),
              title: const Text('Play Audio'),
              onTap: () {
                Navigator.pop(context);
                // Play audio
              },
            ),
          ],
        ),
      ),
    );
  }
}

