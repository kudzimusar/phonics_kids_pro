import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// createUserProfile - Initialises a new user profile in Firestore.
  Future<void> createUserProfile(AppUser user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  /// getUser - Fetches the user profile by ID.
  Future<AppUser?> getUser(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!);
    }
    return null;
  }

  /// getUserStream - Stream for real-time profile updates (like subscription unlocks).
  Stream<AppUser?> getUserStream(String id) {
    return _db.collection('users').doc(id).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        try {
          return AppUser.fromMap(doc.data()!);
        } catch (e, stackTrace) {
          // If parsing fails (e.g., bad data structure), return null instead of crashing the stream
          // In production, we should log this to Crashlytics
          print('Error parsing user stream data: $e');
          print(stackTrace);
          return null;
        }
      }
      return null;
    });
  }

  /// updateUserRole - Updates the role for a user (e.g., during onboarding).
  Future<void> updateUserRole(String id, UserRole role) async {
    await _db.collection('users').doc(id).update({'role': role.index});
  }
}

