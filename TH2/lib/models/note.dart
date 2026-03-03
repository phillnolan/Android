import 'dart:convert';

class Note {
  final String id;
  String title;
  String content;
  DateTime updatedAt;
  List<String> imagePaths;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    List<String>? imagePaths,
  }) : imagePaths = imagePaths ?? [];

  factory Note.createNew() {
    final now = DateTime.now();
    return Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: '',
      content: '',
      updatedAt: now,
      imagePaths: [],
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? imgs = json['imagePaths'] as List<dynamic>?;
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      imagePaths: imgs?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'updatedAt': updatedAt.toIso8601String(),
        'imagePaths': imagePaths,
      };

  static List<Note> listFromJson(String jsonStr) {
    final List<dynamic> data = json.decode(jsonStr) as List<dynamic>;
    return data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<Note> notes) {
    final list = notes.map((e) => e.toJson()).toList();
    return json.encode(list);
  }
}
