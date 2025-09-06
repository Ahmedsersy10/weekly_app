import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.maroon, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.styleSemiBold20(
                    context,
                  ).copyWith(color: AppColors.black),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppStyles.styleRegular14(
                      context,
                    ).copyWith(color: AppColors.black.withOpacity(0.7)),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
