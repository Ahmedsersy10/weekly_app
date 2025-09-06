import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';

class CustomVerticalDividerWeeklyOf extends StatelessWidget {
  const CustomVerticalDividerWeeklyOf({super.key});

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      indent: 6,
      endIndent: 6,
      width: 20,
      thickness: 1,
      color: AppColors.white,
    );
  }
}
