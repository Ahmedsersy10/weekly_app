import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/services/motivational_service.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';

class ProgressOverviewWidget extends StatelessWidget {
  const ProgressOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is WeeklySuccess) {
          final cubit = context.read<WeeklyCubit>();
          final todayIndex = _getTodayIndex();
          final todayTasks = cubit.getTasksForDay(todayIndex);
          final completedTasks = todayTasks
              .where((task) => task.isCompleted)
              .length;
          final totalTasks = todayTasks.length;
          final progressPercentage = totalTasks > 0
              ? (completedTasks / totalTasks) * 100
              : 0.0;

          final motivationalQuote = MotivationalService.getPersonalizedQuote(
            context,
            progressPercentage: progressPercentage,
            currentStreak: cubit.getCurrentStreak(),
            overdueCount: cubit.getOverdueTasksCount(),
          );

          final colorScheme = Theme.of(context).colorScheme;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.maroon,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).tr('more.progress'),
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getTodayDateString(),
                          style: TextStyle(
                            color: colorScheme.onPrimary.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.today,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progressPercentage / 100,
                            strokeWidth: 8,
                            constraints: const BoxConstraints(
                              minHeight: 80,
                              minWidth: 80,
                            ),
                            backgroundColor: colorScheme.onPrimary.withOpacity(
                              0.3,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${progressPercentage.toInt()}%',
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).tr('common.done'),
                                style: TextStyle(
                                  color: colorScheme.onPrimary.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatRow(
                            context,
                            AppLocalizations.of(context).tr('more.totalTasks'),
                            totalTasks,
                            Icons.list,
                          ),
                          const SizedBox(height: 8),
                          _buildStatRow(
                            context,
                            AppLocalizations.of(context).tr('more.completed'),
                            completedTasks,
                            Icons.check_circle,
                          ),
                          const SizedBox(height: 8),
                          _buildStatRow(
                            context,
                            AppLocalizations.of(context).tr('more.remaining'),
                            totalTasks - completedTasks,
                            Icons.pending,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.onPrimary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_emotions,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          motivationalQuote,
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    int value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colorScheme.onPrimary.withOpacity(0.8), size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: colorScheme.onPrimary.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        Text(
          '$value',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  int _getTodayIndex() {
    final today = DateTime.now();
    final weekday = today.weekday;

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
        return 2; // Default to Monday for Friday
      default:
        return 2;
    }
  }

  String _getTodayDateString() {
    final today = DateTime.now();
    final days = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${days[today.weekday - 1]}, ${months[today.month - 1]} ${today.day}';
  }
}
