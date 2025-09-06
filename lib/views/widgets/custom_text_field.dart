// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText});
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyles.styleRegular16(
          context,
        ).copyWith(color: const Color(0xffafafaf)),
        filled: true,
        fillColor: const Color(0xfffafafa),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() => OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0xfffafafa)),
    borderRadius: BorderRadius.circular(12),
  );
}
