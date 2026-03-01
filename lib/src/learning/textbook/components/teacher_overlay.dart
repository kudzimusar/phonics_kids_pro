import 'package:flutter/material.dart';

class TeacherOverlay extends StatelessWidget {
  final Map<String, dynamic> pageData;
  final VoidCallback? onJumpToAnswerKey;

  const TeacherOverlay({
    Key? key, 
    required this.pageData,
    this.onJumpToAnswerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      width: 320,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.school, color: Colors.indigo),
                  const SizedBox(width: 8),
                  const Text(
                    "Teacher Notes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      pageData['activityLabel'] ?? "Intro",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1.5),
              if (pageData['teacherNotes'] != null) ...[
                const Text(
                  "Pedagogy Guide:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  pageData['teacherNotes'] as String,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 16),
              ],
              if (pageData['answerKey'] != null) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: onJumpToAnswerKey,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Go To Activity Key",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "Quick Reference",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pageData['answerKey'] as String,
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
