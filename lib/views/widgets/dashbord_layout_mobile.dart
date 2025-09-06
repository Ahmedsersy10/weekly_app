// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/all_expensess_and_quick_invoice_section.dart';
import 'package:weekly_dash_board/views/widgets/income_section.dart';
import 'package:weekly_dash_board/views/widgets/my_card_and_transaction_section.dart';

class DashbordLayoutMobile extends StatelessWidget {
  const DashbordLayoutMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AllExpensessAndQuickInvoiceSection(),
                SizedBox(height: 24),
                MyCardAndTransactionSection(),
                SizedBox(height: 24),
                Expanded(
                  child: IncomeSection(),
                ), // Uncomment if you want to include the IncomeSection in mobile layout
              ],
            ),
          ),
        ),
      ],
    );
  }
}
