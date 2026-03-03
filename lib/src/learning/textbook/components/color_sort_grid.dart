import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// A41: Glued Sounds Color Sort
/// Color-coded key + word grid. User taps a word chip to cycle through the 4 colors.
class ColorSortGrid extends StatefulWidget {
  final List<Map<String, dynamic>> codes; // {label, color}
  final List<Map<String, dynamic>> words; // {word, gluedSound, answer}
  final String? instruction;
  final List<String> freePrompts;
  final ValueChanged<bool>? onStatusChanged;

  const ColorSortGrid({
    Key? key,
    required this.codes,
    required this.words,
    this.instruction,
    this.freePrompts = const [],
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<ColorSortGrid> createState() => _ColorSortGridState();
}

class _ColorSortGridState extends State<ColorSortGrid> {
  late final Map<String, String?> _selected;
  final Map<String, TextEditingController> _freeControllers = {};

  static const Map<String, Color> _colorMap = {
    'Red': Color(0xFFEF5350),
    'Blue': Color(0xFF1E88E5),
    'Green': Color(0xFF43A047),
    'Purple': Color(0xFF8E24AA),
  };

  static const Map<String, Color> _lightColorMap = {
    'Red': Color(0xFFFFEBEE),
    'Blue': Color(0xFFE3F2FD),
    'Green': Color(0xFFE8F5E9),
    'Purple': Color(0xFFF3E5F5),
  };

  @override
  void initState() {
    super.initState();
    _selected = {for (final w in widget.words) (w['word'] as String): null};
    for (final p in widget.freePrompts) {
      _freeControllers[p] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _freeControllers.values) c.dispose();
    super.dispose();
  }

  void _tapWord(String word) {
    final colorLabels = widget.codes.map((c) => c['color'] as String).toList();
    final current = _selected[word];
    final currentIndex = current == null ? -1 : colorLabels.indexOf(current);
    final nextIndex = (currentIndex + 1) % (colorLabels.length + 1);
    
    setState(() {
      _selected[word] = nextIndex == colorLabels.length ? null : colorLabels[nextIndex];
    });

    if (widget.onStatusChanged != null) {
      bool allCorrect = true;
      for (final wordData in widget.words) {
        if (!_isCorrect(wordData)) {
          allCorrect = false;
          break;
        }
      }
      if (allCorrect) {
        widget.onStatusChanged!(true);
      }
    }
  }

  bool _isCorrect(Map<String, dynamic> wordData) {
    final word = wordData['word'] as String;
    final answer = wordData['answer'] as String;
    return _selected[word] == answer;
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.componentScale(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Color key row
        Padding(
          padding: EdgeInsets.only(bottom: 24 * scale),
          child: Wrap(
            spacing: 16 * scale,
            runSpacing: 12 * scale,
            children: widget.codes.map((code) {
              final label = code['label'] as String;
              final colorLabel = code['color'] as String;
              final color = _colorMap[colorLabel] ?? Colors.grey;
              final lightColor = _lightColorMap[colorLabel] ?? Colors.grey.shade100;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 10 * scale),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightColor, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30 * scale),
                  border: Border.all(color: color.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 10 * scale,
                      offset: Offset(0, 4 * scale),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14 * scale, 
                      height: 14 * scale, 
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle)
                    ),
                    SizedBox(width: 8 * scale),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
                        fontWeight: FontWeight.bold,
                        color: color.darken(0.1),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        // 2. Word grid
        LayoutBuilder(
          builder: (context, constraints) {
            final int crossAxisCount = ResponsiveHelper.getResponsiveGridCount(
              context: context, 
              mobile: 2, 
              tablet: 3, 
              desktop: 4
            );
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12 * scale,
                mainAxisSpacing: 12 * scale,
                childAspectRatio: 2.5, // Wider chips
              ),
              itemCount: widget.words.length,
              itemBuilder: (context, index) {
                final wordData = widget.words[index];
                final word = wordData['word'] as String;
                final colorLabel = _selected[word];
                final correct = colorLabel != null && _isCorrect(wordData);

                final bgColor = colorLabel != null
                    ? (_lightColorMap[colorLabel] ?? Colors.grey.shade100)
                    : Colors.white;
                final borderColor = colorLabel != null
                    ? (_colorMap[colorLabel] ?? Colors.grey)
                    : Colors.blueGrey.withOpacity(0.1);

                return GestureDetector(
                  onTap: () => _tapWord(word),
                  child: AnimatedScale(
                    scale: colorLabel != null ? 1.02 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16 * scale),
                        border: Border.all(
                          color: colorLabel != null 
                              ? borderColor.withOpacity(0.5) 
                              : Colors.blueGrey.withOpacity(0.2), 
                          width: 2
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8 * scale,
                            offset: Offset(0, 4 * scale),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              word,
                              style: TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: ResponsiveHelper.responsiveFontSize(context, 22),
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey.shade900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (correct) ...[
                            SizedBox(width: 8 * scale),
                            Icon(Icons.check_circle, color: Colors.green, size: 20 * scale),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        
        // 3. Free response prompts
        if (widget.freePrompts.isNotEmpty) ...[
          SizedBox(height: 32 * scale),
          Text(
            'Write another word for each sound:',
            style: TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey.shade400,
            ),
          ),
          SizedBox(height: 16 * scale),
          Wrap(
            spacing: 16 * scale,
            runSpacing: 16 * scale,
            children: widget.freePrompts.map((prompt) {
              final color = widget.codes.firstWhere(
                (c) => (c['label'] as String).toLowerCase() == prompt.toLowerCase(),
                orElse: () => {'color': 'Blue'},
              )['color'] as String;
              final accentColor = _colorMap[color] ?? Colors.blue;

              return Container(
                constraints: BoxConstraints(maxWidth: 300 * scale),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 8 * scale),
                      decoration: BoxDecoration(
                        color: (_lightColorMap[color] ?? Colors.blue.shade50),
                        borderRadius: BorderRadius.circular(12 * scale),
                        border: Border.all(color: accentColor.withOpacity(0.4), width: 2),
                      ),
                      child: Text(
                        prompt,
                        style: TextStyle(
                          fontFamily: 'SassoonPrimary',
                          fontSize: ResponsiveHelper.responsiveFontSize(context, 18),
                          color: accentColor.darken(0.1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12 * scale),
                    Expanded(
                      child: TextField(
                        controller: _freeControllers[prompt],
                        decoration: InputDecoration(
                          hintText: 'your word...',
                          hintStyle: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, 18),
                            color: Colors.grey.shade400
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor.withOpacity(0.3), width: 3),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor, width: 3),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'SassoonPrimary',
                          fontSize: ResponsiveHelper.responsiveFontSize(context, 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        SizedBox(height: 100 * scale), // Extra padding for Nav Dock
      ],
    );
  }
}

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
