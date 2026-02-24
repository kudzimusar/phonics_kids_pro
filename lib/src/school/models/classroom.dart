class Classroom {
  final String id;
  final String name;
  final String teacherId;
  final String joinCode; // 6-digit alphanum code
  final List<String> studentIds;

  Classroom({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.joinCode,
    this.studentIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'teacherId': teacherId,
      'joinCode': joinCode,
      'studentIds': studentIds,
    };
  }

  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      id: map['id'],
      name: map['name'],
      teacherId: map['teacherId'],
      joinCode: map['joinCode'],
      studentIds: List<String>.from(map['studentIds'] ?? []),
    );
  }
}
