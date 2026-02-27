import 'package:flutter/material.dart';

class AnswerKeyPage extends StatelessWidget {
  final Map<String, dynamic> pageData;
  final Function(String)? onNavigateToPage;

  const AnswerKeyPage({
    Key? key,
    required this.pageData,
    this.onNavigateToPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = pageData['title'] as String? ?? 'Answer key';
    final content = pageData['content'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87, width: 2.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'SassoonPrimary',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Answer entries
          for (var item in content)
            _buildAnswerItem(item as Map<String, dynamic>),
            
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildAnswerItem(Map<String, dynamic> item) {
    final activityLabel = item['activityLabel'] as String? ?? '';
    final answerText = item['answer'] as String? ?? '';
    final hasTable = item['hasTable'] as bool? ?? false;
    final hasA48Image = item['hasA48Image'] as bool? ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (activityLabel.isNotEmpty && onNavigateToPage != null) {
              // Expected format "A1." -> "A1"
              final cleanLabel = activityLabel.replaceAll('.', '').trim();
              onNavigateToPage!(cleanLabel);
            }
          },
          borderRadius: BorderRadius.circular(12),
          hoverColor: Colors.indigo.shade50,
          splashColor: Colors.indigo.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main text answer
                if (answerText.isNotEmpty && !hasA48Image)
             RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'SassoonPrimary',
                  fontSize: 22,
                  color: Colors.black87,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '$activityLabel ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: answerText),
                ],
              ),
            ),
          
          if (hasA48Image) ...[
            Text(
              activityLabel,
              style: const TextStyle(
                fontFamily: 'SassoonPrimary',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildA48ImageMock(),
          ],

        if (hasTable) ...[
          const SizedBox(height: 16),
          _buildTable(item['tableData'] as Map<String, dynamic>),
        ],
      ],
    ),
  ),
),
      ),
    );
  }

  Widget _buildA48ImageMock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'I Am Learn-ing!',
            style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Connect each verb to its -ing form:',
            style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18),
          ),
          const SizedBox(height: 16),
          // Simplified text representation of the matching diagram
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('go', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('do', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('jump', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('be', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('play', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('say', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                ],
              ),
              Icon(Icons.compare_arrows, size: 40, color: Colors.grey),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('going', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('saying', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('playing', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('doing', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('jumping', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                  SizedBox(height: 8),
                  Text('being', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Add -ing to the end of these verbs and rewrite them.',
            style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: const [
              Text('buy (buying)', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
              Text('fly (flying)', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
              Text('help (helping)', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
              Text('see (seeing)', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
              Text('eat (eating)', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
              Text('rain (raining)', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTable(Map<String, dynamic> tableData) {
    final headers = tableData['headers'] as List<dynamic>? ?? [];
    final rows = tableData['rows'] as List<dynamic>? ?? [];

    return Table(
      border: TableBorder.all(color: Colors.black87, width: 1.5),
      columnWidths: {
        for (int i = 0; i < headers.length; i++) i: const FlexColumnWidth(1),
      },
      children: [
        // Header row if not empty
        if (headers.isNotEmpty && headers.any((h) => h.toString().isNotEmpty))
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            children: headers.map((header) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  header.toString(),
                  style: const TextStyle(
                    fontFamily: 'SassoonPrimary',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        // Data rows
        for (var row in rows)
          TableRow(
            children: (row as List<dynamic>).map((cell) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  cell.toString(),
                  style: const TextStyle(
                    fontFamily: 'SassoonPrimary',
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
