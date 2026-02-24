import '../models/reward_models.dart';

class StickerRepository {
  static final List<Sticker> availableStickers = [
    Sticker(id: 's1', name: 'Cool Fox', assetPath: 'assets/stickers/fox_cool.png', category: 'Characters'),
    Sticker(id: 's2', name: 'Star Cat', assetPath: 'assets/stickers/cat_star.png', category: 'Characters'),
    Sticker(id: 's3', name: 'Happy Apple', assetPath: 'assets/stickers/apple_happy.png', category: 'Fruits'),
    Sticker(id: 's4', name: 'Rocket Ship', assetPath: 'assets/stickers/rocket.png', category: 'Space'),
    Sticker(id: 's5', name: 'Magic Wand', assetPath: 'assets/stickers/wand.png', category: 'Magic'),
  ];

  /// getStickerBook - Fetches the sticker book for a specific student.
  Future<StickerBook> getStickerBook(String studentId) async {
    // Mocking a fetch from local storage or Firestore
    return StickerBook(
      studentId: studentId,
      unlockedStickerIds: ['s1'],
      totalStickersEarned: 1,
    );
  }

  /// unlockRandomSticker - Unlocks a new random sticker for the student.
  Future<Sticker> unlockRandomSticker(String studentId) async {
    // For now, just return a random sticker from the available list
    final sticker = availableStickers[DateTime.now().millisecond % availableStickers.length];
    return sticker;
  }
}
