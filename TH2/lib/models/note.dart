import 'dart:convert';

class Note {
  String id;
  String title;
  String content;
  DateTime lastModified;
  String? imageUrl; // Thêm trường đường dẫn ảnh

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.lastModified,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lastModified': lastModified.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      lastModified: DateTime.parse(map['lastModified']),
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}
