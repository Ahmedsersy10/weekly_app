import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';

class CustomTextWeeklyOf extends StatelessWidget {
  const CustomTextWeeklyOf({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );
  }
}
