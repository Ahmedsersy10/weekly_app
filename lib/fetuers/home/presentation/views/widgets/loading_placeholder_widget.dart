import 'package:flutter/material.dart';

class LoadingPlaceholderWidget extends StatelessWidget {
  final String message;
  final double height;
  final EdgeInsetsGeometry? padding;

  const LoadingPlaceholderWidget({
    super.key,
    this.message = 'Loading...',
    this.height = 200,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
