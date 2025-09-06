import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/view_model/settings_cubit.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/views/widgets/settings_section.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/views/widgets/week_settings_section.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/views/widgets/sync_settings_section.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/views/widgets/language_settings_section.dart';
import 'package:weekly_dash_board/core/services/data_backup_service.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context).tr('app.settings'),
            style: AppStyles.styleSemiBold24(
              context,
            ).copyWith(color: colorScheme.onSurface),
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<SettingsCubit>().clearError();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.settings != null) ...[
                  // LoginAndSgininSettingsSection(),
                  // const SizedBox(height: 24),
                  // ThemeSettingsSection(
                  //   themeMode: state.settings!.themeMode,
                  //   primaryColor: state.settings!.primaryColor,
                  //   onThemeModeChanged: (mode) {
                  //     context.read<SettingsCubit>().updateThemeMode(mode);
                  //   },
                  //   onPrimaryColorChanged: (color) {
                  //     context.read<SettingsCubit>().updatePrimaryColor(color);
                  //   },
                  // ),
                  // const SizedBox(height: 24),
                  // NotificationSettingsSection(
                  //   notificationsEnabled: state.settings!.notificationsEnabled,
                  //   reminderTimes: state.settings!.reminderTimes,
                  //   onNotificationsChanged: (enabled) {
                  //     context.read<SettingsCubit>().updateNotificationsEnabled(enabled);
                  //   },
                  //   onReminderTimesChanged: (reminderTimes) {
                  //     // Update all reminder times at once
                  //     for (final entry in reminderTimes.entries) {
                  //       context.read<SettingsCubit>().updateReminderTime(entry.key, entry.value);
                  //     }
                  //   },
                  // ),
                  // const SizedBox(height: 24),
                  WeekSettingsSection(
                    weekStart: state.settings!.weekStart,
                    weekendDays: state.settings!.weekendDays,
                    onWeekStartChanged: (weekStart) {
                      context.read<SettingsCubit>().updateWeekStart(weekStart);
                      context.read<WeeklyCubit>().updateWeekStart(weekStart);
                    },
                    onWeekendDaysChanged: (weekendDays) {
                      context.read<SettingsCubit>().updateWeekendDays(
                        weekendDays,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SyncSettingsSection(
                    syncProvider: state.settings!.syncProvider,
                    autoSync: state.settings!.autoSync,
                    lastBackup: state.settings!.lastBackup,
                    onSyncProviderChanged: (provider) {
                      context.read<SettingsCubit>().updateSyncProvider(
                        provider,
                      );
                    },
                    onAutoSyncChanged: (autoSync) {
                      context.read<SettingsCubit>().updateAutoSync(autoSync);
                    },
                  ),
                  const SizedBox(height: 24),
                  LanguageSettingsSection(
                    language: state.settings!.language,
                    onLanguageChanged: (language) {
                      context.read<SettingsCubit>().updateLanguage(language);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                SettingsSection(
                  title: AppLocalizations.of(
                    context,
                  ).tr('settings.dataManagement'),
                  children: [
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context).tr('settings.backupData'),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(
                          context,
                        ).tr('settings.backupSubtitle'),
                        style: const TextStyle(color: AppColors.black),
                      ),
                      leading: Icon(Icons.backup, color: colorScheme.primary),
                      onTap: () async {
                        await _backupData(context);
                        // ignore: use_build_context_synchronously
                        context.read<SettingsCubit>().loadSettings();
                      },
                    ),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context).tr('settings.restoreData'),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(
                          context,
                        ).tr('settings.restoreSubtitle'),
                        style: const TextStyle(color: AppColors.black),
                      ),
                      leading: Icon(Icons.restore, color: colorScheme.primary),
                      onTap: () async {
                        await _restoreData(context);
                        if (context.mounted) {
                          // Reload tasks and settings
                          context.read<WeeklyCubit>().reloadTasksFromStorage();
                          context.read<SettingsCubit>().loadSettings();
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context).tr('settings.resetApp'),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(
                          context,
                        ).tr('settings.resetSubtitle'),
                        style: const TextStyle(color: AppColors.black),
                      ),
                      leading: Icon(Icons.refresh, color: colorScheme.primary),
                      onTap: () {
                        _showResetConfirmationDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).tr('settings.resetConfirmationTitle'),
          ),
          content: Text(
            AppLocalizations.of(
              context,
            ).tr('settings.resetConfirmationMessage'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).tr('settings.cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<SettingsCubit>().resetToDefaults();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(AppLocalizations.of(context).tr('settings.reset')),
            ),
          ],
        );
      },
    );
  }

  Future<void> _backupData(BuildContext context) async {
    try {
      final file = await DataBackupService.backup();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).trWithParams(
                'settings.backupSuccess',
                {'filename': file.path.split('/').last},
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).trWithParams('settings.backupFailed', {'error': e.toString()}),
            ),
          ),
        );
      }
    }
  }

  Future<void> _restoreData(BuildContext context) async {
    try {
      final success = await DataBackupService.restoreLatest();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Data restored successfully' : 'No backups found',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).trWithParams('settings.restoreFailed', {'error': e.toString()}),
            ),
          ),
        );
      }
    }
  }
}
