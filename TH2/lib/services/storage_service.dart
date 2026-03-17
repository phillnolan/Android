import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class StorageService {
  static const String _keyNotes = 'notes';

  Future<void> saveNotes(List<Note> notes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      notes.map((note) => note.toMap()).toList(),
    );
    await prefs.setString(_keyNotes, encodedData);
  }

  Future<List<Note>> loadNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_keyNotes);

    if (encodedData == null) {
      return [];
    }

    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((item) => Note.fromMap(item)).toList();
  }
}
