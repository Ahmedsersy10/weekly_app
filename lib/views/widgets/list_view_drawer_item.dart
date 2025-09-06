// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/drawer_item_model.dart';
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/views/widgets/drawer_item.dart';

class ListViewDrawerItem extends StatefulWidget {
  const ListViewDrawerItem({super.key});

  @override
  State<ListViewDrawerItem> createState() => _ListViewDrawerItemState();
}

class _ListViewDrawerItemState extends State<ListViewDrawerItem> {
  int selectedIndex = 0;

  final List<DrawerItemModel> drawerItems = [
    const DrawerItemModel(title: 'Dashboard', image: Assets.imagesDashboard),
    const DrawerItemModel(
      title: 'My Transaction',
      image: Assets.imagesMyTransctions,
    ),
    const DrawerItemModel(title: 'Statistics', image: Assets.imagesStatistics),
    const DrawerItemModel(
      title: 'Wallet Account',
      image: Assets.imagesWalletAccount,
    ),
    const DrawerItemModel(
      title: 'My Investments',
      image: Assets.imagesMyInvestments,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: drawerItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (selectedIndex != index) {
              setState(() {
                selectedIndex = index;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: DrawerItem(
              drawerItemModel: drawerItems[index],
              isSelected: selectedIndex == index,
            ),
          ),
        );
      },
    );
  }
}
