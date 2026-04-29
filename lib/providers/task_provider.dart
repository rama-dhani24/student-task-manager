// lib/providers/task_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../constants/app_constants.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;

  List<TaskModel> get todayTasks => _tasks
      .where((t) => t.isDueToday && !t.isCompleted)
      .toList()
    ..sort(_sortByPriority);

  List<TaskModel> get upcomingTasks => _tasks
      .where((t) => !t.isDueToday && !t.isCompleted && !t.isOverdue)
      .toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  List<TaskModel> get overdueTasks => _tasks
      .where((t) => t.isOverdue)
      .toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  List<TaskModel> get completedTasks => _tasks
      .where((t) => t.isCompleted)
      .toList()
    ..sort((a, b) => (b.completedAt ?? b.createdAt)
        .compareTo(a.completedAt ?? a.createdAt));

  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get overdueCount => overdueTasks.length;

  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    return completedCount / _tasks.length;
  }

  int _sortByPriority(TaskModel a, TaskModel b) {
    const order = {
      AppConstants.priorityHigh: 0,
      AppConstants.priorityMedium: 1,
      AppConstants.priorityLow: 2,
    };
    return (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1);
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(AppConstants.keyTasks) ?? [];
      _tasks = tasksJson
          .map((s) => TaskModel.fromJson(
              jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      _tasks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks
        .map((t) => jsonEncode(t.toJson()))
        .toList();
    await prefs.setStringList(AppConstants.keyTasks, tasksJson);
  }

  Future<TaskModel> addTask({
    required String title,
    required String subject,
    required String description,
    required DateTime dueDate,
    required String priority,
  }) async {
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      subject: subject,
      description: description,
      dueDate: dueDate,
      priority: priority,
      status: AppConstants.statusPending,
      createdAt: DateTime.now(),
    );

    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
    return task;
  }

  Future<void> updateTask(TaskModel updated) async {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _tasks[index] = updated;
    await _saveTasks();
    notifyListeners();
  }

  Future<void> markCompleted(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(
      status: AppConstants.statusCompleted,
      completedAt: DateTime.now(),
    );
    await _saveTasks();
    notifyListeners();
  }

  Future<void> markPending(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(
      status: AppConstants.statusPending,
      completedAt: null,
    );
    await _saveTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _saveTasks();
    notifyListeners();
  }

  TaskModel? findById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
