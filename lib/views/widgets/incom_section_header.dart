// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/views/widgets/range_options.dart';

class IncomSectionHeader extends StatelessWidget {
  const IncomSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Icom', style: AppStyles.styleSemiBold20(context)),
        const RangeOptions(),
      ],
    );
  }
}
