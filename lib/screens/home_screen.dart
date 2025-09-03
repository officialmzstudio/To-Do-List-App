import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../utils/constants.dart';
import '../widgets/task_list_view.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> tasks = [];
  List<TaskModel> filteredTasks = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTasks = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = storedTasks.map((json) => TaskModel.fromJson(jsonDecode(json))).toList();
      _filterTasks(); // نمایش اولیه
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', jsonList);
  }

  void _toggleTaskDone(int index) {
    final realIndex = tasks.indexOf(filteredTasks[index]);
    setState(() {
      tasks[realIndex].isDone = !tasks[realIndex].isDone;
    });
    _saveTasks();
    _filterTasks(); // به‌روز رسانی نمایش
  }

  void _deleteTask(int index) {
    final realIndex = tasks.indexOf(filteredTasks[index]);
    setState(() {
      tasks.removeAt(realIndex);
    });
    _saveTasks();
    _filterTasks();
  }

  void _filterTasks() {
    setState(() {
      filteredTasks = tasks
          .where((task) =>
          task.label.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _updateSearch(String query) {
    searchQuery = query;
    _filterTasks();
  }

  Future<void> _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (result != null && result is TaskModel) {
      setState(() {
        tasks.add(result);
      });
      _saveTasks();
      _filterTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Top Icons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('assets/icons/menu.svg', width: 24),
                  SvgPicture.asset('assets/icons/profile.svg', width: 24),
                ],
              ),
              const SizedBox(height: 24),

              // --- Title ---
              const Text(
                'My Tasks',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA6CDC6), // AppColors.greenTitle
                ),
              ),
              const SizedBox(height: 24),

              // --- Search Box ---
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFBFB),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/search.svg', width: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: _updateSearch,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Task List ---
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return ListTile(
                      title: Text(task.label, style: const TextStyle(fontFamily: 'Ubuntu')),
                      subtitle: Text('${task.startTime} - ${task.endTime}', style: const TextStyle(fontFamily: 'Ubuntu')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: task.isDone,
                            onChanged: (_) => _toggleTaskDone(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTask(index),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // --- Bottom Button ---
      floatingActionButton: GestureDetector(
        onTap: _navigateToAddTask,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Color(0xFFF27507), // AppColors.orange
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF27507).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Text(
            'Create New Task',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
