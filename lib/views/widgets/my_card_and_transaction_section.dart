// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/custom_background_container.dart';
import 'package:weekly_dash_board/views/widgets/my_card_section.dart';
import 'package:weekly_dash_board/views/widgets/transaction_history.dart';

class MyCardAndTransactionSection extends StatelessWidget {
  const MyCardAndTransactionSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return CustomBackgroundContainer(
      child: const Column(
        children: [
          MyCardsSection(),
          Divider(height: 20, color: Color(0xfff1f1f1)),
          TransactionHistory(),
        ],
      ),
    );
  }
}
