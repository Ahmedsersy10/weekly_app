// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/views/widgets/custom_text_field.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({
    super.key,
    required this.title,
    required this.hintText,
  });
  final String title, hintText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.styleMedium16(context)),
        CustomTextField(hintText: hintText),
      ],
    );
  }
}
