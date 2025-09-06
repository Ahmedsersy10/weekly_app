import '../../fetuers/home/data/models/task_model.dart';
import '../../fetuers/home/data/models/statistics_model.dart';

class StatisticsService {
  static final StatisticsService _instance = StatisticsService._internal();
  factory StatisticsService() => _instance;
  StatisticsService._internal();

  // Cache for statistics to avoid recalculation
  StatisticsModel? _cachedStatistics;
  List<TaskModel>? _cachedTasks;
  DateTime? _lastCalculationTime;

  // Cache duration (5 minutes)
  static const Duration _cacheDuration = Duration(minutes: 5);

  StatisticsModel calculateStatistics(List<TaskModel> tasks) {
    // Check if we can use cached statistics
    if (_canUseCache(tasks)) {
      return _cachedStatistics!;
    }

    // Calculate basic statistics synchronously for immediate response
    final basicStats = _calculateBasicStatistics(tasks);

    // Cache the result
    _cachedStatistics = basicStats;
    _cachedTasks = List.from(tasks);
    _lastCalculationTime = DateTime.now();

    // Calculate detailed statistics asynchronously
    _calculateDetailedStatisticsAsync(tasks);

    return basicStats;
  }

  bool _canUseCache(List<TaskModel> tasks) {
    if (_cachedStatistics == null ||
        _cachedTasks == null ||
        _lastCalculationTime == null) {
      return false;
    }

    // Check if tasks have changed
    if (_cachedTasks!.length != tasks.length) return false;

    // Check if cache is still valid
    if (DateTime.now().difference(_lastCalculationTime!) > _cacheDuration) {
      return false;
    }

    return true;
  }

  StatisticsModel _calculateBasicStatistics(List<TaskModel> tasks) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final overallCompletionRate = totalTasks > 0
        ? (completedTasks / totalTasks) * 100
        : 0.0;

    // Calculate only essential statistics synchronously
    final dayProductivity = _calculateDayProductivity(tasks);
    final averageTasksPerDay = _calculateAverageTasksPerDay(tasks);

