import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../textbook/components/phonic_fox_narrator.dart';
import '../textbook/components/vowel_consonant_word.dart';
import '../services/notebook_service.dart';
import '../models/notebook_entry.dart';

class NotebookOverlay extends StatefulWidget {
  final String moduleId;
  final VoidCallback onDismiss;

  const NotebookOverlay({
    Key? key,
    required this.moduleId,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<NotebookOverlay> createState() => _NotebookOverlayState();
}

class _NotebookOverlayState extends State<NotebookOverlay> {
  final List<List<DrawingPoint>> _lines = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0), // Japanese Washi-like off-white
      body: Stack(
        children: [
          // 1. Textured Background Layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/japanese_stationery_texture.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),
          
          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 30, color: Colors.indigo),
                      onPressed: widget.onDismiss,
                    ),
                    const Text(
                      'Fox Notebook',
                      style: TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: 28,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildToolsSelection(),
                  ],
                ),
              ),
              
              Expanded(
                child: Row(
                  children: [
                    // Left Panel: Entry List
                    Container(
                      width: 320,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.orange.shade100, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: PhonicFoxNarrator(
                              text: "Let's master our mistakes!",
                              state: FoxState.thinking,
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder<List<NotebookEntry>>(
                              stream: NotebookService().getEntriesForModule(widget.moduleId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(child: Text("Connection issue: ${snapshot.error}", style: const TextStyle(fontSize: 12)));
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final entries = snapshot.data ?? [];
                                if (entries.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "No entries yet.\nSend some from the textbook!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: entries.length,
                                  itemBuilder: (context, index) => _buildEntryTile(entries[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Right Panel: Drawing Canvas
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: GestureDetector(
                            onPanStart: (details) {
                              setState(() {
                                _lines.add([
                                  DrawingPoint(
                                    offset: details.localPosition,
                                    paint: Paint()
                                      ..color = _selectedColor
                                      ..strokeWidth = _strokeWidth
                                      ..strokeCap = StrokeCap.round
                                      ..style = PaintingStyle.stroke,
                                  )
                                ]);
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                _lines.last.add(
                                  DrawingPoint(
                                    offset: details.localPosition,
                                    paint: Paint()
                                      ..color = _selectedColor
                                      ..strokeWidth = _strokeWidth
                                      ..strokeCap = StrokeCap.round
                                      ..style = PaintingStyle.stroke,
                                  ),
                                );
                              });
                            },
                            child: Listener(
                              onPointerDown: (event) {
                                if (event.kind == PointerDeviceKind.stylus) {
                                  _strokeWidth = (event.pressure * 10).clamp(1.0, 10.0);
                                } else {
                                  _strokeWidth = 3.0; 
                                }
                              },
                              child: CustomPaint(
                                painter: NotebookPainter(_lines),
                                size: Size.infinite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSelection() {
    return Row(
      children: [
        _buildColorButton(Colors.red),
        _buildColorButton(Colors.blue),
        _buildColorButton(Colors.black),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.undo, color: Colors.indigo),
          onPressed: () {
            if (_lines.isNotEmpty) {
              setState(() => _lines.removeLast());
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
          onPressed: () => setState(() => _lines.clear()),
        ),
      ],
    );
  }

  Widget _buildEntryTile(NotebookEntry entry) {
    // Extract the word if it's a mistake entry like "Mistake in: word"
    String textToShow = entry.content;
    if (entry.type == NotebookEntryType.mistake && textToShow.startsWith('Mistake in: ')) {
      textToShow = textToShow.replaceFirst('Mistake in: ', '');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: entry.type == NotebookEntryType.mistake ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entry.type == NotebookEntryType.mistake ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.type == NotebookEntryType.mistake ? "Mistake" : "Cloned Text",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: entry.type == NotebookEntryType.mistake ? Colors.red.shade800 : Colors.blue.shade800,
                ),
              ),
              Icon(
                entry.type == NotebookEntryType.mistake ? Icons.warning_rounded : Icons.copy_rounded,
                size: 16,
                color: entry.type == NotebookEntryType.mistake ? Colors.red.shade400 : Colors.blue.shade400,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Use VowelConsonantWord for A3 Red/Blue logic
          VowelConsonantWord(word: textToShow),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.orange : Colors.grey.shade300,
            width: _selectedColor == color ? 3 : 1,
          ),
        ),
      ),
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class NotebookPainter extends CustomPainter {
  final List<List<DrawingPoint>> lines;

  NotebookPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i].offset, line[i+1].offset, line[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant NotebookPainter oldDelegate) => true;
}
