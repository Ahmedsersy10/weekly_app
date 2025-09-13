import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/data/models/task_model.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/enhanced_task_item.dart';

class CustomListTasks extends StatefulWidget {
  final int dayIndex;

  const CustomListTasks({super.key, required this.dayIndex});

  @override
  State<CustomListTasks> createState() => _CustomListTasksState();
}

class _CustomListTasksState extends State<CustomListTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is WeeklySuccess) {
          final tasks = context.read<WeeklyCubit>().getTasksForDay(
            widget.dayIndex,
          );
          if (tasks.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context).tr('more.no_tasks_for_this_day'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          final tasksByCategory = <TaskCategory, List<TaskModel>>{};
          for (final task in tasks) {
            if (!tasksByCategory.containsKey(task.category)) {
              tasksByCategory[task.category] = [];
            }
            tasksByCategory[task.category]!.add(task);
          }

          final sortedCategories = tasksByCategory.keys.toList()
            ..sort(
              (a, b) =>
                  _getCategoryPriority(a).compareTo(_getCategoryPriority(b)),
            );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...sortedCategories.map((category) {
                final categoryTasks = tasksByCategory[category]!;
                final importantTasks = categoryTasks
                    .where((t) => t.isImportant)
                    .toList();
                final regularTasks = categoryTasks
                    .where((t) => !t.isImportant)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (importantTasks.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.warning,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).tr('settings.Important'),

                              style: TextStyle(
                                color: AppColors.textPrimary.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...importantTasks.map(
                        (task) => EnhancedTaskItem(
                          task: task,
                          onEdit: () => _showEditTaskDialog(context, task),
                          onDelete: () => _deleteTask(context, task),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (regularTasks.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.list,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).tr('settings.AsRegular'),
                              style: TextStyle(
                                color: AppColors.textPrimary.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...regularTasks.map(
                        (task) => EnhancedTaskItem(
                          task: task,
                          onEdit: () => _showEditTaskDialog(context, task),
                          onDelete: () => _deleteTask(context, task),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                  ],
                );
              }),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  int _getCategoryPriority(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return 1;
      case TaskCategory.study:
        return 2;
      case TaskCategory.health:
        return 3;
      case TaskCategory.finance:
        return 4;
      case TaskCategory.personal:
        return 5;
      case TaskCategory.home:
        return 6;
      case TaskCategory.other:
        return 7;
    }
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    final TextEditingController titleController = TextEditingController(
      text: task.title,
    );
    bool isImportant = task.isImportant;
    TimeOfDay? reminderTime = task.reminderTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                AppLocalizations.of(context).tr('settings.editTask'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          cursorColor: AppColors.textPrimary,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            ).tr('settings.enterTaskTitle'),
                            hintStyle: const TextStyle(color: AppColors.textTertiary),
                            border: customOutlineInputBorder(),
                            enabledBorder: customOutlineInputBorder(),
                            focusedBorder: customOutlineInputBorder(),
                          ),
                          autofocus: true,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CheckboxListTile(
                            value: isImportant,
                            onChanged: (value) =>
                                setState(() => isImportant = value ?? false),
                            title: Text(
                              AppLocalizations.of(
                                context,
                              ).tr('settings.markAsImportant'),
                              style: AppStyles.styleSemiBold20(context),
                            ),
                            activeColor: AppColors.white,
                            checkColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.white),
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    const Icon(
                                      Icons.notifications,
                                      color: AppColors.primary,
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      ).tr('settings.reminderTime'),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.access_time,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () async {
                                        final selectedTime =
                                            await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  reminderTime ??
                                                  const TimeOfDay(
                                                    hour: 9,
                                                    minute: 0,
                                                  ),
                                            );
                                        if (selectedTime != null) {
                                          setState(
                                            () => reminderTime = selectedTime,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 32,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    reminderTime != null
                                        ? '${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}'
                                        : AppLocalizations.of(
                                            context,
                                          ).tr('settings.noReminder'),
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
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      context.read<WeeklyCubit>().editTask(
                        task.id,
                        titleController.text.trim(),
                        isImportant: isImportant,
                        reminderTime: reminderTime,
                      );

                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: Text(AppLocalizations.of(context).tr('settings.save')),
                ),
              ],
            );
          },
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

  void _deleteTask(BuildContext context, TaskModel task) {
    context.read<WeeklyCubit>().deleteTask(task.id);
  }
}
