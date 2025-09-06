// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/custom_dot_indicator.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({super.key, required this.currentPage});
  final int currentPage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CustomDotIndicator(isActive: index == currentPage),
        ),
      ),
    );
  }
}
