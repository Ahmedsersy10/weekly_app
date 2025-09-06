// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';

class QuickInvoiceHeader extends StatelessWidget {
  const QuickInvoiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Quick Invoce', style: AppStyles.styleSemiBold20(context)),
        const Spacer(),
        Container(
          width: 48,
          height: 48,
          decoration: const ShapeDecoration(
            shape: OvalBorder(),
            color: Color(0xfffafafa),
          ),
          child: const Icon(Icons.add, color: Color(0xff4eb7f2)),
        ),
      ],
    );
  }
}
