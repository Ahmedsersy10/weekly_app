import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class HiveService {
  static const String _tasksBoxName = 'tasks_box';
  static const String _tasksKey = 'tasks';

  static Box? _tasksBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _tasksBox = await Hive.openBox(_tasksBoxName);
  }

  static Future<void> saveTasks(List<TaskModel> tasks) async {
    if (_tasksBox != null) {
      // Convert tasks to a serializable format
      final serializedTasks = tasks
          .map(
            (task) => {
              'id': task.id,
              'title': task.title,
              'isCompleted': task.isCompleted,
              'dayOfWeek': task.dayOfWeek,
              'isImportant': task.isImportant,
              'reminderTime': task.reminderTime != null
                  ? '${task.reminderTime!.hour}:${task.reminderTime!.minute}'
                  : null,
            },
          )
          .toList();
      await _tasksBox!.put(_tasksKey, serializedTasks);
    }
  }

  static List<TaskModel> loadTasks() {
    if (_tasksBox != null) {
      final serializedTasks = _tasksBox!.get(_tasksKey);
      if (serializedTasks is List) {
        return serializedTasks.whereType<Map>().map((raw) {
          final data = Map<String, dynamic>.from(raw);

          // Parse reminder time if it exists
          TimeOfDay? reminderTime;
          if (data['reminderTime'] != null) {
            final timeParts = (data['reminderTime'] as String).split(':');
            reminderTime = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );
          }

          return TaskModel(
            id: data['id'] as String,
            title: data['title'] as String,
            isCompleted: data['isCompleted'] as bool,
            dayOfWeek: data['dayOfWeek'] as int,
            isImportant: (data['isImportant'] as bool?) ?? false,
            reminderTime: reminderTime,
          );
        }).toList();
      }
    }
    return [];
  }

  static Future<void> close() async {
    await _tasksBox?.close();
  }
}
