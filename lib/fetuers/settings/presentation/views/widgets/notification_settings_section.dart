import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/views/widgets/settings_section.dart';

class NotificationSettingsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final Map<int, TimeOfDay> reminderTimes;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<Map<int, TimeOfDay>> onReminderTimesChanged;

  const NotificationSettingsSection({
    super.key,
    required this.notificationsEnabled,
    required this.reminderTimes,
    required this.onNotificationsChanged,
    required this.onReminderTimesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SettingsSection(
      title: AppLocalizations.of(context).tr('settings.notifications'),
      children: [
        SwitchListTile(
          title: Text(
            AppLocalizations.of(context).tr('settings.enableNotifications'),
            style: TextStyle(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            AppLocalizations.of(context).tr('settings.receiveReminders'),
            style: TextStyle(color: colorScheme.onSurface),
          ),
          value: notificationsEnabled,
          onChanged: onNotificationsChanged,
          secondary: Icon(Icons.notifications, color: colorScheme.primary),
        ),
        if (notificationsEnabled) ...[
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).tr('settings.reminderTimes'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(7, (index) {
            final dayIndex = index + 1; // 1 = Monday, 7 = Sunday
            final time =
                reminderTimes[dayIndex] ?? const TimeOfDay(hour: 9, minute: 0);
            final dayNames = [
              '',
              AppLocalizations.of(context).tr('settings.weekDays.monday'),
              AppLocalizations.of(context).tr('settings.weekDays.tuesday'),
              AppLocalizations.of(context).tr('settings.weekDays.wednesday'),
              AppLocalizations.of(context).tr('settings.weekDays.thursday'),
              AppLocalizations.of(context).tr('settings.weekDays.friday'),
              AppLocalizations.of(context).tr('settings.weekDays.saturday'),
              AppLocalizations.of(context).tr('settings.weekDays.sunday'),
            ];

            return ListTile(
              title: Text(
                dayNames[dayIndex],
                style: TextStyle(color: colorScheme.onSurface),
              ),
              subtitle: Text(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              leading: Icon(Icons.access_time, color: colorScheme.primary),
              trailing: TextButton(
                onPressed: () => _selectTime(context, dayIndex),
                child: Text(
                  AppLocalizations.of(context).tr('settings.change'),
                  style: const TextStyle(color: Color(0xFFA0A0A0)),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, int dayIndex) async {
    final currentTime =
        reminderTimes[dayIndex] ?? const TimeOfDay(hour: 9, minute: 0);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      final newReminderTimes = Map<int, TimeOfDay>.from(reminderTimes);
      newReminderTimes[dayIndex] = selectedTime;
      onReminderTimesChanged(newReminderTimes);
    }
  }
}
