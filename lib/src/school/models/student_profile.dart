class StudentProfile {
  final String id;
  final String name;
  final String classroomId;
  final Map<String, double> lessonScores; // e.g., {'A1': 0.85, 'A2': 0.9}
  final int totalLessonsCompleted;

  StudentProfile({
    required this.id,
    required this.name,
    required this.classroomId,
    this.lessonScores = const {},
    this.totalLessonsCompleted = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classroomId': classroomId,
      'lessonScores': lessonScores,
      'totalLessonsCompleted': totalLessonsCompleted,
    };
  }

  factory StudentProfile.fromMap(Map<String, dynamic> map) {
    return StudentProfile(
      id: map['id'],
      name: map['name'],
      classroomId: map['classroomId'] ?? '',
      lessonScores: Map<String, double>.from(map['lessonScores'] ?? {}),
      totalLessonsCompleted: map['totalLessonsCompleted'] ?? 0,
    );
  }
}
