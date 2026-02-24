import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/sticker_repository.dart';
import '../models/reward_models.dart';

class StickerBookScreen extends StatelessWidget {
  const StickerBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF9FBFB);
    const primaryColor = Color(0xFF37474F);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Sticker Book',
          style: GoogleFonts.fredoka(color: primaryColor, fontSize: 24),
        ),
      ),
      body: FutureBuilder<StickerBook>(
        future: StickerRepository().getStickerBook('student_001'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final unlockedIds = snapshot.data?.unlockedStickerIds ?? [];
          final allStickers = StickerRepository.availableStickers;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: allStickers.length,
              itemBuilder: (context, index) {
                final sticker = allStickers[index];
                final isUnlocked = unlockedIds.contains(sticker.id);
                return _StickerSlot(sticker: sticker, isUnlocked: isUnlocked);
              },
            ),
          );
        },
      ),
    );
  }
}

class _StickerSlot extends StatelessWidget {
  final Sticker sticker;
  final bool isUnlocked;

  const _StickerSlot({required this.sticker, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: isUnlocked ? 1.0 : 0.2,
            child: Icon(
              Icons.stars_rounded, // Placeholder for actual sticker asset
              size: 50,
              color: isUnlocked ? Colors.orangeAccent : Colors.grey,
            ),
          ),
          if (!isUnlocked)
            const Icon(
              Icons.lock_rounded,
              size: 20,
              color: Colors.blueGrey,
            ),
        ],
      ),
    );
  }
}
