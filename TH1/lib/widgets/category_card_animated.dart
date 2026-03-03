import 'package:flutter/material.dart';
import 'package:task/models/category.dart';
import 'package:task/models/task.dart';
import 'package:collection/collection.dart';

class CategoryCardAnimated extends StatefulWidget {
  const CategoryCardAnimated({
    super.key,
    required this.category,
    required this.tasksInCategory,
    required this.onTap,
    required this.onLongPress,
  });

  final Category category;
  final Iterable<Task> tasksInCategory;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  State<CategoryCardAnimated> createState() => _CategoryCardAnimatedState();
}

class _CategoryCardAnimatedState extends State<CategoryCardAnimated> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final taskCount = widget.tasksInCategory.length;
    final completedCount = widget.tasksInCategory.where((task) => task.isCompleted).length;

    Task? nextDueTask;
    final upcomingTasks = widget.tasksInCategory.where((task) => !task.isCompleted && task.dueDate != null && task.dueDate!.isAfter(DateTime.now())).toList();
    if (upcomingTasks.isNotEmpty) {
      upcomingTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
      nextDueTask = upcomingTasks.first;
    }

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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.category.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }
}
