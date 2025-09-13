import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';

import 'package:weekly_dash_board/models/drawer_item_model.dart';
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/util/drawer_page.dart';
import 'package:weekly_dash_board/views/widgets/in_active_drawer_item.dart';
import 'package:weekly_dash_board/views/widgets/list_view_drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int index, DrawerPage page)? onItemSelected;

  const CustomDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: AppColors.surface,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Divider(color: AppColors.surface, height: 1, thickness: 1),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              color: AppColors.primary, // Primary color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.dashboard, size: 50, color: AppColors.textOnPrimary),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppLocalizations.of(context).tr('navigation.weekly'),
                        style: const TextStyle(
                          color: AppColors.surface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ListViewDrawerItem(onItemSelected: onItemSelected),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                inActiveDrawerItem(
                  drawerItemModel: DrawerItemModel(
                    title: AppLocalizations.of(context).tr('logout.account'),
                    image: Assets.imagesLogout,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
