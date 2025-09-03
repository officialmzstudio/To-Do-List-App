import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void toggleDone(int index) {
    _tasks[index].isDone = !_tasks[index].isDone;
    notifyListeners();
  }

  void setTasks(List<TaskModel> tasks) {
    _tasks = tasks;
    notifyListeners();
  }
}
