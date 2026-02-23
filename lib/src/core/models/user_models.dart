enum SubscriptionTier { free, pro, school }

class StudentProfile {
  final String id;
  final String displayName;
  final int age;
  final String currentLevelId;

  StudentProfile({
    required this.id,
    required this.displayName,
    required this.age,
    required this.currentLevelId,
  });

  factory StudentProfile.fromMap(Map<String, dynamic> map, String docId) {
    return StudentProfile(
      id: docId,
      displayName: map['display_name'] ?? '',
      age: map['age'] ?? 0,
      currentLevelId: map['current_level_id'] ?? 'A1',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'display_name': displayName,
      'age': age,
      'current_level_id': currentLevelId,
    };
  }
}

class PhonicsUser {
  final String uid;
  final String email;
  final SubscriptionTier tier;
  final List<StudentProfile> students;

  PhonicsUser({
    required this.uid,
    required this.email,
    this.tier = SubscriptionTier.free,
    required this.students,
  });

  factory PhonicsUser.fromMap(Map<String, dynamic> map, String docId) {
    return PhonicsUser(
      uid: docId,
      email: map['email'] ?? '',
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.toString() == 'SubscriptionTier.${map['sub_tier']}',
        orElse: () => SubscriptionTier.free,
      ),
      students: (map['students'] as List<dynamic>?)
              ?.map((s) => StudentProfile.fromMap(s, s['id'] ?? ''))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'sub_tier': tier.toString().split('.').last,
      // Students usually saved in sub-collection, but here's a map method if nested.
      'students': students.map((s) => s.toMap()).toList(),
    };
  }
}
