
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskDatabase {
  static const String _boxName = 'tasksBox';

  static Future<void> init() async {
    Hive.registerAdapter(TaskModelAdapter());
    await Hive.openBox<TaskModel>(_boxName);
  }

  static Box<TaskModel> get _box => Hive.box<TaskModel>(_boxName);

  static List<TaskModel> getTasks() {
    return _box.values.toList();
  }

  static Future<void> addTask(TaskModel task) async {
    await _box.add(task);
  }

  static Future<void> deleteTask(int index) async {
    await _box.deleteAt(index);
  }

  static Future<void> clearTasks() async {
    await _box.clear();
  }
}
