// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/all_expensess_and_quick_invoice_section.dart';
import 'package:weekly_dash_board/views/widgets/custom_drawer.dart';
import 'package:weekly_dash_board/views/widgets/income_section.dart';
import 'package:weekly_dash_board/views/widgets/my_card_and_transaction_section.dart';

class DashboardDesktopLayout extends StatelessWidget {
  const DashboardDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: CustomDrawer()),
        SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: AllExpensessAndQuickInvoiceSection(),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            Expanded(child: MyCardAndTransactionSection()),
                            SizedBox(height: 24),
                            Expanded(child: IncomeSection()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
