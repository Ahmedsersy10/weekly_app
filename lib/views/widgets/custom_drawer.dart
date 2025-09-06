// Flutter imports:
import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';

// Project imports:
import 'package:weekly_dash_board/models/drawer_item_model.dart';
// import 'package:weekly_dash_board/models/user_info_model.dart';
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/views/widgets/in_active_drawer_item.dart';
import 'package:weekly_dash_board/views/widgets/list_view_drawer_item.dart';
// import 'package:weekly_dash_board/views/widgets/user_info_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.white,
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(
            //   child: UserInfoListTile(
            //     userInfoModel: UserInfoModel(
            //       image: Assets.imagesAvatar3,
            //       title: 'Ahmed elsersy',
            //       subTitle: 'ahmedelsersy10@gmail.com',
            //     ),
            //   ),
            // ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            const ListViewDrawerItem(),
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
      ),
    );
  }
}
