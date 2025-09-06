import 'package:flutter/material.dart' hide ThemeMode;
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/core/models/settings_model.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/views/widgets/settings_section.dart';

class ThemeSettingsSection extends StatelessWidget {
  final ThemeMode themeMode;
  final Color primaryColor;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<Color> onPrimaryColorChanged;

  const ThemeSettingsSection({
    super.key,
    required this.themeMode,
    required this.primaryColor,
    required this.onThemeModeChanged,
    required this.onPrimaryColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SettingsSection(
      title: AppLocalizations.of(context).tr('settings.theme'),
      children: [
        ListTile(
          title: Text(
            AppLocalizations.of(context).tr('settings.themeMode'),
            style: TextStyle(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            _getThemeModeText(context, themeMode),
            style: TextStyle(color: colorScheme.onSurface),
          ),
          leading: Icon(Icons.palette, color: colorScheme.primary),
          trailing: DropdownButton<ThemeMode>(
            value: themeMode,
            onChanged: (ThemeMode? newValue) {
              if (newValue != null) {
                onThemeModeChanged(newValue);
              }
            },
            items: ThemeMode.values.map((ThemeMode mode) {
              return DropdownMenuItem<ThemeMode>(
                value: mode,
                child: Text(
                  _getThemeModeText(context, mode),
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context).tr('settings.primaryColor'),
            style: TextStyle(color: colorScheme.onSurface),
          ),
          subtitle: Text(
            AppLocalizations.of(context).tr('settings.primaryColorSubtitle'),
            style: TextStyle(color: colorScheme.onSurface),
          ),
          leading: Icon(Icons.color_lens, color: colorScheme.primary),
          trailing: GestureDetector(
            onTap: () => _showColorPicker(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.outline, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getThemeModeText(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppLocalizations.of(context).tr('settings.light');
      case ThemeMode.dark:
        return AppLocalizations.of(context).tr('settings.dark');
      case ThemeMode.system:
        return AppLocalizations.of(context).tr('settings.system');
      // ignore: unreachable_switch_default
      default:
        return AppLocalizations.of(context).tr('settings.system');
    }
  }

  void _showColorPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final predefinedColors = [
      const Color(0xFF8E1616), // Maroon
      const Color(0xFF1976D2), // Blue
      const Color(0xFF388E3C), // Green
      const Color(0xFFF57C00), // Orange
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFFD32F2F), // Red
      const Color(0xFF0097A7), // Cyan
      const Color(0xFFFF8F00), // Amber
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).tr('settings.selectPrimaryColor'),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context).tr('settings.predefinedColors'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: predefinedColors.map((color) {
                    final isSelected = color.value == primaryColor.value;
                    return GestureDetector(
                      onTap: () {
                        onPrimaryColorChanged(color);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: isSelected ? 3 : 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).tr('settings.customColor'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showCustomColorPicker(context),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).tr('settings.chooseCustomColor'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).tr('settings.cancel')),
            ),
          ],
        );
      },
    );
  }

  void _showCustomColorPicker(BuildContext context) {
    // For now, we'll use a simple color picker
    // In a production app, you might want to use a more sophisticated color picker
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).tr('settings.customColor')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).tr('settings.customColorNote'),
                style: TextStyle(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              // Simple color picker with predefined options
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int r = 0; r < 8; r++)
                    for (int g = 0; g < 8; g++)
                      for (int b = 0; b < 8; b++)
                        GestureDetector(
                          onTap: () {
                            final color = Color.fromARGB(
                              255,
                              (r * 255 / 7).round(),
                              (g * 255 / 7).round(),
                              (b * 255 / 7).round(),
                            );
                            onPrimaryColorChanged(color);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                255,
                                (r * 255 / 7).round(),
                                (g * 255 / 7).round(),
                                (b * 255 / 7).round(),
                              ),
                              border: Border.all(color: colorScheme.outline),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).tr('settings.cancel')),
            ),
          ],
        );
      },
    );
  }
}
