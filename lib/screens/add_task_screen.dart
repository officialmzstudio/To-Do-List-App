import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';
import '../utils/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _labelController = TextEditingController();
  final _noteController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _repeat = 'Every day';

  void _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _saveTask() async {
    if (_labelController.text.trim().isEmpty || _startTime == null || _endTime == null) return;

    final formattedStartTime = _startTime!.format(context);
    final formattedEndTime = _endTime!.format(context);

    final task = TaskModel(
      label: _labelController.text.trim(),
      note: _noteController.text.trim(),
      repeat: _repeat,
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      isDone: false,
    );

    final startDateTime = _toDateTime(_startTime!);
    final endDateTime = _toDateTime(_endTime!);

    final nowEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    int repeatDays = 0;
    switch (_repeat) {
      case 'Every day':
        repeatDays = 1;
        break;
      case 'Every other day':
        repeatDays = 2;
        break;
      case 'Every week':
        repeatDays = 7;
        break;
      default:
        repeatDays = 0;
    }

    for (int i = 0; i < 7; i++) {
      final offset = i * repeatDays;
      final start = startDateTime.add(Duration(days: offset));
      final end = endDateTime.add(Duration(days: offset));

      await NotificationService().scheduleNotification(
        id: nowEpoch + i * 2,
        title: 'Task Started',
        body: 'Let’s get it done! Your task begins now.',
        scheduledTime: start,
      );

      await NotificationService().scheduleNotification(
        id: nowEpoch + i * 2 + 1,
        title: 'Task Finished',
        body: 'Well done! Your task is over. Time to relax.',
        scheduledTime: end,
      );
    }

    if (mounted) {
      Navigator.pop(context, task);
    }
  }

  DateTime _toDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task', style: TextStyle(fontFamily: 'Ubuntu')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('Label', style: kFieldLabelStyle),
            const SizedBox(height: 6),
            _buildInputField(controller: _labelController, hint: 'Enter your task title'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Start Time', style: kFieldLabelStyle),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _pickTime(isStart: true),
                        child: _buildFakeInput(_startTime?.format(context) ?? '--:--'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('End Time', style: kFieldLabelStyle),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _pickTime(isStart: false),
                        child: _buildFakeInput(_endTime?.format(context) ?? '--:--'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Repeat', style: kFieldLabelStyle),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _repeat,
              items: const [
                DropdownMenuItem(value: 'Every day', child: Text('Everyday')),
                DropdownMenuItem(value: 'Every other day', child: Text('Every other day')),
                DropdownMenuItem(value: 'Every week', child: Text('Every week')),
              ],
              onChanged: (val) => setState(() => _repeat = val!),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Note', style: kFieldLabelStyle),
            const SizedBox(height: 6),
            _buildInputField(controller: _noteController, hint: 'Write additional notes', maxLines: 3),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrangeColor,
                elevation: 4,
                shadowColor: kOrangeColor.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'SAVE TASK',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String hint, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      style: const TextStyle(fontFamily: 'Ubuntu'),
    );
  }

  Widget _buildFakeInput(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontFamily: 'Ubuntu')),
    );
  }
}
