import '../models/classroom.dart';
import '../models/student_profile.dart';

class SchoolRepository {
  // Mock data for demonstration and rapid UI prototyping
  static final List<Classroom> mockClassrooms = [
    Classroom(
      id: 'class_101',
      name: 'Bright Sparks - Grade 1',
      teacherId: 'teacher_001',
      joinCode: 'LEARN1',
      studentIds: ['stu_1', 'stu_2', 'stu_3'],
    ),
    Classroom(
      id: 'class_102',
      name: 'Early Birds - Kindergarten',
      teacherId: 'teacher_001',
      joinCode: 'ABCDEF',
      studentIds: ['stu_4', 'stu_5'],
    ),
  ];

  static final List<StudentProfile> mockStudents = [
    StudentProfile(
      id: 'stu_1',
      name: 'Alice Johnson',
      classroomId: 'class_101',
      lessonScores: {'A1': 0.95, 'A2': 0.88, 'A3': 0.75},
      totalLessonsCompleted: 12,
    ),
    StudentProfile(
      id: 'stu_2',
      name: 'Bob Smith',
      classroomId: 'class_101',
      lessonScores: {'A1': 0.70, 'A2': 0.65},
      totalLessonsCompleted: 5,
    ),
    StudentProfile(
      id: 'stu_4',
      name: 'Charlie Brown',
      classroomId: 'class_102',
      lessonScores: {'A1': 0.99},
      totalLessonsCompleted: 2,
    ),
  ];

  /// getTeacherClassrooms - Fetches all classrooms managed by a specific teacher.
  Future<List<Classroom>> getTeacherClassrooms(String teacherId) async {
    // In production, this would query Firestore:
    // _db.collection('classrooms').where('teacherId', isEqualTo: teacherId).get();
    return mockClassrooms.where((c) => c.teacherId == teacherId).toList();
  }

  /// getClassroomStudents - Fetches all student profiles within a classroom.
  Future<List<StudentProfile>> getClassroomStudents(String classroomId) async {
    return mockStudents.where((s) => s.classroomId == classroomId).toList();
  }

  /// joinClassroom - Allows a student to join a classroom using a 6-digit code.
  Future<bool> joinClassroom(String studentId, String joinCode) async {
    try {
      // Find the classroom with the matching join code
      final index = mockClassrooms.indexWhere((c) => c.joinCode.toUpperCase() == joinCode.toUpperCase());
      
      if (index == -1) return false;

      final classroom = mockClassrooms[index];
      
      // Prevent duplicates
      if (classroom.studentIds.contains(studentId)) return true;

      // Update the classroom with the new student ID
      mockClassrooms[index] = Classroom(
        id: classroom.id,
        name: classroom.name,
        teacherId: classroom.teacherId,
        joinCode: classroom.joinCode,
        studentIds: [...classroom.studentIds, studentId],
      );

      return true;
    } catch (e) {
      print('Error joining classroom: $e');
      return false;
    }
  }
}
