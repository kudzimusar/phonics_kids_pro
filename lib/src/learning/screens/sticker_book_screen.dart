import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/sticker_repository.dart';
import '../models/reward_models.dart';
import '../textbook/utils/responsive_helper.dart';
import '../textbook/components/ui_styles.dart';
import 'dart:ui';

class StickerBookScreen extends StatelessWidget {
  const StickerBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF9FBFB);
    const primaryColor = Color(0xFF37474F);

    return SafeArea(
      child: FutureBuilder<StickerBook>(
        future: StickerRepository().getStickerBook('student_001'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final unlockedIds = snapshot.data?.unlockedStickerIds ?? [];
          final allStickers = StickerRepository.availableStickers;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Sticker Collection',
                  style: GoogleFonts.fredoka(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 24),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.getResponsiveGridCount(
                        context: context,
                        mobile: MediaQuery.of(context).size.width < 380 ? 2 : 3,
                        tablet: 4,
                        desktop: 6,
                      ),
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
                ),
              ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnlocked
              ? Colors.orangeAccent.withOpacity(0.2)
              : Colors.blueGrey.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          if (isUnlocked)
            AppStyles.premiumShadow
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow for unlocked
          if (isUnlocked)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.orangeAccent.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          // Sticker Placeholder Icon
          Opacity(
            opacity: isUnlocked ? 1.0 : 0.2,
            child: Icon(
              Icons.stars_rounded, // Placeholder for actual sticker asset
              size: ResponsiveHelper.responsiveFontSize(context, 40),
              color: isUnlocked ? Colors.orangeAccent : Colors.grey,
            ),
          ),
          // Lock Overlay
          if (!isUnlocked)
            Positioned(
              bottom: 8,
              right: 8,
              child: Icon(
                Icons.lock_rounded,
                size: 16,
                color: Colors.blueGrey.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
