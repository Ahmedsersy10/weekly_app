import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';

class DialogButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;

  const DialogButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? Colors.red : AppColors.maroon,
          foregroundColor: AppColors.white,
        ),
        child: Text(text),
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isDestructive ? Colors.red : AppColors.maroon,
      ),
      child: Text(text),
    );
  }
}
