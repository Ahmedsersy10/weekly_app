import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/core/util/app_theme.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_list_tasks.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/recurrence_model.dart';
import '../../../data/models/category_model.dart';
import 'package:weekly_dash_board/util/app_icons.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 120,
                minWidth: double.infinity,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context).tr(dayStats.dayName),
                              style: Theme.of(context).textTheme.displaySmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontSize: AppTheme.getResponsiveFontSize(
                                      context,
                                      fontSize: 26,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _isCurrentDay(dayStats.date)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                dayStats.date,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      color: _isCurrentDay(dayStats.date)
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      fontSize: AppTheme.getResponsiveFontSize(
                                        context,
                                        fontSize: 16,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${AppLocalizations.of(context).tr('common.done')} : ${dayStats.completedTasks} / ${dayStats.totalTasks}',
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppTheme.getResponsiveFontSize(
                                  context,
                                  fontSize: 20,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DayContent(dayIndex: dayIndex),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtonAddTasks(dayIndex: dayIndex),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () =>
                                _confirmClearDay(context, dayIndex),
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          AppLocalizations.of(ctx).tr('settings.clearDayTasksTitle'),
          style: Theme.of(ctx).textTheme.displaySmall!.copyWith(
            color: Theme.of(ctx).colorScheme.onSurface,
            fontSize: AppTheme.getResponsiveFontSize(ctx, fontSize: 24),
          ),
        ),
        content: Text(
          AppLocalizations.of(ctx).tr('settings.clearDayTasksMessage'),
          style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppLocalizations.of(ctx).tr('settings.cancel'),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ctx.read<WeeklyCubit>().clearTasksForDay(dayIndex);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => _showAddTaskDialog(context),
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    String selectedCategoryId = 'other';
    TimeOfDay? reminderTime;
    bool showAdvancedOptions = false;
    RecurrenceType selectedRecurrenceType = RecurrenceType.none;
    int recurrenceInterval = 1;
    List<int> selectedWeekdays = [];
    RecurrenceEndType recurrenceEndType = RecurrenceEndType.never;
    int? maxOccurrences;
    DateTime? recurrenceEndDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).tr('settings.addNewTask'),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 24),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field - first with auto-focus
                    TextField(
                      controller: taskController,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        ).tr('settings.enterTaskTitle'),
                        hintStyle: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: customOutlineInputBorder(context),
                        enabledBorder: customOutlineInputBorder(context),
                        focusedBorder: customOutlineInputBorder(context),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),

                    // Priority selection with clickable icons
                    Text(
                      'الأولوية',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: TaskPriority.values.map((priority) {
                        final isSelected = selectedPriority == priority;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedPriority = priority),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.outline.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppIcons.createPriorityIcon(
                                  priority.name,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.primary,
                                  size: AppIcons.large,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getPriorityLabel(priority),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.surface
                                        : Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Collapsible advanced options
                    GestureDetector(
                      onTap: () => setState(
                        () => showAdvancedOptions = !showAdvancedOptions,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              showAdvancedOptions
                                  ? AppIcons.collapse
                                  : AppIcons.expand,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'خيارات متقدمة',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (showAdvancedOptions) ...[
                      const SizedBox(height: 16),

                      // Category selection
                      Text(
                        AppLocalizations.of(context).tr('settings.category'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: TaskCategoryModel.getDefaultCategories().map((
                          category,
                        ) {
                          final isSelected = selectedCategoryId == category.id;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategoryId = category.id;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.outline.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcons.createCategoryIcon(
                                    category.name,
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                    size: AppIcons.small,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getCategoryLabel(category),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Recurrence selection
                      Text(
                        'التكرار',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: RecurrenceType.values.map((type) {
                          final isSelected = selectedRecurrenceType == type;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => selectedRecurrenceType = type),
                              child: Container(
                                margin: const EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline
                                              .withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  _getRecurrenceTypeLabel(type),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.surface
                                        : Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Weekly recurrence options
                      if (selectedRecurrenceType == RecurrenceType.weekly) ...[
                        const SizedBox(height: 12),
                        Text(
                          'أيام الأسبوع',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (int i = 0; i < 6; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedWeekdays.contains(i)) {
                                      selectedWeekdays.remove(i);
                                    } else {
                                      selectedWeekdays.add(i);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedWeekdays.contains(i)
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: selectedWeekdays.contains(i)
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    _getDayLabel(i),
                                    style: TextStyle(
                                      color: selectedWeekdays.contains(i)
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],

                      // Recurrence interval
                      if (selectedRecurrenceType != RecurrenceType.none) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              selectedRecurrenceType == RecurrenceType.daily
                                  ? 'كل'
                                  : 'كل',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '1',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                                onChanged: (value) {
                                  final parsed = int.tryParse(value);
                                  if (parsed != null && parsed > 0) {
                                    setState(() => recurrenceInterval = parsed);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selectedRecurrenceType == RecurrenceType.daily
                                  ? 'يوم'
                                  : 'أسبوع',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Reminder time
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
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
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).tr('settings.reminderTime'),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.access_time,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    onPressed: () async {
                                      final selectedTime = await showTimePicker(
                                        context: context,
                                        initialTime:
                                            reminderTime ??
                                            const TimeOfDay(hour: 9, minute: 0),
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            // Quick Add button
            TextButton(
              onPressed: () {
                if (taskController.text.trim().isNotEmpty) {
                  context.read<WeeklyCubit>().addQuickTask(
                    taskController.text.trim(),
                    dayIndex,
                  );
                  Navigator.of(context).pop();
                  // Show snackbar for quick add confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'تم إضافة المهمة بسرعة! يمكنك تعديلها لاحقاً',
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(
                'إضافة سريعة',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.trim().isNotEmpty) {
                  RecurrenceRule? recurrenceRule;

                  if (selectedRecurrenceType != RecurrenceType.none) {
                    recurrenceRule = RecurrenceRule(
                      type: selectedRecurrenceType,
                      interval: recurrenceInterval,
                      weekdays: selectedRecurrenceType == RecurrenceType.weekly
                          ? selectedWeekdays
                          : [dayIndex],
                      endType: recurrenceEndType,
                      maxOccurrences: maxOccurrences,
                      endDate: recurrenceEndDate,
                      startDate: DateTime.now(),
                    );
                  }

                  context.read<WeeklyCubit>().addTask(
                    taskController.text.trim(),
                    dayIndex,
                    priority: selectedPriority,
                    categoryId: selectedCategoryId,
                    reminderTime: reminderTime,
                    isImportant:
                        selectedPriority == TaskPriority.high ||
                        selectedPriority == TaskPriority.urgent,
                    recurrenceRule: recurrenceRule,
                  );
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(AppLocalizations.of(context).tr('settings.add')),
            ),
          ],
        );
      },
    );
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'منخفضة';
      case TaskPriority.medium:
        return 'متوسطة';
      case TaskPriority.high:
        return 'عالية';
      case TaskPriority.urgent:
        return 'عاجلة';
    }
  }

  String _getCategoryLabel(TaskCategoryModel category) {
    return category.nameAr;
  }

  String _getRecurrenceTypeLabel(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.none:
        return 'بدون';
      case RecurrenceType.daily:
        return 'يومي';
      case RecurrenceType.weekly:
        return 'أسبوعي';
      case RecurrenceType.custom:
        return 'مخصص';
    }
  }

  String _getDayLabel(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return 'سبت';
      case 1:
        return 'أحد';
      case 2:
        return 'اثنين';
      case 3:
        return 'ثلاثاء';
      case 4:
        return 'أربعاء';
      case 5:
        return 'خميس';
      default:
        return '';
    }
  }

  OutlineInputBorder customOutlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).tr('settings.allTasksDone'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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
