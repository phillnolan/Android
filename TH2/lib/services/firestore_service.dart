import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> uploadNote(Note note, String uid) async {
    final ref = _db.collection('users').doc(uid).collection('notes').doc(note.id);
    await ref.set(note.toJson());
  }

  static Future<void> deleteNote(String noteId, String uid) async {
    final ref = _db.collection('users').doc(uid).collection('notes').doc(noteId);
    await ref.delete();
  }

  static Future<List<Note>> loadNotes(String uid) async {
    final snap = await _db.collection('users').doc(uid).collection('notes').get();
    return snap.docs.map((d) => Note.fromJson(d.data())).toList();
  }
}
