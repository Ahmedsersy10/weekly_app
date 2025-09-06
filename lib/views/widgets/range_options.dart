// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';

class RangeOptions extends StatelessWidget {
  const RangeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 1, color: Color(0xffF1F1F1)),
        ),
      ),
      child: Row(
        spacing: 12,
        children: [
          Text('Monthly', style: AppStyles.styleMedium16(context)),

          const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: Color(0xFF064061),
            size: 14,
          ),
        ],
      ),
    );
  }
}
