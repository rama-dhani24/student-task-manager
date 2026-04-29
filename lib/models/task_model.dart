// lib/models/task_model.dart

import 'dart:convert';
import '../constants/app_constants.dart';

class TaskModel {
  final String id;
  String title;
  String subject;
  String description;
  DateTime dueDate;
  String priority; // high, medium, low
  String status; // pending, completed
  DateTime createdAt;
  DateTime? completedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.status = AppConstants.statusPending,
    required this.createdAt,
    this.completedAt,
  });

  bool get isCompleted => status == AppConstants.statusCompleted;

  bool get isOverdue =>
      !isCompleted && dueDate.isBefore(DateTime.now());

  bool get isDueToday {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  bool get isDueSoon {
    final now = DateTime.now();
    final diff = dueDate.difference(now).inDays;
    return !isCompleted && diff >= 0 && diff <= 3;
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String,
      status: json['status'] as String? ?? AppConstants.statusPending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  String toJsonString() => jsonEncode(toJson());
  factory TaskModel.fromJsonString(String jsonStr) =>
      TaskModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
}
