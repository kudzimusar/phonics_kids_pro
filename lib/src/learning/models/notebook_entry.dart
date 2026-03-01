import 'package:cloud_firestore/cloud_firestore.dart';

enum NotebookEntryType {
  manual,
  mistake,
  attachment,
}

class NotebookEntry {
  final String id;
  final String moduleId;
  final NotebookEntryType type;
  final String content; // JSON string for vector paths, or plain text
  final String? imageUrl;
  final String? audioUrl;
  final DateTime timestamp;
  final bool needsRestudy;

  NotebookEntry({
    required this.id,
    required this.moduleId,
    required this.type,
    required this.content,
    this.imageUrl,
    this.audioUrl,
    required this.timestamp,
    this.needsRestudy = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moduleId': moduleId,
      'type': type.name,
      'content': content,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'needsRestudy': needsRestudy,
    };
  }

  factory NotebookEntry.fromMap(Map<String, dynamic> map) {
    return NotebookEntry(
      id: map['id'] ?? '',
      moduleId: map['moduleId'] ?? '',
      type: NotebookEntryType.values.byName(map['type'] ?? 'manual'),
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      audioUrl: map['audioUrl'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      needsRestudy: map['needsRestudy'] ?? false,
    );
  }
}
