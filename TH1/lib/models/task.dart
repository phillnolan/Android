class Task {
  String id;
  String title;
  final String categoryId;
  bool isCompleted;
  final DateTime timestamp;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.timestamp,
    this.dueDate,
    this.isCompleted = false,
  });
}