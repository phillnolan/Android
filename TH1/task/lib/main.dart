import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/task.dart';
import 'models/category.dart';
import 'task_list_screen.dart'; // Import the new screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const CategoryGridScreen(), // The new home screen
      debugShowCheckedModeBanner: false,
    );
  }
}

class CategoryGridScreen extends StatefulWidget {
  const CategoryGridScreen({super.key});

  @override
  State<CategoryGridScreen> createState() => _CategoryGridScreenState();
}

class _CategoryGridScreenState extends State<CategoryGridScreen> {
  final _uuid = const Uuid();
  late List<Task> _tasks;
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    
    _categories = [
      Category(id: 'cat-1', name: 'Chung'),
      Category(id: 'cat-2', name: 'Việc nhà'),
      Category(id: 'cat-3', name: 'Phát triển ứng dụng'),
      Category(id: 'cat-4', name: 'Tiếng Anh'),
    ];

    _tasks = [
      Task(id: _uuid.v4(), title: 'Học Flutter Navigation', categoryId: 'cat-3', timestamp: DateTime.now().subtract(const Duration(days: 1)), dueDate: DateTime.now().add(const Duration(days: 2))),
      Task(id: _uuid.v4(), title: 'Nộp bài tập PTUD', categoryId: 'cat-3', timestamp: DateTime.now().subtract(const Duration(days: 2)), dueDate: DateTime.now().add(const Duration(hours: 8))),
      Task(id: _uuid.v4(), title: 'Làm bài tập Provider', categoryId: 'cat-3', isCompleted: true, timestamp: DateTime.now().subtract(const Duration(hours: 5)), dueDate: DateTime.now().subtract(const Duration(days: 1))),
      Task(id: _uuid.v4(), title: 'Lau nhà', categoryId: 'cat-2', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
      Task(id: _uuid.v4(), title: 'Mua sắm', categoryId: 'cat-1', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
      Task(id: _uuid.v4(), title: 'Học 10 từ vựng mới', categoryId: 'cat-4', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ];
  }

  // --- Task Logic ---
  Task _addTask(String title, String categoryId, DateTime? dueDate) {
    final newTask = Task(
      id: _uuid.v4(),
      title: title,
      categoryId: categoryId,
      timestamp: DateTime.now(),
      dueDate: dueDate,
    );
    setState(() {
      _tasks.add(newTask);
    });
    return newTask;
  }

  Task? _updateTask(String id, String newTitle, String categoryId, DateTime? dueDate) {
    Task? updatedTask;
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        final oldTask = _tasks[taskIndex];
        updatedTask = Task(
          id: oldTask.id,
          title: newTitle,
          categoryId: categoryId,
          isCompleted: oldTask.isCompleted,
          timestamp: oldTask.timestamp,
          dueDate: dueDate,
        );
        _tasks[taskIndex] = updatedTask!;
      }
    });
    return updatedTask;
  }

  void _toggleTask(String id) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if(taskIndex != -1) {
        final oldTask = _tasks[taskIndex];
        _tasks[taskIndex] = Task(id: oldTask.id, title: oldTask.title, categoryId: oldTask.categoryId, timestamp: oldTask.timestamp, dueDate: oldTask.dueDate, isCompleted: !oldTask.isCompleted);
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  // --- Category Logic ---
  void _addCategory(String name) {
    setState(() {
      _categories.add(Category(id: _uuid.v4(), name: name));
    });
  }

  void _deleteCategory(String categoryId) {
    setState(() {
      // Find the default "Chung" category
      final defaultCategory = _categories.firstWhere((cat) => cat.name == 'Chung', orElse: () => _categories.first);
      final defaultCatId = defaultCategory.id;

      // Re-assign tasks from the deleted category to the default one
      _tasks = _tasks.map((task) {
        if (task.categoryId == categoryId) {
          return Task(id: task.id, title: task.title, categoryId: defaultCatId, timestamp: task.timestamp, dueDate: task.dueDate, isCompleted: task.isCompleted);
        }
        return task;
      }).toList();

      // Remove the category
      _categories.removeWhere((cat) => cat.id == categoryId);
    });
  }

  // --- Dialogs & Navigation ---
  void _showCategoryDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm mục mới'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Tên mục'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  _addCategory(nameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCategoryConfirmationDialog(Category category) {
     // Cannot delete the default "Chung" category
    if (category.name == 'Chung' && _categories.any((c) => c.name == 'Chung' && c.id == category.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa mục "Chung" mặc định.'), backgroundColor: Colors.red),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa mục "${category.name}"? Mọi công việc trong mục này sẽ được chuyển về mục "Chung".'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _deleteCategory(category.id);
                Navigator.of(context).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTaskList(Category category) {
    final tasksForCategory = _tasks.where((task) => task.categoryId == category.id).toList();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListScreen(
          category: category,
          initialTasks: tasksForCategory,
          onAddTask: _addTask,
          onUpdateTask: _updateTask,
          onDeleteTask: _deleteTask,
          onToggleTask: _toggleTask,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Helper functions for the build method
    String _formatTimeRemaining(Duration duration) {
      if (duration.inDays > 0) return 'Còn ${duration.inDays} ngày';
      if (duration.inHours > 0) return 'Còn ${duration.inHours} giờ';
      if (duration.inMinutes > 0) return 'Còn ${duration.inMinutes} phút';
      return 'Sắp hết hạn';
    }

    Color _getTimeRemainingColor(Duration duration) {
      if (duration.inDays > 2) return Colors.green.shade700;
      if (duration.inDays > 0 || duration.inHours > 0) return Colors.orange.shade800;
      return Colors.red.shade700;
    }

    Widget _buildNextDueInfo(Task nextDueTask) {
      final timeRemaining = nextDueTask.dueDate!.difference(DateTime.now());
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: _getTimeRemainingColor(timeRemaining).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.alarm, size: 14, color: _getTimeRemainingColor(timeRemaining)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _formatTimeRemaining(timeRemaining),
                style: TextStyle(color: _getTimeRemainingColor(timeRemaining), fontWeight: FontWeight.bold, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các mục công việc'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, childAspectRatio: 1.2),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final tasksInCategory = _tasks.where((task) => task.categoryId == category.id);
          final taskCount = tasksInCategory.length;
          final completedCount = tasksInCategory.where((task) => task.isCompleted).length;

          Task? nextDueTask;
          final upcomingTasks = tasksInCategory.where((task) => !task.isCompleted && task.dueDate != null && task.dueDate!.isAfter(DateTime.now())).toList();
          if (upcomingTasks.isNotEmpty) {
            upcomingTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
            nextDueTask = upcomingTasks.first;
          }

          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () => _navigateToTaskList(category),
              onLongPress: () => _showDeleteCategoryConfirmationDialog(category),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (nextDueTask != null) ...[const Spacer(), _buildNextDueInfo(nextDueTask), const Spacer()] else const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$taskCount công việc'),
                        if (taskCount > 0) Padding(padding: const EdgeInsets.only(top: 4.0), child: Text('$completedCount đã hoàn thành')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCategoryDialog,
        child: const Icon(Icons.add),
        tooltip: 'Thêm mục mới',
      ),
    );
  }
}
