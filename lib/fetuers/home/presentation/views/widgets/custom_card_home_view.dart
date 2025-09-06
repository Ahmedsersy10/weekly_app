// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_list_tasks.dart';

class CustomCardHomeView extends StatelessWidget {
  final int dayIndex;

  const CustomCardHomeView({super.key, required this.dayIndex});

  bool _isCurrentDay(String date) {
    final now = DateTime.now();
    final currentDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
    return date == currentDate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is WeeklySuccess) {
          final dayStats = state.weeklyState.dayStats[dayIndex];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              constraints: const BoxConstraints(minHeight: 100, minWidth: double.infinity),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(1, 2),
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context).tr(dayStats.dayName),
                              style: AppStyles.styleSemiBold24(
                                context,
                              ).copyWith(color: AppColors.black),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _isCurrentDay(dayStats.date)
                                    ? AppColors.maroon
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black38, width: 1),
                              ),
                              child: Text(
                                dayStats.date,
                                style: AppStyles.styleSemiBold16(context).copyWith(
                                  color: _isCurrentDay(dayStats.date)
                                      ? AppColors.white
                                      : AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${AppLocalizations.of(context).tr('common.done')} : ${dayStats.completedTasks} / ${dayStats.totalTasks}',
                          style: AppStyles.styleSemiBold20(
                            context,
                          ).copyWith(color: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 20, thickness: 2, color: AppColors.black),
                  // Let content drive height; remove hard ListView
                  _DayContent(dayIndex: dayIndex),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtonAddTasks(dayIndex: dayIndex),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.maroon,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: IconButton(
                          onPressed: () => _confirmClearDay(context, dayIndex),
                          icon: const Icon(Icons.delete, color: AppColors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

void _confirmClearDay(BuildContext context, int dayIndex) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          AppLocalizations.of(ctx).tr('settings.clearDayTasksTitle'),
          style: AppStyles.styleSemiBold24(ctx).copyWith(color: Colors.black),
        ),
        content: Text(
          AppLocalizations.of(ctx).tr('settings.clearDayTasksMessage'),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppLocalizations.of(ctx).tr('settings.cancel'),
              style: const TextStyle(color: AppColors.maroon),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ctx.read<WeeklyCubit>().clearTasksForDay(dayIndex);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.maroon,
              foregroundColor: AppColors.white,
            ),
            child: Text(AppLocalizations.of(ctx).tr('settings.clear')),
          ),
        ],
      );
    },
  );
}

class CustomButtonAddTasks extends StatelessWidget {
  final int dayIndex;

  const CustomButtonAddTasks({super.key, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.maroon, borderRadius: BorderRadius.circular(32)),
      child: IconButton(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    bool isImportant = false;
    TimeOfDay? reminderTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).tr('settings.addNewTask'),
            style: AppStyles.styleSemiBold24(context).copyWith(color: Colors.black),
          ),
          backgroundColor: AppColors.white,
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskController,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).tr('settings.enterTaskTitle'),
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: customOutlineInputBorder(),
                        enabledBorder: customOutlineInputBorder(),
                        focusedBorder: customOutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.maroon,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CheckboxListTile(
                        value: isImportant,
                        onChanged: (value) => setState(() => isImportant = value ?? false),
                        title: Text(
                          AppLocalizations.of(context).tr('settings.markAsImportant'),
                          style: AppStyles.styleSemiBold20(context),
                        ),
                        activeColor: AppColors.white,
                        checkColor: AppColors.maroon,
                        side: const BorderSide(color: AppColors.white),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Reminder time selection
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.maroon.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.maroon.withOpacity(0.3)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                const Icon(Icons.notifications, color: AppColors.maroon),
                                Text(
                                  AppLocalizations.of(context).tr('settings.reminderTime'),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.access_time, color: AppColors.maroon),
                                  onPressed: () async {
                                    final selectedTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
                                    );
                                    if (selectedTime != null) {
                                      setState(() => reminderTime = selectedTime);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 32, bottom: 8),
                              child: Text(
                                reminderTime != null
                                    ? '${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}'
                                    : AppLocalizations.of(context).tr('settings.noReminder'),
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).tr('settings.cancel'),
                style: const TextStyle(color: AppColors.maroon),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.trim().isNotEmpty) {
                  context.read<WeeklyCubit>().addTask(
                    taskController.text.trim(),
                    dayIndex,
                    isImportant: isImportant,
                    reminderTime: reminderTime,
                  );
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: AppColors.white,
              ),
              child: Text(AppLocalizations.of(context).tr('settings.add')),
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder customOutlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }
}

class _DayContent extends StatelessWidget {
  final int dayIndex;
  const _DayContent({required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is! WeeklySuccess) return const SizedBox.shrink();
        final isCollapsed = state.weeklyState.collapsedDays.contains(dayIndex);
        if (isCollapsed) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: AppColors.maroon),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).tr('settings.allTasksDone'),
                  style: const TextStyle(color: AppColors.black),
                ),
              ],
            ),
          );
        }
        return CustomListTasks(dayIndex: dayIndex);
      },
    );
  }
}
