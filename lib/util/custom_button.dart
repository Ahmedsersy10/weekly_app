import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.buttonColor, this.textColor, this.text});
  final Color? buttonColor, textColor;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor ?? AppColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
        ),
        onPressed: () {},
        child: Text(
          text ?? 'Send Mony',
          style: AppStyles.styleSemiBold18(
            context,
          ).copyWith(color: textColor ?? AppColors.textOnAccent),
        ),
      ),
    );
  }
}
