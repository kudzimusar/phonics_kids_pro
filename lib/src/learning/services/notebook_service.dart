import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notebook_entry.dart';

class NotebookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'notebook_entries';

  Future<void> saveEntry(NotebookEntry entry) async {
    await _firestore.collection(_collectionPath).doc(entry.id).set(entry.toMap());
  }

  Stream<List<NotebookEntry>> getEntriesForModule(String moduleId) {
    return _firestore
        .collection(_collectionPath)
        .where('moduleId', isEqualTo: moduleId)
        .snapshots()
        .map((snapshot) {
          final entries = snapshot.docs
            .map((doc) => NotebookEntry.fromMap(doc.data()))
            .toList();
          // Sort by timestamp descending in-memory
          entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return entries;
        });
  }

  Future<void> logMistake({
    required String moduleId,
    required String word,
    String? audioUrl,
  }) async {
    final entry = NotebookEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      moduleId: moduleId,
      type: NotebookEntryType.mistake,
      content: 'Mistake in: $word',
      audioUrl: audioUrl,
      timestamp: DateTime.now(),
      needsRestudy: true,
    );
    await saveEntry(entry);
  }
}
