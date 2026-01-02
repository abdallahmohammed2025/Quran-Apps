import 'package:flutter/material.dart';
import 'package:quran_azkar_app/shared/models/azkar_models.dart';

class AzkarCounterPage extends StatefulWidget {
  final AzkarItem azkarItem;

  const AzkarCounterPage({
    super.key,
    required this.azkarItem,
  });

  @override
  State<AzkarCounterPage> createState() => _AzkarCounterPageState();
}

class _AzkarCounterPageState extends State<AzkarCounterPage> {
  int _currentCount = 0;
  late final int _targetCount;

  @override
  void initState() {
    super.initState();
    _targetCount = widget.azkarItem.repeatCount;
  }

  void _increment() {
    setState(() {
      if (_currentCount < _targetCount) {
        _currentCount++;
      }
    });
    
    // Haptic feedback
    // HapticFeedback.lightImpact();
  }

  void _reset() {
    setState(() {
      _currentCount = 0;
    });
  }

  bool get _isComplete => _currentCount >= _targetCount;

  @override
  Widget build(BuildContext context) {
    final progress = _targetCount > 0 ? _currentCount / _targetCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Azkar Counter'),
        actions: [
          if (_currentCount > 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress indicator
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    '$_currentCount / $_targetCount',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isComplete
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _isComplete ? Colors.green : Theme.of(context).primaryColor,
                    ),
                  ),
                  if (_isComplete) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Completed!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Arabic text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    widget.azkarItem.arabicText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Transliteration
                  if (widget.azkarItem.transliteration != null) ...[
                    Text(
                      widget.azkarItem.transliteration!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Translation
                  if (widget.azkarItem.translation != null)
                    Text(
                      widget.azkarItem.translation!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Counter button
            SizedBox(
              width: 200,
              height: 200,
              child: ElevatedButton(
                onPressed: _isComplete ? null : _increment,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                  backgroundColor: _isComplete
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                ),
                child: Text(
                  '$_currentCount',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Instructions
            Text(
              _isComplete
                  ? 'Tap reset to start again'
                  : 'Tap the counter to increment',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            // Virtues
            if (widget.azkarItem.virtues != null) ...[
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Virtues',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.azkarItem.virtues!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Source
            if (widget.azkarItem.source != null || widget.azkarItem.reference != null) ...[
              const SizedBox(height: 16),
              Text(
                [
                  if (widget.azkarItem.source != null) widget.azkarItem.source!,
                  if (widget.azkarItem.reference != null) widget.azkarItem.reference!,
                ].join(' • '),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

