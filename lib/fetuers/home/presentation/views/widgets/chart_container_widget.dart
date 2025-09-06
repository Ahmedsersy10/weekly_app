import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';

class ChartContainerWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const ChartContainerWidget({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}
