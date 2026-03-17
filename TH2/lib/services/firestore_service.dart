import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _notesCollection {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập');
    return _db.collection('users').doc(user.uid).collection('notes');
  }

  Stream<List<Note>> getNotesStream() {
    return _notesCollection
        .orderBy('lastModified', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note.fromMap(data);
      }).toList();
    });
  }

  Future<void> saveNote(Note note) async {
    await _notesCollection.doc(note.id).set(note.toMap());
  }

  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }

  // Hàm upload ảnh lên Storage
  Future<String> uploadImage(File imageFile, String noteId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Chưa đăng nhập');
    
    final ref = _storage.ref().child('users/${user.uid}/notes/$noteId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
