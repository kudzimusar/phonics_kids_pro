import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Scaffold for n8n + Brevo automation.
/// Sends webhook triggers to a self-hosted or cloud n8n instance.
/// Set n8n webhook URLs in AppConfig (or environment vars) before releasing.
class ReportService {
  // ── Config ──────────────────────────────────────────────────────────────────
  // Replace with your real n8n webhook URLs.
  static const String _weeklyReportWebhook =
      'https://your-n8n-instance.com/webhook/weekly-report';
  static const String _milestoneWebhook =
      'https://your-n8n-instance.com/webhook/milestone-certificate';
  static const String _feedbackWebhook =
      'https://your-n8n-instance.com/webhook/feedback';

  // ── Public API ───────────────────────────────────────────────────────────────

  /// Triggers an n8n workflow that reads Firestore, generates a PDF,
  /// and sends it via Brevo to the parent's email address.
  Future<void> sendWeeklyReport(String userId) async {
    await _post(_weeklyReportWebhook, {
      'userId': userId,
      'trigger': 'manual',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Triggered when a student completes a module with ≥ 80% accuracy.
  /// n8n sends the digital certificate to the parent's email via Brevo.
  Future<void> sendMilestoneCertificate({
    required String userId,
    required String lessonId,
    required double accuracy,
  }) async {
    await _post(_milestoneWebhook, {
      'userId': userId,
      'lessonId': lessonId,
      'accuracy': accuracy,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Posts teacher/parent feedback to n8n for routing to Brevo.
  Future<void> sendFeedback({
    required String userId,
    required String message,
    required String role,
  }) async {
    await _post(_feedbackWebhook, {
      'userId': userId,
      'role': role,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ── Internal ─────────────────────────────────────────────────────────────────
  Future<void> _post(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      debugPrint('[ReportService] POST $url → ${response.statusCode}');
      if (response.statusCode >= 400) {
        throw Exception('Webhook returned ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('[ReportService] Error: $e');
      rethrow;
    }
  }
}
