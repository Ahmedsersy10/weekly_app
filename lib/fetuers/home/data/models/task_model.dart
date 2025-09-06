import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TaskCategory { work, study, health, personal, finance, home, other }

enum TaskPriority { low, medium, high, urgent }

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int dayOfWeek; // 0 = Saturday, 1 = Sunday, ..., 5 = Thursday
  final bool isImportant;
  final TaskCategory category;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int estimatedMinutes;
  final List<String> tags;
  final String? notes;
  final TimeOfDay? reminderTime;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.dayOfWeek,
    this.isImportant = false,
    this.category = TaskCategory.other,
    this.priority = TaskPriority.medium,
    this.dueDate,
    DateTime? createdAt,
    this.completedAt,
    this.estimatedMinutes = 0,
    this.tags = const [],
    this.notes,
    this.reminderTime,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? dayOfWeek,
    bool? isImportant,
    TaskCategory? category,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
    int? estimatedMinutes,
    List<String>? tags,
    String? notes,
    TimeOfDay? reminderTime,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isImportant: isImportant ?? this.isImportant,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  // Helper methods
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool get isDueSoon {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final difference = dueDate!.difference(now).inDays;
    return difference <= 2 && difference >= 0;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isCompleted,
    dayOfWeek,
    isImportant,
    category,
    priority,
    dueDate,
    createdAt,
    completedAt,
    estimatedMinutes,
    tags,
    notes,
    reminderTime,
  ];
}
