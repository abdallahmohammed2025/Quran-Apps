class AzkarCategory {
  final String categoryId;
  final String name;
  final String? nameTransliterated;
  final String? description;
  final String? icon;
  final String? color;
  final List<String> timeTags;
  final int displayOrder;

  AzkarCategory({
    required this.categoryId,
    required this.name,
    this.nameTransliterated,
    this.description,
    this.icon,
    this.color,
    this.timeTags = const [],
    this.displayOrder = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'name_transliterated': nameTransliterated,
      'description': description,
      'icon': icon,
      'color': color,
      'time_tags': timeTags.join(','),
      'display_order': displayOrder,
    };
  }

  factory AzkarCategory.fromMap(Map<String, dynamic> map) {
    return AzkarCategory(
      categoryId: map['category_id'] as String,
      name: map['name'] as String,
      nameTransliterated: map['name_transliterated'] as String?,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
      color: map['color'] as String?,
      timeTags: map['time_tags'] != null
          ? (map['time_tags'] as String).split(',').where((s) => s.isNotEmpty).toList()
          : [],
      displayOrder: map['display_order'] as int? ?? 0,
    );
  }
}

class AzkarItem {
  final String azkarId;
  final String categoryId;
  final String arabicText;
  final String? transliteration;
  final String? translation;
  final String? source;
  final String? reference;
  final int repeatCount;
  final String? virtues;
  final List<String> timeTags;
  final int displayOrder;
  final bool isFavorite;

  AzkarItem({
    required this.azkarId,
    required this.categoryId,
    required this.arabicText,
    this.transliteration,
    this.translation,
    this.source,
    this.reference,
    this.repeatCount = 1,
    this.virtues,
    this.timeTags = const [],
    this.displayOrder = 0,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'azkar_id': azkarId,
      'category_id': categoryId,
      'arabic_text': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'source': source,
      'reference': reference,
      'repeat_count': repeatCount,
      'virtues': virtues,
      'time_tags': timeTags.join(','),
      'display_order': displayOrder,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory AzkarItem.fromMap(Map<String, dynamic> map) {
    return AzkarItem(
      azkarId: map['azkar_id'] as String,
      categoryId: map['category_id'] as String,
      arabicText: map['arabic_text'] as String,
      transliteration: map['transliteration'] as String?,
      translation: map['translation'] as String?,
      source: map['source'] as String?,
      reference: map['reference'] as String?,
      repeatCount: map['repeat_count'] as int? ?? 1,
      virtues: map['virtues'] as String?,
      timeTags: map['time_tags'] != null
          ? (map['time_tags'] as String).split(',').where((s) => s.isNotEmpty).toList()
          : [],
      displayOrder: map['display_order'] as int? ?? 0,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
    );
  }
}

class AzkarProgress {
  final String progressId;
  final String? userId;
  final String categoryId;
  final DateTime sessionDate;
  final int itemsCompleted;
  final int? totalItems;
  final int timeSpent; // in seconds
  final int streakDays;
  final DateTime? lastCompletedAt;

  AzkarProgress({
    required this.progressId,
    this.userId,
    required this.categoryId,
    required this.sessionDate,
    this.itemsCompleted = 0,
    this.totalItems,
    this.timeSpent = 0,
    this.streakDays = 0,
    this.lastCompletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'progress_id': progressId,
      'user_id': userId,
      'category_id': categoryId,
      'session_date': sessionDate.toIso8601String().split('T')[0],
      'items_completed': itemsCompleted,
      'total_items': totalItems,
      'time_spent': timeSpent,
      'streak_days': streakDays,
      'last_completed_at': lastCompletedAt?.millisecondsSinceEpoch,
    };
  }

  factory AzkarProgress.fromMap(Map<String, dynamic> map) {
    return AzkarProgress(
      progressId: map['progress_id'] as String,
      userId: map['user_id'] as String?,
      categoryId: map['category_id'] as String,
      sessionDate: DateTime.parse(map['session_date'] as String),
      itemsCompleted: map['items_completed'] as int? ?? 0,
      totalItems: map['total_items'] as int?,
      timeSpent: map['time_spent'] as int? ?? 0,
      streakDays: map['streak_days'] as int? ?? 0,
      lastCompletedAt: map['last_completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_completed_at'] as int)
          : null,
    );
  }
}

class Reminder {
  final String reminderId;
  final String? userId;
  final String? categoryId;
  final String? azkarId;
  final ReminderType type;
  final String time; // HH:mm format
  final int? timeWindow; // in minutes
  final List<int> daysOfWeek; // 0=Sunday, 1=Monday, etc.
  final bool enabled;
  final NotificationContent notificationContent;
  final String? timezone;
  final DateTime? lastTriggered;

  Reminder({
    required this.reminderId,
    this.userId,
    this.categoryId,
    this.azkarId,
    required this.type,
    required this.time,
    this.timeWindow,
    this.daysOfWeek = const [],
    this.enabled = true,
    this.notificationContent = NotificationContent.generic,
    this.timezone,
    this.lastTriggered,
  });

  Map<String, dynamic> toMap() {
    return {
      'reminder_id': reminderId,
      'user_id': userId,
      'category_id': categoryId,
      'azkar_id': azkarId,
      'type': type.name,
      'time': time,
      'time_window': timeWindow,
      'days_of_week': daysOfWeek.join(','),
      'enabled': enabled ? 1 : 0,
      'notification_content': notificationContent.name,
      'timezone': timezone,
      'last_triggered': lastTriggered?.millisecondsSinceEpoch,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      reminderId: map['reminder_id'] as String,
      userId: map['user_id'] as String?,
      categoryId: map['category_id'] as String?,
      azkarId: map['azkar_id'] as String?,
      type: ReminderType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ReminderType.custom,
      ),
      time: map['time'] as String,
      timeWindow: map['time_window'] as int?,
      daysOfWeek: map['days_of_week'] != null
          ? (map['days_of_week'] as String)
              .split(',')
              .where((s) => s.isNotEmpty)
              .map((s) => int.parse(s))
              .toList()
          : [],
      enabled: (map['enabled'] as int? ?? 1) == 1,
      notificationContent: NotificationContent.values.firstWhere(
        (e) => e.name == map['notification_content'],
        orElse: () => NotificationContent.generic,
      ),
      timezone: map['timezone'] as String?,
      lastTriggered: map['last_triggered'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_triggered'] as int)
          : null,
    );
  }
}

enum ReminderType {
  morning,
  evening,
  prayerBased,
  custom,
  periodic,
}

enum NotificationContent {
  generic,
  snippet,
}

