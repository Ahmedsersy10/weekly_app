import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/constants/app_color.dart';
import 'package:weekly_dash_board/core/utils/app_localizations.dart';
import 'package:weekly_dash_board/core/models/drawer_item_model.dart';
import 'package:weekly_dash_board/core/theme/app_images.dart';
import 'package:weekly_dash_board/core/widgets/drawer_page.dart';
import 'package:weekly_dash_board/views/widgets/in_active_drawer_item.dart';
import 'package:weekly_dash_board/views/widgets/list_view_drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int index, DrawerPage page)? onItemSelected;

  const CustomDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Theme.of(context).colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Divider(
              color: Theme.of(context).colorScheme.surface,
              height: 1,
              thickness: 1,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              color: Theme.of(context).colorScheme.primary, // Primary color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.dashboard,
                      size: 50,
                      color: AppColors.textOnPrimary,
                    ),
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
          SliverToBoxAdapter(
            child: Divider(
              color: Theme.of(context).colorScheme.surface,
              height: 1,
              thickness: 1,
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
