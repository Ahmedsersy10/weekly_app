import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';

class ActionButtonWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final bool isFullWidth;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const ActionButtonWidget({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.isFullWidth = false,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidget = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBackgroundColor(),
              foregroundColor: _getForegroundColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBackgroundColor(),
              foregroundColor: _getForegroundColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(text),
          );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: buttonWidget);
    }

    if (width != null) {
      return SizedBox(width: width, child: buttonWidget);
    }

    return buttonWidget;
  }

  Color _getBackgroundColor() {
    if (isDestructive) return Colors.red;
    if (isPrimary) return AppColors.maroon;
    return AppColors.white;
  }

  Color _getForegroundColor() {
    if (isDestructive) return AppColors.white;
    if (isPrimary) return AppColors.white;
    return AppColors.maroon;
  }
}
