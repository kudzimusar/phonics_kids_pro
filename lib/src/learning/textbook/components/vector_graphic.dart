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
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 8),
                  blurRadius: 15,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: _buildGraphicContent(),
          ),
        );
      },
    );
  }

  Widget _buildGraphicContent() {
    // Priority 1: Check for PNG asset in common locations
    // Use lowercased name for case-insensitive matching in the asset bundle
    final String assetPath = 'assets/images/${widget.assetName.toLowerCase()}.png';
    
    // Note: In a real app we'd use rootBundle to check existence, 
    // but for this prototype we'll assume the existence if named correctly.
    // For now, we fallback to emoji if we can't find it.
    
    return ClipOval(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            _getEmojiForAsset(widget.assetName),
            style: TextStyle(fontSize: widget.size * 0.55),
          ),
          // Attempt to load image overlay
          Image.asset(
            assetPath,
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
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
    if (lowerName.contains('mouth') || lowerName.contains('lip')) return '👄';
    if (lowerName.contains('green')) return '🟩';
    
    // --- A21: Digraph words ---
    if (lowerName.contains('wheel')) return '🚲';
    if (lowerName.contains('photo')) return '📷';
    if (lowerName.contains('shell')) return '🐚';
    if (lowerName.contains('cheese')) return '🧀';
    if (lowerName.contains('path')) return '🛤️';
    if (lowerName.contains('ghost')) return '👻';
    if (lowerName.contains('knight')) return '🏇';
    if (lowerName.contains('wing')) return '🦅';
    if (lowerName.contains('write') || lowerName.contains('pencil')) return '✏️';
    if (lowerName.contains('nail')) return '🔨';
    if (lowerName.contains('glue')) return '🧴';
    if (lowerName.contains('book')) return '📚';
    if (lowerName.contains('leaf')) return '🍃';
    if (lowerName.contains('soap')) return '🧼';
    if (lowerName.contains('coin')) return '🪙';
    // --- A29: Consonant Blend words ---
    if (lowerName.contains('block') || lowerName.contains('blocks')) return '🧱';
    if (lowerName.contains('branch')) return '🌿';
    if (lowerName.contains('clam')) return '🦪';
    if (lowerName.contains('crow')) return '🐦‍⬛';
    if (lowerName.contains('dragon')) return '🐉';
    if (lowerName.contains('fruit')) return '🍇';
    if (lowerName.contains('glitter')) return '✨';
    if (lowerName.contains('grape')) return '🍇';
    if (lowerName.contains('plane')) return '✈️';
    if (lowerName.contains('pretzel')) return '🥨';
    if (lowerName.contains('slug')) return '🐌';
    if (lowerName.contains('smoke')) return '💨';
    if (lowerName.contains('space')) return '🪐';
    if (lowerName.contains('stove')) return '🍳';
    if (lowerName.contains('strong') || lowerName.contains('muscle')) return '💪';
    if (lowerName.contains('splash')) return '💦';
    // --- A28: Spot the Blends words ---
    if (lowerName.contains('bubble') || lowerName.contains('clean')) return '🫧';
    if (lowerName.contains('scarf')) return '🧣';
    if (lowerName.contains('slide')) return '🛝';
    // --- A31: Balloon words ---
    if (lowerName.contains('fling') || lowerName.contains('ring')) return '💍';
    if (lowerName.contains('prime')) return '🔢';
    if (lowerName.contains('travel')) return '🧳';
    if (lowerName.contains('stork')) return '🦢';
    // --- A33: Blend fill words ---
    if (lowerName.contains('glove') || lowerName.contains('ove')) return '🧤';
    if (lowerName.contains('snail')) return '🐌';
    if (lowerName.contains('clock')) return '🕐';
    if (lowerName.contains('flower')) return '🌸';
    if (lowerName.contains('fly')) return '🪰';
    if (lowerName.contains('sled')) return '🛷';
    // --- A34/A35: Diphthong words ---
    if (lowerName.contains('cow') || lowerName.contains('moo')) return '🐄';
    if (lowerName.contains('owl')) return '🦉';
    if (lowerName.contains('foot')) return '🦶';
    if (lowerName.contains('boot')) return '🥾';
    if (lowerName.contains('law') || lowerName.contains('author')) return '⚖️';
    if (lowerName.contains('house')) return '🏠';
    if (lowerName.contains('oil') || lowerName.contains('oi')) return '🫙';
    if (lowerName.contains('boy') || lowerName.contains('toy')) return '🧸';
    if (lowerName.contains('fawn') || lowerName.contains('aw')) return '🦌';
    if (lowerName.contains('toad')) return '🐊';
    if (lowerName.contains('hook')) return '🪝';
    if (lowerName.contains('pool')) return '🏊';
    if (lowerName.contains('moon')) return '🌕';
    if (lowerName.contains('book')) return '📖';
    if (lowerName.contains('cook')) return '🧑‍🍳';
    if (lowerName.contains('wood')) return '🪵';
    if (lowerName.contains('tooth') || lowerName.contains('teeth')) return '🦷';
    if (lowerName.contains('soup')) return '🍲';

    return '🌟'; // Default generic icon fallback
  }
}
