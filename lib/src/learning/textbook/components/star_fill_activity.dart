import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import '../utils/responsive_helper.dart';

class StarFillActivity extends StatefulWidget {
  final List<Map<String, dynamic>> entries;

  const StarFillActivity({Key? key, required this.entries}) : super(key: key);

  @override
  State<StarFillActivity> createState() => _StarFillActivityState();
}

class _StarFillActivityState extends State<StarFillActivity> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.entries.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridCount(
          context: context, 
          mobile: 1, 
          tablet: 2, 
          desktop: 2
        ),
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 2.5 : 2.0,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        final entry = widget.entries[index];
        final partial = entry['partial'] as String;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.amber.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.shade100,
                offset: const Offset(0, 4),
                blurRadius: 8,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VectorGraphic(assetName: 'star', size: 64),
              const SizedBox(width: 16),
              Text(
                partial,
                style: const TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _controllers[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey.shade300, width: 4),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
