// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/views/widgets/transction_h_history_header.dart';
import 'package:weekly_dash_board/views/widgets/transction_history_list_view.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TransctionHHistoryHeader(),
        const SizedBox(height: 20),
        Text(
          '13 Aril 2022',
          style: AppStyles.styleMedium16(
            context,
          ).copyWith(color: const Color(0xffaaaaaa)),
        ),
        const SizedBox(height: 16),
        const TransctionHistoryListView(),
      ],
    );
  }
}
