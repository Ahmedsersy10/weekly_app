// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';

class TransctionHHistoryHeader extends StatelessWidget {
  const TransctionHHistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Transaction History', style: AppStyles.styleSemiBold20(context)),
        Text(
          'See All',
          style: AppStyles.styleMedium16(
            context,
          ).copyWith(color: const Color(0xff4eb7f2)),
        ),
      ],
    );
  }
}
