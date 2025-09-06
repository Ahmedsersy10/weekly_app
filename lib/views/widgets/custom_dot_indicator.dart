// Flutter imports:
import 'package:flutter/material.dart';

class CustomDotIndicator extends StatelessWidget {
  const CustomDotIndicator({super.key, required this.isActive});
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: ShapeDecoration(
        color: isActive ? const Color(0xff4db7f2) : const Color(0xffe7e7e7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
      ),
    );
  }
}
