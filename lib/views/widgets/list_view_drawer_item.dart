// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/drawer_item_model.dart';
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/util/size_config.dart';
import 'package:weekly_dash_board/views/widgets/drawer_item.dart';

class ListViewDrawerItem extends StatefulWidget {
  const ListViewDrawerItem({super.key});

  @override
  State<ListViewDrawerItem> createState() => _ListViewDrawerItemState();
}

class _ListViewDrawerItemState extends State<ListViewDrawerItem> {
  int selectedIndex = 0;

  final List<DrawerItemModel> drawerItems = [
    const DrawerItemModel(title: 'navigation.weekly', image: Assets.imagescalendar),
    const DrawerItemModel(title: 'common.Search', image: Assets.imagescalendarSearch),
    const DrawerItemModel(title: 'app.stats', image: Assets.imagesStatistics),
    const DrawerItemModel(title: 'app.more', image: Assets.imagesmore),
    const DrawerItemModel(title: 'app.settings', image: Assets.imagesSettings),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // فلترة على حسب الشاشة
    final filteredItems = drawerItems.where((item) {
      if (screenWidth >= SizeConfig.desktop && item.title == 'State') {
        return false; // متعرضش State في الديسكتوب
      }
      return true;
    }).toList();

    return SliverList.builder(
      itemCount: filteredItems.length,
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
              drawerItemModel: filteredItems[index],
              isSelected: selectedIndex == index,
            ),
          ),
        );
      },
    );
  }
}
