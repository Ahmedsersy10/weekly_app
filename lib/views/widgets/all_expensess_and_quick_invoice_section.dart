// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/all_expenses.dart';
import 'package:weekly_dash_board/views/widgets/quick_invoice.dart';

class AllExpensessAndQuickInvoiceSection extends StatelessWidget {
  const AllExpensessAndQuickInvoiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [AllExpenses(), SizedBox(height: 24), QuickInvoice()],
      ),
    );
  }
}
