enum UserRole { parent, teacher, student }

class AppUser {
  final String id;
  final String email;
  final UserRole role;
  final String? schoolId; // Null if parent
  final List<String> classroomIds;
  final bool hasActiveSubscription; // NEW: tracks Stripe subscription

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.schoolId,
    this.classroomIds = const [],
    this.hasActiveSubscription = false, // Default to false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role.index,
      'schoolId': schoolId,
      'classroomIds': classroomIds,
      'hasActiveSubscription': hasActiveSubscription,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values[map['role'] ?? 0],
      schoolId: map['schoolId'],
      classroomIds: List<String>.from(map['classroomIds'] ?? []),
      hasActiveSubscription: map['hasActiveSubscription'] ?? false,
    );
  }
}

