class QuranText {
  final String ayahId;
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final int? pageNumber;
  final int? juzNumber;
  final int? hizbNumber;
  final int? rubNumber;
  final int? rukuNumber;
  final bool sajdahMarker;
  final bool bismillah;
  final bool meccan;

  QuranText({
    required this.ayahId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    this.pageNumber,
    this.juzNumber,
    this.hizbNumber,
    this.rubNumber,
    this.rukuNumber,
    this.sajdahMarker = false,
    this.bismillah = false,
    this.meccan = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'ayah_id': ayahId,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'text': text,
      'page_number': pageNumber,
      'juz_number': juzNumber,
      'hizb_number': hizbNumber,
      'rub_number': rubNumber,
      'ruku_number': rukuNumber,
      'sajdah_marker': sajdahMarker ? 1 : 0,
      'bismillah': bismillah ? 1 : 0,
      'meccan': meccan ? 1 : 0,
    };
  }

  factory QuranText.fromMap(Map<String, dynamic> map) {
    return QuranText(
      ayahId: map['ayah_id'] as String,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      text: map['text'] as String,
      pageNumber: map['page_number'] as int?,
      juzNumber: map['juz_number'] as int?,
      hizbNumber: map['hizb_number'] as int?,
      rubNumber: map['rub_number'] as int?,
      rukuNumber: map['ruku_number'] as int?,
      sajdahMarker: (map['sajdah_marker'] as int? ?? 0) == 1,
      bismillah: (map['bismillah'] as int? ?? 0) == 1,
      meccan: (map['meccan'] as int? ?? 0) == 1,
    );
  }

  factory QuranText.fromJson(Map<String, dynamic> json) {
    return QuranText(
      ayahId: json['ayah_id'] as String? ?? '${json['surah_number']}-${json['ayah_number']}',
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      text: json['text'] as String,
      pageNumber: json['page_number'] as int?,
      juzNumber: json['juz_number'] as int?,
      hizbNumber: json['hizb_number'] as int?,
      rubNumber: json['rub_number'] as int?,
      rukuNumber: json['ruku_number'] as int?,
      sajdahMarker: (json['sajdah_marker'] as int? ?? 0) == 1,
      bismillah: (json['bismillah'] as int? ?? 0) == 1,
      meccan: (json['meccan'] as int? ?? 0) == 1,
    );
  }
}

class Surah {
  final int number;
  final String nameArabic;
  final String nameTransliterated;
  final String nameEnglish;
  final int ayahCount;
  final bool meccan;
  final int? revelationOrder;

  Surah({
    required this.number,
    required this.nameArabic,
    required this.nameTransliterated,
    required this.nameEnglish,
    required this.ayahCount,
    this.meccan = true,
    this.revelationOrder,
  });
}

class Translation {
  final String translationId;
  final String languageCode;
  final String translatorName;
  final String translatorId;
  final String version;
  final String ayahId;
  final String text;
  final String? copyright;
  final String? sourceUrl;

  Translation({
    required this.translationId,
    required this.languageCode,
    required this.translatorName,
    required this.translatorId,
    required this.version,
    required this.ayahId,
    required this.text,
    this.copyright,
    this.sourceUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'translation_id': translationId,
      'language_code': languageCode,
      'translator_name': translatorName,
      'translator_id': translatorId,
      'version': version,
      'ayah_id': ayahId,
      'text': text,
      'copyright': copyright,
      'source_url': sourceUrl,
    };
  }

  factory Translation.fromMap(Map<String, dynamic> map) {
    return Translation(
      translationId: map['translation_id'] as String,
      languageCode: map['language_code'] as String,
      translatorName: map['translator_name'] as String,
      translatorId: map['translator_id'] as String,
      version: map['version'] as String,
      ayahId: map['ayah_id'] as String,
      text: map['text'] as String,
      copyright: map['copyright'] as String?,
      sourceUrl: map['source_url'] as String?,
    );
  }
}

class Bookmark {
  final String bookmarkId;
  final String? userId;
  final String ayahId;
  final int surahNumber;
  final int ayahNumber;
  final String? folderId;
  final String? label;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;

  Bookmark({
    required this.bookmarkId,
    this.userId,
    required this.ayahId,
    required this.surahNumber,
    required this.ayahNumber,
    this.folderId,
    this.label,
    this.color,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookmark_id': bookmarkId,
      'user_id': userId,
      'ayah_id': ayahId,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'folder_id': folderId,
      'label': label,
      'color': color,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'synced_at': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      bookmarkId: map['bookmark_id'] as String,
      userId: map['user_id'] as String?,
      ayahId: map['ayah_id'] as String,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      folderId: map['folder_id'] as String?,
      label: map['label'] as String?,
      color: map['color'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      syncedAt: map['synced_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['synced_at'] as int)
          : null,
    );
  }
}

class Note {
  final String noteId;
  final String? userId;
  final String ayahId;
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final bool isEncrypted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;

  Note({
    required this.noteId,
    this.userId,
    required this.ayahId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    this.isEncrypted = false,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'note_id': noteId,
      'user_id': userId,
      'ayah_id': ayahId,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'text': text,
      'is_encrypted': isEncrypted ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'synced_at': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      noteId: map['note_id'] as String,
      userId: map['user_id'] as String?,
      ayahId: map['ayah_id'] as String,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      text: map['text'] as String,
      isEncrypted: (map['is_encrypted'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      syncedAt: map['synced_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['synced_at'] as int)
          : null,
    );
  }
}

class Highlight {
  final String highlightId;
  final String? userId;
  final String ayahId;
  final int surahNumber;
  final int ayahNumber;
  final String color;
  final DateTime createdAt;
  final DateTime? syncedAt;

  Highlight({
    required this.highlightId,
    this.userId,
    required this.ayahId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.color,
    required this.createdAt,
    this.syncedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'highlight_id': highlightId,
      'user_id': userId,
      'ayah_id': ayahId,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'color': color,
      'created_at': createdAt.millisecondsSinceEpoch,
      'synced_at': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory Highlight.fromMap(Map<String, dynamic> map) {
    return Highlight(
      highlightId: map['highlight_id'] as String,
      userId: map['user_id'] as String?,
      ayahId: map['ayah_id'] as String,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      color: map['color'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      syncedAt: map['synced_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['synced_at'] as int)
          : null,
    );
  }
}

