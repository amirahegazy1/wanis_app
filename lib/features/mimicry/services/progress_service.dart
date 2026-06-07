import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists best scores per mimicry session locally using SharedPreferences.
class MimicryProgressService {
  static const String _key = 'mimicry_levels_progress';

  static Future<Map<int, double>> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return {};
    final Map<String, dynamic> json = jsonDecode(data);
    return json.map((k, v) => MapEntry(int.parse(k), v.toDouble()));
  }

  static Future<void> saveScore(int levelId, double score) async {
    final progress = await getProgress();
    if ((progress[levelId] ?? 0) < score) {
      progress[levelId] = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key,
        jsonEncode(progress.map((k, v) => MapEntry(k.toString(), v))),
      );
    }
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
