import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../utils/hive_helper.dart';
import 'task_tile.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<TaskModel>>(
      valueListenable: HiveHelper.taskBox.listenable(),
      builder: (context, box, _) {
        final tasks = box.values.toList();

        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              "No tasks added yet",
              style: TextStyle(fontFamily: 'Ubuntu'),
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return TaskTile(
              task: task,
              index: index,
              onToggleDone: () {
                // مستقیم به خود task تغییر بده (چون از HiveObject ارث‌بری شده)
                task.isDone = !task.isDone;
                task.save(); // به‌روز رسانی در box
              },
              onDelete: () {
                task.delete(); // حذف مستقیم از box
              },
            );
          },
        );
      },
    );
  }
}
