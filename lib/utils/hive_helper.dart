import 'package:hive/hive.dart';
import '../models/task_model.dart';

class HiveHelper {
  static const String _taskBoxName = 'tasks';

  static Future<void> initHive() async {
    Hive.registerAdapter(TaskModelAdapter());
    await Hive.openBox<TaskModel>(_taskBoxName);
  }

  static Box<TaskModel> get taskBox => Hive.box<TaskModel>(_taskBoxName);

  static Future<void> addTask(TaskModel task) async {
    await taskBox.add(task);
  }

  static List<TaskModel> getAllTasks() {
    return taskBox.values.toList();
  }

  static Future<void> updateTask(int index, TaskModel updatedTask) async {
    await taskBox.putAt(index, updatedTask);
  }

  static Future<void> deleteTask(int index) async {
    await taskBox.deleteAt(index);
  }

  static Future<void> clearAllTasks() async {
    await taskBox.clear();
  }
}
