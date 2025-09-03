import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final int index;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.index,
    required this.onToggleDone,
    required this.onDelete,
  });

  void _showTaskDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          task.label,
          style: const TextStyle(fontFamily: 'Ubuntu'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🕒 ${task.startTime} - ${task.endTime}',
              style: const TextStyle(fontFamily: 'Ubuntu'),
            ),
            const SizedBox(height: 8),
            Text(
              '🔁 Repeats: ${task.repeat}',
              style: const TextStyle(fontFamily: 'Ubuntu'),
            ),
            const SizedBox(height: 8),
            Text(
              '📝 Note: ${task.note}',
              style: const TextStyle(fontFamily: 'Ubuntu'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(fontFamily: 'Ubuntu'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTaskDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4F3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Status Icon
            GestureDetector(
              onTap: onToggleDone,
              child: SvgPicture.asset(
                task.isDone
                    ? 'assets/icons/taskfilled.svg'
                    : 'assets/icons/taskempty.svg',
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Task Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.label,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenTitle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.startTime} - ${task.endTime}',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Delete Button
            GestureDetector(
              onTap: onDelete,
              child: SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
