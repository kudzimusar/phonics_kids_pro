class Sticker {
  final String id;
  final String name;
  final String assetPath;
  final String category; // e.g., 'Animals', 'Space', 'Alphabet'

  Sticker({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'assetPath': assetPath,
      'category': category,
    };
  }

  factory Sticker.fromMap(Map<String, dynamic> map) {
    return Sticker(
      id: map['id'],
      name: map['name'],
      assetPath: map['assetPath'],
      category: map['category'],
    );
  }
}

class StickerBook {
  final String studentId;
  final List<String> unlockedStickerIds;
  final int totalStickersEarned;

  StickerBook({
    required this.studentId,
    this.unlockedStickerIds = const [],
    this.totalStickersEarned = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'unlockedStickerIds': unlockedStickerIds,
      'totalStickersEarned': totalStickersEarned,
    };
  }

  factory StickerBook.fromMap(Map<String, dynamic> map) {
    return StickerBook(
      studentId: map['studentId'],
      unlockedStickerIds: List<String>.from(map['unlockedStickerIds'] ?? []),
      totalStickersEarned: map['totalStickersEarned'] ?? 0,
    );
  }
}
