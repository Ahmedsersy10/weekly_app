// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/all_expenses_header.dart';
import 'package:weekly_dash_board/views/widgets/all_expenses_items_list_view.dart';
import 'package:weekly_dash_board/views/widgets/custom_background_container.dart';

class AllExpenses extends StatelessWidget {
  const AllExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomBackgroundContainer(
      child: Column(
        children: [
          AllExpensesHeader(),
          SizedBox(height: 16),
          AllExpensesItemsListView(),
        ],
      ),
    );
  }
}
