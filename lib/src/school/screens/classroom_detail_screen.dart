import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/classroom.dart';
import '../models/student_profile.dart';
import '../repositories/school_repository.dart';

class ClassroomDetailScreen extends StatelessWidget {
  final Classroom classroom;

  const ClassroomDetailScreen({Key? key, required this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F7FA);
    const primaryColor = Color(0xFF2D3E50);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          classroom.name,
          style: GoogleFonts.fredoka(color: primaryColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<StudentProfile>>(
        future: SchoolRepository().getClassroomStudents(classroom.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ClassroomStatsHeader(students: students),
                const SizedBox(height: 24),
                Text(
                  'Student Progress',
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return _StudentProgressTile(student: student);
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

class _ClassroomStatsHeader extends StatelessWidget {
  final List<StudentProfile> students;
  const _ClassroomStatsHeader({required this.students});

  @override
  Widget build(BuildContext context) {
    // Calculate average accuracy
    double totalAccuracy = 0;
    int scoreCount = 0;
    for (var s in students) {
      for (var score in s.lessonScores.values) {
        totalAccuracy += score;
        scoreCount++;
      }
    }
    final avgScore = scoreCount > 0 ? (totalAccuracy / scoreCount * 100).round() : 0;

    return Row(
      children: [
        _StatCard(label: 'Avg Accuracy', value: '$avgScore%', color: Colors.green),
        const SizedBox(width: 16),
        _StatCard(label: 'Lessons Done', value: '${students.fold(0, (sum, s) => sum + s.totalLessonsCompleted)}', color: Colors.orange),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.fredoka(fontSize: 24, color: color)),
          ],
        ),
      ),
    );
  }
}

class _StudentProgressTile extends StatelessWidget {
  final StudentProfile student;
  const _StudentProgressTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: Text(student.name[0], style: const TextStyle(color: Colors.blueAccent)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: student.totalLessonsCompleted / 20, // Example target
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text('${student.totalLessonsCompleted} / 20', style: GoogleFonts.quicksand(color: Colors.grey)),
        ],
      ),
    );
  }
}
