import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/data/models/task_model.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';

class EnhancedTaskItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EnhancedTaskItem({super.key, required this.task, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!();
        } else {
          context.read<WeeklyCubit>().deleteTask(task.id);
        }
      },
      background: _buildDismissBackground(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showTaskOptions(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category color indicator
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.maroon,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Task content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reminder time (if exists)
                        if (task.reminderTime != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: Theme.of(context).colorScheme.primary,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${AppLocalizations.of(context).tr('task.reminder')}: ${_formatTime(context, task.reminderTime!)}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],

                        // Task title
                        Text(
                          task.title,
                          style: TextStyle(
                            color: task.isCompleted
                                ? AppColors.black.withOpacity(0.6)
                                : AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),

                        // Task description (if available)
                        if (task.description != null && task.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description!,
                            style: TextStyle(color: AppColors.black.withOpacity(0.6), fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        // Tags (if available)
                        if (task.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: task.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.maroon.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.maroon.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: const TextStyle(
                                    color: AppColors.maroon,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // Due date and estimated time
                        if (task.dueDate != null || task.estimatedMinutes > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (task.dueDate != null) ...[
                                Icon(
                                  Icons.schedule,
                                  color: AppColors.black.withOpacity(0.5),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getRelativeDateText(context, task.dueDate!),
                                  style: TextStyle(
                                    color: AppColors.black.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],

                              if (task.dueDate != null && task.estimatedMinutes > 0) ...[
                                const SizedBox(width: 16),
                              ],

                              if (task.estimatedMinutes > 0) ...[
                                Icon(
                                  Icons.timer,
                                  color: AppColors.black.withOpacity(0.5),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${task.estimatedMinutes} min',
                                  style: TextStyle(
                                    color: AppColors.black.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Completion checkbox
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: task.isCompleted ? AppColors.maroon : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: task.isCompleted
                            ? AppColors.maroon
                            : AppColors.black.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        context.read<WeeklyCubit>().toggleTaskCompletion(task.id);
                      },
                      activeColor: AppColors.maroon,
                      checkColor: AppColors.white,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD20F01),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    // Format time based on 12-hour or 24-hour format
    final timeString = TimeOfDay(hour: time.hour, minute: time.minute).format(context);

    return timeString;
  }

  String _getRelativeDateText(BuildContext context, DateTime dueDate) {
    final today = DateTime.now();
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDay == today) {
      return AppLocalizations.of(context).tr('common.today');
    } else if (dueDay == today.add(const Duration(days: 1))) {
      return AppLocalizations.of(context).tr('common.tomorrow');
    } else if (dueDay == today.subtract(const Duration(days: 1))) {
      return AppLocalizations.of(context).tr('common.yesterday');
    } else {
      final difference = dueDay.difference(today).inDays;
      if (difference > 0) {
        return AppLocalizations.of(
          context,
        ).trWithParams('common.inDays', {'days': difference.toString()});
      } else {
        return AppLocalizations.of(
          context,
        ).trWithParams('common.daysAgo', {'days': difference.abs().toString()});
      }
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(
            AppLocalizations.of(context).tr('settings.deleteTask'),
            style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppLocalizations.of(
              context,
            ).trWithParams('settings.deleteTaskConfirmation', {'taskTitle': task.title}),
            style: const TextStyle(color: AppColors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                AppLocalizations.of(context).tr('settings.cancel'),
                style: const TextStyle(color: AppColors.maroon),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: AppColors.white,
              ),
              child: Text(AppLocalizations.of(context).tr('settings.deleteTask')),
            ),
          ],
        );
      },
    );
  }

  void _showTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                // 'Task Options',
                AppLocalizations.of(context).tr('task.options'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionButton(
                context,
                AppLocalizations.of(context).tr('edit.tasks'),
                Icons.edit,
                () {
                  Navigator.of(context).pop();
                  if (onEdit != null) {
                    onEdit!();
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildOptionButton(
                context,
                AppLocalizations.of(context).tr('delete.task'),
                Icons.delete,
                () {
                  Navigator.of(context).pop();
                  if (onDelete != null) {
                    onDelete!();
                  } else {
                    context.read<WeeklyCubit>().deleteTask(task.id);
                  }
                },
                isDestructive: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: isDestructive ? Colors.white : AppColors.maroon),
        label: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.white : AppColors.maroon,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? AppColors.maroon : AppColors.white,
          foregroundColor: isDestructive ? Colors.white : AppColors.maroon,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
