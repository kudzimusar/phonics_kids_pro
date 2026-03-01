import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence layer for tracking activity completion status.
/// Uses shared_preferences so progress is retained across sessions
/// without requiring a network connection.
class LocalProgressService {
  static const _prefix = 'activity_cleared_';

  /// Returns true if the given activity has been marked as cleared.
  Future<bool> isActivityCleared(String activityLabel) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$activityLabel') ?? false;
  }

  /// Marks an activity as cleared. Idempotent — safe to call multiple times.
  Future<void> markActivityCleared(String activityLabel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$activityLabel', true);
  }

  /// Resets a specific activity's cleared status (e.g., for retries).
  Future<void> resetActivity(String activityLabel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$activityLabel');
  }

  /// Clears ALL activity progress (e.g., on sign-out or profile reset).
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Returns a map of all cleared activity labels → true.
  Future<Map<String, bool>> getAllClearedActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, bool>{};
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_prefix)) {
        result[key.replaceFirst(_prefix, '')] = true;
      }
    }
    return result;
  }
}
