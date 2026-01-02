import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/shared/models/azkar_models.dart';
import 'package:quran_azkar_app/features/azkar/presentation/pages/azkar_counter_page.dart';

final azkarItemsProvider = FutureProvider.family<List<AzkarItem>, String>((ref, categoryId) async {
  final database = await AppDatabase.instance;
  final items = await database.query(
    'azkar_items',
    where: 'category_id = ?',
    whereArgs: [categoryId],
    orderBy: 'display_order ASC',
  );
  return items.map((map) => AzkarItem.fromMap(map)).toList();
});

final azkarCategoryProvider = FutureProvider.family<AzkarCategory?, String>((ref, categoryId) async {
  final database = await AppDatabase.instance;
  final categories = await database.query(
    'azkar_categories',
    where: 'category_id = ?',
    whereArgs: [categoryId],
    limit: 1,
  );
  if (categories.isEmpty) return null;
  return AzkarCategory.fromMap(categories.first);
});

class AzkarItemsPage extends ConsumerWidget {
  final String categoryId;

  const AzkarItemsPage({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(azkarCategoryProvider(categoryId));
    final itemsAsync = ref.watch(azkarItemsProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: categoryAsync.when(
          data: (category) => Text(category?.nameTransliterated ?? 'Azkar'),
          loading: () => const Text('Azkar'),
          error: (_, __) => const Text('Azkar'),
        ),
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No Azkar items found.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _AzkarItemCard(
                item: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AzkarCounterPage(azkarItem: item),
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
                onPressed: () => ref.invalidate(azkarItemsProvider(categoryId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AzkarItemCard extends StatelessWidget {
  final AzkarItem item;
  final VoidCallback onTap;

  const _AzkarItemCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Arabic text
              Text(
                item.arabicText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              
              // Transliteration
              if (item.transliteration != null) ...[
                Text(
                  item.transliteration!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              
              // Translation
              if (item.translation != null) ...[
                Text(
                  item.translation!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              
              // Repeat count and source
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (item.repeatCount > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.repeatCount}x',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (item.source != null)
                    Text(
                      item.source!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

