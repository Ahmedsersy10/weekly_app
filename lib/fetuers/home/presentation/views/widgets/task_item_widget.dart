import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/fetuers/home/data/models/task_model.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showCheckbox;
  final bool showPriority;
  final bool showCategory;
  final bool showDueDate;
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;

  const TaskItemWidget({
    super.key,
    required this.task,
    this.onTap,
    this.onLongPress,
    this.showCheckbox = true,
    this.showPriority = true,
    this.showCategory = true,
    this.showDueDate = true,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (showCheckbox) ...[
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) => onToggleComplete?.call(),
                  activeColor: AppColors.maroon,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: AppStyles.styleSemiBold16(context).copyWith(
                              color: task.isCompleted
                                  ? AppColors.black.withOpacity(0.6)
                                  : AppColors.black,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        if (showPriority && task.isImportant)
                          const Icon(
                            Icons.priority_high,
                            color: Colors.red,
                            size: 16,
                          ),
                      ],
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: AppStyles.styleRegular14(
                          context,
                        ).copyWith(color: AppColors.black.withOpacity(0.7)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (showCategory) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(
                                task.category,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              task.category.name,
                              style: AppStyles.styleRegular12(context).copyWith(
                                color: _getCategoryColor(task.category),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (showDueDate && task.dueDate != null) ...[
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.black.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(task.dueDate!),
                            style: AppStyles.styleRegular12(
                              context,
                            ).copyWith(color: AppColors.black.withOpacity(0.6)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (showActions) ...[
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.green;
      case TaskCategory.health:
        return Colors.red;
      case TaskCategory.study:
        return Colors.orange;
      case TaskCategory.finance:
        return Colors.purple;
      case TaskCategory.home:
        return Colors.pink;
      case TaskCategory.other:
        return Colors.grey;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDay == today) {
      return 'Today';
    } else if (dueDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (dueDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      final difference = dueDay.difference(today).inDays;
      if (difference > 0) {
        return 'In $difference days';
      } else {
        return '${difference.abs()} days ago';
      }
    }
  }
}
