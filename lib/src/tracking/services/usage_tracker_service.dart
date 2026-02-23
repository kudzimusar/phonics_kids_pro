import 'package:cloud_firestore/cloud_firestore.dart';

class UsageTrackerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> logSkillAttempt({
    required String studentId,
    required String skillId, // e.g., 'A18_BOSSY_R'
    required double accuracy,
    required int durationMs,
  }) async {
    await _db.collection('usage_logs').add({
      'studentId': studentId,
      'skillId': skillId,
      'accuracy': accuracy,
      'duration': durationMs,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUsageLogs() {
    return _db.collection('usage_logs').orderBy('timestamp', descending: true).snapshots();
  }
}