    return StatisticsModel(
      overallCompletionRate: overallCompletionRate,
      totalTasksCompleted: completedTasks,
      totalTasksCreated: totalTasks,
      dayProductivity: dayProductivity,
      categoryStats: const {}, // Will be calculated asynchronously
      weeklyTrends: const [], // Will be calculated asynchronously
      mostProductiveDay: DateTime.now(), // Placeholder
      leastProductiveDay: DateTime.now(), // Placeholder
      averageTasksPerDay: averageTasksPerDay,
      currentStreak: 0, // Will be calculated asynchronously
      longestStreak: 0, // Will be calculated asynchronously
      hourlyProductivity: const {}, // Will be calculated asynchronously
    );
  }

  Future<void> _calculateDetailedStatisticsAsync(List<TaskModel> tasks) async {
    // Use compute for heavy calculations
    try {
      final result = await _calculateFullStatisticsAsync(tasks);
      _cachedStatistics = result;
    } catch (e) {
      // Fallback to synchronous calculation if compute fails
      _cachedStatistics = _calculateFullStatistics(tasks);
    }
  }

  Future<StatisticsModel> _calculateFullStatisticsAsync(
    List<TaskModel> tasks,
  ) async {
    // For now, use synchronous calculation but in a microtask to avoid blocking
    return Future.microtask(() => _calculateFullStatistics(tasks));
  }

  StatisticsModel _calculateFullStatistics(List<TaskModel> tasks) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final overallCompletionRate = totalTasks > 0
        ? (completedTasks / totalTasks) * 100
        : 0.0;

    final dayProductivity = _calculateDayProductivity(tasks);
    final categoryStats = _calculateCategoryStats(tasks);
    final weeklyTrends = _calculateWeeklyTrends(tasks);
    final mostProductiveDay = _findMostProductiveDay(tasks);
    final leastProductiveDay = _findLeastProductiveDay(tasks);
    final averageTasksPerDay = _calculateAverageTasksPerDay(tasks);
    final currentStreak = _calculateCurrentStreak(tasks);
    final longestStreak = _calculateLongestStreak(tasks);
    final hourlyProductivity = _calculateHourlyProductivity(tasks);

    return StatisticsModel(
      overallCompletionRate: overallCompletionRate,
      totalTasksCompleted: completedTasks,
      totalTasksCreated: totalTasks,
      dayProductivity: dayProductivity,
      categoryStats: categoryStats,
      weeklyTrends: weeklyTrends,
      mostProductiveDay: mostProductiveDay,
      leastProductiveDay: leastProductiveDay,
      averageTasksPerDay: averageTasksPerDay,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      hourlyProductivity: hourlyProductivity,
    );
  }

  Map<int, DayProductivityStats> _calculateDayProductivity(
    List<TaskModel> tasks,
  ) {
    final dayNames = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
    ];
    final dayStats = <int, DayProductivityStats>{};

    for (int i = 0; i < 6; i++) {
      final dayTasks = tasks.where((task) => task.dayOfWeek == i).toList();
      final totalTasks = dayTasks.length;
      final completedTasks = dayTasks.where((task) => task.isCompleted).length;
      final completionRate = totalTasks > 0
          ? (completedTasks / totalTasks) * 100
          : 0.0;

      // Calculate average completion time
      double averageCompletionTime = 0.0;
      if (completedTasks > 0) {
        final completedTaskTimes = dayTasks
            .where((task) => task.isCompleted && task.completedAt != null)
            .map(
              (task) => task.completedAt!.difference(task.createdAt).inMinutes,
            )
            .toList();

        if (completedTaskTimes.isNotEmpty) {
          averageCompletionTime =
              completedTaskTimes.reduce((a, b) => a + b) /
              completedTaskTimes.length;
        }
      }

      // Find most productive hour for this day
      final mostProductiveHour = _findMostProductiveHour(dayTasks);

      dayStats[i] = DayProductivityStats(
        dayOfWeek: i,
        dayName: dayNames[i],
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        completionRate: completionRate,
        averageCompletionTime: averageCompletionTime,
        mostProductiveHour: mostProductiveHour,
      );
    }

    return dayStats;
  }

  Map<TaskCategory, CategoryStats> _calculateCategoryStats(
    List<TaskModel> tasks,
  ) {
    final categoryStats = <TaskCategory, CategoryStats>{};

    for (final category in TaskCategory.values) {
      final categoryTasks = tasks
          .where((task) => task.category == category)
          .toList();
      final totalTasks = categoryTasks.length;
      final completedTasks = categoryTasks
          .where((task) => task.isCompleted)
          .length;
      final completionRate = totalTasks > 0
          ? (completedTasks / totalTasks) * 100
          : 0.0;

      // Calculate average completion time for this category
      double averageCompletionTime = 0.0;
      if (completedTasks > 0) {
        final completedTaskTimes = categoryTasks
            .where((task) => task.isCompleted && task.completedAt != null)
            .map(
              (task) => task.completedAt!.difference(task.createdAt).inMinutes,
            )
            .toList();

        if (completedTaskTimes.isNotEmpty) {
          averageCompletionTime =
              completedTaskTimes.reduce((a, b) => a + b) /
              completedTaskTimes.length;
        }
      }

      categoryStats[category] = CategoryStats(
        category: category,
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        completionRate: completionRate,
        averageCompletionTime: averageCompletionTime,
      );
    }

    return categoryStats;
  }

  List<WeeklyTrend> _calculateWeeklyTrends(List<TaskModel> tasks) {
    final weeklyTrends = <WeeklyTrend>[];

    // Group tasks by week
    final weekGroups = <String, List<TaskModel>>{};

    for (final task in tasks) {
      final weekStart = _getWeekStart(task.createdAt);
      final weekKey = weekStart.toIso8601String();

      if (!weekGroups.containsKey(weekKey)) {
        weekGroups[weekKey] = [];
      }
      weekGroups[weekKey]!.add(task);
    }

    // Calculate trends for each week
    for (final entry in weekGroups.entries) {
      final weekTasks = entry.value;
      final totalTasks = weekTasks.length;
      final completedTasks = weekTasks.where((task) => task.isCompleted).length;
      final completionRate = totalTasks > 0
          ? (completedTasks / totalTasks) * 100
          : 0.0;

      // Calculate productivity score based on completion rate and task complexity
      double productivityScore = completionRate;
      if (totalTasks > 0) {
        final averagePriority =
            weekTasks
                .map((task) => _priorityToNumber(task.priority))
                .reduce((a, b) => a + b) /
            totalTasks;
        final importantTasks = weekTasks
            .where((task) => task.isImportant)
            .length;
        productivityScore +=
            (importantTasks / totalTasks) * 20; // Bonus for important tasks
        productivityScore +=
            (5 - averagePriority) * 5; // Bonus for high priority tasks
      }

      weeklyTrends.add(
        WeeklyTrend(
          weekStart: DateTime.parse(entry.key),
          totalTasks: totalTasks,
          completedTasks: completedTasks,
          completionRate: completionRate,
          productivityScore: productivityScore,
        ),
      );
    }

    // Sort by week start date
    weeklyTrends.sort((a, b) => a.weekStart.compareTo(b.weekStart));

    return weeklyTrends;
  }

  DateTime _findMostProductiveDay(List<TaskModel> tasks) {
    final dayProductivity = _calculateDayProductivity(tasks);

    if (dayProductivity.isEmpty) return DateTime.now();

    final mostProductive = dayProductivity.entries.reduce((a, b) {
      final aScore = a.value.completionRate + (a.value.totalTasks * 0.1);
      final bScore = b.value.completionRate + (b.value.totalTasks * 0.1);
      return aScore > bScore ? a : b;
    });

    // Convert day index to actual date
    final today = DateTime.now();
    final daysSinceWeekStart = today.weekday - 6; // Saturday = 0
    final mostProductiveDayIndex = mostProductive.key;
    final daysToAdd = mostProductiveDayIndex - daysSinceWeekStart;

    return today.add(Duration(days: daysToAdd));
  }

  DateTime _findLeastProductiveDay(List<TaskModel> tasks) {
    final dayProductivity = _calculateDayProductivity(tasks);

    if (dayProductivity.isEmpty) return DateTime.now();

    final leastProductive = dayProductivity.entries.reduce((a, b) {
      final aScore = a.value.completionRate + (a.value.totalTasks * 0.1);
      final bScore = b.value.completionRate + (b.value.totalTasks * 0.1);
      return aScore < bScore ? a : b;
    });

    // Convert day index to actual date
    final today = DateTime.now();
    final daysSinceWeekStart = today.weekday - 6; // Saturday = 0
    final leastProductiveDayIndex = leastProductive.key;
    final daysToAdd = leastProductiveDayIndex - daysSinceWeekStart;

    return today.add(Duration(days: daysToAdd));
  }

  double _calculateAverageTasksPerDay(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0.0;

    final dayCounts = <int, int>{};
    for (final task in tasks) {
      dayCounts[task.dayOfWeek] = (dayCounts[task.dayOfWeek] ?? 0) + 1;
    }

    if (dayCounts.isEmpty) return 0.0;

    final totalTasks = dayCounts.values.reduce((a, b) => a + b);
    return totalTasks / dayCounts.length;
  }

  int _calculateCurrentStreak(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;

    final today = DateTime.now();
    int streak = 0;

    // Check consecutive days backwards from today
    for (int i = 0; i < 30; i++) {
      // Check up to 30 days back
      final checkDate = today.subtract(Duration(days: i));
      final dayIndex = _getDayIndex(checkDate);

      if (dayIndex != null) {
        final dayTasks = tasks
            .where((task) => task.dayOfWeek == dayIndex)
            .toList();
        if (dayTasks.isNotEmpty && dayTasks.every((task) => task.isCompleted)) {
          streak++;
        } else {
          break; // Streak broken
        }
      }
    }

    return streak;
  }

  int _calculateLongestStreak(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;

    int longestStreak = 0;
    int currentStreak = 0;

    // Group tasks by date and check for consecutive completion days
    final completionDates = <DateTime>{};
    for (final task in tasks) {
      if (task.isCompleted && task.completedAt != null) {
        completionDates.add(
          DateTime(
            task.completedAt!.year,
            task.completedAt!.month,
            task.completedAt!.day,
          ),
        );
      }
    }

    final sortedDates = completionDates.toList()..sort();

    for (int i = 0; i < sortedDates.length; i++) {
      if (i == 0 || sortedDates[i].difference(sortedDates[i - 1]).inDays == 1) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak
            ? currentStreak
            : longestStreak;
      } else {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }

  Map<int, int> _calculateHourlyProductivity(List<TaskModel> tasks) {
    final hourlyProductivity = <int, int>{};

    for (int hour = 0; hour < 24; hour++) {
      hourlyProductivity[hour] = 0;
    }

    for (final task in tasks) {
      if (task.isCompleted && task.completedAt != null) {
        final hour = task.completedAt!.hour;
        hourlyProductivity[hour] = (hourlyProductivity[hour] ?? 0) + 1;
      }
    }

    return hourlyProductivity;
  }

  int _findMostProductiveHour(List<TaskModel> tasks) {
    final hourlyProductivity = _calculateHourlyProductivity(tasks);

    if (hourlyProductivity.isEmpty) return 9; // Default to 9 AM

    final mostProductive = hourlyProductivity.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return mostProductive.key;
  }

  DateTime _getWeekStart(DateTime date) {
    final daysSinceMonday = date.weekday - 1;
    return date.subtract(Duration(days: daysSinceMonday));
  }

  int? _getDayIndex(DateTime date) {
    // App indices: 0=Saturday ... 5=Thursday, Friday off
    final weekday = date.weekday;
    switch (weekday) {
      case DateTime.saturday: // 6
        return 0;
      case DateTime.sunday: // 7
        return 1;
      case DateTime.monday: // 1
        return 2;
      case DateTime.tuesday: // 2
        return 3;
      case DateTime.wednesday: // 3
        return 4;
      case DateTime.thursday: // 4
        return 5;
      case DateTime.friday: // 5
        return null; // day off
    }
    return null;
  }

  int _priorityToNumber(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.high:
        return 3;
      case TaskPriority.urgent:
        return 4;
    }
  }

  // Additional statistics methods
  Map<TaskPriority, int> getPriorityDistribution(List<TaskModel> tasks) {
    final distribution = <TaskPriority, int>{};
    for (final priority in TaskPriority.values) {
      distribution[priority] = tasks
          .where((task) => task.priority == priority)
          .length;
    }
    return distribution;
  }

  Map<TaskCategory, int> getCategoryDistribution(List<TaskModel> tasks) {
    final distribution = <TaskCategory, int>{};
    for (final category in TaskCategory.values) {
      distribution[category] = tasks
          .where((task) => task.category == category)
          .length;
    }
    return distribution;
  }

  double getAverageTaskCompletionTime(List<TaskModel> tasks) {
    final completedTasks = tasks
        .where((task) => task.isCompleted && task.completedAt != null)
        .toList();
    if (completedTasks.isEmpty) return 0.0;

    final totalTime = completedTasks
        .map((task) => task.completedAt!.difference(task.createdAt).inMinutes)
        .reduce((a, b) => a + b);

    return totalTime / completedTasks.length;
  }

  int getOverdueTasksCount(List<TaskModel> tasks) {
    return tasks.where((task) => task.isOverdue).length;
  }

  int getDueTodayTasksCount(List<TaskModel> tasks) {
    return tasks.where((task) => task.isDueToday).length;
  }

  int getDueSoonTasksCount(List<TaskModel> tasks) {
    return tasks.where((task) => task.isDueSoon).length;
  }
}
