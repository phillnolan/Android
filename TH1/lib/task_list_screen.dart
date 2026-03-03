import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/category.dart';
import 'models/task.dart';
import 'widgets/todo_item_widget.dart';

enum FilterType { all, completed, incomplete }

class TaskListScreen extends StatefulWidget {
  final Category category;
  final List<Task> initialTasks;
  final Task Function(String, String, DateTime?) onAddTask;
  final Task? Function(String, String, String, DateTime?) onUpdateTask;
  final Function(String) onDeleteTask;
  final Function(String) onToggleTask;

  const TaskListScreen({
    super.key,
    required this.category,
    required this.initialTasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
    required this.onToggleTask,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;
  List<Task> _filteredTasks = [];
  FilterType _currentFilter = FilterType.all;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.initialTasks);
    _filterTasks();
  }

  void _filterTasks() {
    setState(() {
      if (_currentFilter == FilterType.completed) {
        _filteredTasks = _tasks.where((task) => task.isCompleted).toList();
      } else if (_currentFilter == FilterType.incomplete) {
        _filteredTasks = _tasks.where((task) => !task.isCompleted).toList();
      } else {
        _filteredTasks = List.from(_tasks);
      }
      _filteredTasks.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final isEditing = task != null;
    DateTime? dueDate = task?.dueDate;
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickDateTime() async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: dueDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
              );
              if (date == null) return;

              final TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(dueDate ?? DateTime.now()),
              );
              if (time == null) return;

              setDialogState(() {
                dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
              });
            }

            return AlertDialog(
              title: Text(isEditing ? 'Chỉnh sửa công việc' : 'Thêm công việc mới'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Nội dung',
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Hạn hoàn thành (tùy chọn):'),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            dueDate == null
                                ? 'Chưa có'
                                : DateFormat('HH:mm - dd/MM/yyyy').format(dueDate!),
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.calendar_month), onPressed: pickDateTime),
                        if (dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setDialogState(() => dueDate = null),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text;
                    if (title.isEmpty) {
                      setDialogState(() => errorText = 'Nội dung không được để trống!');
                      return;
                    }

                    if (isEditing) {
                      final updatedTask = widget.onUpdateTask(task!.id, title, widget.category.id, dueDate);
                      if (updatedTask != null) {
                        setState(() {
                          final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
                          if (index != -1) {
                            _tasks[index] = updatedTask;
                          }
                          _filterTasks();
                        });
                      }
                    } else {
                      final newTask = widget.onAddTask(title, widget.category.id, dueDate);
                      setState(() {
                        _tasks.add(newTask);
                        _filterTasks();
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa công việc này?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                widget.onDeleteTask(taskId);
                 setState(() {
                  _tasks.removeWhere((t) => t.id == taskId);
                  _filterTasks();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<FilterType>(
              segments: const <ButtonSegment<FilterType>>[
                ButtonSegment<FilterType>(value: FilterType.all, label: Text('Tất cả')),
                ButtonSegment<FilterType>(value: FilterType.incomplete, label: Text('Chưa xong')),
                ButtonSegment<FilterType>(value: FilterType.completed, label: Text('Đã xong')),
              ],
              selected: <FilterType>{_currentFilter},
              onSelectionChanged: (Set<FilterType> newSelection) {
                setState(() {
                  _currentFilter = newSelection.first;
                  _filterTasks();
                });
              },
            ),
          ),
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(child: Text('Không có công việc nào trong mục này.'))
                : ListView.builder(
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = _filteredTasks[index];
                      return TodoItemWidget(
                        task: task,
                        onToggle: () {
                          // First, notify the parent to update the master list
                          widget.onToggleTask(task.id);
                          
                          // Then, optimistically update the local state for instant UI feedback
                          setState(() {
                            final localTask = _tasks.firstWhere((t) => t.id == task.id, orElse: () => task);
                            localTask.isCompleted = !localTask.isCompleted;
                            _filterTasks();
                          });
                        },
                        onEdit: () => _showTaskDialog(task: task),
                        onDelete: () => _showDeleteConfirmationDialog(task.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
