import 'package:shared_preferences/shared_preferences.dart';

class LocalProgressService {
  static const String _clearedPrefix = 'cleared_activity_';

  /// Mark an activity as cleared.
  /// Returns true if it was newly marked, false if it was already marked.
  Future<bool> markActivityCleared(String activityLabel) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_clearedPrefix$activityLabel';
    
    final alreadyCleared = prefs.getBool(key) ?? false;
    if (!alreadyCleared) {
      await prefs.setBool(key, true);
      return true; // Newly cleared
    }
    return false; // Was already cleared
  }

  /// Check if a specific activity is cleared.
  Future<bool> isActivityCleared(String activityLabel) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_clearedPrefix$activityLabel';
    return prefs.getBool(key) ?? false;
  }

  /// Get the total count of cleared activities.
  Future<int> getClearedCount() async {
    final prefs = await SharedPreferences.getInstance();
    int count = 0;
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_clearedPrefix)) {
        if (prefs.getBool(key) == true) {
          count++;
        }
      }
    }
    return count;
  }
  
  /// Get all cleared activity labels.
  Future<List<String>> getClearedActivities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cleared = [];
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_clearedPrefix)) {
        if (prefs.getBool(key) == true) {
          cleared.add(key.replaceFirst(_clearedPrefix, ''));
        }
      }
    }
    return cleared;
  }

  /// Reset all progress (useful for testing or full resets).
  Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_clearedPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
