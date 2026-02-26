import 'package:flutter/material.dart';

class VectorGraphic extends StatefulWidget {
  final String assetName;
  final double size;

  const VectorGraphic({
    Key? key,
    required this.assetName,
    this.size = 48,
  }) : super(key: key);

  @override
  State<VectorGraphic> createState() => _VectorGraphicState();
}

class _VectorGraphicState extends State<VectorGraphic> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.indigo.shade100, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade200.withOpacity(0.5),
                  offset: const Offset(0, 6),
                  blurRadius: 12,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _getEmojiForAsset(widget.assetName),
              style: TextStyle(fontSize: widget.size * 0.55),
            ),
          ),
        );
      },
    );
  }

  String _getEmojiForAsset(String name) {
    final lowerName = name.toLowerCase();
    
    // Maps common phonics keywords to emojis
    if (lowerName.contains('apple')) return '🍎';
    if (lowerName.contains('ball')) return '⚽';
    if (lowerName.contains('cake')) return '🍰';
    if (lowerName.contains('cat')) return '🐱';
    if (lowerName.contains('dog')) return '🐶';
    if (lowerName.contains('pig')) return '🐷';
    if (lowerName.contains('farm')) return '🚜';
    if (lowerName.contains('feet')) return '👣';
    if (lowerName.contains('bus')) return '🚌';
    if (lowerName.contains('ham')) return '🍖';
    if (lowerName.contains('fox')) return '🦊';
    if (lowerName.contains('jam')) return '🍯';
    if (lowerName.contains('pail')) return '🪣';
    if (lowerName.contains('gift')) return '🎁';
    if (lowerName.contains('bird')) return '🐦';
    if (lowerName.contains('boat')) return '⛵';
    if (lowerName.contains('flag')) return '🏁';
    if (lowerName.contains('girl')) return '👧';
    if (lowerName.contains('tree')) return '🌳';
    if (lowerName.contains('flower') || lowerName.contains('plant')) return '🌻';
    if (lowerName.contains('moose')) return '🦌';
    if (lowerName.contains('umbrella')) return '☂️';
    if (lowerName.contains('octopus')) return '🐙';
    if (lowerName.contains('rainbow')) return '🌈';
    if (lowerName.contains('watermelon')) return '🍉';
    if (lowerName.contains('dinosaur')) return '🦖';
    if (lowerName.contains('egg')) return '🥚';
    if (lowerName.contains('fire')) return '🔥';
    if (lowerName.contains('gorilla')) return '🦍';
    if (lowerName.contains('house') || lowerName.contains('home')) return '🏠';
    if (lowerName.contains('igloo')) return '🧊';
    if (lowerName.contains('jello')) return '🍮';
    if (lowerName.contains('kite')) return '🪁';
    if (lowerName.contains('lamp')) return '🪔';
    if (lowerName.contains('milk')) return '🥛';
    if (lowerName.contains('night')) return '🌙';
    if (lowerName.contains('piano')) return '🎹';
    if (lowerName.contains('queen')) return '👑';
    if (lowerName.contains('ship')) return '🚢';
    if (lowerName.contains('tractor')) return '🚜';
    if (lowerName.contains('van')) return '🚐';
    if (lowerName.contains('whale')) return '🐳';
    if (lowerName.contains('box')) return '📦';
    if (lowerName.contains('yogurt')) return '🥣';
    if (lowerName.contains('zipper')) return '🤐';
    if (lowerName.contains('cot') || lowerName.contains('bed')) return '🛏️';
    if (lowerName.contains('sand')) return '⏳';
    if (lowerName.contains('top')) return '🌪️';
    if (lowerName.contains('paw')) return '🐾';
    if (lowerName.contains('star')) return '⭐';
    if (lowerName.contains('duck')) return '🦆';
    if (lowerName.contains('rat')) return '🐀';
    if (lowerName.contains('car')) return '🚗';
    if (lowerName.contains('fern')) return '🌿';
    if (lowerName.contains('fork') || lowerName.contains('spit')) return '🍴';
    if (lowerName.contains('hurt') || lowerName.contains('bandaid')) return '🩹';
    if (lowerName.contains('crab')) return '🦀';
    if (lowerName.contains('frog')) return '🐸';
    if (lowerName.contains('plum')) return '🍑';
    if (lowerName.contains('pen')) return '🖊️';
    if (lowerName.contains('mug')) return '☕';
    if (lowerName.contains('sun')) return '☀️';
    if (lowerName.contains('hat')) return '🎩';
    if (lowerName.contains('log')) return '🪵';
    if (lowerName.contains('green')) return '🟩';
    
    return '🌟'; // Default generic icon fallback
  }
}
