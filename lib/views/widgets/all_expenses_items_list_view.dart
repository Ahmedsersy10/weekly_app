// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/all_expenses_Item_model.dart';
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/views/widgets/all_expenses_item.dart';

class AllExpensesItemsListView extends StatefulWidget {
  const AllExpensesItemsListView({super.key});

  @override
  State<AllExpensesItemsListView> createState() =>
      _AllExpensesItemsListViewState();
}

class _AllExpensesItemsListViewState extends State<AllExpensesItemsListView> {
  final items = [
    const AllExpensesItemModel(
      image: Assets.imagesBalance,
      title: 'Balance',
      date: 'April 2022',
      price: r'$20,129',
    ),
    const AllExpensesItemModel(
      image: Assets.imagesIncome,
      title: 'Income',
      date: 'April 2022',
      price: r'$20,129',
    ),
    const AllExpensesItemModel(
      image: Assets.imagesExpenses,
      title: 'Expenses',
      date: 'April 2022',
      price: r'$20,129',
    ),
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      // children: items.map((e) => AllExpensessItem(itemModel: e)).toList(),
      children: items.asMap().entries.map((e) {
        int index = e.key;
        var item = e.value;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              updateIndex(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AllExpensesItem(
                isSelected: selectedIndex == index,
                itemModel: item,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void updateIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
