import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_azkar_app/core/utils/preferences_helper.dart';
import 'package:quran_azkar_app/features/home/presentation/pages/home_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  
  String? _selectedLanguage;
  String? _selectedTheme;
  double _fontSize = 24.0;
  bool _downloadContent = true;
  bool _enableNotifications = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Save preferences
    if (_selectedLanguage != null) {
      await PreferencesHelper.setLanguage(_selectedLanguage!);
    }
    if (_selectedTheme != null) {
      await PreferencesHelper.setTheme(_selectedTheme!);
    }
    await PreferencesHelper.setArabicFontSize(_fontSize);
    
    // Mark onboarding as complete
    await PreferencesHelper.setOnboardingComplete(true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: const Text('Skip'),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildLanguageSelection(),
                  _buildPreferences(),
                  _buildContentDownload(),
                  _buildNotifications(),
                ],
              ),
            ),
            
            // Page indicator and buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  
                  // Next/Complete button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(_currentPage == 3 ? 'Get Started' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.language, size: 80, color: Colors.green),
          const SizedBox(height: 32),
          const Text(
            'Select Language',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose your preferred language for the app interface',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildLanguageOption('English', 'en'),
          const SizedBox(height: 16),
          _buildLanguageOption('العربية', 'ar'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String label, String value) {
    final isSelected = _selectedLanguage == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).primaryColor.withAlpha(26)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferences() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings, size: 80, color: Colors.green),
          const SizedBox(height: 32),
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Customize your reading experience',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Theme selection
          const Text('Theme', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildThemeOption('Light', 'light'),
              _buildThemeOption('Dark', 'dark'),
              _buildThemeOption('System', 'system'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Font size
          const Text('Font Size', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Slider(
            value: _fontSize,
            min: 16,
            max: 32,
            divisions: 16,
            label: _fontSize.round().toString(),
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String label, String value) {
    final isSelected = _selectedTheme == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).primaryColor.withAlpha(26)
              : null,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildContentDownload() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.download, size: 80, color: Colors.green),
          const SizedBox(height: 32),
          const Text(
            'Download Content',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Download Quran text and content for offline reading',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: const Text('Download offline content'),
            subtitle: const Text('Recommended for best experience'),
            value: _downloadContent,
            onChanged: (value) {
              setState(() {
                _downloadContent = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications, size: 80, color: Colors.green),
          const SizedBox(height: 32),
          const Text(
            'Enable Notifications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Get reminders for daily azkar',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: const Text('Enable azkar reminders'),
            subtitle: const Text('You can change this later in settings'),
            value: _enableNotifications,
            onChanged: (value) {
              setState(() {
                _enableNotifications = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

