import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TodoItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatTimeRemaining(Duration duration, bool isOverdue) {
    if (duration.inDays.abs() > 0) {
      return '${isOverdue ? 'Đã quá hạn' : 'Còn'} ${duration.inDays.abs()} ngày';
    } else if (duration.inHours.abs() > 0) {
      return '${isOverdue ? 'Đã quá hạn' : 'Còn'} ${duration.inHours.abs()} giờ';
    } else if (duration.inMinutes.abs() > 0) {
      return '${isOverdue ? 'Đã quá hạn' : 'Còn'} ${duration.inMinutes.abs()} phút';
    } else {
      return isOverdue ? 'Đã quá hạn' : 'Sắp hết hạn';
    }
  }

  Color _getTimeRemainingColor(Duration duration, bool isOverdue) {
    if (isOverdue) {
      return Colors.red;
    } else if (duration.inDays > 2) {
      return Colors.green;
    } else if (duration.inDays > 0 || duration.inHours > 0) {
      return Colors.orange;
    } else {
      return Colors.red; // Less than an hour remaining
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = task.dueDate != null && !task.isCompleted && task.dueDate!.isBefore(DateTime.now());
    Duration? timeRemaining;
    if (task.dueDate != null) {
      timeRemaining = task.dueDate!.difference(DateTime.now());
    }

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          onToggle();
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: task.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tạo: ${DateFormat('HH:mm - dd/MM/yyyy').format(task.timestamp)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          if (task.dueDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: isOverdue ? Colors.red : Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Hạn: ${DateFormat('HH:mm - dd/MM/yyyy').format(task.dueDate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          if (timeRemaining != null && !task.isCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _formatTimeRemaining(timeRemaining, isOverdue),
                style: TextStyle(
                  fontSize: 12,
                  color: _getTimeRemainingColor(timeRemaining, isOverdue),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
      isThreeLine: task.dueDate != null || (timeRemaining != null && !task.isCompleted),
    );
  }
}