import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String label;

  @HiveField(1)
  String startTime;

  @HiveField(2)
  String endTime;

  @HiveField(3)
  String repeat;

  @HiveField(4)
  String note;

  @HiveField(5)
  bool isDone;

  TaskModel({
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.repeat,
    required this.note,
    required this.isDone,
  });

  //  SharedPreferences
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      label: json['label'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      repeat: json['repeat'],
      note: json['note'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'startTime': startTime,
      'endTime': endTime,
      'repeat': repeat,
      'note': note,
      'isDone': isDone,
    };
  }
}
