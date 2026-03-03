import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import '../utils/responsive_helper.dart';

class PictureFillInGrid extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final int? columns; // Optional override
  final ValueChanged<bool>? onStatusChanged;

  const PictureFillInGrid({
    Key? key,
    required this.entries,
    this.columns,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<PictureFillInGrid> createState() => _PictureFillInGridState();
}

class _PictureFillInGridState extends State<PictureFillInGrid> {
  late List<String> _answers;
  bool _isAllComplete = false;

  @override
  void initState() {
    super.initState();
    _answers = List.generate(widget.entries.length, (_) => '');
  }

  void _checkStatus() {
    bool isComplete = true;
    for (int i = 0; i < widget.entries.length; i++) {
      if (_answers[i].toLowerCase() !=
          widget.entries[i]['answer'].toString().toLowerCase()) {
        isComplete = false;
        break;
      }
    }
    if (isComplete && !_isAllComplete) {
      setState(() => _isAllComplete = true);
      if (widget.onStatusChanged != null) {
        widget.onStatusChanged!(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.componentScale(context);
    final int crossAxisCount = widget.columns ?? 
        ResponsiveHelper.getResponsiveGridCount(
          context: context, 
          mobile: 1, 
          tablet: 2, 
          desktop: 3
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: EdgeInsets.fromLTRB(24 * scale, 24 * scale, 24 * scale, 100 * scale),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.85, // Adjust for premium look
            crossAxisSpacing: 24 * scale,
            mainAxisSpacing: 24 * scale,
          ),
          itemCount: widget.entries.length,
          itemBuilder: (context, index) {
            final entry = widget.entries[index];
            final partialParts = (entry['partial'] as String).split('__');
            final prefix = partialParts.isNotEmpty ? partialParts[0] : '';
            final suffix = partialParts.length > 1 ? partialParts[1] : '';
            final isCorrect = _answers[index].toLowerCase() == 
                entry['answer'].toString().toLowerCase();

            return AspectRatio(
              aspectRatio: 0.85,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.indigo.shade50.withOpacity(0.5)],
                  ),
                  borderRadius: BorderRadius.circular(24 * scale),
                  border: Border.all(
                    color: isCorrect 
                        ? Colors.green.withOpacity(0.3) 
                        : Colors.blueGrey.withOpacity(0.2), 
                    width: 2
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15 * scale,
                      offset: Offset(0, 6 * scale),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16 * scale),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Image
                    Expanded(
                      flex: 4,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: VectorGraphic(
                          assetName: entry['imageId'],
                          size: 140 * scale,
                        ),
                      ),
                    ),
                    
                    // Word Row
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (prefix.isNotEmpty)
                            Text(
                              prefix,
                              style: TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: ResponsiveHelper.responsiveFontSize(context, 32),
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          
                          // Input Box
                          Container(
                            width: 70 * scale,
                            height: 55 * scale,
                            margin: EdgeInsets.symmetric(horizontal: 6 * scale),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isCorrect ? Colors.green : Colors.indigo.shade300, 
                                  width: 3
                                )
                              ),
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, 32),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SassoonPrimary',
                                color: isCorrect ? Colors.green.shade700 : Colors.indigo,
                              ),
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                setState(() => _answers[index] = val);
                                _checkStatus();
                              },
                            ),
                          ),

                          if (suffix.isNotEmpty)
                            Text(
                              suffix,
                              style: TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: ResponsiveHelper.responsiveFontSize(context, 32),
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Feedback Icon
                    if (isCorrect)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Icon(Icons.check_circle, color: Colors.green, size: 24 * scale),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
