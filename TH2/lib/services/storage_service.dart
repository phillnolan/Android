import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class StorageService {
  static const _key = 'smart_notes_v1';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<Note> loadNotes() {
    final json = _prefs.getString(_key);
    if (json == null || json.isEmpty) return [];
    try {
      return Note.listFromJson(json);
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final json = Note.listToJson(notes);
    await _prefs.setString(_key, json);
  }

  static Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
