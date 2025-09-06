import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InfoCardWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? Colors.blue.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.blue[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.styleSemiBold16(
                      context,
                    ).copyWith(color: iconColor ?? Colors.blue[600]),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppStyles.styleRegular14(context).copyWith(
                        color: (iconColor ?? Colors.blue[600])?.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
