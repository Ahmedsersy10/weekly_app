import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:weekly_dash_board/core/util/app_localizations.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);

    // Timezone initialization for zoned scheduling
    try {
      tzdata.initializeTimeZones();
      // Using default local timezone; if platform-specific timezone is needed,
      // add a timezone detection package and set location accordingly.
    } catch (_) {}

    // Request permissions where required - Enhanced for Release mode
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    try {
      // Android permissions
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        // Request notification permission
        final granted = await androidPlugin.requestNotificationsPermission();

        // For Android 13+ (API 33+), also request exact alarm permission
        if (granted == true) {
          await androidPlugin.requestExactAlarmsPermission();
        }

        // Note: Battery optimization requests should be handled by the app
        // as this method may not be available in all versions
      }

      // iOS permissions
      final iosPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: false, // Set to true if critical alerts are needed
      );
    } catch (e) {
      // Handle permission request errors gracefully
      print('Error requesting notification permissions: $e');
    }
  }

  static Future<void> scheduleTaskReminder({
    required int dayOfWeek,
    required TimeOfDay time,
    required String taskTitle,
  }) async {
    // Cancel existing notification for this day
    await _notifications.cancel(dayOfWeek);

    // Calculate next occurrence of this day and time
    final now = DateTime.now();
    final nextOccurrence = _getNextOccurrence(dayOfWeek, time);

    if (nextOccurrence.isAfter(now)) {
      await _notifications.zonedSchedule(
        dayOfWeek,
        'Task Reminder',
        'You have a task scheduled: $taskTitle',
        _getTZDateTime(nextOccurrence, time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminders',
            'Task Reminders',
            channelDescription: 'Notifications for task reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  static DateTime _getNextOccurrence(int dayOfWeek, TimeOfDay time) {
    final now = DateTime.now();
    final today = now.weekday;

    // Convert app day index to Flutter weekday (1 = Monday, 7 = Sunday)
    final appDayToFlutterDay = {
      1: DateTime.saturday, // Saturday
      2: DateTime.sunday, // Sunday
      3: DateTime.monday, // Monday
      4: DateTime.tuesday, // Tuesday
      5: DateTime.wednesday, // Wednesday
      6: DateTime.thursday, // Thursday
      7: DateTime.friday, // Friday
    };

    final flutterDay = appDayToFlutterDay[dayOfWeek] ?? DateTime.monday;

    int daysUntilNext = flutterDay - today;
    if (daysUntilNext <= 0) {
      daysUntilNext += 7;
    }

    return DateTime(
      now.year,
      now.month,
      now.day + daysUntilNext,
      time.hour,
      time.minute,
    );
  }

  static tz.TZDateTime _getTZDateTime(DateTime dateTime, TimeOfDay time) {
    return tz.TZDateTime.from(
      DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        time.hour,
        time.minute,
      ),
      tz.local,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> updateReminderTimes(
    Map<int, TimeOfDay> reminderTimes,
  ) async {
    // Cancel all existing notifications
    await cancelAllNotifications();

    // Schedule new notifications for each day
    for (final entry in reminderTimes.entries) {
      await scheduleTaskReminder(
        dayOfWeek: entry.key,
        time: entry.value,
        taskTitle: 'Weekly Task Reminder',
      );
    }
  }

  static Future<void> scheduleWeeklyReminder({
    required int dayOfWeek,
    required TimeOfDay time,
    required String message,
  }) async {
    final now = DateTime.now();
    final nextOccurrence = _getNextOccurrence(dayOfWeek, time);

    if (nextOccurrence.isAfter(now)) {
      await _notifications.zonedSchedule(
        dayOfWeek + 1000, // Use different ID to avoid conflicts
        'Weekly Reminder',
        message,
        _getTZDateTime(nextOccurrence, time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weekly_reminders',
            'Weekly Reminders',
            channelDescription: 'Weekly task reminders',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  static Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'immediate_notifications',
          'Immediate Notifications',
          channelDescription: 'Immediate task notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  // New methods for individual task notifications
  static Future<void> scheduleTaskNotification({
    required String taskId,
    required int dayOfWeek,
    required TimeOfDay time,
    required String taskTitle,
  }) async {
    try {
      // Cancel existing notification for this task
      await _notifications.cancel(taskId.hashCode);

      // Calculate next occurrence of this day and time
      final now = DateTime.now();
      final nextOccurrence = _getNextOccurrence(dayOfWeek, time);

      if (nextOccurrence.isAfter(now)) {
        await _notifications.zonedSchedule(
          taskId.hashCode,
          'Task Reminder',
          'You have a task scheduled: $taskTitle',
          _getTZDateTime(nextOccurrence, time),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'task_reminders',
              'Task Reminders',
              channelDescription: 'Notifications for individual task reminders',
              importance: Importance.high,
              priority: Priority.high,
              enableVibration: true,
              playSound: true,
              showWhen: true,
              autoCancel: true,
              ongoing: false,
              fullScreenIntent: false,
              category: AndroidNotificationCategory.reminder,
              visibility: NotificationVisibility.private,
              // Enhanced for Release mode reliability
              timeoutAfter: 0, // Don't timeout
              usesChronometer: false,
              when: null,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              sound: 'default',
              badgeNumber: null,
              attachments: null,
              categoryIdentifier: 'TASK_REMINDER',
              threadIdentifier: 'task-reminders',
              interruptionLevel: InterruptionLevel.active,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: taskId,
        );
      }
    } catch (e) {
      // Handle scheduling errors gracefully
      print('Error scheduling task notification: $e');
    }
  }

  static Future<void> cancelTaskNotification(String taskId) async {
    await _notifications.cancel(taskId.hashCode);
  }

  static Future<void> updateTaskNotification({
    required String taskId,
    required int dayOfWeek,
    required TimeOfDay? time,
    required String taskTitle,
  }) async {
    if (time != null) {
      await scheduleTaskNotification(
        taskId: taskId,
        dayOfWeek: dayOfWeek,
        time: time,
        taskTitle: taskTitle,
      );
    } else {
      await cancelTaskNotification(taskId);
    }
  }

  // Method to refresh all notifications when language or timezone changes
  static Future<void> refreshAllNotifications({
    required Map<int, TimeOfDay> reminderTimes,
    required List<Map<String, dynamic>> tasksWithReminders,
  }) async {
    // Cancel all existing notifications
    await cancelAllNotifications();

    // Re-schedule weekly reminders
    for (final entry in reminderTimes.entries) {
      await scheduleTaskReminder(
        dayOfWeek: entry.key,
        time: entry.value,
        taskTitle: 'Weekly Task Reminder',
      );
    }

    // Re-schedule individual task notifications
    for (final taskData in tasksWithReminders) {
      final taskId = taskData['id'] as String;
      final dayOfWeek = taskData['dayOfWeek'] as int;
      final time = taskData['reminderTime'] as TimeOfDay;
      final taskTitle = taskData['title'] as String;

      await scheduleTaskNotification(
        taskId: taskId,
        dayOfWeek: dayOfWeek,
        time: time,
        taskTitle: taskTitle,
      );
    }
  }

  // Method to get localized notification message
  static String getLocalizedTaskReminderMessage(
    String taskTitle,
    BuildContext context,
  ) {
    try {
      return AppLocalizations.of(
        context,
      ).tr('notifications.taskReminder').replaceAll('{taskTitle}', taskTitle);
    } catch (e) {
      // Fallback to English if localization fails
      return 'You have a task scheduled: $taskTitle';
    }
  }

  // Method to handle timezone changes
  static Future<void> handleTimezoneChange() async {
    try {
      // Re-initialize timezone data
      tzdata.initializeTimeZones();

      // Cancel and re-schedule all notifications with new timezone
      // This will be called by the app when timezone changes are detected
      await _notifications.cancelAll();
    } catch (e) {
      // Handle timezone initialization errors gracefully
      print('Error handling timezone change: $e');
    }
  }

  // Method to restore notifications after app restart
  static Future<void> restoreNotificationsAfterRestart({
    required Map<int, TimeOfDay> reminderTimes,
    required List<Map<String, dynamic>> tasksWithReminders,
  }) async {
    try {
      // Re-request permissions to ensure they're still granted
      await _requestPermissions();

      // Restore weekly reminders
      for (final entry in reminderTimes.entries) {
        await scheduleTaskReminder(
          dayOfWeek: entry.key,
          time: entry.value,
          taskTitle: 'Weekly Task Reminder',
        );
      }

      // Restore individual task notifications
      for (final taskData in tasksWithReminders) {
        final taskId = taskData['id'] as String;
        final dayOfWeek = taskData['dayOfWeek'] as int;
        final time = taskData['reminderTime'] as TimeOfDay;
        final taskTitle = taskData['title'] as String;

        await scheduleTaskNotification(
          taskId: taskId,
          dayOfWeek: dayOfWeek,
          time: time,
          taskTitle: taskTitle,
        );
      }
    } catch (e) {
      // Handle restoration errors gracefully
      print('Error restoring notifications after restart: $e');
    }
  }

  // Method to check if notifications are enabled and permissions are granted
  static Future<bool> areNotificationsEnabled() async {
    try {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        final result = await androidPlugin.areNotificationsEnabled();
        return result ?? false;
      }

      // For iOS, assume enabled if no error occurred during initialization
      return true;
    } catch (e) {
      print('Error checking notification status: $e');
      return false;
    }
  }
}
