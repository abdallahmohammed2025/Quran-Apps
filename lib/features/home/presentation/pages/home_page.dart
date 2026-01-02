import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_azkar_app/core/utils/preferences_helper.dart';
import 'package:quran_azkar_app/features/quran/presentation/pages/surah_list_page.dart';
import 'package:quran_azkar_app/features/azkar/presentation/pages/azkar_categories_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _QuranTab(),
          _AzkarTab(),
          _AudioTab(),
          _SettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Azkar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones),
            label: 'Audio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran & Azkar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resume Reading
            _buildResumeReading(context),
            const SizedBox(height: 24),
            
            // Daily Verse
            _buildDailyVerse(context),
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(context),
            const SizedBox(height: 24),
            
            // Recent Items
            _buildRecentItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeReading(BuildContext context) {
    return FutureBuilder<Map<String, int?>>(
      future: _getLastReadPosition(),
      builder: (context, snapshot) {
        final surah = snapshot.data?['surah'];
        final ayah = snapshot.data?['ayah'];
        
        if (surah == null || ayah == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start Reading',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Begin your Quran reading journey'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to surah list
                    },
                    child: const Text('Start Reading'),
                  ),
                ],
              ),
            ),
          );
        }
        
        return Card(
          child: InkWell(
            onTap: () {
              // Navigate to reading view
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text(
                        'Resume Reading',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Surah $surah, Ayah $ayah'),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to continue reading',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, int?>> _getLastReadPosition() async {
    final surah = await PreferencesHelper.getLastReadSurah();
    final ayah = await PreferencesHelper.getLastReadAyah();
    return {'surah': surah, 'ayah': ayah};
  }

  Widget _buildDailyVerse(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Verse',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
              style: TextStyle(
                fontSize: 24,
                // fontFamily: 'Amiri', // Uncomment when font is added
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            const Text(
              'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigate to reading view
              },
              child: const Text('Read More'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2,
          children: [
            _buildQuickActionCard(
              context,
              'Go to Surah',
              Icons.menu_book,
              () {
                // Navigate to surah list
              },
            ),
            _buildQuickActionCard(
              context,
              'Search',
              Icons.search,
              () {
                // Navigate to search
              },
            ),
            _buildQuickActionCard(
              context,
              'Morning Azkar',
              Icons.wb_sunny,
              () {
                // Navigate to morning azkar
              },
            ),
            _buildQuickActionCard(
              context,
              'Evening Azkar',
              Icons.nightlight,
              () {
                // Navigate to evening azkar
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // TODO: Show recent bookmarks, surahs, etc.
        const Text('No recent items'),
      ],
    );
  }
}

// Placeholder tabs - will be implemented
class _QuranTab extends StatelessWidget {
  const _QuranTab();
  @override
  Widget build(BuildContext context) {
    return const SurahListPage();
  }
}

class _AzkarTab extends StatelessWidget {
  const _AzkarTab();
  @override
  Widget build(BuildContext context) {
    return const AzkarCategoriesPage();
  }
}

class _AudioTab extends StatelessWidget {
  const _AudioTab();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio')),
      body: const Center(child: Text('Audio Tab - Coming Soon')),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Tab - Coming Soon')),
    );
  }
}

