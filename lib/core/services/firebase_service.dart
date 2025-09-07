import '../../fetuers/home/data/models/task_model.dart';
import '../../fetuers/home/data/models/statistics_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isSignedIn = false;
  String? _userId;

  bool get isSignedIn => _isSignedIn;
  String? get currentUserId => _userId;

  Future<bool> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _isSignedIn = true;
    _userId = 'placeholder_user_id';
    return true;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _isSignedIn = false;
    _userId = null;
  }

  Future<void> syncTasksToCloud(List<TaskModel> tasks) async {
    if (!isSignedIn) return;

    await Future.delayed(const Duration(seconds: 1));
    print('Tasks synced to cloud successfully (placeholder)');
  }

  Future<List<TaskModel>> syncTasksFromCloud() async {
    if (!isSignedIn) return [];

    await Future.delayed(const Duration(seconds: 1));
    print('Tasks synced from cloud successfully (placeholder)');
    return [];
  }

  Future<void> syncStatisticsToCloud(StatisticsModel statistics) async {
    if (!isSignedIn) return;

    await Future.delayed(const Duration(seconds: 1));
    print('Statistics synced to cloud successfully (placeholder)');
  }

  Future<StatisticsModel?> syncStatisticsFromCloud() async {
    if (!isSignedIn) return null;

    await Future.delayed(const Duration(seconds: 1));
    print('Statistics synced from cloud successfully (placeholder)');
    return null;
  }

  Future<void> createBackup() async {
    if (!isSignedIn) return;

    await Future.delayed(const Duration(seconds: 1));
    print('Backup created successfully (placeholder)');
  }

  Future<List<Map<String, dynamic>>> getBackups() async {
    if (!isSignedIn) return [];

    await Future.delayed(const Duration(seconds: 1));
    print('Backups retrieved successfully (placeholder)');
    return [];
  }

  Future<void> restoreFromBackup(String backupId) async {
    if (!isSignedIn) return;

    await Future.delayed(const Duration(seconds: 1));
    print('Backup restored successfully (placeholder)');
  }

  Map<String, dynamic> _taskModelToMap(TaskModel task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
      'dayOfWeek': task.dayOfWeek,
      'isImportant': task.isImportant,
      'category': task.category.name,
      'priority': task.priority.name,
      'dueDate': task.dueDate?.toIso8601String(),
      'createdAt': task.createdAt.toIso8601String(),
      'completedAt': task.completedAt?.toIso8601String(),
      'estimatedMinutes': task.estimatedMinutes,
      'tags': task.tags,
      'notes': task.notes,
    };
  }

  TaskModel _mapToTaskModel(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id.isNotEmpty ? id : map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
      dayOfWeek: map['dayOfWeek'] ?? 0,
      isImportant: map['isImportant'] ?? false,
      category: TaskCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TaskCategory.other,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      estimatedMinutes: map['estimatedMinutes'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> _statisticsModelToMap(StatisticsModel statistics) {
    return {
      'overallCompletionRate': statistics.overallCompletionRate,
      'totalTasksCompleted': statistics.totalTasksCompleted,
      'totalTasksCreated': statistics.totalTasksCreated,
      'currentStreak': statistics.currentStreak,
      'longestStreak': statistics.longestStreak,
      'averageTasksPerDay': statistics.averageTasksPerDay,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  StatisticsModel _mapToStatisticsModel(Map<String, dynamic> map) {
    return StatisticsModel(
      overallCompletionRate: map['overallCompletionRate'] ?? 0.0,
      totalTasksCompleted: map['totalTasksCompleted'] ?? 0,
      totalTasksCreated: map['totalTasksCreated'] ?? 0,
      dayProductivity: const {},
      categoryStats: const {},
      weeklyTrends: const [],
      mostProductiveDay: DateTime.now(),
      leastProductiveDay: DateTime.now(),
      averageTasksPerDay: map['averageTasksPerDay'] ?? 0.0,
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      hourlyProductivity: const {},
    );
  }
}
