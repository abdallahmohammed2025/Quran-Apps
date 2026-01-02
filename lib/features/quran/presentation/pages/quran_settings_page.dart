import 'package:flutter/material.dart';
import 'package:quran_azkar_app/core/utils/quran_api_loader.dart';
import 'package:quran_azkar_app/core/database/app_database.dart';
import 'package:quran_azkar_app/features/quran/data/repositories/quran_repository.dart';

/// Settings page for Quran content management
/// Allows users to download full Quran content
class QuranSettingsPage extends StatefulWidget {
  const QuranSettingsPage({super.key});

  @override
  State<QuranSettingsPage> createState() => _QuranSettingsPageState();
}

class _QuranSettingsPageState extends State<QuranSettingsPage> {
  bool _isLoading = false;
  String _statusMessage = '';
  int _currentSurahCount = 0;

  @override
  void initState() {
    super.initState();
    _checkQuranStatus();
  }

  Future<void> _checkQuranStatus() async {
    final database = await AppDatabase.instance;
    final repository = QuranRepositoryImpl(database);
    final surahs = await repository.getAllSurahs();
    
    setState(() {
      _currentSurahCount = surahs.length;
    });
  }

  Future<void> _downloadFullQuran() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Starting download...';
    });

    try {
      await QuranApiLoader.loadFullQuran();
      
      // Refresh count
      await _checkQuranStatus();
      
      setState(() {
        _isLoading = false;
        _statusMessage = 'Full Quran downloaded successfully!';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Full Quran downloaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: $e';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFullQuran = _currentSurahCount >= 100;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Content'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Content',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        hasFullQuran ? Icons.check_circle : Icons.info_outline,
                        color: hasFullQuran ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Surahs: $_currentSurahCount / 114',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  if (!hasFullQuran) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'You currently have sample data. Download the full Quran for complete access.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          if (!hasFullQuran) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Download Full Quran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Download all 114 surahs with ~6,236 ayahs. This requires an internet connection and may take 1-2 minutes.',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _downloadFullQuran,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.download),
                        label: Text(_isLoading ? 'Downloading...' : 'Download Full Quran'),
                      ),
                    ),
                    if (_statusMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _statusMessage.contains('Error') ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ] else ...[
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Full Quran content is available!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Full Quran includes all 114 surahs\n'
                    '• ~6,236 ayahs (verses)\n'
                    '• Content is cached locally after download\n'
                    '• Works offline after initial download\n'
                    '• Requires internet connection only for first download',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

