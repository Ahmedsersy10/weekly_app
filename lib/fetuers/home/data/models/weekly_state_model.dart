import 'package:equatable/equatable.dart';
import 'task_model.dart';

class WeeklyStateModel extends Equatable {
  final List<TaskModel> tasks;
  final int weekNumber;
  final int totalTasks;
  final int completedTasks;
  final double completionPercentage;
  final List<DayStats> dayStats;
  final Set<int> collapsedDays;

  const WeeklyStateModel({
    required this.tasks,
    required this.weekNumber,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionPercentage,
    required this.dayStats,
    this.collapsedDays = const {},
  });

  /// Factory constructor يحسب كل القيم تلقائيًا
  factory WeeklyStateModel.withTasks(
    List<TaskModel> tasks,
    List<DayStats> dayStats, {
    Set<int> collapsedDays = const {},
  }) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final percentage = total == 0 ? 0 : completed / total;

    return WeeklyStateModel(
      tasks: tasks,
      weekNumber: _getCurrentWeekNumber(),
      totalTasks: total,
      completedTasks: completed,
      completionPercentage: percentage.toDouble(),
      dayStats: dayStats,
      collapsedDays: collapsedDays,
    );
  }

  WeeklyStateModel copyWith({
    List<TaskModel>? tasks,
    int? weekNumber,
    int? totalTasks,
    int? completedTasks,
    double? completionPercentage,
    List<DayStats>? dayStats,
    Set<int>? collapsedDays,
  }) {
    return WeeklyStateModel(
      tasks: tasks ?? this.tasks,
      weekNumber: weekNumber ?? this.weekNumber,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      dayStats: dayStats ?? this.dayStats,
      collapsedDays: collapsedDays ?? this.collapsedDays,
    );
  }

  @override
  List<Object?> get props => [
    tasks,
    weekNumber,
    totalTasks,
    completedTasks,
    completionPercentage,
    dayStats,
    collapsedDays,
  ];

  static int _getCurrentWeekNumber() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // بداية السنة
    final startOfYear = DateTime(today.year, 1, 1);

    // حساب يوم الأسبوع: السبت = 6, الأحد = 0, الاثنين = 1, ... الجمعة = 5
    final startOfYearWeekday = startOfYear.weekday == 7
        ? 0
        : startOfYear.weekday;

    // نحسب كام يوم نرجع عشان نوصل لأقرب سبت قبل أو عند 1 يناير
    // لو 1 يناير = سبت (0) → ما نرجعش حاجة (0 أيام)
    // لو 1 يناير = أحد (1) → نرجع يوم واحد
    // لو 1 يناير = أربعاء (3) → نرجع 4 أيام
    final daysToSubtract = startOfYearWeekday == 0 ? 0 : 7 - startOfYearWeekday;

    // أول سبت في السنة أو قبلها
    final firstWeekStart = startOfYear.subtract(Duration(days: daysToSubtract));

    // بداية الأسبوع الحالي (السبت)
    final todayWeekday = today.weekday == 7 ? 0 : today.weekday;
    final startOfCurrentWeek = today.subtract(Duration(days: todayWeekday));

    // الفرق بالأيام
    final daysSinceStart = startOfCurrentWeek.difference(firstWeekStart).inDays;

    // رقم الأسبوع
    return (daysSinceStart ~/ 7) + 1;
  }

  // دالة للاختبار
  void testWeekCalculation() {
    // اختبار على تواريخ مختلفة
    final testDates = [
      DateTime(2025, 1, 1), // 1 يناير 2025 (الأربعاء)
      DateTime(2025, 1, 4), // 4 يناير 2025 (السبت)
      DateTime(2025, 8, 16), // 16 أغسطس 2025 (السبت)
    ];

    for (final date in testDates) {
      final weekNum = _getWeekNumberForDate(date);
      print(
        'التاريخ: ${date.day}/${date.month}/${date.year} = الأسبوع $weekNum',
      );
    }
  }

  // دالة مساعدة لحساب رقم الأسبوع لتاريخ معين
  static int _getWeekNumberForDate(DateTime targetDate) {
    final today = DateTime(targetDate.year, targetDate.month, targetDate.day);

    final startOfYear = DateTime(today.year, 1, 1);
    final startOfYearWeekday = startOfYear.weekday == 7
        ? 0
        : startOfYear.weekday;
    final daysToSubtract = startOfYearWeekday == 0 ? 0 : 7 - startOfYearWeekday;
    final firstWeekStart = startOfYear.subtract(Duration(days: daysToSubtract));

    final todayWeekday = today.weekday == 7 ? 0 : today.weekday;
    final startOfCurrentWeek = today.subtract(Duration(days: todayWeekday));

    final daysSinceStart = startOfCurrentWeek.difference(firstWeekStart).inDays;
    return (daysSinceStart ~/ 7) + 1;
  }
}

class DayStats extends Equatable {
  final int dayOfWeek;
  final String dayName;
  final int totalTasks;
  final int completedTasks;
  final String date;

  const DayStats({
    required this.dayOfWeek,
    required this.dayName,
    required this.totalTasks,
    required this.completedTasks,
    required this.date,
  });

  @override
  List<Object?> get props => [
    dayOfWeek,
    dayName,
    totalTasks,
    completedTasks,
    date,
  ];
}
