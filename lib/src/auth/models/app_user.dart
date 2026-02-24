enum UserRole { parent, teacher, student }

class AppUser {
  final String id;
  final String email;
  final UserRole role;
  final String? schoolId; // Null if parent
  final List<String> classroomIds;

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.schoolId,
    this.classroomIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role.index,
      'schoolId': schoolId,
      'classroomIds': classroomIds,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'],
      role: UserRole.values[map['role'] ?? 0],
      schoolId: map['schoolId'],
      classroomIds: List<String>.from(map['classroomIds'] ?? []),
    );
  }
}
